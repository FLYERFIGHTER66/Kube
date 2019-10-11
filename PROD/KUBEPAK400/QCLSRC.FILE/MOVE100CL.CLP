/*********************************************************************/
/*   PROGRAM-------- MOVE100CL                                      */
/*   DATE WRITTEN--- 02/05/04                                        */
/*   PROGRAMMER----- R.PIASECKI                                      */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL   VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             DCL   VAR(&DFILE) TYPE(*CHAR) LEN(1)
             DCL   VAR(&F3) TYPE(*CHAR) LEN(1)

/*           CALL       PGM(KUBEPAK400/KUBEALLLBL) /* get library + */
/*                        list */

            CALL       PGM(MOV100R) PARM(&OUTQ &COPY &HOLD &SAVE  +
                        &DFILE &F3)
/*?If F3 pressed, end the program                  ?           */

             IF         COND(&F3 = '1') THEN(DO)
               GOTO       CMDLBL(ENDPGM)
             ENDDO


             QSYS/OVRPRTF FILE(QPRINT) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(88 120) LPI(8) CPI(15) +
                          ALIGN(*NO) OUTQ(&OUTQ) FORMTYPE(*NAR) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             CALL       PGM(MOVR100)


             IF         COND(&DFILE = 'Y') THEN(DO)

             CLRPFM     FILE(FMOVCNT1)
             CLRPFM     FILE(FMOVJB1)

             ENDDO

ENDPGM:      ENDPGM
