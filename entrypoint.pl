#!/usr/bin/perl
#
# Usage: <docker run> <cmd>
#
# This image allows you to use the MkDocs wiki system.
#
# It provides both a live development server and a complete build system to
# generate the static version of the site.
#
# To run the image use:
#
#    docker run -i --rm melopt/mkdocs
#
# Without any commands it will display this message. You can also display this
# message with the commands `help` or `usage`.
#
# > tip: to avoid writting this docker run command every single time, create an
# >      alias:
# >
# >   alias mkdocs='docker run -i --rm melopt/mkdocs' 
# >
# > To make the explanation less verbose, all examples will make use of the
# > `mkdocs` alias.
#
# If you want to explore 
#
use strict;
use warnings;

my ($cmd) = @ARGV;

usage() if !$cmd or $cmd eq 'help' or $cmd eq 'usage';
exec('/bin/sh') if $cmd eq 'sh' or $cmd eq 'shell';

die "FATAL: command '$cmd' not recognized\n";


sub usage {
  seek(*DATA, 0, 0);
  while (<DATA>) {
    next if m/^#!/;
    last unless my ($l) = m{^#\s?(.*)};
    
    print "$l\n";
  }
  
  exit(1);
}


## next line is required to make the DATA filehandle available
__DATA__