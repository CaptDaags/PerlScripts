#!/usr/bin/perl
#A shebang in case you wanna run this on linux etc
# "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
# "+                             ## FileSpy ##                                +\n"
# "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
# "+This deviche will take a filepath and/or name and then poll it at regular +\n"
# "intervals and alert if the file modification date changes.                 +\n"
# "+Poll rate and file name are user defined.                                 +\n"
# "+This is handy in determining if a file is being used before move/delete.  +\n"
# "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"

# Tell the world we are initialising
print '************************ FileSpy Is Starting ************************', "\n";

# Now lets be good and define some user variables
my $filename;
my $sb;
my $filepathname;
my $running;
my $lastmodtime;
my $sleeptime;

# Get the user to tell us what file to monitor
print "Enter path and/or name of file to monitor: ";
$filepathname = <STDIN>;
chomp($filepathname);
if (-e $filepathname)
	{
		print "File exists OK - starting\n";
	}
	else
	{
		print "Trousers - Cannot find file - bailing";
		exit;
	}

# Get the user to tell us how many minutes between polls of the file
print "How many minutes between polls of the file: ";
				$sleeptime= <STDIN>;
				chomp($sleeptime);
				$sleeptime = $sleeptime * 60;
		print 'Will poll the file every: ', $sleeptime / 60,' minutes', "\n";

# Now lets define the modules we want to use
use File::stat;

# Lets initialise some variables before the big kick off
$running = 'y';
my $filename = $filepathname;
$sb = stat($filename);
$lastmodtime = $sb->mtime;

# Lets get down to business and kick off the first examination of the file

print 'Starting the monitor process with the values: ', $filename, ' last modified ', scalar localtime $lastmodtime, "\n";
print 'raw mtime=', $sb->mtime, "\n";

# OK now lets monitor the puppy
while ($running = 'y')
	{
		$sb = stat($filename);
		if ($lastmodtime != $sb->mtime)
			{
				print 'Warning - File ',$filename, ' has been modified on ',scalar localtime $sb->mtime, "\n";
			} 
		$lastmodtime = $sb->mtime;
		sleep($sleeptime);
	}




