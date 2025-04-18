class TripsController < ApplicationController
  before_action :require_login
  before_action :authorize_access_trip, only: [:show, :edit, :update, :create, :destroy]
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
    @owe = Owe.where(trip_id_mirror: @trip.id)
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

  def convert_currency(amount, from, to)
    conversion_rates = {
    "USD" => { "EUR" => 0.88, "JPY" => 142, "USD" => 1 },
    "EUR" => { "USD" => 1.14, "JPY" => 162, "EUR" => 1 },
    "JPY" => { "USD" => 0.0070, "EUR" => 0.0062, "JPY" => 1 } }
    if from == to
      amount
    else
      amount * conversion_rates[from][to]
    end
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

  def authorize_access_trip
    @trip = Trip.find_by(id: params[:id])
    unless @trip.present? && @trip.users.include?(current_user)
      flash[:alert] = "Cannot access trip you are not apart of"
      redirect_to trips_path
    end
  end

  def trip_params
    params.require(:trip).permit(:name, :startDate, :endDate, :defaultCurrency) # add other parameters
  end

  def calc_ows_in_trip
    owe_arr = Owe.where(trip_id_mirror: @trip.id)
    owe_arr.each do |owe|
      owe.delete
      owe.save
    end

    @expenses.each do |expense|
      paid = expense.liables.select { |user| user.amountLiable > 0 }
      owes = expense.liables.select { |user| user.amountLiable < 0 }

      paid.each do |payer|
        owes.each do |ower|
          create = false
          amount = convert_currency(ower.amountLiable.abs, expense.currency, @trip.defaultCurrency)
          other_way = Owe.find_by(userOwing: payer.user, userOwed: ower.user, trip_id_mirror: @trip.id)
          if other_way.present?
            if other_way.amountOwed > amount
              other_way.amountOwed -= amount
              other_way.save!
            elsif other_way.amountOwed < amount
              amount -= other_way.amountOwed
              other_way.delete
              other_way.save
              create = true
            else
              other_way.delete
              other_way.save
            end
          else
            create = true
          end
          if create
            exist = Owe.find_by(userOwing: ower.user, userOwed: payer.user, trip_id_mirror: @trip.id)
            if exist.present?
              exist.amountOwed += amount
              exist.save!
            else
              owe = Owe.new(userOwing: ower.user, userOwed: payer.user, amountOwed: amount, trip_id_mirror: @trip.id)
              owe.save!
            end
          end
        end
      end
    end
  end

  def calc_total_spent
    @trip.on_trips.each do |onT|
      puts "A"
      puts onT.balance
      onT.balance = 0
      onT.save
    end
    # Find the total amount a user is liable for in a specific trip
    exArr = @trip.expenses
    exArr.each do |expense|
      rcmdAmt = convert_currency(expense.amount / expense.liables.count, expense.currency, "USD")
      puts rcmdAmt
      expense.liables.each do |liable|
        on_trip_record = OnTrip.find_by(user_id: liable.user_id, trip_id: @trip.id)
        if on_trip_record
          on_trip_record.update(balance: on_trip_record.balance + rcmdAmt)  # Update balance for the user
        else
          # If the on_trip record doesn't exist, create it with the balance
          OnTrip.create(user_id: liable.user_id, trip_id: @trip.id, balance: rcmdAmt)
        end
      end
    end
    #total = Liable.joins(:expense).where(user_id: user.id).where(expenses: { trip_id: @trip.id }).sum("ABS(amountLiable)")

    
  end
end
