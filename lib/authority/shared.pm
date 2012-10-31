package authority::shared;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.101';

use Role::Commons ();
use Role::Commons::Authority ();

sub import
{
	shift;
	Role::Commons::->import(
		-into      => scalar(caller),
		Authority  => { -authorities => \@_ },
	);
}

1;

