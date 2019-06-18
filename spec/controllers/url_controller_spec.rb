require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  let(:url) { create(:url, original: 'https://www.google.com.mx') }

  describe 'GET #index' do
    subject { get :index }

    it 'assigns a new Url instance to @url' do
      urls = Url.all.order(clicks_count: :desc)
      get :index
      #expect(assigns(:url)).to be_a_new(Url)
      expect(assigns(:urls)).to all(be_a(Url))
      expect(assigns(:urls)).to eq(urls)
    end

    it 'has a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #redirect' do
    it 'assigns the requested url to @url' do
      get :redirect, params: { short_url: url.short }
      expect(assigns(:url)).to eq url
    end

    it 'increases the click_count when visiting the short url' do
      expect(url.clicks_count).to eq(0)

      get :redirect, params: { short_url: url.short }

      expect(assigns(:url)).to eq url
      expect(assigns(:url).clicks_count).to eq(1)
    end

    it 'redirects to the original url' do
      get :redirect, params: { short_url: url.short}
      expect(response).to redirect_to(url.original)
    end

    it 'has a 302 status code' do
      get :redirect, params: { short_url: url.short}
      expect(response.status).to eq(302)
    end

    it 'renders index if the URL does not exist' do
      get :redirect, params: { short_url: 'something' }
      expect(response).to render_template(:index)
    end

    it 'renders show a flash message if the URL does not exist' do
      get :redirect, params: { short_url: 'trhj3g42op' }
      expect(controller).to set_flash
      expect(controller).to set_flash.now[:alert].to(/The given URL does not exist!/)
      expect(flash[:alert]).to match(/The given URL does not exist!/)
    end
  end

  describe 'POST #create' do
    let(:url) { create(:url, original: 'http://alexventura.io') }

    context "with valid attributes" do
      context "with a brand new url" do
        it 'returns a corresponding shortened url' do
          post :create, params: { url: attributes_for(:url) }

          expect(response.status).to eq(200)
          expect(assigns(:saved_url)).to eq("#{request.base_url}/#{url.short}")
        end

        it 'show successful flash messages' do
          post :create, params: { url: attributes_for(:url) }

          expect(controller).to set_flash
          expect(flash[:notice]).to match(/Your shortened URL has been created!/)
        end
      end

      context "with an existing url in the database" do
        before :each do
          existing_url = create(:url, original: 'http://alexventura.io')
          existing_url.save!
        end

        it "does not create a new url record" do
          expect{
            post :create, params: { url: attributes_for(:url) }
          }.to_not change(Url, :count)
        end

        it "redirects to the existing url shortened page" do
          post :create, params: { url: attributes_for(:url) }
          expect(response).to render_template :index
          expect(controller).to set_flash
          expect(flash[:notice]).to match(/Your shortened URL has been created!/)
        end
      end
    end

    context "with invalid attributes" do
      it 'returns an error if orinal url does not match model validations' do
        post :create, params: {url: {original: 'something.com' }}

        expect(assigns(:saved_url)).to be_falsey
      end

      it "does not create a new url entry" do
        expect{
          post :create, params: { url: attributes_for(:url, original: nil) }
        }.to_not change(Url, :count)
      end

      it "renders the :index template" do
        post :create, params: { url: attributes_for(:url, original: nil) }
        expect(response).to render_template :index
      end

      it 'show a flash message if original URL does not meet validations' do
        post :create, params: {url: {original: 'something.com' }}

        expect(controller).to set_flash
        expect(flash[:alert]).to match(/Original is invalid/)
      end
    end
  end
end
