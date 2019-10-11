/*********************************************************************/
/*   PROGRAM-------- SOR190CL                                        */
/*   DATE WRITTEN--- 11/21/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- S/O HISTORY CUSTOMER/PRODUCT CLASS INQUIRY      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('SOR190')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('S/O History +
                          Customer/P/C Inq ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/OVRPRTF FILE(SOR190) TOFILE(*LIBL/QSYSPRT) +
                          DEV(*JOB) PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR) COPIES(1)

             CALL       PGM(SOR190)
 END:        ENDPGM
