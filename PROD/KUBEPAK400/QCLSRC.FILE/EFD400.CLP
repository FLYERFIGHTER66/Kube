/*                                     EFD400      8/03/98 15:56:11 */
             CRTCTLAPPC CTLD(EFD400) LINKTYPE(*SDLC) ONLINE(*NO) +
                          SWITCHED(*YES) SHM(*NO) APPN(*YES) +
                          MAXFRAME(521) RMTNETID(*NETATR) +
                          RMTCPNAME(EFD400) EXCHID(05600001) +
                          INLCNN(*ANS) ROLE(*NEG) STNADR(01) +
                          CPSSN(*YES) NODETYPE(*ENDNODE) +
                          TMSGRPNBR(1) MINSWTSTS(*VRYONPND) +
                          AUTOCRTDEV(*ALL) AUTODLTDEV(*NO) +
                          USRDFN1(*LIND) USRDFN2(*LIND) +
                          USRDFN3(*LIND) TEXT('Controller desc for +
                          pass thru from EFD') CODE(*EBCDIC) +
                          PREDIALDLY(6) REDIALDLY(120) DIALRTY(2) +
                          SWTDSC(*YES) DSCTMR(170 0) POLLPTY(*NO) +
                          POLLLMT(0) OUTLMT(*POLLLMT) CNNPOLLRTY(7) +
                          NDMPOLLTMR(*CALC) CMNRCYLMT(2 5)
CRTDEVAPPC DEVD(EFD400) RMTLOCNAME(EFD400) ONLINE(*NO) +
             LCLLOCNAME(*NETATR) RMTNETID(*NETATR) CTL(EFD400) +
             MODE(*NETATR) MSGQ(*LIBL/QSYSOPR) APPN(*YES) +
             SNGSSN(*NO) TEXT('device desc for passthru to EFD') +
             LOCADR(00)
CHGCTLAPPC CTLD(EFD400) SWTLINLST(PTLINE)
