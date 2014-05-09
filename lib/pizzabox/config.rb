require 'pizzabox'

module PizzaBox::Config

  require 'yaml'
  require 'json'
  require 'pathname'

  class ConfigNotFound < RuntimeError; end

  # This is a singleton, aka self-extended module
  extend self

  @settings = {}
  attr_reader :settings

  def possible_file_names
      results = [
          "./.pizzaboxrc",
          "/usr/local/etc/pizzabox.conf",
          "/usr/local/etc/pizzabox/pizzabox.conf",
          "/etc/pizzabox.conf",
          "/etc/pizzabox/pizzabox.conf",
          Pathname.new($0).dirname + "pizzabox.conf"
      ]

      begin
        config_parameters = JSON.parse(%x(pizzabox-config))
        results.unshift(
          Pathname.new(config_parameters["sysconfdir"]) + "pizzabox.conf"
        )
      rescue Errno::ENOENT
          # Oh well; try to move on.
      end

      return results
  end

  def load!
      possible = self.possible_file_names

      for f in possible
          begin
              self.load_from_file!(f)
              return
          rescue Errno::ENOENT
              next
          end
      end

      raise ConfigNotFound,
         "Could not find any config to load. Tried: " + possible.join(", ")
  end

  def load_from_file!(filename)
    @settings = YAML::load_file(filename)
  end

end
