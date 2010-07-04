Given /^an anonymous user$/ do
end

Given /^a logged in user named "([^"]*)"(?: with "([^"]*)" account "([^"]*)")?$/ do |userNameAndPassword, account_type, account_name| 
  credentials = userNameAndPassword.split('/')
  Factory.create('eventcasts', {:ec_username=>credentials[0], :password=>credentials[1]})  
  visit path_to("the login page")
  fill_in("Username", :with => credentials[0])
  fill_in("Password", :with => credentials[1])    
  click_button("Login")        
  if !account_type.nil?
    user = User.find_by_ec_username(credentials[0])
    account_type = AssociatedAccountType.find_by_abbreviation(account_type)
    Factory.create(:associated_account, :username=>account_name, :user_id=>user.id, :associated_account_type_id=>account_type.id)  
  end
end

Given /^a user named "([^\"]*)"$/ do |username|
  Factory.create(username)
end

Given /^"([^\"]*)" is associated to the "([^\"]*)" account "([^\"]*)"$/ do |username, account_type, account_name|
  user = User.find_by_ec_username(username)
  account_type = AssociatedAccountType.find_by_abbreviation(account_type)
  Factory.create(:associated_account, :username=>account_name, :user_id=>user.id, :associated_account_type_id=>account_type.id)
end

Given /^an associated account type "([^\"]*)"$/ do |type|
  Factory.create(type)
end


Given /^"([^\"]*)" is logged in with password "([^\"]*)"$/ do |username, password|
    visit path_to("the login page")
    fill_in("Username", :with => username)
    fill_in("Password", :with => password)    
    click_button("Login")    
end

Then /^I should see a link to "([^\"]*)" with text "([^\"]*)"$/ do |url, text|
  within(:css, "a[href='#{ url }']") do 
    page.should have_content(text)
  end
end

Then /^I should see a link to "([^\"]*)"$/ do |url|
  page.should have_css("a[href*='#{ url }']")
end

Then /^I should see the "([^\"]*)" link$/ do |link_name|
  id = link_names(link_name)
  page.should have_css("a[id='#{ id }']")
end

Then /^I should not see the "([^\"]*)" link$/ do |link_name|
  id = link_names(link_name)
  page.should_not have_css("a[id='#{ id }']")
end

When /^(?:|I )follow the "([^"]*)" link$/ do |link_name|
  id = link_names(link_name)
  click_link(id)
end

