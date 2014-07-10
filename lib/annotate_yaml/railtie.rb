module AnnotateYaml
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/annotate_yaml.rake"
    end
  end
end
