/*********************************************************************/
/*   PROGRAM-------- BIR310CL                                        */
/*   DATE WRITTEN--- 05/28/97                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PRINT PICK SLIPS  (AUTO VERSION)                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&PRT2) TYPE(*CHAR) LEN(10)
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             IF         COND(&PRT *LE '          ') THEN(DO)
             RTVSYSVAL  SYSVAL(QPRTDEV) RTNVAR(&PRT)
             ENDDO

             QSYS/RTVDTAARA DTAARA(*LDA (134 10)) RTNVAR(&PRT2)
             IF         COND(&PRT2 *LE '          ') THEN(DO)
             RTVSYSVAL  SYSVAL(QPRTDEV) RTNVAR(&PRT2)
             ENDDO

             QSYS/OVRPRTF FILE(BIR310) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(10) +
                          OVRFLW(53) ALIGN(*NO) FORMTYPE(*NAR)

             QSYS/OVRPRTF FILE(BIR311) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT2) PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR) OVRFLW(53)

             CALL       PGM(BIR310)
             MONMSG     MSGID(CPF1241)
                        GOTO END

 END:        ENDPGM
