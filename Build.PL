
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Display run time and dependencies after running code",
  "dist_author" => [
    "Steven Haryanto <stevenharyanto\@gmail.com>"
  ],
  "dist_name" => "Devel-EndStats",
  "dist_version" => "0.12",
  "license" => "perl",
  "module_name" => "Devel::EndStats",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "perl" => "5.007003"
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
