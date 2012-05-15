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

  NAME_STRING_VECTOR = {
    :ean => :ean,    
    :isbn_value => :isbn13,
    :publisher_name => :publisher_name,
    :title => :title,
    :subtitle => :subtitle,
    [:collection, Proc.new {  Elibri::XmlMocks::Examples.collection_mock(:name => 'nazwa') } ] => [:collection_title, 'nazwa'],
    # [ :atrybut do podania do mocka, proc ktory wygeneruje mock ] => [ :atrybut w elibri, wartosc oczekiwana ] 
    :collection_part => :collection_part,
    :or_title => :original_title,
    :trade_title => :trade_title,
    [ :sale_restricted_to, Proc.new { Date.new(2011, 1, 1) } ] => [ :parsed_publishing_date, [2011, 1, 1] ],
    :record_reference => :record_reference,
    :deletion_text => :deletion_text,
    :pkwiu => :pkwiu,
    :edition_statement => :edition_statement
  }
  
  NAME_STRING_VECTOR.keys.each do |property|
      
    
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
      :vat => :vat,
      :number_of_illustrations => :number_of_illustrations,
      :number_of_pages => :number_of_pages,
      :duration => :duration,
      :file_size => :file_size,
      ### atrybuty powiązane z kind_of_measurable
      #:width => :width,
      #:weight => :weight,
      #:thickness => :thickness,
      #:height => :height,
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
    
    it "should create imprint attribute inside product and should it parse properly" do
      imprint = Elibri::XmlMocks::Examples.imprint_mock(:name => 'Imprint Mock')
      product = Elibri::XmlMocks::Examples.book_example(:imprint => imprint)
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:imprint).class.should eq(Elibri::ONIX::Release_3_0::Imprint)
      message.products.first.send(:imprint).send(:name).should eq('Imprint Mock')
      message.products.first.send(:imprint_name).should eq('Imprint Mock')
    end
    
    it "should create full_title inside product based on other fields" do
      collection = Elibri::XmlMocks::Examples.collection_mock(:name => 'Kolekcja książek')
      product = Elibri::XmlMocks::Examples.book_example(
        :title => "Numer jeden", :subtitle => 'Książka nawiedzona',
        :edition_statement => 'wyd. 1, zepsute', :collection => collection,
        :collection_part => 'Część 123')
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:full_title).should eq('Kolekcja książek (Część 123). Numer jeden. Książka nawiedzona')
    end
    
    it "should create cover_price attribute inside product and should it parse properly" do
      product = Elibri::XmlMocks::Examples.book_example(:price_amount => 9.99)
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:cover_price).should eq(9.99)
    end
    
    it "should create publisher_name attribute inside product and should it parse properly" do
      product = Elibri::XmlMocks::Examples.book_example(:publisher_name => 'Wydawnictwo')
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:publisher_name).should eq('Wydawnictwo')
      message.products.first.send(:publisher).send(:name).should eq('Wydawnictwo')
    end
    
    it "should create no_contributors attribute inside product and should it parse properly" do
      product = Elibri::XmlMocks::Examples.book_example
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:no_contributor?).should eq(false)
      authorship_kind = Elibri::XmlMocks::Examples.authorship_kind_mock(:no_contributor? => true)
      product = Elibri::XmlMocks::Examples.book_example(:authorship_kind => authorship_kind)
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:no_contributor?).should eq(true)
    end
    
    it "should create publishing_date and  attribute inside product and should it parse properly" do
      product = Elibri::XmlMocks::Examples.book_example(
        :publication_day => 1, :publication_month => 1, :publication_year => 2010, :sale_restricted_to => Date.new(2010,1,1))
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      pub_date = message.products.first.send(:publishing_date)
      pub_date.class.should eq(Elibri::ONIX::Release_3_0::PublishingDate)
      pub_date.date.should eq('20100101')
      message.products.first.send(:premiere).should eq(Date.new(2010,1,1))
    end
    
    it "should create preview_exists and should it parse properly" do
      product = Elibri::XmlMocks::Examples.book_example(:preview_exists? => true)
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:preview_exists).should eq(true)
      product = Elibri::XmlMocks::Examples.book_example(:preview_exists? => false)
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:preview_exists).should eq(false)
      product = Elibri::XmlMocks::Examples.book_example
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:preview_exists).should eq(false)
    end
    
    it "should create product_composition and should it parse properly (but always 00 right now)" do
      product = Elibri::XmlMocks::Examples.book_example(:product_composition => '00')
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:product_composition).should eq('00')
      product = Elibri::XmlMocks::Examples.book_example(:product_composition => 'asd')
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:product_composition).should eq('00')
    end
    
    it "should create product_form and should it parse properly" do
      product = Elibri::XmlMocks::Examples.book_example(:product_form_onix_code => 'EA')
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:product_form).should eq('EA')
      product = Elibri::XmlMocks::Examples.book_example(:product_form_onix_code => 'BA')
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:product_form).should eq('BA')
    end
    
    it "should create publishing_status and should it parse properly" do
      product = Elibri::XmlMocks::Examples.book_example(:publishing_status_onix_code => Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::ACTIVE)
      product.publishing_status_onix_code.should eq(Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::ACTIVE)
      product.publishing_status_onix_code.present?.should eq(true)
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:publishing_status).should eq(Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::ACTIVE)
  ### dlaczego nie zmienia sie status?
  #    product = Elibri::XmlMocks::Examples.book_example(:publishing_status_onix_code => Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::FORTHCOMING)
  #    product.publishing_status_onix_code.should eq(Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::FORTHCOMING)
  #    product.publishing_status_onix_code.present?.should eq(true)
  #    message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
  #    message.products.first.send(:publishing_status).should eq(Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::FORTHCOMING)
    end    
    
    
    
    it "should create series_name attribute inside product and should it parse properly" do
      product = Elibri::XmlMocks::Examples.onix_series_memberships_example
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:series_names).should eq(['Lektury szkolne','Dla Bystrzaków'])
    end
    
    it "should create series attribute inside product and should it parse properly" do
      product = Elibri::XmlMocks::Examples.onix_series_memberships_example
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:series).should eq([['Lektury szkolne', '2'], ['Dla Bystrzaków', '1']])
    end
    
    it "should create text_contents with types inside product and parse it properly" do
      texts = [
        Elibri::XmlMocks::Examples.description_mock(:type_onix_code => Elibri::ONIX::Dict::Release_3_0::OtherTextType::REVIEW, :text => 'review'),
        Elibri::XmlMocks::Examples.description_mock(:type_onix_code => Elibri::ONIX::Dict::Release_3_0::OtherTextType::EXCERPT, :text => 'excerpt'),
        Elibri::XmlMocks::Examples.description_mock(:type_onix_code => Elibri::ONIX::Dict::Release_3_0::OtherTextType::TABLE_OF_CONTENTS, :text => 'toc'),
        Elibri::XmlMocks::Examples.description_mock(:type_onix_code => Elibri::ONIX::Dict::Release_3_0::OtherTextType::SHORT_DESCRIPTION, :text => 'short description'),
        Elibri::XmlMocks::Examples.description_mock(:type_onix_code => Elibri::ONIX::Dict::Release_3_0::OtherTextType::MAIN_DESCRIPTION, :text => 'description')
      ]
      product = Elibri::XmlMocks::Examples.book_example(:other_texts => texts)
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:reviews).first.text.should eq('review')
      message.products.first.send(:excerpts).first.text.should eq('excerpt')
      message.products.first.send(:table_of_contents).text.should eq('toc')
      message.products.first.send(:description).text.should eq('description')
      message.products.first.send(:short_description).text.should eq('short description')
    end
    
    it "should create proper front_cover inside item" do
      product = Elibri::XmlMocks::Examples.book_example
      message = Elibri::ONIX::Release_3_0::ONIXMessage.from_xml(Elibri::ONIX::XMLGenerator.new(product).to_s)
      message.products.first.send(:front_cover).send(:link).should eq('http://elibri.com.pl/sciezka/do/pliku.png')
    end
    
end
