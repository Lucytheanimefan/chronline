class Admin::ArticlesController < ApplicationController
  layout 'admin'

  def index
    @articles = Article.order('created_at DESC')
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    # Last element of taxonomy array may be an empty string
    params[:article][:section].pop if params[:article][:section].last.blank?
    @article = Article.new(params[:article])
    if @article.save
      redirect_to admin_root_path
    else
      render 'new'
    end
  end
end