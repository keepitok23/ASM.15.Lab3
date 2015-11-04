
package ST09;
use strict;

use CGI;
use CGI::Carp qw(fatalsToBrowser);

sub st09
{
	my ($q, $global) = @_;

	my %hash_obj=();
	my $dbhandle = DBI->connect("DBI:mysql:database=lab3;
		host=localhost","root", "", 
		{'RaiseError' => 1});
	$dbhandle->do("set names cp1251");
	
	sub AddEditForm{
		my $name="";
		my $family="";
		my $address="";
		my $type="regular";
		my $type_check='';
		my $edit_id="";
		my $act='add';
		if($q->param('Action') eq "send_edit"){
			my $id = $q->param('id');
			$edit_id= "<input type=\"hidden\" name=\"id\" value=\"$id\">";
			print "<h3>Editing</h3>";
			($name,$family,$address,$type)=split(/#%/, %hash_obj{$id});
			if($type eq'regular'){
				$type_check='checked';
			}

			$act="edit";
		}else{
			print "<h3>Add element</h3>";
		}
		
			print "
				<table>
				<form method=\"post\">
			 		<input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
					$edit_id
					<tr> <td>Name:</td>
						 <td><input type=\"text\" name=\"Name\" value=\"$name\"></td>
					</tr>
					<tr> <td>Family:</td>
				 		 <td><input type=\"text\" name=\"Family\" value=\"$family\"></td>
				 	<tr> <td>Address:</td>
				 		 <td><input type=\"text\" name=\"Address\" value=\"$address\"></td>
					</tr>
					<tr> <td>Regular:</td>
				 		 <td>
				 		 	<input type=\"checkbox\" name=\"Type\" $type_check value=\"$type\">
				 		 </td>
					</tr>
					<tr> <td></td>
						 <td><button name=\"Action\" type=\"submit\" value=\"$act\">Apply</button></td>
					</tr>

					
				</form>
				</table>";
	}
	sub ImportFile{
		print"<table>
				<form method=\"post\">
			 		<input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
					
					<tr>
						<td><h4>Import from file</h4></td>
					</tr>
					<tr>
						<td><input type=\"text\" name=\"name_file\" value=\"\"></td>
						<td><button name=\"Action\" type=\"submit\" value=\"import\">Open</button></td>
					<tr>
				</form>
				</table>";	
	}
	sub ListOfbj{
		print"<h2>List of customer </h2>";
		if(keys %hash_obj<0){
			print"<p>There is empty</p>";
		}else{
			
			print "<table>
				<tr>
					<td><h3>Name</h3></td><td><h3>Family</h3></td><td><h3>Address</h3></td><td><h3>Type</h3></td>
				<tr>";
			#while( my ($key,$value) =each %hash_obj sort keys){
			foreach my $key(sort keys %hash_obj){
				my $value=$hash_obj{$key};
				my ($name,$family,$address,$type)=split(/#%/, $value);
				print"
				<tr>
					<form method=\"post\">
					 	<input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
					 	<input type=\"hidden\" name=\"id\" value=\"$key\">
						<td>$name</td>
						<td>$family</td>
						<td>$address</td>
						<td>$type</td>
						<td><button name=\"Action\" type=\"submit\"  value=\"send_edit\">Edit</button></td>
						<td><button name=\"Action\" type=\"submit\" value=\"del\">Delete</button></td>
					</form>
				</tr>";	
					
			}
			print"</table>";
		}
		print "<br>";
		
	}
	
	sub get_id
	{
		my $ret_id = -1;
		while ( my ($key, $value) = each %hash_obj )
		{
			if($key > $ret_id){
				$ret_id = $key;
			}
		}
		return $ret_id + 1;
	}
		
	my %function=(
		'add'=>sub{
			my $type=$q->param('Type');
			if($type ne 'regular'){
				$type='not regular';
			}
			
			my $sql=$dbhandle->prepare(
					"insert into st09 (id,name,family,address,type) VALUES (?,?,?,?,?)");
			$sql->execute(
					get_id(),
					$q->param('Name'),
					$q->param('Family'),
					$q->param('Address'),
					$type
					);
			$sql->finish();
			%hash_obj=();
			Load_Data();
		print("<td><p>Customer added</p>");
		},
		'edit'=>sub{
			my $type=$q->param('Type');
			if($type ne 'regular'){
				$type='not regular';
			}
			my $sql = $dbhandle->prepare("update st09 set 
				name=?,
				family=?,
				address=?,
				type=?
					where id=?");
			$sql->execute(
				$q->param('Name'),
				$q->param('Family'),
				$q->param('Address'),
				$type,
				$q->param('id')
				);
			$sql->finish();
			%hash_obj=();
			Load_Data();
		print("<p>Customer edeted</p>");
		},
		'del'=>sub{
			my $sql = $dbhandle->prepare("delete from st09 where	id=?");
			$sql->execute($q->param('id'));
			$sql->finish();
			%hash_obj=();
			Load_Data();
		print "<p>Customer deleted</p>";
		},
		'import'=>sub {
			
			my $file = $q->param('name_file');	
			my %h;
			dbmopen(%h, $file, 0644) || die print "Can't open file !";
			
			$dbhandle->do("truncate table st09");
			%hash_obj=();
			
			while( my ($key,$value) = each %h){

				my ($name,$family,$address)=split(/#%/, $value);
					my $sql = $dbhandle->prepare("insert into st09
							(id, name, family, address) 
						VALUES 
							(?, ?, ?,?)");
					$sql->execute($key,$name,$family,$address);
					$sql->finish();

			}
			
			Load_Data();		
			dbmclose(%h);
		}	

		
	);
	sub Load_Data{
		my $sql = $dbhandle->prepare("select * from st09");
		$sql->execute();
		while (my $r = $sql->fetchrow_hashref()) {
			$hash_obj{$r->{'id'}}=join('#%',
					$r->{'name'},
					$r->{'family'},
					$r->{'address'},
					$r->{'type'});
		}
		$sql->finish();
	}
	
	


	print $q->header(
		-type=>"text/html",
		-charset=>"windows-1251"		
	);
	print $q->start_html("Greznev V.S");

	Load_Data();
	my $ch=$q->param('Action');
	if(%function{$ch}){
		%function{$ch}->();
	}
	ListOfbj();
	AddEditForm();	
	ImportFile();
	
	print "<a href=\"$global->{selfurl}\">Back</a>";
	print $q->end_html;

	$dbhandle->disconnect();
}

1;

