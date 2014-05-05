require 'pizzabox'

module PizzaBox::Config

  require 'yaml'
  require 'json'
  require 'pathname'

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
          "/etc/pizzabox/pizzabox.conf"
      ]

      config_parameters = JSON.parse(%x(pizzabox-config))
      results.unshift(
          Pathname.new(config_parameters["sysconfdir"]) + "pizzabox.conf"
      )

      return results
  end

  def load!
      for f in self.possible_file_names
          begin
              self.load_from_file!(f)
              return
          rescue Errno::ENOENT
              next
          end
      end
  end

  def load_from_file!(filename)
    @settings = YAML::load_file(filename)
  end

end
