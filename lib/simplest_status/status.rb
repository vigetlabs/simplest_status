module SimplestStatus
  class Status
    attr_reader :name, :value

    def initialize(input)
      @name, @value = Array(input)
    end

    def symbol
      name.to_sym
    end

    def string
      name.to_s
    end
    alias :to_s :string

    def to_hash
      { name => value }
    end

    def matches?(input)
      [string, value.to_s].include? input.to_s
    end

    def constant_name
      string.upcase
    end

    def label
      string.split(/[\s_-]+/).map(&:capitalize).join(' ')
    end

    def for_select
      [label, value]
    end

    def ==(status)
      Hash(self) == Hash(status)
    end
  end
end
