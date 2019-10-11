/*********************************************************************/
/*   PROGRAM-------- SATURDAY                                        */
/*   DATE WRITTEN---  2/22/99                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SAVE ALL USER LIBS AND RUN NORMAL NIGHT         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             CALL       PGM(KUBEPAK400/KUBEALLLBL)

             ENDSBS     SBS(QINTER) OPTION(*IMMED)
             ENDSBS     SBS(QBATCH) OPTION(*IMMED)

             CALL       PGM(NIGHTS)
/*           INZTAP     DEV(TAP01) NEWVOL(BACK01) CHECK(*NO) +     +
 +                        DENSITY(*CTGTYPE)                        +
 +                                                                 +
 +           SAVSECDTA  DEV(TAP01)                                 +
 +           SAVCFG     DEV(TAP01)                                 +
 +           SAVLIB     LIB(*ALLUSR) DEV(TAP01)                    +
 +           MONMSG     MSGID(CPF3777)                            */
             CALL       PGM(TSAVE_ALL) /* Use TSAVE_ALL on Saturday ALSO. 2018-10-01 */

/* NOW START QINTER SUB SYSTEM                  */
             STRSBS     SBSD(QINTER) /* Start Sub System after +
                          backup. */
             MONMSG     MSGID(CPF1010)

/* NOW START BATCH SUB SYSTEM                  */
             STRSBS     SBSD(QBATCH) /* Start Sub System after +
                          backup. */
             MONMSG     MSGID(CPF1010)


/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (201 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('SATURDAY  ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE('00')
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Save All User +
                          Libraries.')
             CALL       PGM(STSUPD)

             ENDPGM
