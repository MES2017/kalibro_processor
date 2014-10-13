module MetricCollector
  module Native
    module MetricFu
      class Collector < MetricCollector::Base
        def initialize
          description = YAML.load_file("#{Rails.root}/lib/metric_collector/native/descriptions.yml")["metric_fu"]
          super("MetricFu", description, {}) #FIXME: the last attribute should be a call to `parse_supported_metrics`
        end

        def collect_metrics(code_directory, wanted_metric_configurations, processing)
          runner = Runner.new(repository_path: code_directory)

          runner.run
          MetricCollector::Native::MetricFu::Parser.parse_all(runner.yaml_path, wanted_metric_configurations, processing)
          runner.clean_output
        end

        private

        #FIXME: def parse_supported_metrics; end
      end
    end
  end
end
