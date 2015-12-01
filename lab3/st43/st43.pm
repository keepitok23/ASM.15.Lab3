#!/usr/local/bin/perl

package ST43;
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use DBI;

my %library=();
my $q;
my $global;
my $dbh;

sub st43
{

	my %functions = ('Add'=>\&Add, 'Delete'=>\&Delete, 'Edit'=>\&Edit, 'Import'=>\&import);
	my ($q, $global) = @_;
	
	print $q->header( -type => "text/html", -charset => "windows-1251");
	print $q->start_html( -title => "Frolov" );
	print $q->h2("st::43\n");
	$dbh = DBI->connect("DBI:mysql:input", "root", "root", {RaiseError => 1, AutoCommit => 1});
	$dbh->do("SET NAMES cp1251");
	
	my $temp=$q->param('Action');
	if(%functions{$temp})
	{
		%functions{$temp}->();
		%library=();
	}
	load();
	showAdd();
	
	show();
	$dbh->disconnect();
	
	print "<br>";
	print "<a href=\"$global->{selfurl}\">Back</a>";
	

	
	sub showAdd
	{
		my $bookName="";
		my $publishYear="";
		my $publishHouse="";
		my $type="";
		my $edit_id="";
		my $eff="Add";
		
		print $q->start_form(-method => "post"); 
		print $q->h3("Import from file input.txt:"), "<input type = 'submit' name = 'action' value = 'Import'>";
		print "<input type = 'hidden' name = 'student' value = '$global->{student}'>";
		print $q->end_form;
		
		
		if ($q->param('Action') eq "Edit note"){
			#my $id = $q->param('id');
			$edit_id=$q->param('id');
			($bookName,$publishYear,$publishHouse, $type)=split(/;/, %library{$q->param('id')});
			$eff="Edit";
		}
		
		print $q->start_table;
		print $q->start_form(-method=>'post');
		print $q->hidden('student',$global->{student});
		print $q->hidden('id',$edit_id);
		print $q->Tr(
					$q->td('Bookname'),
					$q->td ($q->textfield('Bookname',$bookName))
			  
		  );
		print $q->Tr(
					$q->td('Publishing Year'),
					$q->td ($q->textfield('publishYear',$publishYear))
			  
		  );
		print $q->Tr(
					$q->td('Publishing house'),
					$q->td ($q->textfield('publishHouse',$publishHouse))
			  
		  );
		print $q->Tr(
					
					$q->td ($q->checkbox(-name=>'type', -value=>'Yes',  -label=>'Encyclopedia'))
			  
		  );
		
		print $q->Tr($q->td($q->submit('Action', $eff)));
		print $q->end_form;
		print $q->end_table;
		
	}
	
	
	sub show
	{
		
		
		print $q->start_table({ -border => 2,   -width  => "50%" });
		print $q->Tr( $q->th(['Bookname','Publishing Year','Publishing house', 'Encyclopedia']));
		foreach my $key (sort keys %library)
		{
			#my $temp2={split(";",%library{$id})};
			print $q->Tr(
				$q->start_form (-method=>'post'),
				$q->hidden('student',$global->{student}),
				#$q->hidden('id',$key),
				"<input type=\"hidden\" name=\"id\" value=\"$key\"  />",
				$q->td ([split (";",%library{$key})]),
				# $q->td($bookName),
				# $q->td($publishYear),
				# $q->td($publishHouse),
				$q->td ($q->submit('Action', "Edit note")),
				$q->td ($q->submit('Action', "Delete")),
				#$q->td ($key),
				$q->end_form
			);
			
		}
		print $q->end_table;
	}
	sub get_id
	{
		my $ret_id = -1;
		while ( my ($key, $value) = each %library )
		{
			if($key > $ret_id){
				$ret_id = $key;
			}
		}
		return $ret_id + 1;
	}

	sub Add
	{
		my $type;	
		if ($q->param('type'))
		{
			$type= $q->param('type');
		}
		else { $type = "No"; }
		#$library{get_id()}=join(';',$q->param('Bookname'),$q->param('publishYear'),$q->param('publishHouse'),$type);
		my $sth = $dbh->prepare("insert into st43 (id, Bookname, publishYear, publishHouse, type) values (?, ?, ?, ?, ?)");
		$sth->execute(get_id(), $q->param('Bookname'),$q->param('publishYear'),$q->param('publishHouse'),$type);
		$sth->finish();
	}
	sub Edit
	{
		my $type;
		if ($q->param('type'))
		{
			$type= $q->param('type');
		}
		else { $type = "No"; }
		#$library{$q->param('id')}=join(';',$q->param('Bookname'),$q->param('publishYear'),$q->param('publishHouse'),$type);
		my $sth = $dbh->prepare("update st43 set Bookname = ?, publishYear = ?, publishHouse = ?, type = ? where id = ?");
		$sth->execute($q->param('Bookname'),$q->param('publishYear'),$q->param('publishHouse'), $type, $q->param('id'));
		$sth->finish();
	}
	sub Delete
	{
		#delete $library{$q->param('id')};
		$dbh->do("delete from st43 where id =".(0+$q->param('id')));
	}
	sub load{
		my $sth = $dbh->prepare("select * from st43");
		$sth->execute();
		while (my $ref = $sth->fetchrow_hashref())
		{
			$library{$ref->{'id'}} = join(';', $ref->{'Bookname'}, $ref->{'publishYear'}, $ref->{'publishHouse'}, $ref->{'type'});
		}
		$sth->finish();
	}	
		sub import{
		my %H;
		dbmopen(%H, "input.txt", 0666) or die "Can't open file: $!\n";
		$dbh->do("truncate table st43");
		while( my ($key,$value) = each %H)
		{
			my ($bookName, $publishYear, $publishHouse, $type) = split(/;/,$H{$key});
			my $sth = $dbh->prepare("insert into st43 (id, Bookname, publishYear, publishHouse,type) values (?, ?, ?, ?,?)");
			$sth->execute($key+1,$bookName, $publishYear, $publishHouse, $type);
			$sth->finish();
		}
		dbmclose %H;
	}
};

	

1;