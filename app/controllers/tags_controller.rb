class TagsController < ApplicationController
  before_filter :set_tag, :only => [:show, :edit, :update, :destroy]
  before_filter :check_admin!, :only => [:index]
  before_filter :check_owner!, :only => [:edit, :update, :destroy]
  before_filter :authenticate_user!, :only => [:create, :new]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @deck = Deck.find(params[:deck_id])
    @tag = @deck.tags.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
    @deck = Deck.find(params[:deck_id])
    @tag = Tag.new(tag_params)
    @tag.deck = @deck

    respond_to do |format|
      if @tag.save
        format.html { redirect_to edit_deck_path(@deck.id), notice: 'Tag was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tag }
      else
        format.html { redirect_to edit_deck @tag, notice: 'Tag was not successfully updated.' }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    @deck = Deck.find(params[:deck_id])
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to edit_deck_path(@deck.id), notice: 'Tag was successfully created.' }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_deck @tag, notice: 'Tag was not successfully updated.' }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @deck = Deck.find(params[:deck_id])
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to edit_deck_path(@deck.id) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:deck_id, :tag_string)
    end

    def check_admin!
      if ( !user_signed_in? || current_user.id != 0 )
        redirect_to root_path, :notice => "Action not allowed"
      end
    end

    def check_owner!
      if ( !user_signed_in? || Tag.find(params[:id]).deck.user_id != current_user.id )
        redirect_to root_path, :notice => "Action not allowed"
      end
    end


end
