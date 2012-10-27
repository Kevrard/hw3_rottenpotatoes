# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    movies_table.hashes.each do |movie|
      Movie.create!(movie)
    end
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
# on the same page

# Then I should see the following movies: The Incredibles, Raiders of the Lost Ark, When Harry Met Sally, Amelie, The Terminator
Then /^(?:|I )should see the following movies: (.*)/ do |movies|
  movies.split(",").each do |text|
    if page.respond_to? :should
      page.should have_content(text)
      else
      assert page.has_content?(text)
      end
  end
end
  
# And I should not see the following movies: Aladdin, The Help, Chocolat, 2001: A Space Odyssey, Chicken Run
And /^(?:|I )should not see the following movies: (.*)/ do |movies|
  movies.split(",").each do |text|
    if page.respond_to? :should
    page.should have_no_content(text)
    else
    assert page.has_no_content?(text)
    end
  end
end

# Scenario: no ratings selected
#  When I uncheck the following ratings: G, PG, PG-13, R => up
#  Then I press "Refresh" => web step
#  Then I should see no movies
Then /^(?:|I )should see no movies/ do
  page.all('table#movies tbody#selectedmovies tr').count.should == 0
end

# Scenario: all ratings selected
#  When I check the following ratings: G, PG, PG-13, R => up
#  Then I press "Refresh" = web step
#  Then I should see all movies
Then /^(?:|I )should see all movies/ do
  page.all('table#movies tbody#selectedmovies tr').count.should == Movie.all.count
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |x|
  if (uncheck == "un")
    uncheck("ratings_" + x.strip)
  else
    check("ratings_" + x.strip)
  end
  end
end

# Scenario: sort movies alphabetically
#   Given I check the following ratings: G, PG, PG-13, R
#   Then I press "Refresh"
#   Then I follow "Movie Title"  
#   Then I should see movies sorted by title

Then /I should see movies sorted by title/ do
  movies = Movie.order("title asc").collect {|movie| movie.title}.uniq
  movies.each do |movie|
    p movie
  end

  for i in 0..movies.count-1
    if (i < movies.count-2)
      if (false == page.body.index(movies[i]).nil? && false == page.body.index(movies[i+1]).nil?) 
        assert page.body.index(movies[i]) < page.body.index(movies[i+1])
      else 
        assert false
      end
    end
  end
end

# Scenario: sort movies in increasing order of release date
#   Given I check the following ratings: G, PG, PG-13, R
#   Then I press "Refresh"
#   Then I follow "Release Date"  
#   Then I should see movies sorted by release date

Then /I should see movies sorted by release date/ do
  movies = Movie.order("release_date asc").collect {|movie| movie.title}.uniq
  
  movies.each do |movie| 
    p movie
  end

  for i in 0..movies.count-1
    if (i < movies.count-2)
      if (false == page.body.index(movies[i]).nil? && false == page.body.index(movies[i+1]).nil?) 
        assert page.body.index(movies[i]) < page.body.index(movies[i+1])
      else 
        assert false
      end
    end
  end
end
