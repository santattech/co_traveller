module Api
  module V1
    class LocationsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: [:record_location]
      
      def create
        if params[:trip_name].blank?
          render status: 422, json: { message: "trip is missing" }
          return
        end

        location = Location.create(lat: params[:lat], lng: params[:lng], other_info: { trip_name: params[:trip_name]})

        if location.errors.blank?
          render status: :created, json: { location: location.as_json }
        else
          render status: 422, json: { message: location.errors.full_messages.to_sentence }
        end
      end

      def record_location
        count = 0
        if request.headers['X-API-KEY'].present? && request.headers['X-API-KEY'] != '987654321'
          Rails.logger.error("The header not matched: #{request.headers['X-API-KEY']}")
          render status: 401, json: { message: 'illegal try' }
          return
        end

        if params[:locations_arr].present?
          params[:locations_arr].each do |location|
            count = count + 1 if Location.create(lat: location[0], lng: location[1])
          end
        end

        render status: :ok, json: { location: "#{count} locations created" } 
      end
    end
  end
end

