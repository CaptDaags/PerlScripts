#!/usr/bin/perl
print "DStar_FileConverter.pl ver 0.3 Initialising\n";
# A shebang in case you wanna run this on linux etc
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +                   ## DStar File Converter ##                             +
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +This takes the output of the WIA repeater listing for the Icom ID880 and  +
# +converts it into a file format that the Icom CS-51 app can read for the   +
# +ID-51A digital repeater listing. You can read the WIA file into the ALL   +
# +repeater listing section of the programming tool but not the specific     +
# +DStar repeater list.                                                      +
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 
##############
# TRASH HEAP OF STUFF
# Works
# DONE - 1 - Need to ignore first line and output own header.
# DONE - 2 - Need to prompt for Group No and Group Name.
# 3 - Need to ignore lines in input file that are not allocated by writing
#     valid empty entires up to row 99.
##############

# Version: 0.3
#
# Now lets be good and define some user variables
my $wia_file;
my $id51a_file;
my $line_in;
my $line_out;
my $logfile;
my $rowcount;
my $fields;
my $delim;
my $groupnum;
my $groupname;

# Initialise the variables
$rowcount = 0;
$delim = ",";

print "Enter path and name of WIA DStar Input File: ";
$wia_file = <STDIN>;
chomp($wia_file);

print "Enter path and name of ID-51a CSV output file: ";
$id51a_file = <STDIN>;
chomp($id51a_file);

if (-e $id51a_file)
	{
		print "** WARNING - OUTPUT FILE SPECIFIED EXISTS **\n";
		print "** Change name and retry -- EXITING **\n";
		exit;
	}

print "Enter the pre-defined Group Number to be assigned: ";
$groupnum = <STDIN>;
chomp($groupnum);

print "Enter the pre-defined Group Name to be assigned: ";
$groupname = <STDIN>;
chomp($groupname);

print "Now attempting to open the input and output files \n";

open (WIA, $wia_file) || die "**TROUSERS** - couldn't open the WIA file";
open (ID51A, ">$id51a_file") || die "**TROUSERS** - couldn't open ID51a file";

# Now seed the first line of the ID51A file outside of the file loop
print ID51A "group no",$delim,"group name",$delim,"name",$delim,"sub name",$delim,"repeater call sign",$delim,"gateway call sign",$delim,"frequency",$delim,"dup",$delim,"offset",$delim,"rpt1use",$delim,"position",$delim,"latitude",$delim,"longitude",$delim,"utc offset\n";

while ($record = <WIA>)
				{
					chomp($record);
					$rowcount++;
					print $rowcount, "\n";
					if ($rowcount > 1)
					{
                        @fields = split "," , $record;
                        print $record, "\n";
                        print ID51A $groupnum, $delim, $groupname,$delim,$delim,$fields[6],$delim,$fields[17],$delim,$fields[1],$delim,$fields[2],$delim,$fields[3],$delim,"YES",$delim,"None",$delim,"0",$delim,"0".$delim,"+11:00","\n";
					}		
				}
				close(WIA);
				close(ID51A);
#--ENDS--

