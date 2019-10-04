#!/usr/bin/perl
$output = `which ss` ? `ss -nltp | tail -n +2` : `netstat -nltp | tail -n +3`;
for (split("\n", $output)) {
($port, $service) = $_ =~ m/:([0-9]+) [\w:.*()\[\]çÇ ]+"?\/?([\w\-.]*)"?/g;
$services{$port} = '{"{#SERVNAME}" : "'.$service.'","{#SERVPORT}" : "'.$port.'"}';
}
print '{"data":['. join(',', values(%services)) .']}';
