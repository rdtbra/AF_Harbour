/*
 * $Id: scancode.prg 16754 2011-05-11 16:05:43Z vszakats $
 */

/*
 * File......: scancode.prg
 * Author....: Glenn Scott (from John Kaster)
 * CIS ID....: 71620,1521
 *
 * This is an original work by Glenn Scott and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.3   15 Aug 1991 23:04:32   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.2   14 Jun 1991 19:52:52   GLENN
 * Minor edit to file header
 *
 *    Rev 1.1   12 Jun 1991 02:30:32   GLENN
 * Documentation mod and check for ft_int86() compatibility
 *
 *    Rev 1.0   01 Apr 1991 01:02:12   GLENN
 * Nanforum Toolkit
 *
 */

#include "ftint86.ch"

#define KEYB       22

#ifdef FT_TEST

  #DEFINE SCANCODE_ESCAPE   (chr(27) + chr(1))

  FUNCTION main()
     LOCAL getlist, cKey
     CLEAR
     QOut("Press any key, ESCape to exit:")

     while .t.
        cKey := FT_SCANCODE()
        QOUT( "chr(" + str(asc(substr(cKey,1,1)),3) + ")+chr(" + str(asc(substr(cKey,2,1)),3) + ")" )
        if cKey == SCANCODE_ESCAPE
           exit
        endif
     end
  RETURN nil

#endif

FUNCTION FT_SCANCODE()
  LOCAL aRegs[ INT86_MAX_REGS ]

  aRegs[ AX ] := MAKEHI( 0 )
  FT_INT86( KEYB, aRegs )
  RETURN chr(LOWBYTE( aRegs[AX] )) + chr(HIGHBYTE( aRegs[AX] ))
