require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @capacity = 4
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
    res = self[@length-1]
    @length -= 1 
    res 
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    self.[]=(@length, val)
    @length += 1 
  end

  # O(n): has to shift over all the elements.
  def shift
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
  end
end
