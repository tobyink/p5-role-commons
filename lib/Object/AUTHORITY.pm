package Object::AUTHORITY;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.100';

use Role::Commons ();

sub import
{
	shift;
	my (undef, $opts) = Role::Commons::->parse_arguments(Authority => @_);
	my @packages = ref $opts->{package}
		? @{ $opts->{package} }
		: ($opts->{package}|| scalar caller);
	
	Role::Commons::->import('Authority', -into => $_) for @packages;
}

1;

