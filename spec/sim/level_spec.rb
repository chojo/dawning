require 'spec_helper'

describe Level do

  subject(:level) { Level.new }

  it "should create the world" do
    config = {'world' => {'height' => 100, 'width' => 50}}
    Builder::World.stub_chain(:new, :create) # prevent building for this test
    level.create(config)
    level.world.size.should == [50, 100]
  end

end
