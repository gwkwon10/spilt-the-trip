class ExpensesController < ApplicationController
  before_action :authorize_access_trip, only: [:new, :edit, :update, :create, :destroy]
  @category
  # Get new expenses
  def new
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.new
    @trip_users = @trip.users
    @expense.currency = @trip.defaultCurrency
  end

  # Add new expenses
  def create
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.new(expense_params)
    user_ids = params[:expense][:user_ids].reject(&:blank?).map(&:to_i)# This is an array of user IDs

    if user_ids.include?(params[:expense][:traveler_id].to_i)
      flash[:alert] = "The person who paid cannot also be involved in paying back"
      render :new
      return
    end

    if @expense.save
      user_ids = params[:expense][:user_ids]
      num_un = user_ids.length
      mliable = @expense.amount / num_un

      user_ids.each do |user_id|
        next if user_id.blank?
        user = User.find(user_id) # find by ID
        Liable.create(user_id: user.id, amountLiable: -mliable, expense_id: @expense.id)
      end
      Liable.create(user_id: params[:expense][:traveler_id], amountLiable: mliable, expense_id: @expense.id)
      redirect_to trip_path(@trip), notice: "Expense added successfully!"
    else
      flash.now[:alert] = @expense.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.find(params[:id])
    @category = @expense.category
    @expense.traveler_id = @expense.liables.find{|l| l.amountLiable > 0}&.user_id
    @participant_ids = @expense.liables.find{|l| l.amountLiable < 0}&.user_id
  end

  def update
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.find(params[:id])
    user_ids = params[:expense][:user_ids].reject(&:blank?).map(&:to_i)# This is an array of user IDs

    if user_ids.include?(params[:expense][:traveler_id].to_i)
      flash[:alert] = "The person who paid cannot also be involved in paying back"
      @trip = Trip.find(params[:trip_id])
      @expense = @trip.expenses.find(params[:id])
      @expense.category = @category
      @expense.traveler_id = @expense.liables.find{|l| l.amountLiable > 0}&.user_id
      @participant_ids = @expense.liables.find{|l| l.amountLiable < 0}&.user_id
      render :new
      return
    end

    if @expense.update(expense_params)
      # Destory all liables associated with old expense and recreate
      @expense.liables.destroy_all
      user_ids = params[:expense][:user_ids] # This is an array of user IDs
      num_un = user_ids.length
      mliable = @expense.amount / num_un

      user_ids.each do |user_id|
        next if user_id.blank?
        user = User.find(user_id) # find by ID
        Liable.create(user_id: user.id, amountLiable: -mliable, expense_id: @expense.id)
      end
      Liable.create(user_id: params[:expense][:traveler_id], amountLiable: mliable, expense_id: @expense.id)
      redirect_to trip_path(@trip), notice: "Expense added successfully!"
    else
      flash.now[:alert] = @expense.errors.full_messages.to_sentence
      @trip = Trip.find(params[:trip_id])
      @expense = @trip.expenses.find(params[:id])
      @expense.traveler_id = @expense.liables.find{|l| l.amountLiable > 0}&.user_id
      @participant_ids = @expense.liables.find{|l| l.amountLiable < 0}&.user_id
      render :edit
    end
  end

  def destroy
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.find(params[:id])
    @expense.destroy
    redirect_to trip_path(@trip), notice: "Expense added successfully!"
  end

  private

  def authorize_access_trip
    @trip = Trip.find_by(id: params[:trip_id])
    unless @trip.present? && @trip.users.include?(current_user)
      flash[:alert] = "Cannot access expense you are not apart of"
      redirect_to trips_path
    end
  end

  def expense_params
    params.require(:expense).permit(:desc, :amount, :date, :currency, :category)
  end
end
