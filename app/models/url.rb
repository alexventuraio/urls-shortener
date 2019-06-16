require 'digest'

class Url < ApplicationRecord
  validates :original, presence: true, on: :create
  validates :original, format: URI::regexp(%w(http https))

  before_create :generate_short_url

  private

  def generate_short_url
    url = self.original.split('://').last
    self.short = Digest::SHA256.hexdigest(url)[0..9]
  end
end
