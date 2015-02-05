class Api::V2::ConsolesController < Api::V2::BaseApiController
  # Returns a list of all consoles. Results are ordered by the consoles name.
  #
  # There is no pagination of this list, as the list of consoles is manually
  # curated and therefore should stay pretty short.
  #
  # If the 'q' parameter is provided then this method acts as an alias for
  # 'consoles/search'
  #
  # Parameters: None
  def list
    return search if params.include? :q
    consoles = Console.order('name ASC')
    render :json => { :error => nil, :consoles => consoles }
  end

  # Searches for consoles based on their name or shortname. Results are
  # ordered by relevance.
  #
  # Parameters:
  # q         - The query string. This is matched against both the name and
  #             the shortname of the console
  # page      - The page of results to display, for pagination. If no page is
  #             specified then it defaults to 1
  # per_page  - The number of results to display per page, to be used in
  #             conjunction with the page parameter. Functionally equivalent
  #             to a 'limit' when page is 1
  def search
    raise Exceptions::APIError, "Missing search query. Did you forget to pass 'q='?" unless params.include? :q

    consoles = Console.easy_search(params[:q], :page => params[:page], :per_page => params[:per_page] )
    render :json => { :error => nil, :total_pages => consoles.total_pages, :consoles => consoles }
  end

  # Returns the information for a single console.
  #
  # Parameters: None
  def show
    id = params[:id]
    console = Console.find_by_id(id)
    raise Exceptions::APIError, "Unable to find Console with id '#{id}'" if console.nil?

    render :json => { :error => nil, :console => console }
  end

  # Returns a paginated list of the games associated with the console. These
  # results are ordered by the games name.
  #
  # Parameters:
  # page      - The page of results to display, for pagination. If no page is
  #             specified then it defaults to 1
  # per_page  - The number of results to display per page, to be used in
  #             conjunction with the page parameter. Functionally equivalent
  #             to a 'limit' when page is 1
  def games
    id = params[:id]
    console = Console.find_by_id(id)
    raise Exceptions::APIError, "Unable to find Console with id '#{id}'" if console.nil?

    games = console.games.where(:duplicate => false).order('name ASC')
    games = games.paginate(:page => params[:page], :per_page => params[:per_page])
    render :json => { :error => nil, :total_pages => games.total_pages, :games => games }, :except => [:console_id], :methods => [:top_picture_url]
  end
end
