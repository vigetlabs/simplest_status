module SimplestStatus
  class ModelMethods
    attr_reader :model, :statuses

    def initialize(model, statuses)
      @model    = model
      @statuses = statuses
    end

    def add
      define_statuses_accessor_for statuses

      populate_statuses

      process_each_status

      define_status_label_method_for statuses

      set_validations_for statuses
    end

    private

    def define_statuses_accessor_for(statuses)
      model.send :define_singleton_method, statuses.model_accessor do
        instance_variable_get('@' + statuses.model_accessor)
      end
    end

    def populate_statuses
      model.send(:instance_variable_set, '@' + statuses.model_accessor, statuses)
    end

    def process_each_status
      statuses.each do |status|
        set_constant_for status
        define_class_methods_for status, statuses.status_name
        define_instance_methods_for status
      end
    end

    def set_constant_for(status)
      model.send :const_set, status.constant_name, status.value
    end

    def define_class_methods_for(status, status_name)
      model.send :define_singleton_method, status.symbol do
        where(status_name => status.value)
      end
    end

    def define_instance_methods_for(status)
      define_predicate(status, statuses.status_name)
      define_status_setter(status, statuses.status_name)
    end

    def define_predicate(status, status_name)
      model.send :define_method, "#{status.symbol}?" do
        send(status_name) == status.value
      end
    end

    def define_status_setter(status, status_name)
      model.send :define_method, status.symbol do
        update_attributes(status_name => status.value)
      end
    end

    def define_status_label_method_for(statuses)
      model.send :define_method, "#{statuses.status_name}_label" do
        self.class.send(statuses.model_accessor).label_for send(statuses.status_name)
      end
    end

    def set_validations_for(statuses)
      model.send :validates, statuses.status_name, :presence => true, :inclusion => { :in => statuses.values }
    end
  end
end
