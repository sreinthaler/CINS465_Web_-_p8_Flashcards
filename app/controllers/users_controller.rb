class UsersController < ApplicationController
  
  #adds to devise user controller

  # GET /users/1
  def show
    @user = User.find(params[:id])
    @user_decks = Array.new
    if (user_signed_in? && current_user.id == @user.id)
      @user_decks = Deck.all.select{ |deck| deck.user_id == @user.id }
    else
      @user_decks = Deck.all.select{ |deck| deck.user_id == @user.id && deck.public_deck == true }
    end
  end

end
