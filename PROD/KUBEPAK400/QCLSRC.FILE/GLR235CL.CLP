/*********************************************************************/
/*   PROGRAM0------- CHP235CL                                        */
/*   DATE WRITTEN---  3/24/03                                        */
/*   PROGRAMMER----- C. BUCK                                         */
/*   DESCRIPTION---- GL ACCOUNT DETAIL REPORT                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/

             /*  DECLARE PROGRAM VARIABLES AND THE DISPLAY FILE */

 DECLARE:    DCL        VAR(&XXACCT)   TYPE(*DEC) LEN(8 0)
             DCL        VAR(&XXFDAT)   TYPE(*DEC) LEN(4 0)
             DCL        VAR(&XXEDAT)   TYPE(*DEC) LEN(4 0)
             DCL        VAR(&JOBNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBUSR)   TYPE(*CHAR) LEN(10)
             DCLF       FILE(GLR235FM)

             /*  DISPLAY THE SELECTION SCREEN */

 PROMPT:     SNDRCVF    RCDFMT(SCRNA)


 CMD_03:     IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(END))

             /*  TURN OFF INDICATORS */

             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')

             /*  MAKE SURE ACCOUNT NUMBER IS NOT ZERO */

             IF         COND(&ACCT# = 0) THEN(DO)
                        CHGVAR VAR(&IN12) VALUE('1')
                        GOTO CMDLBL(PROMPT)
                        ENDDO

             /*  MAKE SURE FROM DATE IS NOT ZERO */

             IF         COND(&FRMDAT = 0) THEN(DO)
                        CHGVAR VAR(&IN10) VALUE('1')
                        GOTO CMDLBL(PROMPT)
                        ENDDO

             /*  MAKE SURE END DATE IS NOT ZERO */

             IF         COND(&ENDDAT = 0) THEN(DO)
                        CHGVAR VAR(&IN11) VALUE('1')
                        GOTO CMDLBL(PROMPT)
                        ENDDO

             /*  SET THE REPORT PARAMETERS */

 CHGVAR:     CHGVAR     VAR(&XXACCT) VALUE(&ACCT#)
             CHGVAR     VAR(&XXFDAT) VALUE(&FRMDAT)
             CHGVAR     VAR(&XXEDAT) VALUE(&ENDDAT)

             /*  RUN THE PROGRAM INTERACTIVELY */

             OVRPRTF FILE(QPRINT) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(88 120) LPI(8) CPI(15) +
                          ALIGN(*NO) OUTQ(P6) FORMTYPE(*NAR)

             CALL       PGM(GLR235) PARM(&ACCT# &FRMDAT &ENDDAT)



  END:       ENDPGM
