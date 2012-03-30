require 'spec_helper'

describe Elibri::XmlMocks::Examples do
  
  it "should create basic_product xml" do
    Elibri::XmlMocks::Examples.send(:basic_product).should_not be_nil
  end
  
  it "should create basic_product xml that is parsable" do
    Elibri::XmlMocks::Examples.send(:basic_product, :record_reference => 'abc').should_not be_nil  
  end
  
  it "should create book object" do
    Elibri::XmlMocks::Examples.send(:book_example).should_not be_nil  
  end
  
  it "should create parsable book object" do
    Elibri::XmlMocks::Examples.send(:book_example, :record_reference => 'abc').should_not be_nil
  end
  
  #more tests to add
  
end