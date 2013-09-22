Swapi::Admin.controllers :skills do
  get :index do
    @title = "Skills"
    @skills = Skill.all
    render 'skills/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'skill')
    @skill = Skill.new
    render 'skills/new'
  end

  post :create do
    @skill = Skill.new(params[:skill])
    if @skill.save
      @title = pat(:create_title, :model => "skill #{@skill.id}")
      flash[:success] = pat(:create_success, :model => 'Skill')
      params[:save_and_continue] ? redirect(url(:skills, :index)) : redirect(url(:skills, :edit, :id => @skill.id))
    else
      @title = pat(:create_title, :model => 'skill')
      flash.now[:error] = pat(:create_error, :model => 'skill')
      render 'skills/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "skill #{params[:id]}")
    @skill = Skill.find(params[:id])
    if @skill
      render 'skills/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'skill', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "skill #{params[:id]}")
    @skill = Skill.find(params[:id])
    if @skill
      if @skill.update_attributes(params[:skill])
        flash[:success] = pat(:update_success, :model => 'Skill', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:skills, :index)) :
          redirect(url(:skills, :edit, :id => @skill.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'skill')
        render 'skills/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'skill', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Skills"
    skill = Skill.find(params[:id])
    if skill
      if skill.destroy
        flash[:success] = pat(:delete_success, :model => 'Skill', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'skill')
      end
      redirect url(:skills, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'skill', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Skills"
    unless params[:skill_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'skill')
      redirect(url(:skills, :index))
    end
    ids = params[:skill_ids].split(',').map(&:strip)
    skills = Skill.find(ids)
    
    if skills.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Skills', :ids => "#{ids.to_sentence}")
    end
    redirect url(:skills, :index)
  end
end
