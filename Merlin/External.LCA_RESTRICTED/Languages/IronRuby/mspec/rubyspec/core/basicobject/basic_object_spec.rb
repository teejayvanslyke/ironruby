require File::join( File::dirname(__FILE__), %w{ .. .. spec_helper } )
require File::join( File::dirname(__FILE__), %w{ shared behavior } )

ruby_version_is "1.9".."1.9.9" do

  describe "BasicObject behaves" do
    extend BasicObjectBehavior

    it "privately" do
      BasicObject.private_instance_methods.sort.should == private_features.sort
    end

    it "protectedly" do
      BasicObject.protected_instance_methods.sort.should == protected_features.sort
    end

    it "publically" do
      BasicObject.instance_methods.sort.should == public_features.sort
    end

  end
end

