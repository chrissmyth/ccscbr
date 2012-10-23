class MoviesController < ApplicationController

  def initialize
    @all_ratings = Movie.all_ratings
    @sort = ""
    super
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def get_ratings_filter(params)
     logger.debug("MoviesController.get_ratings_filter - params:"+params.inspect)

    if (params.has_key? "ratings") then
      logger.debug("MoviesController.get_ratings_filter - ratings:"+params.fetch("ratings").inspect)

      return params.fetch("ratings").keys
    end

    return @all_ratings
  end

  def index
    logger.debug("MoviesController.index - params:"+params.inspect + "@sort:" + @sort)


    logger.debug("ratings exist?:"+(params.has_key? "ratings").to_s)
    @required_ratings = get_ratings_filter(params)
    logger.debug("required_ratings: "+ @required_ratings.to_s)

    @title_header_class = ""
    @release_date_header_class = ""
    params[:sort]?sort=params[:sort]:sort=@sort

    #preserve the sort
    @sort = sort
     logger.debug("@sort: "+ @sort + " sort:" + sort)

    case sort
        when "title"
          @title_header_class = "hilite"
          @movies = Movie.find(:all, :conditions => ["rating IN (?)", @required_ratings] , :order => sort)
        when "release_date"
          @release_date_header_class = "hilite"
          @movies = Movie.find(:all, :conditions => ["rating IN (?)", @required_ratings] , :order => sort)
        else
          @movies = Movie.find(:all, :conditions => ["rating IN (?)", @required_ratings] )
    end
  end

  def tailored_list
    sort = params[:sort] # retrieve movie sort from URI route
    @movies = Movie.all
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end



end
