#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "../ppport.h"

#include <iconfig.h>


MODULE = Lib::Config		PACKAGE = Lib::Config		PREFIX = config_


void
config_change_file_name(rec, fname, create_mode)
	CONFIG_REC *	rec
	const char *	fname
	int	create_mode

void
config_close(rec)
	CONFIG_REC *	rec

int
config_get_bool(rec, arg1, key, def)
	CONFIG_REC *	rec
	const char * 	arg1
	const char *	key
	int	def

int
config_get_int(rec, arg1, key, def)
	CONFIG_REC *	rec
	const char *	arg1
	const char *	key
	int	def

char *
config_get_str(rec, arg1, key, def)
	CONFIG_REC *	rec
	const char *	arg1
	const char *	key
	const char *	def

void
config_nodes_remove_all(rec)
	CONFIG_REC *	rec

CONFIG_REC *
config_open(fname, create_mode)
	const char *	fname
	int	create_mode

int
config_parse(rec)
	CONFIG_REC *	rec

int
config_parse_data(rec, data, input_name)
	CONFIG_REC *	rec
	const char *	data
	const char *	input_name

int
config_set_bool(rec, arg1, key, value)
	CONFIG_REC *	rec
	const char *	arg1
	const char *	key
	int	value

int
config_set_int(rec, arg1, key, value)
	CONFIG_REC *	rec
	const char *	arg1
	const char *	key
	int	value

int
config_set_str(rec, arg1, key, value)
	CONFIG_REC *	rec
	const char *	arg1
	const char *	key
	const char *	value

int
config_write(rec, fname, create_mode)
	CONFIG_REC *	rec
	const char *	fname
	int	create_mode

  
MODULE = Lib::Config		PACKAGE = Lib::Config::Node		PREFIX = config_node_


void
config_node_add_list(rec, node, ...)
	CONFIG_REC *	rec
	CONFIG_NODE *	node
PREINIT:
	char ** list;
CODE:
	{
		int i;
		list = g_new0(char *, items > 2 ? items - 1 : 1);
		for (i = 0; i < items - 2; i++)
			list[i] = SvPV_nolen(ST(i + 2));
		config_node_add_list(rec, node, list);
		g_free(list);
	}

void
config_node_clear(rec, node)
	CONFIG_REC *	rec
	CONFIG_NODE *	node

CONFIG_NODE *
config_node_find(node, key)
	CONFIG_NODE *	node
	const char *	key

GSList *
config_node_first(list)
	GSList *	list

int
config_node_get_bool(parent, key, def)
	CONFIG_NODE *	parent
	const char *	key
	int	def

int
config_node_get_int(parent, key, def)
	CONFIG_NODE *	parent
	const char *	key
	int	def

void
config_node_get_list(node)
	CONFIG_NODE *	node
PPCODE:
	{
		char ** ret, ** tmp;
		ret = config_node_get_list(node);
		for (tmp = ret; tmp && *tmp; ++tmp) {
			mXPUSHs(newSVpv(*tmp, 0));
		}
		g_strfreev(ret);
	}

char *
config_node_get_str(parent, key, def)
	CONFIG_NODE *	parent
	const char *	key
	const char *	def

int
config_node_index(parent, key)
	CONFIG_NODE *	parent
	const char *	key

void
config_node_list_remove(rec, node, index)
	CONFIG_REC *	rec
	CONFIG_NODE *	node
	int	index

GSList *
config_node_next(list)
	GSList *	list

CONFIG_NODE *
config_node_nth(node, index)
	CONFIG_NODE *	node
	int	index

void
config_node_remove(rec, parent, node)
	CONFIG_REC *	rec
	CONFIG_NODE *	parent
	CONFIG_NODE *	node

CONFIG_NODE *
config_node_section(rec, parent, key, new_type)
	CONFIG_REC *	rec
	CONFIG_NODE *	parent
	const char *	key
	int	new_type

CONFIG_NODE *
config_node_section_index(rec, parent, key, index, new_type)
	CONFIG_REC *	rec
	CONFIG_NODE *	parent
	const char *	key
	int	index
	int	new_type

void
config_node_set_bool(rec, parent, key, value)
	CONFIG_REC *	rec
	CONFIG_NODE *	parent
	const char *	key
	int	value

void
config_node_set_int(rec, parent, key, value)
	CONFIG_REC *	rec
	CONFIG_NODE *	parent
	const char *	key
	int	value

void
config_node_set_str(rec, parent, key, value)
	CONFIG_REC *	rec
	CONFIG_NODE *	parent
	const char *	key
	const char *	value

CONFIG_NODE *
config_node_traverse(rec, arg1, create)
	CONFIG_REC *	rec
	const char *	arg1
	int	create

