require File.dirname(__FILE__) + '/test_helper'

class TestClass
  deep_clonable
  
  attr_reader :num
  
  def initialize(n)
    @num = n
  end
  
  clone_method :+, :add!
  def add!(other)
    @num += other.num
  end

  clone_method :invert
  def invert!
    @num = -(@num)
  end
end

class DeepClonableTest < Test::Unit::TestCase
  should 'clone method' do
    a = TestClass.new(10)
    b = a.invert
    
    assert_equal 10,  a.num
    assert_equal 10, -b.num
  end

  should 'clone method with rename' do
    a = TestClass.new(10)
    b = TestClass.new(20)
    c = a + b
    
    assert_equal 30, c.num
    assert_equal 20, b.num
    assert_equal 10, a.num
  end
end
