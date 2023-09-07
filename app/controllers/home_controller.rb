class HomeController < ApplicationController
  def index
    @current_user = (current_user.name if user_signed_in?)
    @recipes = Recipe.all
    @public = Recipe.where(public: true).order('created_at DESC')
  end
end
