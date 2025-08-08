#
#SumatraPDF auto reloads

#Configuration: You will need to edit this

our @batch = ("All Days", "Sunday", "Friday", "Saturday", "Panellist", "Trader", "Guest", "Committee");

our $BADGE_W=210/2*0.9;
our $BADGE_H=297/2*0.9;
our $N_W=2;
our $N_H=2;
our $duplex_correct=1.5;
#our $SHRINK=2;
our $scale = 0.12;
our $P_H=297;
our $P_W=210;

our $cropline=1;

our $GuardianBatch=0; # 1=Guardian 0=Other
if($GuardianBatch) {
@batch = ("Guardian");
 
$BADGE_W=297/2*0.9;
$BADGE_H=210*0.9;
$N_W=2;
$N_H=1;
$duplex_correct=0;
$P_W=297;
$P_H=210;

$scale = 0.17;
}

my $xlsx2csv='C:\Users\s_pam\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.11_qbz5n2kfra8p0\LocalCache\local-packages\Python311\Scripts\xlsx2csv.exe';

#END CONFIGURATION

use strict;
use warnings;

#cpan Tk
use Switch;
use File::Slurp;
use Cwd;
use File::HomeDir;
#use Tk;
use Term::ReadKey;

#use Spreadsheet::ParseExcel;

use Text::CSV_XS qw( csv );

our $max_id=0;

our $Nup=$N_W*$N_H;
our $BORDER_W=($P_W-$BADGE_W*$N_W)*0.5;
our $BORDER_H=($P_H-$BADGE_H*$N_H)*0.5;

our @bg_pid;

our @file_list;


our $side;
 
sub open_default_browser {
  my $url = shift;
  my $platform = $^O;
  my $cmd;
  if    ($platform eq 'darwin')  { $cmd = "open \"$url\"";          } # Mac OS X
  elsif ($platform eq 'linux')   { $cmd = "xdg-open \"$url\""; } # Linux
  elsif ($platform eq 'MSWin32') { $cmd = "start $url";             } # Win95..Win7
  if (defined $cmd) {
    system($cmd);
  } else {
    die "Can't locate default browser";
  }
}


my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$year = $year+1900;

my $rname = "registrants_01-24-$year.xlsx";
my $fileSpec = File::HomeDir->my_home . '\Downloads\\' . $rname;

#if ( ! -e "registrants.csv" ) {
#if ( ! -e "$fileSpec" ) {

my $aoh = csv (in => "C:\\Users\\s_pam\\Downloads\\items-2024-02-17-2025-01-18.csv",
               headers => "auto");


#print $aoh->[1]{"Badge Name"};




#my $workbook = $parser->parse("$fileSpec");
 
#Get cell value from excel sheet1 row 1 column 2
#my $worksheet = $workbook->worksheet('Export');
#my $cell = $worksheet->get_cell(0,1);

#rint "CELL $cell";
#exit;
#use Browser::Open qw( open_browser );



my $dir = getcwd;
print "CWD: $dir\n"; 
#exit;
#print "vvvvvvv\n";

our $cP=0;
our $cW=0;
our $cH=0;

our $FH;

our $svg_name;
 
sub open_SVG {
   my $fname = shift;
   $svg_name=$fname;
   my $out='<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   id="Layer_1"
   data-name="Layer 1"
   viewBox="0 0 '.$P_W.' '.$P_H.'"
   version="1.1"
   sodipodi:docname="FinalBlack.svg"
   xml:space="preserve"
   inkscape:version="1.3 (0e150ed6c4, 2023-07-21)"
   width="'.$P_W.'0"
   height="'.$P_H.'0"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg">';

   print "About to open\n";
   open($FH,'>',$fname) or die;
   print "Opened $fname\n";
   $cP=0;
   $cW=0;
   $cH=0;
   print $FH $out;
}

sub write_SVG {
   my ($t) = @_;
   my $page_pos=($BORDER_H+$P_H)*$cP;
   my $XcW;
   if ($side=~/Back/) {
      $XcW=$N_W-1-$cW
   } else {
      $XcW=$cW
   }
   #_cW = $N_W-1-$cW
   my $x=$BORDER_W+$BADGE_W*$XcW; 
   my $y=$BORDER_H+$BADGE_H*$cH+$page_pos;

   my $out = "<g transform=' translate($x $y) scale($scale)'>$t</g>";
   # $x=$BORDER_W+$BADGE_W; 
   # $y=$BORDER_H+$BADGE_H;

   if ($cW+$cH == 0) {
      switch($cropline) {
      case 0 { }
      case 1 { 
         my $x=$BORDER_W+$duplex_correct;
         my $y2=$page_pos+$BORDER_H-2;
         my $y3=$page_pos+$P_H-$BORDER_H+2;
         my $y4=$page_pos+$P_H;
         for(my $i = 0; $i <= $N_W; $i++){
            $out.="<line x1='$x' x2='$x' y1='$page_pos' y2='$y2' stroke='black' stroke-width='0.3'/>\n";
            $out.="<line x1='$x' x2='$x' y1='$y3' y2='$y4' stroke='black' stroke-width='0.3'/>\n";
            for my $xx ($x-2, $x+2) {
               $out.="<circle cx='$xx' cy='$y2' r='0.3' stroke-width='0' fill='black' />";
               $out.="<circle cx='$xx' cy='$y3' r='0.3' stroke-width='0' fill='black' />";
            }
            $x+=$BADGE_W;
	         #print("$i\n");
         }
         my $y=$page_pos+$BORDER_H;
         my $x2 = $BORDER_W-2 +$duplex_correct;
         my $x3 = $P_W-$BORDER_W+2 +$duplex_correct;
         for(my $i = 0; $i <= $N_H; $i++){
            $out.="<line y1='$y' y2='$y' x1='0' x2='$x2' stroke='black' stroke-width='0.3'/>\n";
            $out.="<line y1='$y' y2='$y' x1='$x3' x2='$P_W' stroke='black' stroke-width='0.3'/>\n";
            for my $yy ($y-2, $y+2) {
               $out.="<circle cx='$x2' cy='$yy' r='0.3' stroke-width='0' fill='black' />";
               $out.="<circle cx='$x3' cy='$yy' r='0.3' stroke-width='0' fill='black' />";
            }
            $y+=$BADGE_H ;
	         #print("$i\n");
         }
      }
      case 3 { 
         my $x=$BORDER_W+$duplex_correct;
         my $y2=$page_pos+$P_H;
         for(my $i = 0; $i <= $N_W; $i++){
            $out.="<line x1='$x' x2='$x' y1='$page_pos' y2='$y2' stroke='black' stroke-width='0.3'/>\n";
            $x+=$BADGE_W;
	         #print("$i\n");
         }
         my $y=$page_pos+$BORDER_H;
         for(my $i = 0; $i <= $N_H; $i++){
            $out.="<line y1='$y' y2='$y' x1='0' x2='$P_W' stroke='black' stroke-width='0.3'/>\n";
            $y+=$BADGE_H ;
	         #print("$i\n");
         }
      }
      }
   }

   $cW++;
   if ($cW>=$N_W) {
      $cW=0;
      $cH++;
      if ($cH>=$N_H) {
         $cH=0;
         $cP++;
      }
   }

   print $FH $out;

}

sub close_SVG {
   my $lastpage=$cP;
   my $out = "";
   if ($cW+$cH == 0) {
      $lastpage--;
   }
   $out.='
     <sodipodi:namedview
     id="namedview1"
     pagecolor="#ffffff"
     bordercolor="#000000"
     borderopacity="0.25"
     inkscape:showpageshadow="2"
     inkscape:pageopacity="0.0"
     inkscape:pagecheckerboard="0"
     inkscape:deskcolor="#d1d1d1"
     inkscape:document-units="mm"
     inkscape:zoom="0.91846942"
     inkscape:cx="396.31151"
     inkscape:cy="1171.5142"
     inkscape:window-width="1916"
     inkscape:window-height="2041"
     inkscape:window-x="1911"
     inkscape:window-y="0"
     inkscape:window-maximized="0"
     inkscape:current-layer="layer1">
     ';
   for my $p (0 .. $lastpage) {
      my $Xp;
      if ($side=~/Back/) {
         $Xp=$lastpage-$p; 
      } else {
         $Xp=$p;
      }
      my $page_pos=($BORDER_H+$P_H)*$Xp;
      $out .= '<inkscape:page
       x="0"
       y="'.$page_pos.'"
       width="'.$P_W.'"
       height="'.$P_H.'"
       id="page1"
       margin="0"
       bleed="0" />';
   }
   $out.="</sodipodi:namedview></svg>";

   print $FH $out;
   close $FH;

   unshift(@file_list,$svg_name);

   #system('"C:\Program Files\Inkscape\bin\inkscape.exe" -b white --export-type="png" "'.$dir."\"\\$svg_name");
   
   if(0) {
   print('FORK: "C:\Program Files\Inkscape\bin\inkscape.exe" -b white --export-type="pdf" "'.$dir."/$svg_name\"");
   
   print $FH $out;
   close $FH;
   if (my $pid = fork) {
      unshift(@bg_pid, $pid);
   } else {
      exec('"C:\Program Files\Inkscape\bin\inkscape.exe" -b white --export-type="pdf" "'.$dir."/$svg_name\"");
   }
   }


  
}

sub export {
   my $f = shift;
}

sub printBadge {
   my ($text, $bn, $type, $side) = @_;
          $b=$text;
          $b=~s/All Days/$type/gi;
          if (length($bn)>12) {
            my($first, $rest) = split(/ /, $bn, 2);
            $b=~s/Badge Name L1/$first/gi;
            $b=~s/Badge Name L2/$rest/gi;
            $b=~s/Badge Name//gi;
          } else {
			#if (length($bn) > 0) {
				$b=~s/Badge Name L[0-9]//gi;
				$b=~s/Badge Name/$bn/gi;
			#} else {
			if (length($bn) > 0 or $side eq "Back" ) {
				$b=~s/0.112/0/g;
			} else {
				$b=~s/0.112/0.95/g;
			}
          }
		  $b=~s/0.112/0/g;
          write_SVG($b);
}

for $side ("","Back") {
   #my $rawtext = read_file("Badge$side.svg");
   #my $text;
   my $text = read_file("BadgeBack.svg");
   if ($side eq "Back") {
      $text=~s/0.666/1/g;
	  $text=~s/0.333/0/g;
   } else {
      $text=~s/0.333/1/g;
      $text=~s/0.666/0/g;
   }

   $text=~s/^<[?].*[?]>//;

   my $noname=$text;
   $noname=~s/Badge Name( L[0-9])?//gi;
   if ($side eq "Back") {
       $noname=~s/0[.]112/0/g;
   } else {
	   $noname=~s/0[.]112/0.9/g;
   }

   my $g="";
   if ($batch[0] eq "Guardian") {
      $g="Guardian";
      $noname=~s/ALL DAYS/GUARDIAN/gi;
   }

   print("g: $g\n;");

   my $f="_P$g$side.svg";
   open_SVG("$f");

   if (!($batch[0] eq "Guardian")) {

      $g="Guardian";
   }


	my $id=0;

  
   for my $L (@{ $aoh }) {
   #### my $L="";
   #### if (0 == 1) {
	  if ($L->{"Category"} ne "Membership") {
		  next;
	  };
	  $id+=1;
	  my $modifiers = $L->{"Modifiers Applied"};
	  my $bn = "";
	  print("---------------\n");
	  if ($modifiers =~ /Name of Guest: ([^,]*)/) {
		$bn = $1;
	  }
	  print("$bn\n");
	  if ($modifiers =~ /Badge Name Preferred: ([^,]*)/) {
		$bn = $1;
	  }
	  print("$bn\n");
	  #next;
	  
      #my $bn = $L->{"Badge Name"};
      my $type = $L->{"Item"};
	  
	  if ($type eq "2025 - GenghisCon Membership") {
		  $type = $L->{"Price Point Name"} ;
	  }
	  
      #my $id = $L->{"ID"};
      #my $id = $L->{"Ticket Number"};
      #$id=~s/Ticket //g;
      #$id+=0;


      $max_id = $id > $max_id ? $id : $max_id;
      
	  $type=~s/2025 - //;
      #$type=~s/[(](EFTPOS|CASH)[)]//;
      $type=~s/[(].*[)]//;
      $type=~s/Traders/Trader/;
      $type=~s/^Swancon Special.*/Standard - All Days/;
      $type=~s/^Fans Funding Fans.*/Standard - All Days/;
      $bn=~s/John McCabe-Dansted/John.CMD/g;

      #HACKS

      if ($bn=~/Cathy Cogan/i){
         $type=~s/.* - .*//i;
      }
      $bn=~s/Miranda Harvey/Demelza Carlton/g;

      #print "$type\t$bn\n";
      #if ($type=~ /^(Trader|Standard|Concession|Guardian)/i) {
      #if ($type=~ /^(Standard|Concession|Guardian)/) {
          $type=~s/(Standard|Concession) - //;
          $type=~s/ of G.*//i;
		  $type=~s/ Membership//i;
		  $type=~s/Guardian/GUARDIAN/i;         		  
          $bn=~s/Yarden Bartram/Azra/;
          print "$type\t$bn\n";

          if (!($type =~ /Guardian/i) eq !($batch[0] eq "Guardian") ) {
            printBadge($text,$bn,$type,$side);
		
            #write_SVG($b);
          }
          #print("if (!($type =~ /Guardian/) eq !($batch[0] == \"Guardian\")\n");
      #}
      #printBadge($text,Swancon 1,"Trader");

   }

   
   if (!$GuardianBatch) {
      printBadge($text,"Swancon 1","Trader",$side);
      printBadge($text,"Swancon 2","Trader",$side);
   }

   while($cW+$cH>0) {   
      write_SVG($noname);
   }
   close_SVG();


   $f="_COMMITTEE_$side.svg";
   open_SVG("$f");

   my $ctext=$text;
   $ctext=~s/FinalBlack4k.png/GrantStone4k.png/;
   #### if ( 0 == 1 ) {
   if ($GuardianBatch) {
      for my $m ("Wez", "John.CMD", "Alex", "Lexi", "Curzon", "Ken", "Mel", "Azra") { 
         printBadge($ctext,$m,"Committee",$side);
      }
	  for my $m ("Catherine Walker", "Natasha Hurley-Walker", "Adam McCaw", "Giorgia Santacaterina", "Grant Stone") { 
         printBadge($ctext,$m,"Guest",$side);
      }
	  for my $m ("Katrina Hennessy", "Kaneda", "Neil Gibson", "Alicia Smith", "Kitty Byrne-Hemsley", "Aaron Creaser", "Matt McKail", "Michael Cogan", "Desiree Heald", "Megan Sutton", "Ruth Turner", "Carol Ryles", "Jasper Greenhill", "Tim Yates", "Beth Creed") {
         printBadge($ctext,$m,"Panellist",$side);
      }
	   for my $m ( "Victoria Harbron", "Sam Ara", "Andreq Shackleton" ) {
		            printBadge($ctext,$m,"Minion",$side);
      }
   }

   close_SVG();
   
   # for my $type ("Weekend", "Thursday", "Friday", "Saturday", "Panellist") {
   for my $type (@batch) {
      my $ns=$type;
      $ns=~s/ //g;
      $f="_$ns$side.svg";
      open_SVG($f);
      my $t=$noname;
      $t=~s/All Days/$type/gi;
      for my $i (1 .. $Nup) {
         write_SVG($t);
      }
      close_SVG();

   }
}

print("Waiting to de-fork.\n");

for my $pid (@bg_pid) {
   print "Waiting for $pid\n";
   waitpid($pid,0)
}

append_file('id_log.txt', "$max_id".$batch[0]);

for my $f (sort @file_list) {
   system('"C:\Program Files\Inkscape\bin\inkscape.exe" -b white --export-type="pdf" "'.$dir."/$f\"");
   my $fpdf=$f;
   $fpdf=~s/svg$/pdf/;
   open_default_browser($fpdf);
}


print "FINISHED\n" ; 
exit;


####
my $a = "Ticket 123";
$a=~ s/Ticket //;
print "$a+0\n";
print $a+0;
print "\n";
exit;
