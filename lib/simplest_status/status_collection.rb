require "active_support/inflector"

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
      find { |status| status.matches?(input) } || NullStatus.new
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

    def configure_for(model)
      tap { ModelMethods.new(model, self).add }
    end

    def status_name
      default
    end

    def model_accessor
      status_name.to_s.pluralize
    end

    private

    NullStatus = Struct.new(:value)
  end
end
