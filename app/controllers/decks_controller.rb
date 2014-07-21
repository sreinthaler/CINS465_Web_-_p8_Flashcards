class DecksController < ApplicationController
  before_action :set_deck, only: [:show, :edit, :update, :destroy, :upload, :download, :test_home, :test_practice_q, :test_practice_a, :test_regex_q, :test_regex_a, :test_regex_end]
  before_filter :check_admin!, :only => [:index]
  before_filter :check_owner!, :only => [:edit, :update, :destroy]
  before_filter :check_owner_or_public!, :only => [:show]
  before_filter :authenticate_user!, :only => [:create, :new]



  # GET /decks
  # GET /decks.json
  def index
    @decks = Deck.all
  end

  # GET /decks/1
  # GET /decks/1.json
  def show
  end

  # GET /decks/new
  def new
    @deck = Deck.new
  end

  # GET /decks/1/edit
  def edit
    @deck_cards = @deck.cards.sort{ |x,y| x.deck_card_id <=> y.deck_card_id }
    @deck_tags = @deck.tags.sort{ |x,y| x.tag_string <=> y.tag_string }
    #for form to add new card
    @new_card = @deck.cards.new
    #for form to add new tag
    @new_tag = @deck.tags.new
  end

  # POST /decks
  # POST /decks.json
  def create
    @deck = Deck.new(deck_params.merge(:user_id => current_user.id))

    respond_to do |format|
      if @deck.save
        format.html { redirect_to @deck, notice: 'Deck was successfully created.' }
        format.json { render action: 'show', status: :created, location: @deck }
      else
        format.html { render action: 'new' }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /decks/1
  # PATCH/PUT /decks/1.json
  def update
    respond_to do |format|
      if @deck.update(deck_params)
        format.html { redirect_to @deck, notice: 'Deck was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /decks/1
  # DELETE /decks/1.json
  def destroy
    @deck.destroy
    respond_to do |format|
      format.html { redirect_to decks_url }
      format.json { head :no_content }
    end
  end





  def upload
  end
  
  def download
  end



  
  def test_practice_q
    @card_num = params[:num].to_i
    @next_num = (@card_num + 1)
    @prev_num = (@card_num - 1)
    @card_temp = Card.where(deck_id: @deck.id, deck_card_id: @card_num)
    @card = @card_temp.first
    @front = @card.front
  end

  def test_practice_a
    @card_num = params[:num].to_i
    @next_num = (@card_num + 1)
    @prev_num = (@card_num - 1)
    @card_temp = Card.where(deck_id: @deck.id, deck_card_id: @card_num)
    @card = @card_temp.first
    @back = @card.back
  end




  
  def test_regex_q
    @card_num = params[:num].to_i
    @card_temp = Card.where(deck_id: @deck.id, deck_card_id: @card_num)
    @card = @card_temp.first
    @front = @card.front
    @num_correct = params[:c].to_i
  end

  def test_regex_a
    @card_num = params[:num].to_i
    @next_num = (@card_num + 1)
    @card_temp = Card.where(deck_id: @deck.id, deck_card_id: @card_num)
    @card = @card_temp.first
    @back = @card.back
    @regex = @card.regex
    @answer = params[:ans]
    @num_correct = params[:c].to_i
    if (@answer =~ /#{@regex}/)
      @is_correct = true
      @num_correct += 1
    else
      @is_correct = false
    end
  end
  
  def test_regex_end
    @num_correct = params[:c]
    @card_num = params[:num].to_i
  end






  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deck
      @deck = Deck.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deck_params
      params.require(:deck).permit(:user_id, :title, :public_deck, :subject, :description)
    end

    def check_admin!
      if ( !user_signed_in? || current_user.id != 0 )
        redirect_to root_path, :notice => "Action not allowed"
      end
    end

    def check_owner!
      if ( !user_signed_in? || Deck.find(params[:id]).user_id != current_user.id )
        redirect_to root_path, :notice => "Action not allowed"
      end
    end

    def check_owner_or_public!
      if ( (Deck.find(params[:id]).public_deck == false) && (!user_signed_in? || Deck.find(params[:id]).user_id != current_user.id) )
        redirect_to root_path, :notice => "Action not allowed"
      end
    end


end
