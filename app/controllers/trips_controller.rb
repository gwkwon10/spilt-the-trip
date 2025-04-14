class TripsController < ApplicationController
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
    @travelers = @trip.travelers
  end

  # request for new trip to be added
  def new
    @trip = Trip.new
  end

  # add new trip to the database
  def create
    @trip = Trip.new(trip_params)
    @trip.ownerid = current_user.id
    if @trip.save
      OnTrip.create(user_id: current_user.id, trip_id: @trip.id)
      if params[:traveler_emails].present?
        traveler_emails = params[:traveler_emails].spilt(",").map(&string)
        users = User.where(email: traveler_emails)
        users.each do |user|
          OnTrip.create(user_id: user.id, trip_id: @trip.id)
        end
      end
      redirect_to @trip, notice: "Trip created sucessfully!"
    else
      render :new
    end
  end

  private
  def trip_params
    params.require(:trip).permit(:name, :startDate, :endDate, :defaultCurrency) #add other parameters
  end
end
