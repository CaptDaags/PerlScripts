#server
#!/usr/bin/perl -w
# udpqotd - UDP message server
use strict;
use IO::Socket;
my $outfile;
my($sock, $newmsg, $hishost, $MAXLEN, $PORTNO);

$MAXLEN = 1024;
$PORTNO = 22335;




$sock = IO::Socket::INET->new(
           LocalPort => $PORTNO, 
       Proto => 'udp') or die "socket: $@";
       
print "Awaiting UDP messages on port $PORTNO\n";

while ($sock->recv($newmsg, $MAXLEN)) {
    my($port, $ipaddr) = sockaddr_in($sock->peername);
    #$hishost = gethostbyaddr($ipaddr, AF_INET);
    #print "Client $hishost said $newmsg\n";
	open(my $outfile,'>>','AVLData.log');
	print "$newmsg\n";
	print $outfile "$newmsg\n";
    #$sock->send("CONFIRMED: $newmsg ");
	close $outfile;
} 


die "recv: $!";
