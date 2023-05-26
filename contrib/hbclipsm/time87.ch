/*
 * $Id: time87.ch 2941 2000-05-31 21:47:19Z vszel $
 */

#translate Days( <nSeconds> )    => SecondsAsDays( <nSeconds> )
#translate AmPm( <cTime> )       => TimeAsAMPM( <cTime> )
#translate Secs( <cTime> )       => TimeAsSeconds( <cTime> )
#translate TString( <nSeconds> ) => TimeAsString( <nSeconds> )
#translate Elaptime( <cStartTime>, <cEndTime> ) => TimeDiff( <cStartTime>, <cEndTime> )
#translate ValidTime( <cTime> )  => TimeIsValid( <cTime> )
