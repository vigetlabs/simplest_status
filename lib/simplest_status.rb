require "simplest_status/version"

module SimplestStatus
  autoload :StatusCollection, 'simplest_status/status_collection'
  autoload :ModelMethods,     'simplest_status/model_methods'

  def statuses(*status_list)
    instance_variable_get(:@statuses) || simple_status(:status, status_list)
  end

  def simple_status(field_name, values)
    status_collection_for(field_name, values).configure_for(self)
  end

  private

  def status_collection_for(status_method, values)
    values.reduce(StatusCollection.new(status_method)) do |collection, value|
      collection.add(value)
    end.configure_for(self)
  end
end
