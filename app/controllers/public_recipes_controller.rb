class PublicRecipesController < ApplicationController
  def index
    @public = Recipe.where(public: true).order('created_at DESC')
  end
end
