# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'json'
require 'dotenv'

Dotenv.load('../.env')
API_KEY = ENV['TMDB_API']

url = "https://api.themoviedb.org/3/movie/top_rated?api_key=#{API_KEY}&language=en-US&page=11"
movies_serialized = URI.open(url).read
movies = JSON.parse(movies_serialized)['results']

puts 'Creating movies...'

movies.each do |movie|
  puts "Adding #{movie['original_title']}"
  Movie.create!({
    title: movie['original_title'],
    overview: movie['overview'],
    poster_url: "https://image.tmdb.org/t/p/w500#{movie['poster_path']}",
    rating: movie['vote_average']
  })
end

puts 'Creating lists...'
List.create!(name: 'Favourite')
List.create!(name: 'Classic')
List.create!(name: 'Rewatch')

puts 'Finished!'
