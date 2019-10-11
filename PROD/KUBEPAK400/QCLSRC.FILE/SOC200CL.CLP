/*********************************************************************/
/*   PROGRAM-------- SOC200CL                                        */
/*   DATE WRITTEN--- 01/24/99                                        */
/*   PROGRAMMER----- JJP                                             */
/*   DESCRIPTION---- SHIPPPED ORDER HISTORY REPORT                   */
/*   REVISIONS------                                                 */
/* 10/08/99 EFD REWRITE                                              */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')


             CALL       PGM(SOC200)

             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             RTVDTAARA  DTAARA(*LDA (45 10)) RTNVAR(&PRT)

             QSYS/OVRPRTF FILE(REPORT1) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(88 198) LPI(8) CPI(15) +
                          OVRFLW(84) ALIGN(*NO) FORMTYPE(*NAR) +
                          COPIES(1) HOLD(*NO) SAVE(*NO)
             QSYS/OVRPRTF FILE(REPORT2) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(88 198) LPI(8) CPI(15) +
                          OVRFLW(84) ALIGN(*NO) FORMTYPE(*NAR) +
                          COPIES(1) HOLD(*NO) SAVE(*NO)

             CALL       PGM(SOR200)

 END:   /*   CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')   */
             ENDPGM
