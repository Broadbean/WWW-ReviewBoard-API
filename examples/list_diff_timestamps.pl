use strict;
use warnings;

use Getopt::Long;
use Term::Prompt;
use WWW::ReviewBoard::API;

GetOptions(
	'url=s'  => \(my $url),
	'user=s' => \(my $user),
	'pass=s' => \(my $pass),
);

if ($url !~ m{api/?$}) {
	$url .= '/api/';
}

if (!$pass) {
	$pass = prompt('x', 'Password?', '', '');
}

my $review_id = $ARGV[0];
if (!$review_id) {
	$review_id = prompt('x', 'Review Request ID?', '', '');
}

my $rb = WWW::ReviewBoard::API->new(
	url      => $url,
	username => $user,
	password => $pass,
);

my $rr = $rb->review_request($review_id);
foreach my $diff (@{ $rr->diffs }) {
	print $diff->revision . ': ' . $diff->timestamp . "\n";
}
