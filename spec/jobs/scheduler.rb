require 'rails_helper'

describe Rufus::Scheduler do

  before :each do
    @scheduler = Rufus::Scheduler.new
  end

  after :each do
    @scheduler.shutdown
  end

  it 'returns the list of scheduled jobs' do
    @scheduler.in '1d' do; end
    @scheduler.in '10d' do; end
    @scheduler.in '1w' do; end
    sleep(1)
    jobs = @scheduler.jobs
    expect(jobs.collect { |j| j.original }.sort).to eq(%w[ 1d 10d 1w ])
  end
  it 'accepts jobs' do
    job = @scheduler.schedule_in '1d' do; end
    expect(job.unscheduled_at).to eq(nil)
    @scheduler.unschedule(job)
    expect(job.unscheduled_at).not_to eq(nil)
  end

end

describe '#repeat' do

  before :each do
    @scheduler = Rufus::Scheduler.new
  end

  after :each do
    @scheduler.shutdown
  end

  it 'accepts a duration and schedules an EveryJob' do
    j = @scheduler.repeat '1d' do; end
    expect(j.class).to eq(Rufus::Scheduler::EveryJob)
  end

  it 'accepts a cron string and schedules a CronJob' do
    j = @scheduler.repeat '* * * * *' do; end
    expect(j.class).to eq(Rufus::Scheduler::CronJob)
  end

end