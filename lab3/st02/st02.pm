#!/usr/bin/perl
package ST02;
use strict;

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use DBI;

sub st02
{	my ($q, $global) = @_;
	my $dbh;
	my %HASH;
	
	sub get_id{
		my $id = -1;
		while (my ($key, $value) = each %HASH)
		{
			if ($key > $id)
			{
				$id = $key;
			}
		}
		return $id + 1;
	}
	
	sub show_form{	
		my $name = "";
		my $age = "";
		my $email = "";
		my $type = "";
		my $action = 'add';
		my $text = "Input Data";
		my $edit_id = "";
		
		print $q->start_html( -title => "Badrudinova Lab_2"),
			$q->h1("List of students"),
			$q->hr();
			
		print $q->start_form(-method => "post"); 
		print $q->h4("Import from file data.txt:"), "<input type = 'submit' name = 'action' value = 'import'>";
		print "<input type = 'hidden' name = 'student' value = '$global->{student}'>";
		print $q->end_form;
		
		if ($q->param('action') eq 'edit')
		{
			($name, $age, $email, $type) = split(/##/,$HASH{$q->param('id')});
			$edit_id = $q->param('id');
			$action = 'do_edit';
			$text = "Edit Data";
		}
			
		print $q->start_form(-method => "post"); 
		print $q->p($q->fieldset(
			$q->legend($text),
			"<input type = 'hidden' name = 'id' value = '$edit_id'>
			<input type = 'hidden' name = 'student' value = '$global->{student}'>",
			$q->b('Name: '),
			"<input type = 'text' name = 'name' value = '$name'  required>",
			$q->p($q->b('Age: '), "<input type = 'number' name = 'age' min = '1' max = '100' value = '$age' required>"),
			$q->p($q->b('E-mail: '), "<input type = 'email' name = 'email' value = '$email' required>"),
			"<p><input type = 'radio' name = 'type' value = 'steward'>Steward</p>
			<p><input type = 'radio' name = 'type' value = 'shop steward'>Shop steward</p>
			<p><input type = 'radio' name = 'type' value = 'sport organizer'>Sport organizer</p>
			<input type = 'submit' name = 'action' value = '$action'>"
			));
		print $q->hr(),
			$q->end_form,
			$q->end_html;
	}
	
	sub display{
		my $count = 0;
		print $q->start_table({-border=> 1, -width => "50%", -align => "center"}),
			$q->col({-width => "5%"}),
			$q->col({-width => "20%"}),
			$q->col({-width => "5%"}),
			$q->col({-width => "25%"}),
			$q->col({-width => "20%"});
		
		print $q->Tr( [
			$q->th( {-bgcolor => "#cccccc"}, ["Num", "Name", "Age", "E-mail", "Extended", "Actions"] ),
		] );
			
		if (keys %HASH > 0)
		{	
			foreach my $key (sort keys %HASH)
			{
				my ($name, $age, $email, $type) = split(/##/,$HASH{$key});
				$count++;
				print $q->Tr(
					$q->start_form(-method => "post").
					"<input type = 'hidden' name = 'student' value = '$global->{student}'>
					<input type = 'hidden' name = 'id' value = '$key'>".
					$q->td([$count, $name, $age, $email, $type,
					$q->submit(-name => 'action', -value => 'edit').
					$q->submit(-name => 'action', -value => 'delete')]).
					$q->end_form()
				);
			}
		}
		else {
			print $q->p("The list is empty");
		}
		print end_table;
	}
	 
	sub add{
		my $type;
		if ($q->param('type'))
		{ $type = $q->param('type'); }
		else { $type = ""; }
		my $sth = $dbh->prepare("insert into st02 (id, name, age, email, type) values (?, ?, ?, ?, ?)");
		$sth->execute(get_id(), $q->param('name'), $q->param('age'), $q->param('email'), $type);
		$sth->finish();
		print $q->p("Item added to the list");
	}
	
	sub edit{
		my $type;
		if ($q->param('type'))
		{ $type = $q->param('type'); }
		else { $type = ""; }
		my $sth = $dbh->prepare("update st02 set name = ?, age = ?, email = ?, type = ? where id = ?");
		$sth->execute($q->param('name'), $q->param('age'), $q->param('email'), $type, $q->param('id'));
		$sth->finish();
		print $q->p("Item edited");
	}
	
	sub delete{
		$dbh->do("delete from st02 where id =".(0+$q->param('id')));
		print $q->p("Item deleted");
	}
			
	sub load{
		my $sth = $dbh->prepare("select * from st02");
		$sth->execute();
		while (my $ref = $sth->fetchrow_hashref())
		{
			$HASH{$ref->{'id'}} = join('##', $ref->{'name'}, $ref->{'age'}, $ref->{'email'}, $ref->{'type'});
		}
		$sth->finish();
	}		
	
	sub import{
		my %H;
		dbmopen(%H, "data.txt", 0666) or die "Can't open file: $!\n";
		$dbh->do("truncate table st02");
		while( my ($key,$value) = each %H)
		{
			my ($name, $age, $email) = split(/##/,$H{$key});
			my $sth = $dbh->prepare("insert into st02 (id, name, age, email) values (?, ?, ?, ?)");
			$sth->execute($key+1, $name, $age, $email);
			$sth->finish();
		}
		dbmclose %H;
	}

	print $q->header(-type => "text/html", -charset => "windows-1251");

	$dbh = DBI->connect("DBI:mysql:data", "root", "root", {RaiseError => 1, AutoCommit => 1});
	$dbh->do("SET NAMES cp1251");
	
	my %MENU = (
		add => \&add, 
		do_edit=> \&edit, 
		delete => \&delete,
		import => \&import);
		
	load();
	my $action = $q->param('action');
	if (defined $MENU{$action})
	{
		$MENU{$action}->();
		%HASH = ();
		load();
	}
	display();
	show_form();
	
	print "<br><a href=\"$global->{selfurl}\">Back</a>";
	$dbh->disconnect();
}

1;
