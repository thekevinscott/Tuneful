# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mongo_mapper}
  s.version = "0.6.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Nunemaker"]
  s.date = %q{2010-01-01}
  s.default_executable = %q{mmconsole}
  s.email = %q{nunemaker@gmail.com}
  s.executables = ["mmconsole"]
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = [".gitignore", "LICENSE", "README.rdoc", "Rakefile", "VERSION", "bin/mmconsole", "lib/mongo_mapper.rb", "lib/mongo_mapper/associations.rb", "lib/mongo_mapper/associations/base.rb", "lib/mongo_mapper/associations/belongs_to_polymorphic_proxy.rb", "lib/mongo_mapper/associations/belongs_to_proxy.rb", "lib/mongo_mapper/associations/collection.rb", "lib/mongo_mapper/associations/in_array_proxy.rb", "lib/mongo_mapper/associations/many_documents_as_proxy.rb", "lib/mongo_mapper/associations/many_documents_proxy.rb", "lib/mongo_mapper/associations/many_embedded_polymorphic_proxy.rb", "lib/mongo_mapper/associations/many_embedded_proxy.rb", "lib/mongo_mapper/associations/many_polymorphic_proxy.rb", "lib/mongo_mapper/associations/one_proxy.rb", "lib/mongo_mapper/associations/proxy.rb", "lib/mongo_mapper/callbacks.rb", "lib/mongo_mapper/dirty.rb", "lib/mongo_mapper/document.rb", "lib/mongo_mapper/dynamic_finder.rb", "lib/mongo_mapper/embedded_document.rb", "lib/mongo_mapper/finder_options.rb", "lib/mongo_mapper/key.rb", "lib/mongo_mapper/mongo_mapper.rb", "lib/mongo_mapper/pagination.rb", "lib/mongo_mapper/rails_compatibility/document.rb", "lib/mongo_mapper/rails_compatibility/embedded_document.rb", "lib/mongo_mapper/serialization.rb", "lib/mongo_mapper/serializers/json_serializer.rb", "lib/mongo_mapper/support.rb", "lib/mongo_mapper/validations.rb", "mongo_mapper.gemspec", "specs.watchr", "test/NOTE_ON_TESTING", "test/functional/associations/test_belongs_to_polymorphic_proxy.rb", "test/functional/associations/test_belongs_to_proxy.rb", "test/functional/associations/test_in_array_proxy.rb", "test/functional/associations/test_many_documents_as_proxy.rb", "test/functional/associations/test_many_documents_proxy.rb", "test/functional/associations/test_many_embedded_polymorphic_proxy.rb", "test/functional/associations/test_many_embedded_proxy.rb", "test/functional/associations/test_many_polymorphic_proxy.rb", "test/functional/associations/test_one_proxy.rb", "test/functional/test_associations.rb", "test/functional/test_binary.rb", "test/functional/test_callbacks.rb", "test/functional/test_dirty.rb", "test/functional/test_document.rb", "test/functional/test_embedded_document.rb", "test/functional/test_logger.rb", "test/functional/test_modifiers.rb", "test/functional/test_pagination.rb", "test/functional/test_rails_compatibility.rb", "test/functional/test_string_id_compatibility.rb", "test/functional/test_validations.rb", "test/models.rb", "test/support/custom_matchers.rb", "test/support/timing.rb", "test/test_helper.rb", "test/unit/associations/test_base.rb", "test/unit/associations/test_proxy.rb", "test/unit/serializers/test_json_serializer.rb", "test/unit/test_document.rb", "test/unit/test_dynamic_finder.rb", "test/unit/test_embedded_document.rb", "test/unit/test_finder_options.rb", "test/unit/test_key.rb", "test/unit/test_mongo_mapper.rb", "test/unit/test_pagination.rb", "test/unit/test_rails_compatibility.rb", "test/unit/test_serializations.rb", "test/unit/test_support.rb", "test/unit/test_time_zones.rb", "test/unit/test_validations.rb"]
  s.homepage = %q{http://github.com/jnunemaker/mongomapper}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Awesome gem for modeling your domain and storing it in mongo}
  s.test_files = ["test/functional/associations/test_belongs_to_polymorphic_proxy.rb", "test/functional/associations/test_belongs_to_proxy.rb", "test/functional/associations/test_in_array_proxy.rb", "test/functional/associations/test_many_documents_as_proxy.rb", "test/functional/associations/test_many_documents_proxy.rb", "test/functional/associations/test_many_embedded_polymorphic_proxy.rb", "test/functional/associations/test_many_embedded_proxy.rb", "test/functional/associations/test_many_polymorphic_proxy.rb", "test/functional/associations/test_one_proxy.rb", "test/functional/test_associations.rb", "test/functional/test_binary.rb", "test/functional/test_callbacks.rb", "test/functional/test_dirty.rb", "test/functional/test_document.rb", "test/functional/test_embedded_document.rb", "test/functional/test_logger.rb", "test/functional/test_modifiers.rb", "test/functional/test_pagination.rb", "test/functional/test_rails_compatibility.rb", "test/functional/test_string_id_compatibility.rb", "test/functional/test_validations.rb", "test/models.rb", "test/support/custom_matchers.rb", "test/support/timing.rb", "test/test_helper.rb", "test/unit/associations/test_base.rb", "test/unit/associations/test_proxy.rb", "test/unit/serializers/test_json_serializer.rb", "test/unit/test_document.rb", "test/unit/test_dynamic_finder.rb", "test/unit/test_embedded_document.rb", "test/unit/test_finder_options.rb", "test/unit/test_key.rb", "test/unit/test_mongo_mapper.rb", "test/unit/test_pagination.rb", "test/unit/test_rails_compatibility.rb", "test/unit/test_serializations.rb", "test/unit/test_support.rb", "test/unit/test_time_zones.rb", "test/unit/test_validations.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3"])
      s.add_runtime_dependency(%q<mongo>, ["= 0.18.2"])
      s.add_runtime_dependency(%q<jnunemaker-validatable>, ["= 1.8.1"])
      s.add_development_dependency(%q<jnunemaker-matchy>, ["= 0.4.0"])
      s.add_development_dependency(%q<shoulda>, ["= 2.10.2"])
      s.add_development_dependency(%q<timecop>, ["= 0.3.1"])
      s.add_development_dependency(%q<mocha>, ["= 0.9.8"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.3"])
      s.add_dependency(%q<mongo>, ["= 0.18.2"])
      s.add_dependency(%q<jnunemaker-validatable>, ["= 1.8.1"])
      s.add_dependency(%q<jnunemaker-matchy>, ["= 0.4.0"])
      s.add_dependency(%q<shoulda>, ["= 2.10.2"])
      s.add_dependency(%q<timecop>, ["= 0.3.1"])
      s.add_dependency(%q<mocha>, ["= 0.9.8"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.3"])
    s.add_dependency(%q<mongo>, ["= 0.18.2"])
    s.add_dependency(%q<jnunemaker-validatable>, ["= 1.8.1"])
    s.add_dependency(%q<jnunemaker-matchy>, ["= 0.4.0"])
    s.add_dependency(%q<shoulda>, ["= 2.10.2"])
    s.add_dependency(%q<timecop>, ["= 0.3.1"])
    s.add_dependency(%q<mocha>, ["= 0.9.8"])
  end
end
