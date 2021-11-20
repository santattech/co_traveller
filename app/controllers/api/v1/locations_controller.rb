module Api
  module V1
    class LocationsController < ApplicationController
      
      def create
        last_location = Location.last
        location = Location.create(lat: params[:lat], lng: params[:lng])

        if location.errors.blank?
          render status: :created, json: { location: location.as_json }
        else
          render status: 422, json: { message: location.errors.full_messages.to_sentence }
        end
      end
    end
  end
end

