Feature: An anonymous user can navigate to login from the home page
	So that an existing user can immediately get started with EventCasts
	As an anonymous user
	I want to see a login link on the home page
	
	Scenario: When the user is not logged in show a Login link
		Given an anonymous user
		When I go to the home page
		Then I should see a link to "/user/register" with text "Sign Up"
	
