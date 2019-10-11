/*********************************************************************/
/*   PROGRAM-------- ARR210CL                                        */
/*   DATE WRITTEN--- 06/25/99                                        */
/*   PROGRAMMER----- MJT                                             */
/*   DESCRIPTION---- A/R CASH RECEIPTS                               */
/*   SWITCHES------- U1 WILL SHOW LINE BALANCE ERRORS                */
/*                   U2 WILL NOT SHOW ZERO LINES                     */
/*                   U8 WILL STOP CHECK DATE KEYING                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&HIST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             RTVJOBA    USER(&USER)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARR210')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('      A/R Cash +
                          Receipts  ')

             CHKOBJ     OBJ(QTEMP/FAR210) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(QTEMP/FAR210) +
                          SRCFILE(*LIBL/QDDSSRC) SRCMBR(FAR210) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX))
             CLRPFM     FILE(QTEMP/FAR210)
             OVRDBF     FILE(FAR210) TOFILE(QTEMP/FAR210)

             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

/*           OVRPRTF    FILE(ARR22A) TOFILE(QSYSPRT) PAGESIZE(66 +
                      120) LPI(6) CPI(15) ALIGN(*NO) FORMTYPE(*NAR) */
/*           OVRPRTF    FILE(ARR210) TOFILE(QSYSPRT) PAGESIZE(66 +
                      120) LPI(6) CPI(15) ALIGN(*NO) FORMTYPE(*NAR) */

 NXT:        CHGJOB     SWS(01000001)
             IF         COND(&USER *EQ 'EFD' *OR &USER *EQ 'TGMS') +
                          THEN(CHGJOB SWS(XXX1XXXX))
             CALL       PGM(ARR210)
             CALL       PGM(QPKLCUPD)
             CHGJOB     SWS(00000000)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)

             DLTOVR     FILE(FAR210)

 /* TEMP RUN FIX DUE DATES  */
             CALL       PGM(FXAROPNDT)

 END:        ENDPGM
