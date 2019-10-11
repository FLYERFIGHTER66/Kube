/*********************************************************************/
/*   PROGRAM-------- SDR900CL                                        */
/*   DATE WRITTEN--- 06/26/01                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- MOVE VEND/SERIES X-REF TO HISTORY FILE          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(8)  /*  SERPRC   */
             DCL        VAR(&FILES) TYPE(*CHAR) LEN(8)  /* SERIES    */

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(SDC900)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 /*   BUILD HISTORY FILE (SERPRC)   */
             RTVDTAARA  DTAARA(*LDA (14 8)) RTNVAR(&FILE)
             CRTPF      FILE(TGMSDATA/&FILE) SRCMBR(FSERPRC) +
                          FLAG(20) MBR(RSERPRC) OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

 /*   BUILD HISTORY FILE (SERIES)   */
             RTVDTAARA  DTAARA(*LDA (22 8)) RTNVAR(&FILES)
             CRTPF      FILE(TGMSDATA/&FILES) SRCMBR(FSERIES) +
                          FLAG(20) MBR(RSERIES) OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             OVRDBF     FILE(FSERPRH) TOFILE(TGMSDATA/&FILE)
             OVRDBF     FILE(FSERIEO) TOFILE(TGMSDATA/&FILES)

             CALL       PGM(SDR900)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('SDR900CL  ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('00')
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Vendor/Series +
                          Moved to History')
             CALL       PGM(STSUPD)

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
