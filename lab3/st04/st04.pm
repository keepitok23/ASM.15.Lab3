#!/usr/bin/perl -w
package ST04;
use strict;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use DBI;
my $q;
my $global;
#############Global Variables#############
my $header="";
my $content="";
my $run=1;

my $currentkeys=["Name","Status","Address","EMail","Extra"];
my $filename="st04";
my $dsn = "DBI:mysql:database=lab3;host=localhost";
my $username = "root";
my $pass = "root";
my $attr= {'RaiseError' => 1, 'AutoCommit' => 1};
my $dbh = DBI->connect($dsn,$username,$pass, $attr);
#############Subroutines###############
#############
# init - check existence of lab3.st04 tables;
#############
sub init{
  my $initial="CREATE TABLE IF NOT EXISTS st04 (
		UID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
		Name varchar(255) NOT NULL,
		Status varchar(255) ,
		Address varchar(255) ,
		EMail varchar(255),
		Extra varchar(255)
		) Engine=InnoDB;";
  $dbh->do($initial);
}
#############
# import - import data from $filename to db
#############
sub Import{
  
  my %cash;
    dbmopen(%cash,"$filename",0);
    while( my ($key,$val)=each %cash){
      my $temp={split(":::",$val)};
      my $sql="INSERT INTO st04 (Name,Status,Address,EMail) values(?,?,?,?);";
      $dbh->do($sql,undef,$temp->{'Name'},$temp->{'Status'},$temp->{'Address'},$temp->{'E-Mail'});
    }
    dbmclose(%cash);
}
#############
# add - call menu for interactively add new item in the $cash
# INPUT: none
# OUTPUT: none
# return in st04
############
sub add{
    if ($q->param("Name")){
#       if ($q->param("Extra")){
      my $sql="insert into st04 (Name,Status,Address,EMail,Extra) values(?,?,?,?,?);";
      $dbh->do($sql,undef, $q->param('Name'),$q->param('Status'),$q->param('Address'),$q->param('EMail'),(defined $q->param('Extra'))? $q->param('Extra'):"");
#       }else{
#       my $sql="insert into st04 (Name,Status,Address,EMail) values(?,?,?,?);".
# 	      $q->param('Name').",".
# 	      $q->param('Status').",".
# 	      $q->param('Address').",".
# 	      $q->param('EMail').",'');";
#       $dbh->do($sql);
#       }
    }
}

#############
# correct -  correct existed item in the $cash
# INPUT: none
# OUTPUT: none
# return in st04
############
sub correct{
    my $UID=$q->param("UID");
    my $sth = $dbh->prepare("select * from st04 where uid=$UID;");
    $sth->execute();
    my $ref = $sth->fetchrow_hashref();
    if ($ref->{"Name"}) {
      my $request="UPDATE st04 SET Name=?, Status=?, Address=?, EMail=?, Extra=? where UID=?;";
    $dbh->do($request,undef,$q->param('Name'),$q->param('Status'),$q->param('Address'),$q->param('EMail'),(defined $q->param('Extra'))? $q->param('Extra'):"",$UID);
    }
    $sth->finish();
}

#############
# delete - call menu for interactively delete existed item in the $cash
# INPUT: none
# OUTPUT: none
# return in st04
############
sub Delete{
    my $UID=$q->param("UID");
    my $sth = $dbh->prepare("select * from st04 where uid=?;");
    $sth->execute($UID);
    my $ref = $sth->fetchrow_hashref();
    if ($ref->{"Name"}) {
      $dbh->do("delete from st04 where uid=?",undef,$UID);
    }
    $sth->finish();
}

#############
# show - call menu for interactively show items in the $cash
# INPUT: none
# OUTPUT: none
 # return in st04
############

sub show{ 
    $content.= $q->start_table({ -border => 1,
				     -width  => "100%" });
    $content.= "\t".$q->th(["",@$currentkeys]);
    my $sth = $dbh->prepare("select * from st04;");
    $sth->execute();
    while(my $temp = $sth->fetchrow_hashref()){
	$content.="\t\t".$q->start_form."\n\t\t<tr>\n\t\t\t".$q->td(
				["\n\t\t\t".$q->hidden("student",$global->{student})."\n\t\t\t"."<input type=\"hidden\" name=\"UID\" value=\"$temp->{'UID'}\">"."\n\t\t\t".$q->submit("action","Delete")."\n\t\t\t".$q->submit('action',"Correct"),
				$q->textfield(-name=>"Name",
						  -override=>1,
						  -size=>20,
						  -maxlength=>30,
						  -value=>$temp->{"Name"}),
				$q->textfield(-name=>"Status",
						  -override=>1,
						  -size=>20,
						  -maxlength=>30,
						  -value=>$temp->{"Status"}),
				$q->textfield(-name=>"Address",
						  -override=>1,
						  -size=>20,
						  -maxlength=>30,
						  -value=>$temp->{"Address"}),
				$q->textfield(-name=>"EMail",
						  -override=>1,
						  -size=>20,
						  -maxlength=>30,
						  -value=>$temp->{"EMail"}),]
				);
	if ($temp->{'Extra'}){
	  $content.="\t\t\t<td>\n\t\t\t\t".$q->textfield(-name=>"Extra",
						  -override=>1,
						  -size=>20,
						  -maxlength=>30,
						  -value=>$temp->{"Extra"})."\n\t\t\t</td>";
	}else
	{
	  $content.="\t\t\t<td></td>\n";
	}
	$content.="\t\t</tr>\n\t\t\t".$q->end_form."\n";
    }
    $content.="\n".$q->start_form."\n\t<tr>\n\t\t<td>\n\t\t\t".$q->hidden("student",$global->{student})."\n\t\t\t".$q->submit('action',"Add")."\n\t\t</td>\n";
    $content.="\n\t\t<td>\n".(join("\n\t\t</td>\n\t\t<td>\n",map{"\t\t\t".$q->textfield(-name=>"$_",
							      -override=>1,
							      -size=>20,
							      -maxlength=>30)} @$currentkeys))."\n\t\t</td>\n";
    $content.="\t</tr>\n".$q->end_form;
    $content.=$q->end_table;
    $sth->finish();
}

#############
# quit - exit point from st04
# INPUT: none
# OUTPUT: none
# return in st04
############
sub quit{
    print $q->redirect($global->{selfurl});
}
sub clear{
    $dbh->do("TRUNCATE TABLE st04;");
}

sub Menu{
    
    $content.= "<H1>Lab3 by Borisenko</H1>\n";
    $content.= $q->start_form."\n";
    $content.="\t".$q->hidden("student",$global->{student})."\n";
    $content.="\t".$q->submit('action','Clear table')."\n";
    $content.="\t".$q->submit('action','Quit')."\n";
    $content.="\t".$q->submit('action','Import')."\n";
    $content.=$q->end_form."\n";
    show();
}
my $menuEntry={
    'Add'=>\&add,
    'Correct'=>\&correct,
    'Delete'=>\&Delete,
    'Quit'=>\&quit,
    'Menu'=>\&Menu,
    'Import'=>\&Import,
    'Clear table'=>\&clear
};

sub st04{
  ($q, $global) = @_;
  $content.= $q->start_html("Lab2 by Borisenko");
  init();
  
  if( my $act=$q->param('action')){
    $menuEntry->{$act}();
  }
  Menu();

  $content.= $q->end_html;
  $header.= $q->header(-type=>"text/html",
			  -charset=>"windows-1251");
  print $header;
  print $content;
  $dbh->disconnect();
}
1;
