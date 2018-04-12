use strict;
use warnings;

use Test::More tests => 2;

use v5.16;

use Lib::Config ':all';

@Lib::Config::Node::List::Ptr::ISA = "Lib::Config::Node::List";
@Lib::Config::Rec::Ptr::ISA	   = "Lib::Config::Rec";
@Lib::Config::Node::Ptr::ISA	   = "Lib::Config::Node::Rec";


my $z = Lib::Config::Rec::open("default.theme", 0644);

is( $z->parse ,  0 , 'parsing succeeded' );


my $var = Lib::Config->attach($z);

use Scalar::Util 'blessed';
#say ">>" . blessed $var;
#say ">>" . blessed $var->{aliases};
#say ">>" . ref $var;
#say ">>" . ref $var->{aliases};
#say ">>" . ref $var->{aliases}{ATAG};
#say ">>" . $var->{aliases};
#say ">>" . $var->{aliases}{ATAG};




use Data::Dumper;
#$Data::Dumper::Sortkeys=1;
$Data::Dumper::Useqq=1;
print Dumper $var->Dump; 
