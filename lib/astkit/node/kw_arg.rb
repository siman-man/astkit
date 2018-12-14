class AbstractSyntaxTreeKit
  class Node
    class KW_ARG < Node
      attr_reader :body, :next_keyword_argument

      def initialize(node:, body:, next_keyword_argument:)
        super(node)
        @body = body
        @next_keyword_argument = next_keyword_argument
      end
    end
  end
end
