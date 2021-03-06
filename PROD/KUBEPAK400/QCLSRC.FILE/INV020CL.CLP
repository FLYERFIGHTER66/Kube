/*********************************************************************/
/*   PROGRAM-------- INV020CL                                        */
/*   DATE WRITTEN--- 06 NOV 2018                                     */
/*   PROGRAMMER----- BILL BEHR                                       */
/*   DESCRIPTION---- Scheduler to RUN INV020                         */
/*   PARAMETERS----- EndTime, Minutes                                */
/*                                                                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ENDTIME &MINUTES@)

             DCL        VAR(&ENDTIME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MINUTES@) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MINUTES)  TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&SECONDS)  TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&JOB)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)      TYPE(*CHAR) LEN(6)
             DCL        VAR(&LIBR)     TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             SBMJOB     CMD(ENDJOB JOB(&NBR/&USER/&JOB)) +
                          JOB(X_INV020) JOBD(*LIBL/KUBE_NOLOG) +
                          JOBQ(QBATCH2) HOLD(*NO) SCDTIME(&ENDTIME)

             CHGVAR     VAR(&MINUTES) VALUE(&MINUTES@)
             CHGVAR     VAR(&SECONDS) VALUE((&MINUTES) * 60)

 START:
/*? RUN SUPPLIER INVENTORY COMPONENT UPDATE ?*/
             SBMJOB     CMD(CALL PGM(INV020)) JOB(INV020) +
                          JOBD(*LIBL/KUBE_NOLOG) JOBQ(QBATCH2) +
                          MSGQ(*NONE)
             IF         COND(&MINUTES *EQ 0) THEN(GOTO CMDLBL(EOJ))
             DLYJOB     DLY(&SECONDS)
             GOTO       CMDLBL(START)

 EOJ:        ENDPGM
