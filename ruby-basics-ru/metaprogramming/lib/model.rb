# frozen_string_literal: true

# BEGIN
module Model
  DATA_TYPES = { string: :to_s, integer: :to_i, float: :to_f, datetime: :to_datetime, boolean: :to_bool }.freeze

  def self.included(base)
    base.extend(ClassMethods)
  end

  def initialize(hash = {})
    self.methods.filter { |method| method.to_s.include? ("default") }.each {|method| send(method) }
    hash.each { |k, v| self.instance_variable_set "@#{k}", v }
  end

  def attributes
    self.instance_variables.map do |attribute|
      key = attribute.to_s.gsub('@', '').to_sym
      val = attribute.to_s.gsub('@', '')
      [key, send(val)]
    end.to_h
  end

  # Methods for class
  module ClassMethods
    def attribute(name, options = {})
      define_method("default_#{name}") do
        self.instance_variable_set("@#{name}", options[:default])
      end

      define_method(name) do
        return nil if self.instance_variable_get("@#{name}").nil?

        options.key?(:type) ? self.instance_variable_get("@#{name}").send(DATA_TYPES[options[:type]]) : self.instance_variable_get("@#{name}")
      end

      define_method("#{name}=") { |value| self.instance_variable_set("@#{name}", value) }
    end
  end
end

# Special methods
module NewConvertTypes
  def to_datetime
    DateTime.parse(self.to_s)
  end

  def to_bool
    if self == true || self == false
      self
    elsif self.zero? || self.empty?
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
