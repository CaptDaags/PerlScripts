#!/usr/bin/perl
# She-bang's she-bang's does she bang...in case yo are using Linux etc
# -----------------------------------------------------------
# Get the stuff that we need
# -----------------------------------------------------------
use Net::Ping;
use IO::Socket::INET;
use Socket;
# -----------------------------------------------------------
# Variable Declarations
# -----------------------------------------------------------
my $addrtype;
my $userfile;
my $outfile;
my $ping;
my $ipaddr;
my $host;
my $record;
my $isalive;
my $yacool;
my $closingmsg = "All done, hope it worked\n";
# -----------------------------------------------------------
# Now talk to the user monkey
# -----------------------------------------------------------
print "-----------------------------------------------------------\n";
print "CheckNodesByIPAndName.pl/Ver 0.99/20050627\n"; 
print "-----------------------------------------------------------\n";
print "Welcome to the dodgy node net query device \n";
print "This attempts to determin the DNS name by ip or vice versa \n";
print "Dont forget no-DNS-no-Work\n" ;
print "Input file format for each line must be:\n";
print "             For IP addresses: 172.17.17.17\n";
print "             For names: donkey or www.donkey.com\n";
print "Output file format for each line will be:\n";
print "             Ping y/n IPAddress nodename\n";
print "-----------------------------------------------------------\n";
# -----------------------------------------------------------
# Get the input file name and content details
# -----------------------------------------------------------
print "Enter Path Of Input File: ";
$userfile = <STDIN>;
chomp($userfile);
print "Does the file contain IP (i) or names (n): ";
$addrtype = <STDIN>;
chomp($addrtype);
print "Enter path and name of output file to log results to: ";
$outfile = <STDIN>;
chomp ($outfile);
if (-e $outfile)
	{
		print "** WARNING - OUTPUT FILE SPECIFIED EXISTS **\n";
		print "** Change name and retry -- EXITING **\n";
		exit;
	}
print "-----------------------------------------------------------\n";
if ($addrtype eq "i")
	{
		print "You are specifying that the file contains IP addresses \n";
	}
	elsif ($addrtype eq "n")
	{
		print "You are specifying that the file contains name addresses \n";
	}
	else
	{
		print "ERROR IN INPUT OF FILE TYPE \n";
		exit;
	}
print "So yo cool with all dat: y or n ";
$yacool = <STDIN>;
chomp($yacool);
if ($yacool ne "y")
	{
		print "OK your not cool!! ya must be a ", chr 219, " then he he - ok ok bailing!!";
		exit;
	}
print "-----------------------------------------------------------\n";
# -----------------------------------------------------------
# Get the file handlers up and dancing
# Logfile gets open for overwrite and not appending
# -----------------------------------------------------------
open (NodeList, $userfile) || die "**TROUSERS** - couldn't open the node file specified!";
open (Logfile, ">$outfile") || die "**TROUSERS** - couldn't open logfile";
# -----------------------------------------------------------
# Tell the monkeys we are starting
# -----------------------------------------------------------
print "And away we go.....\n";
# -----------------------------------------------------------
# Do this if the file is full of IP addresses. First we will
#  need to hoover the file for zero padded ipaddrs
# -----------------------------------------------------------
if ($addrtype eq "i")
			#put hoover stuff in here - this is to hoover the leading zeros
			# from the dot quad address
			{
			while ($record = <NodeList>)
				{
		    	$isalive = "Could Not Ping";
				$p = Net::Ping->new("icmp",2);
				$ipaddr = inet_aton($record);
				$host = gethostbyaddr($ipaddr,AF_INET);
					if ($p->ping($record))
						{
						$isalive = "Ping Returned";
						}
		    	print Logfile "Ping result= ". $isalive. " ". "Node ". $record. " ". "Resolves to: ". $host. "\n";
				}
				close(NodeList);
				close(Logfile);
				print "$closingmsg";
				}
# -----------------------------------------------------------
# Do this if the file is full of node names
# -----------------------------------------------------------
else		
			{
			while ($record = <NodeList>)
				{	
			chomp $record;
			print "step one ", $record;
				$resolvename = gethostbyname('$record') || die "Could not resolve address";
				print $resolvename;
				$y=inet_ntoa(($resolvename)[4]) || die "Trousers could not resolve name";
				print Logfile "Record ", $record, " resolves to ", $y, "\n";
				}
			close(NodeList);
			close(Logfile);
			print "$closingmsg";
			}