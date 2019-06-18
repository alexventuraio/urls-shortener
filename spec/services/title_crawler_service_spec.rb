require 'rails_helper'

#@TODO: Implement VCR to speed up tests

describe TitleCrawlerService do
  let(:crawler_service) { described_class.new('https://www.google.com/') }

  describe '#initialize' do
    it 'has a valid URL' do
      expect(crawler_service.source_url).to_not be_nil
      expect(crawler_service.source_url).to eq('https://www.google.com/')
    end
  end

  describe '#call' do
    it 'returns Google as the name for given site URL' do
      result_data = crawler_service.call

      expect(result_data).to_not be_nil
      expect(result_data).to eq('Google')
    end

    it 'returns Facebook as the name for given site URL' do
      crawler_service.source_url = 'https://www.youtube.com/'
      result_data = crawler_service.call

      expect(result_data).to_not be_nil
      expect(result_data).to eq('YouTube')
    end
  end
end
