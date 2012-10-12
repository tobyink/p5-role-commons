package Role::Commons::Tap;

use strict;
use warnings;
use Moo::Role;
use Carp qw[croak];
use Scalar::Does qw[ does blessed CODE ARRAY HASH REGEXP STRING SCALAR ];

BEGIN {
	$Role::Commons::Tap::AUTHORITY = 'cpan:TOBYINK';
	$Role::Commons::Tap::VERSION   = '0.001';
}

our $setup_for_class = sub {
	my ($role, $package, %args) = @_;
	return 0;
};

sub tap
{
	my $self = shift;
	my %flags;
	
	PARAM: while (@_)
	{
		my $next = shift;
		
		if (does($next, CODE) or not ref $next)
		{
			my $args = does($_[0], 'ARRAY') ? shift : [];
			my $code = ref $next ? $next : sub { $self->$next(@_) };
			
			if ($flags{ EVAL })
			{
				local $_ = $self;
				eval { $code->(@$args) }
			}
			else
			{
				local $_ = $self;
				do { $code->(@$args) }
			}
			next PARAM;
		}
		
		if (does($next, SCALAR))
		{
			if ($$next =~ m{^(no_?)?(.+)$}i)
			{
				$flags{ uc $2 } = $1 ? 0 : 1;
				next PARAM;
			}
		}
		
		croak qq/Unsupported parameter to tap: $next/;
	}
	
	return $self;
}

1;