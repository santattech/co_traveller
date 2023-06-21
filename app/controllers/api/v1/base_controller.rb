module Api
  module V1
    class BaseController < ApplicationController
      # skip_before_action :
      skip_before_action :verify_authenticity_token, :only => :create

      protected

      def authenticate_request
        unless logged_in?
          render_json_error(:unauthorized, code: "1101") # message: "Not Authenticated")
        end
      end

      def authenticate_request_agent
        logged_in?
      end

      def current_user
        return @current_user if @current_user

        unless @current_user == false
          if auth_token && (auth_token[:exp].to_i > Time.now.to_i)
            user = User.find_by(id: auth_token[:user_id])

            if user && user.last_login_at.to_i == auth_token[:last_login_at]
              @current_user ||= user
            end
          end
        end
      end

      private

      def token
        @token ||= if request.headers['Authorization'].present?
          request.headers['Authorization'].split(' ').last
        end
      end

      def auth_token
        @auth_token ||= JsonWebToken.decode(token)
      end

      def logged_in?
        current_user
      end
    end
  end
end
