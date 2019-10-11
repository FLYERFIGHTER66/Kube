      *%*******************************************************************
      *%                                                                 **
      *%                                                                 **
      *%  ?System     ?- AS/400                                          **
      *%  ?Application?- Broker Sales Summary                            **
      *%                                                               ?**
      *%*******************************************************************
      *********************************************************************
      *                                                                   *
      * Program?- SUMBROK                                                *
      *                                                                   *
      * Purpose?- Summarize Sales by Broker                              *
      *                                                                   *
      *   Date  ?Programmer    ? Comment                             ? *
      *  05/20/03  R. Piasecki      Program Created                       *
      *                                                                   *
      *********************************************************************
0022 FFSHISTL1  IP   E           K DISK
     F                                     RENAME(RSHIST:BSHIST)
0022 FFSHISTS   UF A E           K DISK
     FXATABL    IF   E           K DISK
     FFMCUST    IF   E           K DISK
      **                                                               ***
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
     IBSHIST        01
     I              SICUST                      BICUST
     I              SICOMP                      BICOMP
     I              SICQ01                      BICQ01
     I              SICQ02                      BICQ02
     I              SICQ03                      BICQ03
     I              SICQ04                      BICQ04
     I              SICQ05                      BICQ05
     I              SICQ06                      BICQ06
     I              SICQ07                      BICQ07
     I              SICQ08                      BICQ08
     I              SICQ09                      BICQ09
     I              SICQ10                      BICQ10
     I              SICQ11                      BICQ11
     I              SICQ12                      BICQ12
     I              SICQ13                      BICQ13
      **                                                               ***
     I              SICS01                      BICS01
     I              SICS02                      BICS02
     I              SICS03                      BICS03
     I              SICS04                      BICS04
     I              SICS05                      BICS05
     I              SICS06                      BICS06
     I              SICS07                      BICS07
     I              SICS08                      BICS08
     I              SICS09                      BICS09
     I              SICS10                      BICS10
     I              SICS11                      BICS11
     I              SICS12                      BICS12
     I              SICS13                      BICS13
      **                                                               ***
     I              SILQ01                      BILQ01
     I              SILQ02                      BILQ02
     I              SILQ03                      BILQ03
     I              SILQ04                      BILQ04
     I              SILQ05                      BILQ05
     I              SILQ06                      BILQ06
     I              SILQ07                      BILQ07
     I              SILQ08                      BILQ08
     I              SILQ09                      BILQ09
     I              SILQ10                      BILQ10
     I              SILQ11                      BILQ11
     I              SILQ12                      BILQ12
     I              SILQ13                      BILQ13
      **                                                               ***
     I              SILS01                      BILS01
     I              SILS02                      BILS02
     I              SILS03                      BILS03
     I              SILS04                      BILS04
     I              SILS05                      BILS05
     I              SILS06                      BILS06
     I              SILS07                      BILS07
     I              SILS08                      BILS08
     I              SILS09                      BILS09
     I              SILS10                      BILS10
     I              SILS11                      BILS11
     I              SILS12                      BILS12
     I              SILS13                      BILS13
      **                                                               ***
     I              SICC01                      BICC01
     I              SICC02                      BICC02
     I              SICC03                      BICC03
     I              SICC04                      BICC04
     I              SICC05                      BICC05
     I              SICC06                      BICC06
     I              SICC07                      BICC07
     I              SICC08                      BICC08
     I              SICC09                      BICC09
     I              SICC10                      BICC10
     I              SICC11                      BICC11
     I              SICC12                      BICC12
     I              SICC13                      BICC13
      **                                                               ***
     I              SILC01                      BILC01
     I              SILC02                      BILC02
     I              SILC03                      BILC03
     I              SILC04                      BILC04
     I              SILC05                      BILC05
     I              SILC06                      BILC06
     I              SILC07                      BILC07
     I              SILC08                      BILC08
     I              SILC09                      BILC09
     I              SILC10                      BILC10
     I              SILC11                      BILC11
     I              SILC12                      BILC12
     I              SILC13                      BILC13
      ********************************************************************
      ******************  Program Main Line?  ***************************
      ********************************************************************
     C                   CLEAR                   BSHIST
     C                   MOVEA     '000'         *IN(97)
     C     BICUST        CHAIN     FMCUST                             99
     C     *IN99         IFEQ      *OFF
     C     CMBABB        ANDGT     *BLANKS
     C     'BR'          CAT(P)    CMBABB:0      TBTBCD            8
     C     TBTBCD        CHAIN     XATABL                             98
     C     *IN98         IFEQ      *OFF
     C                   Z-ADD     TBBROK        CUST#             6 0
     C     CUST#         CHAIN     FSHISTS                            97
     C     *IN97         IFEQ      *ON
     C                   EXSR      ADDIT
     C                   ELSE
     C                   EXSR      UPDIT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      ********************************************************************
      * ?ADDIT: Add Record to Broker Summary File                       ?*
      ********************************************************************
     CSR   ADDIT         BEGSR
     C                   Z-ADD     CUST#         SHCUST
     C                   Z-ADD     CMCOMP        SHCOMP
     C                   Z-ADD     BICQ01        SHCQ01
     C                   Z-ADD     BICQ02        SHCQ02
     C                   Z-ADD     BICQ03        SHCQ03
     C                   Z-ADD     BICQ04        SHCQ04
     C                   Z-ADD     BICQ05        SHCQ05
     C                   Z-ADD     BICQ06        SHCQ06
     C                   Z-ADD     BICQ07        SHCQ07
     C                   Z-ADD     BICQ08        SHCQ08
     C                   Z-ADD     BICQ09        SHCQ09
     C                   Z-ADD     BICQ10        SHCQ10
     C                   Z-ADD     BICQ11        SHCQ11
     C                   Z-ADD     BICQ12        SHCQ12
     C                   Z-ADD     BICQ13        SHCQ13
      **                                                               ***
     C                   Z-ADD     BICS01        SHCS01
     C                   Z-ADD     BICS02        SHCS02
     C                   Z-ADD     BICS03        SHCS03
     C                   Z-ADD     BICS04        SHCS04
     C                   Z-ADD     BICS05        SHCS05
     C                   Z-ADD     BICS06        SHCS06
     C                   Z-ADD     BICS07        SHCS07
     C                   Z-ADD     BICS08        SHCS08
     C                   Z-ADD     BICS09        SHCS09
     C                   Z-ADD     BICS10        SHCS10
     C                   Z-ADD     BICS11        SHCS11
     C                   Z-ADD     BICS12        SHCS12
     C                   Z-ADD     BICS13        SHCS13
      **                                                               ***
     C                   Z-ADD     BILQ01        SHLQ01
     C                   Z-ADD     BILQ02        SHLQ02
     C                   Z-ADD     BILQ03        SHLQ03
     C                   Z-ADD     BILQ04        SHLQ04
     C                   Z-ADD     BILQ05        SHLQ05
     C                   Z-ADD     BILQ06        SHLQ06
     C                   Z-ADD     BILQ07        SHLQ07
     C                   Z-ADD     BILQ08        SHLQ08
     C                   Z-ADD     BILQ09        SHLQ09
     C                   Z-ADD     BILQ10        SHLQ10
     C                   Z-ADD     BILQ11        SHLQ11
     C                   Z-ADD     BILQ12        SHLQ12
     C                   Z-ADD     BILQ13        SHLQ13
      **                                                               ***
     C                   Z-ADD     BILS01        SHLS01
     C                   Z-ADD     BILS02        SHLS02
     C                   Z-ADD     BILS03        SHLS03
     C                   Z-ADD     BILS04        SHLS04
     C                   Z-ADD     BILS05        SHLS05
     C                   Z-ADD     BILS06        SHLS06
     C                   Z-ADD     BILS07        SHLS07
     C                   Z-ADD     BILS08        SHLS08
     C                   Z-ADD     BILS09        SHLS09
     C                   Z-ADD     BILS10        SHLS10
     C                   Z-ADD     BILS11        SHLS11
     C                   Z-ADD     BILS12        SHLS12
     C                   Z-ADD     BILS13        SHLS13
      **                                                               ***
     C                   Z-ADD     BICC01        SHCC01
     C                   Z-ADD     BICC02        SHCC02
     C                   Z-ADD     BICC03        SHCC03
     C                   Z-ADD     BICC04        SHCC04
     C                   Z-ADD     BICC05        SHCC05
     C                   Z-ADD     BICC06        SHCC06
     C                   Z-ADD     BICC07        SHCC07
     C                   Z-ADD     BICQ08        SHCC08
     C                   Z-ADD     BICC09        SHCC09
     C                   Z-ADD     BICC10        SHCC10
     C                   Z-ADD     BICC11        SHCC11
     C                   Z-ADD     BICC12        SHCC12
     C                   Z-ADD     BICC13        SHCC13
      **                                                               ***
     C                   Z-ADD     BILC01        SHLC01
     C                   Z-ADD     BILC02        SHLC02
     C                   Z-ADD     BILC03        SHLC03
     C                   Z-ADD     BILC04        SHLC04
     C                   Z-ADD     BILC05        SHLC05
     C                   Z-ADD     BILC06        SHLC06
     C                   Z-ADD     BILC07        SHLC07
     C                   Z-ADD     BILQ08        SHLC08
     C                   Z-ADD     BILC09        SHLC09
     C                   Z-ADD     BILC10        SHLC10
     C                   Z-ADD     BILC11        SHLC11
     C                   Z-ADD     BILC12        SHLC12
     C                   Z-ADD     BILC13        SHLC13
      **                                                               ***
     C                   WRITE     RSHISTS
      **                                                               ***
     C                   ENDSR
      ********************************************************************
      * ?UPDIT: Update Record in Broker Summary File                    ?*
      ********************************************************************
     CSR   UPDIT         BEGSR
     C                   ADD       BICQ01        SHCQ01
     C                   ADD       BICQ02        SHCQ02
     C                   ADD       BICQ03        SHCQ03
     C                   ADD       BICQ04        SHCQ04
     C                   ADD       BICQ05        SHCQ05
     C                   ADD       BICQ06        SHCQ06
     C                   ADD       BICQ07        SHCQ07
     C                   ADD       BICQ08        SHCQ08
     C                   ADD       BICQ09        SHCQ09
     C                   ADD       BICQ10        SHCQ10
     C                   ADD       BICQ11        SHCQ11
     C                   ADD       BICQ12        SHCQ12
     C                   ADD       BICQ13        SHCQ13
      **                                                               ***
     C                   ADD       BICS01        SHCS01
     C                   ADD       BICS02        SHCS02
     C                   ADD       BICS03        SHCS03
     C                   ADD       BICS04        SHCS04
     C                   ADD       BICS05        SHCS05
     C                   ADD       BICS06        SHCS06
     C                   ADD       BICS07        SHCS07
     C                   ADD       BICS08        SHCS08
     C                   ADD       BICS09        SHCS09
     C                   ADD       BICS10        SHCS10
     C                   ADD       BICS11        SHCS11
     C                   ADD       BICS12        SHCS12
     C                   ADD       BICS13        SHCS13
      **                                                               ***
     C                   ADD       BILQ01        SHLQ01
     C                   ADD       BILQ02        SHLQ02
     C                   ADD       BILQ03        SHLQ03
     C                   ADD       BILQ04        SHLQ04
     C                   ADD       BILQ05        SHLQ05
     C                   ADD       BILQ06        SHLQ06
     C                   ADD       BILQ07        SHLQ07
     C                   ADD       BILQ08        SHLQ08
     C                   ADD       BILQ09        SHLQ09
     C                   ADD       BILQ10        SHLQ10
     C                   ADD       BILQ11        SHLQ11
     C                   ADD       BILQ12        SHLQ12
     C                   ADD       BILQ13        SHLQ13
      **                                                               ***
     C                   ADD       BILS01        SHLS01
     C                   ADD       BILS02        SHLS02
     C                   ADD       BILS03        SHLS03
     C                   ADD       BILS04        SHLS04
     C                   ADD       BILS05        SHLS05
     C                   ADD       BILS06        SHLS06
     C                   ADD       BILS07        SHLS07
     C                   ADD       BILS08        SHLS08
     C                   ADD       BILS09        SHLS09
     C                   ADD       BILS10        SHLS10
     C                   ADD       BILS11        SHLS11
     C                   ADD       BILS12        SHLS12
     C                   ADD       BILS13        SHLS13
      **                                                               ***
     C                   ADD       BICC01        SHCC01
     C                   ADD       BICC02        SHCC02
     C                   ADD       BICC03        SHCC03
     C                   ADD       BICC04        SHCC04
     C                   ADD       BICC05        SHCC05
     C                   ADD       BICC06        SHCC06
     C                   ADD       BICC07        SHCC07
     C                   ADD       BICC08        SHCC08
     C                   ADD       BICC09        SHCC09
     C                   ADD       BICC10        SHCC10
     C                   ADD       BICC11        SHCC11
     C                   ADD       BICC12        SHCC12
     C                   ADD       BICC13        SHCC13
      **                                                               ***
     C                   ADD       BILC01        SHLC01
     C                   ADD       BILC02        SHLC02
     C                   ADD       BILC03        SHLC03
     C                   ADD       BILC04        SHLC04
     C                   ADD       BILC05        SHLC05
     C                   ADD       BILC06        SHLC06
     C                   ADD       BILC07        SHLC07
     C                   ADD       BILC08        SHLC08
     C                   ADD       BILC09        SHLC09
     C                   ADD       BILC10        SHLC10
     C                   ADD       BILC11        SHLC11
     C                   ADD       BILC12        SHLC12
     C                   ADD       BILC13        SHLC13
      **                                                               ***
     C                   UPDATE    RSHISTS
      **                                                               ***
     C                   ENDSR
