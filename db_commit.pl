#!/usr/bin/perl

use strict;
use warnings;
use DBD::mysql;
use DBI;

my $d = "DBI:mysql:casual";
my $u = "root";
my $p = "";

my $sql ='INSERT INTO insert_table (`1`,`2`,`3`) VALUE ("TEST","hoge","fuga");' ;

eval{
    print "DB execute start\n";
    query_commit_db($sql) ;
    print "DB execute end\n";
};
if($@){
    print "$@ DB COMMIT ERROR";
}

sub query_commit_db{
    my $sql = $_[0] or die "No Query!!!";

    my $dbh = DBI->connect($d, $u, $p)
        or die "DB Connect error $!";
    my $sth;

    for (my $i = 0;$i < 1000000 ;$i++) {
        $sth = $dbh->prepare($sql) ;
        $sth->execute or die "sql execute error $! [$i]!! $sql";
        print "DB execute OK! $i\n";
    }
    $sth->finish  or die "DB Connection Close ERROR $!" ;
    $dbh->disconnect;

    return 0;
}

