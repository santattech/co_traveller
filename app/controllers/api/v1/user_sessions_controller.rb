module Api
  module V1
    class UserSessionsController < BaseController
      skip_before_action :verify_authenticity_token, only: [:create, :reset_password]
      before_action :authenticate_request, only: [:get_user, :destroy, :reset_password]

      def create
        user = AdminUser.find_by_email(params[:email])
        
        if user
          if user.valid_password?(params[:password])
            auth_token = JsonWebToken.encode(user_id: user.id, last_login_at: user.current_sign_in_at.to_i)
            user.last_sign_in_at = user.current_sign_in_at
            user.current_sign_in_at = Time.zone.now
            user.save
            render status: :created, json: json_api_serializer_response(user, meta: { auth_token: auth_token, 
              message: "Login successful" })
          else
            render_json_error(:unauthorized, message: "invalid password")
          end
        else
          render_json_error(:not_found, code: "1101") 
        end
      rescue => e
        render_json_error(:unauthorized, code: "unauthorized") 
      end

      def reset_password
        user = current_user

        if user
          user.update(password: params[:password].to_s, password_confirmation: params[:confirm_password].to_s)

          if user.errors.present?
            render_json_error(:unprocessable_entity, object: user)
          else
            render status: :ok, json: json_api_serializer_response(user, meta: { message: "Password reset successful" })
          end  
        else
          render_json_error(:not_found, code: "1001") # message: "Invalid Email")
        end
      end

      def get_user
        render status: :ok, json: json_api_serializer_response(current_user)
      end

      def destroy
        current_user
        render status: :ok, json: json_api_serializer_response(current_user, meta: { message: "Logout successful" })
      end
    end
  end
end