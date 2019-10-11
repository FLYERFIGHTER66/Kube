/*********************************************************************/
/*   PROGRAM-------- BIR123CL                                        */
/*   DATE WRITTEN--- 04/03/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT TERMS CODES MASTER LIST                   */
/*   REVISIONS------ 10/10/96 ADDED DEV &PRT                         */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(8)
             CALL       PGM(GETPDEV)
             QSYS/RTVDTAARA DTAARA(*LDA (1 8)) RTNVAR(&PRT)
             QSYS/OVRPRTF FILE(BIR123) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(BIR123)
 END:        ENDPGM
