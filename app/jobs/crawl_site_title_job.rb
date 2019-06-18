class CrawlSiteTitleJob < ApplicationJob
  queue_as :default

  def perform(site_id)
    Rails.logger.error "Starting background process on CrawlSiteTitleJob job, site_id: #{site_id}"
    site = Url.find_by_id(site_id)
    site_title = TitleCrawlerService.new(site.original).call
    site.title = site_title
    site.save!
  end
end
