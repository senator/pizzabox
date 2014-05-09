require 'active_record'
require 'mysql'

require 'pizzabox/config'

require 'minitest/autorun'

describe PizzaBox::Config do
  before do
    PizzaBox::Config.load!
  end

  describe "settings" do

    # I know this is terrible test code on many levels.  I'm just getting
    # started.  No I won't really have a set of specs that require MySQL to be
    # up, or that have other runtime dependencies.  I also won't really
    # test for "doesn't raise exception" when I get more serious.

    it "must provide enough info to connect to MySQL" do
      failed = false
      begin
        settings = PizzaBox::Config.settings

        ActiveRecord::Base.establish_connection({
          :adapter => 'mysql',
          :host => settings['database']['host'],
          :database => settings['database']['dbname'],
          :username => settings['database']['username'],
          :password => settings['database']['password']
        })
        ActiveRecord::Schema.define do
          create_table "stores", :force => true do |t|
            t.column "number", :integer
            t.column "phone", :text
          end
        end
      rescue Exception => e
        failed = true
      end

      assert(not(failed), "connect and create table")
    end
  end
end
