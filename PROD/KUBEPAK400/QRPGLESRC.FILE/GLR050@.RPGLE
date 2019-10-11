      *--------------------------------------------------------------     GLR050
      *                                                                   GLR050
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999                          GLR050
      *                                                                   GLR050
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         GLR050
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE         GLR050
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      GLR050
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         GLR050
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      GLR050
      *       BY EXPRESS WRITTEN PERMISSION OF                            GLR050
      *            EFD ENTERPRISES, INC.     215-643-5352                 GLR050
      *                                                                   GLR050
      *--------------------------------------------------------------     GLR050
      **PROGRAM NAME-        GLR050                                       GLR050
      **COMPANY-             EFD ENTERPRISES, INC.                        GLR050
      **SYSTEM-              GLAPPR                                       GLR050
      **DESCRIPTION-         THIS PROGRAM SUPPORTS FORMAT FILE            GLR050
      **                     MAINTENANCE                                  GLR050
      *                                                                   GLR050
      * CHANGE LOG:                                                       GLR050
      *                                                                   GLR050
      *                                                                   GLR050
     FGLR050FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFGLREF    UF A E           K DISK
     FFGLFMH    UF A E           K DISK
     FFGLFMI    IF   E           K DISK
     FFMGLCH    UF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFGLCTL    IF   E           K DISK
      *                                                                   GLR050
      *                                                                   GLR050
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
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0                                      ARC380
      *                                                                   GLR050
      ******   MAIN LOGIC                                                 GLR050
      *                                                                   GLR050
     C                   TIME                    TIMOD             6 0                         GLR05
      *                                                                   GLR050
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       101112
     C                   SETOFF                                       202122
     C                   SETOFF                                       239045
     C                   SETOFF                                       1695
      *
     C   KC                                                                                    GLR05
     COR KG              GOTO      END                                                         GLR05
      *
     C                   MOVEL     VREF          TST1              1
     C     TST1          IFEQ      '?'                                                         GLC15
     C     TST1          OREQ      '/'                                                         GLC15
     C                   MOVEL     *BLANKS       GXLOOK           15
     C                   CALL      'LKGLRF'
     C                   PARM                    GXLOOK           15
     C                   PARM                    GXRPRT            8
     C                   MOVEL     *BLANKS       VREF
     C                   MOVEL     GXRPRT        VREF
     C                   MOVEL     GXLOOK        VDESC
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   ENDIF
      *
      *****TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      NXTA
     C     VACTOK        TAG
      *
     C     VREF          IFEQ      *BLANKS
     C                   SETON                                        12
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VREF          IFGT      *BLANKS                                                     GLC15
     C                   MOVEL     *BLANKS       GXLOOK
     C     KEY23         KLIST                                                                 GLC15
     C                   KFLD                    GXLOOK                                        GLC15
     C                   KFLD                    VCO                                           GLC15
     C                   KFLD                    VREF                                          GLC15
     C     KEY23         CHAIN     FGLREF                             90                       GLC15
     C   90              SETON                                        12
     C   12              GOTO      NXTA
     C                   ENDIF
      *
     C     VGROUP        IFEQ      *ZEROS                                                   K
     C                   SETON                                        13
     C   13              GOTO      NXTA
     C                   ENDIF
      *
     C     VCO           CHAIN     FMCOMP                             90
     C   90              SETON                                        11
     C   11              GOTO      NXTA
      *
     C*?????????DELETE REPORT
      *                                                                   GLR050
     C   02              EXSR      SCRNB                                                       GLR05
      *                                                                   GLR050
     C   03              EXSR      SCRNC                                                       GLR05
      *                                                                   GLR050
     C   04              EXSR      SCRND                                                       GLR05
      *                                                                   GLR050
     C   05              EXSR      SCRNE                                                       GLR05
      *                                                                   GLR050
     C   06              EXSR      SCRNF                                                       GLR05
      *                                                                   GLR050
     C   07              EXSR      CLEAR                                                       GLR05
      *                                                                   GLR050
     C   80              EXCEPT                                                                GLR05
      *                                                                   GLR050
     C     END           TAG                                                                   GLR05
      *                                                                   GLR050
      *                                                                   GLR050
     C     SCRNA         BEGSR                                                                 GLR05
     C                   SETOFF                                       202122                   GLR05
     C                   SETOFF                                       232425                   GLR05
     C                   SETOFF                                       2699                     GLR05
     C                   SETOFF                                       1718                     GLR05
     C                   SETOFF                                       717273                   GLR05
     C                   SETOFF                                       7475                     GLR05
     C                   SETOFF                                       4142                     GLR05
     C                   SETON                                        34                       GLR05
      *                                                                   GLR050
     C   71                                                                                    GLR05
     COR 72                                                                                    GLR05
     COR 75              SETON                                        4449                     GLR05
      ******   CHECK FOR VALID ACTION CODE                                GLR050
      *                                                                   GLR050
     C                   SETOFF                                       60                       GLR05
      ******   CHECK THAT EITHER REPORT REFERENCE OR ALPHA SEARCH ENTERED GLR050
      *                                                                   GLR050
     C                   MOVE      VCODE         SAVCOD            1                           GLR05
      *                                                                   GLR050
      ******   IF ALPHA SEARCH FIELD ENTERED, EXECUTE ALPHA SEARCH S/R    GLR050
      *                                                                   GLR050
     C   63
     CANN99              SETOFF                                       80                       GLR05
     C   63
     CANN99              MOVE      *BLANKS       LIMIT            25                           GLR05
     C   63
     CANN99              MOVEL     VSEARC        LIMIT                                         GLR05
     C   63
     CANN99              EXSR      ALPOUT                                                      GLR05
     C   63
     CANN99              GOTO      ESCRNA                                                      GLR05
      *                                                                   GLR050
      ******   CHECK THAT GROUP NUMBER IS POSITIVE NUMBER                 GLR050
      *                                                                   GLR050
     C                   SETOFF                                       6364                     GLR05
     C     VGROUP        COMP      0                                  636464                   GLR05
     C   64
     CANN99              MOVE      MSG(18)       ERR                                           GLR05
     C   64              SETON                                        992425                   GLR05
      *                                                                   GLR050
      ******   CHECK IF ACTION APPROPRIATE - IF NOT DISPLAY ERROR MSG     GLR050
      ******   DEFER CHECK FOR DELETE OR REACTIVATE UNTIL AFTER           GLR050
      ******   DECISION RE ENTIRE REPORT DELETE OR REACTIVATE             GLR050
      *                                                                   GLR050
     C                   MOVE      *BLANKS       HDRKEY           14                           GLR05
     C                   MOVE      *BLANKS       WK12             12                           GLR05
     C                   MOVEL     VREPRT        WK12                                          GLR05
     C                   MOVE      VGROUP        WK12                                          GLR05
     C                   MOVEL     VCOMP         HDRKEY                                        GLR05
     C                   MOVE      WK12          HDRKEY                                        GLR05
      *                                                                   GLR050
     C                   SETOFF                                       6566                     GLR05
     C     HDRKEY        CHAIN     ULFMH                              65                       GLR05
     C  N65UHSTAT        COMP      'D'                                    66                   GLR05
      *                                                                   GLR050
     C   65
     CAN 72
     CANN99              MOVE      MSG(5)        ERR                                           GLR05
     C   65
     CAN 72              SETON                                        9920                     GLR05
     C   65
     CAN 72              SETON                                        212426                   GLR05
      *                                                                   GLR050
     C   65
     CAN 73
     CANN99              MOVE      MSG(7)        ERR                                           GLR05
     C   65
     CAN 73              SETON                                        9920                     GLR05
     C   65
     CAN 73              SETON                                        212426                   GLR05
      *                                                                   GLR050
     C   65
     CAN 74
     CANN99              MOVE      MSG(6)        ERR                                           GLR05
     C   65
     CAN 74              SETON                                        9920                     GLR05
     C   65
     CAN 74              SETON                                        212426                   GLR05
      *                                                                   GLR050
     C   65
     CAN 75
     CANN99              MOVE      MSG(8)        ERR                                           GLR05
     C   65
     CAN 75              SETON                                        9920                     GLR05
     C   65
     CAN 75              SETON                                        212426                   GLR05
      *                                                                   GLR050
     C   66
     CAN 75
     CANN99              SETOFF                                       90                       GLR05
      *                                                                   GLR050
     C  N65
     CAN 71
     CANN99              MOVE      MSG(4)        ERR                                           GLR05
     C  N65
     CAN 71              SETON                                        9920                     GLR05
     C  N65
     CAN 71              SETON                                        212426                   GLR05
      *                                                                   GLR050
     C   66
     CAN 72
     CANN99              MOVE      MSG(9)        ERR                                           GLR05
     C   66
     CAN 72              SETON                                        9920                     GLR05
     C   66
     CAN 72              SETON                                        212426                   GLR05
      *                                                                   GLR050
     C   99              GOTO      ESCRNA                                                      GLR05
      *                                                                   GLR050
      ******   IF EVERYTHING OK, GO AHEAD TO SCREEN 'D'                   GLR050
      ******   (SCREEN 'C' WILL BE BYPASSED UNLESS IN ADD MODE.           GLR050
      ******    SCREEN 'C' FOR OTHER MODES CAN BE REACHED USING           GLR050
      ******    COMMAND KEY ON SCREEN 'D')                                GLR050
      *                                                                   GLR050
      ******   CHECK IF CROSS REFERENCE ALREADY EXISTS.                   GLR050
      ******   IF IN ADD MODE, DISPLAY SCREEN 'C' ONLY IF                 GLR050
      *****    CROSS REFERENCE RECORD DOES NOT EXIST.                     GLR050
      *                                                                   GLR050
     C                   MOVE      *BLANKS       XRFLIM           25                           GLR05
     C                   MOVE      *BLANKS       WK10             10                           GLR05
     C                   MOVEL     VCOMP         WK10                                          GLR05
     C                   MOVE      VREPRT        WK10                                          GLR05
     C                   MOVE      WK10          XRFLIM                                        GLR05
      *                                                                   GLR050
     C                   SETOFF                                       95                       GLR05
     C                   SETOFF                                       929394                   GLR05
      *                                                                   GLR050
     C     XRFLIM        SETLL     GLREF                                                       GLR05
     C     CLOOP         TAG                                                                   GLR05
     C                   SETOFF                                       65                       GLR05
     C                   READ      GLREF                                  65                   GLR05
     C   65              GOTO      CSKIP                                                       GLR05
     C     GXCOMP        COMP      VCOMP                                  95                   GLR05
     C   95GXRPRT        COMP      VREPRT                                 95                   GLR05
     C   95GXSTAT        COMP      'X'                                9595      BYPASS 'X' STATGLR05
      *                                                                   GLR050
      ******   IF CROSS REFERENCE RECORD EXISTS,                          GLR050
      ******   SAVE KEY FIELDS FROM GLREF                                 GLR050
      *                                                                   GLR050
     C   95              MOVE      GXLOOK        LOOKSV           15                           GLR05
     C   95              Z-ADD     GXRTYP        VRTYP             1 0                         GLR05
     C   95              Z-ADD     GXDPSQ        VDEPT             4 0                         GLR05
      *                                                                   GLR050
     C   95GXSTAT        COMP      'A'                                    92                   GLR05
     C   95GXSTAT        COMP      'D'                                    94                   GLR05
      *                                                                   GLR050
     C   95              GOTO      CSKIP                                                       GLR05
      *                                                                   GLR050
     C  N95              GOTO      CLOOP                                                       GLR05
      *                                                                   GLR050
     C     CSKIP         TAG                                                                   GLR05
      *                                                                   GLR050
     C   71              MOVEL     MSG(12)       VMODE            12                           GLR05
     C   72              MOVEL     MSG(13)       VMODE                                         GLR05
     C   73              MOVEL     MSG(14)       VMODE                                         GLR05
     C   74              MOVEL     MSG(15)       VMODE                                         GLR05
     C   75              MOVEL     MSG(16)       VMODE                                         GLR05
      *                                                                   GLR050
      ******   SET OFF SCREEN 'A' SWITCH 80                               GLR050
      *                                                                   GLR050
     C  N99              SETOFF                                       80        SCR A SW OFF   GLR05
      *                                                                   GLR050
     C   72              EXSR      LOADC                                                       GLR05
     C   72              EXSR      LOADD                                                       GLR05
      *                                                                   GLR050
     C   71                                                                                    GLR05
     COR 72                                                                                    GLR05
     COR 75              SETON                                        34                       GLR05
      *                                                                   GLR050
      ******   IF CONSOLIDATED REPORT INDICATED, DO NOT PERMIT            GLR050
      ******   ENTRY OF DEPARTMENT                                        GLR050
      *                                                                   GLR050
     C   71
     CAN 42              SETON                                        15                       GLR05
     C   71
     CANN42              SETOFF                                       15                       GLR05
      *                                                                   GLR050
     C   71
     CANN95              SETON                                        88                       GLR05
     C   71
     CANN95              EXCEPT                                                                GLR05
     C   71
     CANN95              SETOFF                                       88                       GLR05
      *                                                                   GLR050
     C   71
     CANN99
     CAN 95              SETON                                        84                       GLR05
     C   71
     CANN99
     CAN 95              EXCEPT                                                                GLR05
     C   71
     CANN99
     CAN 95              SETOFF                                       84                       GLR05
      *                                                                   GLR050
     C   72
     CANN99              SETON                                        84                       GLR05
     C   72
     CANN99              EXCEPT                                                                GLR05
     C   72
     CANN99              SETOFF                                       84                       GLR05
      *                                                                   GLR050
     C   71
     CANN99                                                                                    GLR05
     COR 72
     CANN99              GOTO      ESCRNA                                                      GLR05
      *                                                                   GLR050
     C   75              EXSR      LOADC                                                       GLR05
     C   75              EXSR      LOADD                                                       GLR05
     C   75              SETON                                        85                       GLR05
     C   75              EXCEPT                                                                GLR05
     C   75              SETOFF                                       85                       GLR05
     C   75              GOTO      ESCRNA                                                      GLR05
      *                                                                   GLR050
      ******   IF IN DELETE OR REACTIVATE MODE,                           GLR050
      ******   DISPLAY QUERY RE                                           GLR050
      ******   DELETE OR REACTIVATE ONE GROUP OF A REPORT, OR             GLR050
      ******   ENTIRE REPORT.  DEPENDING ON RESPONSE, EXECUTE             GLR050
      ******   APPROPRIATE DELETE/REACTIVATE WITH WARNING MESSAGE.        GLR050
      *                                                                   GLR050
     C   73
     CAN 59
     CAN 49                                                                                    GLR05
     COR 74
     CAN 59
     CAN 49              GOTO      YESTAG                                                      GLR05
     C   73
     CANN49                                                                                    GLR05
     COR 74
     CANN49              GOTO      DRTAG                                                       GLR05
      *                                                                   GLR050
     C   73
     CAN 44
     CAN 49                                                                                    GLR05
     COR 74
     CAN 44
     CAN 49              SETOFF                                       44                       GLR05
      *                                                                   GLR050
     C  N44
     CAN 49              SETON                                        18                       GLR05
     C  N44
     CAN 49              GOTO      ETAG                                                        GLR05
      *                                                                   GLR050
     C     YESTAG        TAG                                                                   GLR05
      *                                                                   GLR050
     C                   SETOFF                                       636465                   GLR05
     C  N44
     CAN 49VYES          COMP      *BLANKS                            656563                   GLR05
     C  N44
     CAN 49VYES          COMP      'YES'                                  64                   GLR05
      *                                                                   GLR050
     C  N44
     CAN 49
     CAN 65                                                                                    GLR05
     CANN64
     CANN99              MOVE      MSG(30)       ERR                                           GLR05
     C  N44
     CAN 49
     CAN 65                                                                                    GLR05
     CANN64
     CANN99              SETON                                        991880                   GLR05
     C  N44
     CAN 49
     CAN 65                                                                                    GLR05
     CANN64
     CANN99              SETON                                        17                       GLR05
     C   99              GOTO      ESCRNA                                                      GLR05
      *                                                                   GLR050
     C   64
     CAN 49              SETOFF                                       49                       GLR05
     C   64              GOTO      ETAG                                                        GLR05
      *                                                                   GLR050
      ******   IF DELETING OR REACTIVATING ONE GROUP ONLY,                GLR050
      ******   CHECK IF ACTION APPROPRIATE - IF NOT DISPLAY ERROR MSG     GLR050
      *                                                                   GLR050
     C   63              MOVE      *BLANKS       HDRKEY           14                           GLR05
     C   63              MOVE      *BLANKS       WK12             12                           GLR05
     C   63              MOVEL     VREPRT        WK12                                          GLR05
     C   63              MOVE      VGROUP        WK12                                          GLR05
     C   63              MOVEL     VCOMP         HDRKEY                                        GLR05
     C   63              MOVE      WK12          HDRKEY                                        GLR05
      *                                                                   GLR050
     C   63              SETOFF                                       6869                     GLR05
     C   63HDRKEY        CHAIN     ULFMH                              68                       GLR05
     C   63
     CANN68
     CANN73UHSTAT        COMP      'D'                                    69    ADDED N73      GLR05
      *                                                                   GLR050
     C   63                                                                                    GLR05
     CAN 69
     CAN 73
     CANN99              MOVE      MSG(11)       ERR                                           GLR05
     C   69
     CAN 73
     CAN 63              SETON                                        992080                   GLR05
     C   69
     CAN 73
     CAN 63              SETON                                        212426                   GLR05
      *                                                                   GLR050
     C   63                                                                                    GLR05
     CANN69
     CAN 74
     CANN99              MOVE      MSG(10)       ERR                                           GLR05
     C  N69
     CAN 74
     CAN 63              SETON                                        992080                   GLR05
     C  N69
     CAN 74
     CAN 63              SETON                                        212426                   GLR05
     C   63
     CAN 99              SETON                                        49                       GLR05
     C   63
     CAN 99              GOTO      ESCRNA                                                      GLR05
      *                                                                   GLR050
     C   63
     CANN99              EXSR      LOADD                                                       GLR05
     C   63
     CANN99              SETOFF                                       3480                     GLR05
     C   63
     CANN99              SETON                                        85                       GLR05
     C   63
     CANN99              EXCEPT                                                                GLR05
     C   63
     CANN99              SETOFF                                       85                       GLR05
     C   63
     CANN99              GOTO      ESCRNA                                                      GLR05
      *                                                                   GLR050
     C     DRTAG         TAG                                                                   GLR05
      *                                                                   GLR050
     C  N49              EXSR      ALLDR                                                       GLR05
     C  N49              EXSR      CLEAR                                                       GLR05
     C                   GOTO      ESCRNA                                                      GLR05
     C     ETAG          TAG                                                                   GLR05
     C                   SETON                                        5980                     GLR05
      *                                                                   GLR050
     C     ESCRNA        ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  SCRNB - SUBROUTINE                   *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     SCRNB         BEGSR                                                                 GLR05
      *                                                                   GLR050
      ******   PROCESS RESTART                                            GLR050
      *                                                                   GLR050
     C   KF              EXSR      CLEAR                                                       GLR05
     C   KF              GOTO      ESCRNB                                                      GLR05
      *                                                                   GLR050
     C   KA
     CAN 65              MOVE      *BLANKS       LIMIT                                         GLR05
     C   KA
     CAN 65              MOVEL     VSEARC        LIMIT                                         GLR05
     C   KA
     CANN65              MOVEL     ALEND         LIMIT                                         GLR05
      ******   PROCESS ROLL OPTION                                        GLR050
      *                                                                   GLR050
     C   KA              EXSR      ALPOUT                                                      GLR05
     C   KA              GOTO      ESCRNB                                                      GLR05
      *                                                                   GLR050
      ******   PICK REPORT NUMBER EDIT LINE SELECTED                      GLR050
      *                                                                   GLR050
     C     VLIN#         COMP      0                                      68                   GLR05
     C   68              SETON                                        80                       GLR05
     C   68              GOTO      ESCRNB                                                      GLR05
     C     VLIN#         COMP      LX                                 68                       GLR05
     C   68              SETON                                        80                       GLR05
     C   68              GOTO      ESCRNB                                                      GLR05
      *                                                                   GLR050
      ******   CHAIN TO CROSS REFERENCE FILE FOR REPORT DESCRIPTION       GLR050
      *                                                                   GLR050
     C                   MOVE      *BLANKS       XRFKEY           25                           GLR05
     C                   MOVE      CHC(VLIN#)    XRFKEY                                        GLR05
     C     XRFKEY        CHAIN     ULREF                              68                       GLR05
      *                                                                   GLR050
     C  N68              MOVEL     UXLOOK        VNAME            40                           GLR05
     C                   MOVE      *BLANKS       VSEARC                                        GLR05
     C                   MOVEL     UXRPRT        VREPRT                                        GLR05
     C                   Z-ADD     UXCOMP        VCOMP                                         GLR05
      *                                                                   GLR050
     C                   SETON                                        80                       GLR05
      *                                                                   GLR050
     C     ESCRNB        ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  SCRNC - SUBROUTINE                   *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     SCRNC         BEGSR                                                                 GLR05
      *                                                                   GLR050
      ******   PROCESS RESTART OPTION.  THIS WILL CLEAR AND               GLR050
      ******   DISPLAY SCREEN A                                           GLR050
      *                                                                   GLR050
     C   KB              SETOFF                                       99                       GLR05
     C   KB              EXSR      CLEAR                                                       GLR05
     C   KB              SETON                                        80                       GLR05
     C   KB              GOTO      ESCRNC                                                      GLR05
      *                                                                   GLR050
     C                   SETOFF                                       394099                   GLR05
     C                   SETOFF                                       767778                   GLR05
     C                   SETOFF                                       792833                   GLR05
     C                   SETOFF                                       616263                   GLR05
     C                   SETOFF                                       6416                     GLR05
      *                                                                   GLR050
      ******   BYPASS CALCS IF INQUIRY - GO AHEAD TO SCREEN 'D'           GLR050
      *                                                                   GLR050
     C   75              EXSR      LOADD                                                       GLR05
     C   75              SETON                                        85                       GLR05
     C   75              EXCEPT                                                                GLR05
     C   75              SETOFF                                       85                       GLR05
      *                                                                   GLR050
     C   75              GOTO      ESCRNC                                                      GLR05
      *                                                                   GLR050
      ******   CHECK THAT ALPHA FIELD ENTERED                             GLR050
      *                                                                   GLR050
     C     VSERCH        COMP      *BLANKS                                61                   GLR05
     C   61
     CANN99              MOVE      MSG(27)       ERR                                           GLR05
     C   61
     CANN99              SETON                                        3999                     GLR05
      *                                                                   GLR050
      ******   CHECK IF THIS IS A DEPARTMENTAL REPORT FORMAT.             GLR050
      ******   IF SO, MUST ENTER A DEPARTMENT NUMBER, BUT                 GLR050
      ******   IF NOT, MUST RETAIN DEFAULT RESPONSE '0000"                GLR050
      *                                                                   GLR050
     C     VANS          COMP      'Y'                                646416                   GLR05
     C   64VANS          COMP      'N'                                6464                     GLR05
      *                                                                   GLR050
     C   64
     CANN99              MOVE      MSG(32)       ERR                                           GLR05
     C   64
     CANN99              SETON                                        9928                     GLR05
      *                                                                   GLR050
     C     VDEPT         COMP      0                                  62  63                   GLR05
     C   16
     CAN 63
     CANN99              MOVE      MSG(33)       ERR                                           GLR05
     C   16
     CAN 63
     CANN99              SETON                                        9933                     GLR05
      *                                                                   GLR050
     C  N16
     CAN 62
     CANN99              MOVE      MSG(34)       ERR                                           GLR05
     C  N16
     CAN 62
     CANN99              SETON                                        9933                     GLR05
      *                                                                   GLR050
      ******   CHECK THAT REPORT TYPE 1 - 4                               GLR050
      *                                                                   GLR050
     C     VRTYP         COMP      0                                    6262                   GLR05
     C   62
     CANN99              MOVE      MSG(28)       ERR                                           GLR05
     C   62
     CANN99              SETON                                        4099                     GLR05
      *                                                                   GLR050
     C     VRTYP         COMP      5                                  62  62                   GLR05
     C   62
     CANN99              MOVE      MSG(28)       ERR                                           GLR05
     C   62
     CANN99              SETON                                        4099                     GLR05
      *                                                                   GLR050
      ******   DETERMINE REPORT TYPE                                      GLR050
      ******   TYPE 1  =  BALANCE SHEET                                   GLR050
      ******   TYPE 2  =  INCOME STATEMENT                                GLR050
      ******   TYPE 3  =  TRIAL BALANCE                                   GLR050
      ******   TYPE 4  =  BUDGET                                          GLR050
      *                                                                   GLR050
     C  N99VRTYP         COMP      1                                  636376                   GLR05
     C   63
     CANN99VRTYP         COMP      2                                  636377                   GLR05
     C   63
     CANN99VRTYP         COMP      3                                  636378                   GLR05
     C   63
     CANN99VRTYP         COMP      4                                  636379                   GLR05
      *                                                                   GLR050
      ******   ON ERROR, REDISPLAY SCREEN                                 GLR050
      *                                                                   GLR050
     C   99              SETON                                        88                       GLR05
     C   99              EXCEPT                                                                GLR05
     C   99              SETOFF                                       88                       GLR05
      *                                                                   GLR050
      ******   IF NO ERROR, OUTPUT TO CROSS REFERENCE FILE                GLR050
      ******   AND GO AHEAD TO NEXT SCREEN                                GLR050
      *                                                                   GLR050
     C   71
     CANN99                                                                                    GLR05
     COR 72
     CANN99              EXSR      XRFOUT                                                      GLR05
      *                                                                   GLR050
     C                   EXSR      ALLHDR                                                      GLR05
      *                                                                   GLR050
     C   71
     CANN99                                                                                    GLR05
     COR 72
     CANN99              EXSR      LOADD                                                       GLR05
      *                                                                   GLR050
     C  N99              SETON                                        34                       GLR05
     C   71
     CANN99                                                                                    GLR05
     COR 72
     CANN99              SETON                                        84                       GLR05
     C   71
     CANN99                                                                                    GLR05
     COR 72
     CANN99              EXCEPT                                                                GLR05
      *                                                                   GLR050
     C   71
     CANN99                                                                                    GLR05
     COR 72
     CANN99              SETOFF                                       84                       GLR05
      *                                                                   GLR050
     C     ESCRNC        ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       * ALLHDR SUBROUTINE - UPDATE DEPT.#     *                   GLR050
      *       *   FOR ENTIRE REPORT IF USER IS ON SCRN C *                GLR050
      *       *****************************************                   GLR050
     C     ALLHDR        BEGSR                                                                 GLR05
      *                                                                   GLR050
      ******   UPDATE DEPT# FOR ALL HEADER RECORDS FROM SCREEN C          GLR050
      *                                                                   GLR050
     C                   MOVE      *BLANKS       HDRLIM           14                           GLR05
     C                   MOVE      *BLANKS       WK10             10                           GLR05
      *                                                                   GLR050
     C                   MOVEL     VCOMP         WK10                                          GLR05
     C                   MOVE      VREPRT        WK10                                          GLR05
     C                   MOVEL     WK10          HDRLIM                                        GLR05
     C                   MOVE      '0000'        HDRLIM                                        GLR05
     C     HDRLIM        SETLL     GLFMH                                                       GLR05
     C     HLUP2         TAG                                                                   GLR05
     C                   SETOFF                                       65                       GLR05
     C                   READ      GLFMH                                  65                   GLR05
     C   65              GOTO      HSKP2                                                       GLR05
     C     GHCOMP        COMP      VCOMP                                  67                   GLR05
     C   67GHRPRT        COMP      VREPRT                                 67                   GLR05
     C  N67              GOTO      HSKP2                                                       GLR05
      *                                                                   GLR050
     C     HKEY          CHAIN     ULFMH                              65                       GLR05
      *                                                                   GLR050
     C                   SETON                                        50                       GLR05
     C                   EXCEPT                                                                GLR05
     C                   SETOFF                                       50                       GLR05
     C                   GOTO      HLUP2                                                       GLR05
      *                                                                   GLR050
     C     HSKP2         ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  SCRND - SUBROUTINE                   *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     SCRND         BEGSR                                                                 GLR05
      *                                                                   GLR050
      ******   PROCESS RETURN TO PREVIOUS SCREEN OPTION.                  GLR050
      ******   THIS WILL PERMIT INQUIRY ON OR CHANGE IN                   GLR050
      ******   ALPHA CROSS REFERENCE RECORD                               GLR050
      *                                                                   GLR050
     C   KB
     CAN 71                                                                                    GLR05
     COR KB
     CAN 72              EXSR      LOADC                                                       GLR05
     C   KB
     CAN 71                                                                                    GLR05
     COR KB
     CAN 72              SETON                                        88                       GLR05
     C   KB
     CAN 71                                                                                    GLR05
     COR KB
     CAN 72              EXCEPT                                                                GLR05
     C   KB
     CAN 71                                                                                    GLR05
     COR KB
     CAN 72              SETOFF                                       88                       GLR05
     C   KB
     CAN 71                                                                                    GLR05
     COR KB
     CAN 72              GOTO      ESCRND                                                      GLR05
      *                                                                   GLR050
     C   KB
     CAN 73                                                                                    GLR05
     COR KB
     CAN 74              EXSR      CLEAR                                                       GLR05
     C   KB
     CAN 73                                                                                    GLR05
     COR KB
     CAN 74              GOTO      ESCRND                                                      GLR05
      *                                                                   GLR050
     C   KB
     CAN 75              SETON                                        89                       GLR05
     C   KB
     CAN 75              EXCEPT                                                                GLR05
     C   KB
     CAN 75              SETOFF                                       89                       GLR05
     C   KB
     CAN 75              GOTO      ESCRND                                                      GLR05
      *                                                                   GLR050
      ******   PROCESS RESTART OPTION.  THIS WILL CLEAR AND               GLR050
      ******   DISPLAY SCREEN A                                           GLR050
      *                                                                   GLR050
     C   KF              SETOFF                                       97                       GLR05
     C   KF              EXSR      CLEAR                                                       GLR05
     C   KF              GOTO      ESCRND                                                      GLR05
      *                                                                   GLR050
      ******   'ADD' MODE -                                               GLR050
      ******   VALIDATE FIELD ENTRIES - SCREEN 'D' AND                    GLR050
      ******   IF OK, CLEAR SCREEN 'E' FIELDS AND DISPLAY                 GLR050
      ******   SCREEN E WITH INPUT ALLOWED                                GLR050
      ******   (NOTE:  SWITCH 41 IS SET OFF OR ON IN VALSCD SR -          GLR050
      ******   (      41 ON IF LINE TYPE 1  -  ONLY LINE TYPE 1           GLR050
      ******   (      NEEDS DETAIL FROM SCREEN 'E')                       GLR050
      *                                                                   GLR050
     C   71              EXSR      VALSCD                                                      GLR05
     C   71
     CANN99              EXSR      HDROUT                                                      GLR05
     C   71
     CANN99
     CAN 41              EXSR      LOADE                                                       GLR05
     C   71
     CANN99
     CAN 41              SETON                                        37                       GLR05
      *                                                                   GLR050
     C   71
     CANN99
     CAN 41              SETON                                        86                       GLR05
     C   71
     CANN99
     CAN 41              EXCEPT                                                                GLR05
     C   71
     CANN99
     CAN 41              SETOFF                                       86                       GLR05
      *                                                                   GLR050
      ******   IF NOT A PRINT TYPE ONE, GO BACK TO FIRST SCREEN           GLR050
      ******   FOR NEXT GROUP NUMBER                                      GLR050
      *                                                                   GLR050
     C   71
     CANN99
     CANN41              ADD       20            VGROUP                                        GLR05
     C   71
     CANN99
     CANN41              SETON                                        48                       GLR05
     C   71
     CANN99
     CANN41              EXSR      CLEAR                                                       GLR05
     C   71
     CANN99
     CANN41              SETOFF                                       48                       GLR05
      *                                                                   GLR050
      ******   'CHANGE' MODE -                                            GLR050
      ******   DISPLAY EXISTING DATA FOR SCREEN 'D',                      GLR050
      ******   VALIDATE ANY CHANGES, AND IF OK,                           GLR050
      ******   LOAD DATA FOR SCREEN 'E' AND DISPLAY                       GLR050
      ******   SCREEN E WITH INPUT ALLOWED                                GLR050
      *                                                                   GLR050
     C   72              EXSR      VALSCD                                                      GLR05
     C   72
     CANN99              EXSR      HDROUT                                                      GLR05
     C   72
     CANN99
     CAN 41              EXSR      LOADE                                                       GLR05
      *                                                                   GLR050
     C   72
     CANN99
     CAN 41              SETON                                        3643                     GLR05
      *                                                                   GLR050
     C   72
     CANN99
     CAN 41              SETON                                        86                       GLR05
     C   72
     CANN99
     CAN 41              EXCEPT                                                                GLR05
     C   72
     CANN99
     CAN 41              SETOFF                                       86                       GLR05
      *                                                                   GLR050
      ******   IF NOT A PRINT TYPE ONE,  RETURN TO 1ST SCREEN             GLR050
      ******   FOR NEW GROUP NUMBER                                       GLR050
      ******   (ZERO GROUP NUMBER FOR NEXT CHANGE)                        GLR050
      *                                                                   GLR050
     C   72
     CANN99
     CANN41              Z-ADD     0             VGROUP                                        GLR05
     C   72
     CANN99
     CANN41              SETON                                        48                       GLR05
     C   72
     CANN99
     CANN41              EXSR      CLEAR                                                       GLR05
     C   72
     CANN99
     CANN41              SETOFF                                       48                       GLR05
      *                                                                   GLR050
      ******   'DELETE' OR 'REACTIVATE' MODES -                           GLR050
      ******   EXISTING SCREEN 'D' FIELDS DISPLAYED WITH                  GLR050
      ******   MESSAGE WARNING DELETE OR REACTIVATE IN PROGRESS           GLR050
      ******   IF PRESS ENTER, DELETE OR REACTIVATE EXECUTED              GLR050
      ******   BY OUTPUT TO FILES                                         GLR050
      ******   THEN RETURN TO FIRST SCREEN                                GLR050
      *                                                                   GLR050
     C   73
     CANN99                                                                                    GLR05
     COR 74
     CANN99              EXSR      DORR                                                        GLR05
     C   73
     CANN99                                                                                    GLR05
     COR 74
     CANN99              SETON                                        48                       GLR05
     C   73
     CANN99                                                                                    GLR05
     COR 74
     CANN99              EXSR      CLEAR                                                       GLR05
     C   73
     CANN99                                                                                    GLR05
     COR 74
     CANN99              SETOFF                                       48                       GLR05
     C   73
     CANN99                                                                                    GLR05
     COR 74
     CANN99              GOTO      ESCRND                                                      GLR05
      *                                                                   GLR050
      ******   IF 'INQUIRY' MODE -                                        GLR050
      ******   LOAD SCREEN 'F' FIELDS (OUTPUT ONLY)                       GLR050
      ******   (IF NO DETAIL FOR LINE TYPE, GO BACK                       GLR050
      ******   TO FIRST SCREEN FOR NEXT GROUP)                            GLR050
      *                                                                   GLR050
     C   75
     CAN 41              EXSR      LOADE                                                       GLR05
      *                                                                   GLR050
     C   75
     CAN 41              SETON                                        87                       GLR05
     C   75
     CAN 41              EXCEPT                                                                GLR05
     C   75
     CAN 41              SETOFF                                       87                       GLR05
      *                                                                   GLR050
     C   75
     CANN41              SETON                                        48                       GLR05
     C   75
     CANN41              EXSR      CLEAR                                                       GLR05
     C   75
     CANN41              SETOFF                                       48                       GLR05
     C   75
     CANN41              GOTO      ESCRND                                                      GLR05
      *                                                                   GLR050
      ******   IF ERROR ON ADD OR UPDATE, REDISPLAY SCREEN D              GLR050
      *                                                                   GLR050
     C   71
     CAN 99                                                                                    GLR05
     COR 72
     CAN 99              SETON                                        84                       GLR05
     C   71
     CAN 99
     CAN 84                                                                                    GLR05
     COR 72
     CAN 99
     CAN 84              EXCEPT                                                                GLR05
     C   71
     CAN 99
     CAN 84                                                                                    GLR05
     COR 72
     CAN 99
     CAN 84              SETOFF                                       84                       GLR05
      *                                                                   GLR050
     C     ESCRND        ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  SCRNE - SUBROUTINE                   *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     SCRNE         BEGSR                                                                 GLR05
      *                                                                   GLR050
     C                   SETOFF                                       353637                   GLR05
     C                   SETOFF                                       381999                   GLR05
      *                                                                   GLR050
      ******   PROCESS RETURN TO FIRST SCREEN FOR NEW GROUP NUMBER OPTION GLR050
      *                                                                   GLR050
     C   KDSAVCOD        COMP      'A'                                    46                   GLR05
     C   KD
     CAN 46              ADD       20            VGROUP                                        GLR05
     C   KD
     CANN46              Z-ADD     0             VGROUP                                        GLR05
     C   KD              SETON                                        48                       GLR05
     C   KD              EXSR      CLEAR                                                       GLR05
     C   KD              SETOFF                                       4897                     GLR05
     C   KD              GOTO      ESCRNE                                                      GLR05
      *                                                                   GLR050
     C   KE              SETON                                        45                       GLR05
     C   KE              EXSR      SCROLL                                       ON ADD/CHANGE  GLR05
     C   KE              SETOFF                                       4597                     GLR05
     C   KE              GOTO      ESCRNE                                                      GLR05
      *                                                                   GLR050
      ******   PROCESS RESTART OPTION                                     GLR050
      *                                                                   GLR050
     C   KF              SETOFF                                       97                       GLR05
     C   KF              EXSR      CLEAR                                                       GLR05
     C   KF              GOTO      ESCRNE                                                      GLR05
      *                                                                   GLR050
      *  CHECK FOR VALID ACTION CODE.                                     GLR050
      *                                                                   GLR050
     C                   SETOFF                                       717273                   GLR05
     C                   SETOFF                                       74                       GLR05
     C     VACTN         COMP      'A'                                606071                   GLR05
     C   60VACTN         COMP      'C'                                606072                   GLR05
     C   60VACTN         COMP      'D'                                606073                   GLR05
     C   60VACTN         COMP      'R'                                606074                   GLR05
     C   60
     CANN99              MOVE      MSG(1)        ERR                                           GLR05
     C   60              SETON                                        99                       GLR05
      *                                                                   GLR050
      *  ON AN ADD, MOVE NEXT AVAILABLE SEQ. # INTO ENTRY FIELD           GLR050
      *                                                                   GLR050
     C   71              Z-ADD     LINHLD        VLINE                                         GLR05
      *                                                                   GLR050
      *  LINE NUMBER CANNOT BE ZERO.                                      GLR050
      *                                                                   GLR050
     C     VLINE         COMP      0                                      61                   GLR05
     C   61
     CANN99              MOVE      MSG(25)       ERR                                           GLR05
     C   61              SETON                                        9936                     GLR05
      *                                                                   GLR050
      ******   CHECK IF DETAIL RECORD EXISTS                              GLR050
      *                                                                   GLR050
     C                   MOVE      *BLANKS       WK10             10                           GLR05
     C                   MOVE      *BLANKS       WK7               7                           GLR05
     C                   MOVE      *BLANKS       DETKEY           17                           GLR05
     C                   MOVEL     VCOMP         WK10                                          GLR05
     C                   MOVE      VREPRT        WK10                                          GLR05
     C                   MOVEL     VGROUP        WK7                                           GLR05
     C                   MOVE      VLINE         WK7                                           GLR05
     C                   MOVEL     WK10          DETKEY                                        GLR05
     C                   MOVE      WK7           DETKEY                                        GLR05
     C                   SETOFF                                       656869                   GLR05
      *                                                                   GLR050
     C     DETKEY        CHAIN     ULFMI                              65                       GLR05
     C  N65UISTAT        COMP      'A'                                    68                   GLR05
     C  N65UISTAT        COMP      'D'                                    69                   GLR05
      *                                                                   GLR050
      ******   IF IN ADD MODE AND RECORD EXISTS - DISPLAY ERROR MSG       GLR050
      *                                                                   GLR050
     C   71
     CANN65
     CANN99              MOVE      MSG(4)        ERR                                           GLR05
     C   71
     CANN65
     CANN99              SETON                                        993536                   GLR05
      *                                                                   GLR050
      ******   IF IN UPDATE MODE AND RECORD DOES NOT EXIST - ERR MSG      GLR050
      *                                                                   GLR050
     C   72
     CAN 65
     CANN99              MOVE      MSG(5)        ERR                                           GLR05
     C   72
     CAN 65
     CANN99              SETON                                        993536                   GLR05
      *                                                                   GLR050
      ******   CANT DELETE RECORD ALREADY INACTIVE OR NON-EXISTENT        GLR050
      ******   CAN'T REACTIVATE RECORD ALREADY ACTIVE OR NON-EXISTENT     GLR050
      *                                                                   GLR050
     C   73
     CAN 69
     CANN99              MOVE      MSG(11)       ERR                                           GLR05
     C   73
     CAN 69              SETON                                        3599                     GLR05
      *                                                                   GLR050
     C   74
     CAN 68
     CANN99              MOVE      MSG(10)       ERR                                           GLR05
     C   74
     CAN 68
     CANN99              SETON                                        3599                     GLR05
      *                                                                   GLR050
     C   73
     CAN 65
     CANN99              MOVE      MSG(7)        ERR                                           GLR05
     C   73
     CAN 65
     CANN99              SETON                                        3599                     GLR05
      *                                                                   GLR050
     C   74
     CAN 65
     CANN99              MOVE      MSG(6)        ERR                                           GLR05
     C   74
     CAN 65
     CANN99              SETON                                        3599                     GLR05
      *                                                                   GLR050
      ******   IF ERROR SO FAR, BYPASS FURTHER ERROR CHECKS               GLR050
      *                                                                   GLR050
     C   99              GOTO      ENDE                                                        GLR05
      *                                                                   GLR050
      *  IF NOT AN ADD LOAD SCREEN FIELDS.                                GLR050
      *                                                                   GLR050
     C                   SETOFF                                       69                       GLR05
     C  N71VACTN         COMP      ACTNCK                             6969                     GLR05
     C   69              SETON                                        43                       GLR05
     C  N71
     CAN 43              MOVE      UICOMD        VCOMD                                         GLR05
     C  N71
     CAN 43              Z-ADD     UIGLAC        VGLACC            8 0                         GLR05
      *                                                                   GLR050
      *  DISPLAY DETAIL ENTRY FIELDS IF 1ST TIME THROUGH.                 GLR050
      *                                                                   GLR050
     C   43              GOTO      ENDEE                                                       GLR05
      *                                                                   GLR050
      ******   CHECK COMPANY NOT 00                                       GLR050
      *                                                                   GLR050
     C     VCOMD         COMP      0                                      62                   GLR05
     C   62
     CANN99              MOVE      MSG(17)       ERR                                           GLR05
     C   62
     CANN99              SETON                                        9938                     GLR05
      *                                                                   GLR050
      ******   IF COMPANY ON FIRST SCREEN WAS '00' THIS IS A              GLR050
      ******   CONSOLIDATED REPORT AND ANY COMPANY NUMBER CAN BE ENTERED  GLR050
      *                                                                   GLR050
     C   42              GOTO      CONSKP                                                      GLR05
      *                                                                   GLR050
     C  N62VCOMD         COMP      VCOMP                              6969                     GLR05
     C  N62
     CAN 69
     CANN99              MOVE      MSG(29)       ERR                                           GLR05
     C  N62
     CAN 69
     CANN99              SETON                                        9938                     GLR05
      *                                                                   GLR050
     C     CONSKP        TAG                                                                   GLR05
      *                                                                   GLR050
      ******   CHECK FOR VALID COMPANY                                    GLR050
      *                                                                   GLR050
     C                   MOVEL     '01'          COKEY             4                           GLR05
     C                   MOVE      VCOMD         COKEY                                         GLR05
     C     COKEY         CHAIN     MCPTS                              66                       GLR05
     C   66
     CANN99              MOVE      MSG(17)       ERR                                           GLR05
     C   66
     CANN99              SETON                                        9938                     GLR05
      *                                                                   GLR050
      ******   CHECK FOR VALID G/L ACCOUNT NUMBER                         GLR050
      *                                                                   GLR050
     C                   MOVEL     VCOMD         MGLKEY           10                           GLR05
     C                   MOVE      VGLACC        MGLKEY                                        GLR05
     C     MGLKEY        CHAIN     MGLCH                              67                       GLR05
     C  N67GCSTAT        COMP      'D'                                    67                   GLR05
     C   67
     CANN99              MOVE      MSG(21)       ERR                                           GLR05
     C   67
     CANN99              SETON                                        993719                   GLR05
      *                                                                   GLR050
      ******   CHECK THAT REPORT TYPE AND G/L ACCOUNT TYPE MATCH          GLR050
      ******   REPORT TYPE 1 USES ACCOUNT TYPES 1 AND 2                   GLR050
      ******   REPORT TYPE 2 USES ACCOUNT TYPES 3 AND 4                   GLR050
      ******   REPORT TYPE 3 USES ANY ACCOUNT TYPE 1 - 4                  GLR050
      ******   REPORT TYPE 4 USES ACCOUNT TYPES 3 AND 4                   GLR050
      *                                                                   GLR050
     C  N67              SETOFF                                       6869                     GLR05
     C  N67GCATYP        COMP      3                                  686968                   GLR05
     C  N67
     CAN 76
     CAN 68                                                                                    GLR05
     CANN99              MOVE      MSG(26)       ERR                                           GLR05
     C  N67
     CAN 76
     CAN 68                                                                                    GLR05
     CANN99              SETON                                        993719                   GLR05
      *                                                                   GLR050
     C  N67
     CAN 77
     CAN 69                                                                                    GLR05
     CANN99              MOVE      MSG(26)       ERR                                           GLR05
     C  N67
     CAN 77
     CAN 69                                                                                    GLR05
     CANN99              SETON                                        993719                   GLR05
      *                                                                   GLR050
     C  N67
     CAN 79
     CAN 69                                                                                    GLR05
     CANN99              MOVE      MSG(26)       ERR                                           GLR05
     C  N67
     CAN 79
     CAN 69                                                                                    GLR05
     CANN99              SETON                                        993719                   GLR05
      *                                                                   GLR050
     C     ENDE          TAG                                                                   GLR05
      *                                                                   GLR050
      ******   IF ERROR, REDISPLAY SCREEN E                               GLR050
      *                                                                   GLR050
     C   99              SETON                                        86                       GLR05
     C   99              EXCEPT                                                                GLR05
     C   99              SETOFF                                       86                       GLR05
     C   99              GOTO      ESCRNE                                                      GLR05
      *                                                                   GLR050
      ******   IF NO ERRORS, UPDATE DETAIL FILE                           GLR050
      *                                                                   GLR050
     C  N99
     CANN43              EXSR      DETOUT                                                      GLR05
     C  N99
     CANN43              Z-ADD     0             VGLACC                                        GLR05
     C  N99
     CANN43
     CANN42              Z-ADD     VCOMP         VCOMD                                         GLR05
     C  N99
     CANN43              EXSR      SCROLL                                                      GLR05
     C  N99              GOTO      ESCRNE                                                      GLR05
      *                                                                   GLR050
      *                                                                   GLR050
      ******  (43 CONTROLS DISPLAY IN FORMAT AND CONTROLS  )              GLR050
      ******  (DOUBLE CYCLE DISPLAY OF SCREEN)                            GLR050
      *                                                                   GLR050
      ******   RE-DISPLAY SCREEN FOR ENTRY.                               GLR050
      *****   (IF DELETE OR REACTIVATE, DISPLAY SCREEN 'F' - OUTPUT ONLY) GLR050
      *                                                                   GLR050
     C     ENDEE         TAG                                                                   GLR05
      *                                                                   GLR050
     C                   MOVE      VACTN         ACTNCK                                        GLR05
     C   73                                                                                    GLR05
     COR 74              SETOFF                                       34                       GLR05
     C   73                                                                                    GLR05
     COR 74              SETON                                        87                       GLR05
     C   87              EXCEPT                                                                GLR05
     C   87              SETOFF                                       87                       GLR05
     C   73                                                                                    GLR05
     COR 74              GOTO      ESCRNE                                                      GLR05
      *                                                                   GLR050
     C   43              SETON                                        37                       GLR05
     C   43              SETOFF                                       43                       GLR05
     C                   SETON                                        86                       GLR05
     C                   EXCEPT                                                                GLR05
     C                   SETOFF                                       86                       GLR05
      *                                                                   GLR050
     C     ESCRNE        ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  SCRNF - SUBROUTINE                   *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     SCRNF         BEGSR                                                                 GLR05
      *                                                                   GLR050
      ******   PROCESS RESTART OPTION                                     GLR050
      *                                                                   GLR050
     C   KF              EXSR      CLEAR                                                       GLR05
     C   KF              GOTO      ESCRNF                                                      GLR05
      *                                                                   GLR050
      ******   PROCESS SCROLL OPTION                                      GLR050
      *                                                                   GLR050
     C   KE              SETON                                        47                       GLR05
     C   KE              EXSR      SCROLL                                       INQUIRY        GLR05
     C   KE              GOTO      ESCRNF                                                      GLR05
     C   KE              SETOFF                                       47                       GLR05
      *                                                                   GLR050
      ******   PROCESS RETURN TO PREVIOUS SCREEN OPTION                   GLR050
      *                                                                   GLR050
     C   KB              SETON                                        85                       GLR05
     C   KB              EXCEPT                                                                GLR05
     C   KB              SETOFF                                       85                       GLR05
     C   KB              GOTO      ESCRNF                                                      GLR05
      *                                                                   GLR050
      ******   ON INQUIRY, GO BACK TO FIRST SCREEN                        GLR050
      *                                                                   GLR050
     C   75              SETON                                        48                       GLR05
     C   75              EXSR      CLEAR                                                       GLR05
     C   75              SETOFF                                       48                       GLR05
     C   75              GOTO      ESCRNF                                                      GLR05
      *                                                                   GLR050
      ******   ON DELETE OR REACTIVATE, RETURN TO SCREEN 'E' FOR ENTRY    GLR050
      *                                                                   GLR050
     C                   EXSR      DETOUT                                                      GLR05
     C                   Z-ADD     0             VLINE                                         GLR05
     C                   Z-ADD     0             VGLACC                                        GLR05
     C  N42              Z-ADD     VCOMP         VCOMD                                         GLR05
     C   42              Z-ADD     0             VCOMD                                         GLR05
     C                   EXSR      SCROLL                                                      GLR05
     C                   GOTO      ESCRNF                                                      GLR05
      *                                                                   GLR050
     C     ESCRNF        ENDSR                                                                 GLR05
      *                                                                   GLR050
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  DORR SURROUTINE - DELETE OR REACTVTE *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     DORR          BEGSR                                                                 GLR05
      *                                                                   GLR050
      ******   IF 'D' OR 'R' MODE, DELETE OR REACTIVATE HEADER AND        GLR050
      ******   DETAIL RECORDS.  IF AT LEAST ONE RECORD REACTIVATED,       GLR050
      ******   REACTIVATE CROSS REFERENCE RECORD AS WELL.                 GLR050
      *                                                                   GLR050
     C   74              MOVE      *BLANKS       XRFLIM           25                           GLR05
     C                   MOVE      *BLANKS       HDRLIM           14                           GLR05
     C                   MOVE      *BLANKS       DETLIM           17                           GLR05
     C                   MOVE      *BLANKS       WK10             10                           GLR05
     C                   MOVE      *BLANKS       WK7               7                           GLR05
      *                                                                   GLR050
     C                   MOVEL     VCOMP         WK10                                          GLR05
     C                   MOVE      VREPRT        WK10                                          GLR05
     C                   MOVEL     WK10          HDRLIM                                        GLR05
     C                   MOVE      VGROUP        HDRLIM                                        GLR05
     C                   MOVEL     VGROUP        WK7                                           GLR05
     C                   MOVEL     WK10          DETLIM                                        GLR05
     C                   MOVE      WK7           DETLIM                                        GLR05
     C   74              MOVE      WK10          XRFLIM                                        GLR05
      *                                                                   GLR050
     C   74XRFLIM        SETLL     GLREF                                                       GLR05
     C     XRLUP         TAG                                                                   GLR05
     C   74              SETOFF                                       65                       GLR05
     C   74              READ      GLREF                                  65                   GLR05
     C   74
     CAN 65              GOTO      HTAG                                                        GLR05
      *                                                                   GLR050
     C   74GXCOMP        COMP      VCOMP                                  67                   GLR05
     C   74
     CAN 67GXRPRT        COMP      VREPRT                                 67    ADD 67 IND.    GLR05
     C   74
     CAN 67GXSTAT        COMP      'X'                                6767      BYPASS 'X' STATGLR05
      *                                                                   GLR050
     C  N67
     CAN 74              GOTO      XRLUP                                                       GLR05
      *                                                                   GLR050
     C   74ALFREP        CHAIN     ULREF                              65                       GLR05
      *                                                                   GLR050
     C   74              SETON                                        52                       GLR05
     C   74              EXCEPT                                                                GLR05
     C   74              SETOFF                                       52                       GLR05
      *                                                                   GLR050
     C     HTAG          TAG                                                                   GLR05
      *                                                                   GLR050
     C     HDRLIM        SETLL     GLFMH                                                       GLR05
     C     HLOOP         TAG                                                                   GLR05
     C                   SETOFF                                       65                       GLR05
     C                   READ      GLFMH                                  65                   GLR05
     C   65              GOTO      HSKIP                                                       GLR05
     C     GHCOMP        COMP      VCOMP                                  67                   GLR05
     C   67GHRPRT        COMP      VREPRT                                 67                   GLR05
     C   67GHGRUP        COMP      VGROUP                                 67                   GLR05
     C  N67              GOTO      HSKIP                                                       GLR05
      *                                                                   GLR050
     C     HKEY          CHAIN     ULFMH                              65                       GLR05
      *                                                                   GLR050
     C                   SETON                                        50                       GLR05
     C                   EXCEPT                                                                GLR05
     C                   SETOFF                                       50                       GLR05
     C                   GOTO      HLOOP                                                       GLR05
      *                                                                   GLR050
     C     HSKIP         TAG                                                                   GLR05
      *                                                                   GLR050
     C     DETLIM        SETLL     GLFMI                                                       GLR05
     C     DLOOP         TAG                                                                   GLR05
     C                   SETOFF                                       65                       GLR05
     C                   READ      GLFMI                                  65                   GLR05
     C   65              GOTO      DSKIP                                                       GLR05
      *                                                                   GLR050
     C     GICOMP        COMP      VCOMP                                  67                   GLR05
     C   67GIRPRT        COMP      VREPRT                                 67                   GLR05
     C   67GIGRUP        COMP      VGROUP                                 67                   GLR05
     C  N67              GOTO      DSKIP                                                       GLR05
      *                                                                   GLR050
     C     IKEY          CHAIN     ULFMI                              65                       GLR05
      *                                                                   GLR050
     C                   SETON                                        51                       GLR05
     C                   EXCEPT                                                                GLR05
     C                   SETOFF                                       51                       GLR05
     C                   GOTO      DLOOP                                                       GLR05
      *                                                                   GLR050
     C     DSKIP         TAG                                                                   GLR05
      *                                                                   GLR050
     C     EDORR         ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  ALLDR SUBROUTINE _ DELETE OR         *                   GLR050
      *       *   REACTIVATE ENTIRE REPORT & CROSS RF *                   GLR050
      *       *****************************************                   GLR050
     C     ALLDR         BEGSR                                                                 GLR05
      *                                                                   GLR050
      ******   DELETE OR REACTIVATE ALL HEADER RECORDS                    GLR050
      *                                                                   GLR050
     C                   MOVE      *BLANKS       XRFLIM           25                           GLR05
     C                   MOVE      *BLANKS       HDRLIM           14                           GLR05
     C                   MOVE      *BLANKS       DETLIM           17                           GLR05
     C                   MOVE      *BLANKS       WK10             10                           GLR05
     C                   MOVE      *BLANKS       WK7               7                           GLR05
      *                                                                   GLR050
     C                   MOVEL     VCOMP         WK10                                          GLR05
     C                   MOVE      VREPRT        WK10                                          GLR05
     C                   MOVEL     WK10          HDRLIM                                        GLR05
     C                   MOVE      '0000'        HDRLIM                                        GLR05
     C                   MOVEL     '0000'        WK7                                           GLR05
     C                   MOVEL     WK10          DETLIM                                        GLR05
     C                   MOVE      WK7           DETLIM                                        GLR05
     C                   MOVE      WK10          XRFLIM                                        GLR05
     C     HDRLIM        SETLL     GLFMH                                                       GLR05
     C     HLUP          TAG                                                                   GLR05
     C                   SETOFF                                       65                       GLR05
     C                   READ      GLFMH                                  65                   GLR05
     C   65              GOTO      HSKP                                                        GLR05
     C     GHCOMP        COMP      VCOMP                                  67                   GLR05
     C   67GHRPRT        COMP      VREPRT                                 67                   GLR05
     C  N67              GOTO      HSKP                                                        GLR05
      *                                                                   GLR050
     C     HKEY          CHAIN     ULFMH                              65                       GLR05
      *                                                                   GLR050
     C                   SETON                                        50                       GLR05
     C                   EXCEPT                                                                GLR05
     C                   SETOFF                                       50                       GLR05
     C                   GOTO      HLUP                                                        GLR05
      *                                                                   GLR050
     C     HSKP          TAG                                                                   GLR05
      *                                                                   GLR050
      ******   DELETE OR REACTIVATE ALL DETAIL RECORDS                    GLR050
      *                                                                   GLR050
     C     DETLIM        SETLL     GLFMI                                                       GLR05
     C     DLUP          TAG                                                                   GLR05
     C                   SETOFF                                       65                       GLR05
     C                   READ      GLFMI                                  65                   GLR05
     C   65              GOTO      DSKP                                                        GLR05
      *                                                                   GLR050
     C     GICOMP        COMP      VCOMP                                  67                   GLR05
     C   67GIRPRT        COMP      VREPRT                                 67                   GLR05
     C  N67              GOTO      DSKP                                                        GLR05
      *                                                                   GLR050
     C     IKEY          CHAIN     ULFMI                              65                       GLR05
      *                                                                   GLR050
     C                   SETON                                        51                       GLR05
     C                   EXCEPT                                                                GLR05
     C                   SETOFF                                       51                       GLR05
     C                   GOTO      DLUP                                                        GLR05
      *                                                                   GLR050
     C     DSKP          TAG                                                                   GLR05
      *                                                                   GLR050
     C     XRFLIM        SETLL     GLREF                                                       GLR05
     C     XLUP          TAG                                                                   GLR05
     C                   SETOFF                                       65                       GLR05
     C                   READ      GLREF                                  65                   GLR05
     C   65              GOTO      EALLDR                                                      GLR05
      *                                                                   GLR050
     C     GXCOMP        COMP      VCOMP                                  67                   GLR05
     C   67GXRPRT        COMP      VREPRT                                 67    ADDED 67 IND.  GLR05
     C   67GXSTAT        COMP      'X'                                6767      BYPASS 'X' STATGLR05
      *                                                                   GLR050
     C  N67              GOTO      XLUP                                                        GLR05
      *                                                                   GLR050
      ******   DELETE OR REACTIVATE CROSS REFERENCE RECORD                GLR050
      *                                                                   GLR050
     C     ALFREP        CHAIN     ULREF                              65                       GLR05
      *                                                                   GLR050
     C   73              SETON                                        57                       GLR05
     C   73              EXCEPT                                                                GLR05
     C   73              SETOFF                                       57                       GLR05
      *                                                                   GLR050
     C   74              SETON                                        52                       GLR05
     C   74              EXCEPT                                                                GLR05
     C   74              SETOFF                                       52                       GLR05
      *                                                                   GLR050
     C     EALLDR        ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  VALSCD- SUBROUTINE                   *                   GLR050
      *       *  VALIDATES FIELDS ENTERED ON SCREEN D *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     VALSCD        BEGSR                                                                 GLR05
      *                                                                   GLR050
     C                   SETOFF                                       277029                   GLR05
     C                   SETOFF                                       303132                   GLR05
     C                   SETOFF                                       419958                   GLR05
     C                   SETON                                        34                       GLR05
      *                                                                   GLR050
      ******   CHECK THAT SPACE BEFORE AND SPACE AFTER ARE 0,1,2,OR 3     GLR050
      *                                                                   GLR050
     C     VSPBF         COMP      0                                    61                     GLR05
     C   61
     CANN99              MOVE      MSG(22)       ERR                                           GLR05
     C   61              SETON                                        2999                     GLR05
      *                                                                   GLR050
     C     VSPBF         COMP      3                                  62                       GLR05
     C   62
     CANN99              MOVE      MSG(22)       ERR                                           GLR05
     C   62
     CANN99              SETON                                        2999                     GLR05
      *                                                                   GLR050
     C     VSPAF         COMP      0                                    63                     GLR05
     C   63
     CANN99              MOVE      MSG(22)       ERR                                           GLR05
     C   63              SETON                                        3099                     GLR05
      *                                                                   GLR050
     C     VSPAF         COMP      3                                  64                       GLR05
     C   64
     CANN99              MOVE      MSG(22)       ERR                                           GLR05
     C   64
     CANN99              SETON                                        3099                     GLR05
      *                                                                   GLR050
      ******   CHECK THAT REVERSE SIGN FIELD IS 0,1,OR 2                  GLR050
      ******   0  =  NOT APPLICABLE                                       GLR050
      ******   1  =  DO NOT REVERSE SIGN                                  GLR050
      ******   2  =  REVERSE SIGN                                         GLR050
      *                                                                   GLR050
     C     VRVSN         COMP      0                                    61                     GLR05
     C   61
     CANN99              MOVE      MSG(23)       ERR                                           GLR05
     C   61
     CANN99              SETON                                        3199                     GLR05
      *                                                                   GLR050
     C     VRVSN         COMP      2                                  62                       GLR05
     C   62
     CANN99              MOVE      MSG(23)       ERR                                           GLR05
     C   62
     CANN99              SETON                                        3199                     GLR05
      *                                                                   GLR050
      ******   CHECK THAT PRINT COLUMN IS 0, POSITIVE NO., H OR T         GLR050
      ******   DETAIL RECORDS POSSIBLE ONLY IF 1 IN THIS FIELD            GLR050
      ******   IF 1 IN FIELD, SET ON 41                                   GLR050
      *                                                                   GLR050
     C     VPTYP         COMP      'H'                                606061                   GLR05
     C   60VPTYP         COMP      'T'                                606061                   GLR05
     C   60VPTYP         COMP      '1'                                606041                   GLR05
     C   60VPTYP         COMP      '0'                                  60                     GLR05
     C   60
     CANN99              MOVE      MSG(24)       ERR                                           GLR05
     C   60              SETON                                        3299                     GLR05
      *                                                                   GLR050
      ******  DON'T ALLOW A DETAIL LINE TYPE (1) TO BE CHANGED TO         GLR050
      ******  ANYTHING ELSE, BECAUSE OF THE HANDLING OF DETAIL ACCOUNTS.  GLR050
     C  N41
     CAN 72UHPCOL        COMP      '1'                                    70                   GLR05
     C   70
     CANN99              MOVE      MSG(35)       ERR                                           GLR05
     C   70              SETON                                        3299                     GLR05
      *                                                                   GLR050
      ******  LINE TYPE OF ZERO SHOULD ALWAYS HAVE A REVERSE SIGN OF 0.   GLR050
     C     VPTYP         COMP      '0'                                    58                   GLR05
     C   58VRVSN         COMP      0                                  5858                     GLR05
     C   58
     CANN99              MOVE      MSG(36)       ERR                                           GLR05
     C   58              SETON                                        993132                   GLR05
      *                                                                   GLR050
      ******   CHECK THAT DESCRIPTION FIELD NOT BLANK                     GLR050
      ******   (UNLESS REPORT TYPE 3 - AND LINE TYPE 1   -                GLR050
      ******   (WHEN IT MUST BE BLANK)                                    GLR050
      ******  TO ENABLE SPACING TO A NEW PAGE ALLOW BLANKS DESCRIPTIONS   GLR050
      ******  FOR LINE TYPE 0 (LINE OF TEXT)                              GLR050
     C                   SETOFF                                       696058                   GLR05
      *                                                                   GLR050
     C     VPTYP         COMP      '0'                                    58    LINE OF TEXT TPGLR05
     C     VDESC         COMP      *BLANKS                            696960                   GLR05
     C  N78                                                                     NOT TRIAL BAL  GLR05
     CAN 60
     CANN99
     CANN58              MOVE      MSG(27)       ERR                            NOT 0          GLR05
     C  N78                                                                                    GLR05
     CAN 60
     CANN99
     CANN58              SETON                                        2799                     GLR05
      *                                                                   GLR050
      ******  TRIAL BALANCE TYPE                                          GLR050
     C   60
     CANN99
     CAN 78                                                                                    GLR05
     CANN41
     CANN58              MOVE      MSG(27)       ERR                                           GLR05
     C   60
     CANN99
     CAN 78                                                                                    GLR05
     CANN41
     CANN58              SETON                                        2799                     GLR05
      *                                                                   GLR050
     C   69
     CANN99
     CAN 78                                                                                    GLR05
     CAN 41              MOVE      MSG(31)       ERR                                           GLR05
     C   69
     CANN99
     CAN 78                                                                                    GLR05
     CAN 41              SETON                                        2799                     GLR05
      *                                                                   GLR050
     C     EVALSD        ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  HDROUT- SUBROUTINE                   *                   GLR050
      *       *  OUTPUT TO FORMAT HEADER FILE         *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     HDROUT        BEGSR                                                                 GLR05
      *                                                                   GLR050
     C   42              Z-ADD     0             VDEPT                          CONSOLIDATED   GLR05
     C                   MOVE      *BLANKS       WK10             10                           GLR05
     C                   MOVE      *BLANKS       HDRKEY           14                           GLR05
     C                   MOVEL     VCOMP         WK10                                          GLR05
     C                   MOVE      VREPRT        WK10                                          GLR05
     C                   MOVEL     WK10          HDRKEY                                        GLR05
     C                   MOVE      VGROUP        HDRKEY                                        GLR05
     C     HDRKEY        CHAIN     ULFMH                              65                       GLR05
     C   65              SETON                                        53                       GLR05
     C   65              EXCEPT                                                                GLR05
     C   65              SETOFF                                       53                       GLR05
      *                                                                   GLR050
     C  N65              SETON                                        50                       GLR05
     C  N65              EXCEPT                                                                GLR05
     C  N65              SETOFF                                       50                       GLR05
      *                                                                   GLR050
     C                   ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  XRFOUT- SUBROUTINE                   *                   GLR050
      *       *  OUTPUT TO CROSS REFERENCE FILE       *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     XRFOUT        BEGSR                                                                 GLR05
      *                                                                   GLR050
     C   42              Z-ADD     0             VDEPT                          CLEAR-CONSOLIDTGLR05
     C     VSERCH        COMP      LOOKSV                             9191                     GLR05
     C  N91VRTYP         COMP      TYPESV                             9191                     GLR05
      *                                                                   GLR050
     C                   MOVE      *BLANKS       XRFKEY           25                           GLR05
     C                   MOVEL     LOOKSV        XRFKEY                                        GLR05
     C                   MOVEL     VCOMP         WK10                                          GLR05
     C                   MOVE      VREPRT        WK10                                          GLR05
     C                   MOVE      WK10          XRFKEY                                        GLR05
      *                                                                   GLR050
     C     XRFKEY        CHAIN     ULREF                              66                       GLR05
      *                                                                   GLR050
     C  N91
     CANN66              SETON                                        52                       GLR05
     C  N91
     CANN66              EXCEPT                                                                GLR05
     C  N91
     CANN66              SETOFF                                       52                       GLR05
      *                                                                   GLR050
     C   91
     CANN66
     CANNU1              SETON                                        U1        PURGE 'X' STAT GLR05
     C   91
     CANN66              SETON                                        56                       GLR05
     C   91
     CANN66              EXCEPT                                                                GLR05
     C   91
     CANN66              SETOFF                                       56                       GLR05
      *                                                                   GLR050
     C   91              MOVEL     VSERCH        XRFKEY                                        GLR05
      *                                                                   GLR050
     C   91XRFKEY        CHAIN     ULREF                              66                       GLR05
      *                                                                   GLR050
     C   91
     CANN66              SETON                                        52                       GLR05
     C   91
     CANN66              EXCEPT                                                                GLR05
     C   91
     CANN66              SETOFF                                       52                       GLR05
      *                                                                   GLR050
     C   91
     CAN 66              SETON                                        55                       GLR05
     C   91
     CAN 66              EXCEPT                                                                GLR05
     C   91
     CAN 66              SETOFF                                       55                       GLR05
      *                                                                   GLR050
     C                   ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  DETOUT- SUBROUTINE                   *                   GLR050
      *       *  OUTPUT TO FORMAT DETAIL FILE         *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     DETOUT        BEGSR                                                                 GLR05
      *                                                                   GLR050
      ******   SET ON INDICATOR TO SHOW SUBROUTINE HAS BEEN EXECUTED      GLR050
      ******   (GETS SET OFF AT END OF SCROLL SUB-ROUTINE)                GLR050
      *                                                                   GLR050
     C                   SETON                                        98                       GLR05
      *                                                                   GLR050
      ******   SET ON INDICATOR 97 TO CONTROL LOADE SUBROUTINE            GLR050
      *                                                                   GLR050
     C                   SETON                                        97                       GLR05
      *                                                                   GLR050
      ******   CHAIN TO MAKE SURE HAVE CORRECT RECORD                     GLR050
     C   42              Z-ADD     0             VDEPT                          CONSOLIDATED   GLR05
      *                                                                   GLR050
     C                   MOVE      *BLANKS       WK10             10                           GLR05
     C                   MOVE      *BLANKS       WK7               7                           GLR05
     C                   MOVE      *BLANKS       DETKEY           17                           GLR05
     C                   MOVEL     VCOMP         WK10                                          GLR05
     C                   MOVE      VREPRT        WK10                                          GLR05
     C                   MOVEL     VGROUP        WK7                                           GLR05
     C                   MOVE      VLINE         WK7                                           GLR05
     C                   MOVEL     WK10          DETKEY                                        GLR05
     C                   MOVE      WK7           DETKEY                                        GLR05
     C                   SETOFF                                       656869                   GLR05
      *                                                                   GLR050
     C     DETKEY        CHAIN     ULFMI                              65                       GLR05
      *                                                                   GLR050
     C   71              SETON                                        54                       GLR05
     C   71              EXCEPT                                                                GLR05
     C   71              SETOFF                                       54                       GLR05
      *                                                                   GLR050
     C  N71              SETON                                        51                       GLR05
     C  N71              EXCEPT                                                                GLR05
     C  N71              SETOFF                                       51                       GLR05
      *                                                                   GLR050
     C                   ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  LOADC - SUBROUTINE                   *                   GLR050
      *       *  LOADS EXISTING DATA FOR SCREEN C     *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     LOADC         BEGSR                                                                 GLR05
      *                                                                   GLR050
     C   42              SETON                                        15        CONSOL-NO DEPT GLR05
     C   42              Z-ADD     0             VDEPT                          FORCE ZERO DEPTGLR05
     C   75
     CANN42              SETOFF                                       15        NOT CONSOLIDATDGLR05
      *                                                                   GLR050
     C                   SETOFF                                       6567                     GLR05
     C                   SETOFF                                       394099                   GLR05
     C                   SETOFF                                       767778                   GLR05
     C                   SETOFF                                       7916                     GLR05
     C                   SETOFF                                       2833                     GLR05
      *                                                                   GLR050
     C                   MOVE      *BLANKS       XRFLIM           25                           GLR05
     C                   MOVE      *BLANKS       WK10             10                           GLR05
     C                   MOVEL     VCOMP         WK10                                          GLR05
     C                   MOVE      VREPRT        WK10                                          GLR05
     C                   MOVE      WK10          XRFLIM                                        GLR05
     C     XRFLIM        SETLL     GLREF                                                       GLR05
     C     LOOPLC        TAG                                                                   GLR05
     C                   SETOFF                                       65                       GLR05
     C                   READ      GLREF                                  65                   GLR05
     C   65              GOTO      ELOADC                                                      GLR05
      *                                                                   GLR050
     C     VCOMP         COMP      GXCOMP                                 67                   GLR05
     C   67VREPRT        COMP      GXRPRT                                 67                   GLR05
     C   67GXSTAT        COMP      'X'                                6767      BYPASS 'X' STATGLR05
     C  N67              GOTO      LOOPLC                                                      GLR05
      *                                                                   GLR050
     C   67GXDPSQ        COMP      0                                  16                       GLR05
      *                                                                   GLR050
     C   67              Z-ADD     GXDPSQ        VDEPT                                         GLR05
     C   67
     CAN 16              MOVE      'Y'           VANS                                          GLR05
     C   67
     CANN16              MOVE      'N'           VANS                                          GLR05
     C   67              MOVEL     GXLOOK        VSERCH                                        GLR05
     C   67              Z-ADD     GXRTYP        VRTYP                                         GLR05
      *                                                                   GLR050
      ******   DETERMINE REPORT TYPE                                      GLR050
      ******   TYPE 1  =  BALANCE SHEET                                   GLR050
      ******   TYPE 2  =  INCOME STATEMENT                                GLR050
      ******   TYPE 3  =  TRIAL BALANCE                                   GLR050
      ******   TYPE 4  =  BUDGET                                          GLR050
      *                                                                   GLR050
     C   67
     CANN99GXRTYP        COMP      1                                  636376                   GLR05
     C   63
     CANN99
     CAN 67GXRTYP        COMP      2                                  636377                   GLR05
     C   63
     CANN99
     CAN 67GXRTYP        COMP      3                                  636378                   GLR05
     C   63
     CANN99
     CAN 67GXRTYP        COMP      4                                  636379                   GLR05
      *                                                                   GLR050
     C     ELOADC        ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  LOADD - SUBROUTINE                   *                   GLR050
      *       *  LOADS EXISTING DATA FOR SCREEN D     *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     LOADD         BEGSR                                                                 GLR05
      *                                                                   GLR050
     C                   SETOFF                                       6566                     GLR05
     C                   SETOFF                                       2729                     GLR05
     C                   SETOFF                                       303132                   GLR05
     C                   SETOFF                                       9941      ADDED 41       GLR05
     C                   SETON                                        34                       GLR05
      *                                                                   GLR050
     C   71              MOVE      *BLANKS       VDESC                                         GLR05
     C   71              Z-ADD     0             VSPBF                                         GLR05
     C   71              Z-ADD     1             VSPAF                                         GLR05
     C   71              Z-ADD     0             VRVSN                                         GLR05
     C   71              MOVE      *BLANKS       VPTYP                                         GLR05
      *                                                                   GLR050
     C   71              GOTO      ELOADD                                                      GLR05
      *                                                                   GLR050
     C                   MOVE      *BLANKS       HDRKEY           14                           GLR05
     C                   MOVE      *BLANKS       WK12             12                           GLR05
     C                   MOVEL     VREPRT        WK12                                          GLR05
     C                   MOVE      VGROUP        WK12                                          GLR05
     C                   MOVEL     VCOMP         HDRKEY                                        GLR05
     C                   MOVE      WK12          HDRKEY                                        GLR05
     C     HDRKEY        CHAIN     ULFMH                              65                       GLR05
     C  N65UHSTAT        COMP      'D'                                    66    WAS GHSTAT     GLR05
     C  N66              MOVE      UHDESC        VDESC                                         GLR05
     C  N66              MOVE      UHSPBF        VSPBF                                         GLR05
     C  N66              MOVE      UHSPAF        VSPAF                                         GLR05
     C  N66              MOVE      UHRVSN        VRVSN                                         GLR05
     C  N66              MOVE      UHPCOL        VPTYP                                         GLR05
     C  N66UHPCOL        COMP      '1'                                    41                   GLR05
     C  N66              MOVE      UHDPSQ        VDEPT                                         GLR05
      *                                                                   GLR050
     C     ELOADD        ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  LOADE - SUBROUTINE                   *                   GLR050
      *       *  LOADS EXISTING DATA FOR SCREEN E & F *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     LOADE         BEGSR                                                                 GLR05
      *                                                                   GLR050
     C                   SETOFF                                       353637                   GLR05
     C                   SETOFF                                       3899                     GLR05
     C                   SETOFF                                       6219                     GLR05
     C   71              SETON                                        43                       GLR05
     C   72              SETON                                        43                       GLR05
     C   75              SETON                                        43                       GLR05
      *                                                                   GLR050
     C   97              SETOFF                                       717374                   GLR05
     C   97              SETOFF                                       75                       GLR05
     C   97              SETON                                        72                       GLR05
      *                                                                   GLR050
     C   71              MOVE      'A'           VACTN                                         GLR05
     C   72              MOVE      'C'           VACTN                                         GLR05
     C                   MOVE      VACTN         ACTNCK            1                           GLR05
      *                                                                   GLR050
     C   71              Z-ADD     1             VLINE                                         GLR05
     C   71              Z-ADD     VLINE         LINHLD            3 0                         GLR05
      *                                                                   GLR050
     C  N71              Z-ADD     0             VLINE                                         GLR05
      *                                                                   GLR050
     C                   Z-ADD     VCOMP         VCOMD                                         GLR05
      *                                                                   GLR050
     C   71              GOTO      ELOADE                                                      GLR05
     C                   Z-ADD     0             Y                 2 0                         GLR05
      *                                                                   GLR050
      ******   SET LIMITS FOR READING GLFMI                               GLR050
      *                                                                   GLR050
     C                   MOVE      *BLANKS       DETLIM           17                           GLR05
     C                   MOVE      *BLANKS       WK10             10                           GLR05
     C                   MOVE      *BLANKS       WK7               7                           GLR05
     C                   MOVEL     VCOMP         WK10                                          GLR05
     C                   MOVE      VREPRT        WK10                                          GLR05
     C                   MOVEL     VGROUP        WK7                                           GLR05
     C                   MOVEL     WK10          DETLIM                                        GLR05
     C                   MOVE      WK7           DETLIM                                        GLR05
      *                                                                   GLR050
     C     DETLIM        SETLL     GLFMI                                                       GLR05
      *                                                                   GLR050
     C     LOOPLE        TAG                                                                   GLR05
     C                   SETOFF                                       65                       GLR05
     C                   READ      GLFMI                                  65                   GLR05
     C  N65VCOMP         COMP      GICOMP                             6565                     GLR05
     C  N65VREPRT        COMP      GIRPRT                             6565                     GLR05
     C  N65VGROUP        COMP      GIGRUP                             6565                     GLR05
      *                                                                   GLR050
     C   65
     CANN62              ADD       1             Y                                             GLR05
     C   65
     CANN62              MOVEL     '** END '     END9              9                           GLR05
     C   65
     CANN62              MOVE      'OF'          END9                                          GLR05
     C   65
     CANN62              MOVEL     END9          END              17                           GLR05
     C   65
     CANN62              MOVE      ' DATA **'    END                                           GLR05
     C   65
     CANN62              MOVEL     END           DES(Y)                                        GLR05
      *                                                                   GLR050
     C   65
     CAN 72              ADD       1             LINHLD                                        GLR05
      *                                                                   GLR050
     C                   ADD       1             Y                                             GLR05
      *                                                                   GLR050
     C   65              GOTO      ELOADE                                                      GLR05
      *                                                                   GLR050
     C  N62              Z-ADD     GICOMD        COM(Y)                                        GLR05
     C  N62              Z-ADD     GIGLAC        ACC(Y)                                        GLR05
     C  N62              Z-ADD     GISEQ#        LIN(Y)                                        GLR05
     C                   Z-ADD     GISEQ#        LINHLD                                        GLR05
     C  N62              MOVE      GISTAT        STA(Y)                                        GLR05
      *                                                                   GLR050
      ******   CHAIN TO GET DESCRIPTION OF ACCOUNT AND TYPE               GLR050
      *                                                                   GLR050
     C  N62              MOVEL     GICOMD        GLKEY            10                           GLR05
     C  N62              MOVE      GIGLAC        GLKEY                                         GLR05
     C  N62GLKEY         CHAIN     MGLCH                              65                       GLR05
     C  N65
     CANN62              MOVEL     GCDESC        DES(Y)                                        GLR05
     C  N65
     CANN62              Z-ADD     GCATYP        TYP(Y)                                        GLR05
     C     Y             COMP      10                                 62  62                   GLR05
      *                                                                   GLR050
     C                   GOTO      LOOPLE                                                      GLR05
      *                                                                   GLR050
     C     ELOADE        ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  SCROLL- SUBROUTINE                   *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
      *  THIS SUBROUTINE ROLLS THE BOTTOM OF SCREENS 'E' AND 'F'          GLR050
      *  IT RE-LOADS THE ARRAYS                                           GLR050
      *                                                                   GLR050
     C     SCROLL        BEGSR                                                                 GLR05
     C                   SETOFF                                       62                       GLR05
      ******   SET LIMITS FOR READING GLFMI                               GLR050
      *                                                                   GLR050
     C                   MOVE      *BLANKS       DETLIM           17                           GLR05
     C                   MOVE      *BLANKS       WK10             10                           GLR05
     C                   MOVE      *BLANKS       WK7               7                           GLR05
     C                   MOVEL     VCOMP         WK10                                          GLR05
     C                   MOVE      VREPRT        WK10                                          GLR05
     C                   MOVEL     VGROUP        WK7                                           GLR05
     C                   MOVEL     WK10          DETLIM                                        GLR05
     C                   MOVE      WK7           DETLIM                                        GLR05
      *                                                                   GLR050
     C     LIN(10)       COMP      0                                      62                   GLR05
     C   62
     CANN99              MOVE      '   '         DETLIM                                        GLR05
     C  N62LIN(10)       ADD       1             SQWRK             3 0                         GLR05
     C  N62              MOVE      SQWRK         DETLIM                                        GLR05
     C  N62              MOVE      *BLANKS       STA                                           GLR05
     C  N62              MOVE      *BLANKS       DES                                           GLR05
     C  N62              Z-ADD     0             COM                                           GLR05
     C  N62              Z-ADD     0             ACC                                           GLR05
     C  N62              MOVE      *BLANKS       TYP                                           GLR05
     C  N62              Z-ADD     0             LIN                                           GLR05
     C   98              MOVE      LIN(1)        DETLIM                                        GLR05
     C   98
     CAN 71
     CANN62              MOVE      LINHLD        DETLIM                                        GLR05
     C     DETLIM        SETLL     GLFMI                                                       GLR05
     C                   Z-ADD     0             Y                                             GLR05
     C     LOOPSC        TAG                                                                   GLR05
     C                   SETOFF                                       6463                     GLR05
     C                   READ      GLFMI                                  64                   GLR05
     C  N64GICOMP        COMP      VCOMP                              6464                     GLR05
     C  N64GIRPRT        COMP      VREPRT                             6464                     GLR05
     C  N64GIGRUP        COMP      VGROUP                             6464                     GLR05
      *                                                                   GLR050
     C   64              ADD       1             Y                                             GLR05
     C   64              MOVEL     '** END '     END8              9                           GLR05
     C   64              MOVE      'OF'          END8                                          GLR05
     C   64              MOVEL     END8          END              17                           GLR05
     C   64              MOVE      ' DATA **'    END                                           GLR05
     C   64              MOVEL     END           DES(Y)                                        GLR05
     C   64              GOTO      ARNDSC                                                      GLR05
     C                   ADD       1             Y                                             GLR05
     C                   Z-ADD     GICOMD        COM(Y)                                        GLR05
     C                   Z-ADD     GIGLAC        ACC(Y)                                        GLR05
     C                   Z-ADD     GISEQ#        LIN(Y)                                        GLR05
     C                   MOVE      GISTAT        STA(Y)                                        GLR05
      *                                                                   GLR050
      ******   CHAIN TO GET DESCRIPTION OF ACCOUNT                        GLR050
      *                                                                   GLR050
     C                   MOVEL     GICOMD        GLKEY            10                           GLR05
     C                   MOVE      GIGLAC        GLKEY                                         GLR05
     C     GLKEY         CHAIN     MGLCH                              65                       GLR05
     C  N65              MOVEL     GCDESC        DES(Y)                                        GLR05
     C  N65              Z-ADD     GCATYP        TYP(Y)                                        GLR05
     C     Y             COMP      10                                 62  62                   GLR05
     C  N62              GOTO      LOOPSC                                                      GLR05
      *                                                                   GLR050
      *  RE-DISPLAY CORRECT SCREEN.                                       GLR050
      *                                                                   GLR050
     C     ARNDSC        TAG                                                                   GLR05
      *                                                                   GLR050
      ******   IF SCROLLING FROM KE COMMAND SCREEN 'E' - SW 45 IS ON      GLR050
      *                                                                   GLR050
     C   71
     CANN45              ADD       1             LINHLD                                        GLR05
     C   71
     CANN45              Z-ADD     LINHLD        VLINE                                         GLR05
     C   72
     CANN45              Z-ADD     0             VLINE                                         GLR05
     C   71              SETON                                        37                       GLR05
     C   71              SETOFF                                       43                       GLR05
      *                                                                   GLR050
     C  N71              SETON                                        36                       GLR05
     C  N71
     CANN45              SETON                                        43                       GLR05
      *                                                                   GLR050
      ******   IF SCROLLING FROM KE COMMAND SCREEN 'F'                    GLR050
      ******   SWITCH 47 WILL BE ON                                       GLR050
      *                                                                   GLR050
     C   47              SETON                                        87                       GLR05
     C   87              EXCEPT                                                                GLR05
     C   87              SETOFF                                       8798                     GLR05
     C   47              GOTO      ESCROL                                                      GLR05
      *                                                                   GLR050
     C                   SETON                                        86                       GLR05
     C   86              EXCEPT                                                                GLR05
     C   86              SETOFF                                       8698                     GLR05
      *                                                                   GLR050
     C     ESCROL        ENDSR                                                                 GLR05
      *                                                                   GLR050
      *       *****************************************                   GLR050
      *       *  CLEAR - SUBROUTINE                   *                   GLR050
      *       *****************************************                   GLR050
      *                                                                   GLR050
     C     CLEAR         BEGSR                                                                 GLR05
      *                                                                   GLR050
     C                   SETOFF                                       808182                   GLR05
     C                   SETOFF                                       838485                   GLR05
     C                   SETOFF                                       8687                     GLR05
     C                   SETOFF                                       99                       GLR05
     C                   SETOFF                                       202122                   GLR05
     C                   SETOFF                                       232425                   GLR05
     C                   SETOFF                                       262728                   GLR05
     C                   SETOFF                                       293031                   GLR05
     C                   SETOFF                                       3233                     GLR05
     C                   SETOFF                                       353637                   GLR05
     C                   SETOFF                                       383940                   GLR05
     C                   SETOFF                                       414219                   GLR05
     C                   SETON                                        344390                   GLR05
     C                   SETON                                        4449                     GLR05
     C                   SETOFF                                       955958                   GLR05
     C                   SETOFF                                       929394                   GLR05
     C                   SETOFF                                       151718                   GLR05
      *                                                                   GLR050
     C                   Z-ADD     0             VGLACC                                        GLR05
     C                   MOVE      *BLANKS       VYES              3                           GLR05
     C                   MOVE      *BLANKS       LOOKSV           15                           GLR05
     C                   Z-ADD     0             TYPESV            1 0                         GLR05
     C                   Z-ADD     0             DEPTSV            4 0                         GLR05
     C  N48              MOVE      'A'           VCODE                                         GLR05
     C  N48              MOVE      *BLANKS       VREPRT                                        GLR05
     C                   MOVE      *BLANKS       VDESC                                         GLR05
     C  N48              Z-ADD     0             VDEPT                                         GLR05
     C  N48              MOVE      'N'           VANS              1                           GLR05
     C                   MOVE      *BLANKS       VSEARC                                        GLR05
     C                   MOVE      *BLANKS       VSERCH                                        GLR05
     C                   Z-ADD     0             VRTYP                                         GLR05
     C  N48              Z-ADD     20            VGROUP                                        GLR05
     C  N48              Z-ADD     0             VCOMP                                         GLR05
     C                   MOVE      *BLANKS       VNAME                                         GLR05
     C                   MOVE      *BLANKS       VCONAM                                        GLR05
     C                   Z-ADD     0             VSPBF                                         GLR05
     C                   Z-ADD     1             VSPAF                                         GLR05
     C                   Z-ADD     0             VRVSN                                         GLR05
     C                   MOVE      *BLANKS       VPTYP                                         GLR05
     C                   MOVE      *BLANKS       LIN                                           GLR05
     C                   MOVE      *BLANKS       COM                                           GLR05
     C                   MOVE      *BLANKS       ACC                                           GLR05
     C                   MOVE      *BLANKS       DES                                           GLR05
     C                   MOVE      *BLANKS       TYP                                           GLR05
     C                   MOVE      *BLANKS       STA                                           GLR05
      *                                                                   GLR050
     C                   SETON                                        80                       GLR05
      *                                                                   GLR050
     C                   ENDSR                                                                 GLR05
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      *                                                                   GLR050
**  ERROR MESSAGES
             Both Entries Not Allowed                        1
           Both Entried Cannot Be Blank                      2
   Invalid Action Code - Must Be A,C,D,R, or I               3
            Can't Add, Record Exists                         4
       Can't Update, Record Doesn't Exist                    5
     Can't Reactivate, Record Doesn't Exist                  6
        Can't Delete, Record Doesn't Exist                   7
       Can't Inquire, Record Doesn't Exist                   8
       Can't Update, Must Reactivate First                   9
             Record Currently Active                         10
              Record Already Deleted                         11
     Add                                                     12
   Change                                                    13
   Delete                                                    14
             Invalid Company Number                          15
     Group Number Cannot Be Blank or Negative                16
        Report Reference Cannot Be Blank                     17
     Invalid Action Code - Must Be A,C,D or R                18
         Invalid General Ledger Account                      19
    Invalid Entry - Must Be In Range 0 - 3                   20
     Invalid Entry - Must Be In Range 1 - 2                  21
   Invalid - Must Be 0, Positive Number, H or T              22
            Line Number Cannot Be Zero                       23
       Account Tyoe Invalid For Report Type                  24
              Field Cannot Be Blank                          25
         Type Must Be Number 1 Through 4                     26
 Company # Must Agree With Number on First Screen            27
      Invalid Entry - Must Be 'Y-E-S' or Blank               28
  Must Be Blank For Trial Balance(Report Type 3)             29
         Invalid Entry - Must Be 'Y' or 'N'                  30
  For Departmental Format, Must Show Dept Number             31
        For Company Report, Must Be '0000'                   32
     Cannot Change A Detail Record Line Type                 33
  Line Type Zero (TEXT) Must Have a Sign of Zero             34
