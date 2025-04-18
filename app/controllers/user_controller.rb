class UserController < ApplicationController
  def new
    @user = User.new
  end
  # add user to the database and go to trips
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @owes = []
    overall_owes = Owe.where(trip_id_mirror: -1)
    puts "A"
    overall_owes.each do |owe|
      puts "B"
      if owe.userOwed.id == @user.id || owe.userOwing.id == @user.id
        puts "C"
        puts owe.userOwed.id
        puts owe.userOwing.id
        puts @user.id
        @owes << owe
      end
    end
  end

  def calc_owes
    # reset owe values
    owe_arr = Owe.where(trip_id_mirror: -1)
    owe_arr.each do |owe|
      owe.amountOwed = 0
      owe.save
    end

    # go through each expense, find deltas in owes for each liable in the expense
    ex_arr = Expense.all
    # amount MUST equal sum(amountLiable)
    ex_arr.each do |expense|
      lb_arr = expense.liables # arr of liables in some ex
      # if lb_arr[i].amountLiable > 0, that user is OWED lb_arr[NOT i].amountLiable*-1 by every other lb_arr[NOT i]
      # Step 1: Find which lb_arr[i] is owed $$$
      payingI = -1
      lb_arr.each_with_index do |liable, i|
        if liable.amountLiable > 0 # Then, liable.user_id is the paying user.
          payingI = i
        end
      end

      # Step 2: For all lb_arr[NOT i]:
      lb_arr.each_with_index do |liable, i|
        if i == payingI
          puts payingI
          puts i
          break
        end
        # Step 3: Make/Update an Owe where
        # userOwed = uid2 = lb_arr[i].user_id and userOwing = uid1 = some lb_arr[NOT i].user_id
        uid1 = liable.user_id
        uid2 = lb_arr[payingI].user_id
        # amountOwed = some lb_arr[NOT i].amountLiable*-1, trip_id_mirror = -1
        amtOwed = liable.amountLiable * -1

        if uid1 > uid2 #sort uids, now Owe(uid2,uid1) will never exist, only Owe(uid1,uid2)
          temp = uid2
          uid2 = uid1
          uid1 = temp
          amtOwed *= -1 # delta for 1 to 2 Owe
        end
        
        owe = Owe.find_by(userOwing: uid1, userOwed: uid2, trip_id_mirror: -1)
        
        # else, create an Owe between them and set O.amountOwed = amtOwed
        if owe # if uid1 and uid2 have an Owe together, O.amountOwed+=amtOwed
          owe.amountOwed += amtOwed #if amountOwed negative, Owed owes Owing. If aO +, Owing owes Owed
          owe.save
        else
          Owe.create(userOwing: User.find(uid1),userOwed: User.find(uid2), amountOwed: amtOwed, trip_id_mirror: -1)
        end
      end
      @user
      #amt = expense.amount #current ex cost
      #user_owes_arr = []
      #ser_owed_arr = []
      #total_paid = 0
      #total_debt = 0
      #users_owed = 0
      #users_owing = 0

      #lb_arr.each_with_index do |liable, i|
        #total_paid += liable.paid
        #net = liable.paid-liable.amountLiable # +owed money, negative=owes money
        #if net < 0
          #users_owing += 1
          #user_owes_arr < [i,net]
          
        #end
        #if net > 0
          #users_owed += 1
          #user_owed_arr < [i,net]
          #total_debt+=net
        #end # if 0, that person is neither owed nor owes
      #end

      #if total_paid == amt # then, debts can be accurately calculated
        #user_owes_arr.each do |owes_i, owes_amt|
          #debt_ratio = owes_amt.to_f / total_debt #percentage of debt they must pay, which is the percentage per Owed
          #user_owed_arr.each do |owed_i, owed_amt|
            #uid1 = lb_arr[owes_i].user_id
            #uid2 = lb_arr[owed_i].user_id
            #amtOwed = debt_ratio * owed_amt # amount that user_owes_arr[j] owes user_owed_arr[k]
            #if uid1 > uid2 #sort uids, now Owe(uid2,uid1) will never exist, only Owe(uid1,uid2)
              #temp = uid2
              #uid2 = uid1
              #id1 = temp
              #amtOwed *= -1 # delta for 1 to 2 Owe
            #end
            
            #owe = Owe.findby(userOwing: uid1, userOwed: uid2, trip_id_mirror: -1)
            
            # else, create an Owe between them and set O.amountOwed = amtOwed
            #if owe # if uid1 and uid2 have an Owe together, O.amountOwed+=amtOwed
              #owe.amountOwed += amtOwed #if amountOwed negative, Owed owes Owing. If aO +, Owing owes Owed
              #owe.save
            #else
              #Owe.create(userOwing: uid1,userOwed: uid2, amountOwed: amtOwed, trip_id_mirror: -1)
            #end
          #end
        #end
      #end
    end
  end

  private

  def user_params
    params.require(:user).permit(:displayName, :username, :email, :password, :password_confirmation)
  end
end
