module AnnotateYaml
  require 'yaml'

  class << self
    def annotate_locales

      files = Dir.glob("config/locales/*.yml")
      files.each do |file|
        thing = YAML.load_file(file)
        array_of_hashes_of_values_with_keys = []
        yaml_navigation(thing, [], array_of_hashes_of_values_with_keys)
        # puts array_of_hashes_of_values_with_keys.inspect

        string_result = ''

        text = File.open(file).read
        text.gsub!(/\r\n?/, "\n")
        current_hash = array_of_hashes_of_values_with_keys.shift
        text.each_line do |line|
          # puts "#{line}"

          line_hash = YAML::load line
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
        result.push({ value => keys_array_updated.join('.') }) unless value.nil? || value.is_a?(Hash)
        yaml_navigation value, keys_array_updated, result if value.is_a?(Hash)
      end
    end
  end

end
