require 'rails_helper'

RSpec.describe "RecipeDetails", type: :system do
  include Devise::Test::IntegrationHelpers

  before(:all) do
    Ingredient.delete_all
    Recipe.delete_all

    @author = User.first
    @author ||= User.create!(name: 'John',
                             email: 'john.doe@mail.com',
                             password: 'admin1234',
                             password_confirmation: 'admin1234',
                             confirmed_at: Time.now)
    @recipe = Recipe.create(author: @author,
                            name: 'Perfect Chicken',
                            description: 'Description for Perfect Chicken',
                            preparation_time: 10,
                            cooking_time: 75)
    sign_in @author
  end

  it "I can see the recipe's title" do
    visit recipe_path(@recipe)
    expect(page).to have_content(@recipe.name)
  end

  it "I can see the recipe's description" do
    visit recipe_path(@recipe)
    expect(page).to have_content(@recipe.description)
  end

  it "I can toggle the recipe's visibility" do
    visit recipe_path(@recipe)
    check 'recipe[public]'
    @recipe = Recipe.find(@recipe.id)
    expect(@recipe.public).to be(true)
  end
end
