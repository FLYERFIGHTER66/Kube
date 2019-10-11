/*********************************************************************/
/*   PROGRAM-------- SCR421C                                         */
/*   DATE WRITTEN---  3/16/04                                        */
/*   DESCRIPTION---- PRINT UN-PRINTED ITEMS location customer/truck  */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL   VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL   VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             DCL   VAR(&F3) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)

            CALL       PGM(NCRPMTR1) PARM(&DATE &OUTQ &COPY            &HOLD  +
                         &SAVE  &F3)
/*?If F3 pressed, end the program                  ?           */

             IF         COND(&F3 = '1') THEN(DO)
               GOTO       CMDLBL(ENDPGM)
             ENDDO



             OVRPRTF FILE(NCR421P)  +
                          PAGESIZE(66  96) LPI(6) CPI(12) +
                          ALIGN(*NO) OUTQ(&OUTQ) FORMTYPE(*NAR) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             CALL       PGM(NCR421R) PARM(&DATE)


ENDPGM:      ENDPGM
