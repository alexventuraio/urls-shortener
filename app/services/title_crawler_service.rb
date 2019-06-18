require 'open-uri'

class TitleCrawlerService
  attr_accessor :source_url

  def initialize(source_url)
    @source_url = source_url
  end

  def call
    begin
      Nokogiri::HTML(open(@source_url.to_s)).css('title').text || 'Unknown'
    rescue StandardError => e
      Rails.logger.error "Something went wrong with TitleCrawler service: #{e.to_s}"
      nil
    end
  end
end
