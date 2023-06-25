require 'profiling'

module Api
  module V1
    class FuelEntriesController < BaseController
      skip_before_action :verify_authenticity_token, only: [:create]
      before_action :authenticate_request, only: [:index]

      def index
        fuel_entries = FuelEntry.all.order(:entry_date)
        render status: :ok, json: json_api_serializer_response(fuel_entries, params: {})
      end

      def create
      end
     

     
    end
  end
end