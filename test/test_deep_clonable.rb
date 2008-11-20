require File.dirname(__FILE__) + '/test_helper.rb'

class DCTClass
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
  test "simple method clone" do
    a = DCTClass.new(10)
    b = a.invert
    
    assert_equal 10,  a.num
    assert_equal 10, -b.num
  end

  test "complex method clone" do
    a = DCTClass.new(10)
    b = DCTClass.new(20)
    c = a + b
    
    assert_equal 30, c.num
    assert_equal 20, b.num
    assert_equal 10, a.num
  end
end
