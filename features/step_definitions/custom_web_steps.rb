Given /^an anonymous user$/ do
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

Then /^I should see a link with id "([^\"]*)"$/ do |id|
  page.should have_css("a[id='#{ id }']")
end

Then /^I should see a link to "([^\"]*)"$/ do |url|
  page.should have_css("a[href*='#{ url }']")
end