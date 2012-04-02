# encoding: UTF-8
require 'set'

module Elibri

  # Klasa implementująca logikę wariantów XML produktów. Gdy klient zapłaci za pełne informacje
  # o produkcie, to dostaje bogatszy XML. Poniższa klasa jest tylko helperem, który upraszcza
  # i redukuje kod w innych miejscach aplikacji.
  class XmlVariant
    attr_reader :features

    # Wyjątek zgłaszany przy nieprawidłowej kombinacji wariantu:
    class InvalidFeature < Exception; end

    FEATURES_SEPARATOR = ':'

    # Dostępne elementy XML produktu. Gdy nic nie będzie wybrane, XML będzie zawierał
    # tylko RecordReference.
    FEATURES = ActiveSupport::OrderedHash.new
    FEATURES[:basic_meta] = 'podstawowe meta-dane produktów'
    FEATURES[:media_files] = 'linki do załączników (okładki, fragmenty treści)'
    FEATURES[:other_texts] = 'opisy szczegółowe (spis treści, recenzje)'
    FEATURES[:stocks] = 'stany magazynowe dostawców'

    #jeśli ostatni argument to true, to nie waliduj, czy kobinacja jest prawidłowa,
    #a więc jest jedną z ALL_FEATURES_COMBINATIONS
    def initialize(*features)
      @features = Array(features).flatten
      if @features[-1] === true
        ignore_unknow_combinations = true
        @features.pop
      else
        ignore_unknow_combinations = false
      end
      @features = @features.reject(&:blank?).map(&:to_sym).to_set

      unless (@features - FEATURES.keys).empty?
        raise InvalidFeature.new("Unknown xml features #{@features.inspect}")
      end
      unless ignore_unknow_combinations
        if @features.present? and !ALL_FEATURES_COMBINATIONS.map(&:features).include?(@features)
          raise InvalidFeature.new("Unknow combination of xml features #{@features.inspect}")
        end
      end
    end

    # Wszystkie możliwe kombinacje wariantów XML - zbiór uzupełniany na końcu klasy.
    # Upraszcza kod odświeżacza XML. W celu odświeżenia wszystkich możliwych wariantów XML
    # dla produktu, po prostu iteruję po tej kolekcji.
    ALL_FEATURES_COMBINATIONS = Set.new
    ALL_FEATURES_COMBINATIONS << XmlVariant.new([:basic_meta, :media_files, :other_texts], true)
    ALL_FEATURES_COMBINATIONS << XmlVariant.new([:basic_meta, :media_files, :other_texts, :stocks], true)
    ALL_FEATURES_COMBINATIONS << XmlVariant.new([:stocks], true)


    # Fabryka budująca instancę XmlVariant ze stringu 'basic_meta:media_files:other_texts:stocks'
    def self.deserialize(features_str, ignore_unknow_combinations = false)
      if ignore_unknow_combinations
        XmlVariant.new(features_str.to_s.split(FEATURES_SEPARATOR), true)
      else
        XmlVariant.new(features_str.to_s.split(FEATURES_SEPARATOR))
      end
    end

    def except(*features)
      excluded_features = Array(features).flatten.map(&:to_sym)
      XmlVariant.new( (self.features - excluded_features).to_a )
    end


    def ==(other_xml_variant)
      self.features == other_xml_variant.features
    end


    def eql?(other_xml_variant)
      self == other_xml_variant
    end


    def equal?(other_xml_variant)
      self == other_xml_variant
    end


    # Żeby działało porównywanie w Set`ach
    def hash
      self.features.hash
    end


    def feature_included?(feature)
      self.features.include?(feature.to_sym)
    end


    FEATURES.keys.each do |feature_sym|
      self.class_eval %Q{
        def includes_#{feature_sym}?              #  def includes_other_texts?               
          feature_included?(:#{feature_sym})      #    feature_included?(:other_texts)
        end                                       #  end
      }, __FILE__, __LINE__
    end  


    # Wykorzystywane do utworzenia nazwy pliku XML oraz serializacji wariantu w MySQL.
    # Zwraca np. 'basic_meta:media_files:other_texts:stocks'
    def serialize
      # features muszą być posortowane, aby za każdym razem generować tę samą nazwę - Set nie gwarantuje kolejności.
      self.features.map(&:to_s).sort.join(FEATURES_SEPARATOR) 
    end


    def to_s
      "#<Elibri::XmlVariant: features=#{self.features.inspect}>"
    end

    # Wariant zawierający wszystkie możliwe dane:
    FULL_VARIANT = self.new(FEATURES.keys)
  end

end
