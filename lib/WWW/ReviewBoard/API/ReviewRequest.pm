use strict;
use warnings;

use WWW::ReviewBoard::API::User;

package WWW::ReviewBoard::API::ReviewRequest;
use Moose;
extends 'WWW::ReviewBoard::API::Base';

sub raw_key { 'review_board' }

has summary => (
	is      => 'rw',
	lazy    => 1,
	default => sub { shift->raw->{summary} }
);

has submitter => (
	is      => 'rw',
	lazy    => 1,
	default => sub {
		my ($self) = @_;
		my %api;
		$api{api} = $self->api if $self->api;
		WWW::ReviewBoard::API::User->new({
				url => $self->raw->{links}->{submitter}->{href},
				%api
			})
	}
);

has target_people => (
	is      => 'rw',
	lazy    => 1,
	default => sub {
		my ($self) = @_;
		my %api;
		$api{api} = $self->api if $self->api;

		return [
			map {
				WWW::ReviewBoard::API::User->new({ url => $_->{href}, %api })
			} @{ $self->{raw}->{target_people} }
		];
	}
);

1
