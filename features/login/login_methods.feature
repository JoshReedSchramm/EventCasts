Feature: The login page should allow multiple ways to login to EventCasts
	So that a user does not have to create another account on the internet
	As a anonymous user
	I want to see multiple ways to login on the login page
	
	Scenario: The user should see a EventCasts login option
		Given an anonymous user
		When I am on the login page		
		Then I should see "Login with your EventCasts account"
		And I should see the "Username" field
		And I should see the "Password" field
	
	Scenario: The user should see a Twitter login option
		Given an anonymous user
		When I am on the login page		
		Then I should see "Login with your Twitter account"
		And I should see a link with id "twitter_login"
		And I should see a link to "/user/start_twitter"		
