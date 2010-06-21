Feature: The login page should allow a user to login with an Twitter account
	So that a user can manage their data
	As a anonymous user
	I want to be able to login using my Twitter account
	
	Scenario: The user can login with their Twitter account
		Given an anonymous user
		When I am on the login page		
		Then I should see "Login with your EventCasts account"
		And I should see the "Username" field
		And I should see the "Password" field