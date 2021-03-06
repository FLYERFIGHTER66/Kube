/*********************************************************************/
/* Program? -  HG0110C                                              */
/* Purpose? -  Maintain HARD GOODS Return Order File AS/400 Native  */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*  Date  ?  Programmer  ?  Comment                              ?*/
/* 05/19/04    R. PIASECKI     PGM CREATED                           */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&SEC) TYPE(*CHAR) LEN(1)

/*           ADDLIBLE   LIB(APAYFILE) POSITION(*LAST)           */
/*           MONMSG     MSGID(CPF2103)                          */
 /*          ADDLIBLE   LIB(APAY400)  POSITION(*LAST)    */
 /*          MONMSG     MSGID(CPF2103)                   */
 /*          ADDLIBLE   LIB(XAPPFILE) POSITION(*LAST)    */
 /*          MONMSG     MSGID(CPF2103)                   */

             CALL       PGM(HG0110R) PARM(&SEC)

             IF         COND(&SEC = N) THEN(SNDPGMMSG MSGID(SS99999) +
                          MSGF(KPMSGF))

             ENDPGM
