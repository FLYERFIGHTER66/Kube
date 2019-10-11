/*********************************************************************/
/*   PROGRAM-------- WSORDSCDCL                                      */
/*   DATE WRITTEN--- 07 Jun 2018                                     */
/*   PROGRAMMER----- Vimala                                          */
/*   DESCRIPTION---- Scheduler to GET Purchase Orders from Broker's  */
/*                   Server using FTP based on time and minutes      */
/*   PARAMETERS----- EndTime, Minutes,WSPOEHRFTP,WSPOEHRLOG         */
/*                                                                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ENDTIME &MINUTES@ &PARM1 &PARM2)

             DCL        VAR(&ENDTIME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MINUTES@) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MINUTES)  TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&SECONDS)  TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&JOB)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)      TYPE(*CHAR) LEN(6)
             DCL        VAR(&LIBR)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM1)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM2)    TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             SBMJOB     CMD(ENDJOB JOB(&NBR/&USER/&JOB)) +
                          JOB(CANCELWEB) JOBD(*LIBL/KUBE_NOLOG) +
                          JOBQ(QBATCH2) HOLD(*NO) SCDTIME(&ENDTIME)

             CHGVAR     VAR(&MINUTES) VALUE(&MINUTES@)
             CHGVAR     VAR(&SECONDS) VALUE((&MINUTES) * 60)

 START:
/*? RUN GET FTP to get Purchase Order xml from Broker's FTP Server */
             SBMJOB     CMD(CALL PGM(WSGETFTPC) PARM(&PARM1 &PARM2)) +
                            JOB(WEBBUILD2) +
                          JOBD(*LIBL/KUBE_NOLOG) JOBQ(QBATCH2) +
                          MSGQ(*NONE)
             IF         COND(&MINUTES *EQ 0) THEN(GOTO CMDLBL(EOJ))
             DLYJOB     DLY(&SECONDS)
             GOTO       CMDLBL(START)

 EOJ:        ENDPGM
