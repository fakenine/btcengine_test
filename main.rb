require 'json'
require './btc_engine'

data = JSON.parse(File.open('data.json').read)

engine = BtcEngine.new(data)
engine.process!

output_file = File.open('output.json', 'w')
output_file.write(engine.serialize.to_json)
