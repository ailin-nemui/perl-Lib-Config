use strict;
use warnings;

use Test::More tests => 2;

use v5.16;

use Lib::Config ':all';

@Lib::Config::Node::List::Ptr::ISA = "Lib::Config::Node::List";
@Lib::Config::Rec::Ptr::ISA	   = "Lib::Config::Rec";
@Lib::Config::Node::Ptr::ISA	   = "Lib::Config::Node::Rec";


my $z = Lib::Config::Rec::open("test2.conf", 0644);

is( $z->parse ,  0 , 'parsing succeeded' );

my $x = $z->mainnode;

say $z;
is ( ref $x, 'Lib::Config::Node::Ptr' , 'found config node' );

sub dump_node_rec {
    my ($node, $indent) = @_;
    $indent ||= 0;
    if ($indent > 20) {
	die "something went wrong";
    }
    print ' ' x $indent, '- ';
    if (defined $node->get_key) {
	print "[". $node->get_key . "] => ";
    }
    else {
	print "* ";
    }
    if ($node->is_node_list) {
	print " # " . $node->get_type . "\n";
	for (my $l = $node->get_value; $l; $l = $l->next) {
	    dump_node_rec($l->value, $indent + 2);
	}
    }
    elsif (defined $node->get_value) {
	print "\"" . $node->get_value . "\" # " . $node->get_type. "\n";
    }
    else {
	print "# " . $node->get_type."\n";
    }
}


dump_node_rec($x);

