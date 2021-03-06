class UsersController < ApplicationController

	before_filter :authenticate, :except => [:show, :new, :create] 

  def new
		@user = User.new
		@title = "Sign up"
  end
  
  def show
		@user = current_user
		@title = @user.name
  end
  
  def edit
		@user = current_user
		@title = "Edit user"
  end
  		
	def index 
		@title = "All users"
		@users = User.paginate(:page => params[:page])
	end
			
	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to '/profile'
			UserMailer.registration_confirmation(@user).deliver
		else
			@title = "Sign up"
			render 'new'
		end
	end
	
	def update
		@user = current_user
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated."
			redirect_to '/profile'
		else
			@title = "Edit user"
			render 'edit'
		end
	end
	
	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_path
	end
		
	private
	
		def authenticate
			deny_access unless signed_in?
		end
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
	
end
