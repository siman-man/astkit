class AbstractSyntaxTreeKit
  class Node
    class CASE < Node
      attr_reader :expression, :case_clauses

      def initialize(node:, expression:, case_clauses:)
        super(node)
        @expression = expression
        @case_clauses = case_clauses
      end
    end
  end
end
