class User
    include MongoMapper::Document
    key :name, String
    key :email, String
    key :lastName, String
    key :firstName, String
    key :headline, String
    key :lid, String
    key :loc, Array
    key :threePastPositions, Hash
    key :everything, Hash
    key :pictureUrl, String

    has_many :locations
    has_many :skills
    ensure_index [[:loc, '2d']]
    ensure_index :lid

    timestamps!

    def self.nearest(query,range)
        case query
        when Array
            location = query
        when String
            geo = Geokit::Geocoders::MultiGeocoder.geocode(location)
            if geo.lat.nil?
                location = [-122, 37 ] #Berkeley
            else
                location = [geo.long, geo.lat]
            end
        end
        self.where(:loc => { :$near => location  , :$maxDistance => range    }).all
    end

end
