class ArticlesController < ApplicationController
  # The 'before_action' allows us to add our set_article method to our selected methods at the beginning of the controller, helping to prevent repeated code
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:show, :index]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  # Actions, each need a view file in the views/articles folder.
  def show 
  end

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    # We have to initialize a new article instance in order for our page to load without a nilCLass error
    @article = Article.new
  end

  def edit
  end

  def create
    # This enabled our new article to be posted to the articles table, we must whitelist the required fields using the permit method
    @article = Article.new(article_params)
    # Temporary user to enable authentication for creating articles
    @article.user = current_user
    # We then save the article to the table
    if @article.save
      # If our article saves we display a success message
      flash[:notice] = "Article was saved successfully"
      # We then re-direct to the show article path so that we can see our new article
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def update
    if @article.update(article_params)
      flash[:notice] = "Article updated successfully."
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private # Anything below the 'private' keyword is exclusive to this controller only
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end

  def require_same_user
    if current_user != @article.user && !current_user.admin?
    flash[:notice] = "You do not have permission to edit this article"
      redirect_to @article
    end
  end
end