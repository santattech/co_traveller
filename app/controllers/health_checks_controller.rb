class HealthChecksController < ApplicationController
  def index
    heath = {}

    heath[:postgres] = true

    if heath.values.all? { |h| h == true }
      ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
      ipadd = ip.ip_address if ip
      time = Time.now.strftime("%FT%T%:z")
      render status: 200, json: { message: "Aaaaal is well from #{ipadd} at #{time}" }
    else
      message = heath.select{|k, v| v == false}.keys.to_sentence
      render status: 500, json: { message: message }
    end
  end

  def test_api
    heath = {}
    heath[:postgres] = DataProvider.hdb.present?

    if heath.values.all? { |h| h == true }
      ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
      ipadd = ip.ip_address if ip
      time = Time.now.strftime("%FT%T%:z")
      render status: 200, json: { message: "test api v5 from #{ipadd} at #{time}" }
    else
      message = heath.select{|k, v| v == false}.keys.to_sentence
      render status: 500, json: { message: message }
    end
  end
end
