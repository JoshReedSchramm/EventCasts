@twitter
Feature: The sign up page should allow a user to sign up with a Twitter account
	So that a user can access member only features of EventCasts
	And a user does not need another account on the internet
	As a anonymous user
	I want to be able to sign up for EventCasts using my Twitter account
	
	Background:
	    Given an associated account type "Twitter"	
			
	Scenario: The user can sign up with their Twitter account
		When I am on the sign up page		
		And I follow "twitter_sign_up"
		And Twitter authorizes me
		Then I should be on the user home page
	
	Scenario: The user is returned to the login page when rejected by Twitter
		When I am on the sign up page		
		And I follow "twitter_sign_up"
		And Twitter rejects me
		Then I should be on the sign up page