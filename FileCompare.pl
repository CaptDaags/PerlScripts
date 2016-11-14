#!/usr/bin/perl
#A shebang in case you wanna run this on linux etc
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +                          ## FIleCompare ##                             +
# +          ## Compare two files are report the differences ##            +
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +This script takes two files and compares the contents and reports the   +
# +differences out to another file. This is primarily written to compare   +
# +a list of Windows 2003 servers from AD with that of servers from HP     +
# +service desk database for Dickie.                                       +
# +This script relies on the serverlist script and the adcompare script    +
# +for the generation of the source files for this script to process. We   +
# +may combine the whole shooting match one day but its currently handy to +
# +have them seperated at this stage of the game.                          +
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Now lets be good and define some user variables
my $input_file_one;
my $file_one_array;
my $file_one_record;
my $input_file_two;
my $file_two_array;
my $file_two_record;
my $delta_file;
my $wanna_debug;
my $debug = 0;
my $howmanyruns;
my $sleeptime;
my $tag_scripttime;
my $compare_option;
my $list_compare_handle;
my $list_compare_item;
my $ver_number = "20060817"; # < <  S E T  T H E  V E R S I O N   N U M B E R    H E R E

print "++++++++++++ Starting FileCompare: ", $ver_number, "\n";

# Now lets define the modules we want to use
use List::Compare;
use Time::localtime;

# Get user to tell us where the first file to read is
print "Enter path and name of first file to read: ";
$input_file_one = <STDIN>;
chomp($input_file_one);

# Get user to tell us where the second file to read is
print "Enter path and name of second file to read: ";
$input_file_two = <STDIN>;
chomp($input_file_two);

# Get user to tell us where to put the results file to read is
print "Enter path and name of the results file to output to: ";
$delta_file = <STDIN>;
chomp($delta_file);

# Do we want to run this continuously
print "Run continuous (y/n): ";
$howmanyruns = <STDIN>;
chomp($howmanyruns);
if ($howmanyruns eq "y")
	{
		print "How many minutes between runs: ";
				$sleeptime= <STDIN>;
				$sleeptime = $sleeptime * 60;
		print "The response to run continuous was: ", $howmanyruns, "\n";
		print "Will run the process every: ", $sleeptime / 60, " minutes\n";
	}

# Does the peanut user want to send debug stuff to the console
print "Do you want to debug to the console as we go (y/n): ";
$wanna_debug = <STDIN>;
chomp($wanna_debug);
if (($wanna_debug eq "y") ||($wanna_debug eq "Y"))
	{
		$debug=1;
		print "OK were gunna debug to the console with a debug value of: ", $debug, "\n" ;
	}
	
print "++++++++++++ Starting FileCompare: ", $ver_number, "\n";

# Firstly we need to decide which way to compare the files 1st to 2nd or 2nd to 1st or deltas in both
# We will then test the user input to make sure a valid option is selected
retry_option:
print "Please indicate which way you would like to compare the nominated files\n";
print "Option 1 - Get those items which appear (at least once) only in the first list - enter 1\n";
print "Option 2 - Get those items which appear (at least once) only in the second list - enter 2\n";
print "Option 3 - Get those items which appear at least once in either the first or the second list, but not both - enter 3\n";
$compare_option = <STDIN>;
chomp($compare_option);

# This is were the constant run restart loop re-kicks off from
restart:

$tag_scripttime = ctime(); #Gotta be under the restart so that it updates on each run through

trouser_time("Opening input and result and log files for over write");

open (InFileOne, '<', $input_file_one) || die "***TROUSERS*** - couldn't open the first input file specified!";		
open (InFileTwo, '<', $input_file_two) || die "***TROUSERS*** - couldn't open the second input file specified!";
open (ResultFile, '>', $delta_file) || die "***TROUSERS*** - couldn't open the result output file specified!";

trouser_time("Files should now be open for over write");
trouser_time("The value entered was", $compare_option);

if (($compare_option ne "1" ) && ($compare_option ne "2") && ($compare_option ne "3"))
	{
		trouser_time("You have entered and invalid option for file processing it must be 1 or 2 or 3");
		goto retry_option;
	}
	
trouser_time("User option request passed validation and proceeding");

# Now read the contents of each file into an array

while ($file_one_record = <InFileOne>)
	{
		@file_one_array = (@file_one_array, $file_one_record);
	}
	
while ($file_two_record = <InFileTwo>)
	{
		@file_two_array = (@file_two_array, $file_two_record);	
	}

trouser_time("Arrays should now be populated from the user defined input files");

chomp($compare_option);
if ($compare_option eq 1)
	{
		trouser_time("Evaluating option 1");
		$list_compare_handle = List::Compare->new(\@file_one_array, \@file_two_array);
		@list_compare_array = $list_compare_handle->get_complement;
		@list_compare_array = $list_compare_handle->get_Lonly;
		foreach $list_compare_item (@list_compare_array)
			{
				trouser_time("Records only in the first file are: ", $list_compare_item);
				print ResultFile "Records only in the ", $input_file_one, " file are: ", $list_compare_item, "\n";
			}		
	}
elsif ($compare_option eq 2)
	{
		trouser_time("Evaluating option 2");
		$list_compare_handle = List::Compare->new(\@file_one_array, \@file_two_array);
		@list_compare_array = $list_compare_handle->get_complement;
		@list_compare_array = $list_compare_handle->get_Ronly;
		foreach $list_compare_item (@list_compare_array)
			{
				trouser_time("Records only in the second file are: ", $list_compare_item);
				print ResultFile "Records only in the ", $input_file_two, " file are: ", $list_compare_item, "\n";
			}			
	}
elsif ($compare_option eq 3)
	{
		trouser_time("Evaluating option 3");
		$list_compare_handle = List::Compare->new(\@file_one_array, \@file_two_array);
		@list_compare_array = $list_compare_handle->get_symmetric_difference;
		@list_compare_array = $list_compare_handle->get_symdiff;
		@list_compare_array = $list_compare_handle->get_LorRonly;
		foreach $list_compare_item (@list_compare_array)
			{
				trouser_time("Records that only appear in one but not the other file are: ", $list_compare_item);
				print ResultFile "Records that only appear in one but not the other file are: ", $list_compare_item, "\n";
			}			
	}
else
	{
		trouser_time("No valid file processing option selected - bailing out");
		print "Peanut - You didnt enter a valid file processing option should be 1 2 or 3 - bailing out";
	}

trouser_time("Finished processing the files");

# Now close the logfile that contains the retrieved AD record
trouser_time("Closing the logfile now");

close ResultFile;

		if ($howmanyruns eq 'y')				
			{
				trouser_time($tag_scripttime , " Now just having a snooze before next run");
				sleep($sleeptime);
				trouser_time("Off to restart we go...weeeeeee");
				goto restart;
			}
trouser_time("Bye Bye");
			
sub trouser_time
	{
		if ($debug eq 1)
			{
				print "DEBUG- $_[0] $_[1] $_[2] $_[3]\n";
			}
	}
	
	
##################################################################
# TRASH HEAP FOR STUFF
##################################################################
# BUG LIST
##################################################################
# Compare CPAN reference:
# http://search.cpan.org/dist/List-Compare/lib/List/Compare.pm
##################################################################


	
	