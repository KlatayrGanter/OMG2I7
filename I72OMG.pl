use warnings;
use strict;
# (C) GPL v3, by Klatayr Ganter, 2017

my $start = shift // 0;
$start =~ s/^([0-9]+)-([0-9]+)$/$1/;
my $end = $2 // 0xffffffff;

my $in_func = 0;

my $S = qr/(\s+)/;
my $W = qr/\s*(?:the\s+)?+(\b(?:\w+[-\s]+)*?\w+\b)\s*?/;
my $e = qr/((?:\s*|\[[^]]*\])*)$/;
my $IMO = qr/^To\s+decide\s+/;
my $is = qr/\s*\b[Ii]s\s+/;
my $of = qr/\s*\b[Oo]f\s+/;
my $and = qr/\s*\b[Aa]nd\s+/;
my $or = qr/\s*\b[Oo]r\s+/;
my $if = qr/\s*\b[Ii]f\s+/;

while (<>) {
    s/[\r\n]+$//;
    if ($. >= $start and $. <= $end) {
        if (/$IMO/) {
            s/$IMO\bwhich\s+list\s+of\s+$W$is([^:]+?):$e/IMO $2 = 4 $1:$3\n/;
            s/$IMO\bwhich\s+$W$is([^:]+?):$e/IMO $2 = $1:$3\n/;
            s/$IMO\bwhether\s+([^:]+?):$e/IMO $1 If:$3\n/;
            $in_func=1;
        } elsif (/^\s*$/) {
            $in_func = 0;
        } else {
            s/${S}\bRepeat\s+with${W}running\s+through(?:\s+the)?\b${W}:/${1}4 $2 \@$3:\n/;
            s/($and|$or|$if)$W${is}listed\s+in\s$W/$1$2 =\@ $3/;
            s/\bDecide\s+on$W/GA $1;/;
            s/\bDecide\s+(yes|no)\s*;/GA $1;/;
            s/$is/ = /g;
            s/$of/ o /g;
            s/$and/ \& /g;
            s/$or/ \/ /g;
        }
    }
    print $_, "\n";
}
