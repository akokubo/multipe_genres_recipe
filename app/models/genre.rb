class Genre < ApplicationRecord
  has_many :recipe_genres
  has_many :recipes, through: :recipe_genres, dependent: :destroy
end
