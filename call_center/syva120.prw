#Include "FWMVCDEF.CH"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYVA120  บAutor  ณMicrosiga           บ Data ณ  01/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Competencias                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SYVA120()

Local oBrowse	:= Nil

Private aRotina	:= MenuDef()

oBrowse:= FWMBrowse():New()
oBrowse:SetAlias("SZ6")
oBrowse:SetDescription("Cadastro de Competencia")
oBrowse:Activate()

Return

Static Function ModelDef()

Local oModel	:= Nil

// Estrutura de campos do cabecalho
Local oStruCSZ6 := FwFormStruct( 1, "SZ6")

oModel:= MpFormMOdel():New( "COMPMVC" ,  /*bPreValid*/ , /*bPosValid*/ , /*bComValid*/ ,/*bCancel*/ )
oModel:SetDescription("Cadastro de Competencia") 
oModel:AddFields("MdFieldCSZ6",Nil,oStruCSZ6,/*prevalid*/,,/*bCarga*/)
oModel:SetPrimaryKey({ "Z6_FILIAL" , "Z6_COD" })


Return( oModel )


Static Function ViewDef()

Local oModel 	:= FwLoadModel( "SYVA120" )
Local oView 	:= Nil
Local oStruCSZ6 := FwFormStruct( 2, "SZ6")

oView := FwFormView():New()
oView:SetModel(oModel)

oView:AddField('VwFieldSZ6', oStruCSZ6 , 'MdFieldCSZ6') 

oView:CreateHorizontalBox("TELA",100)
oView:SetOwnerView('VwFieldSZ6',"TELA")

Return(oView)


Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE "Pesquisar" 	ACTION "PesqBrw"       		OPERATION 1 ACCESS 0   //"Pesquisar"
ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.SYVA120"	OPERATION 2 ACCESS 0   //"Visualizar"
ADD OPTION aRotina TITLE "Incluir" 		ACTION "VIEWDEF.SYVA120" 	OPERATION 3 ACCESS 0   //"Incluir"
ADD OPTION aRotina TITLE "Alterar" 		ACTION "VIEWDEF.SYVA120" 	OPERATION 4 ACCESS 0   //"Alterar"
ADD OPTION aRotina TITLE "Excluir" 		ACTION "VIEWDEF.SYVA120" 	OPERATION 5 ACCESS 0   //"Excluir"

Return ( aRotina )