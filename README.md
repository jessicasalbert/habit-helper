### Flatiron School: Module 1 Final Project
### Created by Madeline Stalter & Jessica Salbert

### Purpose
- Habit Helper is a CLI application that encourages healthier living through the implementation of good habits. Habit Helper offers users fun ways to be active within their community and create meal plans in line with their fitness goals (i.e., lose weight or build muscle). 

### Installation Instructions 
1. Clone down to your local machine
2. Run bundle install
3. Run ruby bin/run.rb
4. Have fun! 

### Functionalities
1. Users can either log in or sign up to use the application.
2. If this is a user's first time using the applicaiton, they will sign up by creating a username and password as well as inputting their name, fitness goal (lose weight or build muscle), height (in inches), weight (in pounds), and fitness level (sedentary, moderate, active).
3. To log in, a user will enter their username and password. 
4. Once signed in, the user can look at the main menu and select and view: 
     - Their profile (containing their current height, weight, fitness   goal, fitness level, and health points. Everything, besides health points, can be modified by the user by selecting "Edit profile." Health points are updated by the application automatically when the user completes an activity (exercise or food related). For each activity, the user's health points are incremented by 1).
     - Their activity log (i.e., activities they've completed).
     - Available activities (i.e., activity suggestions they have yet to complete. A user can then select an activity and mark it as complete if they've completed it). 
     - A user feed (i.e., the activities that other users have completed). 

### Additional Functionality
1. Located on the main menu is an option to view activities from a user's Strava account. 
     - We've authenticated Strava within this applicaiton and, in the future, intend to allow users to enter their own activities on Strava, access those activities from this application, and earn points based upon completion. This allows our users to have many options to pick exercises and meals beyond our suggestions that work best for them.
     - IMPORTANT NOTE:
          - To view activites on Strava, a user will select "View Strava" from the main menu and then be prompted to follow a specified URL to authorize Habit Helper within their Strava account (i.e., allow Habit Helper to have access to their Strava data).
          - The user will then be redirected to a web page that says "this site can't be reached." DON'T PANIC!!! This is exactly what we want. From that web page, the user will receive an access code from a specific portion of the "unreachable" site's URL.
          - For example, if we were directed to a site with this URL: http://localhost/exchange_token?state=&code=1a2b3c4d5e6f1a2b3c4d5e6f&scope=read,activity:read_all , we would copy the portion of the URL after the code= and before &scope= (i.e., 1a2b3c4d5e6f1a2b3c4d5e6f). 
          - Once the user has copied the specified portion of the URL, they will paste it into their terminal. 

### API
1. Strava: http://developers.strava.com/


