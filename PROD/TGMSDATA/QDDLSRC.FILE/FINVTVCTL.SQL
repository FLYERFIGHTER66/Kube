-- Inventory View Control File

Create or replace Table Inventory_View_Control_File for system name FINVTVCTL
(   PLUG_CTL_TYPE   for column PCTYPE   char(10)    not null
,   PLUG_CTL_CODE   for column PCCODE   char(1)     not null
,   PLUG_CTL_DESC   for column PCDESC   char(65)    not null
)   RCDFMT RINVTVCTL;


Label on Table Inventory_View_Control_File
    is 'Inventory View Control File';

