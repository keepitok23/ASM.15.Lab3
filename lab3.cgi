#!/usr/bin/perl

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

use lab3::st00::st00;
use lab3::st01::st01;
use lab3::st04::st04;
use lab3::st07::st07;
use lab3::st09::st09;
use lab3::st14::st14;
use lab3::st26::st26;
use lab3::st28::st28;
use lab3::st29::st29;
use lab3::st30::st30;
use lab3::st32::st32;
use lab3::st39::st39;
use lab3::st45::st45;
use lab3::st46::st46;

my @MODULES = 
(
	\&ST00::st00,
	\&ST01::st01,
	\&ST04::st04,
	\&ST07::st07,
	\&ST09::st09,
	\&ST14::st14,
	\&ST26::st26,
	\&ST28::st28,
	\&ST29::st29,
	\&ST30::st30,
	\&ST32::st32,
	\&ST39::st39,
	\&ST45::st45,
	\&ST46::st46,
);

my @NAMES = 
(
	"00. Sample",
	"01. Baglikova",
	"04. Borisenko",
	"07. Gorinov",
	"09. Greznev",
	"14. Ivanova",
	"26. Mikaelian",
	"28. Nikolaeva",
	"29. Novozhentsev",
	"30. Pereverzev",
	"30. Pyatakhina",
	"39. Stupin",
	"45. Yazkov",
	"46. Bushmakin",
);

Lab2Main();

sub menu
{
	my ($q, $global) = @_;
	print $q->header();
	my $i = 0;
	print "<pre>\n------------------------------\n";
	foreach my $s(@NAMES)
	{
		$i++;
		print "<a href=\"$global->{selfurl}?student=$i\">$s</a>\n";
	}
	print "------------------------------</pre>";
}

sub Lab2Main
{
	my $q = new CGI;
	my $st = 0+$q->param('student');
	my $global = {selfurl => $ENV{SCRIPT_NAME}, student => $st};
	if($st && defined $MODULES[$st-1])
	{
		$MODULES[$st-1]->($q, $global);
	}
	else
	{
		menu($q, $global);
	}
}
