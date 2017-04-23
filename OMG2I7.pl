use warnings;
use strict;
# (C) GPL v3, by Klatayr Ganter, 2017

my $in_func = 0;


my $S = qr/(\s+)/;
my $W = qr/\s*(\b(?:\w+[-\s]+)*?\w+\b)\s*?/;
my $e = qr/((?:\s*|\[[^]]*\])*)$/;
my $to = qr/\s*(?:\b(?:2|to)(?![\w-])|-\>)(?:\s*the\b)?\s*/;
my $of = qr/\s*(?:\b(?:4|of?)(?![\w-])|\<-|'?\b[Oo]\b)(?:\s+the\b)?\s*/;
my $if = qr/\s*(?:\b(?:[Ii][FfCc])(?![\w-])|\?)(?:\s+the\b)?\s*/;
my $else = qr/\s*(?:-|\b[Ee](?:lse|LSE)\b|[Oo]\/?[Ww]\b)\s*/;
my $at = qr/\s*(?:\b[Aa][Tt]\b|\@)\s*/;
my $wrt = qr/\s*\b(?:WRT|4)\b\s*/;

my $so = qr/(?:\~|\=\s*SO\s+4\b)/;
my $is = qr/\s*(?:=|:\s*(?=[^\[\s])|\b[Ii][Ss]\b)\s*/;
my $next = qr/\s*\b(?:BRB|[Nn]ext)\b\s*/;
my $ob = qr/\s*(?:\bOB\b|-)\s*/;
my $IMO = qr/^IM(?:NS)?H?O\s+/;

while (<>) {
    if (/$IMO/) {
        s/$IMO(.*?)$is$wrt([^:=)]+?):$e/IMO WRT $2 is $1:$3/;
        s/$IMO(.*?)$is([^:=)]+?):$e/IMO $2 is $1:$3/;
        s/$IMO(.*?)$if:$e/To decide whether $1:$2/;
        s/$IMO$wrt$W$is/To decide which list of $1 is /;
        s/$IMO$W$is/To decide which $1 is /;
        s/$IMO/To decide whether /;
        s/$wrt/ a list of /;
        $in_func = 1;
    } elsif ($in_func) {
        next if /^\s*$/;
        if (/^\S/) {
            $in_func = 0;
            print "\n";
        } else {

            s/^$S(?:AFAI(?:K|C[STK])[:,]?|\$)$W$so$W$to$W;/$1Let $2 be a various-to-one relation of $3 to $4;/;
            s/^$S$if$W$so$W$to$W([:&|])/${1}If the $3 relates to $4 by the $2$5/;

            s/^$S*((?:FYI[:,]?|BTW[:,]?|\$)${W}[:=])$W$of$W~$W;/$1$2 $4 to which the $6 relates by the $5;/;

            s/^$S(?:BTW[:,]?|\$)$W$so$W$to$W;/$1Now the $2 relates $3 to $4;/;

            s/^$S(?:FYI[:,]?|\$)$W$is\s*/$1Let the $2 be the /;
            s/^$S(?:BTW[:,]?|\$)$W=\s*/$1Now the $2 is the /;

            s/^${S}$wrt$W$at/$1Repeat with $2 running through the /;
            s/^$S$W-$at$W;/$1Remove the $2 from the $3, if present;/;
            s/^$S$W-$at$W;/$1Remove the $2 from the $3;/;

            s/^$S(BRB|[Nn]ext|^-+)$if([^;]+?);$e/$1$2$3, Next;$4/;
            s/^$S(CU|[Bb]reak|v-+)$if([^;]+?);$e/$1$2$3, Break;$4/;
            s/(?:\s*,)?\s*-+\^$e/, Next;$1/;
            s/(?:\s*,)?\s*-+v$e/, Break;$1/;
            s/\bGA\s+([Yy]es|[Nn]o)\s*;/Decide $1;/;
            s/\bGA\s+$W;/Decide on $1;/;
            s/^${S}GA[:,]?\s*([^;]+?)(?:,\s*EOD)?;$e/$1Decide on $2;$3/;

            s/^$S$if\s*/$1If /;
            s/^$S$else\?/$1Else If /;
            s/^$S$else:/$1Else:/;

            s/\s*(?<![=:])$wrt$W$of$W/ the list of $1 which the $2 relates to/;
            s/$wrt/ the list of /;


            s/\ba ([aeioAEIO]|hour|honour|honest|heir)/an $1/g; # correct indefinite article

            s/(?<=[\w}])$to(?=[\w}])/ to /g;
            s/(?<=[\w}])$of(?=[\w}])/ of the /g;
            s/\s*\<-\s*/ of the /g;
            s/\s*\->\s*/ to the /g;
            s/\s*[\/|]\s*/ or the /g; # <= FIXME division?
            s/\s*&\s*/ and the /g;
            s/\s*\>\s*/ is greater than the /g;
            s/$is$at/ is listed in the /g;
            s/\s*(?:=|:\s*(?=[^\[\s]))\s*/ is /g;
        }
    }
    print $_;
}

