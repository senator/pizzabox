require 'pizzabox'

module PizzaBox::Config

  require 'yaml'

  # This is a singleton, aka self-extended module
  extend self

  @settings = {}
  attr_reader :settings

  # This is the main point of entry - we call Settings.load! and provide
  # a name of the file to read as it's argument. We can also pass in some
  # options, but at the moment it's being used to allow per-environment
  # overrides in Rails
  def load!(filename, options = {})
    @settings = YAML::load_file(filename)
  end

end
