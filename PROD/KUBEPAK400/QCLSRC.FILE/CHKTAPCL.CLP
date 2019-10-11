             PGM
             DCL        VAR(&TAPDAY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CTGNAM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MSG)    TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF67AB)

             ADDTAPCTG  DEV(TAPMLB01)  +
                        CTG(KP001D KP002D KP003D  KP004D KP005D KP010D KP001W KP002W)
             CALL       PGM(#TAPDAY) PARM(&TAPDAY)
             CHGVAR     VAR(&CTGNAM) VALUE('KP00' *TCAT &TAPDAY *TCAT 'D')

             IF         COND(&TAPDAY <= '5') THEN(DO)
 DAILY:      CHKTAP     DEV(TAPMLB01) VOL(&CTGNAM)
             MONMSG     MSGID(CPF412C) EXEC(CALLSUBR SUBR(GENERIC))
             SNDMSG     MSG('Tape checked at this time.  Found +
                          Cartridge ' *BCAT &CTGNAM *TCAT '. +
                          Okay!!') TOUSR(*SYSOPR)
             RETURN
             ENDDO
             ELSE DO
             CHGVAR     VAR(&CTGNAM) VALUE('Weekly')
 WEEKLY_1:   CHKTAP     DEV(TAPMLB01) VOL(KP001W)
             MONMSG     MSGID(CPF412C) EXEC(GOTO CMDLBL(WEEKLY_2))
             SNDMSG     MSG('Tape checked at this time.  Found +
                          Cartridge KP001W. Okay!!') TOUSR(*SYSOPR)
             RETURN
 WEEKLY_2:   CHKTAP     DEV(TAPMLB01) VOL(KP002W)
             MONMSG     MSGID(CPF412C) EXEC(GOTO CMDLBL(WEEKLY_NA))
             SNDMSG     MSG('Tape checked at this time.  Found +
                          Cartridge KP002W. Okay!!') TOUSR(*SYSOPR)
             RETURN
 WEEKLY_NA:  CALLSUBR SUBR(SNDERRMSG)
             RETURN
             ENDDO
                                                                           /* +
----------------------------------------------------------------------------*/
             SUBR       SUBR(GENERIC)
                                                                            /* +
 ?           BEFORE JUST FAILING, SEE IF THE GENERIC TAPE +                    +
 ?           KP010D, IS AVAILABLE.  IF SO SEND AN ERROR MESSAGE +              +
 ?           STATING THAT WE ARE USING A GENERIC TAPE.  +                      +
 ?           ... OTHERWISE SEND THE FAILURE MESSAGE.                          */

 DAILY:      CHKTAP     DEV(TAPMLB01) VOL(KP010D)
             MONMSG     MSGID(CPF412C) EXEC(CALLSUBR SUBR(SNDERRMSG))
             SNDMSG     MSG('Tape checked at this time.  Cartridge ' +
                          *BCAT &CTGNAM *BCAT 'NOT found. Using +
                          Generic Tape KP010D') TOUSR(*SYSOPR)
             RETURN
             ENDSUBR

                                                                           /* +
----------------------------------------------------------------------------*/
             SUBR       SUBR(SNDERRMSG)
             CHGVAR     VAR(&MSG) VALUE('The correct Tape for today +
                          <<' *TCAT &CTGNAM *TCAT '>> is not +
                          loaded in the Tape Library.')
             SNDBRKMSG  MSG(&MSG) TOMSGQ(DSP015_1 DSP015_2 DSP015_3)
             SNDBRKMSG  MSG(&MSG) TOMSGQ(DSP014_01 DSP014_02 DSP014_03)
             SNDBRKMSG  MSG(&MSG) TOMSGQ(DSP013_1 DSP013_2 DSP013_3)
             RETURN
             ENDSUBR

 EOJ:        ENDPGM
