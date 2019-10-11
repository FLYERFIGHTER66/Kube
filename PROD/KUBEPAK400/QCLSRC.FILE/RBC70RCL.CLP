/*********************************************************************/
/*   PROGRAM-------- RBC700CL                                        */
/*   DATE WRITTEN---  4/11/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- DELETE WEEKS RECORDS FROM READY BAY FILES       */
/*   REVISIONS------                                                 */
/* THIS FILE IS REORGANIZED EVERY NIGHT.                             */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&COP) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&SUM) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             CLRPFM     FILE(FRBTRAY)

             CALL       PGM(RBR700)
 END:        ENDPGM
