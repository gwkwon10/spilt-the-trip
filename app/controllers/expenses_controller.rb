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
    @expense = Expense.find(params[:id])
    @expense.destroy
    redirect_to trip_path(@trip), notice: "Expense added successfully!"
  end

  private

  def expense_params
    params.require(:expense).permit(:desc, :amount, :date, :currency, :category )
  end

  def calc_owes
    # reset owe values
    owe_arr = Owe.where(trip_id_mirror == -1)
    owe_arr.each do |owe|
      owe.amountOwed = 0
      owe.save
    end

    # go through each expense, find deltas in owes for each liable in the expense
    ex_arr = Expense.all
    # amount MUST equal sum(amountLiable)
    ex_arr.each do |expense|
      lb_arr = expense.liables # arr of liables in some ex
      amt = expense.amount #current ex cost
      user_owes_arr = []
      user_owed_arr = []
      total_paid = 0
      total_debt = 0
      users_owed = 0
      users_owing = 0

      lb_arr.each_with_index do |liable, i|
        total_paid += liable.paid
        net = liable.paid-liable.amountLiable # +owed money, negative=owes money
        if net < 0
          users_owing += 1
          user_owes_arr < [i,net]
          
        end
        if net > 0
          users_owed += 1
          user_owed_arr < [i,net]
          total_debt+=net
        end # if 0, that person is neither owed nor owes
      end

      if total_paid == amt # then, debts can be accurately calculated
        user_owes_arr.each do |owes_i, owes_amt|
          debt_ratio = owes_amt.to_f / total_debt #percentage of debt they must pay, which is the percentage per Owed
          user_owed_arr.each do |owed_i, owed_amt|
            uid1 = lb_arr[owes_i].user_id
            uid2 = lb_arr[owed_i].user_id
            amtOwed = debt_ratio * owed_amt # amount that user_owes_arr[j] owes user_owed_arr[k]
            if uid1 > uid2 #sort uids, now Owe(uid2,uid1) will never exist, only Owe(uid1,uid2)
              temp = uid2
              uid2 = uid1
              uid1 = temp
              amtOwed *= -1 # delta for 1 to 2 Owe
            end
            
            owe = Owe.findby(userOwing: uid1, userOwed: uid2, trip_id_mirror: -1)
            
            # else, create an Owe between them and set O.amountOwed = amtOwed
            if owe # if uid1 and uid2 have an Owe together, O.amountOwed+=amtOwed
              owe.amountOwed += amtOwed #if amountOwed negative, Owed owes Owing. If aO +, Owing owes Owed
              owe.save
            else
              Owe.create(userOwing: uid1,userOwed: uid2, amountOwed: amtOwed, trip_id_mirror: -1)
            end
          end
        end
      end
    end
  end

end
