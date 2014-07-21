class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy, :move]
  before_filter :check_admin!, :only => [:index]
  before_filter :check_owner!, :only => [:edit, :update, :destroy]
  before_filter :authenticate_user!, :only => [:create, :new]

  # GET /cards
  # GET /cards.json
  def index
    @cards = Card.all
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @deck = Deck.find(params[:deck_id])
    @card = @deck.cards.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
    @deck = Deck.find(params[:deck_id])
    @card = Card.new(card_params)
    @card.deck = @deck

    @card.deck_card_id = @deck.cards.count + 1

    respond_to do |format|
      if @card.save
        format.html { redirect_to edit_deck_path(@deck.id), notice: 'Card was successfully created.' }
        format.json { render action: 'show', status: :created, location: @card }
      else
        format.html { redirect_to edit_deck_path(@deck.id), notice: 'Card was not successfully created.' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    @deck = Deck.find(params[:deck_id])
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to edit_deck_path(@deck.id), notice: 'Card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_deck_path(@deck.id), notice: 'Card was not successfully created.' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @deck = Deck.find(params[:deck_id])
    
    @deck.cards.each do |i|
      if i.deck_card_id > @card.deck_card_id then i.update_attributes(:deck_card_id => i.deck_card_id - 1) end
    end

    @card.destroy
    respond_to do |format|
      format.html { redirect_to edit_deck_path(@deck.id) }
      format.json { head :no_content }
    end
  end



  def move
    @direction = params[:dir]
    @deck = Deck.find(params[:deck_id])

    if (@direction == "up" && @card.deck_card_id > 1)
      @other_card = @deck.cards.select{ |c| (c.deck_card_id == @card.deck_card_id - 1) }.first
      @other_card.update_attributes(:deck_card_id => @other_card.deck_card_id + 1)
      @card.update_attributes(:deck_card_id => @card.deck_card_id - 1)
      respond_to do |format|
        format.html { redirect_to edit_deck_path(@deck.id), notice: 'Card was successfully updated.' }
        format.json { head :no_content }
      end
    elsif (@direction == "down" && @card.deck_card_id < @deck.cards.count)
      @other_card = @deck.cards.select{ |c| (c.deck_card_id == @card.deck_card_id + 1) }.first
      @other_card.update_attributes(:deck_card_id => @other_card.deck_card_id - 1)
      @card.update_attributes(:deck_card_id => @card.deck_card_id + 1)
      respond_to do |format|
        format.html { redirect_to edit_deck_path(@deck.id), notice: 'Card was successfully updated.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_deck_path(@deck.id), notice: 'Card was not successfully created.' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end

  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:deck_id, :deck_card_id, :front, :back, :regex)
    end

    def check_admin!
      if ( !user_signed_in? || current_user.id != 0 )
        redirect_to root_path, :notice => "Action not allowed"
      end
    end

    def check_owner!
      if ( !user_signed_in? || Card.find(params[:id]).deck.user_id != current_user.id )
        redirect_to root_path, :notice => "Action not allowed"
      end
    end


end
