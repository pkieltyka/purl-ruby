begin
  require 'msgpack'
rescue LoadError
  $stderr.puts "Sorry, cannot load 'purls' gem. Make sure you specify in your Gemfile:"
  $stderr.puts "gem 'msgpack', platform: :mri"
  $stderr.puts "gem 'msgpack-jruby', platform: :jruby"
  exit!
end

require 'net/http'
require 'uri'
require 'cgi'
require 'openssl'

require 'purls/version'

class Purls
  MAXTIME = 45 # timeout in seconds to complete parallel get

  class ConfigError < StandardError; end
  class SocketError < StandardError; end
  class FetchError < StandardError; end

  class << self
    attr_accessor :service_uri, :maxtime

    def instance
      Thread.current[:purls_instance] ||= self.new
    end

    def get(urls, options={})
      instance.get(urls, options)
    end
  end

  def initialize
    if self.class.service_uri.nil?
      raise ConfigError.new("You must set Purls.service_uri")
    end
    self.class.service_uri = URI.parse(service_uri) if service_uri.is_a?(String)
    self.class.maxtime ||= MAXTIME # set default timeout
  end

  def http
    @http ||= Net::HTTP.new(service_uri.host, service_uri.port)
  end

  def get(urls, options={})
    maxtime = options[:maxtime] || self.class.maxtime
    q = urls.map {|u| "url[]=#{CGI.escape(u)}" rescue nil }.compact.join('&')
    return [] if q.empty?

    uri = service_uri.dup
    uri.path = '/fetch'
    uri.query = q + "&maxtime=#{maxtime}"

    obj = nil
    begin
      resp = http.get(uri.to_s, {})
      if resp.header['Content-Type'].index('x-msgpack')
        obj = MessagePack.unpack(resp.body)
      else
        obj = resp.body
      end
    rescue => ex
      raise SocketError.new(ex.inspect)
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
