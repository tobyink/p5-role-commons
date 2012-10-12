package Role::Commons::ObjectID;

use strict;
use warnings;
use Moo::Role;
use Object::ID qw( object_id );

BEGIN {
	$Role::Commons::ObjectID::AUTHORITY = 'cpan:TOBYINK';
	$Role::Commons::ObjectID::VERSION   = '0.001';
}

our $setup_for_class = sub {
	my ($role, $package, %args) = @_;
};

1;

