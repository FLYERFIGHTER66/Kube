/*********************************************************************/
/*   PROGRAM-------- PIC050CL                                        */
/*   DATE WRITTEN--- 05/09/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- BUILD POINTSETTIA INVENTORY FILE                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (1 4)) VALUE('0000')

             CALL       PGM(PIC050)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(PIC050CLJQ)

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
