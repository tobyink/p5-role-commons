package Role::Commons::Authority;

use strict;
use warnings;
use Moo::Role;
use Carp qw[croak];
use Scalar::Does qw[ does blessed CODE ARRAY HASH REGEXP STRING ];

BEGIN {
	$Role::Commons::Authority::AUTHORITY = 'cpan:TOBYINK';
	$Role::Commons::Authority::VERSION   = '0.001';
}

our %ENABLE_SHARED;
our %SHARED_AUTHORITIES;

our $setup_for_class = sub {
	my ($role, $package, %args) = @_;
	
	if ( exists $args{-authorities} )
	{
		$ENABLE_SHARED{ $package } = 1;
		
		does($args{-authorities}, ARRAY) and
			$SHARED_AUTHORITIES{ $package } = $args{-authorities};
	}
};

our $_smart_match;
$_smart_match = sub
{
	my ($A, $B) = @_;
	
	if (not defined $b)
		{ return not defined $a }
	
	if (does $b, CODE)
		{ return $b->($a) }
	
	if (does $b, ARRAY)
		{ return scalar grep { $_smart_match->($a, $_) } @$b }
	
	if (does $b, HASH)
		{ return defined $a && exists $b->{$a} }
	
	if (does $b, REGEXP)
		{ return $a =~ $b }
	
	if (does $b, STRING)
		{ return $a eq $b }
	
	return;
};

sub AUTHORITY
{
	my ($invocant, $test) = @_;
	$invocant = ref $invocant if blessed($invocant);
	
	my @authorities = do {
		no strict 'refs';
		my @a = ${"$invocant\::AUTHORITY"};
		if (exists $ENABLE_SHARED{ $invocant })
		{
			push @a, @{$SHARED_AUTHORITIES{$invocant} || []};
			push @a, @{"$invocant\::AUTHORITIES"};
		}
		@a;
	};
	
	if (scalar @_ > 1)
	{
		my $ok = undef;
		AUTH: for my $A (@authorities)
		{
			if ($_smart_match->($A, $test))
			{
				$ok = $A;
				last AUTH;
			}
		}
		return $ok if defined $ok;
		
		@authorities
			? croak("Invocant ($invocant) has authority '$authorities[0]'")
			: croak("Invocant ($invocant) has no authority defined");
	}
	
	wantarray ? @authorities : $authorities[0];
}

1;

