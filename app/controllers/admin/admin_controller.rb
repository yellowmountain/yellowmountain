class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_filter :authorize_user

  layout 'admin'

  private
  def authorize_user
    redirect_to root_path unless current_user.has_role? :admin
  end
end