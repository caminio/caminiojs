require 'spec_helper'

describe Caminio::Application do

  it "Application root" do
    expect( Caminio::Root.join ).to eq( File::join(Dir.pwd,'') )
  end

  it "reads configuration" do
    expect( Caminio::Application.config ).to have_key(:db)
  end

  it "initializes with correct env" do
    expect( Caminio::env ).to eq('test')
  end

end
