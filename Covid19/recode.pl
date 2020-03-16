%C2Iso = (
'Italy' => 'ITw' , 
'Germany' => 'DEw',
'Spain' => 'ESw',
'United Kingdom' => 'UKw', 
'France' => 'FRw', 
'Danmark' => 'DKw', 
'Sweden' => 'SEw',
'Poland' => 'PLw',
'Czech Republic' =>'CZw', 
'Slovakia' => 'SKw', 
'Hungary' => 'HUw', 
'Romania' => 'ROw',
'Bulgaria' => 'BGw',
'Greece' => 'ELw');

print "date;id;country;newc;newd;totalc;totald\n";

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
  ($t0, $t1, $t2, $t3, $t4, $t5) = split /,/, $_;
  ##print STDERR "$t0==$t1\n";
  if (exists $C2Iso{$t1} ) { $iso = $C2Iso{$t1} } else {$iso ='Na'}
  print "$t0;$iso;$t1;$t2;$t3;$t4;$t5\n";
}
