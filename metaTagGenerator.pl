#!/usr/bin/perl -w
#
#Plugin Name: MetaTagGenerator
#Plugin URI:  http://blogs.hiveworks.com/msa/content/binary/wordpress/mtg.tar.gz
#Description: A plugin that generates meta tags out of the nouns of the posts
#Author: Michalis Sarigiannidis
#Version: 1.0
#Author URI: http://blogs.hiveworks.com/msa/
#

use strict;
use Lingua::Wordnet;

my ($WORDS) = @ARGV;

# Remove any non-word character
$WORDS =~ s/\W/ /gi;

# Remove all words with 1 to 3 characters
# This doesn't catch them all, fix it
#$WORDS =~ s/(\W|^|\s)\w{1,3}(\W|$|\s)/ /gi; 

# Convert all characters to lower case
$WORDS =~ tr/[A-Z]/[a-z]/;

# Parse string  to array
my @parsedWords = map { s/\W|\d/ /gi; split; } $WORDS;

# Remove all duplicates
my %seen = ();
my @uniqueWords = sort grep { ! $seen{$_}++ } @parsedWords;

# Reject all words that are not nouns
my $wn = new Lingua::Wordnet;
my @nouns = grep { $wn->lookup_synset($_, "n")>0 && length($_) > 4} @uniqueWords;

# Create comma-separated string
my $nouns = join(", ", @nouns);

print "$nouns";
