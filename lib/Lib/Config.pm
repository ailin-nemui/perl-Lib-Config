package Lib::Config;

use 5.026001;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Lib::Config ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	config_change_file_name
	config_close
	config_get_bool
	config_get_int
	config_get_str
	config_node_add_list
	config_node_clear
	config_node_find
	config_node_first
	config_node_get_bool
	config_node_get_int
	config_node_get_list
	config_node_get_str
	config_node_index
	config_node_list_remove
	config_node_next
	config_node_nth
	config_node_remove
	config_node_section
	config_node_section_index
	config_node_set_bool
	config_node_set_int
	config_node_set_str
	config_node_traverse
	config_nodes_remove_all
	config_open
	config_parse
	config_parse_data
	config_set_bool
	config_set_int
	config_set_str
	config_write
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Lib::Config', $VERSION);

# Preloaded methods go here.

1;
__END__
