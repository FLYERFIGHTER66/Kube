      *? Program        :  WSINNOCALL
      *?
      *? Description    : This program is pass Year and Week to the
      *?                  InnovaPlant url to get data week by week for
      *?                  52 weeks and delete data for that week before
      *?                  uploading new data
      *?
      *? Created By     : Vimala
      *?
      *? Date           : 28 Aug 2018
      //--------------------------------------------------------------------
      *? Special Notes  : a. Use functions InnovaStrt() to get Innovastart date
      *?                : and calculate 52 weeks from the FCALENWEEK file.
      *?                : b. Use the Century/Year/Week to pass to Innovaweek()
      *?                : function to get the Innovaweek.
      *?                : c. The Innovaweek changes Year on Week 40.
      *
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
 VV01 * VV01    09/25/18   Vimala       Include Procedure Interface for the program
 VV02 * VV02    11/02/18   Vimala       Delete old records that have SIAVLDAT < First
 VV02 *                                 Week Date (InnovaStartDate)
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Calendar File Logical by CYMD (Mondays Only)
      *?Key : CLCYMD - Date in CYYMMDD format
        Dcl-F FCALENWEEK Disk(*Ext) Keyed Usage(*Input);
      *
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Prototype Declaration
 VV01   Dcl-Pi WSINNOCALL End-Pi;

      *?Procedure Prototype Declaration : Called Program
        Dcl-Pr WSURCSUP01 Extpgm;
          PSupCde    Char(6);
          PSeason    Char(2);
          PStWk      Char(2);
          PEndWk     Char(2);
        End-Pr;
      *
      *
      *?Work Variable Declaration :
        Dcl-S PSupCde    Char(6)     Inz;
        Dcl-S PSeason    Char(2)     Inz;
        Dcl-S PStWk      Char(2)     Inz;
        Dcl-S PEndWk     Char(2)     Inz;
        Dcl-S WkInStDt   Date        Inz;
        Dcl-S WkStCal    Packed(7)   Inz;
        Dcl-S WkCount    Packed(2)   Inz;
        Dcl-S WkDelDat   Packed(8)   Inz;
        Dcl-S WkKBWk     Packed(2)   Inz;
        Dcl-S WkKBCn     Packed(2)   Inz;
        Dcl-S WkKBYr     Packed(2)   Inz;
        Dcl-S WkKBDtC    Char(6)     Inz;
        Dcl-S WkKBDt     Packed(6)   Inz;
        Dcl-S WkInWk     Packed(6)   Inz;
        Dcl-S WkInPeriod Char(6)     Inz;
      //--------------------------------------------------------------------

      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Get Innova Date and Week numbers from functions
           Exsr GetInnoDate;

      *?   // End Program
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // Return
           *InLr = *On;
           Return;

        EndSr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : GetInnoDate Subroutine :
      *?                :------------------------:
      *
        Begsr GetInnoDate;

      *?   // Get Innova Start Date from the function
           Exec sql SET :WkInStDt = InnovaStrt();
           WkStCal = %Int(%Char(WkInStDt:*cymd0));
           WkCount = 1;

      *?   // Read Calendar file for 52 weeks from the Innova Start Date
           Setll WkStCal FCALENWEEK;
           Read FCALENWEEK;
           Dow Not %Eof() and WkCount <= 52;

      *?      // Delete all old records in Inventory File for Innova Start Date
              WkDelDat = %Dec(%Char(%Date(CLCYMD:*cymd):*iso0):8:0);
              Exec Sql
                 Delete from WSSUPINVPF where SIVENNAM = 'INNOVAPLANT'
                        and SIAVLDAT = :WkDelDat;

VV02  *?      // Delete any old records that are less than Innova Start Date ONCE only
VV02          If WkCount = 1;
VV02             Exec Sql
VV02                Delete from WSSUPINVPF where SIVENNAM = 'INNOVAPLANT'
VV02                    and SIAVLDAT < :WkDelDat;
VV02          Endif;

              WkKBWk = CLWEEK;
              WkKBCn = CLCENT;
              WkKBYr = CLYEAR;
      *?      // Get Innova Season and Week from Kube-Pak Year and Week
              Exsr GetInnoWeek;
              WkCount += 1;
           Read FCALENWEEK;
           Enddo;
       EndSr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : GetInnoDate Subroutine :
      *?                :------------------------:
      *
       BegSr  GetInnoWeek;
      *?   // Pass KubePak Year and Week to get Innova Year and Week
           WkKBDtC = %EDITC(WkKBCn:'X') + %EDITC(WkKBYr:'X')
                                        + %EDITC(WkKBWk:'X');
           WkKBDt = %Int(WkKBDtC);
           Exec sql SET :WkInWk = InnovaWeek(:WkKBDt);

           WkInPeriod = %Char(WkInWk);
           PSeason    = %SubSt(WkInPeriod:3:2);
           PStWk      = %SubSt(WkInPeriod:5:2);
           PEndWk     = PStWk;
           PSupCde    = '1941';                                             //Vendor code for Innova

      *?   // Call InnovaPlant Inventory Program to get Inventory
           WSURCSUP01 (PSupCde:PSeason:PStWk:PEndWk);

       EndSr;
      //--------------------------------------------------------------------
