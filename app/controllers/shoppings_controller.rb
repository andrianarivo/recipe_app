class ShoppingsController < ApplicationController
  before_action :authenticate_user!

  def index
    # list all the shopping lists
    ingredients = Recipe.find(params[:id]).foods.select("foods.id", "foods.name", "ingredients.quantity", "foods.measurement_unit", "foods.price")
    foods = Recipe.find(params[:id]).foods
    ingredients = ingredients.zip(foods)
    ingredients = ingredients.map do |entry|
      Food.new(measurement_unit: entry[1].measurement_unit, name: entry[1].name, quantity: entry[1].quantity-entry[0].quantity, price: entry[1].price) 
    end
    ingredients = ingredients.select do |ingredient|
      ingredient.quantity.negative?
    end
    @ingredients = ingredients.map do |ingredient|
      ingredient.quantity = ingredient.quantity.abs
      ingredient
    end
    @total_amount = @ingredients.reduce(0) do |acc, item|
      acc + item.price
    end
    @total_item = @ingredients.length
  end
end
