/*********************************************************************/
/* Program? -  KP4010C                                              */
/* Purpose? -  Print the Inventory Transaction Register within      */
/*              date range by user or all users                      */
/*                                                                   */
/*  Date  ?  Programmer  ?  Comment                              ?*/
/* 02/15/03    R. Piasecki     PGM CREATED                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&USER &FDTE &TDTE &OUTQ &FKEY)

             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&FDTE)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&TDTE)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&OUTQ)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&FKEY)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&NRCDS) TYPE(*DEC)  LEN(10 0)




/*?Call prompt screen program                                  ?*/

             DLTF       FILE(TRANWORK)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(KP4010R) PARM(&USER &FDTE &TDTE +
                          &OUTQ &FKEY)

/*?If F3 pressed, end the program                  ?           */

             IF         COND(&FKEY = '03') THEN(DO)
               GOTO       CMDLBL(ENDPGM)
             ENDDO

/*?If User not Entered to to nouser                     ?           */

             IF         COND(&USER = '          ') THEN(DO)
               GOTO       CMDLBL(NOUSER)
             ENDDO

/* SELECT TRANSACTION DETAIL FOR SELECTED DATE RANGE */
             DLTF       FILE(TRANWORK)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(KPHIST) SHARE(*YES)
             OPNQRYF    FILE((KPHIST))                 +
             QRYSLT('DHUSER  *EQ "' *CAT &USER *CAT '"   *AND       +
                     TRNDTE *GE "' *CAT &FDTE *CAT '" *AND       +
                     TRNDTE *LE "' *CAT &TDTE *CAT '"')          +
                     KEYFLD((DHUSER) (DHCYMD) (DHPITM) (DHPSIZ)) +
                     MAPFLD((DT DHCYMD *ZONED 8)       +
                            (TRNDTE DT  *CHAR  8))

             CPYFRMQRYF FROMOPNID(KPHIST) TOFILE(TGMSDATA/TRANWORK) +
                          MBROPT(*NONE) CRTFILE(*YES)
/* Have performed selections, Check to see if any Invoices met  +
   selection criteria. Bypass if no Invoices selected               */
             RTVMBRD    FILE(*LIBL/TRANWORK)  NBRCURRCD(&NRCDS)
             IF         COND(&NRCDS *EQ 0) THEN(DO)
             DLTOVR     FILE(*ALL)
             SNDPGMMSG  MSG('No Records met the Selection Criteria for +
                        USER and DATES Entered')
             CLOF       OPNID(KPHIST)

             DLTOVR     FILE(*ALL)

             GOTO       CMDLBL(ENDPGM)
             ENDDO

             GOTO       CMDLBL(PRNTIT)

/* SELECT TRANSACTION DETAIL FOR SELECTED DATE RANGE ONLY */
NOUSER:      DLTF       FILE(TRANWORK)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(KPHIST) SHARE(*YES)
             OPNQRYF    FILE((KPHIST))                 +
             QRYSLT('TRNDTE *GE "' *CAT &FDTE *CAT '" *AND       +
                     TRNDTE *LE "' *CAT &TDTE *CAT '"')          +
                     KEYFLD((DHCYMD) (DHPITM) (DHPSIZ))  +
                     MAPFLD((DT DHCYMD *ZONED 8)       +
                            (TRNDTE DT  *CHAR  8))

             CPYFRMQRYF FROMOPNID(KPHIST) TOFILE(TGMSDATA/TRANWORK) +
                          MBROPT(*NONE) CRTFILE(*YES)

             RTVMBRD    FILE(*LIBL/TRANWORK)  NBRCURRCD(&NRCDS)
             IF         COND(&NRCDS *EQ 0) THEN(DO)
             DLTOVR     FILE(*ALL)
             SNDPGMMSG  MSG('No Records met the Selection Criteria for  +
                        Dates entered')
             CLOF       OPNID(KPHIST)

             DLTOVR     FILE(*ALL)

             GOTO       CMDLBL(ENDPGM)
             ENDDO



/* Print Transaction History Report                           */
PRNTIT:
             OVRPRTF    FILE(KP0011P) OUTQ(&OUTQ)

             CALL       PGM(KP4011R) PARM(&USER &FDTE &TDTE)

             CLOF       OPNID(KPHIST)

             DLTOVR     FILE(*ALL)


ENDPGM:         ENDPGM



