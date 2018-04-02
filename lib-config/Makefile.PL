use 5.026001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Lib::Config',
    VERSION_FROM      => '../lib/Lib/Config.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    #ABSTRACT_FROM     => 'lib/Lib/Config.pm', # retrieve abstract from module
    AUTHOR            => 'Ailin Nemui <anei@cpan.org>',
    #LICENSE           => 'perl',
    #Value must be from legacy list of licenses here
    #http://search.cpan.org/perldoc?Module%3A%3ABuild%3A%3AAPI
    LIBS              => [qx{pkg-config --libs glib-2.0}], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I. '.qx{pkg-config --cflags glib-2.0}, # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    OBJECT            => '$(O_FILES)', # link all the C files too
#    C => [ <*.c>, <lib-config/*.c> ],
);
