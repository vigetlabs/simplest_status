module SimplestStatus
  module ModelMethods
    def self.included(base)
      base.class_eval do
        statuses.each do |status_info|
          const_set(status_info.constant_name, status_info.value)

          define_singleton_method status_info.symbol do
            where(:status => status_info.value)
          end

          define_method "#{status_info.symbol}?" do
            status == status_info.value
          end

          define_method status_info.symbol do
            update_attributes(:status => status_info.value)
          end

          define_method :status_label do
            self.class.statuses.label_for(status)
          end
        end

        validates :status, :presence => true, :inclusion => { :in => proc { statuses.values } }
      end
    end
  end
end
