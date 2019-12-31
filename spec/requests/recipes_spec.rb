require "rails_helper"

RSpec.describe "Recipes", type: :request do
  describe "GET /recipes" do
    it "returns an array of recipes" do
      user = User.create!(name: "Peter", email: "peter@email.com", password: "password")
      Recipe.create!(title: "First recipe", chef: "test chef", ingredients: "thing", directions: "do the thing", prep_time: 33, user_id: user.id)
      Recipe.create!(title: "Second recipe", chef: "test chef", ingredients: "thing", directions: "do the thing", prep_time: 33, user_id: user.id)

      get "/api/recipes"
      recipes = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(recipes.length).to eq(2)
    end
  end

  describe "POST /recipes" do
    it "creates a recipe" do
      user = User.create!(name: "Peter", email: "peter@email.com", password: "password")
      jwt = JWT.encode({ user_id: user.id }, Rails.application.credentials.fetch(:secret_key_base), "HS256")

      post "/api/recipes", params: {
                             input_title: "New title",
                             input_chef: "New chef",
                             input_prep_time: 100,
                             input_ingredients: "New ingredients",
                             input_directions: "New directions",
                             input_image_url: "something",
                           },
                           headers: { "Authorization" => "Bearer #{jwt}" }
      recipe = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(recipe["title"]).to eq("New title")
    end
  end

  describe "GET /recipes/:id" do
    it "should return a hash with the appropriate attributes" do
      user = User.create!(name: "Peter", email: "peter@email.com", password: "password")
      Recipe.create!(title: "First recipe", chef: "test chef", ingredients: "thing", directions: "do the thing", prep_time: 33, user_id: user.id)
      Recipe.create!(title: "Second recipe", chef: "test chef", ingredients: "thing", directions: "do the thing", prep_time: 33, user_id: user.id)

      recipe_id = Recipe.first.id
      get "/api/recipes/#{recipe_id}"
      recipe = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(recipe["title"]).to eq("First recipe")
      expect(recipe["chef"]).to eq("test chef")
    end
  end
end
