require "annotate_yaml/version"
require "annotate_yaml/annotate_yaml"

module AnnotateYaml
  require 'annotate_yaml/railtie' if defined?(Rails)
end
