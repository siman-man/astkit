require 'astkit/version'
require 'astkit/node'
require 'astkit/node/fcall'
require 'astkit/node/scope'
require 'astkit/node/lit'
require 'astkit/node/str'
require 'astkit/node/array'
require 'astkit/node/zarray'
require 'astkit/node/defn'
require 'astkit/node/args'
require 'astkit/node/kw_arg'
require 'astkit/node/lasgn'
require 'astkit/node/cdecl'
require 'astkit/node/colon2'
require 'astkit/node/colon3'
require 'astkit/node/const'
require 'astkit/node/call'
require 'astkit/node/opcall'
require 'astkit/node/hash'
require 'astkit/node/nil'
require 'astkit/node/true'
require 'astkit/node/false'
require 'astkit/node/or'
require 'astkit/node/and'
require 'astkit/node/lvar'
require 'astkit/node/if'
require 'astkit/node/vcall'
require 'astkit/node/nbegin'
require 'astkit/node/iter'
require 'astkit/node/dvar'
require 'astkit/node/block'
require 'astkit/node/unless'
require 'astkit/node/case'
require 'astkit/node/when'
require 'astkit/node/case2'
require 'astkit/node/for'
require 'astkit/node/dot2'
require 'astkit/node/dot3'
require 'astkit/node/masgn'
require 'astkit/node/while'
require 'astkit/node/until'
require 'astkit/node/break'
require 'astkit/node/next'
require 'astkit/node/redo'
require 'astkit/node/retry'
require 'astkit/node/rescue'
require 'astkit/node/resbody'
require 'astkit/node/errinfo'
require 'astkit/node/ensure'
require 'astkit/node/gasgn'
require 'astkit/node/module'
require 'astkit/node/class'
require 'astkit/node/iasgn'
require 'astkit/node/cvasgn'
require 'astkit/node/flip2'
require 'astkit/node/flip3'
require 'astkit/node/self'
require 'astkit/node/ivar'
require 'astkit/node/gvar'
require 'astkit/node/cvar'
require 'astkit/node/nth_ref'
require 'astkit/node/back_ref'
require 'astkit/node/qcall'
require 'astkit/node/zsuper'
require 'astkit/node/super'
require 'astkit/node/lambda'
require 'astkit/node/attrasgn'
require 'astkit/node/dsym'
require 'astkit/node/dstr'
require 'astkit/node/evstr'
require 'astkit/node/defined'
require 'astkit/node/sclass'
require 'astkit/node/match'
require 'astkit/node/match2'
require 'astkit/node/match3'
require 'astkit/node/xstr'
require 'astkit/node/return'
require 'astkit/node/values'
require 'astkit/node/yield'
require 'astkit/node/dasgn'
require 'astkit/node/dasgn_curr'
require 'astkit/node/op_asgn1'
require 'astkit/node/op_asgn2'
require 'astkit/node/op_asgn_and'
require 'astkit/node/op_asgn_or'
require 'astkit/node/op_cdecl'
require 'astkit/node/dxstr'
require 'astkit/node/once'
require 'astkit/node/dregx'
require 'astkit/node/undef'
require 'astkit/node/valias'
require 'astkit/node/alias'
require 'astkit/node/defs'
require 'astkit/node/splat'
require 'astkit/node/argspush'

class AbstractSyntaxTreeKit
  HashElement = Struct.new(:key, :value)

  def self.parse(src)
    root = RubyVM::AbstractSyntaxTree.parse(src)
    new.traverse(root)
  end

  def self.walk(node, &block)
    yield node

    case node.type
    when :SCOPE
      if node.body.instance_of?(Array)
        node.body.each do |child|
          walk(child, &block)
        end
      else
        walk(node.body, &block)
      end
    when :FCALL
      walk(node.arguments, &block)
    when :ARRAY
    when :ZARRAY
    when :LIT
    when :STR
    when :ARGS
    else
      raise "Unexpected node type[#{node.type}]"
    end
  end

  def traverse(node)
    return node unless node.instance_of?(RubyVM::AbstractSyntaxTree::Node)

    case node.type
    when :SCOPE
      Node::SCOPE.new(
        node: node,
        local_table: node.children[0],
        arguments: traverse(node.children[1]),
        body: body(node.children[2])
      )
    when :ARRAY
      Node::ARRAY.new(
        node: node,
        elements: elements(node)
      )
    when :ZARRAY
      Node::ZARRAY.new(node: node)
    when :STR
      Node::STR.new(
        node: node,
        value: node.children[0]
      )
    when :FCALL
      Node::FCALL.new(
        node: node,
        method_id: node.children[0],
        arguments: traverse(node.children[1])
      )
    when :LIT
      Node::LIT.new(
        node: node,
        value: node.children[0]
      )
    when :DEFN
      Node::DEFN.new(
        node: node,
        method_id: node.children[0],
        method_definition: traverse(node.children[1])
      )
    when :KW_ARG
      Node::KW_ARG.new(
        node: node,
        body: traverse(node.children[0]),
        next_keyword_argument: traverse(node.children[1])
      )
    when :LASGN
      Node::LASGN.new(
        node: node,
        name: node.children[0],
        value: traverse(node.children[1])
      )
    when :ARGS
      Node::ARGS.new(
        node: node,
        parameter_count: node.children[0],
        rest_argument: node.children[6],
        keyword_arguments: traverse(node.children[7]),
        block_argument: node.children[9]
      )
    when :CDECL
      if node.children[1].instance_of?(Symbol)
        Node::CDECL.new(
          node: node,
          extension: traverse(node.children[0]),
          name: node.children[1],
          value: traverse(node.children[2])
        )
      else
        Node::CDECL.new(
          node: node,
          name: node.children[0],
          value: traverse(node.children[1])
        )
      end
    when :COLON2
      Node::COLON2.new(
        node: node,
        receiver: traverse(node.children[0]),
        name: node.children[1]
      )
    when :COLON3
      Node::COLON3.new(
        node: node,
        name: node.children[0]
      )
    when :CONST
      Node::CONST.new(
        node: node,
        name: node.children[0]
      )
    when :CALL
      Node::CALL.new(
        node: node,
        receiver: traverse(node.children[0]),
        method_id: node.children[1],
        arguments: traverse(node.children[2])
      )
    when :OPCALL
      opcall(node)
    when :HASH
      hash(node)
    when :NIL
      Node::NIL.new(node: node)
    when :TRUE
      Node::TRUE.new(node: node)
    when :FALSE
      Node::FALSE.new(node: node)
    when :OR
      Node::OR.new(
        node: node,
        left: traverse(node.children[0]),
        right: traverse(node.children[1])
      )
    when :AND
      Node::AND.new(
        node: node,
        left: traverse(node.children[0]),
        right: traverse(node.children[1])
      )
    when :LVAR
      Node::LVAR.new(
        node: node,
        name: node.children[0]
      )
    when :IF
      Node::IF.new(
        node: node,
        condition: traverse(node.children[0]),
        body: traverse(node.children[1]),
        els: traverse(node.children[2])
      )
    when :UNLESS
      Node::UNLESS.new(
        node: node,
        condition: traverse(node.children[0]),
        body: traverse(node.children[1]),
        els: traverse(node.children[2])
      )
    when :CASE
      Node::CASE.new(
        node: node,
        expression: traverse(node.children[0]),
        case_clauses: case_clauses(node.children[1])
      )
    when :CASE2
      Node::CASE2.new(
        node: node,
        case_clauses: case_clauses(node.children[1])
      )
    when :WHEN
      if node.children[2]&.type == :WHEN
        Node::WHEN.new(
          node: node,
          expressions: traverse(node.children[0]),
          body: traverse(node.children[1])
        )
      else
        Node::WHEN.new(
          node: node,
          expressions: traverse(node.children[0]),
          body: traverse(node.children[1]),
          els: traverse(node.children[2])
        )
      end
    when :FOR
      Node::FOR.new(
        node: node,
        receiver: traverse(node.children[0]),
        body: traverse(node.children[1])
      )
    when :VCALL
      vcall(node)
    when :BEGIN
      nbegin(node)
    when :ITER
      Node::ITER.new(
        node: node,
        receiver: traverse(node.children[0]),
        body: traverse(node.children[1])
      )
    when :DVAR
      dvar(node)
    when :BLOCK
      block(node)
    when :DOT2
      Node::DOT2.new(
        node: node,
        nd_begin: traverse(node.children[0]),
        nd_end: traverse(node.children[1])
      )
    when :DOT3
      Node::DOT3.new(
        node: node,
        nd_begin: traverse(node.children[0]),
        nd_end: traverse(node.children[1])
      )
    when :MASGN
      Node::MASGN.new(
        node: node,
        rhs: traverse(node.children[0]),
        lhs: traverse(node.children[1]),
        splat: traverse(node.children[2])
      )
    when :WHILE
      Node::WHILE.new(
        node: node,
        condition: traverse(node.children[0]),
        body: traverse(node.children[1])
      )
    when :UNTIL
      Node::UNTIL.new(
        node: node,
        condition: traverse(node.children[0]),
        body: traverse(node.children[1])
      )
    when :BREAK
      Node::BREAK.new(node: node)
    when :NEXT
      Node::NEXT.new(node: node)
    when :REDO
      Node::REDO.new(node: node)
    when :RETRY
      Node::RETRY.new(node: node)
    when :RESCUE
      Node::RESCUE.new(
        node: node,
        body: traverse(node.children[0]),
        rescue_body: traverse(node.children[1]),
        else_body: traverse(node.children[2])
      )
    when :RESBODY
      Node::RESBODY.new(
        node: node,
        exceptions: traverse(node.children[0]),
        clause: traverse(node.children[1]),
        next_rescue: traverse(node.children[2])
      )
    when :ERRINFO
      Node::ERRINFO.new(node: node)
    when :ENSURE
      Node::ENSURE.new(
        node: node,
        body: traverse(node.children[0]),
        clause: traverse(node.children[1])
      )
    when :GASGN
      Node::GASGN.new(
        node: node,
        name: node.children[0],
        value: traverse(node.children[1])
      )
    when :MODULE
      Node::MODULE.new(
        node: node,
        path: traverse(node.children[0]),
        body: traverse(node.children[1])
      )
    when :CLASS
      Node::CLASS.new(
        node: node,
        path: traverse(node.children[0]),
        superclass: traverse(node.children[1]),
        body: traverse(node.children[2])
      )
    when :IASGN
      Node::IASGN.new(
        node: node,
        name: node.children[0],
        value: traverse(node.children[1])
      )
    when :CVASGN
      Node::CVASGN.new(
        node: node,
        name: node.children[0],
        value: traverse(node.children[1])
      )
    when :FLIP2
      Node::FLIP2.new(
        node: node,
        nd_begin: traverse(node.children[0]),
        nd_end: traverse(node.children[1])
      )
    when :FLIP3
      Node::FLIP3.new(
        node: node,
        nd_begin: traverse(node.children[0]),
        nd_end: traverse(node.children[1])
      )
    when :SELF
      Node::SELF.new(node: node)
    when :GVAR
      Node::GVAR.new(
        node: node,
        name: node.children[0]
      )
    when :IVAR
      Node::IVAR.new(
        node: node,
        name: node.children[0]
      )
    when :CVAR
      Node::CVAR.new(
        node: node,
        name: node.children[0]
      )
    when :NTH_REF
      Node::NTH_REF.new(
        node: node,
        name: node.children[0]
      )
    when :BACK_REF
      Node::BACK_REF.new(
        node: node,
        name: node.children[0]
      )
    when :QCALL
      Node::QCALL.new(
        node: node,
        receiver: traverse(node.children[0]),
        method_id: node.children[1],
        arguments: traverse(node.children[2])
      )
    when :ZSUPER
      Node::ZSUPER.new(node: node)
    when :SUPER
      Node::SUPER.new(
        node: node,
        arguments: traverse(node.children[0])
      )
    when :LAMBDA
      Node::LAMBDA.new(
        node: node,
        body: traverse(node.children[0])
      )
    when :ATTRASGN
      Node::ATTRASGN.new(
        node: node,
        receiver: traverse(node.children[0]),
        method_id: node.children[1],
        arguments: traverse(node.children[2])
      )
    when :DSYM
      Node::DSYM.new(
        node: node,
        interpolation: traverse(node.children[0]),
        tail_str: traverse(node.children[1])
      )
    when :DSTR
      Node::DSTR.new(
        node: node,
        pre_str: node.children[0],
        interpolation: traverse(node.children[1]),
        tail_str: traverse(node.children[2])
      )
    when :EVSTR
      Node::EVSTR.new(
        node: node,
        body: traverse(node.children[0])
      )
    when :DEFINED
      Node::DEFINED.new(
        node: node,
        expression: traverse(node.children[0])
      )
    when :SCLASS
      Node::SCLASS.new(
        node: node,
        receiver: traverse(node.children[0]),
        body: traverse(node.children[1])
      )
    when :MATCH
      Node::MATCH.new(
        node: node,
        value: traverse(node.children[0])
      )
    when :MATCH2
      Node::MATCH2.new(
        node: node,
        regexp: traverse(node.children[0]),
        string: traverse(node.children[1])
      )
    when :MATCH3
      Node::MATCH3.new(
        node: node,
        regexp: traverse(node.children[0]),
        string: traverse(node.children[1])
      )
    when :XSTR
      Node::XSTR.new(
        node: node,
        value: node.children[0]
      )
    when :RETURN
      Node::RETURN.new(node: node)
    when :VALUES
      Node::VALUES.new(
        node: node,
        elements: elements(node)
      )
    when :YIELD
      Node::YIELD.new(node: node)
    when :DASGN
      Node::DASGN.new(
        node: node,
        name: node.children[0],
        value: traverse(node.children[1])
      )
    when :DASGN_CURR
      Node::DASGN_CURR.new(
        node: node,
        name: node.children[0],
        value: traverse(node.children[1])
      )
    when :OP_ASGN1
      Node::OP_ASGN1.new(
        node: node,
        receiver: traverse(node.children[0]),
        operator: node.children[1],
        index: traverse(node.children[2]),
        value: traverse(node.children[3])
      )
    when :OP_ASGN2
      # p node.children
    when :OP_ASGN_AND
      Node::OP_ASGN_AND.new(
        node: node,
        variable: traverse(node.children[0]),
        value: traverse(node.children[2])
      )
    when :OP_ASGN_OR
      Node::OP_ASGN_OR.new(
        node: node,
        variable: traverse(node.children[0]),
        value: traverse(node.children[2])
      )
    when :OP_CDECL
      Node::OP_CDECL.new(
        node: node,
        namespace: traverse(node.children[0]),
        operator: node.children[1],
        value: traverse(node.children[2])
      )
    when :DXSTR
      Node::DXSTR.new(
        node: node,
        pre_str: node.children[0],
        interpolation: traverse(node.children[1]),
        tail_str: traverse(node.children[2])
      )
    when :ONCE
      Node::ONCE.new(
        node: node,
        body: traverse(node.children[0])
      )
    when :DREGX
      Node::DREGX.new(
        node: node,
        interpolation: traverse(node.children[0]),
        tail_str: traverse(node.children[1])
      )
    when :UNDEF
      Node::UNDEF.new(
        node: node,
        old_name: traverse(node.children[0])
      )
    when :VALIAS
      Node::VALIAS.new(
        node: node,
        new_name: node.children[0],
        old_name: node.children[1]
      )
    when :ALIAS
      Node::VALIAS.new(
        node: node,
        new_name: traverse(node.children[0]),
        old_name: traverse(node.children[1])
      )
    when :DEFS
      Node::DEFS.new(
        node: node,
        receiver: traverse(node.children[0]),
        name: node.children[1],
        body: traverse(node.children[2])
      )
    when :SPLAT
      Node::SPLAT.new(
        node: node,
        element: traverse(node.children[0])
      )
    when :ARGSPUSH
      Node::ARGSPUSH.new(
        node: node,
        array: traverse(node.children[0]),
        element: traverse(node.children[1])
      )
    else
      raise "Unexpected node type[#{node.type}]"
    end
  end

  private

  def opcall(node)
    Node::OPCALL.new(
      node: node,
      receiver: traverse(node.children[0]),
      method_id: node.children[1],
      arguments: traverse(node.children[2])
    )
  end

  def hash(node)
    Node::HASH.new(
      node: node,
      elements: hash_elements(node.children[0])
    )
  end

  def vcall(node)
    Node::VCALL.new(
      node: node,
      name: node.children[0]
    )
  end

  def nbegin(node)
    Node::NBEGIN.new(
      node: node,
      body: traverse(node.children[0])
    )
  end

  def dvar(node)
    Node::DVAR.new(
      node: node,
      name: node.children[0]
    )
  end

  def block(node)
    Node::BLOCK.new(
      node: node,
      statements: statements(node.children)
    )
  end

  def body(node)
    traverse(node)
  end

  def elements(node)
    node.children[0..-2].map { |child| traverse(child) }
  end

  def hash_elements(node)
    node.children[0..-2].each_slice(2).map do |key_node, value_node|
      HashElement.new(traverse(key_node), traverse(value_node))
    end
  end

  def statements(list)
    list.map { |l| traverse(l) }
  end

  def case_clauses(node)
    list = [traverse(node)]

    if node.children[2]&.type == :WHEN
      list << case_clauses(node.children[2])
    end

    list.flatten
  end
end
