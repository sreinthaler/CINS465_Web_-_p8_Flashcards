class HomeController < ApplicationController


  def index

    @decks_all = Deck.all
    @decks_owned = Array.new
    @decks_public = Array.new

    if user_signed_in?
      @decks_owned = @decks_all.select{ |deck| deck.user_id == current_user.id }
      @decks_public = @decks_all.reject{ |deck| deck.user_id == current_user.id }.select{ |deck| deck.public_deck == true }
    else
      @decks_public = @decks_all.select{ |deck| deck.public_deck == true }
    end

    @decks_owned.sort!{ |x,y| x.title <=> y.title }
    @decks_public.sort!{ |x,y| x.title <=> y.title }

  end


  def search
  end


  def search_results

    @q_title = params[:q_title]
    @q_author = params[:q_author]
    @q_subject = params[:q_subject]
    @q_tag = params[:q_tag]
    @sort = params[:sort]
    @order = params[:order]

    @decks_all = Deck.all
    @decks_modified = Array.new
    @decks_modified = @decks_all

    if !@q_title.to_s.empty? then @decks_modified = @decks_modified.select{ |deck| deck.title =~ /#{@q_title}/ } end
    if !@q_author.to_s.empty? then @decks_modified = @decks_modified.select{ |deck| deck.author =~ /#{@q_author}/ } end
    if !@q_subject.to_s.empty? then @decks_modified = @decks_modified.select{ |deck| deck.subject =~ /#{@q_subject}/ } end
    if !@q_tag.to_s.empty? then @decks_modified = @decks_modified.select{ |deck| !deck.tags.select{ |tag| tag.tag_string =~ /#{@q_tag}/ }.empty? } end

    if @sort == 'author' then @decks_modified = @decks_modified.sort{ |x,y| [x.author, x.title] <=> [y.author, y.title] }
    elsif @sort == 'subject' then @decks_modified = @decks_modified.sort{ |x,y| [x.subject, x.title] <=> [y.subject, y.title] }
    else @decks_modified = @decks_modified.sort{ |x,y| x.title <=> y.title }
    end

    if @order == 'desc' then @decks_modified = @decks_modified.reverse end

    @decks_owned = Array.new
    @decks_public = Array.new

    if user_signed_in?
      @decks_owned = @decks_modified.select{ |deck| deck.user_id == current_user.id }
      @decks_public = @decks_modified.reject{ |deck| deck.user_id == current_user.id }.select{ |deck| deck.public_deck == true }
    else
      @decks_public = @decks_modified.select{ |deck| deck.public_deck == true }
    end

  end


end
