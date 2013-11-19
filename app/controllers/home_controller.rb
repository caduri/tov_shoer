class HomeController < ApplicationController
  def index
  	if user_signed_in?
  		redirect_to player_url(current_user.id) and return
    end
  end
end
