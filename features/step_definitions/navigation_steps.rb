Given /^(?:a|the) user visits the (.*) page$/ do |page_name|
  step "the user attempts to visit the #{page_name} page"
  step "the page should be shown without error"
end

Given /^the (.*) page is shown/ do |page_name|
  step "the #{page_name} page should be shown"
end

When /^the user attempts to visit the (.*) page$/ do |page_name|
  @current_page = find_page(page_name)
  @current_page.visit
end

When /^the user navigates back$/ do
  @current_page.back
end

Then /^the (.*) page should be shown$/ do |page_name|
  @current_page = find_page(page_name)
  step "the page should be shown without error"
end

Then /^the page should be shown without error$/ do
  @current_page.should be_shown_without_error
end

When /^the user refreshes the page$/ do
  @current_page.refresh
end
