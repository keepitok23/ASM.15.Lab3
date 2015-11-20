#!perl.exe

package ST47;
use strict;
use CGI;
use DBI;
use Scalar::Util qw(looks_like_number);

sub st47 {
	my ($page, $global) = @_;

	my @MainList = ();
	my $db = DBI->connect(
		"DBI:mysql:database=lab3;host=localhost",
		"root", 
		"",
		{'RaiseError' => 1}
	);
	$db->do("SET NAMES cp1251");
	
	sub add {
		my $cname = $page->param('cname');	
		my $ctown = $page->param('ctown');
		my $clocation = $page->param('clocation');
		if ( ( $cname ne "" ) && ( $ctown ne "") ){
			my $sql = $db->prepare("
				INSERT INTO 
					st47
				(cname, ctown, clocation) 
				VALUES 
					(?, ?, ?)");
			$sql->execute($cname,$ctown,$clocation);
			$sql->finish();
		}
	};
	sub edit {
		my $cname = $page->param('cname');	
		my $ctown = $page->param('ctown');
		my $clocation = $page->param('clocation');
		my $id = $page->param('id');
		if ( ( $cname ne "" ) && ( $ctown ne "") ){
			my $sql = $db->prepare("
				UPDATE 
					st47
				SET 
					cname=?, 
					ctown=?, 
					clocation=?
				WHERE
					id=?");
			$sql->execute($cname,$ctown,$clocation,$id);
			$sql->finish();
		}
	}
	sub delete {
		my $id = $page->param('id');
		my $sql = $db->prepare("
			DELETE FROM 
				st47
			WHERE
				id=?");
		$sql->execute($id);
		$sql->finish();
	}	
	sub import {
		my $file = $page->param('file');	
		if ( $file ne "" ){
			my %h;
			dbmopen(%h, $file, 0644);
			for (my $i = 0; ; $i++){
				if (exists $h{$i}){
					my ($cname, $ctown) = split(/--/, $h{$i});
					my $sql = $db->prepare("
						INSERT INTO 
							st47
						(cname, ctown) 
						VALUES 
							(?, ?)");
					$sql->execute($cname,$ctown);
					$sql->finish();
				} else {
					last;
				}		
			}
			dbmclose(%h);
		}	
	}	
	my @functions = (
		\&add,
		\&edit,
		\&delete,
		\&import
	);

	if (looks_like_number($page->param('action'))){
		$functions[$page->param('action')]();
	}

	sub load {	
		my $sql = $db->prepare("SELECT * FROM st47");
		$sql->execute();
		while (my $ref = $sql->fetchrow_hashref()) {
			my %a = (
				id => $ref->{'id'}, 
				cname => $ref->{'cname'}, 
				ctown => $ref->{'ctown'}
			);
			if ($ref->{'clocation'} ne undef){
				%a->{'clocation'} = $ref->{'clocation'};
			}
			push @MainList, \%a;
		}
		$sql->finish();
	};
	
	sub show_page {
		print '
			<table width="100%" border=2 style="margin-bottom:10px;">
				<tr>
					<td colspan=6 style="font-size:30px; text-align: center;">
						СПИСОК КОМПАНИЙ
					</td>
				</tr>
			<tr>
				<td  style="font-size:16px; text-align: center;">
					<b>
					№
					</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>
						Название Компании
					</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>
						Город
					</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>
						Адрес
					</b>
				</td>
				<td  colspan=2 style="font-size:16px; text-align: center;">
					<b>
						Действия
					</b>
				</td>
			</tr>';	
		print $page->start_form();
		print '
			<tr>
				<td  style="font-size:16px; text-align: center;">
					<b>';
		print $page->hidden('student',$global->{'student'});
		print '			</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>';
		print $page->textfield('cname',"",30,100);
		print '
					</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>';
		print $page->textfield('ctown',"",30,100);		
		print '
					</b>
				</td>				<td  style="font-size:16px; text-align: center;">
					<b>';
		print $page->textfield('clocation',"",30,100);		
		print '
					</b>
				</td>
				<td  colspan=2 style="font-size:16px; text-align: center;">
					<b>
					<button cname="action" value=0 type="submit">Добавить</button>
					</b>
				</td>
			</tr>';	
		print $page->end_form;		
		if (scalar @MainList == 0){
			print '<tr>
					<td colspan=5 style="font-size:24px; text-align: center;">
						<b>Список пуст</b>
					</td>
				</tr>';	
		} else {
			for (my $i = 0; $i < scalar @MainList; $i++) {
				print $page->start_form();
				print '
					<tr>
						<td  style="font-size:16px; text-align: center;">
							<b>';
				print $page->hidden('id',$MainList[$i]->{'id'});
				print $page->hidden('student',$global->{'student'});
				print $i+1;
				print '
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>';
				print $page->textfield('cname',$MainList[$i]->{'cname'},30,100);
				print '
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>';
				print $page->textfield('ctown',$MainList[$i]->{'ctown'},30,100);		
				print '
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>';
				if (exists($MainList[$i]->{'clocation'})){
					print $page->textfield('clocation',$MainList[$i]->{'clocation'},30,100);
				}
				else{
					print '-';
				};
				print '
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>
							<button cname="action" value=1 type="submit">Редактировать</button>
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>
							<button cname="action" value=2 type="submit">Удалить</button>
							</b>
						</td>
					</tr>';	
				print $page->end_form;
			}	
		}					
		print '
			</table>';		
		print $page->start_form();
		print $page->textfield('file',"",30,100);
		print $page->hidden('student',$global->{'student'});
		print '<button cname="action" value=3 type="submit" style="margin-left:5px">Импорт из файла</button>';
		print $page->end_form;	
		print	'<a href="'.$global->{'selfurl'}.'"><<Назад</button>';		
	}

	print $page->header( -type => "text/html", -charset => "windows-1251");
	print $page->start_html( -title => "Утенов Р.А." );
	print $page->delete_all();
	load;
	show_page;
	print $page->end_html;
}

return 1;
