Feature: The user should be able to associate multiple accounts	
	So that a user can use EventCasts data on multiple sites
	As a registered user
	I want to be able to associate my account with another account
	
	Background:
	    Given an associated account type "Twitter"	
	
	Scenario: A user with every associated account type should not see a link to associate a new account
		Given a logged in user named "eventcasts/password" with "TW" account "EventCasts"
		When I am on the associated accounts page
		Then I should not see the "Associate a new account" link

	Scenario: A user with no twitter account can see an option to add a twitter account
		Given a logged in user named "eventcasts/password"
		When I am on the associated accounts page
		And I follow the "Associate a new account" link
		Then I should see the "Add a twitter account" link		

	Scenario: A user with no eventcasts account can see an option to add a twitter account
		Given twitter authorizes me
		When I am on the associated accounts page
		And I follow the "Associate a new account" link
		Then I should see the "Add a eventcasts account" link		

	@javascript	
	Scenario: The various account add forms should be hidden from the user on page load
		Given a logged in user named "eventcasts/password" 
		When I am on the associated accounts page
		Then I should not see "Click the link below to associate your twitter account"

	@javascript	
	Scenario: The user should see a link to twitter when they choose to add a twitter account
		Given a logged in user named "eventcasts/password" 
		When I am on the associated accounts page
		And I follow the "Associate a new account" link
		And I follow the "Add a twitter account" link		
		Then I should see the "register with twitter" link

	@javascript
	Scenario: The user should be able to associate a twitter account
		Given a logged in user named "eventcasts/password" 
		When I am on the associated accounts page
		And I follow the "Associate a new account" link
		And I follow the "Add a twitter account" link		
		And I follow the "register with twitter" link
		And Twitter authorizes me
		Then I should be on the user home page
		And I should see "Associated Accounts (1)"
		
	@javascript
	Scenario: The user should see a form to register for eventcasts when they choose to add an eventcasts account
		Given Twitter authorizes me
		When I am on the associated accounts page
		And I follow "Associate a new account"
		And I follow "show_associate_EC"
		Then I should see "Enter a username and password to create an EventCasts account"
		And I should see the "Username" field
		And I should see the "Password" field

	@javascript
	Scenario: The user should be able to associate an EventCasts account
		Given Twitter authorizes me
		When I am on the associated accounts page
		And I follow "Associate a new account"
		And I follow "show_associate_EC"
		And I fill in "Username" with "eventcasts"
		And I fill in "Password" with "password"
		And I press "Create User"
		Then I should be on the associated accounts page
		And I should see "EventCasts - eventcasts" within "#EC_account_container"
