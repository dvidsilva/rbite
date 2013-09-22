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
    erb :'user/linkedin', :layout => false
  end

  get :nearest do
       @close = User.nearest([ -122.1 , 37.2 ], 200)
       @close.to_json
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
    Skill.delete_all(:user_id => @Usuario[:id] )
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
    @Usuario.to_json
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
