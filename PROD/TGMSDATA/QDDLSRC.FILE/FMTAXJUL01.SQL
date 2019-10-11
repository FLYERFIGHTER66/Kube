create or replace view Tax_File_with_Jurisdictions
for system name FMTAXJUL01 as

Select
        Case when left(TXJUNM,10) = 'New York (' then 'NY'|| substr(TXJUNM,11,4)
        else TXTXJU
        end as Jurisdiction
,       TXTXJU
,       TXJUNM
,       TXPCT1
,       TXPCT2
,       TXPCT3
,       TXDTLA
,       TXTIME
,       TXUSER
,       TXGLA1
,       TXGLA2
,       TXGLA3
,       TXLIM1
,       TXLIM2
,       TXLIM3
,       TXCOMN


from FMTAXF
where TXSTAT = 'A';

select txstat from fmtaxf
