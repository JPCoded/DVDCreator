#!/usr/local/bin/perl -w

use English;
use Switch;    # allows the use of switch() structures
use strict;
use Tk;
use Tk::widgets qw(FileSelect Widget);
require "BName.pm";

my ($bn) = Mvid::BName->new;

my ($strFile,$strMPG,$strISO,$strMPGS) = ""; 

# Main Window
my ($mw) = new MainWindow;
$mw->geometry("250x180");
$mw->title("Main Menu");
$mw->resizable( 0, 0 );    #don't allow resize

my($lblHeader)=$mw->Label(-text=>'MENU')->pack;
my ($btnFile) = $mw->Button( -width => 30, -text => "Select File", -command => sub { mainMenu(1); })->pack;
my ($btnFFmpeg) = $mw->Button( -width => 30, -text => "Create DVD (NO SUBs)", -state=>'disabled',-command => sub { mainMenu(2);})->pack;
my ($btnSPUMUX) = $mw->Button( -width => 30, -text => "Create DVD (SUBS)", -state=>'disabled',-command => sub { mainMenu(3); })->pack;
my ($btnCLEAN) = $mw->Button( -width => 30, -text => "Clean Up", -state=>'disabled',-command => sub { mainMenu(4); })->pack;
my($lblFile)=$mw->Label()->pack;

MainLoop;

sub getFile {	
	$btnFile->configure(-state=>'disabled');
	my($FSref) = $mw->FileSelect( -directory=>"/media/RAID/Movies2DVD/");
	$strFile = $FSref->Show;
	if ($strFile) {
		$bn->set($strFile);
		$strMPG = $bn->name().".mpg";
		chdir($bn->dir());
		$btnFFmpeg->configure(-state=>'normal');
		$btnSPUMUX->configure(-state=>'normal');
		$lblFile->configure(-text=>'MOVIE NAME: ' . $bn->name());
	}
	$btnFile->configure(-state=>'normal');
}

sub mainMenu {
    my $mmArgs = shift;
   	
        switch ($mmArgs) {
			#get file
			case 1 { getFile();}	
            #convert to mpg, create filesystem, tileset and iso w/o subs
            case 2 {  
					mpgConv();
					# Create File System
					system("dvdauthor","--title","-o","dvd","-f",$strMPG);
					print "\nDVD FS created \n\n";	
					dvdFS();
					} 
			#same as case 2 except with subs
			#NOT WORKING
            case 3 { 
					 mpgConv();
					 $strMPGS = $bn->name()."S.mpg";
					 system("spumux", "-s0", "-m", "dvd", "-P", "subs.xml", "<", $strMPG, ">", $strMPGS) or die "\nERROR with SPUMUX\n";
					 print "\nSubtitles Muxed \n";
					 system("dvdauthor","--title","-o","dvd","-f",$strMPGS);
					 print "\nDVD FS created \n";	
					 dvdFS();
					 }
			#delete folder dvd/, rm mpg and avi files and reset variables
			case 4 { 
					 system("rm","-r","dvd/");
					 print "\ndir dvd/ deleted\n";
					 if($strMPG){system("rm",$strMPG); print "\n$strMPG deleted \n";}
					 if($strFile){system("rm",$strFile); print "\n$strFile deleted \n";}
					 if($strMPGS){system("rm",$strMPGS); print "\n$strMPGS deleted \n";}

					 ($strISO,$strFile,$strMPG,$strMPGS)= "";
					 $btnCLEAN->configure(-state=>"disabled");
					 $lblFile->configure(-text=>'MOVIE NAME:');
					}
				}
}

sub mpgConv {
		# Convert file to MPG
		system("ffmpeg", "-i", $strFile, "-y", "-target", "ntsc-dvd", "-sameq", "-aspect", "16:9", "-copyts", $strMPG);
		print "\nFile Converted \n\n";
}

sub dvdFS {
	$strISO = $bn->name().".iso";
	# Create dvd Tileset
	system("dvdauthor","-o","dvd", "-T");
	print "\nDVD TOC Created \n\n";
	system("mkisofs", "-dvd-video", "-o", $strISO ,"dvd/"); 
	print "\nISO created \n\n";			
	system("mv", $strISO,"/media/RAID/Movies2DVD/Movies/");
	print "\nISO moved \n";
	$btnCLEAN->configure(-state=>"normal");
	$btnFFmpeg->configure(-state=>'disabled');
	$btnSPUMUX->configure(-state=>'disabled');
}
