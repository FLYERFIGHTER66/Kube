/*********************************************************************/
/* Program? -  SS0001C                                              */
/* Purpose? -  Maintain System Security Master File                 */
/*                                                                   */
/*?                                                                 ?*/
/*?* * * * * * * *    Program Maintenance Log      * * * * * * * * *?*/
/*   Date  ? Programmer       ? Comment                          ?*/
/* 8/14/2003   Richard E. Piasecki Program created                   */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&PASS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FKEY) TYPE(*CHAR) LEN(2)

/*?    Call the password entry program                       ?*/

             CALL       PGM(PSSWRDR) PARM(&PASS &FKEY)

/*?If incorrect password entered, issue error message, end program  ?*/

             IF         COND(&PASS = 'N') THEN(DO)
                        SNDPGMMSG MSGID(SS99999) MSGF(KPMSGF)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO

/*?If F3 pressed, end program                                       ?*/

             IF         COND(&FKEY = '03') THEN(DO)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO


/*?Call the system security program                                 ?*/
             CALL       PGM(SS0001R)

ENDPGM:      ENDPGM
