require 'set'
require 'kolekti'

require 'metric_collector'

module Processor
  class Collector < ProcessingStep
    protected

    def self.task(context)
      kolekti_collector_names = Set.new(Kolekti.collectors.map(&:name))

      kolekti_metrics, unknown_metrics =
        get_metrics(context.native_metrics, kolekti_collector_names)

      # Work around the fact that Hash#partition does not return hashes
      kolekti_metrics = Hash[kolekti_metrics]
      unknown_metrics = Hash[unknown_metrics]

      raise_unknown_metrics_exception(unknown_metrics)

      collect_kolekti_metrics(context, kolekti_metrics)

      context.processing.reload

      raise_empty_module_results_exception(context.processing.module_results)
    end

    def self.collect_kolekti_metrics(context, wanted_metrics)
      persistence_strategy = MetricCollector::PersistenceStrategy.new(context.processing)
      runner = Kolekti::Runner.new(
        context.repository.code_directory,
        wanted_metrics.values.flatten,
        persistence_strategy
      )

      begin
        runner.run_wanted_metrics
      ensure
        runner.clean_output
      end
    end

    def self.state
      'COLLECTING'
    end

    def self.get_metrics(native_metrics, names)
      native_metrics.partition do |metric_collector_name, _|
        names.include?(metric_collector_name)
      end
    end

    def self.raise_unknown_metrics_exception(unknown_metrics)
      unless unknown_metrics.empty?
        unknown_collector_names = unknown_metrics.keys.join(', ')
        raise Errors::NotFoundError.new("Metric collectors #{unknown_collector_names} not found")
      end
    end

    def self.raise_empty_module_results_exception(module_results)
      raise Errors::EmptyModuleResultsError if module_results.empty?
    end
  end
end
