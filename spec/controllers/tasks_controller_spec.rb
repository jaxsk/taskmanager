require 'rails_helper'
require 'rspec/rails'
require 'devise'

describe TasksController do
  include Devise::TestHelpers

  let(:valid_attributes) { { title: 'Hi!', description: 'Hello!', user_id: 1 } }
  let(:invalid_attributes) { { title: '', description: '' } }

  before(:each) do
    @user = User.create!(email: 'user@user.user', password: '12345678')
    @task = Task.create!(title: 'Hi!', description: 'Hello!', user_id: @user.id)

    sign_in @user
  end

  describe 'GET index' do
    it 'should be successful' do
      get 'index'
      expect(response).to be_success
    end

    it 'should render index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET new' do
    it 'should assign a new task as @task' do
      get :new, {}
      expect(assigns(:task)).to be_a_new(Task)
    end
  end

  describe 'POST create' do
    it 'should create a new task and save it to the database' do
      expect { post :create, { task: valid_attributes } }.to change(Task, :count).by(1)
    end
  end

  describe 'GET show' do
    it 'should assign the requested task to @task' do
      get :show, id: @task.to_param
      expect(assigns(:task)).to eq(@task)
    end
  end

  describe 'GET edit' do
    it 'should assign the requested task as @task' do
      get :edit, id: @task.to_param
      expect(assigns(:task)).to eq(@task)
    end
  end

  describe 'DELETE destroy' do
    it 'should destroy the requested task' do
      expect { delete :destroy, id: @task.id }.to change(Task, :count).by(-1)
    end

    it 'should redirect to the tasks list' do
      delete :destroy, id: @task.to_param
      expect(response).to redirect_to(tasks_url)
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      it 'should assign the requested task as @task' do
        put :update, id: @task.to_param, task: valid_attributes
        expect(assigns(:task)).to eq(@task)
      end

      it 'should redirect to the task' do
        put :update, id: @task.to_param, task: valid_attributes
        expect(response).to redirect_to(task_url(@task))
      end
    end

    context 'with invalid params' do
      it 'should assign the task as @task' do
        allow_any_instance_of(Task).to receive(:save).and_return(false)
        put :update, id: @task.to_param, task: invalid_attributes
        expect(assigns(:task)).to eq(@task)
      end

      it 're-renders the "edit" template' do
        allow_any_instance_of(Task).to receive(:save).and_return(false)
        put :update, id: @task.to_param, task: { task: {} }
        expect(response).to render_template('edit')
      end
    end
  end
end
