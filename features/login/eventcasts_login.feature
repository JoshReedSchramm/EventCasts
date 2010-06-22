Feature: The login page should allow a user to login with an EventCasts account
	So that a user can manage their data
	As a anonymous user
	I want to be able to login using my EventCasts account
	
	Scenario: The user can login with their EventCasts account
		Given a user named "eventcasts"
		When I am on the login page		
		And I fill in "Username" with "eventcasts"
		And I fill in "Password" with "password"
		And I press "Login"
		Then I should be on the user home page