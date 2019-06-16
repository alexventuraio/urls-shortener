require 'rails_helper'

RSpec.describe Url, type: :model do
  let(:url) { create(:url) }

  context 'validations' do
    it 'is valid with a valid url' do
      expect(url).to be_valid
    end

    it 'is invalid without a url' do
      url = build(:url, original: nil)
      expect(url).not_to be_valid
      expect(url.errors[:original]).to include("can't be blank")
      expect(url.errors[:original]).to include('is invalid')
    end

    it 'is invalid with an invalid URL' do
      url = build(:url, original: 'something')
      expect(url).not_to be_valid
      expect(url.errors[:original]).to include('is invalid')
    end
  end

  context 'create a new url' do
    it 'should not be the same url' do
      expect(url.short).not_to eq(url.original)
    end

    it 'should have only 10 characters' do
      expect(url.short.size).to be(10)
      expect(url.short).to eq('1221a604eb')
    end
  end

  describe 'method' do
    it '#generate_short_url generates a 10-char string containing only letters and numbers' do
      expect(url.short).to match(/\A[a-z\d]{10}\z/i)
    end
  end
end

