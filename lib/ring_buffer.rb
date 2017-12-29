require_relative "static_array"
require 'byebug'
class RingBuffer
  attr_reader :length

  def initialize
    @capacity = 8
    @length = 0
    @start_idx = 0 
    @store = StaticArray.new(@capacity)
  end

  # O(1)
  def [](index)
    @store[check_index(index)]
  end

  # O(1)
  def []=(index, value)
    @store[(index + @start_idx) % @capacity] = value
  end

  # O(1)
  def pop
    if @length==0 
      raise "index out of bounds"
    end
    res = @store[end_idx-1]
    @length -= 1 
    res 
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.

  def end_idx 
    (@start_idx + @length) % @capacity
  end 

  def push(val)
    if(@length==@capacity)
      resize!
    end 
    self.[]=(end_idx, val)
    @length += 1 
  end

  # O(1)
  def shift
    if @length==0 
      raise 'index out of bounds'
    end 
    res = self[@start_idx]
    @start_idx = (@start_idx+1) % @capacity
    @length -= 1 
    res 
  end

  # O(1) ammortized
  def unshift(val)
    if (@length==0)
      @store[@start_idx] = val
    else 
      @store[(@start_idx-1) % @capacity] = val
      @start_idx = (@start_idx-1) % @capacity
    end 
    @length += 1
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    actual = (index + @start_idx) % @capacity
    if @store[actual] == nil 
      raise 'index out of bounds'
    end
    actual 
  end

  def resize!
  end
end
