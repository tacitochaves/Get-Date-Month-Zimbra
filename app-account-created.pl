#!/bin/env perl
#
# app-account-created.pl 
#
# Este programa tem por objetivo pegar a data de criação de todas as contas e montar no arquivo apenas as
# contas com a data solicitada pelo usuário, criando-se no seguinte modelo: account@exemple.com: 20150129202320
#
# Author: Tácito Chaves - 2015-01-29
# e-mail: tacitochaves@gmail.com
# skype: tacito.chaves

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use DATA::Created_Month;

my $self = DATA::Created_Month->new;

my $binary   = "/opt/zimbra/bin/zmprov";
my $dst_file = "/usr/local/bin/get-date-month/data";

my $all_accounts = $self->handle_accounts( "$binary", "acai.com.br" );

my $data = [];
map { push @{ $data }, $self->account_created_date( $_, "$binary") } @{$all_accounts}; 

for my $Timestamp ( @{$data} ) {

    for my $emails ( keys %{ $Timestamp } ) {

#        print "$emails -> $Timestamp->{$emails}->{CreateTimestamp}\n";
        $self->creates_file( "$emails", "$Timestamp->{$emails}->{CreateTimestamp}", "$dst_file" ) if ( $Timestamp->{$emails}->{CreateTimestamp} =~ m/^201501/gi );

    }

}
