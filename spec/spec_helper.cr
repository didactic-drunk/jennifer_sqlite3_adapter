require "spec"
require "json"
require "./jennifer_setup"
require "./models"
# require "factory"
require "./support/array_logger"

module Spec
  class_getter logger = ArrayLogger.new(STDOUT)

  def self.adapter
    Jennifer::Adapter.adapter
  end
end

def setup_jennifer
  Jennifer::Config.configure do |conf|
    conf.logger = Spec.logger
    conf.logger.level = Logger::DEBUG
    conf.user = "anyuser"
    conf.password = "anypassword"
    conf.host = "."
    conf.adapter = "sqlite3"
    conf.db = "test.db"
  end
end

def read_to_end(rs)
  rs.each do
    rs.column_names.size.times do
      rs.read
    end
  end
end

Spec.before_each do
  setup_jennifer
  Spec.adapter.begin_transaction
end

Spec.after_each do
  Spec.logger.clear
  Spec.adapter.rollback_transaction
end

setup_jennifer
