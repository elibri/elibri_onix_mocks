# encoding: UTF-8

require 'spec_helper'
$VERBOSE = nil #temp: supress id warnings

describe Elibri::XmlMocks::Examples do
=begin 
  [
  :basic_product, :book_example, :onix_record_identifiers_example, :onix_product_form_example,
  :onix_epub_details_example, :onix_languages_example,
  :onix_measurement_example, :onix_sale_restrictions_example, :onix_audience_range_example,
  :onix_publisher_info_example, :onix_subjects_example, :onix_edition_example, :onix_ebook_extent_example,
  :onix_audiobook_extent_example, :onix_no_contributors_example, :onix_collective_work_example,
  :onix_contributors_example, :onix_announced_product_example, :onix_preorder_product_example,
  :onix_published_product_example, :onix_out_of_print_product_example, :onix_titles_example,
  :onix_title_with_collection_example, :onix_texts_example, :onix_related_products_example,
  :onix_supply_details_example, :onix_series_memberships_example, :onix_supporting_resources_example,
  :onix_elibri_extensions_example, :contributor_mock, :review_mock, :supply_detail_mock, :imprint_mock,
  :description_mock
  ].each do |symbol|
  
    it "should create #{symbol} xml and parse it properly" do
      Elibri::XmlMocks::Examples.send(symbol, {}).should_not be_nil
      Elibri::ONIX::XMLGenerator.new(Elibri::XmlMocks::Examples.send(symbol, {})).should_not be_nil
      Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(Elibri::XmlMocks::Examples.send(symbol, {})).to_s)
    end
  
  end
  
  it "onix_subjects_example should return a valid list of product categories" do
    product_with_categories = Elibri::XmlMocks::Examples.onix_subjects_example()
    message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product_with_categories).to_s)
    message.products.first.subjects.size.should == 2

    product_with_categories = Elibri::XmlMocks::Examples.onix_subjects_example(:elibri_product_category1_id => 1110, :elibri_product_category2_id => nil)
    message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product_with_categories).to_s)
    message.products.first.subjects.size.should == 1

    product_with_categories = Elibri::XmlMocks::Examples.onix_subjects_example(:elibri_product_category1_id => nil, :elibri_product_category2_id => nil)
    message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product_with_categories).to_s)
    message.products.first.subjects.size.should == 0

  end
=end 

=begin

    :, :, :collection_part, :full_title, :original_title,
    :trade_title, :parsed_publishing_date, :record_reference, :deletion_text, :cover_type,
    :cover_price, :vat, :pkwiu, :product_composition, :product_form, :imprint, :publisher,
    :product_form, :no_contributor, :edition_statement, :number_of_illustrations, :publishing_status,
    :publishing_date, :premiere, :front_cover, :series_names, :elibri_product_category1_id, :elibri_product_category2_id,
    :preview_exists, :short_description
=end

  NAME_STRING_VECTOR = {
#    :height => :height,
#    :width => :width,
#    :weight => :weight,
#    :thickness => :thickness,
    :ean => :ean,    
    :isbn_value => :isbn13,
 #   :number_of_pages => :number_of_pages,
#    :duration => :duration
#    :file_size => :file_size,
    :publisher_name => :publisher_name,
#    :table_of_contents => :table_of_contents,
#    :description => :description
#    :reviews => :reviews, RELATION
#    :excerpts => :excerpts RELATION
#    :series => :series,
    :title => :title,
    :subtitle => :subtitle,
    [:collection, Proc.new {  Elibri::XmlMocks::Examples.collection_mock(:name => 'nazwa') } ] => [:collection_title, 'nazwa'],
    # [ :atrybut do podania do mocka, proc ktory wygeneruje mock ] => [ :atrybut w elibri, wartosc oczekiwana ] 
  
  }
  
  NAME_STRING_VECTOR.keys.each do |property|
      
    
#    next if [:current_state, :cover_type, :imprint, :publishing_status, :series_names].include? property

      it "should create properly string attribute #{property} inside product and should it parse properly" do
        if property.is_a?(Array)
          product = Elibri::XmlMocks::Examples.book_example(property[0] => property[1].call)
          message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
          message.products.first.send(NAME_STRING_VECTOR[property][0]).should eq(NAME_STRING_VECTOR[property][1])
        else
          product = Elibri::XmlMocks::Examples.book_example(property => '1')
          product.send(property).should eq('1')
          message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
          message.products.first.send(NAME_STRING_VECTOR[property]).should eq('1')
        end
      end
      
    end
    
    NAME_INT_VECTOR = {
      :publisher_id => :publisher_id,
      :audience_age_from => :reading_age_from,
      :audience_age_to => :reading_age_to,
      
    }
    
    NAME_INT_VECTOR.keys.each do |property|
      
      it "should create properly integer attribute #{property} inside product and should it parse properly" do
        product = Elibri::XmlMocks::Examples.book_example(property => 1)
        product.send(property).should eq(1)
        message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
        message.products.first.send(NAME_INT_VECTOR[property]).should eq(1)
      end
    
    end
    
    it "should create properly attribute current_state inside product and should it parse properly" do
      product = Elibri::XmlMocks::Examples.book_example(:notification_type => '04')
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:current_state).should eq(:published)
    end
    
    ### cover_type
    
    it "should create imprint attribute inside product and should it parse properly" do
      imprint = Elibri::XmlMocks::Examples.imprint_mock(:name => 'Imprint Mock')
      product = Elibri::XmlMocks::Examples.book_example(:imprint => imprint)
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:imprint).class.should eq(Elibri::ONIX::Release_3_0::Imprint)
      message.products.first.send(:imprint).send(:name).should eq('Imprint Mock')
      message.products.first.send(:imprint_name).should eq('Imprint Mock')
    end
  
end
