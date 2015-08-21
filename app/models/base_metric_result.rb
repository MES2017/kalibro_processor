class BaseMetricResult < ActiveRecord::Base
  attr_writer :metric
  belongs_to :module_result

  scope :tree_results, -> { where(type: 'MetricResult') }
  scope :hotspot_results, -> { where(type: 'HotspotResult') }

  self.table_name = "metric_results"

  def metric_configuration=(value)
    self.metric_configuration_id = value.id
  end

  def metric_configuration
    # This is a low level Rails caching
    # With this there is a HUGE speed up on the Runner
    Rails.cache.fetch("processing/#{self.module_result.processing_id}/metric_configuration/#{self.metric_configuration_id}", expires_in: Delayed::Worker.max_run_time) do
      @metric_configuration ||= KalibroClient::Entities::Configurations::MetricConfiguration.find(self.metric_configuration_id)
    end
  end

  def metric
    @metric ||= self.metric_configuration.metric
  end

  def types
    %w(MetricResult HotspotResult)
  end
end
