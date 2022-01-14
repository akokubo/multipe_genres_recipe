class CreateRecipeGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_genres do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
