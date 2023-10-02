class SessionsController < ApplicationController 

    def new 
        @user = User.new 
        render :new
    end 

    def create 
        @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
        login(@user)
        redirect_to cats_url
    end 


    def destroy
        logout!
        redirect_to new_session_url
    end 






end 