class Api::RecipesController < ApplicationController
  def first_recipe_method
    @recipe = Recipe.first
    render "first_recipe.json.jb"
  end
end
