/*********************************************************************/
/*   PROGRAM-------- CHM070CL                                        */
/*   DATE WRITTEN---  1/21/03                                        */
/*   PROGRAMMER----- C.BUCK                                          */
/*   DESCRIPTION---- SPRAYER CONTROL FILE                            */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')

       /*    CLRPFM     FILE(FFCMNAM)    */
      /*     MONMSG     MSGID(CPF3142) EXEC(CRTPF +      */
       /*                 FILE(TGMSDATA/FFCMNAM) SRCMBR(FFCMNAM))  */

             CALL       PGM(FCR070)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))


 END:        CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             ENDPGM
