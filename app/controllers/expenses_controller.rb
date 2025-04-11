class ExpensesController < ApplicationController
  # Get new expenses
  def new
    @expense = @trip.expenses.new
  end

  # Add new expenses
  def add
  end


end
