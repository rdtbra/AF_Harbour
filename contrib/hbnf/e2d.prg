/*
 * $Id: e2d.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: e2d.prg
 * Author....: Gary Baren
 * CIS ID....: 75470,1027
 *
 * This is an original work by Gary Baren and is hereby placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.2   15 Aug 1991 23:03:28   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:51:40   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   07 Jun 1991 23:03:32   GLENN
 * Initial revision.
 *
 */

#ifdef FT_TEST
  function main( sNumE )
     return qout( FT_E2D( sNumE ) )
#endif

function ft_e2d( sNumE )
  local nMant, nExp

  nMant := val( left( sNumE, at( 'E', sNumE ) - 1 ) )
  nExp  := val(substr( sNumE,                    ;
                 at( 'E', sNumE ) + 1,           ;
                 len( sNumE ) - at( 'E', sNumE ) ;
                     )                           ;
              )
  return nMant * 10 ^ nExp
