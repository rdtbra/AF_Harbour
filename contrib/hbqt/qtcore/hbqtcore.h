/*
 * $Id: hbqtcore.h 16683 2011-04-27 10:00:24Z vszakats $
 */

#ifndef __HBQTCORE_H
#define __HBQTCORE_H

#include "hbqt.h"

HB_EXTERN_BEGIN

extern HB_EXPORT HBQT_GC_FUNC( hbqt_gcRelease_HBQEvents );
extern HB_EXPORT HBQT_GC_FUNC( hbqt_gcRelease_HBQSlots );
extern HB_EXPORT HBQT_GC_FUNC( hbqt_gcRelease_HBQString );

extern HB_EXPORT void * hbqt_gcAllocate_HBQEvents( void * pObj, bool bNew );
extern HB_EXPORT void * hbqt_gcAllocate_HBQSlots( void * pObj, bool bNew );
extern HB_EXPORT void * hbqt_gcAllocate_HBQString( void * pObj, bool bNew );

HB_EXTERN_END

#define hbqt_par_HBQEvents( n )                                 ( ( HBQEvents                                   * ) hbqt_par_ptr( n ) )
#define hbqt_par_HBQSlots( n )                                  ( ( HBQSlots                                    * ) hbqt_par_ptr( n ) )
#define hbqt_par_HBQString( n )                                 ( ( HBQString                                   * ) hbqt_par_ptr( n ) )

#define HBQT_TYPE_QSize                                         ( ( HB_U32 ) 0xD1575132 )

#endif /* __HBQTCORE_H */
