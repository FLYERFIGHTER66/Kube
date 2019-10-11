/*********************************************************************/
/*   PROGRAM-------- CHR210CL                                        */
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
             QSYS/DCL   VAR(&LIBR) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&DATE7@) TYPE(*CHAR) LEN(7)

             RTVOBJD    OBJ(*LIBL/FCHMDFT) OBJTYPE(*FILE) RTNLIB(&LIBR)

 FILE:       CPYF       FROMFILE(&LIBR/FCHMRUN) TOFILE(&LIBR/WRKRUN) +
                          MBROPT(*ADD) FROMRCD(1) FMTOPT(*NOCHK)
/* WJB       CLRPFM     FILE(&LIBR/FCHMRUN)         */
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             CALL       PGM(CHR210) PARM(&DATE7@)

/* WJB       CLRPFM     FILE(&LIBR/FCHMTOT)         */
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             CALL       PGM(CHR075) PARM(&DATE7@)

/* WJB       CLRPFM     FILE(&LIBR/FCHMTOT1)        */
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             CALL       PGM(CHR077) PARM(&DATE7@)

 END:        CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             ENDPGM
