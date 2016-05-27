require 'rails_helper'

describe 'Task' do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @task = FactoryGirl.create(:task)
  end

  describe 'user associations' do
    it 'have a users attribute' do
      expect(@task).to respond_to(:users)
    end

    it 'have the right association with users' do
      @task.users << @user
      expect(@task.users.first).to eql(@user)
    end
  end
end
