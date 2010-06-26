Given /^an anonymous user$/ do
end

Given /^a user named "([^\"]*)"$/ do |username|
  Factory.create(username)
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