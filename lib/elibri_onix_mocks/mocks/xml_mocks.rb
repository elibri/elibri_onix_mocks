# encoding: UTF-8

require 'mocha'
module Elibri
  class XmlMocks
    
    COVER_TYPES= [      1  => 'gąbka',
                        2 => 'kartonowa',
                        3 => 'kartonowa foliowana',
                        4 => 'miękka',
                        5 => 'miękka ze skrzydełkami',
                        6 => 'plastikowa',
                        7 => 'skórzana',
                        8 => 'twarda',
                        9 => 'twarda z obwolutą',
                        10 => 'twarda lakierowana']

    HARDBACK = 8
    PLASTIC = 6
    PAPERBACK = 4

    # Przykładowe produkty dla generatora XML. Są to sztuczne twory (nie ma sensu tworzyć rekordów
    # w bazie). Mają tylko służyć jako model, z którego można utworzyć jak najwięcej tagów z subsetu
    # ONIX wykorzystywanego w Elibri.
    # TODO: Czy to jest dobre miejsce na coś takiego? 
    module Examples
      extend self

      # Dla uproszczenia stub`ujemy większość funkcjonalności:
      extend Mocha::API


      # Najprostszy produkt, dla którego XML się waliduje przez RelaxNG
      def basic_product(options = {})
        opt = {:title => "Nielegalni",
        :product_form_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductFormCode::BOOK,
        :ean => nil,
        :isbn_value => '9788324799992',
        :record_reference => "fdb8fa072be774d97a97",
        :facsimiles => [],
        :similar_products => [],
        :state => "published",
        :public? => true}.merge(options)
        mock("product") do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def book_example(options = {})
        opt = {
          :state => "published",
          :public? => true,
          :product_form_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductFormCode::BOOK,
          :cover_type_id => Elibri::XmlMocks::PAPERBACK,
          :publishing_status_onix_code => Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::ACTIVE,
          :publication_year => 2011,
          :publication_month => 2,
          :publication_day => 10,
          :publisher_symbol => "W pustyni i w puszczy",
          :record_reference => "fdb8fa072be774d97a97",
          :imprint => stub('Imprint', :name => 'National Geographic'),
          :publisher_name => 'GREG',
          :publisher_id => 11,
          :ean => '9788324788882',
          :isbn_value => '9788324799992',
          :pack_quantity => 7,
          :price_printed_on_product_onix_code => Elibri::ONIX::Dict::Release_3_0::PricePrintedOnProduct::YES,
          :width => 125,
          :height => 195,
          :thickness => 20,
          :weight => 90,
          :number_of_pages => 250,
          :number_of_illustrations => 32,
          :kind_of_book? => true,
          :kind_of_ebook? => true,
          :kind_of_audio? => true,
          :kind_of_map? => true,
          #:map_scale => '20000',
          :elibri_product_category1_id => 1110,
          :elibri_product_category2_id => 491,
          :deletion_text => 'Rekord miał sporo błędów',
          :sale_restricted? => true,
          :sale_restricted_for => 'sklep.gildia.pl',
          :sale_restricted_to =>  Date.new(2012, 7, 22),
          :audience_age_from => 7,
          :audience_age_to => 25,
          # Trochę oszukujemy, żeby w XML`u pokazać wszystkie 3 opcje:
          :authorship_kind => stub('AuthorshipKind', :user_given? => true, :collective? => false, :no_contributor? => false),
          :contributors => [
            stub('Contributor',
              :artificial_id => 257,
              :role_onix_code => Elibri::ONIX::Dict::Release_3_0::ContributorRole::TRANSLATOR,
              :language_onix_code => 'pol',
              :title => 'prof.',
              :name => 'Henryk',
              :last_name_prefix => 'von',
              :last_name => 'Sienkiewicz',
              :last_name_postfix => 'Ibrahim',
              :biography => stub('OtherText', :text => 'Biografia Sienkiewicza', :exportable? => true, :is_a_review? => false, :resource_link => 'http://example').extend(MockMethodMissing),
              :updated_at => Date.new(2011, 11, 04).to_time + 10.hours + 5.minutes + 27.seconds
            ).extend(MockMethodMissing)
          ],
          :or_title => "Tytuł oryginalny",
          :trade_title => "Tytuł handlowy",
          :vat => 5,
          :pkwiu => "58.11.1",
          :price_amount => 12.99,
          :collection_part => 'Tom 1',
          :title => 'Tytuł',
          :subtitle => 'Podtytuł',
          :collection => stub('PublisherCollection', :name => 'Nazwa kolekcji'),
          :edition_statement => 'wyd. 3, poprawione',
          :languages => [stub('Language', :language_onix_code => 'pol', :role_onix_code => Elibri::ONIX::Dict::Release_3_0::LanguageRole::LANGUAGE_OF_TEXT)],
          :other_texts => [
            stub('OtherText',
                 :artificial_id => 137,
                 :type_onix_code => Elibri::ONIX::Dict::Release_3_0::OtherTextType::REVIEW,
                 :text => 'Recenzja książki',
                 :text_author => 'Jan Kowalski', 
                 :updated_at => Date.new(2011, 12, 03).to_time + 19.hours + 5.minutes + 28.seconds,
                 :exportable? => true,
                 :is_a_review? => true,
                 :resource_link => 'http://example'
                ).extend(MockMethodMissing)
          ],
          :series_membership_kind => stub('series_membership_kind', :user_given? => true),
          :series_memberships => [
            stub('SeriesMembership', :series_name => 'Lektury szkolne', :number_within_series => '2').extend(MockMethodMissing)
          ],
          :facsimiles => [stub('Product', :publisher_name => 'PWN', :publisher_id => 12, :publisher_symbol => 'Tytuł dodruku', :isbn_value => '9788324705818')],
          :similar_products => [stub('Product', :publisher_name => 'WNT', :publisher_id => 13, :publisher_symbol => 'Tytuł podobnej książki', :isbn_value => '9788324799992')],
          :attachments => [
            stub('ProductAttachment', 
                 :id => 668,
                 :attachment_type_code => Elibri::ONIX::Dict::Release_3_0::ResourceContentType::FRONT_COVER,
                 :file_content_type => 'image/png',
                 :onix_resource_mode => Elibri::ONIX::Dict::Release_3_0::ResourceMode::IMAGE,
                 :file => stub('Paperclip::Attachment', :url => 'http://elibri.com.pl/sciezka/do/pliku.png'),
                 :updated_at => Date.new(2011, 12, 01).to_time + 19.hours + 5.minutes + 28.seconds
                ).extend(MockMethodMissing)
          ],
          :product_availabilities => [
            stub('ProductAvailability',
                 :supplier_identifier => 'GILD-123',
                 :supplier_role_onix_code => Elibri::ONIX::Dict::Release_3_0::SupplierRole::PUB_NON_EXL_DIST,
                 :product_availability_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductAvailabilityType::IN_STOCK,
                 :supplier => stub('Supplier',
                                   :name => 'Gildia.pl',
                                   :nip => '521-33-59-408',
                                   :phone => '22 631 40 83',
                                   :email => 'bok@gildia.pl',
                                   :website => 'http://gildia.pl'
                                  ),
                 :stock_info => stub('stock_info', :exact_info? => true, :on_hand => '1000'),
                 :price_infos => [ stub('PriceInfo', :minimum_order_quantity => 20, :amount => 12.99, :vat => 7, :currency_code => 'PLN') ]
                ).extend(MockMethodMissing),

            stub('ProductAvailability',
                 :supplier_identifier => 'pl.pwn.ksiegarnia.produkt.id.76734',
                 :supplier_role_onix_code => Elibri::ONIX::Dict::Release_3_0::SupplierRole::WHOLESALER,
                 :product_availability_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductAvailabilityType::IN_STOCK,
                 :supplier => stub('Supplier',
                                    :name => 'PWN',
                                   :nip => '521-33-59-408',
                                   :phone => '22 631 40 83',
                                   :email => 'bok@pwn.pl',
                                   :website => 'http://pwn.pl'
                                  ).extend(MockMethodMissing),
                 :stock_info => stub('stock_info', :exact_info? => false, :quantity_code => 'mało'),
                 :price_infos => [ stub('PriceInfo', :minimum_order_quantity => 10, :amount => 14.99, :vat => 7, :currency_code => 'PLN') ]
                ).extend(MockMethodMissing)
          ]
        }.merge(options)
        mock("product").tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end

      def onix_record_identifiers_example(options = {})
        opt = {
          :state => "published",
          :title => "Nielegalni",
          :product_form_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductFormCode::BOOK,
          :record_reference => "fdb8fa072be774d97a97",
          :ean => '9788324788882',
          :isbn_value => '9788324799992',
          :public? => true,
          :product_availabilities => [
            stub('ProductAvailability', :supplier_identifier => '355006',
                 :product_availability_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductAvailabilityType::IN_STOCK,
                 :stock_info => stub('stock_info', :exact_info? => true, :on_hand => '1000'),
                 :price_infos => [ stub('PriceInfo', :minimum_order_quantity => 20, :amount => 12.99, :vat => 7, :currency_code => 'PLN') ],
                 :supplier => stub('Supplier', :name => "Olesiejuk",
                                               :nip => "527-22-62-432", :phone => "22 721 70 07", :email => "", :website => "www.olesiejuk.pl"),
                 :supplier_role_onix_code => Elibri::ONIX::Dict::Release_3_0::SupplierRole::WHOLESALER).extend(MockMethodMissing)
          ]
        }.merge(options)
        mock("product").tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_product_form_example(options = {})
        opt = {
          :title => "Nielegalni",
          :ean => nil,
          :isbn_value => '9788324799992',
          :record_reference => "fdb8fa072be774d97a97",
          :product_form_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductFormCode::BOOK,
          :cover_type_id => Elibri::XmlMocks::PAPERBACK,
          :state => "published",
          :public? => true,
          :product_availabilities => []
        }.merge(options)
        mock("product").tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end
    

      def onix_epub_details_example(options = {})
        opt = {
          :title => "Nielegalni",
          :ean => nil,
          :isbn_value => '9788324799992',
          :record_reference => "fdb8fa072be774d97a97",
          :product_form_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductFormCode::EBOOK,
          :epub_technical_protection_onix_code => Elibri::ONIX::Dict::Release_3_0::EpubTechnicalProtection::DRM,
          :product_form_detail_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductFormDetail::EPUB,
          :state => "published",
          :public? => true,
          :product_availabilities => []
        }.merge(options)
        mock("product").tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_categories_example(options = {})
        opt = {
          :publisher_name => "Buchmann",
          :publisher_id => 15,
          :publisher_product_categories => [
             stub('PublisherProductCategory', :name => "Beletrystyka: Horror"),
             stub('PublisherProductCategory', :name => "Beletrystyka: Sensacja")
          ]
        }.merge(options)
        basic_product.tap do |product|
           product.stubs(
            opt
           )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end

      def onix_languages_example(options = {})
        opt = {
           :languages => [
              stub('Language', :language_onix_code => 'pol', :role_onix_code => Elibri::ONIX::Dict::Release_3_0::LanguageRole::LANGUAGE_OF_TEXT),
              stub('Language', :language_onix_code => 'eng', :role_onix_code => Elibri::ONIX::Dict::Release_3_0::LanguageRole::LANGUAGE_OF_ABSTRACTS)
            ]
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_measurement_example(options = {})
        opt = {
          :title => "Katowice, mapa",
          :ean => nil,
          :isbn_value => '9788324799992',
          :record_reference => "fdb8fa072be774d97a97",
          :product_form_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductFormCode::SHEET_MAP,
          :width => 125,
          :height => 195,
          :thickness => 20,
          :weight => 90,
          :map_scale => 50_000, 
          :state => "published",
          :public? => true
        }.merge(options)
        mock("product").tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_sale_restrictions_example(options = {})
        opt = {
          :sale_restricted? => true,
          :sale_restricted_for => 'Empik',
          :sale_restricted_to =>  Date.new(2012, 7, 22),
          :publication_year => 2012,
          :publication_month => 7,
          :publication_day => 12
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_audience_range_example(options = {})
        opt = {
          :audience_age_from => 7,
          :audience_age_to => 10
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_publisher_info_example(options = {})
        opt = {
          :publisher_name => 'G+J Gruner+Jahr Polska',
          :publisher_id => 14,
          :imprint => stub('Imprint', :name => 'National Geographic')
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end



      def onix_subjects_example(options = {})
        opt = {
          :elibri_product_category1_id => 1110,
          :elibri_product_category2_id => 491
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_edition_example(options = {})
        opt = {
          :edition_statement => 'wyd. 3, poprawione'
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_ebook_extent_example(options = {})
        opt = {
          :example_title => 'E-book (rozmiar pliku, ilość stron i obrazków)',
          :product_form_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductFormCode::EBOOK,
          :file_size => 1.22,
          :number_of_pages => 150,
          :number_of_illustrations => 12
        }.merge(options)
        basic_product.tap do |product|
            product.stubs(
              opt
            )
          end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end

      def onix_audiobook_extent_example(options = {})
          opt = {
            :example_title => 'Audio CD z długością ścieżki',
            :product_form_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductFormCode::AUDIO_CD,
            :duration => 340
          }.merge(options)
          basic_product.tap do |product|
            product.stubs(
              opt
            )
          end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end
 
      def onix_no_contributors_example(options = {})
          opt = {
            :example_title => 'Brak autorów',
            :authorship_kind => ActiveSupport::StringInquirer.new("no_contributor")
          }.merge(options)
          basic_product.tap do |product|
            product.stubs(
              opt
            )
          end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end

      def onix_collective_work_example(options = {})
        opt = {
          :example_title => 'Praca zbiorowa',
          :authorship_kind => ActiveSupport::StringInquirer.new("collective")
        }.merge(options)
          basic_product.tap do |product|
            product.stubs(
              opt
            )
          end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end

      def onix_contributors_example(options = {})
          opt = {
            :example_title => 'Wyszczególnieni autorzy',
            :title => "Taka jest nasza wiara",
            :authorship_kind => ActiveSupport::StringInquirer.new("user_given"),
            :contributors => [
              stub('Contributor',
                :artificial_id => 255,
                :role_onix_code => Elibri::ONIX::Dict::Release_3_0::ContributorRole::AUTHOR,
                :missing_parts => true,
                :full_name => 'Św. Tomasz z Akwinu',
                :biography => stub('OtherText', :text => 'Tomasz z Akwinu, Akwinata, łac. Thoma de Aquino (ur. 1225, zm. 7 marca 1274) – filozof scholastyczny, teolog, członek zakonu dominikanów. Był jednym z najwybitniejszych myślicieli w dziejach chrześcijaństwa. Święty Kościoła katolickiego, jeden z doktorów Kościoła, który nauczając przekazywał owoce swej kontemplacji (łac. contemplata aliis tradere).'),
                :updated_at => Date.new(2011, 11, 04).to_time + 10.hours + 5.minutes + 27.seconds
              ).extend(MockMethodMissing),
              stub('Contributor',
                :artificial_id => 256,
                :role_onix_code => Elibri::ONIX::Dict::Release_3_0::ContributorRole::TRANSLATOR,
                :language_onix_code => 'lat',
                :title => 'prof. ks.',
                :name => 'Henryk',
                :last_name_prefix => 'von',
                :last_name => 'Hausswolff',
                :last_name_postfix => 'OP',
                :updated_at => Date.new(2011, 11, 04).to_time + 10.hours + 5.minutes + 27.seconds
              ).extend(MockMethodMissing)
            ]
          }.merge(options)
          basic_product.tap do |product|
            product.stubs(
              opt
            )
          end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end

      def onix_announced_product_example(options = {})
        opt = {
          :state => :announced,
          :publisher_symbol => "Światu nie mamy czego zazdrościć.",
          :or_title => "Nothing to Envy: Ordinary Lives in North Korea",
          :collection_part => '33',
          :title => 'Światu nie mamy czego zazdrościć.',
          :subtitle => "Zwyczajne losy mieszkańców Korei Północnej.",
          :publication_year => 2011
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end

      def onix_preorder_product_example(options = {})
        opt = {
          :state => :preorder,
          :publication_year => 2011,
          :publication_month => 2,
          :publication_day => 10
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end

      def onix_published_product_example(options = {})
        opt = {
          :state => :published,
          :publication_year => 2011,
          :publication_month => 2
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end

      def onix_out_of_print_product_example(options = {})
        opt = {
          :state => :out_of_print
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end

      def onix_titles_example(options = {})
        opt = {
          :publisher_symbol => "Światu nie mamy czego zazdrościć.",
          :or_title => "Nothing to Envy: Ordinary Lives in North Korea",
          :collection_part => '33',
          :title => 'Światu nie mamy czego zazdrościć.',
          :subtitle => "Zwyczajne losy mieszkańców Korei Północnej."
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end

      def onix_title_with_collection_example(options = {})
        opt = {
          :publisher_symbol => "Thorgal 33 Statek-Miecz TWARDA",
          :or_title => "Thorgal: Le Bateau-Sabre",
          :collection_part => '33',
          :title => 'Statek-Miecz',
          :collection => stub('PublisherCollection', :name => 'Thorgal')
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end



      def onix_texts_example(options = {})
        opt = {
            :other_texts => [
              stub('OtherText',
                   :artificial_id => 133,
                   :type_onix_code => Elibri::ONIX::Dict::Release_3_0::OtherTextType::TABLE_OF_CONTENTS,
                   :text => '1. Wprowadzenie<br/>2. Rozdział pierwszy<br/>[...]',
                   :updated_at => Date.new(2011, 12, 04).to_time + 13.hours + 15.minutes + 5.seconds
                  ).extend(MockMethodMissing),
              stub('OtherText',
                   :artificial_id => 134,
                   :exportable_review => true,
                   :type_onix_code => Elibri::ONIX::Dict::Release_3_0::OtherTextType::REVIEW,
                   :text => 'Recenzja książki<br/>[...]',
                   :resource_link => 'http://nakanapie.pl/books/420469/reviews/2892.odnalezc-swa-droge',
                   :source_title => 'nakanapie.pl',
                   :text_author => 'Jan Kowalski',
                   :updated_at => Date.new(2011, 12, 04).to_time + 13.hours + 18.minutes + 15.seconds
                  ).extend(MockMethodMissing),
              stub('OtherText',
                   :artificial_id => 135,
                   :type_onix_code => Elibri::ONIX::Dict::Release_3_0::OtherTextType::MAIN_DESCRIPTION,
                   :text => 'Opis książki<br/>[...]',
                   :updated_at => Date.new(2011, 12, 04).to_time + 13.hours + 25.minutes + 18.seconds
                  ).extend(MockMethodMissing),
              stub('OtherText',
                   :artificial_id => 136,
                   :type_onix_code => Elibri::ONIX::Dict::Release_3_0::OtherTextType::EXCERPT,
                   :text => 'Fragment książki<br/>[...]', 
                   :updated_at => Date.new(2011, 12, 04).to_time + 13.hours + 35.minutes + 2.seconds
                  ).extend(MockMethodMissing),
            ]
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_related_products_example(options = {})
        opt = {
            :facsimiles => [stub('Product', :publisher_name => 'PWN', :publisher_id => 11, :publisher_symbol => 'Tytuł dodruku', :isbn_value => '9788324705818')],
            :similar_products => [stub('Product', :publisher_name => 'WNT', :publisher_id => 12, :publisher_symbol => 'Tytuł podobnej książki', :isbn_value => '9788324799992')]        
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_supply_details_example(options = {})
        opt = {
           :product_availabilities => [
              stub('ProductAvailability',
                   :supplier_identifier => 'GILD-123',
                   :supplier_role_onix_code => Elibri::ONIX::Dict::Release_3_0::SupplierRole::PUB_NON_EXL_DIST,
                   :product_availability_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductAvailabilityType::IN_STOCK,
                   :supplier => stub('Supplier',
                                     :name => 'Gildia.pl',
                                     :nip => '521-33-59-408',
                                     :phone => '22 631 40 83',
                                     :email => 'bok@gildia.pl',
                                     :website => 'http://gildia.pl'
                                    ),
                   :stock_info => stub('stock_info', :exact_info? => true, :on_hand => '1000'),
                   :price_infos => [ stub('PriceInfo', :minimum_order_quantity => 20, :amount => 12.99, :vat => 7, :currency_code => 'PLN') ]
                  ),

              stub('ProductAvailability',
                   :supplier_identifier => 'pl.pwn.ksiegarnia.produkt.id.76734',
                   :supplier_role_onix_code => Elibri::ONIX::Dict::Release_3_0::SupplierRole::WHOLESALER,
                   :product_availability_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductAvailabilityType::IN_STOCK,
                   :supplier => stub('Supplier',
                                     :name => 'PWN',
                                     :nip => '521-33-59-408',
                                     :phone => '22 631 40 83',
                                     :email => 'bok@pwn.pl',
                                     :website => 'http://www.pwn.pl'
                                    ),
                   :stock_info => stub('stock_info', :exact_info? => false, :quantity_code => 'mało'),
                   :price_infos => [ stub('PriceInfo', :minimum_order_quantity => 10, :amount => 14.99, :vat => 7, :currency_code => 'PLN') ]
                  )
            ]
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_series_memberships_example(options = {})
        opt = {
          :series_membership_kind => stub('series_membership_kind', :user_given? => true),
          :series_memberships => [
            stub('SeriesMembership', :series_name => 'Lektury szkolne', :number_within_series => '2'),
            stub('SeriesMembership', :series_name => 'Dla Bystrzaków', :number_within_series => '1')
          ]
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_supporting_resources_example(options = {})
        opt = {    
          :attachments => [
            stub('ProductAttachment', 
                 :id => 667,
                 :attachment_type_code => Elibri::ONIX::Dict::Release_3_0::ResourceContentType::FRONT_COVER,
                 :file_content_type => 'image/png',
                 :onix_resource_mode => Elibri::ONIX::Dict::Release_3_0::ResourceMode::IMAGE,
                 :file => stub('Paperclip::Attachment', :url => 'http://elibri.com.pl/sciezka/do/pliku.png'), 
                 :updated_at => Date.new(2011, 12, 01).to_time + 18.hours + 5.minutes + 28.seconds
                ),
            stub('ProductAttachment', 
                 :id => 668,
                 :attachment_type_code => Elibri::ONIX::Dict::Release_3_0::ResourceContentType::SAMPLE_CONTENT,
                 :file_content_type => 'application/pdf',
                 :onix_resource_mode => Elibri::ONIX::Dict::Release_3_0::ResourceMode::TEXT,
                 :file => stub('Paperclip::Attachment', :url => 'http://elibri.com.pl/sciezka/do/pliku.pdf'),
                 :updated_at => Date.new(2011, 12, 01).to_time + 18.hours + 9.minutes + 18.seconds
                )
          ]
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end


      def onix_elibri_extensions_example(options = {})
        opt = {
          :cover_type_id => Elibri::XmlMocks::PAPERBACK,
          :vat => 5,
          :pkwiu => "58.11.1",
          :price_amount => 12.99,
          :preview_exists? => true
        }.merge(options)
        basic_product.tap do |product|
          product.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end
    
    
      def contributor_mock(options = {})
        opt = {
          :artificial_id => 240,
          :role_onix_code => Elibri::ONIX::Dict::Release_3_0::ContributorRole::AUTHOR,
          :language_onix_code => 'pol',
          :title => 'prof.',
          :name => 'Henryk',
          :last_name_prefix => 'von',
          :last_name => 'Sienkiewicz',
          :last_name_postfix => 'Ibrahim',
          :biography => stub('OtherText', :text => 'Biografia Sienkiewicza', :exportable? => true, :is_a_review? => false, :resource_link => 'http://example').extend(MockMethodMissing),
          :updated_at => Date.new(2011, 11, 04).to_time + 10.hours + 5.minutes + 27.seconds
        }.merge(options)
        mock('Contributor').tap do |contributor|
          contributor.stubs(
            opt
          )
        end.extend(OnixHelpers::InstanceMethods).extend(MockMethodMissing)
      end
    
      def review_mock(options = {})
        opt = {
          :artificial_id => 137,
          :type_onix_code => Elibri::ONIX::Dict::Release_3_0::OtherTextType::REVIEW,
          :text => 'Recenzja książki',
          :text_author => 'Jan Kowalski', 
          :updated_at => Date.new(2011, 12, 03).to_time + 19.hours + 5.minutes + 28.seconds,
          :exportable? => true,
          :is_a_review? => true,
          :resource_link => 'http://example'
        }.merge(options)
        mock('OtherText').tap do |other_text|
          other_text.stubs(
            opt
          )
        end.extend(MockMethodMissing)
      end
    
      def supply_detail_mock(options = {})
        opt = 
        {
         :supplier_identifier => 'GILD-123',
         :supplier_role_onix_code => Elibri::ONIX::Dict::Release_3_0::SupplierRole::PUB_NON_EXL_DIST,
         :product_availability_onix_code => Elibri::ONIX::Dict::Release_3_0::ProductAvailabilityType::IN_STOCK,
         :supplier => stub('Supplier',
                           :name => 'Gildia.pl',
                           :nip => '521-33-59-408',
                           :phone => '22 631 40 83',
                           :email => 'bok@gildia.pl',
                           :website => 'http://gildia.pl'
                          ),
         :stock_info => stub('stock_info', :exact_info? => true, :on_hand => '1000'),
         :price_infos => [ stub('PriceInfo', :minimum_order_quantity => 20, :amount => 12.99, :vat => 7, :currency_code => 'PLN') ]
        }.merge(options)
         mock('ProductAvailability').tap do |aval|
           aval.stubs(
            opt
            )
        end.extend(MockMethodMissing)
      end
    
      def imprint_mock(options = {})
        opt =
        {
          :name => 'National Geographic'
        }.merge(options)
        mock('Imprint').tap do |impr|
          impr.stubs(
            opt
          )
        end.extend(MockMethodMissing)
      end
      
      def description_mock(options = {})
        opt = 
        {
          :artificial_id => 137,
          :type_onix_code => Elibri::ONIX::Dict::Release_3_0::OtherTextType::MAIN_DESCRIPTION,
          :text => 'Recenzja książki',
          :text_author => 'Jan Kowalski', 
          :updated_at => Date.new(2011, 12, 03).to_time + 19.hours + 5.minutes + 28.seconds,
          :exportable? => true,
          :is_a_review? => false,
          :resource_link => 'http://example' 
        }.merge(options)
        mock('OtherText').tap do |descr|
          descr.stubs(
            opt
          )
        end.extend(MockMethodMissing)
      end
      
      
    end
  end
end