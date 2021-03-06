#!/usr/bin/perl

=head1 NAME

marc2xml - convert a MARC file to XML

=head1 SYNOPSIS

    # convert a file
    % marc2xml marc.dat > marc.xml

    # or use in a pipeline
    % cat marc.dat | marc2xml > marc.xml

=head1 DESCRIPTION

marc2xml is a command line utility for converting MARC21 bibliographic
data to XML using the Library of Congress Slim Schema. Conversion is
handled using the MARC::Record and MARC::File::XML packages.

=cut

use strict;
use warnings;
use MARC::Record;
use MARC::Batch;
use MARC::File::XML;
use IO::File;
use utf8;

my $file = shift;
my $fh;

## read from a file?
if ( $file ) {
    fatal( "no such file: $file" ) if ! -r $file;
    $fh = IO::File->new( $file );
}

## or from STDIN?
else {
    $fh = \*STDIN;
}

## set up intput/output for utf8 encoding
binmode( STDOUT, ':utf8' );
binmode( $fh, ':bytes' );

my $found = 0;
my $batch = MARC::Batch->new( 'USMARC', $fh );

# be lenient, it's MARC afterall :)
$batch->warnings_off();
$batch->strict_off();

while ( my $record = $batch->next() ) {
    $record->encoding( 'UTF-8' );
    if ( ! $found ) {
        print MARC::File::XML::header();
        $found = 1;
    }
    print MARC::File::XML::record( $record );
}

print MARC::File::XML::footer() if $found;

sub fatal {
    print STDERR shift, "\n";
    exit( 1 );
}
