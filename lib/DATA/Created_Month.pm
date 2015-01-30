package DATA::Created_Month;

use strict;
use warnings;

sub new {
    return bless {}, shift;
}

# gets all accounts
sub handle_accounts {
    my ( $self, $zmprov, $domain ) = @_;
    
    $self->{_zmprov} = $zmprov if defined $zmprov;
    $self->{_domain} = $domain if defined $domain;

    open my $ACCOUNTS, "$self->{_zmprov} -l gaa $self->{_domain} |" or die "Comando não encontrado\n";
    chomp (my @t_accounts = <$ACCOUNTS>);
    close $ACCOUNTS;

    my $all_accounts;
    $all_accounts = \@t_accounts;

    return $all_accounts;
}

# gets the date of creation of all accounts
sub account_created_date {
    my ( $self, $accounts, $zmprov ) = @_;

    $self->{_accounts} = $accounts if defined $accounts;
    $self->{_zmprov} = $zmprov if defined $zmprov;

    open my $dt, "$self->{_zmprov} -l ga $self->{_accounts} zimbraCreateTimestamp |" or die "Command not found\n";
    my @timestamp = <$dt>;
    close $dt;

    my $detalhes = {};

    for my $data ( @timestamp ) {
    
        if ( $data =~ m/name\s(.*@.*)/ ) {
            $self->{_email} = $1;
        }

        if ( $data =~ m/zimbraCreateTimestamp:\s(.*)/ ) {
            $self->{_CreateTimestamp} = $1;
        }

        $detalhes->{$self->{_email}}->{CreateTimestamp} = $self->{_CreateTimestamp};
  
    }

    return $detalhes;

}

# creates a file containing the accounts and the creation date within the data directory
sub creates_file {
    my ( $self, $email, $timestamp, $directory ) = @_;
    
    $self->{_email} = $email if defined $email;
    $self->{_CreateTimestamp} = $timestamp if defined $timestamp;
    $self->{_directory} = $directory if defined $directory;

    if ( -e "$self->{_directory}" ) {
        open CREATE, ">>", "$self->{_directory}/zimbra-created.txt" or die "Não foi possível criar o arquivo\n";
        print CREATE "$self->{_email}: $self->{_CreateTimestamp}\n";
        close CREATE;
    }
    else {
        mkdir "$self->{_directory}";
        open CREATE, ">>", "$self->{_directory}/zimbra-created.txt" or die "Não foi possível criar o arquivo\n";
        print CREATE "$self->{_email}: $self->{_CreateTimestamp}\n";
        close CREATE;
    }

}

1;
