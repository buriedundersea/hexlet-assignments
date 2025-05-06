# frozen_string_literal: true

# BEGIN
require 'uri'
require 'forwardable'

class Url
  extend Forwardable
  include Comparable

  attr_accessor :url

  def initialize(url)
    @url = URI(url)
  end

  def_delegators :@url, :host, :port, :scheme


  def <=>(other)
    sorted_url <=> other.sorted_url
  end

  def sorted_url
    [] << url.scheme << url.host << url.port << url.path << params.sort.join << url.fragment
  end

  def params
    params = url.query.nil? ? "" : url.query
    URI.decode_www_form(params)
  end

  def query_params
    Hash[params.map { |k, v| [k.to_sym, v] }]
  end

  def query_param(key, value = nil)
    query_params.fetch(key, value)
  end
end
# END
