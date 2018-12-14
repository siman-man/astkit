class AbstractSyntaxTreeKit
  class Node
    class ALIAS < Node
      attr_reader :new_name, :old_name

      def initialize(node:, new_name:, old_name:)
        super(node)
        @new_name = new_name
        @old_name = old_name
      end
    end
  end
end
