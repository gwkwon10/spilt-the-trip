class ExpensesController < ApplicationController
  # Get new expenses
  def new
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.new
  end

  # Add new expenses
  def create
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.new(expense_params)
    if @expense.save
      @trip.recalulate_expenses # need to make method in Model to recalculate
      redirect_to trip_path(@trip), notice: "Expense added successfully!"
    else
      render :new
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:description, :amount, :date, :traveler_id, traveler_ids: [])
  end

end
