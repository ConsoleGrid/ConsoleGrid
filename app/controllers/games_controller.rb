class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    add_crumb("'#{params[:q]}'",games_path(:q => params[:q]))
    # My own inverted index
    search = Game.search do
      fulltext params[:q]
    end
    @matches = search.results
    respond_to do |format|
      format.html # search.html.erb
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    add_crumb(@game.console.name,console_path(@game.console))
    add_crumb(@game.name,game_path(@game))
    
    # @pictures = @game.pictures
    @pictures = @game.pictures.find_with_reputation(:votes, :all, :order => "votes desc")
    @top_picture = @pictures.shift
    @new_picture = Picture.new
    @new_picture.game_id = @game.id
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new
    if params[:console]
      @game.console = Console.where(:shortname => params[:console]).first
      add_crumb(@game.console.name,console_path(@game.console))
    end
    
    @consoles = Console.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new()
    @game.name = params[:game][:name]
    @game.console_id = params[:game][:console_id]
    
    respond_to do |format|
      if @game.save
        # @game.populate_inverted_index
        format.html { redirect_to @game, :notice => 'Game was successfully created.' }
        format.json { render :json => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.json { render :json => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, :notice => 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
  
  def find
    respond_to do |format|
      format.html # find.html.erb
    end
  end
  
  def console
    @console = Console.find(params[:id])
    add_crumb(@console.name,console_path(@console))
    @matches = @console.games
    respond_to do |format|
      format.html # console.html.erb
    end
  end
end