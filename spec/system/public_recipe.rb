require 'rails_helper'

RSpec.describe 'Menu', type: :system do
  include Devise::Test::IntegrationHelpers

  before(:all) do
    Food.delete_all
    Recipe.delete_all

    @food1 = Food.create(name: 'Pizza',
                         measurement_unit: 'Slice',
                         price: 8.99,
                         quantity: 5)
    @food2 = Food.create(name: 'Burger',
                         measurement_unit: 'Piece',
                         price: 5.99,
                         quantity: 10)
    @foods = Food.all

    @recipe1 = Recipe.create(name: 'Pasta',
                             description: 'Delicious pasta dish',
                             public: true)
    @recipe2 = Recipe.create(name: 'Salad',
                             description: 'Healthy salad recipe',
                             public: true)
    @public_recipes = Recipe.where(public: true)
  end

  before(:each) do
    sign_in User.create!(name: 'John',
                         email: 'john.doe@mail.com',
                         password: 'admin1234',
                         password_confirmation: 'admin1234',
                         confirmed_at: Time.now)
  end

  it 'displays the menu and food details' do
    visit '/'
    expect(page).to have_content('Foods')

    within '#foods' do
      expect(page).to have_content(@food1.name)
      expect(page).to have_content(@food1.measurement_unit)
      expect(page).to have_content('$ 8.99')
      expect(page).to have_content(@food1.quantity)

      expect(page).to have_content(@food2.name)
      expect(page).to have_content(@food2.measurement_unit)
      expect(page).to have_content('$ 5.99')
      expect(page).to have_content(@food2.quantity)
    end
  end

  it 'renders the menu partial' do
    visit '/'
    expect(page).to have_content('Public Recipes')
    expect(page).to have_selector('.recipe', count: @public_recipes.count)
  end

  it 'displays public recipes and their details' do
    visit '/'
    within '#recipes' do
      @public_recipes.each do |recipe|
        expect(page).to have_content(recipe.name)
        expect(page).to have_content(recipe.description)
      end
    end
  end

  it 'allows adding a new food' do
    visit '/'
    click_link 'Add Food'

    fill_in 'Name', with: 'Sushi'
    fill_in 'Measurement unit', with: 'Roll'
    fill_in 'Price', with: '12.99'
    fill_in 'Quantity', with: '3'

    click_button 'Create Food'

    expect(page).to have_content('Food was successfully created.')
    expect(page).to have_content('Sushi')
    expect(page).to have_content('Roll')
    expect(page).to have_content('$ 12.99')
    expect(page).to have_content('3')
  end

  it 'allows removing a food' do
    visit '/'
    within "#food-#{@food1.id}" do
      click_link 'Remove'
    end

    expect(page).to have_content('Food was successfully removed.')
    expect(page).not_to have_content(@food1.name)
  end
end
