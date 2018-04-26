#!/usr/bin/perl

$bannerline = "##########################################################";

print "$bannerline\n";
print "              BIRD Neighbor Config Tool\n\n";
print "        WARNING! This script must be run as root!\n";
print "       If not run as root the final step will fail!\n";
print "$bannerline\n\n";


print "Please enter the name of the new member. This will be used to create the config snippet and identify the member. ";
$line = <STDIN>;
$cname = "";
$ip = "";
$asn = "";
$template = "";

while($line eq "\n"){
	print "Not a valid name, please enter a non empty name: ";
	$line = <STDIN>;
}
chomp($line);
$_ = $line;
s/ /_/g;
$cname = $_;

print "Please enter the name of the tempalte to follow. Please note that spaces will be removed! ";
$_ = <STDIN>;
while($_ eq "\n"){
	print "Please enter a non empty template name: ";
	$_ = <STDIN>;
}
chomp($_);
s/ //g;
$template = $_;

print "Please enter the ip for the peering interface of the host. ";
$line = <STDIN>;
while($line eq "\n"){
	print "Not a valid IP, please enter a non empty address: ";
	$line = <STDIN>;
}
chomp($line);
$_ = $line;
while(not m/[0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}/g){
	print "Not a valid IP, please enter a valid IP: ";
	$line = <STDIN>;
	chomp($line);
	$_ = $line;
}
$ip = $_;
print "Please enter the 2 byte AS number for the new router: ";
$line = <STDIN>;
while($line eq "\n"){
	print "Not a valid ASN, please enter a non empty ASN: ";
	$line = <STDIN>;
}
chomp($line);
$_ = $line;
while((not m/[0-9]{1,10}/g) || ($_ > 4294967295)){
	print "Not a valid 4 byte ASN. Please enter a valid ASN: ";
	$_ = <STDIN>;
	chomp($_);
}
chomp($_);
$asn = $_;

$config = "protocol bgp $cname from $template { \n    neighbor $ip as $asn; \n}\n";
print "The config: \n$config\n";

$fname = "$cname.conf";
$filetest = open FTEST, "</etc/bird_config/$fname";
if($filetest){
	print "The config file for this host already exists!\n";
}
else {
	print "Creating new host...\n";
	$filewrite = open FWRITE, ">>/etc/bird_config/$fname";
	if($filewrite){
		print "New file created\n";
		print FWRITE "$config";
		print "Added config\n";
		print "Done.\n";
	}
	else {
		print "Something went wrong and we can't create the config!\n";
	}
	close FWRITE;
}
close FTEST;

