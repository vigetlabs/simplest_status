module SimplestStatus
  autoload :Status, 'simplest_status/status'

  class StatusCollection < Hash
    def each
      super do |status|
        yield Status.new(status)
      end
    end

    def [](status_name)
      status_for(status_name).value
    end
    alias :value_for :[]

    def status_for(input)
      find do |status|
        status.matches? input
      end
    end

    def add(status, value = self.size)
      self.merge!(status => value)
    end

    def label_for(value)
      status_for(value).label
    end

    def for_select
      map(&:for_select)
    end
  end
end
