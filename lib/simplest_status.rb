require "simplest_status/version"

module SimplestStatus
  autoload :StatusCollection, 'simplest_status/status_collection'
  autoload :ModelMethods,     'simplest_status/model_methods'

  def statuses(*status_list)
    @statuses ||= status_list.reduce(StatusCollection.new) do |collection, status|
      collection.add(status)
    end.tap { send(:include, ModelMethods) }
  end
end
