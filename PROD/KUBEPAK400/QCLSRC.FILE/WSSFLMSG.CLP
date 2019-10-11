/*     ? Program        : WSSFLMSG                                  */
/*     ?                                                            */
/*     ? Description    : This pgm to Send and Clear Messages from  */
/*     ?                  Message Subfile                           */
/*     ? Created By     : S.Uthayadurga                             */
/*     ?                                                            */
/*     ? Date           : 09 Nov 2017                               */
/********************************************************************/
         PGM        PARM(&MSGF &MSGID &MSGOPT)

         DCL        VAR(&MSGF)   TYPE(*CHAR) LEN(10)
         DCL        VAR(&MSGID)  TYPE(*CHAR) LEN(7)
         DCL        VAR(&MSGOPT) TYPE(*CHAR) LEN(1)

/*     ? Send Message                                               */
         IF         COND(&MSGOPT *EQ 'I') THEN(SNDPGMMSG +
                           MSGID(&MSGID) MSGF(&MSGF))

/*     ? Clear Message                                              */
         IF         COND(&MSGOPT *EQ 'C') THEN(RMVMSG PGMQ(*PRV +
                    (*)) CLEAR(*ALL))


         ENDPGM
