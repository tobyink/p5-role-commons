package authority::shared;

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

