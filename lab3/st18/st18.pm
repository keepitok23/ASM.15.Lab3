#!C:\Perl64\bin\perl.exe
package ST18;
use 5.010;
use strict;
use warnings;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use DBI qw(:sql_types);
use CGI;

	

sub st18
{	

	my %DbmFileHash =();
	my @data = ();
	my $index;
	my ($q, $global) = @_;
	my ($dbh, $sth, $sql);



sub bind_
{
	for(my $i = 0; $i < $#_ + 1; $i++){
		$sth->bind_param($i+1,$_[$i]);
	}
	return 1;
}
	
sub execute_
{
	($sql, @_) = @_;
	$sth = $dbh->prepare($sql);
	bind_(@_);
	$sth->execute();
	return $sth;
}	

sub SavetoDbm
{
	if(@_)
	{
		if(param("id")){
			my $id = param("id");
			$sql = "UPDATE table_2 SET _name = ?, _mail = ?, _phone = ?
					WHERE _id = $id";
		}
		else
		{
			$sql = "INSERT INTO table_2 (_name, _mail, _phone) VALUES (?,?,?)";
		}
		$sth = execute_($sql, @_);
		$sth->finish();
		return 1;
	}
	else 
	{
		return 0
	};
}


sub select_fields
{
	(my $name, my $mail, my $phone) = @_;
	if($mail)
	{
		return ($name, $mail, $phone);
	}
	else
	{
		return ($name, $mail);
	}
}

sub del_rec
{
	if($_[0])
	{
		$sth = execute_("DELETE FROM table_2 where _id = ?", $_[0]);
		$sth->finish();
		return 1;
	}
	else
	{
		return 0;
	}
}


sub LoadList
{
	dbmopen (%DbmFileHash, $_[0],0666);
	while (my ($key, $value) = each(%DbmFileHash))
	{
		my ($name, $mail, $phone) = split(/--/, $value);
		save(select_fields($name, $mail, $phone))
			
	}
		dbmclose %DbmFileHash;
	return 1;
}




sub show_person
{

	print "<hr><p><b>PERSON</b><p>";
	for(my $i = 1; $i < ($#_ + 1); $i++)
	{
			print "<i>$_[$i]</i><p>";			
	}
		print <<"	END";
			<input type="button" value="Edit" onClick="location.href='?edit=$_[0]&student=$global->{student}';">
			<input type="button" value="Delete" onClick="location.href='?del=$_[0]&student=$global->{student}';">
			<a href='#add';">Add person</a>
	END
	return 1;
}

sub show_form
{
	print <<"	END";
		<hr><form>
		<i><input type=hidden name="student" value=$global->{student}>
	END
	if(@_){
		print <<"		END";
			<p><b>$_[0]</b>
			<i><input type=hidden name="student" value=$global->{student}>
				<i><input type = "hidden" name="id" value=$_[1] readonly>
				<p>Enter name: <input name="name" value=$_[2]>
				<p>Enter mail: <input name="mail" value=$_[3]>
				<p>Enter phone: <input name="phone" value=$_[4]></i>
			<a name="add"></a>
		END
	}else
	{
		print <<"		END";
			<p>Load from: <input name="path" value="dbfile">
		END
	}
	print <<"	END";
			<p><input type="submit" value="Accept">
			<p><a href=\"$global->{selfurl}\">Start page</a>
		</form><hr>
	END
	return 1;
}


sub show_list
{
	$index = 0;
	print header(-type=>'text/html',  -charset=>'windows-1251');
	print start_html("Klykov Lab 2");
	print	"<Center><h1>List</h1></Center><p>";
	$sth = execute_("SELECT * FROM table_2");
	while((my $id, my $name, my $mail, my $phone) = $sth->fetchrow_array()){
		if($_[0]==$id)
		{
			show_form("Edit person",$id,select_fields($name, $mail, $phone));
		}
		else
		{
			show_person($id,select_fields($name, $mail ,$phone));
		}
		} 
	$sth->finish();
	show_form("Add person",0);
	show_form();
	return 1;
}



sub create_table
{
	$dbh = DBI->connect("DBI:mysql:st18:localhost", "root", "");
	$sql = "CREATE TABLE IF NOT EXISTS table_2(
			_id int(255) NOT NULL AUTO_INCREMENT PRIMARY KEY,
			_name varchar(20) NOT NULL,
			_mail varchar(20) NOT NULL,
			_phone varchar(15) NULL
			)";
	$dbh->do($sql);
	return 1;
}




	
	create_table();	
	SavetoDbm(select_fields(param("name"),param("mail"),param("phone")));
	LoadList(param("path"));
	del_rec(param("del"));
	show_list(param("edit"));


$dbh->disconnect();
}

1;

	
	
	