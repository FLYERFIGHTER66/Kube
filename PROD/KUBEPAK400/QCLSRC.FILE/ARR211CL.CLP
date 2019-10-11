/*********************************************************************/
/*   PROGRAM-------- ARR211CL                                        */
/*   DATE WRITTEN--- 06/25/99                                        */
/*   PROGRAMMER----- MJT                                             */
/*   DESCRIPTION---- A/R CASH NSF ENTRY                              */
/*   SWITCHES-------
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&HIST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)


             RTVJOBA    USER(&USER)


             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARR211')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('      A/R NSF +
                          Entry      ')

             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

/*           OVRPRTF    FILE(ARR22A) TOFILE(QSYSPRT) PAGESIZE(66 +
                      120) LPI(6) CPI(15) ALIGN(*NO) FORMTYPE(*NAR) */
/*           OVRPRTF    FILE(ARR210) TOFILE(QSYSPRT) PAGESIZE(66 +
                      120) LPI(6) CPI(15) ALIGN(*NO) FORMTYPE(*NAR) */

 NXT:        CHGJOB     SWS(00000001)
             IF         COND(&USER *EQ 'EFD' *OR &USER *EQ 'TGMS') +
                          THEN(CHGJOB SWS(XXX1XXXX))
             CALL       PGM(ARR211)
             CHGJOB     SWS(00000000)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)

 END:        ENDPGM
