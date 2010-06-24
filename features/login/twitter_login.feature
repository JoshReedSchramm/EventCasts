@twitter
Feature: The login page should allow a user to login with a Twitter account
	So that a user can manage their data
	As a anonymous user
	I want to be able to login using my Twitter account
	
	Background:
	    Given an associated account type "Twitter"
			
	Scenario: The user can login with their Twitter account
		When I am on the login page		
		And I follow "twitter_login"
		And Twitter authorizes me
		Then I should be on the user home page
	
	Scenario: The user is returned to the login page with a flash message when rejected by Twitter
		When I am on the login page		
		And I follow "twitter_login"
		And Twitter rejects me
		Then I should be on the login page