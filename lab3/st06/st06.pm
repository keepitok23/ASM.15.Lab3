#!wperl.exe
package ST06;
sub st06
{
use 5.010;
use strict;
use warnings;
use CGI qw(:standard);
use DBI qw(:sql_types);
my ($q, $global) = @_;
my ($dbh, $sth, $sql);

create_table();

head();

save(select_fields(param("name"),param("surname"),param("group"),param("salary")));
load(param("path"));
del(param("del"));

show_list(param("edit"));

$dbh->disconnect();

sub save{
	if(@_){
		if(param("id")){
			my $id = param("id");
			$sql = "UPDATE card_file SET _name = ?, _surname = ?, _group = ?, _salary = ?
					WHERE _id = $id";
		}else{
			$sql = "INSERT INTO card_file (_name, _surname, _group, _salary) VALUES (?,?,?,?)";
		}
		$sth = execute_($sql, @_);
		$sth->finish();
		return 1;
	}else{
		return 0;
	}
}
sub load{
	if(@_){
		dbmopen(my %hdb, $_[0], 0666) || die;
		while((my $key, my $value) = each(%hdb)){
			(my $name, my $surname, my $group, my $salary) = split(/::/,$value);
			save(select_fields($name, $surname, $group, $salary));
		}
		dbmclose(%hdb);
		return 1;
	}else{
		return 0;
	}
}

sub del{
	if($_[0]){
		$sth = execute_("DELETE FROM card_file where _id = ?", $_[0]);
		$sth->finish();
		return 1;
	}else{
		return 0;
	}
}

sub show_list{
	$sth = execute_("SELECT * FROM card_file");
	print "<h1>CARD FILE</h1>";
	while((my $id, my $name, my $surname, my $group, my $salary) = $sth->fetchrow_array()){
		if($_[0]==$id){
			show_form("Edit person",$id,select_fields($name, $surname, $group, $salary));
		}else{
			show_person($id,select_fields($name, $surname, $group, $salary));
		}
	} $sth->finish();
	show_form("Add person",0);
	show_form();
	return 1;
}

sub show_person{
	print "<hr><p><b>PERSON</b><p>";
	for(my $i = 1; $i < ($#_ + 1); $i++){
		print "<i>$_[$i]</i><p>";			
	}
	print <<"	END";
		<input type="button" value="Edit" onClick="location.href='?edit=$_[0]&student=$global->{student}';">
		<input type="button" value="Delete" onClick="location.href='?del=$_[0]&student=$global->{student}';">
		<a href='#add';">Add person</a>
	END
	return 1;
}

sub select_fields{
	(my $name, my $surname, my $group, my $salary) = @_;
	if($salary){
		return ($name, $surname, $group, $salary);
	}else{
		return ($name, $surname, $group);
	}
}

sub execute_{
	($sql, @_) = @_;
	$sth = $dbh->prepare($sql);
	bind_(@_);
	$sth->execute();
	return $sth;
}

sub bind_{
	for(my $i = 0; $i < $#_ + 1; $i++){
		$sth->bind_param($i+1,$_[$i]);
	}
	return 1;
}

sub show_form{
	print <<"	END";
		<hr><form>
		<i><input type=hidden name="student" value=$global->{student}>
	END
	if(@_){
		print <<"		END";
			<p><b>$_[0]</b>
			<i><input type=hidden name="id" value=$_[1] size=4  readonly>
			<p>Enter name: <input name="name" value=$_[2]>
			<p>Enter surname: <input name="surname" value=$_[3]>
			<p>Enter group: <input name="group" value=$_[4]><i>
			<p>Enter salary: <input name="salary" value=$_[5]></i>
			<a name="add"></a>
		END
	}else{
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
sub create_table{
	$dbh = DBI->connect("DBI:mysql:st45:localhost", "root", "");
	$sql = "CREATE TABLE IF NOT EXISTS card_file(
			_id int(255) NOT NULL AUTO_INCREMENT PRIMARY KEY,
			_name varchar(20) NOT NULL,
			_surname varchar(20) NOT NULL,
			_group varchar(15) NULL,
			_salary int(5) NULL
			)";
	$dbh->do($sql);
	return 1;
}

sub head{
	print header(-type=>'text/html',
				 -charset=>'windows-1251'
			    );
	print start_html("Lab3");
	return 1;
}
}
1;