/*********************************************************************/
/*   PROGRAM-------- APC525CL                                        */
/*   DATE WRITTEN--- 07/15/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PURGE RECONCILED CHECKS                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PURGE) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APC525')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Purge +
                          Reconciled  Checks ')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APC525)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APR525)

             DLTF       FILE(TGMSDATA/APRECWRK)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(TGMSDATA/APRECWRK) SRCMBR(FAPREC) +
                          MBR(RAPREC) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*YES)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(TGMSDATA/FAPREC) +
                          TOFILE(TGMSDATA/APRECWRK) MBROPT(*ADD) +
                          INCCHAR(AKSTAT 1 *NE 'X') FMTOPT(*MAP *DROP)
             CLRPFM     FILE(TGMSDATA/FAPREC)
             CPYF       FROMFILE(TGMSDATA/APRECWRK) +
                          TOFILE(TGMSDATA/FAPREC) MBROPT(*ADD) +
                          INCCHAR(AKSTAT 1 *NE 'X') FMTOPT(*MAP *DROP)
             DLTF       FILE(TGMSDATA/APRECWRK)
             MONMSG     MSGID(CPF2105)

 END:        ENDPGM
