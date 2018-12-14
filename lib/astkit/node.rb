class AbstractSyntaxTreeKit
  class Node
    attr_reader :type, :children, :first_column, :first_lineno, :last_column, :last_lineno

    def initialize(node)
      @type = node.type
      @children = node.children
      @first_column = node.first_column
      @first_lineno = node.first_lineno
      @last_column = node.last_column
      @last_lineno = node.last_lineno
    end
  end
end
