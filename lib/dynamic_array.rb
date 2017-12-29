require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @capacity = 8
    @length = 0
    @store = StaticArray.new(@capacity)
  end

  # O(1)
  def [](index)
    if index>=@length
      raise "index out of bounds"
    else 
      @store[index]
    end
  end

  # O(1)
  def []=(index, value)
    if index>@length
      raise "index out of bounds"
    else 
      @store[index] = value
    end
  end

  # O(1)
  def pop
    if @length==0 
      raise "index out of bounds"
    end
    res = self[@length-1]
    @length -= 1 
    res 
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    if(@length==@capacity)
      resize!
    end 
    self.[]=(@length, val)
    @length += 1 
  end

  # O(n): has to shift over all the elements.
  def shift
    if @length==0 
      raise "index out of bounds"
    end 

    res = @store[0]
    (1..@length-1).each do |idx| 
      @store[idx-1] = @store[idx]
    end
    @length -= 1 
    res 
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    if(@length==@capacity)
      resize!
    end 
    new_store = StaticArray.new(@capacity)
    new_store[0] = val
    (0..@length-1).each do |idx| 
      new_store[idx+1] = self[idx]
    end
    @store = new_store
    @length += 1  
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity = @capacity*2
    new_store = StaticArray.new(@capacity)
    (0..@length-1).each do |idx| 
      new_store[idx] = self[idx]
    end
    @store = new_store
  end
end
