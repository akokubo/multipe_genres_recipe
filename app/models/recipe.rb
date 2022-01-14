class Recipe < ApplicationRecord
  has_many :recipe_genres
  has_many :genres, through: :recipe_genres, dependent: :destroy
end
