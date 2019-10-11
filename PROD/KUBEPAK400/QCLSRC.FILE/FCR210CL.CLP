/*********************************************************************/
/*   PROGRAM-------- FCR210CL                                        */
/*   DATE WRITTEN---  1/14/03                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SPLIT JOB RUN FILE INTO RUN FILE                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*    2/07/03    ADDED CHANGES   C.BUCK                              */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATE7) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DATALIB) TYPE(*CHAR) LEN(10)
             RTVOBJD    OBJ(DATALIB) OBJTYPE(*FILE) RTNLIB(&DATALIB)

 FILE:       CPYF       FROMFILE(&DATALIB/FFCMRUN) TOFILE(&DATALIB/WRKRUN) +
                          MBROPT(*ADD) FROMRCD(1) FMTOPT(*NOCHK)
             CLRPFM     FILE(&DATALIB/FFCMRUN)
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             CALL       PGM(FCR210)  PARM(&DATE7)

             CLRPFM     FILE(&DATALIB/FFCMTOT)
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             CALL       PGM(FCR075)  PARM(&DATE7)

             CLRPFM     FILE(&DATALIB/FFCMTOT1)
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             CALL       PGM(FCR077)  PARM(&DATE7)

 END:        CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             ENDPGM
