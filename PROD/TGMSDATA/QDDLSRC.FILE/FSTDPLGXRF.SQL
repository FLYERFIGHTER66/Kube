Create or Replace VIEW Kube_Pak_Standard_Plug_Inventory_XREF as (
Select
View_Control_Type,
Ready_Date,
Ready_Date_7,
SowDate,
Item_Number,
Item_Size,
trim(Item_Number)||trim(Item_Size) as LocalKeyValue,
ehr.ForeignKeyValue as ForeignKeyValue_EHR,
mch.ForeignKeyValue as ForeignKeyValue_Michell,
mhn.ForeignKeyValue as ForeignKeyValue_McHutch,
gri.ForeignKeyValue as ForeignKeyValue_Griffin,
glo.ForeignKeyValue as ForeignKeyValue_Gloeckner,
Item_Description,
Item_Sort,
SZSALE,
Quantity_Available,
Quantity_Available * SZSALE as Cell_Quantity_Available,
Retrieved_Time

from Kube_pak_Standard_Plug_Inventory
    join fmsize on ITEM_SIZE = SZCODE
    join xrefinvt as EHR on trim(Item_Number)||trim(Item_Size) = EHR.LocalKeyValue and EHR.ProvidedByID = '3953' --EHR
    join xrefinvt as MCH on trim(Item_Number)||trim(Item_Size) = MCH.LocalKeyValue and MCH.ProvidedByID = '3975' --Michell
    join xrefinvt as MHN on trim(Item_Number)||trim(Item_Size) = MHN.LocalKeyValue and MHN.ProvidedByID = '1947' --McHutch
    join xrefinvt as GRI on trim(Item_Number)||trim(Item_Size) = GRI.LocalKeyValue and GRI.ProvidedByID = '2386' --Griffin
    join xrefinvt as GLO on trim(Item_Number)||trim(Item_Size) = GLO.LocalKeyValue and GLO.ProvidedByID =  '234' --Gloeckner

);
