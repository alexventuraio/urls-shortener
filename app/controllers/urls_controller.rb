class UrlsController < ApplicationController
  before_action :set_urls, only: [:index, :redirect, :create]

  def index
  end

  def redirect
    @url = Url.find_by_short(params[:short_url])

    if @url
      #url.increase_counter
      redirect_to @url.original, status: 302
    else
      flash.now[:alert] = 'The given URL does not exist!'
      render :index
    end
  end

  def create
    url = Url.find_or_create_by(original: url_params[:original])

    if url.persisted?
      @saved_url = "#{request.base_url}/#{url.short}"
      flash.now[:notice] = 'Your shortened URL has been created!'
    else
      flash.now[:alert] = url.errors.full_messages.to_sentence
    end

    render :index
  end

  private

  def set_urls
    @urls = Url.all
    @url = Url.new
  end

  def url_params
    params.require(:url).permit(:original)
  end
end
