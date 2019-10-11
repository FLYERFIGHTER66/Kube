/*********************************************************************/
/*   PROGRAM-------- SCR410PCL                                       */
/*   DATE WRITTEN---  4/04/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT PUT DOWN WORK SHEETS     CALLED           */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SHCYM &MASTER &ITEM &SIZE &PRINT_RB &PRINTER)
             DCL        VAR(&SHCYM) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&MASTER) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&ITEM) TYPE(*CHAR) LEN(12)
             DCL        VAR(&PRINT_RB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SIZE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)

             QSYS/OVRPRTF FILE(SCR410) TOFILE(*LIBL/QSYSPRT) PAGESIZE(66 +
                          96) LPI(6) CPI(12) ALIGN(*NO) OUTQ(&PRINTER) +
                          FORMTYPE(*NAR) COPIES(1)


             CALL       PGM(SCR410P) PARM(&SHCYM &MASTER &ITEM &SIZE +
                          &PRINT_RB)

 END:        ENDPGM
