#!/usr/bin/perl

use LWP::Simple;                # From CPAN
use JSON qw( decode_json );     # From CPAN
use Data::Dumper;               # Perl core module
use strict;                     # Good practice
use warnings;                   # Good practice
use XML::Parser;
use Data::Dumper;
use XML::SimpleObject;

my $stopno = 1415; # exampleO Bahn 3127 O'Connell St


my $url = "http://data.sa.gov.au/storage/f/2013-05-09T03%3A38%3A59.921Z/acc-dog-registrations-2012.xml";

# open is for files.  unless you have a file called
# 'https://graph.facebook.com/?ids=http://www.filestube.com' in your
# local filesystem, this won't work.
#{
#  local $/; #enable slurp
#  open my $fh, "<", $trendsurl;
#  $json = <$fh>;
#}

# 'get' is exported by LWP::Simple; install LWP from CPAN unless you have it.
# You need it or something similar (HTTP::Tiny, maybe?) to get web pages.

my $xml_data = get( $url );

die "Could not get $url!" unless defined $xml_data;

my $parser= new XML::Parser( ErrorContext => 2, Style => 'Tree' );

my $tree = $parser->parse ( $xml_data);

my $xmlobj = new XML::SimpleObject ($parser->parse($xml_data));

my %namecount;

foreach my $child ($xmlobj->child("Report")->child("table1")->child("Detail_Collection")->children) {
    if (defined $child->attribute("AnimalName"))
      { 
        my $dog_name=$child->attribute("AnimalName"); 
        $namecount{uc($dog_name)} += 1; 
      }
  }
my @popular = sort { $namecount{$a} <=> $namecount{$b} || $a <=> $b } keys %namecount;

my $lastfreq=0;

foreach my $name (@popular)
  {
    if ($lastfreq ne $namecount{$name})
      { print "\n".$namecount{$name}; 
        $lastfreq=$namecount{$name};
        print " ".$name;
      }
    else
      { print ",".$name; }
}

die "woof";
