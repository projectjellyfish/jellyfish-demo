# desc "Explaining what the task does"
# task :jellyfish_demo do
#   # Task goes here
# end

def sample_data(file)
  puts "-- Loading #{file.titlecase}"
  data = YAML.load_file(File.join [JellyfishDemo::Engine.root, 'db', 'data', 'sample', [file, 'yml'].join('.')])
  return data unless block_given?
  data.each { |d| yield d }
end

namespace :sample do
  desc 'Generates demo data'
  task demo: :environment do
    providers = sample_data('providers').map do |data|
      reg_provider = RegisteredProvider.find_by uuid: data.delete('registered_provider')
      data.merge! registered_provider: reg_provider
      puts "  #{data['name']}"
      [data.delete('_assoc'), Provider.create(data)]
    end
  end
end
