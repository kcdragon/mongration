module Mongration

  class Result

    def self.success
      new(true)
    end

    def self.failed
      new(false)
    end

    def self.with(message)
      new(true).with(message)
    end

    def initialize(success)
      @success = success
      @messages = []
    end

    def success?
      @success
    end

    def failed?
      !success?
    end

    def with(messages)
      @messages.concat(Array(messages))
      self
    end

    def success
      @success = true
      self
    end

    def failed
      @success = false
      self
    end

    def each_message(&block)
      @messages.each(&block)
    end

    def merge(other)
      @success &&= other.success?
      @messages.concat(other.messages)
      self
    end

    def ==(other)
      state == other.state
    end
    alias_method :eql?, :==

    protected

    def state
      [@success, @messages]
    end

    def messages
      @messages
    end
  end
end
