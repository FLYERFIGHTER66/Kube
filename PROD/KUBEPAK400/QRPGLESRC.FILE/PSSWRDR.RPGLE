      *%*******************************************************************
      *%                                                                 **
      *%                                                  ?              **
      *%                                                                 **
      *%                        ?                                        **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- PASSWORD PROMPT SCREEN                          **
      *%                                                                 **
      *%                                                                 **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- PSSWRDR                                                *
      *                                                                   *
      * Purpose?- PROMPT FOR PASSWORD                                    *
      *                                                                   *
      *    Date  ?Programmer       ? Comment                         ? *
      *  8/14/2003  Richard E. Piasecki Program Created                   *
      *                                                                   *
      *%*******************************************************************
     FPSSWRDS   CF   E             WORKSTN
     F                                     INFDS(INFDS3)
      *
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
      *****************************************************************
      * ?Define Program Constants                                   ? *
      *****************************************************************
     D YES             C                   CONST('YES')
      *
      ********************************************************************
      ********************************************************************
      ******************  Program Main Line?  ***************************
      ********************************************************************
      ********************************************************************
      *
      *? Program Main Loop                                ?             ?
      *
     C                   WRITE     MSGCTL
     C                   EXFMT     SC01
      *
      *? Clear indicators and flags                       ?
      *
     C                   MOVEA     '00'          *IN(50)
     C                   MOVEA     '000'         *IN(13)
     C                   MOVE      *BLANKS       ERROR             3
      *? Clear Messages                                   ?
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *
     C     *IN03         IFEQ      *ON
     C                   MOVE      '03'          #EFKEY
     C                   ELSE
     C                   EXSR      $EDT01
     C                   ENDIF
      *
      *? End the program                                  ?             ?
      *
     C                   MOVE      *ON           *INLR
      *
      ********************************************************************
      ********************************************************************
      ********************  End Main Line?  *****************************
      ********************************************************************
      ********************************************************************
      *
      ********************************************************************
      * ?       Program Initialization and Housekeeping                 ?*
      ********************************************************************
     CSR   *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    #EPASS            1
     C                   PARM                    #EFKEY            2
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
     C     *DTAARA       DEFINE                  PSSWRD           10
     C     *DTAARA       DEFINE                  FGPWRD           10
     C  NU1              IN        PSSWRD
     C   U1              IN        FGPWRD
      *
     CSR                 ENDSR
      ********************************************************************
      * ?$EDT01 - Check the Input from Screen                           ?*
      ********************************************************************
     CSR   $EDT01        BEGSR
      *****
      * Check the password entered against the data area                ?*
      *****
     C     *INU1         IFNE      *ON
     C     S1PSWD        IFEQ      PSSWRD
     C                   MOVE      'Y'           #EPASS
     C                   ELSE
     C                   MOVE      'N'           #EPASS
     C                   ENDIF
     C                   ENDIF
     C     *INU1         IFEQ      *ON
     C     S1PSWD        IFEQ      FGPWRD
     C                   MOVE      'Y'           #EPASS
     C                   ELSE
     C                   MOVE      'N'           #EPASS
     C                   ENDIF
     C                   ENDIF
      *
     CSR                 ENDSR
      ********************************************************************
      * ?SRMSGF - Clear or send messages to Pgm msg queue               ?*
      ********************************************************************
     CSR   SRMSGF        BEGSR
      *
      *? Define Parameter List - define variables         ?
      *
     C     PLMSGF        PLIST
     C                   PARM                    $#PGMQ           10
     C                   PARM                    $#MSGF           10
     C                   PARM                    $#MSGL           10
     C                   PARM                    $#MSID            7
     C                   PARM                    $#MSGD           80
     C                   PARM                    $#MSKY            4
     C                   PARM                    $#MSFN            1
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
