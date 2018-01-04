#server
#!/usr/bin/perl -w
# udpqotd - UDP message server
use strict;
use IO::Socket;

my($sock, $newmsg, $hishost, $MAXLEN, $PORTNO);

$MAXLEN = 1024;
$PORTNO = 5151;

$sock = IO::Socket::INET->new(
           LocalPort => $PORTNO, 
       Proto => 'udp') or die "socket: $@";
       
print "Awaiting UDP messages on port $PORTNO\n";

while ($sock->recv($newmsg, $MAXLEN)) {
    my($port, $ipaddr) = sockaddr_in($sock->peername);
    #$hishost = gethostbyaddr($ipaddr, AF_INET);
    #print "Client $hishost said $newmsg\n";
	print "$newmsg\n";
    #$sock->send("CONFIRMED: $newmsg ");
} 
die "recv: $!";

# You can't use the telnet program to talk to this server. You 
# have to use a dedicated client. 



#client
#!/usr/bin/perl -w
# udpmsg - send a message to the udpquotd server

use IO::Socket;
use strict;

my($sock, $msg, $port, $ipaddr, $hishost, 
   $MAXLEN, $PORTNO, $TIMEOUT);

$MAXLEN  = 1024;
$PORTNO  = 5151;
$TIMEOUT = 5;

$sock = IO::Socket::INET->new(Proto     => 'udp',
                              PeerPort  => $PORTNO,
                              PeerAddr  => 'localhost')
    or die "Creating socket: $!\n";

$msg = 'testmessage'.time;

$sock->send($msg) or die "send: $!";

eval {
    local $SIG{ALRM} = sub { die "alarm time out" };
    alarm $TIMEOUT;
    $sock->recv($msg, $MAXLEN)      or die "recv: $!";
    alarm 0;
    1;  # return value from eval on normalcy
} or die "recv from localhost timed out after $TIMEOUT seconds.\n";

print "Server $hishost responded $msg\n";

# This time when we create the socket, we supply a peer host and 
# port at the start, allowing us to omit that information in the send.

# We've added an alarm timeout in case the server isn't responsive, 
# or maybe not even alive. Because recv is a blocking system call that
# may not return, we wrap it in the standard eval block construct 
# for timing out a blocking operation.
