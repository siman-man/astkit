class AbstractSyntaxTreeKit
  class Node
    class DEFN < Node
      attr_reader :method_id, :method_definition

      def initialize(node:, method_id:, method_definition:)
        super(node)
        @method_id = method_id
        @method_definition = method_definition
      end
    end
  end
end
