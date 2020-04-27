#include 'Protheus.ch'
#include 'FWMVCDEF.CH'

//Cabec
Static _cAlEnt,_cNmEnt,_cPK

//Grid
Static _cAlias,_cNmTable

//Controle do ListBox
Static _cName,_aCampos,_aList,_nChave,_oLbx,_oPanel,_oField,_xGet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMFRA01   บAutor  ณPaulo Seno          บ Data ณ  13/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de cadastro amarracao de usuario x produto            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LuksColor                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function KMFRA01(cAlEnt,cPK,cAlias) //QAA, QAA_MAT, Z03

	Local aArea		:= GetArea()
	Local oBrowse
	Local cFunBkp	:= FunName()
	Local cTitulo	:= ""
	
	Private aRotina := MenuDef()
	
	SetFunName('KMFRA01')

	_cAlias	:= cAlias
	_cAlEnt	:= cAlEnt
	_cPK	:= cPK
	
	dbSelectArea('SX2')
	dbSetOrder(1)
	dbSeek(_cAlEnt)
	_cNmEnt := X2Nome()

	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek(_cAlias)
	_cNmTable := X2Nome()
	
	cTitulo := ALLTRIM(CAPITALACE(_cNmEnt)) + " X " + ALLTRIM(CAPITALACE(_cNmTable))
	
		//LISTBOX
	_aList		:= {}
	_aCampos	:= {}
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(_cAlias)
	
	While alltrim(SX3->X3_ARQUIVO) == _cAlias
		If SX3->X3_CONTEXT <> 'V' .and. SX3->X3_TIPO <> 'M'
			&(SX3->X3_CAMPO) := CriaVar(SX3->X3_CAMPO,.f.)
			AADD(_aList,alltrim(SX3->X3_TITULO))
			AADD(_aCampos,SX3->X3_CAMPO)
		EndIf
		SX3->(dbSkip())
	EndDo
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(_cAlEnt)
	oBrowse:SetDescription(cTitulo)
	oBrowse:SetExecuteDef( 1 )
	oBrowse:SetUseFilter( .T. )
	oBrowse:OptionReport( .F. )
	oBrowse:SetWalkThru( .F. )
	oBrowse:SetAmbiente( .F. )
	oBrowse:SetUseCaseFilter( .T. )
	oBrowse:SetMenuDef( 'KMFRA01' )
	oBrowse:Activate()
	
	SetFunName(cFunBkp)
	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMFRA01   บAutor  ณPaulo Seno          บ Data ณ  13/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Opcoes da rotina                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LuksColor                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*Static Function MenuDef()
Local aRotina := {}
ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'VIEWDEF.KMFRA01' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Atualizar'  	ACTION 'VIEWDEF.KMFRA01' OPERATION 4 ACCESS 0
Return aRotina*/

Static Function MenuDef()
 
Return FWMVCMenu('KMFRA01') 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMFRA01   บAutor  ณPaulo Seno          บ Data ณ  13/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Modelo de dados da estrutura MVC                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LuksColor                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ModelDef()

Local oStruGRD := FWFormStruct( 1, _cAlEnt )
Local oStruZ04 := FWFormStruct( 1, 'Z04' )
Local oModel
Local cId
Local nx := 1

oStruGRD:SetProperty("*",MODEL_FIELD_VALID,{|| .T.})
oStruGRD:SetProperty("*",MODEL_FIELD_OBRIGAT,.F.)
oStruZ04:SetProperty("*",MODEL_FIELD_VALID,{|| .T.})
oStruZ04:SetProperty("*",MODEL_FIELD_OBRIGAT,.F.)

oModel := MPFormModel():New( 'KMFRA01_MVC' )

oModel:AddFields( 'GRDMASTER', , oStruGRD )
oModel:AddGrid( 'Z04DETAIL', 'GRDMASTER', oStruZ04 )

oModel:SetRelation( 'Z04DETAIL', { ;
								 { 'Z04_FILIAL', 'xFilial( "Z04" )' },;
								 { 'Z04_ENTFIL', 'xFilial( "'+_cAlEnt+'" )' },;
								 { 'Z04_FILGRD', 'xFilial( "'+_cAlias+'" )' },;
								 { 'Z04_CHVPK' , '"'+_cPK+'"' },;
								 { 'Z04_ALIAS' , '"'+_cAlias+'"' },;
								 { 'Z04_ENTALI', '"'+_cAlEnt+'"' },;
								 { 'Z04_ENTPK' , _cPk } }, Z04->( IndexKey( 0 ) ) )

oModel:SetPrimaryKey( { 'Z04_ENTFIL','Z04_ENTALI','Z04_ENTPK', "Z04_ALIAS", "Z04_FIELD", "Z04_CONTEU" } )

oModel:GetModel( 'GRDMASTER' ):SetDescription( _cNmEnt )
oModel:GetModel( 'GRDMASTER' ):SetOnlyView( .T. )

oModel:GetModel( 'Z04DETAIL' ):SetDescription( _cNmTable )
oModel:GetModel( 'Z04DETAIL' ):SetNoInsertLine( .T. )
oModel:GetModel( 'Z04DETAIL' ):SetNoUpdateLine ( .T. )

oModel:GetModel( 'Z04DETAIL' ):SetUniqueLine( { "Z04_FIELD", "Z04_CONTEU" } )
oModel:GetModel( 'Z04DETAIL' ):SetOptional( .T. )

Return oModel

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMFRA01   บAutor  ณPaulo Seno          บ Data ณ  13/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Regras de negocio da estrutura MVC                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LuksColor                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ViewDef()

Local oStruGRD := FWFormStruct( 2, _cAlEnt )
Local oStruZ04 := FWFormStruct( 2, 'Z04')
Local oModel := FwLoadModel( "KMFRA01" )
Local aSX3
Local oView

oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_GRD', oStruGRD, 'GRDMASTER' )
oView:AddGrid( 'VIEW_Z04', oStruZ04, 'Z04DETAIL' )

//oView:addIncrementField('VIEW_Z04',"Z04_SEQ")

oView:CreateHorizontalBox( 'SUPERIOR', 40 )
oView:CreateHorizontalBox( 'INFERIOR', 60 )

oView:CreateVerticallBox( "INFERIOR_ESQ" , 20 , 'INFERIOR')
oView:CreateVerticallBox( "INFERIOR_DIR" , 80 , 'INFERIOR')

//ADD LISTBOX
oView:AddOtherObject("LIST_BOX", {|oPanel| u_KMFRA01LB(oPanel)})
oView:SetOwnerView("LIST_BOX","INFERIOR_ESQ")

oView:SetOwnerView( 'VIEW_GRD', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_Z04', "INFERIOR_DIR" )

//TITULO -> PAINEL OTHERS_OBJECTS
oView:EnableTitleView("LIST_BOX",'Filtro')

// Habilita os tํtulos
oView:EnableTitleView ('GRDMASTER')

//oView:EnableTitleView ("FLDCENTER")
oView:EnableTitleView ('Z04DETAIL')

// habilita a barra de controle
oView:EnableControlBar(.T.)

//verificar se a janela deve ou nใo ser fechada ap๓s a execu็ใo do botใo OK
oView:SetCloseOnOk({|| .T.})

Return oView


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMFRA01LB บAutor  ณPaulo Seno          บ Data ณ  13/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ListBox                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LuksColor                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function KMFRA01LB(oPanel)
Local oSay,oTButADD,oTButDEL
_oPanel := oPanel

oTButADD := TButton():New( 40, 0, "Adicionar",oPanel,{||U_KMFRA01C()},40,14,,,.F.,.T.,.F.,,.F.,,,.F. )
oTButADD:nClientWidth := oPanel:nClientWidth
oTButADD:nWidth := oPanel:nWidth
//oTButADD:nClientWidth := oPanel:nClientWidth/2
//oTButADD:nWidth := oPanel:nWidth/2

//oTButDEL := TButton():New( 40, 0, "Remover",oPanel,{||u_KMFRA01D()},40,14,,,.F.,.T.,.F.,,.F.,,,.F. )
//oTButDEL:nClientWidth := oPanel:nClientWidth/2
//oTButDEL:nWidth := oPanel:nWidth/2
//oTButDEL:nLeft := oPanel:nWidth/2

oSay := TSay():New(57,00,{||'Campos'},oPanel,,,,,,.T.,,,200,10)
oSay:nClientWidth := oPanel:nClientWidth
oSay:nWidth := oPanel:nWidth

_oLbx := tListBox():New(65,0,{|u| if(Pcount()>0, _nChave := u , _nChave)},_aList,,,,oPanel,,,,.T.)
_oLbx:bChange := {|| U_KMFRA01SL() }
_oLbx:Select(1)

_oLbx:nBottom := oPanel:nBottom  - _oLbx:nTop
_oLbx:nClientHeight := oPanel:nClientHeight - _oLbx:nTop
_oLbx:nClientWidth := oPanel:nClientWidth
_oLbx:nHeight := oPanel:nHeight - _oLbx:nTop
_oLbx:nWidth := oPanel:nWidth
_oLbx:nRight := oPanel:nRight

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMFRA01SL บAutor  ณPaulo Seno          บ Data ณ  13/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Field Get -> Conteudo                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LuksColor                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function KMFRA01SL(_nChave)
Local cValid := ""

dbSelectArea("SX3")
dbSetOrder(2)
if dbSeek(_aCampos[_oLbx:nAt])

	if ValType(_oField) <> 'U'
		_oField:hide()
	endif

	&(SX3->X3_CAMPO) := CriaVar(SX3->X3_CAMPO,.f.)

	if Empty(SX3->X3_CBOX)

		cValid := SX3->(U_DV05C01C())

		_oField := TGet():New( ;
		15,;
		0,;
		&("{|u| iif(PCount()>0," +SX3->X3_CAMPO+" := u, "+SX3->X3_CAMPO+" )}"),;
		_oPanel,;
		096,;
		009,;
		SX3->(iif(!Empty(X3_PICTURE),X3_PICTURE,nil)),;
		iif( AllTrim(SX3->X3_CAMPO) $ _cPk .OR. "EXISTCHAV" $ UPPER(cValid) , nil, &("{|| VAZIO() .or. ("+cValid+")  }")),;
		0,;
		,;
		,;
		.F.,;
		,;
		.T.,;
		,;
		.F.,;
		,;
		.F.,;
		.F.,;
		,;
		.F.,;
		.F.,;
		SX3->(iif(!Empty(X3_F3),X3_F3,nil)),;
		SX3->X3_CAMPO,;
		,;
		,;
		,;
		,;
		,;
		,;
		"Conteudo",;
		1)
	else

		cValid := SX3->(U_DV05C01C())

		_oField := tComboBox():New(;
		15,;
		0,;
		&("{|u| iif(PCount()>0," +SX3->X3_CAMPO+" := u, "+SX3->X3_CAMPO+" )}"),;
		StrToArray(SX3->X3_CBOX,";"),;
		096,;
		009,;
		_oPanel,;
		,;
		,;
		iif( AllTrim(SX3->X3_CAMPO) $ _cPk .OR. "EXISTCHAV" $ UPPER(cValid), nil, &("{|| VAZIO() .OR. ("+cValid+") }")),;
		,;
		,;
		.T.,;
		,;
		,;
		,;
		,;
		,;
		,;
		,;
		,;
		SX3->X3_CAMPO,;
		"Conteudo",;
		1)
	endif


	if 	(SX3->X3_TIPO == 'C' .AND. !Empty(SX3->X3_F3)) .OR. SX3->X3_TIPO == 'D'
		_oField:nClientWidth := _oPanel:nClientWidth-15
		_oField:nWidth := _oPanel:nWidth-15
	else
		_oField:nClientWidth := _oPanel:nClientWidth
		_oField:nWidth := _oPanel:nWidth
	endif

	//_oField:CtrlRefresh()

endif

return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMFRA01c  บAutor  ณPaulo Seno          บ Data ณ  13/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Acao do botao adicionar                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LuksColor                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function KMFRA01C()
local oView := FWViewActive()
Local oModel := FWModelActive()
Local oModelZ04 := oModel:GetModel( 'Z04DETAIL' )
Local nTotal := oModelZ04:Length()
Local nx
Local cGet

dbSelectArea("Z04")
dbSelectArea("SX3")
dbSetOrder(2)

if dbSeek(_aCampos[_oLbx:nAt])

	if SX3->X3_TIPO == "C"
		cGet := &(_aCampos[_oLbx:nAt])
	elseif SX3->X3_TIPO == "N"
		cGet := cValToChar(&(_aCampos[_oLbx:nAt]))
	else
		cGet := DTOS(&(_aCampos[_oLbx:nAt]))
	endif

	oModel:GetModel( 'Z04DETAIL' ):SetNoInsertLine( .F. )
	oModel:GetModel( 'Z04DETAIL' ):SetNoUpdateLine( .F. )

	if Empty(oModelZ04:GetValue("Z04_FIELD",nTotal))
		oModelZ04:GoLine(nTotal)
		oModelZ04:SetValue("Z04_FIELD", _aCampos[_oLbx:nAt])
		oModelZ04:SetValue("Z04_CONTEU", cGet)
		oModelZ04:GoLine(1)
	else
		if(nx:=oModelZ04:AddLine()) > nTotal
			oModelZ04:GoLine(nx)
			oModelZ04:SetValue("Z04_FIELD", _aCampos[_oLbx:nAt])
			oModelZ04:SetValue("Z04_CONTEU", cGet)
			oModelZ04:GoLine(1)
		else
			MsgInfo("Nใo foi possํvel inserir o filtro. Verifique linhas duplicadas.")
		endif
	endif
	oModel:GetModel( 'Z04DETAIL' ):SetNoInsertLine( .T. )
	oModel:GetModel( 'Z04DETAIL' ):SetNoUpdateLine ( .T. )

endif

oView:Refresh()

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMFRA01c  บAutor  ณPaulo Seno          บ Data ณ  13/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Acao do botao remover                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LuksColor                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function KMFRA01D()
local oView := FWViewActive()
Local oModel := FWModelActive()
Local oModelZ04 := oModel:GetModel( 'Z04DETAIL' )

if oModelZ04:Length() > 0

	oModelZ04:DeleteLine()
	oView:Refresh()

endif

return

User Function DV05C01C()
	Local aArea := GetArea()
	Local cFiltro := ""

	if !Empty(X3_VLDUSER)
		cFiltro += alltrim(X3_VLDUSER)
	endif

	if !Empty(X3_VALID)

		if !Empty(cFiltro)
			cFiltro := "("+cFiltro+") .and. "
		endif

		cFiltro += "("+alltrim(X3_VALID)+")"
	endif

	if Empty(cFiltro)
		cFiltro := ".T."
	endif

	RestArea(aArea)
return cFiltro


