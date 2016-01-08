# desc "Explaining what the task does"
# task :jellyfish_demo do
#   # Task goes here
# end

require File.dirname(__FILE__) + '/../../app/services/dataset.rb'

namespace :demo do
  desc 'Generates generic demo data'
  task generic: :environment do
    JellyfishDemo::Dataset.load_generic_dataset
  end
end