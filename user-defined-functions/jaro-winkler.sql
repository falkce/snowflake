CREATE OR REPLACE FUNCTION PUBLIC.JaroWinkler(S1 VARCHAR, S2 VARCHAR)
  RETURNS FLOAT
  LANGUAGE JAVASCRIPT
COMMENT = 'JaroWinkler Distance Calculation.'
AS
$$ 
try {
	if (S1 == null || S2 == null) {
		return null;
	} 
	else 
	{     var m = 0;        // Exit early if either are empty.
        if ( S1.length === 0 || S2.length === 0 ) {
            return 0;
        }
        // Exit early if they're an exact match.
        if ( S1 === S2 ) {
            return 1;
        }
		var range     = (Math.floor(Math.max(S1.length, S2.length) / 2)) - 1,
            S1Matches = new Array(S1.length),
            S2Matches = new Array(S2.length);
        for ( i = 0; i < S1.length; i++ ) {
            var low  = (i >= range) ? i - range : 0,
                high = (i + range <= S2.length) ? (i + range) : (S2.length - 1);
            for ( j = low; j <= high; j++ ) {
            if ( S1Matches[i] !== true && S2Matches[j] !== true && S1[i] === S2[j] ) {
                ++m;
                S1Matches[i] = S2Matches[j] = true;
                break;
            }
            }
        }
        // Exit early if no matches were found.
        if ( m === 0 ) {
            return 0;
        }
        // Count the transpositions.
        var k = n_trans = 0;
        for ( i = 0; i < S1.length; i++ ) {
            if ( S1Matches[i] === true ) {
            for ( j = k; j < S2.length; j++ ) {
                if ( S2Matches[j] === true ) {
                k = j + 1;
                break;
                }
            }
            if ( S1[i] !== S2[j] ) {
                ++n_trans;
            }
            }
        }
        var weight = (m / S1.length + m / S2.length + (m - (n_trans / 2)) / m) / 3,
            l      = 0,
            p      = 0.1;
        if ( weight > 0.7 ) {
            while ( S1[l] === S2[l] && l < 4 ) {
            ++l;
            }
            weight = weight + l * p * (1 - weight);
        }
        return weight;
	}
}
catch (err) {
 	return "ERROR: " + err;
}
$$ 
;