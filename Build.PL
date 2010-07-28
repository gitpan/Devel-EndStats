
use strict;
use warnings;

use Module::Build 0.3601;

my %module_build_args = (
                       'dist_abstract' => 'Show various statistics at the end of program run',
                       'script_files' => [],
                       'license' => 'perl',
                       'build_requires' => {
                                             'Module::Build' => '0.3601'
                                           },
                       'dist_name' => 'Devel-EndStats',
                       'dist_author' => [
                                          'Steven Haryanto <stevenharyanto@gmail.com>'
                                        ],
                       'module_name' => 'Devel::EndStats',
                       'requires' => {
                                       'perl' => '5.010000'
                                     },
                       'recommends' => {},
                       'configure_requires' => {
                                                 'Module::Build' => '0.3601'
                                               },
                       'dist_version' => '0.02'
                     );


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
