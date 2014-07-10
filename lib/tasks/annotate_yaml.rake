namespace :annotate do
  namespace :yaml do
    desc "Annotate keys of YAML files inside config/locales/*.yml"
    task locales: :environment do

      AnnotateYaml.annotate_locales

    end
  end
end
