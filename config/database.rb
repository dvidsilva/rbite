MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)

case Padrino.env
  when :development then MongoMapper.database = 'swapi_development'
  when :production  then MongoMapper.database = 'swapi_production'
  when :test        then MongoMapper.database = 'swapi_test'
end
