require 'rails_helper'
require 'rake'

describe 'Merge_avatar' do

  before { Faceit::Application.load_tasks }

  it { expect { Rake::Task['merge_avatar:add_object_img'].invoke }.not_to raise_exception }

end