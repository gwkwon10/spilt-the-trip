# Project6-Group3: Spilt the Bill

## Set Up
1. Download and set up Ruby on Rails 
2. Get all the gem files for the project through running "bundle install"
3. Run server through "rails server" to get the host

## Features of Web Application

### Authentication
- Sign up as a user
- If already a user, log into the application

## Trips
- Click on "View Your Trips" to see all the trips the user participates in
- Click on "Create a Trip" to start a new trip
    - Add the description, start/end date, default currency, and participants of the trip
    - The participants of the trip need to be current users
- Edit or Delete a Trip with the button
- On the specific trip page, user is able to see the details of the specific trip such as dates, participants, expenses, etc

## Expenses
- User is able to see the total trip balance and how much each user spent on the trip in the specific trip page
- User is able to see all the expenses associated with the trip, along with the details of each expense such as amount, who paid, etc
- How much each participants owe each other is on the trip page as well, showing how to spilt all the expense for the trip
- Edit or Delete an Expense with each button

## Profile
- View user info, who owes you money, and who you owe money to
- The Administrator with username "admin1" can trigger these Owe calculations on their profile page