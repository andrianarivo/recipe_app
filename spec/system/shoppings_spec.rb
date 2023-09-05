require 'rails_helper'

RSpec.describe "Shoppings", type: :system do
  include Devise::Test::IntegrationHelpers

  before(:all) do
    Ingredient.delete_all
    Food.delete_all
    Recipe.delete_all

    @author = User.first
    @author ||= User.create!(name: 'John',
                             email: 'john.doe@mail.com',
                             password: 'admin1234',
                             password_confirmation: 'admin1234',
                             confirmed_at: Time.now)
    @recipe1 = Recipe.create(author: @author,
                             name: 'Perfect Chicken',
                             description: 'Description for Perfect Chicken',
                             preparation_time: 10,
                             cooking_time: 75)
    @food1 = Food.create(owner: @author,
                         name: 'Chicken',
                         measurement_unit: 'g',
                         price: 5.03,
                         quantity: 10)
    @food2 = Food.create(owner: @author,
                         name: 'Butter',
                         measurement_unit: 'g',
                         price: 5.03,
                         quantity: 10)
    @ingredient1 = Ingredient.create(recipe: @recipe1, food: @food1, quantity: 1000)
    @ingredient2 = Ingredient.create(recipe: @recipe1, food: @food2, quantity: 1000)
  end

  before(:each) do
    sign_in @author
  end

  it "I can see the total amount" do
    visit shoppings_path(@recipe1)
    expect(page).to have_content("$10.06")
  end

  it "I can see the total item" do
    visit shoppings_path(@recipe1)
    expect(page).to have_content(2)
  end
end
