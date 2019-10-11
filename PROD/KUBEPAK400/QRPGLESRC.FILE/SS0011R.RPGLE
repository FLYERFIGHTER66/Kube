      *%*******************************************************************
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- KUBEPAK                                         **
      *%                                                               ?**
      *********************************************************************
      *                                                                   *
      * Program?- SS0011R                                                *
      *                                                                   *
      * Purpose?- Security - User Master Maintenance Selection           *
      *                                                                   *
      *   Date  ?Programmer       ?  Comment                         ? *
      *  8/9/2003  Richard E. Piasecki  Program Created                   *
      *                                                                   *
      *********************************************************************
     FSECUSER   UF   E           K DISK
     FSECSYS    IF   E           K DISK
     FSS0011S   CF   E             WORKSTN
     F                                     SFILE(S1DATA:S1RRN)
     F                                     SFILE(S2DATA:S2RRN)
     F                                     INFDS(INFDS3)
      ********************************************************************
      * ?Tables & Arrays                                                ?*
      ********************************************************************
     D OPT             S              9    DIM(2) CTDATA PERRCD(1)
     D VOP             S              1    DIM(9)
     D OTX             S             70    DIM(2) CTDATA PERRCD(1)
      ********************************************************************
      * ?File Information Data Structure                                ?*
      ********************************************************************
     D INFDS2          DS
     D  $2RRN#               397    400B 0
      ********************************************************************
      * ?File Information Data Structure                                ?*
      ********************************************************************
     D INFDS3          DS
      *   Display File name (internal RPG name)
     D  $3FILN           *FILE
      *   Record format ID for last record input
     D  $3RCDF           *RECORD
      *   AID byte: identifies which function key was pressed:
     D  $3AID                369    369
      *   Current Cursor row and column (Binary)
     D  $3CURP               370    371B 0
      *    Low Relative Record # on SFLPAG
     D  PAGRRN               378    379B 0
      *    Relative Record # of Last Changed Record in SFLRCD
     D  $3RRN#               397    400B 0
      ********************************************************************
      * ?Program Status Data Structure                                  ?*
      ********************************************************************
     D                SDS
     D  ##PGM            *PROC
     D  ##PARM           *PARMS
     D  ##PERR                91    169
     D  ##JOB                244    253
     D  ##USER               254    263
     D  ##JOBN               264    269
     D  ##JBDT               276    281  0
     D  ##JBTM               282    287  0
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
     D YES             C                   CONST('YES')
     D NO              C                   CONST('NO ')
     D DFTVAL          C                   CONST('*DEFAULT  ')
     D NONE            C                   CONST('*NONE')
     D @ZRO10          C                   CONST('0000000000')
      *
      ********************************************************************
      ********************************************************************
      ******************  Program Main Line?  ***************************
      ********************************************************************
      ********************************************************************
      *
      *? Program Main Loop                                ?             ?
      *
     C     ENDPGM        DOWNE     YES
      *
      *? Write Cmd Key, Msgsfl                            ?
      *
     C                   WRITE     CFKY01
     C                   WRITE     MSGCTL
     C                   EXFMT     S1CNTL
      *
      *? Move 1st RRN for Current SFL Page to ##RRNO      ?             ?
      *
     C                   Z-ADD     PAGRRN        ##RRNO
      *
      *? Reset Cursor Position                            ?             ?
      *
     C                   Z-ADD     *ZERO         ##ROW
     C                   Z-ADD     *ZERO         ##COL
      *
      *? Clear Error indicators and flags                       ?
      *
     C                   MOVEA     '00000000'    *IN(31)                        CLR *IN31-38
     C                   MOVEA     '00000000'    *IN(39)                        CLR *IN39-46
     C                   MOVEA     '000'         *IN(47)                        CLR *IN47-49
     C                   MOVE      *BLANKS       ERROR             3
      *
      *? Clear Messages                                   ?
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN
      *
      * ?SFL Input Selection                          ?
      *
     C                   SELECT
      *
      * ?F3 or F12 pressed                                ?
     C     *IN03         WHENEQ    *ON
     C     *IN12         OREQ      *ON
     C                   MOVE      YES           ENDPGM            3
      *
      *? F1 - Cursor Help                                 ?
     C     *IN01         WHENEQ    '1'
     C                   EXSR      SRCHLP
      *
      *?  F6 - Add new User
     C     *IN06         WHENEQ    '1'
     C                   CLEAR                   #PUSID
     C                   CALL      'SS0012R '                           69
     C                   PARM                    #ESYS
     C                   PARM                    #PUSID
     C     #PUSID        IFNE      *BLANKS
     C                   MOVE      #PUSID        C1USID
     C                   EXSR      LOADSF
     C                   END
      *? Position to requested -- change in CHAIN/NAME    ?
     C     *IN28         WHENEQ    *ON
     C                   EXSR      LOADSF
      *
      *    ?Postioned Past EOF, Load Prior Page if Not BOF
     C     S1RRN         IFEQ      *ZEROS
     C     $$BOF         IFNE      *ON
     C                   EXSR      BACKSF
     C                   ELSE
      *    ?ELSE  Subfile Empty Write One Blank SFL Record (ND PR)
     C                   MOVE      'SS00102'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   EXSR      BLNKSF
     C                   ENDIF
     C                   ENDIF
      *
      *? F11 - Change view                                ?
     C     *IN11         WHENEQ    '1'
     C     WKVIEW        IFEQ      1
     C                   Z-ADD     2             WKVIEW
     C                   ELSE
     C                   Z-ADD     1             WKVIEW
     C                   ENDIF
     C                   EXSR      $FLHDG
     C     PAGRRN        CHAIN     S1DATA                             99
     C                   MOVEL     S1USID        C1USID
     C                   MOVE      *ON           *IN28
     C                   EXSR      LOADSF
      *
      * ?RollDown                                         ?
     C     *IN27         WHENEQ    *ON
     C     $$BOF         IFEQ      *ON
     C                   Z-ADD     1             ##RRNO
     C                   MOVE      'SR00001'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ELSE
      *??If No Errors Found in READSF Execute Roll Back
     C                   EXSR      READSF
     C     ERROR         IFNE      YES
     C                   EXSR      BACKSF
     C                   ENDIF
     C                   ENDIF
      *
      * ?Rollup                                           ?
     C     *IN26         WHENEQ    *ON
     C     $EOF          IFEQ      *OFF
     C                   EXSR      LOAD##
     C                   ELSE
     C                   MOVE      'SR00002'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   END
      *? Process SFL Input               ?
     C     $$LOAD        WHENEQ    '1'
     C                   EXSR      READSF
     C***                  MOVE 'SR00101' $#MSID           ?Message Id   ?
     C***                  EXSR SRMSGF
      *? No Records Loaded to SFL
     C                   OTHER
     C                   Z-ADD     1             ##RRNO
     C                   MOVE      'SR00102'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
      *? End the program                                  ?             ?
      *
     C                   MOVE      '1'           *INLR
      *
      ********************************************************************
      ********************************************************************
      ********************  End Main Line?  *****************************
      ********************************************************************
      ********************************************************************
      *
      ********************************************************************
      * ?LOADSF - Load the System Master Display                        ?*
      ********************************************************************
     CSR   LOADSF        BEGSR
      *
      *? Set Roll Forward by Load Factor set in *INZSR                  ?
      *
     C****       #SFLPG    MULT ##LOAD    ##ROLL
      *
      *? Clear the subfile                                ?             ?
      *
     C                   MOVE      *ON           *IN80
     C                   Z-ADD     *ZERO         S1RRN             5 0
     C                   Z-ADD     *ZERO         MXRRN             5 0
     C                   WRITE     S1CNTL
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN96
     C                   MOVE      *OFF          $$LOAD            1
     C                   MOVE      *OFF          $$BOF             1
     C                   MOVE      *OFF          *IN81
      *
      *? Save Position To Values for Roll Back Routine?             ?
     C                   MOVEL     C1USID        SVUSID
      *
      *? Set File Position                                ?             ?
     C     *IN28         IFEQ      *OFF
     C                   MOVE      *LOVAL        USUSID
     C                   ELSE
     C                   MOVEL     C1USID        USUSID
     C                   ENDIF
      *
      *? Check for BOF                                    ?             ?
     C     USKEY         SETLL     USERR
     C     USSYS         READPE    USERR                                  66
     C     *IN66         IFEQ      *ON
     C                   MOVE      *ON           $$BOF             1
     C                   ENDIF
      *
      *? Reposition after BOF Check                       ?             ?
     C     *IN28         IFEQ      *OFF
     C                   MOVE      *LOVAL        USUSID
     C                   ELSE
     C                   MOVEL     C1USID        USUSID
     C                   ENDIF
      *
      *? Set file pointer                                               ?
     C     USKEY         SETLL     USERR
      *
     C                   CLEAR                   C1USID
     C                   MOVE      *OFF          $EXLOD            1
     C                   MOVE      *OFF          $EOF              1
     C                   MOVE      *ON           *IN81
      *
      *? Read Loop                                        ?             ?
      *
     C     $EXLOD        DOUEQ     *ON
     C     USSYS         READE     USERR                                  66
     C     *IN66         IFEQ      *ON
     C                   MOVE      *ON           $EOF              1
     C                   MOVE      *ON           $EXLOD            1
     C                   MOVE      *OFF          *IN81
     C                   ELSE
      *
      *? Initialize SFL Record Field Values               ?
     C                   EXSR      MOV@S1
      *
     C                   MOVE      *BLANK        S1SEL
      *
     C                   ADD       1             S1RRN
     C                   WRITE     S1DATA
     C****       S1RRN     IFEQ ##ROLL
     C     S1RRN         IFEQ      26
     C                   MOVE      *ON           $EXLOD
     C                   END
      *
     C                   END
     C                   END
      *
      *? If records loaded                                ?             ?
      *
     C     S1RRN         IFGT      *ZERO
     C                   Z-ADD     1             ##RRNO
     C                   Z-ADD     S1RRN         MXRRN
     C                   MOVE      *ON           $$LOAD            1
     C                   MOVE      'SS00102'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   ELSE
      *
      *? If no records loaded                             ?
      *
     C                   MOVE      *OFF          $$LOAD            1
     C                   EXSR      BLNKSF
     C                   MOVE      'CB00102'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   END
      *
     CSR                 ENDSR
      ********************************************************************
      * ?LOAD## - Load the System Master Display                        ?*
      ********************************************************************
     CSR   LOAD##        BEGSR
      *
      *? Set Roll to SFLPAG * Roll Forward Factor                       ?
      *
     C****       #SFLPG    MULT ##FWRL    ##ROLL
      *
      *? Read Loop                                        ?             ?
      *
     C                   MOVE      *OFF          $EXLOD            1
     C                   MOVE      *OFF          $EOF
     C                   MOVE      *ON           *IN81
     C                   Z-ADD     *ZEROS        $COUNT            5 0
     C                   Z-ADD     MXRRN         S1RRN
     C     $EXLOD        DOUEQ     *ON
     C     USSYS         READE     USERR                                  66
     C     *IN66         IFEQ      *ON
     C                   MOVE      *ON           $EOF              1
     C                   MOVE      *ON           $EXLOD            1
     C                   MOVE      *OFF          *IN81
     C                   ELSE
      *
      *? Initialize SFL Record Field Values               ?
     C                   EXSR      MOV@S1
     C                   MOVE      *BLANK        S1SEL
      *
      *
      *? Write subfile record                             ?
     C                   ADD       1             S1RRN
     C                   ADD       1             $COUNT            5 0
     C                   WRITE     S1DATA
     C****       $COUNT    IFEQ ##ROLL
     C     $COUNT        IFEQ      13
     C                   MOVE      *ON           $EXLOD
     C                   END
      *
     C                   END
     C                   END
      *
      *? If records loaded                                ?             ?
      *
     C     $COUNT        IFGT      *ZERO
     C                   Z-ADD     S1RRN         ##RRNO
     C                   Z-ADD     S1RRN         MXRRN
     C                   ELSE
      *
      *? If no records loaded                             ?
      *
     C                   END
      *
     CSR                 ENDSR
      *****************************************************************
      * ?MOV@S1 - Move File Fields to SFL Display Output Fields     ? *
      *****************************************************************
     CSR   MOV@S1        BEGSR
      *
      *
      * ?Master File Fields.                    ?
      *?
     C                   MOVEL     USUSID        S1USID
      *
     C     WKVIEW        IFEQ      1
     C                   MOVEL     USFL01        S1FL01
     C                   MOVEL     USFL02        S1FL02
     C                   MOVEL     USFL03        S1FL03
     C                   MOVEL     USFL04        S1FL04
     C                   MOVEL     USFL05        S1FL05
     C                   MOVEL     USFL06        S1FL06
     C                   MOVEL     USFL07        S1FL07
     C                   MOVEL     USFL08        S1FL08
     C                   MOVEL     USFL09        S1FL09
     C                   MOVEL     USFL10        S1FL10
     C                   ELSE
     C                   MOVEL     USFL11        S1FL01
     C                   MOVEL     USFL12        S1FL02
     C                   MOVEL     USFL13        S1FL03
     C                   MOVEL     USFL14        S1FL04
     C                   MOVEL     USFL15        S1FL05
     C                   MOVEL     USFL16        S1FL06
     C                   MOVEL     USFL17        S1FL07
     C                   MOVEL     USFL18        S1FL08
     C                   MOVEL     USFL19        S1FL09
     C                   MOVEL     USFL20        S1FL10
     C                   ENDIF
      *
     CSR                 ENDSR
      *****************************************************************
      * ?BACKSF - Roll Back File One Page of SFL Records            ? *
      *****************************************************************
     CSR   BACKSF        BEGSR
      *
      *? Restore Saved Position to Fields from last SFL Load            ?
      *
     C                   MOVE      SVUSID        C1USID
      *
      *? Set Roll Factor Based on Current SFL Mode  (Fold/Drop)         ?
      *
     C***        ##SFLM    IFEQ *OFF
     C***                  Z-ADD#SFLPG    ##ROLL           SFL Drop Mode
     C***                  ELSE
      *? Set Roll to SFLPAG * Roll Forward Factor                       ?
     C***        #SFLPG    MULT ##FWRL    ##ROLL           SFL Fold Mode
     C***                  END
      *
     C                   MOVE      C1USID        USUSID
     C     USKEY         SETLL     USERR
      *
     C****       1         DO   ##ROLL
     C     1             DO        13
     C     USSYS         READPE    USERR                                  66
     C     *IN66         IFEQ      *ON
     C                   MOVE      *LOVAL        SYSYS
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVE      USUSID        C1USID
     C                   MOVE      *ON           *IN28
     C                   EXSR      LOADSF
      *
     CSR                 ENDSR
      ********************************************************************
      * ?READSF - Read the subfile -- check for subfile selections and  ?*
      * ?         check for change to sequence number                   ?*
      ********************************************************************
     CSR   READSF        BEGSR
      *
      *? Check and process delete requests                ?             ?
      *
     C                   MOVE      *OFF          $$RLOD            1
     C                   EXSR      SRDEL
      *
      *? Set loop -- read all changed subfile records     ?             ?
      *
     C     *IN66         DOUEQ     *ON
     C                   READC     S1DATA                                 66
     C     *IN66         IFEQ      *OFF
      *
      *
      *? If Subfile option entered                        ?
      *
     C     S1SEL         IFNE      *BLANK
     C                   Z-ADD     S1RRN         ##RRNO
     C                   CLEAR                   *IN91
     C     S1SEL         LOOKUP    VOP                                    91
      *
      *? Selection 1 - Select                            ?
      *
     C                   SELECT
     C     S1SEL         WHENEQ    '1'
     C     *IN91         ANDEQ     *ON
     C                   MOVE      S1USID        #EUSID
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
      *? Selection 2 - Execute                            ?
      *
     C     S1SEL         WHENEQ    '2'
     C     *IN91         ANDEQ     *ON
     C                   MOVE      #ESYS         #PSYS
     C                   MOVE      S1USID        #PUSID
     C                   CALL      'SS0012R '                           69
     C                   PARM                    #PSYS
     C                   PARM                    #PUSID
     C     #PUSID        IFEQ      'XX'                                         F3=EXIT
     C                   MOVE      *ON           *IN66
     C                   END
     C     #PUSID        IFNE      *BLANKS
     C                   MOVE      #PUSID        C1USID
     C                   MOVE      *ON           $$RLOD            1
     C                   END
     C                   CLEAR                   S1SEL
      *
      *? Invalid Option entered                           ?
      *
     C                   OTHER
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN39
     C                   MOVE      *OFF          $$RLOD
     C                   MOVE      'SR00003'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
     C                   MOVE      YES           ERROR             3
     C                   CLEAR                   C1USID
     C                   ENDSL
     C                   END
      *
      *? Reset Indicators and Update subfile              ?
      *
     C                   UPDATE    S1DATA
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN39
     C     ERROR         IFEQ      YES
     C                   LEAVE                                                   END LOOP
     C                   END
     C                   END
     C                   END
      *
     C     $$RLOD        IFEQ      *ON
     C                   MOVE      *ON           *IN28
     C                   EXSR      LOADSF
     C                   END
      *
     CSR                 ENDSR
      ********************************************************************
      * ?SRDEL  - Check for Delete option and process                   ?*
      ********************************************************************
     CSR   SRDEL         BEGSR
      *
      *?   Clear the subfile                              ?             ?
      *
     C                   MOVE      *ON           *IN82
     C                   Z-ADD     *ZERO         S2RRN             5 0
     C                   WRITE     S2CNTL
     C                   CLEAR                   S2DATA
     C                   MOVE      *OFF          *IN82
      *
      *? Set loop -- read all changed subfile records     ?             ?
      *
     C     *IN66         DOUEQ     '1'
     C                   READC     S1DATA                                 66
     C     *IN66         IFEQ      *OFF
      *
      *? Set Subfile Next Change                          ?             ?
      *
     C                   MOVE      *ON           *IN39
      *
      *? Selection 4 - Delete                             ?             ?
      *
     C     S1SEL         LOOKUP    VOP                                    91
     C     S1SEL         IFEQ      '4'
     C     *IN91         ANDEQ     *ON
     C                   ADD       1             S2RRN
     C                   WRITE     S2DATA
     C                   CLEAR                   S1SEL
     C                   MOVE      *OFF          *IN39
     C                   END
      *
      *? Update Subfile 1                                 ?             ?
      *
     C                   UPDATE    S1DATA
     C                   END
     C                   END
      *
      *? If valid delete requested - process              ?             ?
      *
     C     S2RRN         IFGT      *ZEROS
     C                   Z-ADD     1             #2RRNO
      *
      *? Save number of records                           ?             ?
      *
     C                   Z-ADD     S2RRN         $2RRN             5 0
      *
      *? Delete message                                   ?             ?
      *
     C                   MOVE      'SR00004'     $#MSID                         ?Message Id   ?
     C                   EXSR      SRMSGF
      *
      *? Display the screen                               ?             ?
      *
     C                   WRITE     CFKY02
     C                   WRITE     MSGCTL
     C                   EXFMT     S2CNTL
      *
      *? Process each subfile record                      ?             ?
      *
     C     *IN12         IFEQ      *OFF
     C     1             DO        $2RRN         $$RRN             5 0
     C     $$RRN         CHAIN     S2DATA                             66
     C     *IN66         IFEQ      *OFF
     C                   MOVE      *ON           $$RLOD
     C                   MOVE      S1USID        USUSID
     C     USKEY         CHAIN     USERR                              67
     C     *IN67         IFEQ      *OFF
     C                   DELETE    USERR
     C                   END
     C                   END
     C                   END       1
     C                   END
      *
      *? Clear Messages                                   ?             ?
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
     C                   END
      *
     CSR                 ENDSR
      ********************************************************************
      * ?BLNKSF - Clear the subfile and write one blank record          ?*
      ********************************************************************
     CSR   BLNKSF        BEGSR
      *
      * ?Clear Subfile Fields                             ?
      *
     C                   CLEAR                   S1DATA
      *
      *? Clear the subfile                                ?             ?
      *
     C                   MOVE      *ON           *IN80
     C                   Z-ADD     *ZERO         S1RRN             5 0
     C                   Z-ADD     1             ##RRNO
     C                   WRITE     S1CNTL
      *
      *? Write a blank, non-display record                ?             ?
      *
     C                   MOVE      *ON           *IN96
     C                   ADD       1             S1RRN
     C                   WRITE     S1DATA
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN96
      *
     CSR                 ENDSR
      ********************************************************************
      * ?$FLHDG - Fill column headings from system file                 ?*
      ********************************************************************
     CSR   $FLHDG        BEGSR
      *
      *? Fill headings 1-10 or 11-20 based on current view              ?
      *
     C     WKVIEW        IFEQ      1
     C                   MOVEL     SYCH01        S1CH01
     C                   MOVEL     SYCH02        S1CH02
     C                   MOVEL     SYCH03        S1CH03
     C                   MOVEL     SYCH04        S1CH04
     C                   MOVEL     SYCH05        S1CH05
     C                   MOVEL     SYCH06        S1CH06
     C                   MOVEL     SYCH07        S1CH07
     C                   MOVEL     SYCH08        S1CH08
     C                   MOVEL     SYCH09        S1CH09
     C                   MOVEL     SYCH10        S1CH10
     C                   ELSE
     C                   MOVEL     SYCH11        S1CH01
     C                   MOVEL     SYCH12        S1CH02
     C                   MOVEL     SYCH13        S1CH03
     C                   MOVEL     SYCH14        S1CH04
     C                   MOVEL     SYCH15        S1CH05
     C                   MOVEL     SYCH16        S1CH06
     C                   MOVEL     SYCH17        S1CH07
     C                   MOVEL     SYCH18        S1CH08
     C                   MOVEL     SYCH19        S1CH09
     C                   MOVEL     SYCH20        S1CH10
     C                   ENDIF
      *
      *? Don't display underline for blank options                      ?
      *
     C                   MOVEA     @ZRO10        *IN(51)
      *
     C     S1CH01        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN51
     C                   ENDIF
      *
     C     S1CH02        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN52
     C                   ENDIF
      *
     C     S1CH03        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN53
     C                   ENDIF
      *
     C     S1CH04        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN54
     C                   ENDIF
      *
     C     S1CH05        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN55
     C                   ENDIF
      *
     C     S1CH06        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN56
     C                   ENDIF
      *
     C     S1CH07        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN57
     C                   ENDIF
      *
     C     S1CH08        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN58
     C                   ENDIF
      *
     C     S1CH09        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN59
     C                   ENDIF
      *
     C     S1CH10        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      * ?SRMSGF - Clear or send messages to Pgm msg queue               ?*
      ********************************************************************
     CSR   SRMSGF        BEGSR
      *
      *? Define Parameter List - define variables         ?
      *
     C     PLMSGF        PLIST
     C                   PARM                    $#PGMQ           10            Pgm Msg Queue
     C                   PARM                    $#MSGF           10            Message File
     C                   PARM                    $#MSGL           10            Library
     C                   PARM                    $#MSID            7            Message Id
     C                   PARM                    $#MSGD           80            Message Data
     C                   PARM                    $#MSKY            4            Message Key
     C                   PARM                    $#MSFN            1            Send or Clear
      *
      *? Call Msg processing CL                           ?
      *
     C                   CALL      'XAMSFC'      PLMSGF
      *
     C                   ENDSR
      *****************************************************************
      * ?SRCHLP - Cursor Sensitive Help                             ? *
      * ?                                                           ? *
      * ?         This subroutine will call the program to display  ? *
      * ?         field level help, check for returned values and   ? *
      * ?         move the field value to the screen field.         ? *
      * ?                                                           ? *
      * ?This subroutine was created by the CRTSRCHLP Command       ? *
      * ?                                                           ? *
      *****************************************************************
     CSR   SRCHLP        BEGSR
      *
      * ?Save Indicators                                  ?
      *
     C                   MOVE      *IN66         @@IN66            1
     C                   MOVE      *IN69         @@IN69            1
      *
      * ?Retain Current Cursor Position                   ?
      *
     C     $3CURP        DIV       256           ##ROW
     C                   MVR                     ##COL
      *
      * ?Call Cursor Help Program                         ?
      *
     C                   CALL      'XACHLPC'                            69
     C                   PARM                    ##FLD
     C                   PARM                    $3CURP
     C                   PARM                    ##PGM
     C                   PARM                    ##RCD
      *
      * ?Restore Indicators                               ?
      *
     C                   MOVE      @@IN66        *IN66
     C                   MOVE      @@IN69        *IN69
      *
     CSR                 ENDSR
      ********************************************************************
      * ?       Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
      *
      *?*ENTRY parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM                    #ESYS            10
     C                   PARM                    #EUSID           10
      *
      *?If program called with *ENTRY parm, allow select
      *
     C     ##PARM        IFGT      1
     C                   Z-ADD     1             O#                1 0
     C                   ELSE
     C                   Z-ADD     2             O#
     C                   ENDIF
      *
      *?Set valid options & options text
      *
     C                   MOVEA     OPT(O#)       VOP
     C                   MOVE      OTX(O#)       C1OPTN
      *
      *?Set initial view
      *
     C                   Z-ADD     1             WKVIEW            1 0
      *
      *?Get system record & fill control record headings
      *
     C     #ESYS         CHAIN     SYSTM                              99
     C                   EXSR      $FLHDG
      *
      *?Define key lists
      *
     C     USKEY         KLIST
     C                   KFLD                    USSYS
     C                   KFLD                    USUSID
      *
     C                   MOVEL     #ESYS         USSYS
      *
      * Define *LIKE Fields ?
      *
     C     *LIKE         DEFINE    #SFLPG        ##ROLL
     C     *LIKE         DEFINE    #SFLPG        ##FWRL
     C     *LIKE         DEFINE    #SFLPG        ##LOAD
     C     *LIKE         DEFINE    USUSID        SVUSID
     C     *LIKE         DEFINE    USSYS         #PSYS
     C     *LIKE         DEFINE    USUSID        #PUSID
      *
      * Define Key Lists ?
      *
      *
      *? Initialize values for message subfile            ?             ?
      *
     C                   MOVE      ##PGM         $#PGMQ           10            ?Pgm Msg Queue?
     C                   MOVEL     'KPMSGF'      $#MSGF           10            ?Msg File N/A ?
     C                   MOVEL     '*LIBL'       $#MSGL           10            ?Library  N/A ?
      *
      *? Clear Message Subfile -- set function to send    ?             ?
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *
      *? Initial subfile load                             ?             ?
      *
     C                   MOVE      *OFF          $$LOAD            1
      *
      *?Set initial subfile mode - Fold/Truncate  ECT...           *OFF/*ON
     C***                  MOVE *ON       *IN83            SFLMODE Fold/Trnc.
     C***                  MOVE *IN83     ##SFLM
      *
      *?Set  SFL PAGE Size and SFL Size
      *?#FWRL - Multiple Page Size by # of Pages to LOAD on ROLL FWD/BACK
      *?#LOAD - Multiple Page Size by # of Pages to LOAD on POSITION TO
     C                   Z-ADD     12            #SFLPG            4 0          SFLPAG(7) Folded Siz
     C                   Z-ADD     2             ##FWRL                         SFL Roll Forward 14
     C                   Z-ADD     4             ##LOAD                         SFL Load 28 Records
      *
      *? Initial Sub File Load.                                  ?             ?
     C                   EXSR      LOADSF
      *
     CSR                 ENDSR
** OPT - options
1
24
** OTX - options text
1=Select
2=Change   4=Delete
