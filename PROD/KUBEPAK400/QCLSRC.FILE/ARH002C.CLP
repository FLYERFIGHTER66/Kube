
/*?                                                     ??*/
/*? *********                                   *********  ?*/
/*? *********                                   *********  ?*/
/*?*********                                   *********??*/

/*?  PROCEDURE NAME    - ARH002C                           ?*/
/*?  FUNCTION  - RUN A/R HISTORY FILE PURGE PROGRAM        ?*/
/*?                                                        ?*/
             PGM

             DCL        VAR(&SBDT)      TYPE(*CHAR) LEN(8)
             DCL        VAR(&FKEY)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&RPLY)      TYPE(*CHAR) LEN(8)
             DCL        VAR(&SAVF)      TYPE(*CHAR) LEN(10)

 WRTAPE:     SNDUSRMSG  MSG('No Tape required for PURGED A/R +
                          History  Type "GO" to Continue or +
                          "CANCEL"') TOMSGQ(*) MSGRPY(&RPLY)

             IF         (&RPLY='GO') THEN(GOTO CONT)
             IF         (&RPLY='CANCEL') THEN(GOTO CANCEL)

             GOTO       WRTAPE
/*?  Call parameter selection program - RCS001R            ?*/

CONT:        CLRPFM     FILE(TGMSDATA/PGARHIST)
             CALL       PGM(ARH002R) PARM(&SBDT &FKEY)

             IF         COND(&FKEY = '12') THEN(GOTO CMDLBL(CANCEL))

            CPYF FROMFILE(PGARHIST) TOFILE(TGMSDATA/('AR' *CAT &SBDT)) +
                          MBROPT(*NONE) CRTFILE(*YES)

/*?  Save Purged Data to Tape for Archiving Purposes       ?*/

/*?  ADDED FOR TEST                                        ?*/
/*           GOTO       CMDLBL(END)                         */
/*?  END OF ADD FOR TEST                                   ?*/

             CHGVAR     VAR(&SAVF) VALUE('AR' *CAT &SBDT)
             CRTSAVF    FILE(SAVLIB/&SAVF)
             MONMSG     MSGID(CPF7302)

   /*       SAVOBJ     OBJ('AR' *CAT &SBDT) LIB(TGMSDATA) DEV(TAP01) +
                       LABEL('AR' *CAT &SBDT)     */
             SAVOBJ     OBJ(('AR' *CAT &SBDT)) LIB(TGMSDATA) +
                          DEV(*SAVF) SAVF(SAVLIB/&SAVF)


            CLRPFM FILE(TGMSDATA/PGARHIST)
            DLTF FILE(TGMSDATA/('AR' *CAT &SBDT))

             GOTO       CMDLBL(END)

/*?  Cancel request                                        ?*/

CANCEL:      SNDPGMMSG  MSG('Purge cancelled at user''s request')

END:         SNDPGMMSG  MSG('PURGE OF A/R HISTORY FILE DETAIL COMPLETE')
/*?  End program                                           ?*/
             ENDPGM
