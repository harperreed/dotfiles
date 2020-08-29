 #!/usr/bin/perl

 # pipes standard in to an xmpp message, sent to the JIDs on the commandline
 #
 # usage: bash$ `echo "message body" | xmppipe garen@tychoish.com
 #
 # code shamelessly stolen from:
 # http://stackoverflow.com/questions/170503/commandline-jabber-client/170564#170564

 use strict;
 use warnings;

 use Net::Jabber qw(Client);

 my $server = "jabber.org";
 my $port = "5222";
 my $username = "nata2";
 my $password = "ninja";
 my $resource = "xmppipe";
 my @recipients = @ARGV;

 my $clnt = new Net::Jabber::Client;

 my $status = $clnt->Connect(hostname=>$server, port=>$port);

 if (!defined($status)) {
    die "Jabber connect error ($!)\n";
 }
 my @result = $clnt->AuthSend(username=>$username,
    password=>$password,
    resource=>$resource);

 if ($result[0] ne "ok") {
    die "Jabber auth error: @result\n";
 }

 my $body = '';
 while (<STDIN>) {
    $body .= $_;
 }
 chomp($body);

 foreach my $to (@recipients) {
     $clnt->MessageSend(to=>$to,
             subject=>"",
             body=>$body,
             type=>"chat",
             priority=>10);
 }

 $clnt->Disconnect();
