Feature: The user should be able to remove associated accounts
	So that a user can prevent EventCasts from continuing to use their accounts
	As a registered user
	I want to be able to disassociate my account from another account
	
	Background:
	    Given an associated account type "Twitter"	
	
	@testing
	Scenario: A user with a twitter account can disassociate that twitter account
		Given a logged in user named "eventcasts/password" with "TW" account "EventCasts"
		When I am on the associated accounts page
		And I follow the "remove twitter account" link
		Then I should be on the associated accounts page
		And I should see "Associated Accounts (0)"
