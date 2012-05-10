# encoding: UTF-8

require 'spec_helper'
$VERBOSE = nil #temp: supress id warnings

describe Elibri::XmlMocks::Examples do
  
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
  #more tests to add
  
end
