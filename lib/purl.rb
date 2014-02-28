require 'pry'
require 'singleton'
require 'net/http'
require 'uri'
require 'cgi'
require 'openssl'
require 'msgpack'

require 'purl/version'

class Purl
  include Singleton

  MAXTIME = 45 # timeout in seconds to complete parallel get

  class ConfigError < StandardError; end
  class FetchError < StandardError; end
  class ConnectionError < FetchError; end

  class << self
    attr_accessor :service_uri, :maxtime

    def get(urls, options={})
      instance.get(urls, options)
    end
  end

  def initialize
    if self.class.service_uri.nil?
      raise ConfigError.new("You must set Purl.service_uri")
    end
    self.class.service_uri = URI.parse(service_uri)
    self.class.maxtime ||= MAXTIME # set default timeout
  end

  def http
    Thread.current[:purlconn] ||= Net::HTTP.new(service_uri.host, service_uri.port)
  end

  def get(urls, options={})
    q = urls.map {|u| "url[]=#{CGI.escape(u)}" }.join('&')
    uri = "#{service_uri}/fetch?#{q}"
    obj = nil

    begin
      resp = http.get(uri, {})
      if resp.header['Content-Type'].index('x-msgpack')
        obj = MessagePack.unpack(resp.body)
      else
        obj = resp.body
      end
    rescue => ex
      raise FetchError.new(ex.inspect)
    end

    if resp.code.to_i != 200
      raise FetchError.new("Server responded with #{resp.code}")
    end

    obj
  end


  private

    def service_uri
      self.class.service_uri
    end

end
