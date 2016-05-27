class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, except: [:index, :create, :new, :refresh_activities]
  before_action :check_permissions!, except: [:show, :index, :create, :new, :refresh_activities]
  before_action :load_activities, only: [:index, :show, :new, :edit, :refresh_activities]

  def index
    @tasks = Task.includes(:users, :creator).where(user_id: current_user.id) + current_user.tasks.includes(:users)
    @tasks.sort_by!(&:updated_at).reverse!
    @task = Task.new
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    @task.creator = current_user
    if @task.save
      redirect_to @task
      flash[:success] = 'Task was successfully created.'
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task
      flash[:success] = 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url
    flash[:success] = "Task was successfully destroyed."
  end

  def share
    @user = User.find_by(email: params[:share][:email])
    if @user
      if @task.users.include?(@user)
        redirect_to @task
        flash[:error] = 'User already have that task'
      else
        @task.create_activity :share, recipient: @user, owner: current_user
        @task.users << @user
        redirect_to @task, notice: 'Task was successfully shared.'
      end
    else
      redirect_to @task
      flash[:error] = "Sorry, did not find any user with email: #{params[:share][:email]}"
    end
  end

  def done
    @task.update(done: true)
    redirect_to root_path
    flash[:success] = 'Task was marked as completed'
  end

  def refresh_activities
    @tasks = Task.includes(:users, :creator).where(user_id: current_user.id) + current_user.tasks.includes(:users)
    @tasks.sort_by!(&:updated_at).reverse!
    respond_to do |format|
      format.js {}
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :done, :user_id, user_ids: [])
  end

  def check_permissions!
    unless @task.users.include?(current_user) || @task.creator == current_user
      redirect_to root_path
      flash[:error] = 'You do not have privileges for this action.'
    end
  end

  def load_activities
    @activities = PublicActivity::Activity.order('created_at DESC')
                                          .where(recipient_id: current_user.id, recipient_type: 'User')
                                          .includes(:owner, :trackable)
  end
end
