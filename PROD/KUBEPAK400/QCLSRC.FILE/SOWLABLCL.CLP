/*********************************************************************/
/*   PROGRAM-------- SOWLABLCL                                       */
/*   DATE WRITTEN--- 10/07/98                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- SOW LABELS                                      */
/*   REVISIONS------                                                 */
/* 12/17/98 EFD USE ONLY 1 LABEL PRINT FILE AND ADD LABEL LIST       */
/*********************************************************************/
             PGM
             DCL        VAR(&P) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&TQRY) TYPE(*CHAR) LEN(1)


/* ADD TLA LIBRARY TO LIBRARY LIST */
             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2103)
             RTVDTAARA  DTAARA(SOWQRYCL (1 10)) RTNVAR(&P)

/* GET QUERY TO RUN LIST */
             QSYS/RTVDTAARA DTAARA(*LDA (66 1)) RTNVAR(&TQRY)

/* GET LABEL PRINT FILE */
             RUNQRY     QRY(LABALL) QRYFILE((*SAME))
             CALL       PGM(LBLBATCH) PARM(LBLMIX4 LALBQT '0000'  +
                          P4 LABL '01' *YES LBLMX4 QS36F LBLMX4 *ALL)

             IF         COND(&TQRY = '1') THEN(GOTO CMDLBL(PROD))
             IF         COND(&TQRY = '2') THEN(GOTO CMDLBL(UPDT))

 PROD:       RUNQRY     QRY(LABLISTP) OUTTYPE(*PRINTER) PRTDEV(&P)
             GOTO       CMDLBL(END)

 UPDT:       RUNQRY     QRY(LABLISTU) OUTTYPE(*PRINTER) PRTDEV(&P)
             GOTO       CMDLBL(END)

/* REMOVE TLA LIBRARY TO LIBRARY LIST */
 END:        RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2104)


             ENDPGM
