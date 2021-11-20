module Api
  module V1
    class LocationsController < ApplicationController
      
      def create
        location = Location.create(lat: params[:lat], lng: params[:lng])

        if location
          render status: :created, json: { location: location.as_json }
        else
            render status: 500, json: { message: location.errors.full_messages.to_sentence }
        end
      end
    end
  end
end

