/*********************************************************************/
/*   PROGRAM-------- SAR420C                                        */
/*   DATE WRITTEN--- 03/03/04                                        */
/*   PROGRAMMER----- R.PIASECKI                                      */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL   VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL   VAR(&ITEM) TYPE(*CHAR) LEN(12)
             DCL   VAR(&SIZE) TYPE(*CHAR) LEN(3)
             DCL   VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             DCL   VAR(&DFILE) TYPE(*CHAR) LEN(1)
             DCL   VAR(&F3) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)

             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)

/*           CALL       PGM(KUBEPAK400/KUBEALLLBL) /* get library + */
/*                        list */

 SELECT:  /* WB ADD */
             CHGVAR     VAR(&ITEM) VALUE('                ')
             CALL       PGM(SCRPMTR) PARM(&DATE &ITEM &SIZE &OUTQ +
                          &COPY &HOLD &SAVE &DFILE &F3)
/*?If F3 pressed, end the program                  ?           */

             IF         COND(&F3 = '1') THEN(DO)
               GOTO       CMDLBL(ENDPGM)
             ENDDO


                  OVRPRTF FILE(SCR420P)    +
                          PAGESIZE(66  96) LPI(6) CPI(12) +
                          ALIGN(*NO) OUTQ(&OUTQ) FORMTYPE(*NAR) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             CALL       PGM(SCR420R) PARM(&DATE &ITEM &SIZE)
             GOTO       CMDLBL(SELECT) /* WB ADD */


/*           IF         COND(&DFILE = 'Y') THEN(DO)  */
/*                                               */
/*           CLRPFM     FILE(FMOVCNT1)           */
/*           CLRPFM     FILE(FMOVJB1)            */

/*           ENDDO                               */

ENDPGM:      ENDPGM
