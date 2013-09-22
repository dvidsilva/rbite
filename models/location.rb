class Location
    include MongoMapper::Document
    # key <name>, <type>
    key :cord, Array
    key :lid, String
    belongs_to :user
    ensure_index [[:cord, '2d']]
    timestamps!

    def self.nearest(query,range)
        case query
        when Array
            location = query
        when String
            geo = Geokit::Geocoders::MultiGeocoder.geocode(location)
            if geo.lat.nil?
                location = ["-122.2685057", "37.8701231"] #Berkeley
            else
                location = [geo.long, geo.lat]
            end
        end
        self.where(:cord => {:$near => location , :$maxDistance => range }).all
    end

end

