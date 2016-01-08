module JellyfishDemo
  class DatasetController < JellyfishDemo::ApplicationController
    def self.load_generic
      JellyfishDemo::Dataset.load_generic_dataset
    end
  end
end
