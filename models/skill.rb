class Skill
  include MongoMapper::Document
  # key <name>, <type>
  key :name, String
  key :lid, String
  belongs_to :user
  timestamps!
end

