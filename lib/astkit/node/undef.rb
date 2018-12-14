class AbstractSyntaxTreeKit
  class Node
    class UNDEF < Node
      attr_reader :old_name

      def initialize(node:, old_name:)
        super(node)
        @old_name = old_name
      end
    end
  end
end
