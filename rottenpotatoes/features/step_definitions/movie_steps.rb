# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
   expect(/#{e1}.*#{e2}/m).to match(page.body)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  if uncheck
    # uncheck all the boxes whose values are in rating_list
    rating_list.split(',').each do |rating|
      #p r.gsub(" ", "")
      find("#ratings_#{rating.gsub(' ', '')}").set(false)
    end
  else
    rating_list.split(',').each do |rating|
      page.check("ratings[#{rating.gsub(' ', '')}]")
    end
  end
  # require 'pry'
  # binding.pry

  # steps( %Q(
  #   Then I visit "/movies"
  #     And I enter "#{user}" in the "user name" field
  #     And I enter "#{user}-test-passwd" in the "password" field
  #     And I press the "login" button
  # ) )


end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.pluck(:title).each do |title|
    expect(page).to have_content(title)
  end
end
