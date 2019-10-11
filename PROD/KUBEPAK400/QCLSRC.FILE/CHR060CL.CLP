/*********************************************************************/
/*   PROGRAM-------- CHM060CL                                        */
/*   DATE WRITTEN---  1/21/03                                        */
/*   PROGRAMMER----- C.BUCK                                          */
/*   DESCRIPTION---- APPLICATER CONTROL FILE                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')

     /*      CLRPFM     FILE(FCHMNAM)                    */
     /*      MONMSG     MSGID(CPF3142) EXEC(CRTPF +             */
     /*                   FILE(TGMSDATA/FCHMNAM) SRCMBR(FCHMNAM))  */

             CALL       PGM(CHR060)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))


 END:        CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             ENDPGM
