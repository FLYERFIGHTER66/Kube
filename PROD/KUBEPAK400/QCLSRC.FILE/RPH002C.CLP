
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

 WRTAPE:     SNDUSRMSG  MSG('Mount tape to save PURGED A/R History  +
                          Type "GO" to Continue or "CANCEL"')         +
                          TOMSGQ(*) MSGRPY(&RPLY)

             IF         (&RPLY='GO') THEN(GOTO CONT)
             IF         (&RPLY='CANCEL') THEN(GOTO CANCEL)

             GOTO       WRTAPE
/*?  Call parameter selection program - RCS001R            ?*/

CONT:
            SAVOBJ     OBJ('AR' *CAT &SBDT) LIB(TGMSDATA) DEV(TAP01) +
                       LABEL('AR' *CAT &SBDT)
            CLRPFM FILE(TGMSDATA/PGARHIST)
            DLTF FILE(TGMSDATA/('AR' *CAT &SBDT))

             GOTO       CMDLBL(END)

/*?  Cancel request                                        ?*/

CANCEL:      SNDPGMMSG  MSG('Purge cancelled at user''s request')

END:         SNDPGMMSG  MSG('PURGE OF A/R HISTORY FILE DETAIL COMPLETE')
/*?  End program                                           ?*/
             ENDPGM
