class ShoppingsController < ApplicationController
  before_action :authenticate_user!

  def index
    # list all the shopping lists
    @recipe = Recipe.find(params[:id])
    @ingredients = get_shopping_list(@recipe)
    @total_amount = @ingredients.reduce(0) do |acc, item|
      acc + item.price
    end
    @total_item = @ingredients.length
  end

  def all
    recipes = Recipe.all
    @ingredients = []
    recipes.each do |recipe|
      @ingredients << get_shopping_list(recipe)
    end
    @ingredients.flatten!
    @total_amount = @ingredients.reduce(0) do |acc, item|
      acc + item.price
    end
    @total_item = @ingredients.length
  end

  private

  def get_shopping_list(recipe)
    ingredients = recipe.foods.select('foods.id', 'foods.name', 'ingredients.quantity',
                                       'foods.measurement_unit', 'foods.price')
    foods = recipe.foods
    ingredients = ingredients.zip(foods)
    ingredients = ingredients.map do |entry|
      Food.new(measurement_unit: entry[1].measurement_unit, name: entry[1].name,
               quantity: entry[1].quantity - entry[0].quantity, price: entry[1].price)
    end
    ingredients = ingredients.select do |ingredient|
      ingredient.quantity.negative?
    end
    ingredients.map do |ingredient|
      ingredient.quantity = ingredient.quantity.abs
      ingredient
    end
  end
end
