class TripsController < ApplicationController
  before_action :require_login
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
  end

  # request for new trip to be added
  def new
    @trip = Trip.new
  end

  # add new trip to the database
  def create
    @trip = Trip.new(trip_params)
    @trip[:ownerid] = current_user.id
    if @trip.save
      Rails.logger.debug("Made trip")
      # create user trip relation for current user
      OnTrip.create(user_id: current_user.id, trip_id: @trip.id)
      Rails.logger.debug("Added current user")
      # find the user for each traveler added to the trip
      if params[:traveler_emails].present?
        Rails.logger.debug("Access emails")
        traveler_emails = params[:traveler_emails].split(",").map(&string)
        traveler_emails.each do |email|
          user = User.find_by(email: email)
          if user
            OnTrip.create(user_id: user.id, trip_id: @trip.id, balance: 0)
          end
          # potentially figure out how to handle if user is not signed up to the application
        end
      end
      redirect_to @trip
    else
      flash.now[:alert] = @trip.errors.full_messages.to_sentence
      render :new
    end
  end

  private
  def trip_params
    params.require(:trip).permit(:name, :startDate, :endDate, :defaultCurrency) #add other parameters
  end
end
