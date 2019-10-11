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
      **PROGRAM NAME-------- CNVPER
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CONVERT SHIST AND SHISTS TO NEW CALENDAR
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFSHISTI   IF   E           K DISK
     F                                     RENAME(RSHIST:SHISTI)
     FFSHIST    UF   E           K DISK
      *
     FFSHISTSI  IF   E           K DISK
     F                                     RENAME(RSHISTS:SHISTS)
     FFSHISTS   UF   E           K DISK
      *
      * SHIST/SHISTS ARRAYS  OUTPUT
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
      * SHIST/SHISTS ARRAYS  INPUT
     D CI$             S              9  2 DIM(13)
     D PI$             S              9  2 DIM(13)
     D CIQ             S             11  1 DIM(13)
     D PIQ             S             11  1 DIM(13)
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
     IRSHISTS
      ** OUTPUT FILE
     I              SHCS01                      CS$(1)
     I              SHCS02                      CS$(2)
     I              SHCS03                      CS$(3)
     I              SHCS04                      CS$(4)
     I              SHCS05                      CS$(5)
     I              SHCS06                      CS$(6)
     I              SHCS07                      CS$(7)
     I              SHCS08                      CS$(8)
     I              SHCS09                      CS$(9)
     I              SHCS10                      CS$(10)
     I              SHCS11                      CS$(11)
     I              SHCS12                      CS$(12)
     I              SHCS13                      CS$(13)
      *
     I              SHLS01                      PS$(1)
     I              SHLS02                      PS$(2)
     I              SHLS03                      PS$(3)
     I              SHLS04                      PS$(4)
     I              SHLS05                      PS$(5)
     I              SHLS06                      PS$(6)
     I              SHLS07                      PS$(7)
     I              SHLS08                      PS$(8)
     I              SHLS09                      PS$(9)
     I              SHLS10                      PS$(10)
     I              SHLS11                      PS$(11)
     I              SHLS12                      PS$(12)
     I              SHLS13                      PS$(13)
      *
     I              SHCQ01                      CSQ(1)
     I              SHCQ02                      CSQ(2)
     I              SHCQ03                      CSQ(3)
     I              SHCQ04                      CSQ(4)
     I              SHCQ05                      CSQ(5)
     I              SHCQ06                      CSQ(6)
     I              SHCQ07                      CSQ(7)
     I              SHCQ08                      CSQ(8)
     I              SHCQ09                      CSQ(9)
     I              SHCQ10                      CSQ(10)
     I              SHCQ11                      CSQ(11)
     I              SHCQ12                      CSQ(12)
     I              SHCQ13                      CSQ(13)
      *
     I              SHLQ01                      PSQ(1)
     I              SHLQ02                      PSQ(2)
     I              SHLQ03                      PSQ(3)
     I              SHLQ04                      PSQ(4)
     I              SHLQ05                      PSQ(5)
     I              SHLQ06                      PSQ(6)
     I              SHLQ07                      PSQ(7)
     I              SHLQ08                      PSQ(8)
     I              SHLQ09                      PSQ(9)
     I              SHLQ10                      PSQ(10)
     I              SHLQ11                      PSQ(11)
     I              SHLQ12                      PSQ(12)
     I              SHLQ13                      PSQ(13)
      *
     ISHISTS
      *** INPUT FILE
     I              SHCS01                      CI$(1)
     I              SHCS02                      CI$(2)
     I              SHCS03                      CI$(3)
     I              SHCS04                      CI$(4)
     I              SHCS05                      CI$(5)
     I              SHCS06                      CI$(6)
     I              SHCS07                      CI$(7)
     I              SHCS08                      CI$(8)
     I              SHCS09                      CI$(9)
     I              SHCS10                      CI$(10)
     I              SHCS11                      CI$(11)
     I              SHCS12                      CI$(12)
     I              SHCS13                      CI$(13)
      *
     I              SHLS01                      PI$(1)
     I              SHLS02                      PI$(2)
     I              SHLS03                      PI$(3)
     I              SHLS04                      PI$(4)
     I              SHLS05                      PI$(5)
     I              SHLS06                      PI$(6)
     I              SHLS07                      PI$(7)
     I              SHLS08                      PI$(8)
     I              SHLS09                      PI$(9)
     I              SHLS10                      PI$(10)
     I              SHLS11                      PI$(11)
     I              SHLS12                      PI$(12)
     I              SHLS13                      PI$(13)
      *
     I              SHCQ01                      CIQ(1)
     I              SHCQ02                      CIQ(2)
     I              SHCQ03                      CIQ(3)
     I              SHCQ04                      CIQ(4)
     I              SHCQ05                      CIQ(5)
     I              SHCQ06                      CIQ(6)
     I              SHCQ07                      CIQ(7)
     I              SHCQ08                      CIQ(8)
     I              SHCQ09                      CIQ(9)
     I              SHCQ10                      CIQ(10)
     I              SHCQ11                      CIQ(11)
     I              SHCQ12                      CIQ(12)
     I              SHCQ13                      CIQ(13)
      *
     I              SHLQ01                      PIQ(1)
     I              SHLQ02                      PIQ(2)
     I              SHLQ03                      PIQ(3)
     I              SHLQ04                      PIQ(4)
     I              SHLQ05                      PIQ(5)
     I              SHLQ06                      PIQ(6)
     I              SHLQ07                      PIQ(7)
     I              SHLQ08                      PIQ(8)
     I              SHLQ09                      PIQ(9)
     I              SHLQ10                      PIQ(10)
     I              SHLQ11                      PIQ(11)
     I              SHLQ12                      PIQ(12)
     I              SHLQ13                      PIQ(13)
      *
     IRSHIST
      ** OUTPUT FILE
     I              SICS01                      CS$(1)
     I              SICS02                      CS$(2)
     I              SICS03                      CS$(3)
     I              SICS04                      CS$(4)
     I              SICS05                      CS$(5)
     I              SICS06                      CS$(6)
     I              SICS07                      CS$(7)
     I              SICS08                      CS$(8)
     I              SICS09                      CS$(9)
     I              SICS10                      CS$(10)
     I              SICS11                      CS$(11)
     I              SICS12                      CS$(12)
     I              SICS13                      CS$(13)
      *
     I              SILS01                      PS$(1)
     I              SILS02                      PS$(2)
     I              SILS03                      PS$(3)
     I              SILS04                      PS$(4)
     I              SILS05                      PS$(5)
     I              SILS06                      PS$(6)
     I              SILS07                      PS$(7)
     I              SILS08                      PS$(8)
     I              SILS09                      PS$(9)
     I              SILS10                      PS$(10)
     I              SILS11                      PS$(11)
     I              SILS12                      PS$(12)
     I              SILS13                      PS$(13)
      *
     I              SICQ01                      CSQ(1)
     I              SICQ02                      CSQ(2)
     I              SICQ03                      CSQ(3)
     I              SICQ04                      CSQ(4)
     I              SICQ05                      CSQ(5)
     I              SICQ06                      CSQ(6)
     I              SICQ07                      CSQ(7)
     I              SICQ08                      CSQ(8)
     I              SICQ09                      CSQ(9)
     I              SICQ10                      CSQ(10)
     I              SICQ11                      CSQ(11)
     I              SICQ12                      CSQ(12)
     I              SICQ13                      CSQ(13)
      *
     I              SILQ01                      PSQ(1)
     I              SILQ02                      PSQ(2)
     I              SILQ03                      PSQ(3)
     I              SILQ04                      PSQ(4)
     I              SILQ05                      PSQ(5)
     I              SILQ06                      PSQ(6)
     I              SILQ07                      PSQ(7)
     I              SILQ08                      PSQ(8)
     I              SILQ09                      PSQ(9)
     I              SILQ10                      PSQ(10)
     I              SILQ11                      PSQ(11)
     I              SILQ12                      PSQ(12)
     I              SILQ13                      PSQ(13)
      *
     ISHISTI
      *** INPUT FILE
     I              SICS01                      CI$(1)
     I              SICS02                      CI$(2)
     I              SICS03                      CI$(3)
     I              SICS04                      CI$(4)
     I              SICS05                      CI$(5)
     I              SICS06                      CI$(6)
     I              SICS07                      CI$(7)
     I              SICS08                      CI$(8)
     I              SICS09                      CI$(9)
     I              SICS10                      CI$(10)
     I              SICS11                      CI$(11)
     I              SICS12                      CI$(12)
     I              SICS13                      CI$(13)
      *
     I              SILS01                      PI$(1)
     I              SILS02                      PI$(2)
     I              SILS03                      PI$(3)
     I              SILS04                      PI$(4)
     I              SILS05                      PI$(5)
     I              SILS06                      PI$(6)
     I              SILS07                      PI$(7)
     I              SILS08                      PI$(8)
     I              SILS09                      PI$(9)
     I              SILS10                      PI$(10)
     I              SILS11                      PI$(11)
     I              SILS12                      PI$(12)
     I              SILS13                      PI$(13)
      *
     I              SICQ01                      CIQ(1)
     I              SICQ02                      CIQ(2)
     I              SICQ03                      CIQ(3)
     I              SICQ04                      CIQ(4)
     I              SICQ05                      CIQ(5)
     I              SICQ06                      CIQ(6)
     I              SICQ07                      CIQ(7)
     I              SICQ08                      CIQ(8)
     I              SICQ09                      CIQ(9)
     I              SICQ10                      CIQ(10)
     I              SICQ11                      CIQ(11)
     I              SICQ12                      CIQ(12)
     I              SICQ13                      CIQ(13)
      *
     I              SILQ01                      PIQ(1)
     I              SILQ02                      PIQ(2)
     I              SILQ03                      PIQ(3)
     I              SILQ04                      PIQ(4)
     I              SILQ05                      PIQ(5)
     I              SILQ06                      PIQ(6)
     I              SILQ07                      PIQ(7)
     I              SILQ08                      PIQ(8)
     I              SILQ09                      PIQ(9)
     I              SILQ10                      PIQ(10)
     I              SILQ11                      PIQ(11)
     I              SILQ12                      PIQ(12)
     I              SILQ13                      PIQ(13)
      ****************
      * SHIST FIRST  *
      ****************
     C     NXT1          TAG
     C                   READ      FSHISTI                                90
     C   90              GOTO      END1
     C     HSTKEY        KLIST
     C                   KFLD                    SICUST
     C                   KFLD                    SIITEM
     C                   KFLD                    SISIZE
     C                   KFLD                    SISLSM
     C                   KFLD                    SICOMP
     C     HSTKEY        CHAIN     FSHIST                             91
     C   91              GOTO      NXT1
      ** NOW GET RIGHT BUCKETS
      ** DOLLARS FIRST
     C                   Z-ADD     CI$(10)       CS$(1)
     C                   Z-ADD     CI$(11)       CS$(2)
     C                   Z-ADD     CI$(12)       CS$(3)
     C                   Z-ADD     PI$(10)       PS$(1)
     C                   Z-ADD     PI$(11)       PS$(2)
     C                   Z-ADD     PI$(12)       PS$(3)
     C                   Z-ADD     CI$(01)       PS$(4)
     C                   Z-ADD     CI$(02)       PS$(5)
     C                   Z-ADD     CI$(03)       PS$(6)
     C                   Z-ADD     CI$(04)       PS$(7)
     C                   Z-ADD     CI$(05)       PS$(8)
     C                   Z-ADD     CI$(06)       PS$(9)
     C                   Z-ADD     CI$(07)       PS$(10)
     C                   Z-ADD     CI$(08)       PS$(11)
     C                   Z-ADD     CI$(09)       PS$(12)
      ** NOW QTYS.
     C                   Z-ADD     CIQ(10)       CSQ(1)
     C                   Z-ADD     CIQ(11)       CSQ(2)
     C                   Z-ADD     CIQ(12)       CSQ(3)
     C                   Z-ADD     PIQ(10)       PSQ(1)
     C                   Z-ADD     PIQ(11)       PSQ(2)
     C                   Z-ADD     PIQ(12)       PSQ(3)
     C                   Z-ADD     CIQ(01)       PSQ(4)
     C                   Z-ADD     CIQ(02)       PSQ(5)
     C                   Z-ADD     CIQ(03)       PSQ(6)
     C                   Z-ADD     CIQ(04)       PSQ(7)
     C                   Z-ADD     CIQ(05)       PSQ(8)
     C                   Z-ADD     CIQ(06)       PSQ(9)
     C                   Z-ADD     CIQ(07)       PSQ(10)
     C                   Z-ADD     CIQ(08)       PSQ(11)
     C                   Z-ADD     CIQ(09)       PSQ(12)
     C                   UPDATE    RSHIST
     C                   GOTO      NXT1
     C     END1          TAG
      ****************
      * SHISTS NOW   *
      ****************
     C     NXT2          TAG
     C                   READ      FSHISTSI                               90
     C   90              GOTO      END
     C     HSSKEY        KLIST
     C                   KFLD                    SHCUST
     C                   KFLD                    SHITEM
     C                   KFLD                    SHSIZE
     C                   KFLD                    SHSLSM
     C                   KFLD                    SHCOMP
     C     HSSKEY        CHAIN     FSHISTS                            91
     C   91              GOTO      NXT2
      ** NOW GET RIGHT BUCKETS
      ** DOLLARS FIRST
     C                   Z-ADD     CI$(10)       CS$(1)
     C                   Z-ADD     CI$(11)       CS$(2)
     C                   Z-ADD     CI$(12)       CS$(3)
     C                   Z-ADD     PI$(10)       PS$(1)
     C                   Z-ADD     PI$(11)       PS$(2)
     C                   Z-ADD     PI$(12)       PS$(3)
     C                   Z-ADD     CI$(01)       PS$(4)
     C                   Z-ADD     CI$(02)       PS$(5)
     C                   Z-ADD     CI$(03)       PS$(6)
     C                   Z-ADD     CI$(04)       PS$(7)
     C                   Z-ADD     CI$(05)       PS$(8)
     C                   Z-ADD     CI$(06)       PS$(9)
     C                   Z-ADD     CI$(07)       PS$(10)
     C                   Z-ADD     CI$(08)       PS$(11)
     C                   Z-ADD     CI$(09)       PS$(12)
      ** NOW QTYS.
     C                   Z-ADD     CIQ(10)       CSQ(1)
     C                   Z-ADD     CIQ(11)       CSQ(2)
     C                   Z-ADD     CIQ(12)       CSQ(3)
     C                   Z-ADD     PIQ(10)       PSQ(1)
     C                   Z-ADD     PIQ(11)       PSQ(2)
     C                   Z-ADD     PIQ(12)       PSQ(3)
     C                   Z-ADD     CIQ(01)       PSQ(4)
     C                   Z-ADD     CIQ(02)       PSQ(5)
     C                   Z-ADD     CIQ(03)       PSQ(6)
     C                   Z-ADD     CIQ(04)       PSQ(7)
     C                   Z-ADD     CIQ(05)       PSQ(8)
     C                   Z-ADD     CIQ(06)       PSQ(9)
     C                   Z-ADD     CIQ(07)       PSQ(10)
     C                   Z-ADD     CIQ(08)       PSQ(11)
     C                   Z-ADD     CIQ(09)       PSQ(12)
     C                   UPDATE    RSHISTS
     C                   GOTO      NXT2
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
