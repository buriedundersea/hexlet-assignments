# frozen_string_literal: true
# BEGIN
module Model
  DATA_TYPES = { string: :to_s, integer: :to_i, float: :to_f, datetime: :to_datetime, boolean: :to_bool }.freeze
  DEFAULTS = {}

  def self.included(base)
    base.extend(ClassMethods)
  end

  def initialize(hash = {})
    DEFAULTS.each {|k, v| self.instance_variable_set "@#{k}", v }
    hash.each {|k, v| self.instance_variable_set "@#{k}", v }
  end

  def attributes
    self.instance_variables.map do |attribute|
      key = attribute.to_s.gsub('@','').to_sym
      val = attribute.to_s.gsub('@','')
      [key, send(val)]
    end.to_h
  end

  module ClassMethods
    def attribute(name, options = {})
      DEFAULTS[name.to_sym] = options[:default]

      define_method(name) do
        return nil if self.instance_variable_get("@#{name}").nil?
        options.key?(:type) ? self.instance_variable_get("@#{name}").send(DATA_TYPES[options[:type]]) : self.instance_variable_get("@#{name}")
      end

      define_method("#{name}=") { |value| self.instance_variable_set("@#{name}", value) }
    end
  end
end

module NewConvertTypes
  def to_datetime
    DateTime.parse(self.to_s)
  end

  def to_bool
    if self == true || self == false
      self
    elsif self == 0 || self == ""
      false
    else
      true
    end
  end
end

String.include NewConvertTypes
Integer.include NewConvertTypes
Float.include NewConvertTypes
TrueClass.include NewConvertTypes
FalseClass.include NewConvertTypes
NilClass.include NewConvertTypes
# END
