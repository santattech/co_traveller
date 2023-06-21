module Api
  module V1
    class UserSessionsController < BaseController
      before_action :authenticate_request, only: [:get_user, :destroy]

      def create
        user = AdminUser.find_by_email(params[:email])
        
        if user
          if user.valid_password?(params[:password])
            auth_token = JsonWebToken.encode(user_id: user.id)
            render status: :created, json: json_api_serializer_response(user, meta: { auth_token: auth_token, 
              message: "Login successful" })
          else
            render_json_error(:unauthorized, message: "invalid password")
          end
        else
          render_json_error(:not_found, code: "not found") 
        end
      rescue => e
        render_json_error(:unauthorized, code: "unauthorized") 
      end

      def destroy
        current_user
        render status: :ok, json: json_api_serializer_response(current_user, meta: { message: "Logout successful" })
      end
    end
  end
end