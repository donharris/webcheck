#!/usr/bin/perl -w
#
# A script to check any webpage and report data back.
#

use LWP;
use HTTP::Response;
use Time::HiRes qw( clock gettimeofday );

chomp($FILENAME=`date +"%Y%m%d%H%M"`);
#$PATH="/home/YOUR_DIRECTORY_FOR_SCRIPT_OUTPUT";

$browser = LWP::UserAgent->new(); #Create virtual Browser
$browser->agent("Web_Check_Client"); #web check client browser
$browser->timeout(30); #Add 30 second timeout

my $url="http://www.google.com"; # REPLACE WITH URL YOU WANT TO CHECK

# Open file to write check data to:
        open (CHECK_DATA, "+>>$PATH/$FILENAME");

# Check URL
        $time_start = gettimeofday();
        $webdoc = $browser->get($url);

#       URL Success
	if ($webdoc->is_success) { 
		# Do Success
		#### What should we do?
       		$time_end = gettimeofday();
		$total_time = ($time_end - $time_start);
		print CHECK_DATA "=== Succes === \n\n in $total_time seconds\n\n";
		my $header=$webdoc->headers_as_string();
		print CHECK_DATA "=== HEADER IS=== \n\n $header\n\n";
		my $content=$webdoc->content();
		print CHECK_DATA "=== CONTENT IS === \n\n $content\n\n";
		close CHECK_DATA;
		$NEW_FILENAME=$FILENAME.".success";
		rename "$PATH/$FILENAME","$PATH/$NEW_FILENAME";
		exit;
        } else {  
		#FAILURE - exit
		# send email on failure
		#### SEND FAILURE
		print CHECK_DATA "+++ FAILURE +++ \n\n";
                my $header=$webdoc->headers_as_string();
                print CHECK_DATA "+++ HEADER IS +++ \n\n $header\n\n";
                my $content=$webdoc->content();
                print CHECK_DATA "+++ CONTENT IS +++\n\n $content\n\n";
		my $error_data=$webdoc->error_as_HTML();
		print CHECK_DATA "+++ ERROR DATA ++++ \n\n $error_data\n\n";
                close (CHECK_DATA);
                $NEW_FILENAME=$FILENAME.".FAILURE";
                rename "$PATH/$FILENAME","$PATH/$NEW_FILENAME";
                exit;
	}

print "=== something else happened ===";

