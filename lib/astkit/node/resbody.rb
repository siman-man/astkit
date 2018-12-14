class AbstractSyntaxTreeKit
  class Node
    class RESBODY < Node
      attr_reader :exceptions, :clause, :next_rescue

      def initialize(node:, exceptions:, clause:, next_rescue:)
        super(node)
        @exceptions = exceptions
        @clause = clause
        @next_rescue = next_rescue
      end
    end
  end
end
