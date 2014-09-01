module AnnotateYaml
  require 'yaml'

  DEFAULT_YML_LOOKUP = 'config/locales/*.yml'

  class YamlHashExplorer
    attr_reader :result

    def initialize(hash)
      @result = []
      yaml_navigation(hash, [])
    end

    private

    def yaml_navigation(yaml_hash, keys_array_origin)
      yaml_hash.each do |key, value|
        keys_array_updated = keys_array_origin.dup
        keys_array_updated.push(key)
        result.push({ value => keys_array_updated.join('.') }) if desired_terminatory_value?(value)

        yaml_navigation(value, keys_array_updated) if value.is_a?(Hash)
      end
    end

    def desired_terminatory_value?(value)
      !(value.nil? || value.is_a?(Hash) || value.is_a?(Array))
    end
  end

  class FileHandler

    attr_reader :file_name, :result

    def initialize(file_name)
      @file_name = file_name
      @result = ""
    end

    def call
      create_annotated_text
      rewrite_file
    end

    private

    def create_annotated_text
      adapted_file_content.each_line do |line|
        annotate_line(line)
      end
    end

    def annotate_line(line)
      begin
        if line_hash = YAML::load(line)
          _, line_value = line_hash.first

          if line_value.nil?
            result << line
          else
            key, value = current_hash.first
            if line_value == key
              result << annotation_for_line(line, value)
            else
              result << line
            end
          end
        else
          result << line
        end
      # YAML::load will generate an exception when references are used inside the yaml file. Exemple: errors: &errors
      rescue Psych::BadAlias
        result << line
      end
    end

    def annotation_for_line(line, value)
      (line.end_with?(" \# #{value}\n") ? line : line.gsub("\n", '') + " \# #{value}\n")
    end

    def rewrite_file
      File.open(file_name, "w+") do |f|
        f.write(result)
      end
    end

    def adapted_file_content
      File.open(file_name).read.gsub(/\r\n?/, "\n")
    end

    def hash_content
      # Remove the references inside the yaml file otherwise the hash will be duplicated at each reference, and we don't want that.
      # Exemple of reference: <<: *errors
      YAML.load(File.open(file_name).read.gsub(/<<: \*.*/, ''))
    end

    def array_of_hashes_of_values_with_keys
      @array_of_hashes_of_values_with_keys ||= YamlHashExplorer.new(hash_content).result
    end

    def current_hash
      array_of_hashes_of_values_with_keys.shift
    end
  end

  class << self
    def annotate_locales
      file_names.each do |file_name|
        FileHandler.new(file_name).call
      end
    end

    def file_names
      Dir.glob(DEFAULT_YML_LOOKUP)
    end
  end

end
