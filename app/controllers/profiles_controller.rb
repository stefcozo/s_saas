class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :only_current_user
    def new
        #form where a user cna fill their own profile
        @user = User.find ( params[:user_id] )
        @profile = Profile.new
    end
    def create
        @user = User.find( params[:user_id] )
        @profile = @user.build_profile(profile_params) #Trebuie de definit fiecare parametru pentru securitate prin private mai jos!
        #salvam forma in baza de date in felul dat:
        if @profile.save
            flash[:success] = "Profile Updated! " #mesaj cu profil Updated
            redirect_to user_path( params[:user_id] ) #redirectioneaza la pagina cu profil completat
        else
            render action: :new
        end
    end   
    
    def edit
        @user = User.find( params[:user_id] )
        @profile = @user.profile
    end
    
    def update
        @user = User.find( params[:user_id] )
        @profile = @user.profile
        if @profile.update_attributes(profile_params)
            flash[:success] = "Profile Updated"
            redirect_to user_path( params[:user_id] )
        else
            render action: :edit
        end
    end
    
        #partea cu declararea!
        private
        def profile_params
            params.require(:profile).permit(:first_name, :last_name, :job_title, :phone_number, :contact_email, :description)
        end
        
        def only_current_user
            @user = User.find( params[:user_id] )
            redirect_to(root_url) unless @user == current_user
         end
end

