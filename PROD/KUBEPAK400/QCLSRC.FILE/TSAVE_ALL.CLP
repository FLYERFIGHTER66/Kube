             PGM
                                                                             /*+
 ?.............................................................                +
 ?:                                                           :                +
 ?:                 ?     TSAVE_ALL     ?                     :                +
 ?:                                                         ?:                +
 ?:  Date   | Who | Description                             ?:                +
 ?:?Description   ?:?Daily Save of Security Settings, Config ?:                +
 ?:?        ? ?   ?:?Settings and all User Libraries.        ?:                +
 ?:?        ? ?   ?:?- This program replaces TSAVE in the    ?:                +
 ?:?              ?:?  nightly processing.                   ?:                +
 ?:?Date          ?: Created February 8th, 2005              ?:                +
 ?:?Programmer    ?:?William J. Behr                         ?:                +
 ?:...........................................................:                +
 ?............................................................................ +
 ?:                                                                          : +
 ?:            ?     Program Change Log     ?                                : +
 ?:                                                                        ?: +
 ?:  Date   | Who | Description                                            ?: +
 ?:?02/08/05?|?WJB?|?Initial PGM copied from TSAVE.                         ?: +
 ?:?02/08/05?|?WJB?|?Changed PGM to do complete backup                      ?: +
 ?:?        ?|?   ?|? instead of just select Libraries.                     ?: +
 ?:?07/28/05?|?WJB?|?Changed code to skip backup here if                    ?: +
 ?:?        ?|?   ?|? there is no tape available.                           ?: +
 ?:?09/03/10?|?WJB?|?ADDED "SAV" COMMAND FOR IFS                            ?: +
 ?:?08/27/18?|?WJB?|?ADDED SAVDLO COMMAND / implemented SUBR                ?: +
 ?:?09/25/18?|?WJB?|?REWRITE FOR TAPMLB01 INSTEAD OF TAP01                  ?: +
 ?:?10/05/18?|?WJB?|?ADDED LOGIC FOR GENERIC TAPE IS REQ'D TAPE IS MISSING  ?: +
 ?:?__/__/__?|?___?|?_______________________________________________________?: +
 ?:?        ?|?   ?|?                                                       ?: +
 ?:?        ?|?   ?|?                                                       ?: +
 ?:..........................................................................:*/

             DCL        VAR(&ERR_CNT) TYPE(*DEC) LEN(2 0) VALUE(0)
             DCL        VAR(&ERR_CNT@) TYPE(*Char) LEN(2)
             DCL        VAR(&CTGNAM)   TYPE(*Char) LEN(6)
             DCL        VAR(&TAPDAY)   TYPE(*Char) LEN(1)

             CALLSUBR   SUBR(SETLDA)
             CALLSUBR   SUBR(INZTAP)
             CALLSUBR   SUBR(SAVSECDTA)
             CALLSUBR   SUBR(SAVCFG)
             CALLSUBR   SUBR(SAVDLO)
             CALLSUBR   SUBR(ALLUSR)
             CALLSUBR   SUBR(SAV)
             IF         COND(&ERR_CNT *NE 0) THEN(CALLSUBR (ERROR))
             CALLSUBR   SUBR(STATUS)
             RETURN

                                                                             /*+
?    LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE                              */
             SUBR       SUBR(SETLDA)
             SNDMSG     MSG('The backup is starting') TOUSR(*SYSOPR)
             CHGDTAARA  DTAARA(*LDA (201 44)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (201 14)) VALUE('TSAVE_ALL 0000')
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Save All but System')
             ENDSUBR
                                                                             /*+
?    Initialize the Tape as a Backup Tape                                     */
             SUBR       SUBR(INZTAP)
             SNDMSG     MSG('Initializing the Tape (INZTAP)') +
                          TOUSR(*SYSOPR)
             CALL       PGM(#TAPDAY) PARM(&TAPDAY)

             IF         COND(&TAPDAY <= '5') THEN(DO)
 DAILY:      CHGVAR     VAR(&CTGNAM) VALUE('KP00' *TCAT &TAPDAY *TCAT 'D')
             CHKTAP     DEV(TAPMLB01) VOL(&CTGNAM)
             MONMSG     MSGID(CPF412C CPF6708) EXEC(GOTO +
                          CMDLBL(GENERIC))
             ENDDO
             ELSE DO
 WEEKLY_1:   CHGVAR     VAR(&CTGNAM) VALUE('KP001W')
             CHKTAP     DEV(TAPMLB01) VOL(KP001W)
             MONMSG     MSGID(CPF412C CPF6708) EXEC(GOTO +
                          CMDLBL(WEEKLY_2))
             GOTO       CMDLBL(INITBACKUP)
 WEEKLY_2:   CHGVAR     VAR(&CTGNAM) VALUE('KP002W')
             CHKTAP     DEV(TAPMLB01) VOL(KP002W)
             MONMSG     MSGID(CPF412C CPF6708) EXEC(GOTO +
                          CMDLBL(GENERIC))
             ENDDO
             GOTO       CMDLBL(INITBACKUP)

 GENERIC:    CHKTAP     DEV(TAPMLB01) VOL(KP010D) /*  IF REQUIRED TAPE IS MISSING, USE KP010D */
             MONMSG     MSGID(CPF412C) EXEC(DO)
             SNDMSG     MSG('*** URGENT ***  The TSAVE_ALL program +
                          could not find an appropriate backup tape +
                          to use for the nightly save (all) +
                          process.  A backup was NOT performed.') +
                          TOUSR(*SYSOPR)
             RETURN
             ENDDO

 INITBACKUP: INZTAP     DEV(TAPMLB01) NEWVOL(&CTGNAM) VOL(&CTGNAM) +
                          CHECK(*NO) DENSITY(*CTGTYPE) CLEAR(*NO)
             SNDMSG     MSG('Initialized volume' *BCAT &CTGNAM) +
                          TOUSR(*SYSOPR)
 END_INZTAP: ENDSUBR
                                                                             /*+
?    Backup Security Data                                                     */
             SUBR       SUBR(SAVSECDTA)
             SNDMSG     MSG('Backup Security Data (SAVSECDTA)') +
                          TOUSR(*SYSOPR)
             SAVSECDTA  DEV(TAPMLB01) VOL(&CTGNAM) ENDOPT(*LEAVE)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERR_CNT) +
                          VALUE(&ERR_CNT + 1))
             ENDSUBR
                                                                             /*+
?    Backup Configuration Files                                               */
             SUBR       SUBR(SAVCFG)
             SNDMSG     MSG('Backup Configuration Files (SAVCFG)') +
                          TOUSR(*SYSOPR)
             SAVCFG     DEV(TAPMLB01) VOL(&CTGNAM) ENDOPT(*LEAVE)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERR_CNT) +
                          VALUE(&ERR_CNT + 1))
             ENDSUBR
                                                                             /*+
?    Backup Document Library Objects                                          */
             SUBR       SUBR(SAVDLO)
             SNDMSG     MSG('Backup Document Library Objects (SAVDLO)') +
                          TOUSR(*SYSOPR)
             SAVDLO     DLO(*ALL) DEV(TAPMLB01) VOL(&CTGNAM) +
                          ENDOPT(*LEAVE)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERR_CNT) +
                          VALUE(&ERR_CNT + 1))
             ENDSUBR
                                                                             /*+
?    Backup all User Libraries                                                */
             SUBR       SUBR(ALLUSR)
             SNDMSG     MSG('Backup all User Libraries (SAVLIB +
                          LIB(*ALLUSR))') TOUSR(*SYSOPR)
             SAVLIB     LIB(*ALLUSR) DEV(TAPMLB01) VOL(&CTGNAM) +
                          ENDOPT(*LEAVE)
             MONMSG     MSGID(CPF3701 CPF3796 CPF3777)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERR_CNT) +
                          VALUE(&ERR_CNT + 1))
             ENDSUBR
                                                                             /*+
?    Backup Shared Disk Space                                                 */
             SUBR       SUBR(SAV)
             SNDMSG     MSG('Backup Shared Disk Space (SAV)') +
                          TOUSR(*SYSOPR)
             SAV        DEV('/QSYS.LIB/TAPMLB01.DEVD') OBJ(('/*') +
                          ('/QSYS.LIB' *OMIT) ('/QDLS' *OMIT)) +
                          VOL(&CTGNAM) ENDOPT(*UNLOAD) UPDHST(*YES)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERR_CNT) +
                          VALUE(&ERR_CNT + 1))
    /* Sample Restore: +
       RST     DEV('/QSYS.LIB/TAPMLB01.DEVD') OBJ(('/KUBE PAK')) VOL(&CTGNAM) */

             ENDSUBR
                                                                             /*+
?    Error routine                                                            */
             SUBR       SUBR(ERROR)
             DMPCLPGM
             CHGVAR     VAR(&ERR_CNT@) VALUE(&ERR_CNT)
             SNDMSG     MSG('Backup completed with' *BCAT &ERR_CNT@ +
                          *BCAT 'errors.  Check the Program dump to +
                          verify sufficient backup.') TOUSR(*SYSOPR)
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Save Data +
                          Files:' *BCAT &ERR_CNT@ *BCAT 'errors')
             ENDSUBR
                                                                             /*+
?    Error reporting Routine                                                  */
             SUBR       SUBR(STATUS)
 STATUS:     CALL       PGM(STSUPD)
             ENDSUBR

             ENDPGM
