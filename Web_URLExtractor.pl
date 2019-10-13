#!/usr/bin/perl
print "WebURLExtractor.pl - Starting\n";
# A shebang in case you wanna run this on linux etc
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +                      ## Web URL Extractor ##                             +
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +This utility will take a input file of any ASCII type and extract all of  +
# +web URL's from the file and write them out to another file for processing.+
# +                                                                          +
# +This is designed to be used with a LWP script that will then read each of +
# +the URL's from the file and then verify that the links are still valie    +
# +using the Perl LWP:Head function to check for a valid HTTP header it gets +
# +back from the web call. This will then write the URL out to another file  +
# +along with the result of the LWP:HEAD call. This is then used to manage   +
# +the original file that contains the URL's so that dead links can be       +
# +removed. Kinda-like FileFresh.pl for the intertubes.                      +
# +                                                                          +
# +Dear GITHUB foles as usual, this is specifically designed for me so if    +
# +you and is provided here as a simple example and if it blows shit up then +
# +more fool you. The following is an example of the URL format that we are  +
# +trying to extract from the file:                                          +
# + HREF="http://www.lonelyplanet.com/"                                      +
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 
##############
# TRASH HEAP OF STUFF
# To Be Done
# 1 - NOTE STUFF HERE ON THE TO-DO LIST
##############

# Version: 0.1
#
# Now lets be good and define some user variables
my $url_source_file;
my $url_output_file;
my $line_in;
my $line_out;
my $logfile;
my $rowcount;
my $fields;
my $delim;

# Initialise the variables
$rowcount = 0;
$delim = ",";

print "Enter path and name of the URL source/input File: ";
$wia_file = <STDIN>;
chomp($url_source_file);

print "Enter path and name of the URL output File: ";
$id51a_file = <STDIN>;
chomp($url_output_file);

if (-e $url_output_file)
	{
		print "** WARNING - OUTPUT FILE SPECIFIED EXISTS **\n";
		print "** Change name and retry -- EXITING **\n";
		exit;
	}

print "Now attempting to open the input and output files \n";

open (URL_SOURCE, $url_source_file) || die "**TROUSERS** - couldn't open the URL Source File";
open (URL_OUTPUT, ">$url_output_file") || die "**TROUSERS** - couldn't open the URL Output File";

# Now's We's Going To Get Krackin

while ($record = <URL_SOURCE>)
				{
					chomp($record);
					$rowcount++;
					print $rowcount, "\n";
					if ($rowcount > 1)
					{
                        @fields = (?<=HREF=":)(?=");
                        print $record, "\n";
                        print URL_OUTPUT @fields
					}		
				}
				close(URL_SOURCE);
				close(URL_OUTPUT);
#--ENDS--