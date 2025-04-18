class TripsController < ApplicationController
  before_action :require_login
  # main index page with all the trips of the user
  def index
    if session[:user_id]
      @trips = current_user.trips
    else
      redirect_to login_path, alert: "Please log in first"
    end
  end

  # Show specific trip page
  def show
    @trip = Trip.find(params[:id])
    @expenses = @trip.expenses
    @travelers = @trip.users
    calc_ows_in_trip
    calc_total_spent
    @owe = Owe.all
  end

  # request for new trip to be added
  def new
    @trip = Trip.new
    @users = User.where.not(id: current_user.id)
  end

  # add new trip to the database
  def create
    @trip = Trip.new(trip_params)
    @trip.ownerid = current_user.id
    if @trip.save
      # create user trip relation for current user
      OnTrip.create(user_id: current_user.id, trip_id: @trip.id, balance: 0)
      if params[:participant_ids].present?
        params[:participant_ids].each do |user_id|
          OnTrip.create(user_id: user_id, trip_id: @trip.id, balance: 0)
        end
      end
      redirect_to @trip
    else
    flash.now[:alert] = @trip.errors.full_messages.to_sentence
    @users = User.where.not(id: current_user.id) # repopulate for render :new
    render :new
    end
  end

  def update_default_currency
    @trip = Trip.find(params[:id])
    @trip.update(defaultCurrency: params[:trip][:defaultCurrency])
    redirect_to @trip
  end

  def edit
    @trip = Trip.find(params[:id])
    existing_users = @trip.users
    @users = User.where.not(id: existing_users.pluck(:id))
  end
  def update
    @trip = Trip.find(params[:id])
    if @trip.update(trip_params)
      if params[:participant_ids].present?
        params[:participant_ids].each do |user_id|
          OnTrip.create(user_id: user_id, trip_id: @trip.id, balance: 0)
        end
      end
      redirect_to trips_path, notice: "Edited Trip"
    else
      flash.now[:alert] = @trip.errors.full_messages.to_sentence
      existing_users = @trip.users
      @users = User.where.not(id: existing_users.pluck(:id))
      render :edit
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    redirect_to trips_path
  end

  private
  def trip_params
    params.require(:trip).permit(:name, :startDate, :endDate, :defaultCurrency) # add other parameters
  end

  def calc_ows_in_trip
    owe_arr = Owe.where(trip_id_mirror: @trip.id)
    owe_arr.each do |owe|
      owe.amountOwed = 0
      owe.save
    end

    @expenses.each do |expense|
      paid = expense.liables.select { |user| user.amountLiable > 0 }
      owes = expense.liables.select { |user| user.amountLiable < 0 }

      paid.each do |payer|
        owes.each do |ower|
          create = false
          amount = ower.amountLiable.abs
          other_way = Owe.find_by(userOwing: payer.user, userOwed: ower.user)
          if other_way
            if other_way.amountOwed > amount
              other_way.amountOwed -= amount
              other_way.save!
            elsif other_way.amountOwed < amount
              amount -= other_way.amountOwed
              other_way.destroy
              create = true
            else
              other_way.destroy
            end
          else
            create = true
          end
          if create
            owe = Owe.new(userOwing: ower.user, userOwed: payer.user, amountOwed: amount, trip_id_mirror: @trip.id)
            owe.save!
          end
        end
      end
    end
  end

  def calc_total_spent
    @travelers.each do |user|
      # Find the total amount a user is liable for in a specific trip
      total = Liable.joins(:expense).where(user_id: user.id).where(expenses: { trip_id: @trip.id }).sum("ABS(amountLiable)")

      on_trip_record = OnTrip.find_by(user_id: user.id, trip_id: @trip.id)
      if on_trip_record
        on_trip_record.update(balance: total)  # Update balance for the user
      else
        # If the on_trip record doesn't exist, create it with the balance
        OnTrip.create(user_id: user.id, trip_id: @trip.id, balance: total_spent)
      end
    end
  end
end
