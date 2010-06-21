Given /^an anonymous user$/ do
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