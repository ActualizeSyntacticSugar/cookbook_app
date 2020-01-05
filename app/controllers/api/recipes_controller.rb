class Api::RecipesController < ApplicationController
  def index
    @recipes = Recipe.all

    if params[:input_search]
      @recipes = @recipes.where("title ILIKE ?", "%#{params[:input_search]}%")
    end

    @recipes = @recipes.order(:id => :asc)

    render "index.json.jb"
  end

  def create
    if params[:input_image_file]
      response = Cloudinary::Uploader.upload(params[:input_image_file])
      cloudinary_url = response["secure_url"]
    else
      cloudinary_url = nil
    end

    @recipe = Recipe.new(
      title: params[:input_title],
      chef: params[:input_chef],
      ingredients: params[:input_ingredients],
      directions: params[:input_directions],
      prep_time: params[:input_prep_time],
      image_url: cloudinary_url,
      user_id: current_user.id,
    )
    @recipe.save
    render "show.json.jb"
  end

  def show
    @recipe = Recipe.find_by(id: params[:id])
    render "show.json.jb"
  end

  def update
    @recipe = Recipe.find_by(id: params[:id])
    @recipe.title = params[:input_title] || @recipe.title
    @recipe.chef = params[:input_chef] || @recipe.chef
    @recipe.ingredients = params[:input_ingredients] || @recipe.ingredients
    @recipe.directions = params[:input_directions] || @recipe.directions
    @recipe.save
    render "show.json.jb"
  end

  def destroy
    @recipe = Recipe.find_by(id: params[:id])
    @recipe.destroy
    render json: { message: "Recipe successfully destroyed!" }
  end
end
