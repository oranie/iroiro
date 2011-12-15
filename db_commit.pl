#!/usr/bin/perl

use strict;
use warnings;
use HTTP::Date;
use IO::File;
use DBD::mysql;
use DBI;
use Config::Simple;

package DB_Commit;

use lib '/opt/SYSTEM/perl/log_analyze/lib';
require "output_log.pm";

my $d = "DBI:mysql:casual";
my $u = "root";
my $p = "yura0244";

my $sql ='INSERT INTO example_table (`1`,`2`,`3`) VALUE ("TEST","hoge","fuga");' ;

eval{
    Output_Log::error_log("DB execute start");
    query_commit_db($sql) ;
    Output_Log::error_log("DB execute end ");
};
if($@){
    print "$@ DB COMMIT ERROR";
}

sub query_commit_db{
    my $sql = $_[0] or die "No Query!!!";

    my $dbh = DBI->connect($d, $u, $p)
        or die "DB Connect error $!";
    my $sth;

    Output_Log::error_log("DB execute start $sql");
    for (my $i = 0;$i < 1000000 ;$i++) {
        $sth = $dbh->prepare($sql) or die "sql execute error $! \n $sql\n";
        $sth->execute  or die "sql execute error $! [$i]!! ";
        Output_Log::error_log("DB execute OK! $i");
    }
    $sth->finish  or die "DB Connection Close error $!" ;
    $dbh->disconnect;

    return 0;
}

