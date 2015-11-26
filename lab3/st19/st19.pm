#!C:/perl/bin/perl
use strict;
use CGI::Carp qw (fatalsToBrowser);
use CGI qw(param);
use DBI qw(:sql_types);
use DBI; 
sub st24
{

my @list=();
my $persnumber=0;


my ($q, $global) = @_;

my %buffer;
my $filename = "file_const";
my $dbname = "st24";
my $table = "lab3";
my $dbh = DBI->connect( "DBI:mysql:database=$dbname;host=localhost","root", "root", {'RaiseError' => 1, 'AutoCommit' => 1});
    $dbh->do("SET NAMES cp1251");
    

my @funcs= (
  \&add,         
  \&edit,
  \&deleteelem,
  \&showbox,    
  \&actionform,
  \&sub_download);
  $funcs[4]->();
  $funcs[3]->();
  $dbh->disconnect();

  sub sub_download{
    
         my %buf;
         dbmopen(%buf, $filename, 0777);
         @list = ();
            while ( (my $key, my $value) = each %buf )
           {
             my ($surname, $numingroup, $married) = split(/--/, $value);
             
             my $sth = $dbh->prepare("insert into $table (surname,numingroup,married) values (?,?,?) ");
            $sth->execute($surname,$numingroup,$married); 
            $sth->finish();
           }
         dbmclose(%buf);
     
  }
sub add{
       
        my $surname =$_[1];
        my $numingroup = $_[2];
        my $married = $_[3];
        if($married eq ""){
          $married=" ";
        }
        my $sth = $dbh->prepare("insert into $table (surname,numingroup,married) values (?,?,?) ");
        $sth->execute($surname,$numingroup,$married); 
        $sth->finish();
  } 
sub edit{
 
        my $editid =  $_[0];
        print "number".$_[0];
        my $sth = $dbh->prepare("UPDATE $table SET surname = ?, numingroup = ?, married =? WHERE id = ?");
        my $married = (defined $_[3]) ? $_[3] : "";
        $sth->execute($_[1],$_[2],$married,$editid);
        $sth->finish();
      
 } 

sub deleteelem{
   if($_[0]){
    my $sth = $dbh->prepare("DELETE FROM $table WHERE id=?");
        $sth->execute($_[0]); 
    return 1;
  }else{
    return 0;
  }
   
 } 
sub actionform
  {

   
              my $action = "addelem";
              my $title = "Add human";
              my $persnum=0;
              my $hidden_param = "";
              my $surname = "";
              my $numingroup = "";
              my $id = "";
              my $married = "";
              if($q->param("action") eq "editelem") 
           {
      
              $persnum = $q->param("persnumber");
              my $sth = $dbh->prepare("SELECT * FROM $table WHERE id=?");
              $sth->execute($persnum); 
              my $ref = $sth->fetchrow_hashref();
              $id = $ref->{'id'};
              $surname = $ref->{'surname'};
              $numingroup = $ref->{'numingroup'};
              $married = $ref->{'married'};
            
              $action = "editelem";
              $title = "Edit human";
              
     
            }
              print "<hr><form method=\"post\">
              <p><h2>$title</h2></p>
              $hidden_param
              <input type=\"hidden\" name=\"student\" value=\"".$global->{'student'}."\">
              <p>Surname<input type=\"text\" name=\"surname\" value=\"$surname\"></p>
              <p>numingroup<input type=\"text\" name=\"numingroup\"  value=\"$numingroup\"></p>
              <p>married<input type=\"text\" name=\"married\" value=\"$married\"></p>
              <p><button name=\"action\" type=\"submit\" value=\"$action\">DO</button></p>
              <p><button name=\"action\" type=\"submit\" value=\"download\">Download box from file</button></p>
              </form>";
             
             
       if($q->param("surname")&&$q->param("numingroup")&&$q->param("married")){
          if($q->param("action") eq "editelem") 
            {
               $persnum=$q->param("persnumber");
               $surname=$q->param("surname");
               $numingroup=$q->param("numingroup");
               $married=$q->param("married");
               $funcs[1]->( $persnum,$surname,$numingroup,$married);
      
                 

            } 

          elsif($q->param("action") eq "addelem") 
            {
               $persnum=$q->param("persnumber");
              
               $surname=$q->param("surname");
               $numingroup =$q->param("numingroup");

               $married =$q->param("married");
               $funcs[0]->($surname,$numingroup,$married);
        
               
            }
          }
          elsif
          ($q->param("action") eq "deleteelem") 
            {
               my $persnum = $q->param("persnumber");
               $funcs[2]->($persnum);
         
               
             }
         elsif($q->param("action") eq "download") 
            {
    
               $funcs[5]->();
              
               
             }
            
  }

sub showbox{
  
                   printf("Content-type: text/html\n\n");
                   print "<html> <head>
                    <META charset=\"windows-1251\">
                    <title>Full List</title>
                    </head>
                    <body><h1>Full List</h1><hr>";
              my $sth = $dbh->prepare("select * from $table");
              $sth->execute(); 
              while (my $ref = $sth->fetchrow_hashref()) {
              my $id = $ref->{id};
              my $surname = $ref->{surname};
              my $numingroup = $ref->{numingroup};
              my $married = $ref->{married};
         
            
                    print "    
                    <p><b>Human # $id:</b><p>
                        Surname: <b>$surname</b>
                        numingroup: <b>$numingroup</b>
                        married: <b>$married</b><p>
                    <form method=\"post\">
                    <input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
                    <input type=\"hidden\" name=\"persnumber\" value=\"$id\">
                    <button name=\"action\" type=\"submit\" value=\"editelem\">EditPerson</button>
                    <button name=\"action\" type=\"submit\" value=\"deleteelem\">DeletePerson</button>
                    </form>
                    <hr  size=\"5\"  color=\"#BC8F8F\" noshade>
      </body>
    </html>";
       }   
    }
}

1;