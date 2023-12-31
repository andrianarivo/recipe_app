class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show edit update destroy]
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:all]

  # GET /recipes or /recipes.json
  def index
    @recipes = current_user.recipes.all
  end

  def all
    @recipes = Recipe.where(public: true)
  end

  # GET /recipes/1 or /recipes/1.json
  def show
    @ingredients = Recipe.find(params[:id]).foods.select('foods.id', 'foods.name', 'ingredients.quantity',
                                                         'foods.measurement_unit', 'foods.price')
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
    @recipe.ingredients.build
    @foods_map = Food.all.collect { |food| [food.name, food.id] }
  end

  # GET /recipes/1/edit
  def edit
    @foods_map = Food.all.collect { |food| [food.name, food.id] }
  end

  # POST /recipes or /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.author = current_user

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_ingredient
    ingredient = Ingredient.find(params[:id])
    recipe = ingredient.recipe
    ingredient.destroy
    redirect_to recipe_path(recipe), notice: 'Ingredient was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description, :public,
                                   ingredients_attributes: %i[id food_id quantity _destroy])
  end
end
