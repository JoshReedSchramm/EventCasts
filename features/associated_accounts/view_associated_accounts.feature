Feature: The user should be able to see their associated accounts	
	So that a user can manage their associated accounts
	As a registered user
	I want to be able to view details of my associated accounts
	
	Background:
	    Given an associated account type "Twitter"	
	
	Scenario: A user with a twitter account should see twitter in their list of associated accounts
		Given a user named "twitter_user"
		And "eventcasts" is logged in with password "password"		
		When I am on the associated accounts page
		Then I should see "Your Associated Accounts"
		And I should see "Twitter - @EventCasts"
				
	Scenario: A user with an eventcasts account should see EventCasts in their list of accounts
		Given a user named "eventcasts"
		And "eventcasts" is logged in with password "password"		
		When I am on the associated accounts page
		Then I should see "Your Associated Accounts"
		And I should see "EventCasts - eventcasts" within "#EC_account_container"

	Scenario: A user should not see a link to remove an EventCasts account
		Given a user named "eventcasts"
		And "eventcasts" is logged in with password "password"		
		When I am on the associated accounts page
		Then I should not see "(remove)" within "#EC_account_container"

	Scenario: A user should see a link to remove a twitter account
		Given a user named "eventcasts"
		And "eventcasts" is associated to the "TW" account "eventcasts"
		And "eventcasts" is logged in with password "password"		
		When I am on the associated accounts page
		Then I should see "(remove)" within "#TW_account_container"