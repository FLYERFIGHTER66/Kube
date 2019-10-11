      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- PUR220
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- TRUCK SCHEDULE INQUIRY   (CALLED)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FPUR220FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFPUHDRHR  IF   E           K DISK
      *
      *
      ** MESSAGE ARRAY
     D MSG             S             30    DIM(10) CTDATA PERRCD(1)             MESSAGE
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   PARMS      *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    WKDATE            6 0
     C                   PARM                    TRUCK             4
     C                   PARM                    ROUT              2
     C     WKDATE        IFGT      0
      ** GET TO MONDAY
     C                   Z-ADD     WKDATE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
      ** CHECK FOR MONDAY
     C     #Y            IFNE      1
     C     #Y            SUB       1             Y                 2 0
     C                   SUB       Y             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         WKDATE
     C                   END
     C                   GOTO      DATOK
     C                   END
     C                   SETOFF                                       1011
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KC
     COR KG              DO
     C                   MOVE      *BLANKS       TRUCK
     C                   MOVE      *BLANKS       ROUT
     C                   GOTO      END
     C                   END
     C                   SETOFF                                       1011
      ** COME HERE ON CALL TO CHECK DATE
     C     DATOK         TAG
     C                   Z-ADD     WKDATE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
      ** CHECK FOR MONDAY
     C     #Y            IFNE      1
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     ##CYMD        BGCYMD            7 0
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ENCYMD            7 0
      ** CHECK IF ANY SCHEDULED
     C     BGCYMD        SETLL     FPUHDRHR
     C                   READ      FPUHDRHR                               90
     C  N90              DO
     C     THSHDT        IFGT      ENCYMD
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
     C                   ENDDO
     C   90              DO
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDDO
      ** IF HERE THERE ARE RECORDS FOR SELECTED WEEK
     C                   EXSR      BLDSFL
     C     NXTFMT        TAG
     C                   EXFMT     RECCTL
     C   KC
     COR KG              DO
     C                   MOVE      *BLANKS       TRUCK
     C                   MOVE      *BLANKS       ROUT
     C                   GOTO      END
     C                   END
      ** CHECK FOR LINE
     C     LINE          IFGT      0
     C     LINE          CHAIN     RECSFL                             91
     C   91              GOTO      NXTFMT
     C                   MOVEL     THTRK#        TRUCK
     C                   MOVEL     THROUT        ROUT
     C                   Z-ADD     DATE          WKDATE
     C                   GOTO      END
     C                   END
     C                   GOTO      NXTFMT
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      **   BUILD SUB FILE  **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   SETOFF                                       2526
     C     BGCYMD        SETLL     FPUHDRHR
     C     NXTBLD        TAG
     C                   READ      FPUHDRHR                               90
     C  N90              DO
     C     THSHDT        IFLE      ENCYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    THSHDT            7 0          DATE CYYMMDD
     C                   PARM                    DATE                           DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    THSHDT                         DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C                   MOVEL     MSG(#Y)       DAY
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTBLD
     C                   ENDIF
     C     RECNO         IFGT      16
     C                   SETON                                        25
     C                   END
     C                   ENDDO
     C                   MOVE      *BLANKS       THTRK#
     C                   MOVE      *BLANKS       THDRIV
     C                   MOVE      *BLANKS       THSTOP
     C                   MOVE      *BLANKS       THROUT
     C                   MOVE      *BLANKS       THCOMM
     C                   MOVE      *BLANKS       DAY
     C                   Z-ADD     0             DATE
     C                   MOVEL     MSG(8)        THCOMM
     C                   SETON                                        26
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
**  message
Monday
Tuesday
Wednesday
Thursday
Friday
Saturday
Sunday
     *** End of Data ***
