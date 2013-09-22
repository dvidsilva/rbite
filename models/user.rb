class User
  include MongoMapper::Document
  key :name, String
  key :email, String
  key :lastName, String
  key :firstName, String
  key :headline, String
  key :lid, String
  key :loc, String
  key :threePastPositions, Hash

  has_many :locations
  has_many :skills
  ensure_index [[:loc, '2d']]
  ensure_index :lid

  timestamps!

    def self.nearest(query)
      case query
        when Array
          location = query
        when String
          geo = Geokit::Geocoders::MultiGeocoder.geocode(location)
          if geo.lat.nil?
            # Return a default location, the geocoder couldn't find it.
            # How about New York City?
            location = [-73.98,40.77]
          else
            location = [geo.long, geo.lat]
          end
          where(:location => {'$near' => location}).limit(1).first
        end
    end

end
