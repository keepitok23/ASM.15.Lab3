#!C:/perl/bin/perl
use strict;
use CGI::Carp qw (fatalsToBrowser);
use CGI qw(param);
use DBI qw(:sql_types);
use DBI; 
sub st24
{

my @list=();
my $elemnumber=0;


my ($q, $global) = @_;

my %buffer;
my $filename = "file";
my $dbname = "st24";
my $table = "lab3";
my $dbh = DBI->connect( "DBI:mysql:database=$dbname;host=localhost","root", "root", {'RaiseError' => 1, 'AutoCommit' => 1});
    $dbh->do("SET NAMES cp1251");
    

my @funcs= (
  \&add,         
  \&edit,
  \&delete_elem,
  \&showlist,    
  \&saveto,
  \&loadfrom,
  \&actionform,
  \&importfromdbmtodb);
  $funcs[3]->();
  $funcs[6]->();
  $dbh->disconnect();
sub saveto{
         if (@list>0){
         my $i=0;
         my %buf=();
         dbmopen (%buf, $filename, 0644) or die print "cant open file";
         foreach my $nameage(@list)
              {
                
                  $buf{$i} = join('--', $nameage->{name}, $nameage-> {age});
                  ++$i;
              }

        dbmclose(%buf);
     }
           else {print "List is empty";}
           
  }
  sub loadfrom{
    
         my %buf;
         dbmopen(%buf, $filename, 0777);
         @list = ();
            while ( (my $key, my $value) = each %buf )
           {
             my ($name, $age) = split(/--/, $value);
             my %nameage = (name => $name,age => $age);
             push(@list, \%nameage);
             $elemnumber++;
           }
         dbmclose(%buf);
     
  }
  sub importfromdbmtodb{
    
         my %buf;
         dbmopen(%buf, $filename, 0777);
         @list = ();
            while ( (my $key, my $value) = each %buf )
           {
             my ($name, $age, $carmark) = split(/--/, $value);
             
             my $sth = $dbh->prepare("insert into $table (lname,lage,lcarmark) values (?,?,?) ");
            $sth->execute($name,$age,$carmark); 
            $sth->finish();
           }
         dbmclose(%buf);
     
  }
sub add{
        my $lid = $_[0];
        my $lname =$_[1];
        my $lage = $_[2];
        my $lcarmark = $_[3];
        if($lcarmark eq ""){
          $lcarmark=" ";
        }
        my $sth = $dbh->prepare("insert into $table (lname,lage,lcarmark) values (?,?,?) ");
        $sth->execute($lname,$lage,$lcarmark); 
        $sth->finish();
  } 
sub edit{
 
        my $editid =  $_[0];
        print "number".$_[0];
        my $sth = $dbh->prepare("UPDATE $table SET lname = ?, lage = ?, lcarmark =? WHERE lid = ?");
        my $carmark = (defined $_[3]) ? $_[3] : "";
        $sth->execute($_[1],$_[2],$carmark,$editid);
        $sth->finish();
      
 } 

sub delete_elem{
   if($_[0]){
    my $sth = $dbh->prepare("DELETE FROM $table WHERE lid=?");
        $sth->execute($_[0]); 
    return 1;
  }else{
    return 0;
  }
   
 } 
sub actionform
  {

   
              my $action = "add_elem";
              my $title = "Add human";
              my $elemnum=0;
              my $hidden_param = "";
              my $name = "";
              my $age = "";
              my $id = "";
              my $carmark = "";
              if($q->param("action") eq "edit_elem") 
           {
      
              $elemnum = $q->param("elemnumber");
              my $sth = $dbh->prepare("SELECT * FROM $table WHERE lid=?");
              $sth->execute($elemnum); 
              my $ref = $sth->fetchrow_hashref();
              $id = $ref->{'lid'};
              $name = $ref->{'lname'};
              $age = $ref->{'lage'};
              $carmark = $ref->{'lcarmark'};
            
              $action = "edit_elem";
              $title = "Edit human";
              
     
            }
              print "<hr><form method=\"post\">
              <p><h2>$title</h2></p>
              $hidden_param
              <input type=\"hidden\" name=\"student\" value=\"".$global->{'student'}."\">
              <p>Name<input type=\"text\" name=\"namein\" value=\"$name\"></p>
              <p>Age<input type=\"text\" name=\"agein\"  value=\"$age\"></p>
              <p>Carmark<input type=\"text\" name=\"carmarkin\" value=\"$carmark\"></p>
              <p><button name=\"action\" type=\"submit\" value=\"$action\">Accept</button></p>
              <p><button name=\"action\" type=\"submit\" value=\"download\">Download from file</button></p>
              </form>";
             
             
       if($q->param("namein")&&$q->param("agein")&&$q->param("carmarkin")){
          if($q->param("action") eq "edit_elem") 
            {
               $elemnum=$q->param("elemnumber");
               $name=$q->param("namein");
               $age=$q->param("agein");
               $carmark=$q->param("carmarkin");
               $funcs[1]->( $elemnum,$name,$age,$carmark );
               $funcs[4]->();
                 

            } 

          elsif($q->param("action") eq "add_elem") 
            {
               $elemnum=$q->param("elemnumber");
               $id =$q->param("idin");
               $name=$q->param("namein");
               $age =$q->param("agein");

               $carmark =$q->param("carmarkin");
               $funcs[0]->($id,$name,$age,$carmark);
               $funcs[4]->();
               
            }
          }
          elsif
          ($q->param("action") eq "delete_elem") 
            {
               my $elemnum = $q->param("elemnumber");
               $funcs[2]->($elemnum);
               $funcs[4]->();
               
             }
         elsif($q->param("action") eq "download") 
            {
    
               $funcs[7]->();
              
               
             }
             else{ print "nichego ne nazhato "}
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
              my $id = $ref->{lid};
              my $name = $ref->{lname};
              my $age = $ref->{lage};
              my $carmark = $ref->{lcarmark};
         
            
                    print "    
                    <p><b>Human # $id:</b><p>
                        Name: <b>$name</b>
                        Age: <b>$age</b>
                        Carmark: <b>$carmark</b><p>
                    <form method=\"post\">
                    <input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
                    <input type=\"hidden\" name=\"elemnumber\" value=\"$id\">
                    <button name=\"action\" type=\"submit\" value=\"edit_elem\">Edit</button>
                    <button name=\"action\" type=\"submit\" value=\"delete_elem\">Delete</button>
                    </form>
                    <hr  size=\"5\"  color=\"#BC8F8F\" noshade>
      </body>
    </html>";
       }   
    }
}

1;