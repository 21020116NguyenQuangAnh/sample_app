class MicropostsController < ApplicationController
  before_action :correct_user, only: :destroy
  before_action :logged_in_user, only: %i(create destroy)

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      handle_success_micropost
    else
      handle_invalid_micropost
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.destroy.success"
    else
      flash[:danger] = t "microposts.destroy.failed"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::CONTENT_ATTRIBUTES
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "microposts.destroy.invalid"
    redirect_to request.referer || root_url
  end

  def handle_success_micropost
    flash[:success] = t "microposts.create.success"
    redirect_to root_url
  end

  def handle_invalid_micropost
    @pagy, @feed_items = pagy current_user.feed.newest, items: Settings.page_10
    render "static_pages/home", status: :unprocessable_entity
  end
end
