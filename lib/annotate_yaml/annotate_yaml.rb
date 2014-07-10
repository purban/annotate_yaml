module AnnotateYaml
  require 'yaml'

  class << self
    def annotate_locales

      files = Dir.glob("config/locales/*.yml")
      files.each do |file|
        complete_yaml_file = File.open(file).read
        # Remove the references
        complete_yaml_file_without_references = complete_yaml_file.gsub(/<<: \*.*/, '')
        yaml_hash = YAML::load(complete_yaml_file_without_references)
        array_of_hashes_of_values_with_keys = []
        yaml_navigation(yaml_hash, [], array_of_hashes_of_values_with_keys)

        string_result = ''

        text = File.open(file).read
        text.gsub!(/\r\n?/, "\n")
        current_hash = array_of_hashes_of_values_with_keys.shift
        text.each_line do |line|
          begin
            line_hash = YAML::load line
          rescue Exception => e
            string_result += line
            next
          end
          if line_hash === false
            string_result += line
          else
            line_key, line_value = line_hash.first
            key, value = current_hash.first
            if line_value == key
              string_result += (line.end_with?(" \# #{value}\n") ? line : line.gsub("\n", '') + " \# #{value}\n")
              current_hash = array_of_hashes_of_values_with_keys.shift
            else
              string_result += line
            end
          end

          File.open(file, "w+") do |f|
            f.write(string_result)
          end
        end
      end
    end

    def yaml_navigation(yaml_hash, keys_array_origin = [], result = [])
      yaml_hash.each do |key, value|
        keys_array_updated = keys_array_origin.dup
        keys_array_updated.push(key)
        result.push({ value => keys_array_updated.join('.') }) unless value.nil? || value.is_a?(Hash) || value.is_a?(Array)
        yaml_navigation value, keys_array_updated, result if value.is_a?(Hash)
      end
    end
  end

end
