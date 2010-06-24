Feature: The user should be able to associate multiple accounts	
	So that a user can use EventCasts data on multiple sites
	As a registered user
	I want to be able to associate my account with another account
	
	Background:
	    Given an associated account type "Twitter"		
	
	Scenario: A user can navigate to the associate a new account dialog
		Given a user named "eventcasts"
		And "eventcasts" is logged in
		When I am on the associated accounts page
		And I follow "Associate a new account"
		Then I should see "Please choose an account type to associate"
		And I should see a link with id "associate_TW"
