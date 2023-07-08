class ApplicationController < ActionController::Base
    def login
        if session[:user_name]
        else
         redirect_to root_url
        end
    end

    def admin_judge
        if session[:admin_flag] == true
        else
         redirect_to root_url
        end
    end

end
