#mongo_uri = ENV['MONGOLAB_URI']
#db_name = mongo_uri[%r{/([^/\?]+)(\?|$)}, 1]
#
#MongoMapper.connection = Mongo::Connection.new(mongo_uri, nil, :logger => logger)
#
#case Padrino.env
#  when :development then MongoMapper.database = 'swapi_development'
#  when :production  then MongoMapper.database = 'swapi_production'
#  when :test        then MongoMapper.database = 'swapi_test'
#end
regex_match = /.*:\/\/(.*):(.*)@(.*):(.*)\//.match(ENV['MONGOLAB_URI'])
host = regex_match[3]
port = regex_match[4]
db_name = regex_match[1]
pw = regex_match[2]

MongoMapper.connection = Mongo::Connection.new(host, port)
MongoMapper.database = db_name
MongoMapper.database.authenticate(db_name, pw)

