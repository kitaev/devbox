require 'yaml'
require 'vagrant/util/deep_merge'

module DevBox
  class Config
    attr_reader :files, :data

    def initialize(files)
      @files = files.respond_to?( 'map' ) ? files : [ files ]
      @data  = @files.select { |file| File.exist? file }.map { | file | YAML.load_file file }.reduce({}) { |memo, obj| Vagrant::Util::DeepMerge.deep_merge(memo, obj) }
    end

    def get(key='', default_value=nil)
      keys = key.split('.')
      value = self.data
      keys.each { |k|
        if value.nil?
          return default_value
        end
        value = value[k]
      }
      value.nil? ? default_value : value
    end
  end
end