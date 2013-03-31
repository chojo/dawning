require "spec_helper"

describe "Level" do

  before :each do
    user = FactoryGirl.create :admin_user, password: 'secret'
    login_with(user, 'secret')
  end

  it "should create a new level" do
    visit '/admin/levels'
    click_on 'create_level_button'
    fill_in 'level_name', with: 'level test'
    click_on 'Start'
    click_on 'Build'
    click_on 'Run'
    click_on 'Stop'
    click_on 'Remove'
  end

end
