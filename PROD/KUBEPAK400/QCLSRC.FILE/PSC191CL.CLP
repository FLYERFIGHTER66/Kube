/*********************************************************************/
/*   PROGRAM-------- PSC191CL                                        */
/*   DATE WRITTEN--- 12/12/11                                        */
/*   PROGRAMMER----- WILLIAM BEHR                                    */
/*   DESCRIPTION---- CHANGE THE MONDAY FRIDAY READY BAY DATE         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCLF  FILE(PSC191FM)

SCRNA:
             RTVDTAARA  DTAARA(PSC191 *ALL) RTNVAR(&DAYSBACK)
             RTVDTAARA  DTAARA(PSC191 *ALL) RTNVAR(&DAYSBACKS)
             SNDRCVF
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(EOJ))
             IF         COND(&DAYSBACK *EQ &DAYSBACKS) THEN(GOTO CMDLBL(EOJ))
             CHGDTAARA  DTAARA(PSC191 *ALL) VALUE(&DAYSBACK)
             GOTO       CMDLBL(SCRNA)

 EOJ:        ENDPGM
