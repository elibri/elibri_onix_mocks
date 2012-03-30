module OnixHelpers
  extend ActiveSupport::Concern

  module InstanceMethods

    #zwróć różne poziomy tytułu, w formacie potrzebnym do exportu w ONIX-ie
    def title_parts
      [].tap do |res|
        product_code =  Elibri::ONIX::Dict::Release_3_0::TitleElementLevel::PRODUCT      #01
        collection_code = Elibri::ONIX::Dict::Release_3_0::TitleElementLevel::COLLECTION #02
        res << OpenStruct.new(:level => collection_code, :title => collection.name, :part => self.collection_part) if collection
        res << OpenStruct.new(:level => product_code, :title => self.title, :subtitle => self.subtitle, :part => self.title_part) if self.title.present?
      end
    end


    # Zwróć datę publikacji w formacie ONIX
    def publication_date(format = :onix, splitter = nil)
      publication_year_str = self.publication_year ? "%04d"% self.publication_year : nil
      publication_month_str = self.publication_month ? "%02d"% self.publication_month : nil
      publication_day_str = self.publication_day ? "%02d"% self.publication_day : nil

      case format
        when :onix
          splitter ||= ''
          date_string = [publication_year_str, publication_month_str, publication_day_str].compact.join(splitter)
        when :polish
          splitter ||= '.'
          date_string = [publication_day_str, publication_month_str, publication_year_str].compact.join(splitter)
      end
      date_string.blank? ? nil : date_string
    end


    def publication_date_with_onix_format_code
       #lista 55
       if self.publication_year.present? && self.publication_month.present? && self.publication_day.present?
         [publication_date, Elibri::ONIX::Dict::Release_3_0::DateFormat::YYYYMMDD]
       elsif self.publication_year.present? && self.publication_month.present?
         [self.publication_year.to_s + "%02d" % self.publication_month, Elibri::ONIX::Dict::Release_3_0::DateFormat::YYYYMM] 
       elsif self.publication_year.present?
         [self.publication_year.to_s, Elibri::ONIX::Dict::Release_3_0::DateFormat::YYYY]
       else
         [nil, nil]
       end
    end


    # Parsuj datę publikacji z ONIX`a (YYYYMMDD) i uzupełnij odpowiednie pola
    def publication_date=(date_from_xml)
      if match = date_from_xml.to_s.match(/ (\d{4}) [\s-]? (\d{2})? [\s-]? (\d{2})? /x)
        self.publication_year = $1
        self.publication_month = $2
        self.publication_day = $3
      else
        self.publication_year = self.publication_month = self.publication_day = nil if date_from_xml.blank?
      end
    end


    # TODO
    def notification_type
      if current_state == :private
        raise "Cannot handle private state"
      elsif current_state == :announced
        Elibri::ONIX::Dict::Release_3_0::NotificationType.find_by_onix_code(Elibri::ONIX::Dict::Release_3_0::NotificationType::EARLY_NOTIFICATION)
      elsif current_state == :preorder
        Elibri::ONIX::Dict::Release_3_0::NotificationType.find_by_onix_code(Elibri::ONIX::Dict::Release_3_0::NotificationType::ADVANCED_NOTIFICATION)
      else
        Elibri::ONIX::Dict::Release_3_0::NotificationType.find_by_onix_code(Elibri::ONIX::Dict::Release_3_0::NotificationType::CONFIRMED_ON_PUBLICATION)
      end
    end
    
    #hack wynikający z nieobecności maszyny stanów
    def current_state
      state
    end


    def publishing_status_onix_code
      if current_state.to_sym == :private #domyślny stan
        raise "Cannot handle private state"
      elsif current_state.to_sym == :announced    #zapowiedź
        Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::FORTHCOMING
      elsif current_state.to_sym == :preorder     #przedsprzedaż
        Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::FORTHCOMING
      elsif current_state.to_sym == :published    #dostępna na rynku
        Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::ACTIVE
      elsif current_state.to_sym == :out_of_print #nakład wyczerpany
        Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::OUT_OF_PRINT
      elsif current_state.to_sym == :deleted      #błędnie stworzony rekord
        Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::UNSPECIFIED
      else
        raise "Don't know how to handle state = #{current_state}"
      end
    end

    def publishing_status_onix_code=(code)
      if code.present?
        if code == Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::ACTIVE
          self.state = "published"
        elsif code == Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::OUT_OF_PRINT
          self.state = "out_of_print"
        elsif code == Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode::FORTHCOMING
          self.state = "preorder"
        else
          raise "Don't know how to handle publishing_stats_onix_code = #{code}"
        end
      end
    end

    def form
      Elibri::ONIX::Dict::Release_3_0::ProductFormCode.find_by_onix_code(self.product_form_onix_code)
    end

    def publishing_status
      Elibri::ONIX::Dict::Release_3_0::PublishingStatusCode.find_by_onix_code(self.publishing_status_onix_code)
    end

    def epub_technical_protection
      Elibri::ONIX::Dict::Release_3_0::EpubTechnicalProtection.find_by_onix_code(self.epub_technical_protection_onix_code)
    end

    def form_detail
      Elibri::ONIX::Dict::Release_3_0::ProductFormDetail.find_by_onix_code(self.product_form_detail_onix_code)
    end

    def audience_range_present?
      self.audience_age_from.present? or self.audience_age_to.present?
    end


    def authorship_kind
      value = self.method_missing(:authorship_kind) || :user_given
      ActiveSupport::StringInquirer.new(value.to_s)
    end


    def series_membership_kind
      value = self.method_missing(:series_membership_kind) || :user_given
      ActiveSupport::StringInquirer.new(value.to_s)
    end


    def series_names
      self.series_memberships.map {|series_membership| series_membership.publisher_series.try(:name)}.compact
    end

    def stock_quantity_for_merlin
      if stock_quantity.nil?
        0
      elsif stock_quantity > 50
        50
      else
        stock_quantity
      end
    end

  end
end