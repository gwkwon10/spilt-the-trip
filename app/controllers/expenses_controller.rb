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

  def calc_owes
    # go through each expense, find deltas in owes for each liable in the expense
    exArr = Expense.all
    # amount MUST equal sum(amountLiable)
    for (int i=0; i<exArr.length; i++) {
      lbArr = exArr[i].liables # arr of liables in some ex
      amt = exArr[i].amount #current ex cost
      userOwesArr[] = {}
      userOwedArr[] = {}
      total_paid = 0
      total_debt = 0
      users_owed = 0
      users_owing = 0

      for (int j=0; j<lbArr.length; j++) {
        total_paid += lbArr[j].paid
        net = lbArr[j].paid-lbArr[j].amountLiable # +owed money, negative=owes money
        if (net < 0) {
          users_owing++
          userOwesArr.push({j,net})
          
        }
        if (net > 0) {
          users_owed++
          userOwedArr.push({j,net})
          total_debt+=net
        } # if 0, that person is neither owed nor owes
      }
# - ) P _ 0 p
      if (total_paid==amt) { # then, debts can be accurately calculated
        for (int j=0; j<userOwesArr.length; j++) {
          debt_ratio = userOwesArr[j][1]/total_debt #percentage of debt they must pay, which is the percentage per Owed
          for (int k=0; k<userOwedArr.length; k++) {
            amtOwed = debt_ratio*userOwedArr[k][1] # amount that userOwesArr[j] owes userOwedArr[k]
            # if 
            # if lbArr[userOwesArr[j][0]].user_id and lbArr[userOwedArr[k][1]].user_id have an Owe together, O.amountOwed+=amtOwed
            owe = Owe.findby(userOwed_id userOwing_id)
            # else, create an Owe between them and set O.amountOwed = amtOwed
          }
        }
      }
    }
    
  end

end
