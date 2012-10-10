require 'helper'
require 'thread'
require 'active_record'
require 'arel'

class ParserTest < Test::Unit::TestCase
  setup do
    ActiveRecord::Base.establish_conntection({
      :adapter => 'sqlite',
      :host => ':memory:',
      :verbosity => 'quiet'
    })
    Arel::Table.engine = Arel::Sql::Engine.new(ActiveRecord::Base)
  end
end
