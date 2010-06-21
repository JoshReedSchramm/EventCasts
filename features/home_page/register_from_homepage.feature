Feature: An anonymous user can navigate to registration from the home page
	So that a user can immediately get started with EventCasts
	As an anonymous user
	I want to see a sign up link on the home page
	
	Scenario: When the user is not logged in show a Sign Up link
		Given an anonymous user
		When I go to the home page
		Then I should see a link to "/user/register" with text "Sign Up"
	
	Scenario: Clicking on the Sign Up links takes the user to the registration page
		Given an anonymous user
		When I go to the home page
		And I follow "Sign Up"
		Then I should be on the sign up page
	
	