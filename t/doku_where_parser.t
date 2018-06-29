#!perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use Data::Dumper;

my @test_cases = (

  ['x = 1',    [{ exp => [{ lhs => 'x', op => '=', rhs => [num => 1] }] }]],
  ['x = 1.1',  [{ exp => [{ lhs => 'x', op => '=', rhs => [num => 1.1] }] }]],
  ['x = -1',   [{ exp => [{ lhs => 'x', op => '=', rhs => [num => -1] }] }]],
  ['x = +1',   [{ exp => [{ lhs => 'x', op => '=', rhs => [num => 1] }] }]],
  ['x = -1.1', [{ exp => [{ lhs => 'x', op => '=', rhs => [num => -1.1] }] }]],
  ['x = +1.1', [{ exp => [{ lhs => 'x', op => '=', rhs => [num => 1.1] }] }]],
  ['x = -.1',  [{ exp => [{ lhs => 'x', op => '=', rhs => [num => -.1] }] }]],
  ['x = +.1',  [{ exp => [{ lhs => 'x', op => '=', rhs => [num => .1] }] }]],

  ['x = "42"',     [{ exp => [{ lhs => 'x', op => '=', rhs => [str   => '42'] }] }]],
  ["x = '42'",     [{ exp => [{ lhs => 'x', op => '=', rhs => [str   => '42'] }] }]],
  ["x = my_token", [{ exp => [{ lhs => 'x', op => '=', rhs => [token => 'my_token'] }] }]],
  ["x = func()",   [{ exp => [{ lhs => 'x', op => '=', rhs => [func  => 'func'] }] }]],

  ["(x = my_token)", [{ exp => [{ exp => [{ lhs => 'x', op => '=', rhs => [token => 'my_token'] }] }] }]],

  [ 'x = +1.1 or y = "silly string"',
    [ { exp => [
          { lhs => 'x', op => '=', rhs => [num => 1.1] },
          'or',
          { lhs => 'y', op => '=', rhs => [str => 'silly string'] }
        ]
      }
    ]
  ],


  [ '(x = +1.1 or y = "silly string") and(z > 2 or args.xpto <= 3)and a=magical_function()',
    [ { 'exp' => [
          { 'exp' => [
              { 'rhs' => ['num', '1.1'],
                'op'  => '=',
                'lhs' => 'x'
              },
              'or',
              { 'lhs' => 'y',
                'op'  => '=',
                'rhs' => ['str', 'silly string']
              }
            ]
          },
          'and',
          { 'exp' => [
              { 'rhs' => ['num', 2],
                'op'  => '>',
                'lhs' => 'z'
              },
              'or',
              { 'lhs' => 'args.xpto',
                'op'  => '<=',
                'rhs' => ['num', 3]
              }
            ]
          },
          'and',
          { 'lhs' => 'a',
            'op'  => '=',
            'rhs' => ['func', 'magical_function']
          }
        ]
      }
    ]
  ],
);

for my $t (@test_cases) {
  my ($input, $expected) = @$t;

  my $r = eval { where_parser($input) };
  ok($r,       "Input '$input' didn't die ($@)");
  ok($r->{ok}, "... parse was successful")
    or print "### " . Dumper($r);
  cmp_deeply($r->{tree}, $expected, '... parse tree matches expectations')
    or print "### " . Dumper([$r->{tree}, $expected]);
}


done_testing();


###############

sub where_parser {
  my ($value) = @_;

  my @tree;
  my @stack;

  my $find_tokens = sub {
    for my $sp (reverse @stack) {
      return $sp->{tokens} if exists $sp->{tokens};
    }
    return;
  };

  my $push_state = sub {
    my $s = shift;
    push @stack, { @_, state => $s };
  };

  my $push_capture_state = sub {
    my @t;
    push @stack, { state => 'capture_exp', tokens => \@t };
  };

  my $atomic_expression_ends = sub {
    my $tokens = $find_tokens->();

    my $rhs = pop @$tokens;
    my $op  = pop @$tokens;
    my $lhs = pop @$tokens;
    push @$tokens, { lhs => $lhs, op => $op, rhs => $rhs };
  };


  ### Start the ball rolling...
  $push_capture_state->();
  $push_state->('expression');

  while ($value or @stack) {
    my $sp     = $stack[-1];
    my $state  = $sp->{state};
    my $tokens = $find_tokens->();

    $value =~ s/^\s*//sm;    ## remove leading ws - global action

#    print "## ===> [$state (" . @stack . ")] to match: '$value'\n";
#    use Data::Dumper;
#    print "#### ... " . Dumper(\@stack) . "\n";

    ## Expression parsing
    if ($state eq 'expression') {
      pop @stack;
      if ($value =~ s/^\(//) {
        $push_state->('logical_op', optional => 1);
        $push_capture_state->();
        $push_state->('match', token => ')');
        $push_state->('expression');
      }
      else {
        $push_state->('logical_op', optional => 1);
        $push_state->('right_side');
        $push_state->('operator');
        $push_state->('left_side');
      }
      next;
    }

    ## Logical operation between expressions
    if ($state eq 'logical_op') {
      pop @stack;
      if ($value =~ s/^(and|or)\b//i) {
        push @$tokens, $1;
        $push_state->('expression');
      }
      next;
    }

    ## Capture expression
    if ($state eq 'capture_exp') {
      pop @stack;
      my $parent = $find_tokens->() || \@tree;
      push @$parent, { exp => $sp->{tokens} };
      next;
    }

    ## Constant matching
    if ($state eq 'match') {
      my $token = $sp->{token};    ## the token to match
      if ($value =~ s/^\Q$token\E//) {
        pop @stack;
      }
      else {
        return { error => "unmatched token '$token'", ctx => $value };
      }
      next;
    }

    ## Operators
    if ($state eq 'operator') {
      if ($value =~ s/^([=!<>]+)//g) {
        ## TODO: check for valid operators
        push @$tokens, $1;
      }
      else {
        return { error => 'could not parse operator', ctx => $value };
      }
      pop @stack;
      next;
    }

    ## Left side parsing
    if ($state eq 'left_side') {
      if ($value =~ s/^([\w\.]+)//) {    ## a variable
        push @$tokens, $1;
      }
      else {
        return { error => 'could not parse left_side', ctx => $value };
      }
      pop @stack;
      next;
    }

    ## Right side parsing
    if ($state eq 'right_side') {
      if ($value =~ s/^(\w+)\(\)//) {    ## functions...
        push @$tokens, [func => $1];
      }
      elsif ($value =~ s/^'(.+?)'//) {    ## single quote strings
        push @$tokens, [str => $1];
      }
      elsif ($value =~ s/^"(.+?)"//) {    ## double quote strings
        push @$tokens, [str => $1];
      }
      elsif ($value =~ s/^([-+]?\d+(\.\d+)?)//) {    ## numbers
        push @$tokens, [num => 0 + $1];
      }
      elsif ($value =~ s/^([-+]?\.\d+)//) {          ## numbers with just decimals
        push @$tokens, [num => 0 + $1];
      }
      elsif ($value =~ s/^([\w\.]+)//) {                 ## tokens/strings without white-space
        push @$tokens, [token => $1];
      }
      else {
        return { error => 'could not parse right_side', ctx => $value };
      }
      pop @stack;
      $atomic_expression_ends->();
      next;
    }

    die "State '$state' unhandled";
  }

  return { ok => 1, tree => \@tree };
}
