module FakeEnumerable
  def map 
    if block_given?
      [].tap { |out| each { |e| out << yield(e) } }
    else
      FakeEnumerator.new(self, :map)
    end
  end

  def select
    [].tap { |out| each { |e| out << e if yield(e) } }
  end

  def sort_by
    map { |e| [yield(e), e]}.sort.map { |e| e[1] }
  end

  def reduce(operation_or_value=nil)
    case operation_or_value
    when Symbol
      # convert things like reduce(:+) into reduce { |s,e| s + e }
      return reduce { |s,e| s.send(operation_or_value, e) }
    when nil
      acc = nil
    else
      acc = operation_or_value
    end

    each do |a|
      if acc.nil?
        acc = a
      else
        acc = yield(acc, a)
      end
    end

    return acc
  end
end

require "fiber"
class FakeEnumerator
  include FakeEnumerable

  def initialize(target, iter) 
    @target = target
    @iter   = iter
  end

  def each(&block)
    @target.send(@iter, &block) 
  end

  def next
    @fiber ||= Fiber.new do
      each { |e| Fiber.yield(e) }

      raise StopIteration
    end

    if @fiber.alive?
      @fiber.resume
    else
      raise StopIteration
    end
  end

  def with_index
    i = 0
    each do |e|
      out = yield(e, i)
      i += 1
      out
    end
  end

  def rewind
    @fiber = nil  
  end
end