use Test::More;

BEGIN {
	package Local::Class;
	use Role::Commons -all;
	our $AUTHORITY = 'http://www.example.com/';
	our $VERSION   = '42.0';
	sub new  { bless [], shift };
	sub bumf { 123 };
}

my $obj = new_ok 'Local::Class';
can_ok $obj => $_ for qw( AUTHORITY tap object_id does );

done_testing();