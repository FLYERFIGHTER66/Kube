/*********************************************************************/
/*   PROGRAM-------- BIR460CL                                        */
/*   DATE WRITTEN--- 10/23/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT CREDIT MEMOS                              */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
/*           QSYS/RTVDTAARA  DTAARA(*LDA (60 8)) RTNVAR(&FILE)       */
/*           OVRDBF     FILE(FIORCX) TOFILE(QS36F/&FILE)             */
             QSYS/RTVDTAARA DTAARA(*LDA (38 8)) RTNVAR(&PRT)
             QSYS/OVRPRTF FILE(BIR460A) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 132) LPI(6) CPI(10) +
                          ALIGN(*YES) FORMTYPE(*CRM)
             CALL       PGM(BIR460)
 END:        ENDPGM
