/*********************************************************************/
/*   PROGRAM-------- SCR410PCL                                       */
/*   DATE WRITTEN---  4/04/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT PUT DOWN WORK SHEETS     CALLED           */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SHCYM &SMASTER &ITEM &SIZE)
             DCL        VAR(&SHCYM) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&SMASTER) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&ITEM) TYPE(*CHAR) LEN(12)
             QSYS/DCL   VAR(&SIZE) TYPE(*CHAR) LEN(3)

             QSYS/OVRPRTF FILE(NCR410) TOFILE(*LIBL/QSYSPRT) DEV(R6) +
                          PAGESIZE(66 96) LPI(6) CPI(12) ALIGN(*NO) +
                          FORMTYPE(*NAR)

             CALL       PGM(NCR410P) PARM(&SHCYM &SMASTER &ITEM &SIZE)

 END:        ENDPGM
