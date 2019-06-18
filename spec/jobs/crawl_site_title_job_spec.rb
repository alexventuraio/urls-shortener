require 'rails_helper'

RSpec.describe CrawlSiteTitleJob, type: :job do
  include ActiveJob::TestHelper

  ActiveJob::Base.queue_adapter = :test

  let!(:url) { create(:url, original: 'https://www.youtube.com/') }

  subject(:job) { described_class.perform_later(url.id) }

  it 'queues the job' do
    expect { job }.to change(
      ActiveJob::Base.queue_adapter.enqueued_jobs, :size
    ).by(1)
  end

  it 'queues the job in specific queue' do
    expect { job }.to have_enqueued_job(described_class)
      .with(url.id)
      .on_queue('default')
  end

  it 'is in default queue' do
    expect(described_class.new.queue_name).to eq('default')
  end

  it 'matches with enqueued job' do
    expect { job }.to have_enqueued_job(CrawlSiteTitleJob)

    expect {
      described_class.perform_later(url.id)
    }.to have_enqueued_job.with(url.id)
  end

  it 'executes perform' do
    expect(Url.count).to eq(1)
    expect(Url.last.title).to be_nil

    # After the job finishes, the title attribute must be updated
    perform_enqueued_jobs { job }

    expect(Url.last.title).to eq('YouTube')
  end
end
