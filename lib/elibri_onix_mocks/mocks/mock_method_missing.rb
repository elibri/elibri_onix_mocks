# encoding: UTF-8

module Elibri
  module MockMethodMissing

  #TODO: dodać sprawdzanie czy obiekt przypadkiem nie zna metody
    def method_missing(m, *args, &block)
      if m == :product_form_onix_code
        super
      elsif [:kind_of_measurable?].include? m
        nil #bo jednostki są w elibri
      elsif [:publisher_id, :publisher_symbol, :record_reference, :ean, :no_isbn, 
        :ean_other_than_isbn, :product_form_onix_code, :file_size, :publication_year, 
        :publication_month, :publication_day, :number_of_pages, :number_of_illustrations, 
        :width, :height, :thickness, :weight, :duration, :map_scale, :authorship_kind, 
        :series_membership_kind, :set_membership_kind, :created_at, :updated_at, 
        :book_cover_type_onix_code, :edition_statement, :audience_age_from, 
        :audience_age_to, :sale_restricted_to, :sale_restricted_for, :imprint_id, 
        :publishing_status_onix_code, :sale_restricted, :isbn_id, :price_amount , 
        :price_currency, :price_printed_on_product_onix_code, :pack_quantity, :state, 
        :__elibri_product_category1_identifier, :__elibri_product_category2_identifier, 
        :template_product_id, :title, :subtitle, :or_title, :cascading_title, :collection_id, 
        :collection_part, :title_part, :vat, :pkwiu  , :print_run, :medial_patronage, :media_action_plan, 
        :city_of_publication, :cover_type_id, :paper_type_id, :publisher_product_category1_id, 
        :publisher_product_category2_id, :sale_restricted_to_poland, :platon_export_id, :azymut_export_id, 
        :import_verified, :matras_export_id, :dictum_export_id, :elibri_product_category1_id, :elibri_product_category2_id, 
        :super_siodemka_export_id, :wilga_xml_checksum, :isbn_from_import, :external_id, :stock_operator, :stock_quantity, 
        :motyl_product_id, :exported_to_motyl, :exported_to_motyl_at, :motyl_export_id, :epub_technical_protection_onix_code, 
        :product_form_detail_onix_code, :epub_sale_restricted_to, :epub_sale_not_restricted, :settlement_id,
        :collection, :trade_title, :imprint, :publisher_name, :sale_restricted?, :skip_ProductSupply, :cover_type, :preview_exists?,
        :kind_of_book?, :kind_of_audio?, :kind_of_map?, :kind_of_ebook?].include? m #nieobowiązkowe pola
        begin
          super
        rescue Mocha::ExpectationError
          nil
        end
      elsif [:series_memberships, :product_availabilities, :contributors, :languages,
        :elibri_product_categories, :publisher_product_categories, :other_texts, :attachments].include? m #nieobowiązkowe relacje
        begin
          super
        rescue Mocha::ExpectationError
          []
        end
      else
        begin
          super
        rescue Mocha::ExpectationError
          nil
        end        
      end
    end 
  
  
  end



  module Attributes
    DIMENSION_ATTRIBUTES = [ :width, :height, :thickness, :weight ]
    EPUB_ATTRIBUTES = [ :file_size, :epub_technical_protection_onix_code, :product_form_detail_onix_code, :epub_sale_restricted_to, :epub_sale_not_restricted ]
    BOOK_ATTRIBUTES = [ :number_of_pages, :number_of_illustrations, :excerpt, :edition_statement ]

    # Lista pól, które nie mają sensu dla określonych typów produktów.
    EXCLUDED_ATTRIBUTES = {
      # książka
      "BA" => [:duration, :map_scale, EPUB_ATTRIBUTES].flatten,
      # e-book
      "EA" => [:duration, :paper_type_id, :stock_quantity, :stock_operator, :print_run, :pack_quantity, :map_scale, :cover_type_id, DIMENSION_ATTRIBUTES].flatten,
      # kalendarz
      "PC" => [:duration, :map_scale, :cover_type_id, BOOK_ATTRIBUTES, EPUB_ATTRIBUTES].flatten,
      # audio DVD
      "AI" => [:map_scale, BOOK_ATTRIBUTES, EPUB_ATTRIBUTES].flatten,
      # audio CD
      "AC" => [:map_scale, BOOK_ATTRIBUTES, EPUB_ATTRIBUTES].flatten,
      # kaseta magnetofonowa
      "AB" => [:map_scale, BOOK_ATTRIBUTES, EPUB_ATTRIBUTES].flatten,
      # audio MP3
      "AJ" => [:map_scale, BOOK_ATTRIBUTES, EPUB_ATTRIBUTES].flatten,
      # inny format kartograficzny
      "CZ" => [:duration, :cover_type_id, BOOK_ATTRIBUTES, EPUB_ATTRIBUTES].flatten,
      # mapa w rolce
      "CD" => [:duration, :cover_type_id, BOOK_ATTRIBUTES, EPUB_ATTRIBUTES].flatten,
      # mapa płaska
      "CC" => [:duration, :cover_type_id, BOOK_ATTRIBUTES, EPUB_ATTRIBUTES].flatten,
      # mapa składana
      "CB" => [:duration, :cover_type_id, BOOK_ATTRIBUTES, EPUB_ATTRIBUTES].flatten,
      # mapa
      "CA" => [:duration, :cover_type_id, BOOK_ATTRIBUTES, EPUB_ATTRIBUTES].flatten,
    }

  end
end
