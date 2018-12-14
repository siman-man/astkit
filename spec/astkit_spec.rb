RSpec.describe AbstractSyntaxTreeKit, aggregate_failures: true do
  describe '.parse' do
    it 'local assign' do
      src = <<~SRC
        foo = 'hello'
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:LASGN)
      expect(result.body.name).to eq(:foo)
      expect(result.body.value.value).to eq('hello')
    end

    it 'global assign' do
      src = <<~SRC
        $foo = 'hello'
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:GASGN)
      expect(result.body.name).to eq(:$foo)
      expect(result.body.value.value).to eq('hello')
    end

    it 'dynamic assign' do
      src = <<~SRC
        x = nil
        1.times { x = 15 }
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.statements[1].body.body.type).to eq(:DASGN)
      expect(result.body.statements[1].body.body.name).to eq(:x)
      expect(result.body.statements[1].body.body.value.value).to eq(15)
    end

    it 'dynamic assign (current scope)' do
      src = <<~SRC
        1.times { x = 15 }
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.body.body.type).to eq(:DASGN_CURR)
      expect(result.body.body.body.name).to eq(:x)
      expect(result.body.body.body.value.value).to eq(15)
    end

    it 'local var' do
      src = <<~SRC
        foo = 1
        foo
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.statements[1].type).to eq(:LVAR)
      expect(result.body.statements[1].name).to eq(:foo)
    end

    it 'instance var' do
      src = <<~SRC
        @foo
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:IVAR)
      expect(result.body.name).to eq(:@foo)
    end

    it 'class var' do
      src = <<~SRC
        @@foo
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:CVAR)
      expect(result.body.name).to eq(:@@foo)
    end

    it 'global var' do
      src = <<~SRC
        $foo
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:GVAR)
      expect(result.body.name).to eq(:$foo)
    end

    it 'special var(nth)' do
      src = <<~SRC
        $1
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:NTH_REF)
      expect(result.body.name).to eq(:$1)
    end

    it 'special var(back ref)' do
      src = <<~SRC
        $&
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:BACK_REF)
      expect(result.body.name).to eq(:$&)
    end

    it 'array assignment' do
      src = <<~SRC
        foo[0] += 1
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:OP_ASGN1)
      expect(result.body.receiver.name).to eq(:foo)
      expect(result.body.operator).to eq(:+)
      expect(result.body.index.elements[0].value).to eq(0)
      expect(result.body.value.value).to eq(1)
    end

    xit 'field assignment' do
      src = <<~SRC
        foo.bar += 1
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:OP_ASGN1)
      expect(result.body.receiver.name).to eq(:foo)
      expect(result.body.operator).to eq(:+)
      expect(result.body.index.elements[0].value).to eq(0)
      expect(result.body.value.value).to eq(1)
    end

    it 'and assignment' do
      src = <<~SRC
        foo &&= 1
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:OP_ASGN_AND)
    end

    it 'or assignment' do
      src = <<~SRC
        foo ||= 1
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:OP_ASGN_OR)
    end

    it 'add' do
      src = <<~SRC
        1 + 2
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:OPCALL)
      expect(result.body.receiver.value).to eq(1)
      expect(result.body.method_id).to eq(:+)
      expect(result.body.arguments.elements.first.value).to eq(2)
    end

    it 'sub' do
      src = <<~SRC
        8 - 5
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:OPCALL)
      expect(result.body.receiver.value).to eq(8)
      expect(result.body.method_id).to eq(:-)
      expect(result.body.arguments.elements.first.value).to eq(5)
    end

    it 'mul' do
      src = <<~SRC
        3 * 4
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:OPCALL)
      expect(result.body.receiver.value).to eq(3)
      expect(result.body.method_id).to eq(:*)
      expect(result.body.arguments.elements.first.value).to eq(4)
    end

    it 'div' do
      src = <<~SRC
        8 / 2
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:OPCALL)
      expect(result.body.receiver.value).to eq(8)
      expect(result.body.method_id).to eq(:/)
      expect(result.body.arguments.elements.first.value).to eq(2)
    end

    it 'hash' do
      src = <<~SRC
        { foo: 1, bar: 'hello' }
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.elements.size).to eq(2)
      expect(result.body.elements[0].key.value).to eq(:foo)
      expect(result.body.elements[0].value.value).to eq(1)
      expect(result.body.elements[1].key.value).to eq(:bar)
      expect(result.body.elements[1].value.value).to eq('hello')
    end

    it 'regexp' do
      src = <<~SRC
        reg = /\\d+/
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.name).to eq(:reg)
      expect(result.body.value.value).to eq(/\d+/)
    end

    it 'regexp (with once option)' do
      src = <<~'SRC'
        /foo#{ bar }baz/o
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:ONCE)
    end

    it 'nil' do
      src = <<~SRC
        nil
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:NIL)
      expect(result.body.value).to eq(nil)
    end

    it 'true' do
      src = <<~SRC
        true
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:TRUE)
      expect(result.body.value).to eq(true)
    end

    it 'false' do
      src = <<~SRC
        false
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:FALSE)
      expect(result.body.value).to eq(false)
    end

    it '||' do
      src = <<~SRC
        true || false
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:OR)
      expect(result.body.left.value).to eq(true)
      expect(result.body.right.value).to eq(false)
    end

    it 'or' do
      src = <<~SRC
        true or false
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:OR)
      expect(result.body.left.value).to eq(true)
      expect(result.body.right.value).to eq(false)
    end

    it '&&' do
      src = <<~SRC
        true && false
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:AND)
      expect(result.body.left.value).to eq(true)
      expect(result.body.right.value).to eq(false)
    end

    it 'and' do
      src = <<~SRC
        true and false
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:AND)
      expect(result.body.left.value).to eq(true)
      expect(result.body.right.value).to eq(false)
    end

    it '+=' do
      src = <<~SRC
        n += 1
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:LASGN)
      expect(result.body.name).to eq(:n)
      expect(result.body.value.method_id).to eq(:+)
      expect(result.body.value.arguments.elements.first.value).to eq(1)
    end

    %i(% ^ & | == != > >= < <= === **).each do |op|
      it do
        src = <<~SRC
          1 #{op} 2
        SRC

        result = AbstractSyntaxTreeKit.parse(src)
        expect(result.body.type).to eq(:OPCALL)
        expect(result.body.receiver.value).to eq(1)
        expect(result.body.method_id).to eq(op)
        expect(result.body.arguments.elements.first.value).to eq(2)
      end
    end

    it 'constant' do
      src = <<~SRC
        FOO
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:CONST)
      expect(result.body.name).to eq(:FOO)
    end

    it 'constant with operator' do
      src = <<~SRC
        A::B ||= 1
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:OP_CDECL)
      expect(result.body.operator).to eq(:"||")
    end

    it 'scope constant' do
      src = <<~SRC
        Foo::Bar
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:COLON2)
      expect(result.body.name).to eq(:Bar)
    end

    it 'top-level constant' do
      src = <<~SRC
        ::Foo
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:COLON3)
      expect(result.body.name).to eq(:Foo)
    end

    it 'constant assign' do
      src = <<~SRC
        FOO = 3.14
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:CDECL)
      expect(result.body.name).to eq(:FOO)
      expect(result.body.value.value).to eq(3.14)
    end

    it 'constant with extension' do
      src = <<~SRC
        FOO::BAR = 3
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.extension.receiver.name).to eq(:FOO)
      expect(result.body.name).to eq(:BAR)
      expect(result.body.value.value).to eq(3)
    end

    it 'array literal' do
      src = <<~SRC
        [1, 2, 3]
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:ARRAY)
      expect(result.body.elements[0].value).to eq(1)
      expect(result.body.elements[1].value).to eq(2)
      expect(result.body.elements[2].value).to eq(3)
    end

    it 'empty array' do
      src = <<~SRC
        []
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:ZARRAY)
      expect(result.body.value).to eq([])
      expect(result.body.first_column).to eq(0)
      expect(result.body.first_lineno).to eq(1)
      expect(result.body.last_column).to eq(2)
      expect(result.body.last_lineno).to eq(1)
    end

    it 'string literal' do
      src = <<~SRC
        'hello'
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:STR)
      expect(result.body.value).to eq('hello')
    end

    it 'query string' do
      src = <<~SRC
        `ls`
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:XSTR)
      expect(result.body.value).to eq('ls')
    end

    it 'dynamic query string' do
      src = <<~'SRC'
        `ls #{option} ./`
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:DXSTR)
      expect(result.body.pre_str).to eq('ls ')
    end

    it 'string literal (%q)' do
      src = <<~SRC
        %q(hello)
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:STR)
      expect(result.body.value).to eq('hello')
    end

    it 'dot3' do
      src = <<~SRC
        1...5
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:DOT3)
      expect(result.body.begin.value).to eq(1)
      expect(result.body.end.value).to eq(5)
    end

    it 'multiple assign' do
      src = <<~SRC
        a, b = 1, 2
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:MASGN)
      expect(result.body.rhs.elements[0].value).to eq(1)
      expect(result.body.rhs.elements[1].value).to eq(2)
      expect(result.body.lhs.elements[0].name).to eq(:a)
      expect(result.body.lhs.elements[1].name).to eq(:b)
    end

    it 'splat args' do
      src = <<~SRC
        foo(*[1, 2, 3])
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.arguments.type).to eq(:SPLAT)
      expect(result.body.arguments.element.elements[0].value).to eq(1)
      expect(result.body.arguments.element.elements[1].value).to eq(2)
      expect(result.body.arguments.element.elements[2].value).to eq(3)
    end

    it 'splat and post args' do
      src = <<~SRC
        foo(*bar, baz)
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.arguments.type).to eq(:ARGSPUSH)
    end

    it 'function' do
      src = <<~SRC
        def foo; end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:DEFN)
      expect(result.body.method_definition.arguments.parameter_count).to eq(0)
    end

    it 'function with argument' do
      src = <<~SRC
        def foo(a); end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:DEFN)
      expect(result.body.method_definition.arguments.parameter_count).to eq(1)
    end

    it 'function with keyword argument' do
      src = <<~SRC
        def foo(a:, b:, c:); end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:DEFN)
      expect(result.body.method_definition.arguments.parameter_count).to eq(0)
    end

    it 'function with rest argument' do
      src = <<~SRC
        def foo(*rest); end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:DEFN)
      expect(result.body.method_definition.arguments.parameter_count).to eq(0)
      expect(result.body.method_definition.arguments.rest_argument).to eq(:rest)
    end

    it 'function with block argument' do
      src = <<~SRC
        def foo(&block); end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:DEFN)
      expect(result.body.method_definition.arguments.parameter_count).to eq(0)
      expect(result.body.method_definition.arguments.block_argument).to eq(:block)
    end

    it 'singleton method definition' do
      src = <<~SRC
        def obj.foo; end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:DEFS)
    end

    it 'method call' do
      src = <<~SRC
        1.to_s
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:CALL)
      expect(result.body.method_id).to eq(:to_s)
      expect(result.body.arguments).to eq(nil)
    end

    it 'method call (empty arguments)' do
      src = <<~SRC
        1.to_s()
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:CALL)
      expect(result.body.method_id).to eq(:to_s)
      expect(result.body.arguments).to eq(nil)
    end

    it 'method call with arguments' do
      src = <<~SRC
        10.to_s(16)
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:CALL)
      expect(result.body.method_id).to eq(:to_s)
      expect(result.body.arguments.elements[0].value).to eq(16)
    end

    it 'safe navigation operator' do
      src = <<~SRC
        foo&.bar(1)
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:QCALL)
      expect(result.body.method_id).to eq(:bar)
    end

    it 'super' do
      src = <<~SRC
        super
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:ZSUPER)
    end

    it 'super with arguments' do
      src = <<~SRC
        super(1, 2, 3)
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:SUPER)
      expect(result.body.arguments.elements[0].value).to eq(1)
    end

    it 'lambda arrow' do
      src = <<~SRC
        ->(x) { x * 3 }
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:LAMBDA)
    end

    it 'attr assign' do
      src = <<~SRC
        foo.bar = 'baz'
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:ATTRASGN)
      expect(result.body.method_id).to eq(:bar=)
      expect(result.body.arguments.elements[0].value).to eq('baz')
    end

    it 'interpolation' do
      src = <<~'SRC'
        "foo#{bar}baz"
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:DSTR)
      expect(result.body.pre_str).to eq('foo')
    end

    it 'dynamic symbol' do
      src = <<~'SRC'
        :"foo#{bar}baz"
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:DSYM)
    end

    it 'undef' do
      src = <<~SRC
        undef foo
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:UNDEF)
      expect(result.body.old_name.value).to eq(:foo)
    end

    it 'method alias' do
      src = <<~SRC
        alias foo bar
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:ALIAS)
      expect(result.body.new_name.value).to eq(:foo)
      expect(result.body.old_name.value).to eq(:bar)
    end

    it 'global var alias' do
      src = <<~SRC
        alias $y $x
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:VALIAS)
      expect(result.body.new_name).to eq(:$y)
      expect(result.body.old_name).to eq(:$x)
    end

    it 'module' do
      src = <<~SRC
        module Foo
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:MODULE)
      expect(result.body.path.name).to eq(:Foo)
    end

    it 'class' do
      src = <<~SRC
        class Foo
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:CLASS)
      expect(result.body.path.name).to eq(:Foo)
    end

    it 'singleton class' do
      src = <<~SRC
        class A
          class << self
            def say
              'hello'
            end
          end
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.body.body.statements[1].type).to eq(:SCLASS)
    end

    it 'yield' do
      src = <<~SRC
        def foo
          yield
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.method_definition.body.type).to eq(:YIELD)
    end

    it 'instance variable' do
      src = <<~SRC
        @foo = 3
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:IASGN)
      expect(result.body.name).to eq(:@foo)
      expect(result.body.value.value).to eq(3)
    end

    it 'class variable' do
      src = <<~SRC
        @@foo = 3
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:CVASGN)
      expect(result.body.name).to eq(:@@foo)
      expect(result.body.value.value).to eq(3)
    end

    it 'flip flop2' do
      src = <<~SRC
        list.each do |n|
          if (n == 2)..(n == 4)
            p n
          end
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.body.body.condition.type).to eq(:FLIP2)
    end

    it 'flip flop3' do
      src = <<~SRC
        list.each do |n|
          if (n == 2)...(n == 4)
            p n
          end
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.body.body.condition.type).to eq(:FLIP3)
    end

    it 'if' do
      src = <<~SRC
        if n > 10
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:IF)
      expect(result.body.condition.receiver.name).to eq(:n)
      expect(result.body.condition.arguments.elements[0].value).to eq(10)
    end

    it 'if - else' do
      src = <<~SRC
        if n > 10
          'foo'
        else
          'bar'
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:IF)
      expect(result.body.condition.receiver.name).to eq(:n)
      expect(result.body.condition.arguments.elements[0].value).to eq(10)
      expect(result.body.body.value).to eq('foo')
      expect(result.body.els.value).to eq('bar')
    end

    it 'if - elsif - else' do
      src = <<~SRC
        if n > 10
          'foo'
        elsif n > 5
          'bar'
        else
          'baz'
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:IF)
      expect(result.body.condition.receiver.name).to eq(:n)
      expect(result.body.condition.arguments.elements[0].value).to eq(10)
      expect(result.body.body.value).to eq('foo')
      expect(result.body.els.condition.receiver.name).to eq(:n)
    end

    it 'unless' do
      src = <<~SRC
        unless n > 10
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:UNLESS)
      expect(result.body.condition.receiver.name).to eq(:n)
      expect(result.body.condition.arguments.elements[0].value).to eq(10)
    end

    it 'unless - else' do
      src = <<~SRC
        unless n > 10
          'foo'
        else
          'bar'
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:UNLESS)
      expect(result.body.condition.receiver.name).to eq(:n)
      expect(result.body.condition.arguments.elements[0].value).to eq(10)
      expect(result.body.body.value).to eq('foo')
      expect(result.body.els.value).to eq('bar')
    end

    it 'case - when' do
      src = <<~SRC
        case rand(4)
        when 0
          '0'
        when 1, 2
          '1'
        else
          '2'
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:CASE)
      expect(result.body.case_clauses[0].expressions.elements[0].value).to eq(0)
      expect(result.body.case_clauses[0].body.value).to eq('0')
      expect(result.body.case_clauses[1].expressions.elements[0].value).to eq(1)
      expect(result.body.case_clauses[1].expressions.elements[1].value).to eq(2)
      expect(result.body.case_clauses[1].body.value).to eq('1')
      expect(result.body.case_clauses[1].els.value).to eq('2')
    end

    it 'case - when' do
      src = <<~SRC
        case
        when n == 1
          '0'
        when n == 2
          '1'
        else
          '2'
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:CASE2)
      expect(result.body.case_clauses[0].expressions.elements[0].arguments.elements[0].value).to eq(1)
      expect(result.body.case_clauses[0].expressions.elements[0].receiver.name).to eq(:n)
      expect(result.body.case_clauses[0].body.value).to eq('0')
      expect(result.body.case_clauses[1].expressions.elements[0].arguments.elements[0].value).to eq(2)
      expect(result.body.case_clauses[1].expressions.elements[0].receiver.name).to eq(:n)
      expect(result.body.case_clauses[1].body.value).to eq('1')
      expect(result.body.case_clauses[1].els.value).to eq('2')
    end

    it 'for' do
      src = <<~SRC
        for i in 1..3 do
          p i
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:FOR)
      expect(result.body.receiver.type).to eq(:DOT2)
      expect(result.body.receiver.begin.value).to eq(1)
      expect(result.body.receiver.end.value).to eq(3)
    end

    xit 'for multi' do
      src = <<~SRC
        for x, y in [[1, 2], [3, 4]] do 
          p [x, y]
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:FOR)
    end

    it 'while' do
      src = <<~SRC
        while n < 5
          n += 1
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:WHILE)
      expect(result.body.condition.type).to eq(:OPCALL)
      expect(result.body.body.type).to eq(:LASGN)
    end

    it 'until' do
      src = <<~SRC
        until n > 5
          n += 1
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:UNTIL)
      expect(result.body.condition.type).to eq(:OPCALL)
      expect(result.body.body.type).to eq(:LASGN)
    end

    it 'break' do
      src = <<~SRC
        [1, 2, 3].each do |i|
          break if i == 2
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.body.body.body.type).to eq(:BREAK)
    end

    it 'next' do
      src = <<~SRC
        [1, 2, 3].each do |i|
          next if i == 2
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.body.body.body.type).to eq(:NEXT)
    end

    it 'redo' do
      src = <<~SRC
        [1, 2, 3].each do |i|
          redo if i == 2
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.body.body.body.type).to eq(:REDO)
    end

    it 'retry' do
      src = <<~SRC
        [1, 2, 3].each do |i|
          retry if i == 2
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.body.body.body.type).to eq(:RETRY)
    end

    it 'begin - rescue' do
      src = <<~SRC
        begin
          raise 'Error'
        rescue StandardError => ex
          puts ex
        rescue => ex
          puts ex
        else
          'no error'
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:RESCUE)
    end

    it 'ensure' do
      src = <<~SRC
        begin
          3
        ensure
          'ensure'
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:ENSURE)
      expect(result.body.body.value).to eq(3)
      expect(result.body.clause.value).to eq('ensure')
    end

    it 'iterator' do
      src = <<~SRC
        3.times { |i| puts i }
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:ITER)
    end

    it 'self' do
      src = <<~SRC
        self
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:SELF)
    end

    it 'block' do
      src = <<~SRC
        puts 'foo'
        puts 'bar'
        puts 'baz'
        'hello'
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:BLOCK)
      expect(result.body.statements[0].arguments.elements[0].value).to eq('foo')
      expect(result.body.statements[1].arguments.elements[0].value).to eq('bar')
      expect(result.body.statements[2].arguments.elements[0].value).to eq('baz')
      expect(result.body.statements[3].value).to eq('hello')
    end

    it 'defined?' do
      src = <<~SRC
        defined?(foo)
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:DEFINED)
      expect(result.body.expression.name).to eq(:foo)
    end

    it 'match' do
      src = <<~SRC
        if /foo/; end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.condition.type).to eq(:MATCH)
      expect(result.body.condition.value).to eq(/foo/)
    end

    it 'match 2' do
      src = <<~SRC
        /foo/ =~ 'foo'
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:MATCH2)
      expect(result.body.regexp.value).to eq(/foo/)
      expect(result.body.string.value).to eq('foo')
    end

    it 'match 3' do
      src = <<~SRC
        'foo' =~ /foo/
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:MATCH3)
      expect(result.body.regexp.value).to eq(/foo/)
      expect(result.body.string.value).to eq('foo')
    end

    it 'return' do
      src = <<~SRC
        return
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.type).to eq(:RETURN)
    end

    it 'return values' do
      src = <<~SRC
        def foo
          return 1, 2, 3
        end
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      expect(result.body.method_definition.body.type).to eq(:VALUES)
      expect(result.body.method_definition.body.elements[0].value).to eq(1)
      expect(result.body.method_definition.body.elements[1].value).to eq(2)
      expect(result.body.method_definition.body.elements[2].value).to eq(3)
    end
  end

  describe '.walk' do
    it 'empty array' do
      src = <<~SRC
        []
      SRC

      result = AbstractSyntaxTreeKit.parse(src)
      AbstractSyntaxTreeKit.walk(result) do |node|
      end
    end
  end
end
