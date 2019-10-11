
/*?                                                     ??*/
/*? *********                                   *********  ?*/
/*? *********                                   *********  ?*/
/*?*********                                   *********??*/

/*?  PROCEDURE NAME    - APH002C                           ?*/
/*?  FUNCTION  - RUN A/P HISTORY FILE PURGE PROGRAM        ?*/
/*?                                                        ?*/
             PGM

             DCL        VAR(&SBDT)      TYPE(*CHAR) LEN(8)
             DCL        VAR(&FKEY)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&RPLY)      TYPE(*CHAR) LEN(8)
             DCL        VAR(&SAVF)      TYPE(*CHAR) LEN(10)

 WRTAPE:     SNDUSRMSG  MSG('No tape required for PURGED A/P +
                          History  Type "GO" to Continue or +
                          "CANCEL"') TOMSGQ(*) MSGRPY(&RPLY)

             IF         (&RPLY='GO') THEN(GOTO CONT)
             IF         (&RPLY='CANCEL') THEN(GOTO CANCEL)

             GOTO       WRTAPE
/*?  Call parameter selection program - APH002R            ?*/

CONT:        CLRPFM     FILE(TGMSDATA/PGAPHIST)
             CALL       PGM(APH002R) PARM(&SBDT &FKEY)

             IF         COND(&FKEY = '12') THEN(GOTO CMDLBL(CANCEL))

            CPYF FROMFILE(PGAPHIST) TOFILE(TGMSDATA/('AP' *CAT &SBDT)) +
                          MBROPT(*NONE) CRTFILE(*YES)

/*?  Save Purged Data to Tape for Archiving Purposes       ?*/

/*?  ADDED FOR TEST                                        ?*/
/*           GOTO       CMDLBL(END)                         */
/*?  END OF ADD FOR TEST                                   ?*/
            RGZPFM FILE(TGMSDATA/FAPDTP)

             CHGVAR     VAR(&SAVF) VALUE('AP' *CAT &SBDT)
             CRTSAVF    FILE(SAVLIB/&SAVF)
             MONMSG     MSGID(CPF7302)

   /*       SAVOBJ     OBJ('AP' *CAT &SBDT) LIB(TGMSDATA) DEV(TAP01) +
                       LABEL('AP' *CAT &SBDT)     */
             SAVOBJ     OBJ(('AP' *CAT &SBDT)) LIB(TGMSDATA) +
                          DEV(*SAVF) SAVF(SAVLIB/&SAVF)

            CLRPFM FILE(TGMSDATA/PGAPHIST)
            DLTF FILE(TGMSDATA/('AP' *CAT &SBDT))

             GOTO       CMDLBL(END)

/*?  Cancel request                                        ?*/

CANCEL:      SNDPGMMSG  MSG('Purge cancelled at user''s request')

END:         SNDPGMMSG  MSG('PURGE OF A/P HISTORY FILE DETAIL COMPLETE')
/*?  End program                                           ?*/
             ENDPGM
