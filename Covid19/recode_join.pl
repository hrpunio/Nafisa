%C2Iso = (
'Italy' => 'IT' , 
'Germany' => 'DE',
'Spain' => 'ES',
'United Kingdom' => 'UK', 
'France' => 'FR', 
'Danmark' => 'DK', 
'Sweden' => 'SE',
'Poland' => 'PL',
'Czech Republic' =>'CZ', 
'Slovakia' => 'SK', 
'Hungary' => 'HU', 
'Romania' => 'RO',
'Bulgaria' => 'BG',
'Greece' => 'EL');

print "date;location;newc;newd;totalc;totald;temp;id;date.date;id.id;country;newc.ue;newd.ue;totalc.ue;totald.ue\n";

open (UE, "covid19_C.csv");
## date;id;country;newc;newd;totalc;totald
while (<UE>) { chomp();
  ($t0, $t1, $t2, $t3, $t4, $t5, $t6) = split /;/, $_;
  if (exists $C2Iso{$t1} ) { $iso = $C2Iso{$t1} } else {$iso ='Na'}
  $CC{$t0}{$t1} = "$_";
  ##print STDERR "$t0/$t1\n";
}

close(UE);


while (<>) { chomp();
  if (/new_deaths/) {next}
  ($t0, $t1, $t2, $t3, $t4, $t5, $t6) = split /,/, $_;
  ##print STDERR "$t0==$t1\n";
  if (exists $C2Iso{$t1} ) { $iso = $C2Iso{$t1} } else {$iso ='Na'}
  if ( exists($CC{$t0}{$iso})) { $post = "$CC{$t0}{$iso}" } else {$post = ';;;;;;'; }
  print "$t0;$t1;$t2;$t3;$t4;$t5;$t6;$iso;$post\n";
}
