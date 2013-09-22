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
    erb :'user/linkedin'
    #client = LinkedIn::Client.new('60r2wa6mwqj8', 'KYgJra61uWbtN5Ju')
    #rtoken = client.request_token.token
    #rsecret = client.request_token.secret
    #redirect client.request_token.authorize_url + "&redirect_uri=" + request.base_url + "/user/auth"


    #client.authorize_from_request(rtoken, rsecret, pin)

    # or authorize from previously fetched access keys
    #client.authorize_from_access("OU812", "8675309")

  end


  post :auth do
    User.delete_all
    Location.delete_all
    Skill.delete_all
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
    Skill.delete_all(:user_id => @Usuario[:id] )
    params[:userdata][:values]["0"][:skills]["values"].values.each   do |skill|
        @skill = Skill.create( {:name => skill[:skill][:name] , :lid => skill[:id]  } );
    end
    if params[:theuserisat].nil?
        params[:theuserisat] = {}
        params[:theuserisat][:coords] = {}
    end
    lo =  params[:theuserisat][:coords][:longitude] || 0;
    la =  params[:theuserisat][:coords][:latitude] || 0;
    @Usuario.loc =  [lo , la ];
    @Usuario.save()
    @loc = Location.create( {:cord => [ params[:theuserisat][:coords][:longitude].to_f , params[:theuserisat][:coords][:latitude].to_f ] , :user => @Usuario } );
    @loc.save()
    @loc.to_json
  end


  get :locations do
    Location.all.to_json
  end

# params[:userdata][:total] me trae el total de mancitos
# params[:userdata].to_json

  post :auth, :csrf_protection => false do
    #data = params.to_json
    params[:values][0][:id]
  end

end
