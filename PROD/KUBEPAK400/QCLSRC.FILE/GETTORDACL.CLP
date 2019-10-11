/*********************************************************************/
/*   PROGRAM-------- GETTORDACL                                      */
/*   DATE WRITTEN--- 05/07/01                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- REBUILD VALUE OF OPEN ORDERS IN FMCUST          */
/*   REVISIONS------                                                 */
/*  3/04/02 EFD ADD UPDATE BROKER I.D.                               */
/*********************************************************************/
             PGM

/*   PURGE UNNEED RECORDS                                            */
             CALL       PGM(PRGOPNORD)

/*   REORG FOPNORD                                                   */
             RGZPFM     FILE(FOPNORD)
             MONMSG     MSGID(CPF2981)

/*   GET VALUE INTO MCUST                                            */
             OVRDBF     FILE(FMCUSTC) TOFILE(FMCUST)
             CALL       PGM(GETTORDALL)

     END:    ENDPGM
