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

  def actual_index(idx)
    (idx + @start_idx) % @capacity
  end 

  # O(1)
  def [](index)
    check_index(index)
    @store[actual_index(index)]
  end

  # O(1)
  def []=(index, value)
    check_index(index)
    @store[actual_index(index)] = value
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
    @length += 1  
    self.[]=(@length-1, val)
  end

  # O(1)
  def shift
    if @length==0 
      raise 'index out of bounds'
    end 
    res = @store[@start_idx]
    @start_idx = (@start_idx+1) % @capacity
    @length -= 1 
    res 
  end

  # O(1) ammortized
  def unshift(val)
    if (@length==@capacity)
      resize!
    end 

    if @length==0 
      @store[@start_idx] = val
    else 
      @start_idx = (@start_idx - 1)% @capacity
      @store[@start_idx] = val
    end 
    
    @length += 1 

  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    if index<0 || index>=@length 
      raise 'index out of bounds'
    end 
  end

  def resize!
    new_store = StaticArray.new(@capacity*2)
    (0..@length-1).each do |idx| 
      new_store[idx] = self[idx]
    end
    @capacity = @capacity*2
    @store = new_store
    @start_idx = 0 
  end
end
