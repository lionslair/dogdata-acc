#!/usr/bin/perl

use LWP::Simple;                # From CPAN
use JSON qw( decode_json );     # From CPAN
use Data::Dumper;               # Perl core module
use strict;                     # Good practice
use warnings;                   # Good practice
use XML::Parser;
use Data::Dumper;
use XML::SimpleObject;

sub do_year
{

my $this_year=$_[0];

my $url = $_[1];

my $xml_data = get( $url );

die "Could not get $url!" unless defined $xml_data;

my $parser= new XML::Parser( ErrorContext => 2, Style => 'Tree' );

my $tree = $parser->parse ( $xml_data);

my $xmlobj = new XML::SimpleObject ($parser->parse($xml_data));

foreach my $child ($xmlobj->child("Report")->child("table1")->child("Detail_Collection")->children) {
	my $breed=$child->attribute("Breed");
    my $suburb=$child->attribute("Suburb");
	$suburb =~ s/\s+$//; #remove trailing spaces
    my $status=$child->attribute("Status");
	my $gender=$child->attribute("Gender");
	my $dog_name="";
	if (defined $child->attribute("AnimalName"))
      { 
        $dog_name=$child->attribute("AnimalName"); 
      }
	if ($status eq "NORMAL" || $status eq "NORMAL MULTIPLE") { print $this_year.",\"".$dog_name."\",\"".$breed."\",\"".$gender."\",\"".$suburb."\"\n"; }
  }

}

print "Year,Dog_name,Breed,Gender,Suburb\n";

do_year(2008,"http://data.sa.gov.au/storage/f/2013-05-06T03%3A04%3A59.250Z/acc-dog-registrations-2008.xml");  
do_year(2009,"http://data.sa.gov.au/storage/f/2013-05-09T03%3A37%3A18.310Z/acc-dog-registrations-2009.xml");
do_year(2010,"http://data.sa.gov.au/storage/f/2013-05-09T03%3A37%3A57.744Z/acc-dog-registrations-2010.xml");
do_year(2011,"http://data.sa.gov.au/storage/f/2013-05-09T03%3A38%3A30.982Z/acc-dog-registrations-2011.xml");
do_year(2012,"http://data.sa.gov.au/storage/f/2013-05-09T03%3A38%3A59.921Z/acc-dog-registrations-2012.xml");

die "woof";
