require 'rails_helper'

RSpec.describe 'Menu', type: :system do
  include Devise::Test::IntegrationHelpers

  before(:all) do
    delete_all
    set_user
    @food1 = Food.create(owner: @john,
                         name: 'Pizza',
                         measurement_unit: 'Slice',
                         price: 8.99,
                         quantity: 5)
    @food2 = Food.create(owner: @john,
                         name: 'Burger',
                         measurement_unit: 'Piece',
                         price: 5.99,
                         quantity: 10)
    @foods = Food.all
    @recipe1 = Recipe.create(author: @john,
                             name: 'Pasta',
                             preparation_time: 5,
                             cooking_time: 10,
                             description: 'Delicious pasta dish',
                             public: true)
    @recipe2 = Recipe.create(author: @john,
                             name: 'Salad',
                             preparation_time: 10,
                             cooking_time: 0,
                             description: 'Healthy salad recipe',
                             public: true)
    @public_recipes = Recipe.where(public: true)
  end

  before(:each) do
    sign_in @john
  end

  it 'renders the menu partial' do
    visit public_recipes_path
    expect(page).to have_content('Public Recipes')
  end

  it 'displays public recipes and their details' do
    visit public_recipes_path
    within '#recipes' do
      @public_recipes.each do |recipe|
        expect(page).to have_content(recipe.name)
      end
    end
  end

  def delete_all
    Ingredient.delete_all
    Food.delete_all
    Recipe.delete_all
  end

  def set_user
    @john = User.first
    @set_user ||= User.create!(name: 'John',
                               email: 'john.doe@mail.com',
                               password: 'admin1234',
                               password_confirmation: 'admin1234',
                               confirmed_at: Time.now)
  end
end
