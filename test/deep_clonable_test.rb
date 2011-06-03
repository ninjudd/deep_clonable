require File.dirname(__FILE__) + '/test_helper.rb'

class TestClass
  deep_clonable

  attr_reader :num, :hash, :array

  def initialize(num, hash, array)
    @num   = num
    @hash  = hash
    @array = array
  end

  clone_method :+, :add!
  def add!(other)
    @num += other.num
    @hash.merge!(other.hash)
    @array.concat(other.array)
  end

  clone_method :invert
  def invert!
    @num  = -(@num)
    @hash = @hash.invert
    @array.reverse!
  end
end

class DeepClonableTest < Test::Unit::TestCase
  should "clone method" do
    a = TestClass.new(10, {:a => 1}, [1,2,3])
    b = a.invert

    assert_equal(10,        a.num)
    assert_equal({:a => 1}, a.hash)
    assert_equal([1,2,3],   a.array)

    assert_equal(-10,       b.num)
    assert_equal({1 => :a}, b.hash)
    assert_equal([3,2,1],   b.array)
  end

  should 'clone method with rename' do
    a = TestClass.new(10, {:a => 1}, [1])
    b = TestClass.new(20, {:b => 2}, [2,3])
    c = a + b

    assert_equal(10,        a.num)
    assert_equal({:a => 1}, a.hash)
    assert_equal([1],       a.array)

    assert_equal(20,        b.num)
    assert_equal({:b => 2}, b.hash)
    assert_equal([2,3],     b.array)

    assert_equal(30,                 c.num)
    assert_equal({:a => 1, :b => 2}, c.hash)
    assert_equal([1,2,3],            c.array)
  end

  should "return a frozen object when cloning a frozen object" do
    a = TestClass.new(10, {:a => 1}, [1,2,3]).freeze

    assert_raises(TypeError) do
      a.invert!
    end

    b = a.invert

    assert_equal(10,        a.num)
    assert_equal({:a => 1}, a.hash)
    assert_equal([1,2,3],   a.array)

    assert_equal(-10,       b.num)
    assert_equal({1 => :a}, b.hash)
    assert_equal([3,2,1],   b.array)

    assert a.frozen?
    assert b.frozen?
    assert a.clone.frozen?
  end

  should "unfreeze an object when duping" do
    a = TestClass.new(10, {:a => 1}, [1,2,3]).freeze
    b = a.dup

    assert  a.frozen?
    assert !b.frozen?

    b.invert!

    assert_equal(10,        a.num)
    assert_equal({:a => 1}, a.hash)
    assert_equal([1,2,3],   a.array)

    assert_equal(-10,       b.num)
    assert_equal({1 => :a}, b.hash)
    assert_equal([3,2,1],   b.array)
  end
end
