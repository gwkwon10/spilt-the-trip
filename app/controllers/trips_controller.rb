class TripsController < ApplicationController
  # main index page with all the trips of the user
  def index
    @trips = Trip.all
  end

  # Show specific trip page
  def show
    @trip = Trip.find(params[:id])
    @expenses = @trip.expenses
    @travelers = @trip.on_trip
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
      redirect_to @trip, notice: "Trip created sucessfully!"
    else
      render :new
    end
  end

  private
  def trip_params
    params.require(:trip).permit(:startDate, :endDate, :name, :defaultCurrency) #add other parameters
  end
end
