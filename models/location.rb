class Location
  include MongoMapper::Document
  # key <name>, <type>
  key :cord, Array
  key :lid, String
  belongs_to :user
  ensure_index [[:cord, '2d']]
  timestamps!
end

