# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Genre.create([
  {name: '和食'},
  {name: '洋食'},
  {name: '中華'}
])

Recipe.create([
  {name: '味噌汁'},
  {name: 'ハンバーグ'},
  {name: '麻婆豆腐'},
  {name: 'トンカツ'}
])

RecipeGenre.create([
  {recipe: Recipe.find_by(name: '味噌汁'), genre: Genre.find_by(name: '和食')},
  {recipe: Recipe.find_by(name: 'ハンバーグ'), genre: Genre.find_by(name: '洋食')},
  {recipe: Recipe.find_by(name: '麻婆豆腐'), genre: Genre.find_by(name: '中華')},
  {recipe: Recipe.find_by(name: 'トンカツ'), genre: Genre.find_by(name: '和食')},
  {recipe: Recipe.find_by(name: 'トンカツ'), genre: Genre.find_by(name: '洋食')}
])
