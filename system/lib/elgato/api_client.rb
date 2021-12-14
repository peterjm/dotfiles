#!/usr/bin/env ruby

require 'net/http'
require 'json'

module Elgato
  class ApiClient
    LIGHTS_PATH = "/elgato/lights"

    class Error < StandardError; end

    class Status
      attr_reader :on, :brightness, :temperature

      class << self
        def from_response(json_response)
          light = json_response["lights"][0]

          new(
            on: light["on"] == 1,
            brightness: light["brightness"],
            temperature: light["temperature"],
          )
        end
      end

      def initialize(on:, brightness:, temperature:)
        @on = on
        @brightness = brightness
        @temperature = temperature
      end
    end

    def initialize(ip_address: ENV["ELGATO_IP_ADDRESS"], port: 9123)
      raise Error, "no ip_address specified" unless ip_address && ip_address != ""
      @ip_address = ip_address
      @port = port
    end

    def status
      response = get(lights_uri)
      Status.from_response(response)
    end

    def toggle_light
      with_connection do |http|
        current_status = status

        if current_status.on
          turn_light_off
        else
          turn_light_on
        end
      end
    end

    def turn_light_on
      response = put(lights_uri, build_light_configuration_data(on: 1))
      Status.from_response(response)
    end

    def turn_light_off
      response = put(lights_uri, build_light_configuration_data(on: 0))
      Status.from_response(response)
    end

    private

    attr_reader :ip_address, :port, :connection

    def lights_uri
      URI::HTTP.build(host: ip_address, port: port, path: LIGHTS_PATH)
    end

    def build_light_configuration_data(on:)
      {
        numberOfLights: 1,
        lights: [{
          on: on,
        }]
      }
    end

    def get(uri)
      perform_request(:get, uri)
    end

    def put(uri, data = {})
      perform_request(:put, uri) do |request|
        request.body = data.to_json
      end
    end

    def connected?
      !!@connection
    end

    def with_connection
      Net::HTTP.start(ip_address, port, open_timeout: 1, read_timeout: 1) do |connection|
        @connection = connection
        yield
      end
    rescue Errno::EHOSTDOWN, Net::OpenTimeout
      raise Error, "couldn't connect to lights"
    ensure
      @connection = nil
    end

    def perform_request(method, uri, &block)
      if connected?
        perform_request_with_connection(method, uri, &block)
      else
        with_connection do
          perform_request_with_connection(method, uri, &block)
        end
      end
    end

    def perform_request_with_connection(method, uri, &block)
      request = build_request(method, uri)
      request['Content-Type'] = "application/json"
      block.call(request) if block_given?
      response = connection.request(request)

      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      else
        raise Error, response.body
      end

    end

    def build_request(method, uri)
      case method
      when :get
        Net::HTTP::Get.new(uri)
      when :put
        Net::HTTP::Put.new(uri)
      else
        raise ArgumentError, "unhandled method type: #{method}"
      end
    end
  end
end
