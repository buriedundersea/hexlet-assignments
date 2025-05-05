# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/stack'
require 'minitest/power_assert'

class StackTest < Minitest::Test
  # BEGIN
  def setup
    @stack = Stack.new([1, 2, 3])
  end

  def test_push
    add_element = 'elem1'
    expecting_greeting = [1, 2, 3, 'elem1']
    assert do
      @stack.push!(add_element)
      @stack.to_a == expecting_greeting
    end
  end

  def test_pop
    expecting_greeting = [1, 2]
    assert do
      @stack.pop!
      @stack.to_a == expecting_greeting
    end
  end

  def test_clear
    expecting_greeting = []
    assert do
      @stack.clear!
      @stack.to_a == expecting_greeting
    end
  end

  def test_empty
    @stack.clear!
    expecting_greeting = true
    assert {@stack.empty? == expecting_greeting}
  end
  # END
end

test_methods = StackTest.new({}).methods.select { |method| method.start_with? 'test_' }
raise 'StackTest has not tests!' if test_methods.empty?
