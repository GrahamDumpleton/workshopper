require 'yaml'
require 'digest/sha2'
require 'uri'

require 'workshopper/content'
require 'workshopper/loader'

module Workshopper

  class Workshop

    def initialize(url)
      @url = url
      @data = Workshopper::Loader.get(@url)
      @data = YAML.load(@data)
      @data['content'] ||= {}

      @id = @data['id']

      @content = Content.new(self)
    end

    def prefix
      content_url = ENV['CONTENT_URL_PREFIX']
      return content_url if content_url
      content_url = @data['content']['url'] || ''
      return content_url if !content_url.scan(URI.regexp).empty?
      File.join(File.dirname(@url), content_url)
    end

    def id
      @id ||= Digest::SHA256.hexdigest(@url)
    end

    def name
      @data['name']
    end

    def vars
      @data['vars']
    end

    def active_labs
      @data['modules']['activate']
    end

    def lab(name)
      @content.lab(name)
    end

    def issues
      @content.issues
    end

  end

end
