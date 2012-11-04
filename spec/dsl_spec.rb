require 'spec_helper'

describe CharacterWithoutAttributes do
  subject do
    CharacterWithoutAttributes.new do
      name 'John Doe'
      age 21
    end
  end
  
  context "Subject" do
    it "should have instance variables set correctly" do
      subject.at.name.should == 'John Doe'
      subject.at.age.should == 21
    end
  end
end

describe CharacterWithAttrReader do
  subject do
    CharacterWithAttrReader.new do
      name 'John Doe'
      age '21'
    end
  end
  
  context "Subject" do
    it "should have instance variables set correctly" do
      subject.at.name.should == 'John Doe'
      subject.at.age.should == '21'
    end
    
    it "should have attr readers set correctly" do
      subject.name.should == 'JOHN'
      subject.age.should == 21
    end
  end
  
  context "DSL" do
    it "should have attr readers set correctly" do
      subject.at.dsl.name.should == 'JOHN'
      subject.at.dsl.age.should == 21
    end
  end
  
end

describe CharacterWithAttrWriter do
  subject do
    CharacterWithAttrWriter.new do
      name 'John Doe'
      age '21'
    end
  end
  
  context "Subject" do
    it "should have instance variables set correctly" do
      subject.at.name.should == 'JOHN'
      subject.at.age.should == 21
    end
  end
  
  context "DSL" do
    it "should have attr readers set correctly" do
      subject.at.dsl.name.should == 'JOHN'
      subject.at.dsl.age.should == 21
    end
  end
end
