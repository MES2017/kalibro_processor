module Processor
  class Interpreter < ProcessingStep
    protected

    def self.task(context)
      all_module_results = context.processing.root_module_result.pre_order

      all_module_results.each do | module_result_child |
        factors = get_factors(module_result_child.tree_metric_results)
        numerator = factors[0]
        denominator = factors[1]

        module_result_child.update(grade: calculate_quotient(numerator, denominator))
      end
    end

    def self.state
      "INTERPRETING"
    end

    def self.get_factors(results)
      factors = [0, 0]

      results.each do |result|
        weight = result.metric_configuration.weight
        factors[0] += weight * get_grade(result)
        factors[1] += weight
      end

      factors
    end

    def self.get_grade(tree_metric_result)
      tree_metric_result.has_grade? ? tree_metric_result.range.reading.grade : 0
    end

    def self.calculate_quotient(numerator, denominator)
      denominator == 0 ? 0 : numerator/denominator
    end

  end
end
