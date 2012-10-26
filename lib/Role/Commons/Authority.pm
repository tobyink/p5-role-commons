package Role::Commons::Authority;

use strict;
use warnings;
use Moo::Role;
use Carp qw[croak];
use Scalar::Does qw[ does blessed CODE ARRAY HASH REGEXP STRING ];

BEGIN {
	$Role::Commons::Authority::AUTHORITY = 'cpan:TOBYINK';
	$Role::Commons::Authority::VERSION   = '0.100';
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
	
	if (not defined $B)
		{ return not defined $A }
	
	if (does $B, CODE)
		{ return $B->($A) }
	
	if (does $B, ARRAY)
		{ return scalar grep { $_smart_match->($A, $_) } @$B }
	
	if (does $B, HASH)
		{ return defined $A && exists $B->{$A} }
	
	if (does $B, REGEXP)
		{ return $A =~ $B }
	
	if (does $B, STRING)
		{ return $A eq $B }
	
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

__END__

=head1 NAME

Role::Commons::Authority - a class method indicating who published the package

=head1 SYNOPSIS

@@TODO

=head1 DESCRIPTION

@@TODO

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Role-Commons>.

=head1 SEE ALSO

L<Role::Commons>,
L<authority>,
@@TODO

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2012 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

