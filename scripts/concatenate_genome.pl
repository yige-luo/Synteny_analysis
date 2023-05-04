#!/usr/bin/perl

use strict;
use warnings;

my $input_file = shift(@ARGV) or die; # genome.fa file
my $output_file = shift(@ARGV) or die; # concatenated_genome.fa

open my $in_fh, "<", $input_file or die "Cannot open input file: $!";
open my $out_fh, ">", $output_file or die "Cannot open output file: $!";

my $header;
my $sequence;

while (my $line = <$in_fh>) {
    chomp $line;
    if ($line =~ /^>/) {
        # If the line starts with ">", it's a header line
        # Print the previous sequence (if it exists) to the output file
        print $out_fh "$header\n$sequence\n" if $header;
        # Save the new header and reset the sequence
        my @a = split(/\s/, $line);
        $header = $a[0];
        $sequence = "";
    } else {
        # Otherwise, it's a DNA sequence line
        # Remove any whitespace and add it to the sequence
        $line =~ s/\s+//g;
        $sequence .= $line;
    }
}

# Print the last sequence to the output file
print $out_fh "$header\n$sequence\n" if $header;

close $in_fh;
close $out_fh;
