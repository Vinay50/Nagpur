class Admin::UsersController < Admin::BaseController

  def index
    @users = User.all(order: "email")
   # @roles = Role.all
    @user = User.new
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    is_admin = params[:user].delete(:is_admin) == '1'
    @user = User.new(user_params)
    @user.save
    @user.is_admin = is_admin
    if @user.save
      flash[:notice] = 'User has been created.'
      redirect_to admin_users_path
    else
      flash[:alert] = 'User has not been created'
      render action: 'new'
    end
  end

    def edit
      @user = User.find(params[:id])
      respond_to do |format|
        format.js
        format.html
      end
    end

  def update
    if params[:user][:password].empty?
      params[:user].delete(:password)
    end
     set_admin
     @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to admin_users_path, notice: 'User has been updated'
    else
      redirect_to edit_admin_users_path, alert: "User could not be created, Please try again"
    end
  end

  def destroy
    if @user == current_user
      flash[:alert] = 'You cannot delete yourself!'
    else
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = 'User has been deleted.'
    end
    redirect_to admin_users_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def set_admin
    @user = User.find(params[:id])
    is_admin = params[:user].delete(:is_admin) == '1'
    @user.is_admin = true
  end

  private
  def user_params
     params.require(:user).permit(:first_name,:last_name,:email,:password,:username,:birth_date,:is_active,:is_admin)
  end

end
