/*********************************************************************/
/*   PROGRAM-------- TRC510CL                                        */
/*   DATE WRITTEN---  1/10/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- TRUCK SCHEDULE                                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TRTRK# &TRSHDT@)

             DCL        VAR(&TRUCK)   TYPE(*CHAR)  LEN(10)
             DCL        VAR(&TRTRK#)  TYPE(*CHAR)  LEN(4)
             DCL        VAR(&TRSHDT@) TYPE(*CHAR)  LEN(7)

             CHGVAR     VAR(&TRUCK) VALUE('TRUCK_' *CAT &TRTRK#)
             SBMJOB     CMD(CALL PGM(*LIBL/TRR502) PARM(&TRTRK# +
                          &TRSHDT@)) JOB(&TRUCK) JOBD(KUBEPAK) +
                          JOBQ(TRUCKS) JOBPTY(9)

             ENDPGM
