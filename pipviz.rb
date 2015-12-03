require 'pp'
require 'json'
require_relative 'pipboy/db/database'
require_relative 'pipboy/db/updates'

STDOUT.sync = true
STDIN.sync = true

pipdb = Pipboy::DB::Database.new
obj_ref = (ARGV[0] || 0).to_i


until STDIN.eof? do
  message = JSON.parse(STDIN.gets)
  if message["type"] == "DATA_UPDATE"
    message["body"].each do |update_hash|
      update = case update_hash["type"]
      when "value"
        Pipboy::DB::Updates::Value.from_hash(update_hash)
      when "dictionary"
        Pipboy::DB::Updates::Dictionary.from_hash(update_hash)
      end
      pipdb.update(update)
    end
  end
end

pp pipdb.get(obj_ref)

