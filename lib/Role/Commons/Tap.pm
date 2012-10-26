package Role::Commons::Tap;

use strict;
use warnings;
use Moo::Role;
use Carp qw[croak];
use Scalar::Does qw[ does blessed CODE ARRAY HASH REGEXP STRING SCALAR ];

BEGIN {
	$Role::Commons::Tap::AUTHORITY = 'cpan:TOBYINK';
	$Role::Commons::Tap::VERSION   = '0.100';
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

__END__

=head1 NAME

Role::Commons::Tap - an object method which helps with chaining, inspired by Ruby

=head1 SYNOPSIS

@@TODO

=head1 DESCRIPTION

@@TODO

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Role-Commons>.

=head1 SEE ALSO

L<Role::Commons>,
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

