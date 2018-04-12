package Lib::Config;

use 5.026001;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
        NODE_TYPE_KEY
        NODE_TYPE_VALUE
        NODE_TYPE_BLOCK
        NODE_TYPE_LIST
	NODE_TYPE_COMMENT
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
);

BEGIN {
    our $VERSION = '0.01';

    require XSLoader;
    XSLoader::load('Lib::Config', $VERSION);
}

# Preloaded methods go here.

@Lib::Config::Block::ISA = __PACKAGE__;
@Lib::Config::List::ISA = __PACKAGE__;
@Lib::Config::Value::ISA = __PACKAGE__;
@Lib::Config::Comment::ISA = __PACKAGE__;

use overload
    '%{}' => 'MYHASH',
    '""' => 'MYVALUE',
    '@{}' => 'MYARRAY',
    # '${}' => 'MYSCALAR',
    ;

use Carp;

sub attach {
    my $class = shift;
    my ($config) = @_;
    $config->isa('Lib::Config::Rec::Ptr')
	or croak 'Lib::Config->attach: config is not of type Lib::Config::Rec::Ptr';
    my $self = bless \ {
	config => $config,
	root => 1,
    }, $class;
    $self->_bind_node($self->config->mainnode);
    $self
}

sub _bind_node {
    my $self = shift;
    my $v = shift;
    $$self->{type} = $v->get_type;
    $$self->{node} = $v;
    if ($v->is_node_list) {
	if ($$self->{type} == NODE_TYPE_BLOCK) {
	    my %hash;
	    tie %hash, $self, $self;
	    $$self->{hash} = \%hash;
	    bless $self, __PACKAGE__."::Block";
	}
	elsif ($$self->{type} == NODE_TYPE_LIST) {
	    my @array;
	    tie @array, $self, $self;
	    $$self->{list} = \@array;
	    bless $self, __PACKAGE__."::List";
	}
    }
    elsif ($$self->{type} == NODE_TYPE_COMMENT) {
	bless $self, __PACKAGE__."::Comment";
    }
    elsif ($v->has_node_value) {
	bless $self, __PACKAGE__."::Value";
	#return $v->get_value;
    }
}

sub _wrap_node_value {
    my $self = shift;
    my $v = shift;
    return unless $v;
    my $rv = bless \ {
	config => $self->config,
    }, ref $self;
    $rv->_bind_node($v);
    #$rv
}

sub config {
    ${+shift}->{config}
}

sub MYVALUE {
    my $self = shift;
    my $v = $$self->{node};
    return unless $v;
    if (!$v->is_node_list) {
	return $v->get_value;
    }
    else {
	$self
    }
}

sub MYHASH {
    my $self = shift;
    $$self->{hash}
}

sub MYARRAY {
    my $self = shift;
    $$self->{list}
}

sub TIEHASH {
    my ($class, $self) = @_;
    $self
}

sub FETCH {
    my ($self, $key) = @_;
    my $v;
    if ($$self->{type} == NODE_TYPE_BLOCK && !($key=~s/\A::(\d+)\#?\z/$1/)) {
	$v = Lib::Config::Node::Rec::find($$self->{node}, $key);
    }
    else {#elsif ($$self->{type} == NODE_TYPE_LIST) {
	my $i = 0;
	$v = $$self->{node}->get_value;
	while ($v && $i < $key) {
	    $v = $v->next;
	    $i++;
	}
	$v = $v->value if $v;
    }
    $self->_wrap_node_value($v)
}

sub STORE {
    my ($self, $key, $value) = @_;
    if ($$self->{type} == NODE_TYPE_BLOCK) {
    }
    elsif ($$self->{type} == NODE_TYPE_LIST) {
    }
}

sub DELETE {
    my ($self, $key) = @_;
    if ($$self->{type} == NODE_TYPE_BLOCK) {
    }
    elsif ($$self->{type} == NODE_TYPE_LIST) {
    }
}


sub CLEAR {
    my ($self) = @_;
    if ($$self->{type} == NODE_TYPE_BLOCK) {
    }
    elsif ($$self->{type} == NODE_TYPE_LIST) {
    }
}

sub EXISTS {
    my ($self, $key) = @_;
    if ($$self->{type} == NODE_TYPE_BLOCK) {
	!!Lib::Config::Node::Rec::find($$self->{node}, $key);
    }
    elsif ($$self->{type} == NODE_TYPE_LIST) {
	my $i = 0;
	my $v = $$self->{node}->get_value;
	while ($i < $key) {
	    $i++;
	    $v = $v->next;
	}
	!!$v
    }
}

sub FIRSTKEY {
    my ($self) = @_;
    $$self->{_key} = $$self->{node}->get_value;
    $$self->{_idx} = -1;
    return unless $$self->{_key};
    if (my $v = $$self->{_key}->value) {
	$$self->{_idx}++;
	$v->get_key // ("::$$self->{_idx}" . (defined $v->get_value ? "#" : ""));
    }
}

sub NEXTKEY {
    my ($self, $lastkey) = @_;
    return unless $$self->{_key};
    $$self->{_key} = $$self->{_key}->next;
    return unless $$self->{_key};
    if (my $v = $$self->{_key}->value) {
	$$self->{_idx}++;
	$v->get_key // ("::$$self->{_idx}" . (defined $v->get_value ? "#" : ""));
    }
}

sub SCALAR {
    my ($self) = @_;
}

sub DESTROY {
    my ($self) = @_;
    if ($$self->{type} == NODE_TYPE_BLOCK) {
    }
    elsif ($$self->{type} == NODE_TYPE_LIST) {
    }
}

sub UNTIE {
    my ($self) = @_
}


sub TIEARRAY {
    my ($class, $self) = @_;
    $self
}



sub FETCHSIZE {
    my $self = shift;
    my $i = 0;
    my $v = $$self->{node}->get_value;
    while ($v) {
	$i++;
	$v = $v->next;
    }
    $i
}

sub STORESIZE {
    my ($self, $count) = @_;
}

sub PUSH {
    my ($self, @list) = @_;
}

sub POP {
    my ($self) = @_;
}

sub SHIFT {
    my ($self) = @_;
}

sub UNSHIFT {
    my ($self, @list) = @_;
}

sub SPLICE {
    my ($self, $offset, $length, @list) = @_;
}

sub EXTEND {
    my ($self, $count) = @_;
}


use Tie::IxHash;

sub Dump {
    my $self = shift;
    if (ref $self && $self->isa(__PACKAGE__)) {
	my $dmp;
	if ($$self->{type} == NODE_TYPE_BLOCK) {
	    $dmp = {};
	    tie %$dmp, 'Tie::IxHash';
	    for my $key (keys %$self) {
		$dmp->{$key} = Dump($self->{$key});
	    }
	}
	elsif ($$self->{type} == NODE_TYPE_LIST) {
	    $dmp = [];
	    for my $el (@$self) {
		push @$dmp, Dump($el);
	    }
	}
	elsif ($$self->{type} == NODE_TYPE_COMMENT) {
	    my $var = $$self->{node}->get_value;
	    $dmp = $var
	}
	else {
	    $dmp = "$self";
	}
	$dmp
    }
    else {
	$self
    }
}

sub Lib::Config::Rec::Ptr::DESTROY {
    Lib::Config::Rec::close(+shift);
}
1;
__END__
