class ShoppingsController < ApplicationController
  before_action :authenticate_user!

  def index
    # list all the shopping lists
    @recipe = Recipe.find(params[:id])
    @foods = current_user.foods
    @ingredients = @recipe.foods
    @missing_ingredients = @ingredients.select do |ingredient|
      idx = @foods.find_index(ingredient)
      @foods[idx].quantity > ingredient.quantity
    end
  end
end
