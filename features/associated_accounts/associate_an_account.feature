@testing
Feature: The user should be able to associate multiple accounts	
	So that a user can use EventCasts data on multiple sites
	As a registered user
	I want to be able to associate my account with another account
	
	Background:
	    Given an associated account type "Twitter"	

	Scenario: A user with no twitter account can see an option to add a twitter account
		Given a user named "eventcasts"
		And "eventcasts" is logged in with password "password"
		When I am on the associated accounts page
		And I follow "Associate a new account"
		Then I should see "Please choose an account type to associate"
		And I should see a link with id "show_associate_TW"
		
	Scenario: A user with no eventcasts account can see an option to add a twitter account
		Given twitter authorizes me
		When I am on the associated accounts page
		And I follow "Associate a new account"
		Then I should see "Please choose an account type to associate"
		And I should see a link with id "show_associate_EC"

	@javascript	
	Scenario: The various account add forms should be hidden from the user on page load
		Given a user named "eventcasts"
		And "eventcasts" is logged in with password "password"
		When I am on the associated accounts page
		Then I should not see "Click the link below to associate your twitter account"

	@javascript	
	Scenario: The user should see a link to twitter when they choose to add a twitter account
		Given a user named "eventcasts"
		And "eventcasts" is logged in with password "password"
		When I am on the associated accounts page
		And I follow "Associate a new account"
		And I follow "show_associate_TW"
		Then I should see "Click the link below to associate your twitter account"
		