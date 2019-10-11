/*? Program       : WSPLGORDCL                                        */
/*? Date Written  : 18 JUL 2018                                       */
/*? Programmer    : VIMALA                                            */
/*? Description   : PLUG ORDER ENTRY SCREEN PROGRAM                   */
/*?                 OVERRIDE WORK FILES FOR EACH USER IN QTEMP        */
/*? Parameters    : CALLED FROM MENU                                  */
/*?                                                                   */
/*? Revisions     :                                                   */
/*********************************************************************/
             PGM

/*? Delete Work files in QTEMP                                        */
             DLTF       FILE(QTEMP/WPLGORDL0)
             MONMSG     MSGID(CPF2105)

             DLTF       FILE(QTEMP/WPLGORDPF)
             MONMSG     MSGID(CPF2105)

             DLTF       FILE(QTEMP/WPLGORXML0)
             MONMSG     MSGID(CPF2105)

             DLTF       FILE(QTEMP/WPLGORXML)
             MONMSG     MSGID(CPF2105)

/*? Create duplicate Object in QTEMP File                             */
             CRTDUPOBJ  OBJ(WPLGORDPF) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CRTDUPOBJ  OBJ(WPLGORDL0) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CRTDUPOBJ  OBJ(WPLGORXML) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CRTDUPOBJ  OBJ(WPLGORXML0) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

/*? Override DBF for each user in QTEMP                               */
             OVRDBF     FILE(WPLGORDPF) TOFILE(QTEMP/WPLGORDPF)
             OVRDBF     FILE(WPLGORDL0) TOFILE(QTEMP/WPLGORDL0)
             OVRDBF     FILE(WPLGORXML) TOFILE(QTEMP/WPLGORXML)
             OVRDBF     FILE(WPLGORXML0) TOFILE(QTEMP/WPLGORXML0)

/*? Call Plug Order Entry Screen Program                              */
             CALL       PGM(WSPLGORD01)

             DLTOVR     FILE(WPLGORDL0)
             DLTOVR     FILE(WPLGORDPF)
             DLTOVR     FILE(WPLGORXML0)
             DLTOVR     FILE(WPLGORXML)

             DLTF       FILE(QTEMP/WPLGORDL0)
             MONMSG     MSGID(CPF2105)

             DLTF       FILE(QTEMP/WPLGORDPF)
             MONMSG     MSGID(CPF2105)

             DLTF       FILE(QTEMP/WPLGORXML0)
             MONMSG     MSGID(CPF2105)

             DLTF       FILE(QTEMP/WPLGORXML)
             MONMSG     MSGID(CPF2105)

             ENDPGM
