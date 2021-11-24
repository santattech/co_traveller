module Api
  module V1
    class LocationsController < ApplicationController
      
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
    end
  end
end

