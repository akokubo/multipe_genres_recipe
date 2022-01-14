# アプリの作成
```
$ rails new multipe_genres_recipe
$ cd multipe_genres_recipe
```

# モデルとスキャフォルドの作成
```
$ rails generate scaffold Genre name:string
$ rails generate scaffold Recipe name:string
$ rails generate model RecipeGenre recipe:references genre:references
```

# モデルの修正
app/models/genre.rb
```
class Genre < ApplicationRecord
  has_many :recipe_genres
  has_many :recipes, through: :recipe_genres, dependent: :destroy
end
```

app/models/recipe.rb
```
class Recipe < ApplicationRecord
  has_many :recipe_genres
  has_many :genres, through: :recipe_genres, dependent: :destroy
end
```

app/models/recipe_genre.rb ※確認する
```
class RecipeGenre < ApplicationRecord
  belongs_to :recipe
  belongs_to :genre
end
```

# データベースのマイグレーション
```
$ rails db:migrate
```

# モデルの確認
```
$ rails console --sandbox
>> japanese_food = Genre.create({name: '和食'})
>> pork_cutlet = Recipe.create({name: 'トンカツ'})
>> RecipeGenre.create({recipe: pork_cutlet, genre: japanese_food})
>> (pork_cutlet.genres.all.map { |genre| genre.name}).join(', ')
>> western_food = Genre.create({name: '洋食'})
>> RecipeGenre.create({recipe: pork_cutlet, genre: western_food})
>> (pork_cutlet.genres.all.map { |genre| genre.name}).join(', ')
```

# シードの作成
db/seeds.rb
```
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
```

# シードの投入
```
$ rails db:seed
```

# サーバーの起動
```
$ rails server
```

# コントローラーの修正
app/controllers/recipes_controller.rb
```
class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[ show edit update destroy ]

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1 or /recipes/1.json
  def show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes or /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to recipe_url(@recipe), notice: "Recipe was successfully created." }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to recipe_url(@recipe), notice: "Recipe was successfully updated." }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url, notice: "Recipe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(:name, genre_ids: [])
    end
end
```

# ビューの修正
app/views/recipes/index.html.erb
```
<p id="notice"><%= notice %></p>

<h1>Recipes</h1>

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Genre</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @recipes.each do |recipe| %>
      <tr>
        <td><%= recipe.name %></td>
        <td>
          <%= (recipe.genres.all.map { |genre| genre.name}).join(', ') %>
        </td>
        <td><%= link_to 'Show', recipe %></td>
        <td><%= link_to 'Edit', edit_recipe_path(recipe) %></td>
        <td><%= link_to 'Destroy', recipe, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New Recipe', new_recipe_path %> |
<%= link_to 'Genres', genres_path %>
```

app/views/recipes/show.html.erb
```
<p id="notice"><%= notice %></p>

<p>
  <strong>Name:</strong>
  <%= @recipe.name %>
</p>

<p>
  <strong>Genre:</strong>
  <%= (@recipe.genres.all.map { |genre| genre.name}).join(', ') %>
</p>

<%= link_to 'Edit', edit_recipe_path(@recipe) %> |
<%= link_to 'Back', recipes_path %>
```

app/views/recipes/_form.html.erb   
```
<%= form_with(model: recipe) do |form| %>
  <% if recipe.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(recipe.errors.count, "error") %> prohibited this recipe from being saved:</h2>

      <ul>
        <% recipe.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= form.label :name %>
    <%= form.text_field :name %>
  </div>

  <div>
    Genre<br>
    <% Genre.all.each do |genre| %>
      <%= form.check_box :genre_ids, { multiple: true }, genre.id, nil %>
      <%= form.label :genre_ids, genre.name, value: genre.id %>
    <% end %>
    <p><%= link_to "ジャンルを追加したい場合", new_genre_path %> 注:このページには戻ってきません</p>
  </div>

  <div class="actions">
    <%= form.submit %>
  </div>
<% end %>
```

app/assets/stylesheets/application.css 
```
/*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets, or any plugin's
 * vendor/assets/stylesheets directory can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the bottom of the
 * compiled file so the styles you add here take precedence over styles defined in any other CSS/SCSS
 * files in this directory. Styles in this file should be added after the last require_* statement.
 * It is generally better to create a new file per style scope.
 *
 *= require_tree .
 *= require_self
 */

form div input[type="checkbox"] + label { 
  display: inline-block;
}
```

app/views/genres/index.html.erb 
```
<p id="notice"><%= notice %></p>

<h1>Genres</h1>

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @genres.each do |genre| %>
      <tr>
        <td><%= genre.name %></td>
        <td><%= link_to 'Show', genre %></td>
        <td><%= link_to 'Edit', edit_genre_path(genre) %></td>
        <td><%= link_to 'Destroy', genre, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New Genre', new_genre_path %> |
<%= link_to 'Recipes', recipes_path %>
```

app/views/recipes/_recipe.json.jbuilder
```
json.extract! recipe, :id, :name, :genre_ids, :created_at, :updated_at
json.url recipe_url(recipe, format: :json)
```
