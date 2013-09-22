Swapi::App.controllers :user do

    # get :index, :map => '/foo/bar' do
    #   session[:foo] = 'bar'
    #   render 'index'
    # end

    # get :sample, :map => '/sample/url', :provides => [:any, :js] do
    #   case content_type
    #     when :js then ...
    #     else ...
    # end

    # get :foo, :with => :id do
    #   'Maps to url '/foo/#{params[:id]}''
    # end

    # get '/example' do
    #   'Hello world!'
    # end

    get :index do
        'hello world'
    end

    get :linkedin do
        erb :'user/linkedin' #, :layout => false
    end

    get :nearby do
        # {"needs":"developers,marketing",
        # "location":{"timestamp":"1379874930935","coords":{"speed":"","heading":"","altitudeAccuracy":"","accuracy":"53","altitude":"","longitude":"-122.2684755","latitude":"37.8701691"}}
        # }
        @needs  = params[:needs].split(',')
        @needs.each_with_index do |need,ind|
            #@needs[ind] = /#{need.split}/ # Regexp.new(need.to_s, "i");
            # TODO read user input and aproximate it to the skills
        end
        @skills = Skill.where(:name => @needs )
        lids = [];
        @skills.each do |skill|
            lids.push(skill.user_id)
        end
        @lc = [params[:location][:coords][:longitude], params[:location][:coords][:latitude] ]
        @users = User.where(:id => lids ).where(:id => {:$ne => params[:currentid] } ).nearby(@lc,2).all
        {:results => @users , :total => @users.count }.to_json
        #@lc.to_json
        #@needs.to_json
    end

    get :nearest do
        @close = User.nearest(params[:loc], 10)
        @result = {:values =>  @close , :total => @close.count }
        @result.to_json
    end

    post :auth do
        @Usuario = User.where({:lid => params[:userdata]["values"]["0"][:id]  })
        if @Usuario.count > 0
            @Usuario = User.first({:lid => params[:userdata]["values"]["0"][:id]  })
        else
            @Usuario = User.create({:lid => params[:userdata]["values"]["0"][:id] ,
                                    :email => params[:userdata]["values"]["0"][:emailAddress],
                                    :firstName => params[:userdata]["values"]["0"][:firstName],
                                    :lastName => params[:userdata]["values"]["0"][:lastName],
                                    :headline => params[:userdata]["values"]["0"][:lastName],
                                    :threePastPositions => params[:userdata]["values"]["0"][:threePastPositions]
            });
        end
        @Usuario.skills.delete_all
        params[:userdata][:values]["0"][:skills]["values"].values.each   do |skill|
            @skill = Skill.create( {:name => skill[:skill][:name] , :lid => skill[:id]  , :user => @Usuario } );
        end
        if params[:theuserisat].nil?
            params[:theuserisat] = {}
            params[:theuserisat][:coords] = {}
        end
        #@Usuario.everything = params[:userdata]["values"]["0"]
        @Usuario.pictureUrl = params[:pictureUrl]
        @Usuario.loc =  [params[:theuserisat][:coords][:longitude].to_f  , params[:theuserisat][:coords][:latitude].to_f  ];
        @Usuario.save()
        @loc = Location.create({:cord => [ params[:theuserisat][:coords][:longitude].to_f , params[:theuserisat][:coords][:latitude].to_f ] ,
                                :user => @Usuario ,
                                :lid => @Usuario.lid
        });
        @loc.save()
        {:user => @Usuario, :result => 'success'}.to_json
    end


    get :locations do
        #User.all.to_json
    end

    # params[:userdata][:total] me trae el total de mancitos
    # params[:userdata].to_json


end
