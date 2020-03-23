#!/usr/bin/perl
use LWP::Simple;

$PP="http://policja.pl/pol/form/1,Informacja-dzienna.html";
$PPBase="pp.csv";

$content = get("$PP");

$content =~ s/\r//g; # dla pewności usuń

@content = split (/\n/, $content);

foreach (@content) { chomp();
  unless ($_ =~ m/data-label=/ ) { next }

  if ($_ =~ m/Data statystyki/ ) { $d = clean($_); }
  elsif ($_ =~ m/Interwencje/ )  { $i = clean($_); }
  elsif ($_ =~ m/Zatrzymani na g/ ) { $zg = clean($_); }
  elsif ($_ =~ m/Zatrzymani p/ ) { $zp = clean($_); }
  elsif ($_ =~ m/Zatrzymani n/ ) { $zn = clean($_); }
  elsif ($_ =~ m/Wypadki d/ ) { $w = clean($_);  }
  elsif ($_ =~ m/Zabici/ )  { $z = clean($_);  }
  elsif ($_ =~ m/Ranni/ ) { $r = clean($_);
    $l = "$d;$i;$zg;$zp;$zn;$w;$z;$r";
    $PP1{"$d"} = $l;
    last;
 }
}

### read the database
open (PP, "<$PPBase") || die "cannot open $PPBase/r!\n" ;

while (<PP>) { chomp(); $line = $_; @tmp = split /;/, $line; }

close(PP);

### append the database (if new record)
open (PP, ">>$PPBase") || die "cannot open $PPBase/w!\n" ;

unless (exists ($PP1{"$tmp[0]"})) { print PP "$line\n" }

close(PP);


sub clean  {
 my $s = shift;
 $s =~ s/<[^<>]*>//g;
 $s =~ s/<[ \t]>//g;

 return ($s);


}
