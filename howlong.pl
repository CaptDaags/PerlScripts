# This file returns the length of the string in the double quotes in the length function
my $stringtomeasure;
print "Enter the string to measure:";
$stringtomeasure = <STDIN>;
chomp($stringtomeasure);
print("Length of the string is ".length($stringtomeasure)."\n");

