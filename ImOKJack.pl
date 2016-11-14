#!/usr/bin/perl
#A shebang in case you wanna run this on linux etc
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +                            ## ImOKJack ##                              +
# +                ## Write to a log file on periodic basis ##             +
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +This will write to a user defined log at a user defined interval as     +
# +long as the process is running what use is that I hear you ask, well if +
# +a bit of hardware is dodgy like my random shutting down Dell laptop,    +
# +I can monitor exactly when it was up and when it died by checking the   +
# +time stamps in the log and then start the diagnosis process from there. +
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Now lets be good and define some user variables
$wanna_debug;
$append_to_filename;
$howmanyruns;
$complex_time;
$logfile;
my $ver_number = "20070110"; # < <  S E T  T H E  V E R S I O N   N U M B E R    H E R E

# Now lets define the modules we want to use
use Time::localtime;

# Does the peanut user want to send debug stuff to the console
print "Do you want to debug to the console as we go (y/n): ";
$wanna_debug = <STDIN>;
chomp($wanna_debug);
if (($wanna_debug eq "y") ||($wanna_debug eq "Y"))
	{
		$debug=1;
		print "OK were gunna debug to the console with a debug value of: ", $debug, "\n" ;
	}
	
# Does the user want to run continously - fair change with this one	
print "Run continuous (y/n): ";
$howmanyruns = <STDIN>;
chomp($howmanyruns);
if ($howmanyruns eq "y")
	{
		print "How many minutes between runs: ";
				$sleeptime= <STDIN>;
				$sleeptime = $sleeptime * 60;
		print 'The response to run continuous was: ', $howmanyruns, "\n";
		print 'Will run the process every: ', $sleeptime / 60, ' minutes', "\n";
	}	
	
# Get user to tell us where to log stuff to
print "Enter path and name of logfile file to log results to: ";
$logfile = <STDIN>;
chomp($logfile);	
trouser_time("Logfile name is:",$logfile);
	
trouser_time("++++++++++++ Starting ImOKJack: ", $ver_number, ctime());

# Now lets actually do some stuff

# Any looping will have to restart here
restart:

open (Logfile, '>>', $logfile) || die "***TROUSERS*** - couldn't open the log file specified!";
$complex_time = localtime->year() + 1900 . localtime->mon() . localtime->mday() . localtime->hour() . localtime->min() . localtime->sec();
trouser_time("$complex_time");
print Logfile "Im OK Jack on: ", ctime(), "\n";
trouser_time("Im OK Jack on: ", ctime());
close Logfile;

if ($howmanyruns eq 'y')				
			{
				trouser_time("Now just having a snooze before next run");
				#print $tag_scripttime , ' Now just having a snooze before next run', "\n";
				sleep($sleeptime);
				goto restart;
			}

sub trouser_time
	{
		if ($debug eq 1)
			{
				print "DEBUG- $_[0] $_[1] $_[2] $_[3]\n";
			}
	}
