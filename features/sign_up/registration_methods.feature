Feature: The sign up page should allow multiple ways to sign up for EventCasts
	So that a user does not have to create another account on the internet
	As a anonymous user
	I want to see multiple ways to register on the sign up page
	
	Scenario: The user should see a EventCasts sign up option
		Given an anonymous user
		When I am on the sign up page		
		Then I should see "create an EventCasts Acccount"
		And I should see the "Username" field
		And I should see the "Password" field
	
	Scenario: The user should see a Twitter sign up option
		Given an anonymous user
		When I am on the sign up page		
		Then I should see "signing in with your Twitter account"
		And I should see a link to "/user/start_twitter"		
