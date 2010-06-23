Feature: The sign up page should allow a user to sign up for an EventCasts account
	So that a user can access member only features of EventCasts
	As a anonymous user
	I want to be able to sign up for an EventCasts account
	
	Scenario: The user can sign up for an EventCasts account
		Given an anonymous user
		When I am on the sign up page		
		And I fill in "Username" with "sign_up_test"
		And I fill in "Password" with "password"
		And I press "Create User"
		Then I should be on the user home page
	
	Scenario: The username should be required when signing up for an EventCasts account
		Given an anonymous user
		When I am on the sign up page		
		And I fill in "Password" with "password"
		And I press "Create User"
		Then I should be on the sign up page
		And I should see "username can't be blank"
	
	Scenario: The password should be required when signing up for an EventCasts account
		Given an anonymous user
		When I am on the sign up page		
		And I fill in "Username" with "sign_up_test"		
		And I press "Create User"
		Then I should be on the sign up page
		And I should see "Password can't be blank"
	
	Scenario: The username must be unique when signing up for an EventCasts account
		Given a user named "eventcasts"
		When I am on the sign up page		
		And I fill in "Username" with "eventcasts"		
		And I fill in "Password" with "password"		
		And I press "Create User"
		Then I should be on the sign up page
		And I should see "username has already been taken"