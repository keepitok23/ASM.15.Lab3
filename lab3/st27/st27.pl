#!wperl.exe
##package ST00;

use 5.010;
use strict;
use warnings;
use CGI qw(:standard);
use DBI qw(:sql_types);
my ($q, $global) = @_;
my ($dbh, $sth, $sql);






sub save_kart_sql{
		my $nm=param("name");#param("name");$_[2]
		my $bk=param("book");#param("book");$_[3]
		my $bkid=param("book_id");#param("book_id");$_[4]
		my $auth=param("author");#param("author");$_[5]
		if(param("id")){
			my $id = param("id");
			$sql = "UPDATE st27.kart SET _name = ?, book = ?, book_id = ?, author = ?
					WHERE _id = $id";
		}else{
			$sql = "INSERT INTO st27.kart (_name, book, book_id, author) VALUES (?,?,?,?)";
		}
	$sth = $dbh->prepare($sql);
	$sth->execute("$nm","$bk","$bkid","$auth");
	$sth->finish();
		return 1;
	
}
sub load{
	my $name,my $book,my $book_id,my $record;
	@mass = (); %hash=();
	dbmopen(%hash, "lib_kart", 0666) || die "can't open DBM file!\n";
		while((my $key, my $value) = each(%hash)){
			( $name,  $book,  $book_id) = split(/##/,$value);
			save(select_fields($name, $book, $book_id));
			$record = {	"name",$name,"book",$book,"book_id",$book_id};
push(@mass, $record);}
		
		dbmclose(%hash);
		return 1;
	
}

sub del{
	if($_[0]){
	$sql = "DELETE FROM st27.kart where _id = ?";
	$sth = $dbh->prepare($sql);
	for(my $i = 0; $i < $#_ + 1; $i++){
		$sth->bind_param($i+1,$_[$i]);
	}
	$sth->execute();
	$sth->finish();
		return 1;
	}else{
		return 0;
	}
}

sub show_kart{
	#$sth = execute_("SELECT * FROM st27.kart");
	$sql="SELECT * FROM st27.kart";
	$sth = $dbh->prepare($sql);
	$sth->execute();

	print	"<Center><h1>Library`s Kartoteka</h1></Center><p><hr color = 'brown' size = '5'>";
	while((my $id, my $name, my $book, my $book_id, my $author) = $sth->fetchrow_array()){
		if($_[0]==$id){
			show_form("Edit record",$id,select_fields($name, $book, $book_id, $author));
		}else{
			show_rec($id,select_fields($name, $book, $book_id, $author));
		}
	} $sth->finish();
	show_form("Add record",0);
	show_form();
	return 1;
}

sub show_rec{
	print "<p><b>Record</b><p>";
	for(my $i = 1; $i < ($#_ + 1); $i++){
		print "<i>$_[$i]</i><p>";			
	}
	print <<"	END";
		<input type="button" value="Edit" onClick="location.href='?edit=$_[0]&student=$global->{student}';">
		<input type="button" value="Delete" onClick="location.href='?del=$_[0]&student=$global->{student}';">
	END
	return 1;
}

sub select_fields{
	(my $name, my $book, my $book_id, my $author) = @_;
	if($author){
		return ($name, $book, $book_id, $author);
	}else{
		return ($name, $book, $book_id);
	}
}


sub show_form{
	print <<"	END";
		<hr color = 'brown'><form>
		<i><input type=hidden name="student" value=$global->{student}>
	END
	if(@_){
		print <<"		END";
			<p><b>$_[0]</b>
			<i><input type=hidden name="id" value=$_[1] size=4  readonly>
			<p>Enter name: <input name="name" value=$_[2]>
			<p>Enter book: <input name="book" value=$_[3]>
			<p>Enter book_id: <input name="book_id" value=$_[4]><i>
			<p>Enter author: <input name="author" value=$_[5]></i>
			<p><input type="submit" value="Accept">
		END
	}
	
	return 1;
}


sub create_table{
my $host = "localhost"; # MySQL-сервер нашего хостинга
my $port = "3306"; # порт, на который открываем соединение
my $user = "root"; # имя пользователя
my $pass = "root"; # пароль
my $db = "st27"; # имя базы данных 

	$dbh =DBI->connect("DBI:mysql:$db:$host:$port", $user, $pass);
	#$dbh = DBI->connect("DBI:mysql:localhost:nik_db:3306", "root", "root");
	$sql = "CREATE TABLE IF NOT EXISTS st27.kart(
			_id int(255) NOT NULL AUTO_INCREMENT PRIMARY KEY,
			_name varchar(20) NOT NULL,
			book varchar(20) NOT NULL,
			book_id int NULL,
			author varchar(20) NULL
			)";
	$dbh->do($sql);
	return 1;
}

sub head{
	print header(-type=>'text/html',
				 -charset=>'windows-1251'
			    );
	print start_html("Nik_Lab3");
	return 1;
}



sub main{
	create_table();
	head();
	save_kart_sql();
	del(param("del"));
	show_kart(param("edit"));
	$dbh->disconnect();
}


main();
1;

	
	