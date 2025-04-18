class ExpensesController < ApplicationController
  # Get new expenses
  def new
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.new
    @trip_users = @trip.users
  end

  # Add new expenses
  def create
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.new(expense_params)

    if @expense.save
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
      render :new
    end
  end

  def edit
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.find(params[:id])
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

  def expense_params
    params.require(:expense).permit(:desc, :amount, :date, :currency, :category )
  end
end
