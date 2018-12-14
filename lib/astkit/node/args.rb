class AbstractSyntaxTreeKit
  class Node
    class ARGS < Node
      attr_reader :parameter_count, :rest_argument, :keyword_arguments, :block_argument

      def initialize(node:, parameter_count:, rest_argument:, keyword_arguments:, block_argument:)
        super(node)
        @parameter_count = parameter_count
        @rest_argument = rest_argument
        @keyword_arguments = keyword_arguments
        @block_argument = block_argument
      end
    end
  end
end
