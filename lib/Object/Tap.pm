package Object::Tap;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.100';

use Role::Commons ();
use Role::Commons::Tap ();

sub import
{
	shift;
	my ($r, $opts) = Role::Commons::->parse_arguments(DummyArgument => @_);
	my @packages = ref $opts->{package}
		? @{ $opts->{package} }
		: ($opts->{package}|| scalar caller);
	
	delete $r->{DummyArgument};
	$r = { tap => undef } unless keys %$r;
	
	for my $pkg (@packages)
	{
		for my $meth (keys %$r)
		{
			if ($meth eq 'tap')
			{
				Role::Commons::->import('Tap', -into => $pkg);
			}
			else
			{
				no strict 'refs';
				*{"$pkg\::$meth"} = \&Role::Commons::Tap::tap;
			}
		}
	}
}

1;

