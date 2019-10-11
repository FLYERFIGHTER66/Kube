/*********************************************************************/
/*   PROGRAM-------- BIR128CL                                        */
/*   DATE WRITTEN--- 04/08/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ACCOUNTING PERIODS MASTER LISTING               */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             CALL       PGM(GETPDEV)
             QSYS/RTVDTAARA DTAARA(*LDA (1 10)) RTNVAR(&PRT)
             QSYS/OVRPRTF FILE(BIR128) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(BIR128)
             ENDPGM
