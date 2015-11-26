#!C:/perl/bin/perl
use strict;
use CGI::Carp qw (fatalsToBrowser);
use CGI qw(param);
use DBI qw(:sql_types);
use DBI; 
sub st24
{

my @list=();
my $num_of_selected=0;


my ($q, $global) = @_;

my %buffer;
my $filename = "spisokelementov";
my $dbpersname = "st11";
my $table = "lab3";
my $dbh = DBI->connect( "DBI:mysql:database=$dbname;host=localhost","root", "", {'RaiseError' => 1, 'AutoCommit' => 1});
    $dbh->do("SET persnameS cp1251");
    

my @mass= (
  \&add,         
  \&redact,
  \&delete_elem,
  \&showlist,    
  \&actionform,
  \&loadingdbm);
  $mass[4]->();
  $mass[3]->();
  $dbh->disconnect();

  sub loadingdbm{
    
         my %buf;
         dbmopen(%buf, $filename, 0777);
         @list = ();
            while ( (my $key, my $value) = each %buf )
           {
             my ($persname, $perssurname) = split(/--/, $value);
             
             my $sth = $dbh->prepare("insert into $table (persname,perssurname,degree) values (?,?,'null') ");
            $sth->execute($persname,$perssurname); 
            $sth->finish();
           }
         dbmclose(%buf);
     
  }
sub add{
        my $id = $_[0];
        my $persname =$_[1];
        my $perssurname = $_[2];
        my $degree = $_[3];
        if($degree eq ""){
          $degree='null';
        }
        my $sth = $dbh->prepare("insert into $table (persname,perssurname,degree) values (?,?,?) ");
        $sth->execute($persname,$perssurname,$degree); 
        $sth->finish();
  } 
sub redact{
 
        my $editid =  $_[0];
        my $sth = $dbh->prepare("UPDATE $table SET persname = ?, perssurname = ?, degree =? WHERE id = ?");
        my $degree = (defined $_[3]) ? $_[3] : "";
        $sth->execute($_[1],$_[2],$degree,$editid);
        $sth->finish();
      
 } 

sub delete_elem{
   if($_[0]){
    my $sth = $dbh->prepare("DELETE FROM $table WHERE id=?");
        $sth->execute($_[0]); 
    return 1;
  }else{
    return 0;
  }
   
 } 
 sub showlist{
  
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
              my $persname = $ref->{persname};
              my $perssurname = $ref->{perssurname};
              my $degree = $ref->{degree};
         
            
                    print "    
                    <p><b>Human # $id:</b><p>
                        Name: <b>$persname</b>
                        Surname: <b>$perssurname</b>
                        degree: <b>$degree</b><p>
                    <form method=\"post\">
                    <input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
                    <input type=\"hidden\" name=\"num_of_selected\" value=\"$id\">
                    <button name=\"action\" type=\"submit\" value=\"to_redact\">Edit</button>
                    <button name=\"action\" type=\"submit\" value=\"delete_elem\">Delete</button>
                    </form>
                    <hr  size=\"5\"  color=\"#BC8F8F\" noshade>
      </body>
    </html>";
       }   
    }
sub actionform
  {

   
              my $action = "to_add";
              my $title = "Add ";
              my $elemnum=0;
              my $hidden_param = "";
              my $persname = "";
              my $perssurname = "";
              my $id = "";
              my $degree = "";
              if($q->param("action") eq "to_redact") 
           {
      
              $elemnum = $q->param("num_of_selected");
              my $sth = $dbh->prepare("SELECT * FROM $table WHERE id=?");
              $sth->execute($elemnum); 
              my $ref = $sth->fetchrow_hashref();
              $id = $ref->{'id'};
              $persname = $ref->{'persname'};
              $perssurname = $ref->{'perssurname'};
              $degree = $ref->{'degree'};
            
              $action = "to_redact";
              $title = "Edit ";
              
     
            }
              print "<hr><form method=\"post\">
              <p><h2>$title</h2></p>
              $hidden_param
              <input type=\"hidden\" name=\"student\" value=\"".$global->{'student'}."\">
              <p>Name<input type=\"text\" name=\"persname\" value=\"$persname\"></p>
              <p>Surname<input type=\"text\" name=\"perssurname\"  value=\"$perssurname\"></p>
              <p>degree<input type=\"text\" name=\"degree\" value=\"$degree\"></p>
              <p><button name=\"action\" type=\"submit\" value=\"$action\">Принять</button></p>
              <p><button name=\"action\" type=\"submit\" value=\"download\">Зугрузить из файла</button></p>
              </form>";
             
             
       if($q->param("persname")&&$q->param("perssurname")&&$q->param("degree")){
          if($q->param("action") eq "to_redact") 
            {
               $elemnum=$q->param("num_of_selected");
               $persname=$q->param("persname");
               $perssurname=$q->param("perssurname");
               $degree=$q->param("degree");
               $mass[1]->( $elemnum,$persname,$perssurname,$degree );
              
            } 

          elsif($q->param("action") eq "to_add") 
            {
               $elemnum=$q->param("num_of_selected");
               $id =$q->param("id");
               $persname=$q->param("persname");
               $perssurname =$q->param("perssurname");

               $degree =$q->param("degree");
               $mass[0]->($id,$persname,$perssurname,$degree);
               
               
            }
          }
          elsif
          ($q->param("action") eq "delete_elem") 
            {
               my $elemnum = $q->param("num_of_selected");
               $mass[2]->($elemnum);
               
             }
         elsif($q->param("action") eq "download") 
            {
               $mass[5]->();
             }
            
  }


}

1;