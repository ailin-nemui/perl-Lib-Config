#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "../ppport.h"

#include <iconfig.h>

typedef CONFIG_REC * Lib__Config__Rec__Ptr;
typedef CONFIG_NODE * Lib__Config__Node__Ptr;
typedef GSList * Lib__Config__Node__List__Ptr;


MODULE = Lib::Config		PACKAGE = Lib::Config::Rec	PREFIX = config_
PROTOTYPES: ENABLE


void
config_change_file_name(rec, fname, create_mode)
	Lib::Config::Rec::Ptr	rec
	const char *	fname
	int	create_mode

void
config_close(rec)
	Lib::Config::Rec::Ptr	rec
CODE:
	config_close(rec);
	sv_bless(ST(0),gv_stashpv("Lib::Config::Rec::Ptr::Dead",GV_ADD));

int
config_get_bool(rec, arg1, key, def)
	Lib::Config::Rec::Ptr	rec
	const char * 	arg1
	const char *	key
	int	def

int
config_get_int(rec, arg1, key, def)
	Lib::Config::Rec::Ptr	rec
	const char *	arg1
	const char *	key
	int	def

char *
config_get_str(rec, arg1, key, def)
	Lib::Config::Rec::Ptr	rec
	const char *	arg1
	const char *	key
	const char *	def

void
config_nodes_remove_all(rec)
	Lib::Config::Rec::Ptr	rec

Lib::Config::Rec::Ptr
config_open(fname, create_mode)
	const char *	fname
	int	create_mode

int
config_parse(rec)
	Lib::Config::Rec::Ptr	rec
POSTCALL:
      if (RETVAL != 0)
	      croak("%s", config_last_error(rec));

int
config_parse_data(rec, data, input_name)
	Lib::Config::Rec::Ptr	rec
	const char *	data
	const char *	input_name

int
config_set_bool(rec, arg1, key, value)
	Lib::Config::Rec::Ptr	rec
	const char *	arg1
	const char *	key
	int	value

int
config_set_int(rec, arg1, key, value)
	Lib::Config::Rec::Ptr	rec
	const char *	arg1
	const char *	key
	int	value

int
config_set_str(rec, arg1, key, value)
	Lib::Config::Rec::Ptr	rec
	const char *	arg1
	const char *	key
	const char *	value

int
config_write(rec, fname, create_mode)
	Lib::Config::Rec::Ptr	rec
	const char *	fname
	int	create_mode

char *
config_last_error(rec)
	Lib::Config::Rec::Ptr	rec
CODE:
	RETVAL = config_last_error(rec);
OUTPUT:
	RETVAL

Lib::Config::Node::Ptr
config_mainnode(rec)
	Lib::Config::Rec::Ptr	rec
CODE:
	RETVAL = (rec)->mainnode;
OUTPUT:
	RETVAL


MODULE = Lib::Config		PACKAGE = Lib::Config::Node::Rec	PREFIX = config_node_


void
config_node_add_list(rec, node, ...)
	Lib::Config::Rec::Ptr	rec
	Lib::Config::Node::Ptr	node
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
	Lib::Config::Rec::Ptr	rec
	Lib::Config::Node::Ptr	node

Lib::Config::Node::Ptr
config_node_find(node, key)
	Lib::Config::Node::Ptr	node
	const char *	key

int
config_node_get_bool(parent, key, def)
	Lib::Config::Node::Ptr	parent
	const char *	key
	int	def

int
config_node_get_int(parent, key, def)
	Lib::Config::Node::Ptr	parent
	const char *	key
	int	def

void
config_node_get_list(node)
	Lib::Config::Node::Ptr	node
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
	Lib::Config::Node::Ptr	parent
	const char *	key
	const char *	def

int
config_node_index(parent, key)
	Lib::Config::Node::Ptr	parent
	const char *	key

void
config_node_list_remove(rec, node, index)
	Lib::Config::Rec::Ptr	rec
	Lib::Config::Node::Ptr	node
	int	index


Lib::Config::Node::Ptr
config_node_nth(node, index)
	Lib::Config::Node::Ptr	node
	int	index

void
config_node_remove(rec, parent, node)
	Lib::Config::Rec::Ptr	rec
	Lib::Config::Node::Ptr	parent
	Lib::Config::Node::Ptr	node

Lib::Config::Node::Ptr
config_node_section(rec, parent, key, new_type)
	Lib::Config::Rec::Ptr	rec
	Lib::Config::Node::Ptr	parent
	const char *	key
	int	new_type

Lib::Config::Node::Ptr
config_node_section_index(rec, parent, key, index, new_type)
	Lib::Config::Rec::Ptr	rec
	Lib::Config::Node::Ptr	parent
	const char *	key
	int	index
	int	new_type

void
config_node_set_bool(rec, parent, key, value)
	Lib::Config::Rec::Ptr	rec
	Lib::Config::Node::Ptr	parent
	const char *	key
	int	value

void
config_node_set_int(rec, parent, key, value)
	Lib::Config::Rec::Ptr	rec
	Lib::Config::Node::Ptr	parent
	const char *	key
	int	value

void
config_node_set_str(rec, parent, key, value)
	Lib::Config::Rec::Ptr	rec
	Lib::Config::Node::Ptr	parent
	const char *	key
	const char *	value

Lib::Config::Node::Ptr
config_node_traverse(rec, arg1, create)
	Lib::Config::Rec::Ptr	rec
	const char *	arg1
	int	create

void
config_node_has_node_value(node)
	Lib::Config::Node::Ptr node
PPCODE:
	if (has_node_value(node)) {
		XSRETURN_YES;
	} else {
		XSRETURN_NO;
	}

void
config_node_is_node_list(node)
	Lib::Config::Node::Ptr node
PPCODE:
	if (is_node_list(node)) {
		XSRETURN_YES;
	} else {
		XSRETURN_NO;
	}

int
config_node_get_type(node)
	Lib::Config::Node::Ptr node
CODE:
	RETVAL = (node)->type;
OUTPUT:
	RETVAL

char *
config_node_get_key(node)
	Lib::Config::Node::Ptr node
CODE:
	RETVAL = (node)->key;
OUTPUT:
	RETVAL

void
config_node_get_value(node)
	Lib::Config::Node::Ptr node
PPCODE:
	{
		if (is_node_list(node)) {
#if 1
			SV * sv = sv_newmortal();
			sv_setref_pv(sv, "Lib::Config::Node::List::Ptr", (node)->value);
			XPUSHs(sv);
#else
			mXPUSHs(newSVpv("list",0));
#endif
		}
		else {
			mXPUSHs(newSVpv((node)->value,0));
		}
	}
			

MODULE = Lib::Config		PACKAGE = Lib::Config::Node::List	PREFIX = config_node_list_


Lib::Config::Node::List::Ptr
config_node_list_skip_comments(list)
	Lib::Config::Node::List::Ptr	list
CODE:
	RETVAL = config_node_first(list);
OUTPUT:
	RETVAL

Lib::Config::Node::List::Ptr
config_node_list_next(list)
	Lib::Config::Node::List::Ptr	list
CODE:
	RETVAL = (list)->next;
OUTPUT:
	RETVAL


Lib::Config::Node::Ptr
config_node_list_value(list)
	Lib::Config::Node::List::Ptr	list
CODE:
	RETVAL = (list)->data;
OUTPUT:
	RETVAL


MODULE = Lib::Config		PACKAGE = Lib::Config                           

int
NODE_TYPE_KEY()
CODE:
        RETVAL = NODE_TYPE_KEY;
OUTPUT:
	RETVAL

int
NODE_TYPE_VALUE()
CODE:
        RETVAL = NODE_TYPE_VALUE;
OUTPUT:
	RETVAL

int
NODE_TYPE_BLOCK()
CODE:
        RETVAL = NODE_TYPE_BLOCK;
OUTPUT:
	RETVAL

int
NODE_TYPE_LIST()
CODE:
        RETVAL = NODE_TYPE_LIST;
OUTPUT:
	RETVAL

int
NODE_TYPE_COMMENT()
CODE:
	RETVAL = NODE_TYPE_COMMENT;
OUTPUT:
	RETVAL
