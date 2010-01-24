# DO NOT MODIFY THIS FILE
module Bundler
 file = File.expand_path(__FILE__)
 dir = File.dirname(file)

  ENV["GEM_HOME"] = dir
  ENV["GEM_PATH"] = dir

  # handle 1.9 where system gems are always on the load path
  if defined?(::Gem)
    $LOAD_PATH.reject! do |p|
      p != File.dirname(__FILE__) &&
        Gem.path.any? { |gp| p.include?(gp) }
    end
  end

  ENV["PATH"]     = "#{dir}/../../../../bin:#{ENV["PATH"]}"
  ENV["RUBYOPT"]  = "-r#{file} #{ENV["RUBYOPT"]}"

  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/youtube-g-0.5.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/youtube-g-0.5.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activesupport-2.3.5/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activesupport-2.3.5/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/jnunemaker-validatable-1.8.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/jnunemaker-validatable-1.8.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mongo-0.18.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mongo-0.18.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mongo_mapper-0.6.10/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mongo_mapper-0.6.10/lib")

  @gemfile = "#{dir}/../../../../Gemfile"

  require "rubygems" unless respond_to?(:gem) # 1.9 already has RubyGems loaded

  @bundled_specs = {}
  @bundled_specs["youtube-g"] = eval(File.read("#{dir}/specifications/youtube-g-0.5.0.gemspec"))
  @bundled_specs["youtube-g"].loaded_from = "#{dir}/specifications/youtube-g-0.5.0.gemspec"
  @bundled_specs["activesupport"] = eval(File.read("#{dir}/specifications/activesupport-2.3.5.gemspec"))
  @bundled_specs["activesupport"].loaded_from = "#{dir}/specifications/activesupport-2.3.5.gemspec"
  @bundled_specs["jnunemaker-validatable"] = eval(File.read("#{dir}/specifications/jnunemaker-validatable-1.8.1.gemspec"))
  @bundled_specs["jnunemaker-validatable"].loaded_from = "#{dir}/specifications/jnunemaker-validatable-1.8.1.gemspec"
  @bundled_specs["mongo"] = eval(File.read("#{dir}/specifications/mongo-0.18.2.gemspec"))
  @bundled_specs["mongo"].loaded_from = "#{dir}/specifications/mongo-0.18.2.gemspec"
  @bundled_specs["mongo_mapper"] = eval(File.read("#{dir}/specifications/mongo_mapper-0.6.10.gemspec"))
  @bundled_specs["mongo_mapper"].loaded_from = "#{dir}/specifications/mongo_mapper-0.6.10.gemspec"

  def self.add_specs_to_loaded_specs
    Gem.loaded_specs.merge! @bundled_specs
  end

  def self.add_specs_to_index
    @bundled_specs.each do |name, spec|
      Gem.source_index.add_spec spec
    end
  end

  add_specs_to_loaded_specs
  add_specs_to_index

  def self.require_env(env = nil)
    context = Class.new do
      def initialize(env) @env = env && env.to_s ; end
      def method_missing(*) ; yield if block_given? ; end
      def only(*env)
        old, @only = @only, _combine_only(env.flatten)
        yield
        @only = old
      end
      def except(*env)
        old, @except = @except, _combine_except(env.flatten)
        yield
        @except = old
      end
      def gem(name, *args)
        opt = args.last.is_a?(Hash) ? args.pop : {}
        only = _combine_only(opt[:only] || opt["only"])
        except = _combine_except(opt[:except] || opt["except"])
        files = opt[:require_as] || opt["require_as"] || name
        files = [files] unless files.respond_to?(:each)

        return unless !only || only.any? {|e| e == @env }
        return if except && except.any? {|e| e == @env }

        if files = opt[:require_as] || opt["require_as"]
          files = Array(files)
          files.each { |f| require f }
        else
          begin
            require name
          rescue LoadError
            # Do nothing
          end
        end
        yield if block_given?
        true
      end
      private
      def _combine_only(only)
        return @only unless only
        only = [only].flatten.compact.uniq.map { |o| o.to_s }
        only &= @only if @only
        only
      end
      def _combine_except(except)
        return @except unless except
        except = [except].flatten.compact.uniq.map { |o| o.to_s }
        except |= @except if @except
        except
      end
    end
    context.new(env && env.to_s).instance_eval(File.read(@gemfile), @gemfile, 1)
  end
end

module Gem
  @loaded_stacks = Hash.new { |h,k| h[k] = [] }

  def source_index.refresh!
    super
    Bundler.add_specs_to_index
  end
end
