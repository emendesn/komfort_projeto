#include 'Protheus.ch'
#include 'FWMVCDEF.CH'

Static _xGetSQL,_xGetSX1
Static _cGetSQL,_cGetSX1
Static CCRLF := Chr(13) + Chr(10)


/*/{Protheus.doc}KMFRA02
	Rotina de cadastro de expressões SQL

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
User Function KMFRA02()
	Local cTitulo := ""
	Private oBrowse := FWMBrowse():NEW()
	Private aRotina := MenuDef()

	oBrowse:SetAlias( "Z03" )
	oBrowse:SetDescription( OemToAnsi("Cadastro de Expresões SQL") )
	oBrowse:SetExecuteDef( 1 )
	oBrowse:SetUseFilter( .T. )
	oBrowse:OptionReport( .F. )
	oBrowse:SetWalkThru( .F. )
	oBrowse:SetAmbiente( .F. )
	oBrowse:SetUseCaseFilter( .T. )
	oBrowse:SetMenuDef( 'KMFRA02' )
	oBrowse:Activate()

return

/*/{Protheus.doc}MenuDef
	Menu de opções da rotina

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar' 	   ACTION 'VIEWDEF.KMFRA02' OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'	   ACTION 'VIEWDEF.KMFRA02' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    	   ACTION 'VIEWDEF.KMFRA02' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'   	   ACTION 'VIEWDEF.KMFRA02' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'   	   ACTION 'VIEWDEF.KMFRA02' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Executar'   	   ACTION 'U_KMFRA02I'      OPERATION 1 ACCESS 0

Return aRotina

/*/{Protheus.doc}ModelDef
	Modelo de Dados

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
Static Function ModelDef()

	Local oStruZ03 := FWFormStruct( 1, "Z03" )
	Local oModel
	Local cId
	Local nx := 1

	oModel := MPFormModel():New( 'KMFRA02_MVC' )

	oModel:AddFields( 'Z03MASTER', , oStruZ03 )

	oModel:SetPrimaryKey( { 'Z03_COD' } )

	oModel:GetModel( 'Z03MASTER' ):SetDescription( "Parâmetros" )

Return oModel

/*/{Protheus.doc}ViewDef
	View do modelo de dados

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
Static Function ViewDef()

	Local oStruZ03 := FWFormStruct( 2, "Z03" )
	Local oModel := FwLoadModel( "KMFRA02" )
	Local aSX3
	Local oView

	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_Z03', oStruZ03, 'Z03MASTER' )

	oView:CreateHorizontalBox( 'SUPERIOR', 20 )
	oView:CreateHorizontalBox( 'MEIO', 20 )
	oView:CreateHorizontalBox( 'INFERIOR', 60 )

	oView:AddOtherObject("CRIASX1", {|oPanel| u_KMFRA02E(oPanel)})
	oView:SetOwnerView("CRIASX1","MEIO")

	oView:AddOtherObject("EXPSQL", {|oPanel| u_KMFRA02D(oPanel)})
	oView:SetOwnerView("EXPSQL","INFERIOR")

	oView:SetOwnerView( 'VIEW_Z03', 'SUPERIOR' )

	oView:EnableTitleView ('Z03MASTER')
	oView:EnableTitleView("CRIASX1",'Cria Pergunta SX1')
	oView:EnableTitleView("EXPSQL",'Expressão SQL')

	oView:EnableControlBar(.T.)

	oView:SetCloseOnOk({|| u_KMFRA02G()})

	oView:SetAfterOkButton({||U_KMFRA02F()})

Return oView

/*/{Protheus.doc}KMFRA02E
	Cria campo MEMO SQL

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
User Function KMFRA02D(oPanel)

	Local oView := FWViewActive()

	if ValType(oView) <> 'U'

		_cGetSQL := iif(oView:GetBrowseOpc()<>3,Z03->Z03_SQL,"")

		_xGetSQL := tMultiget():New(13,,{|u| if(PCount()>0,_cGetSQL:=u,_cGetSQL)},oPanel,,,,,,,,.T.,,.T.,,,,,,,,.F.,.T.,)
		_xGetSQL:nBottom := oPanel:nBottom   - _xGetSQL:nTop
		_xGetSQL:nClientHeight := oPanel:nClientHeight   - _xGetSQL:nTop
		_xGetSQL:nClientWidth := oPanel:nClientWidth
		_xGetSQL:nHeight := oPanel:nHeight - _xGetSQL:nTop
		_xGetSQL:nWidth := oPanel:nWidth
		_xGetSQL:nRight := oPanel:nRight

	else

		_cGetSQL := ""

		_xGetSQL := tMultiget():New(13,,{|u| if(PCount()>0,_cGetSQL:=u,_cGetSQL)},oPanel,,,,,,,,.T.,,.T.,,,,,,,,.F.,.T.,)
		_xGetSQL:nBottom := oPanel:nBottom   - _xGetSQL:nTop
		_xGetSQL:nClientHeight := oPanel:nClientHeight   - _xGetSQL:nTop
		_xGetSQL:nClientWidth := oPanel:nClientWidth
		_xGetSQL:nHeight := oPanel:nHeight - _xGetSQL:nTop
		_xGetSQL:nWidth := oPanel:nWidth
		_xGetSQL:nRight := oPanel:nRight

	endif

return

/*/{Protheus.doc}KMFRA02E
	Cria campo MEMO SX1

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
User Function KMFRA02E(oPanel)

	Local oView := FWViewActive()


	if ValType(oView) <> 'U'

		_cGetSX1 := iif(oView:GetBrowseOpc()<>3,Z03->Z03_PUTSX1,"")

		_xGetSX1 := tMultiget():New(13,,{|u| if(PCount()>0,_cGetSX1:=u,_cGetSX1)},oPanel,,,,,,,,.T.,,.T.,,,,,,,,.F.,.T.,)
		_xGetSX1:nBottom := oPanel:nBottom   - _xGetSX1:nTop
		_xGetSX1:nClientHeight := oPanel:nClientHeight   - _xGetSX1:nTop
		_xGetSX1:nClientWidth := oPanel:nClientWidth
		_xGetSX1:nHeight := oPanel:nHeight - _xGetSX1:nTop
		_xGetSX1:nWidth := oPanel:nWidth
		_xGetSX1:nRight := oPanel:nRight

	else

		_cGetSX1 := ""

		_xGetSX1 := tMultiget():New(13,,{|u| if(PCount()>0,_cGetSX1:=u,_cGetSX1)},oPanel,,,,,,,,.T.,,.T.,,,,,,,,.F.,.T.,)
		_xGetSX1:nBottom := oPanel:nBottom   - _xGetSX1:nTop
		_xGetSX1:nClientHeight := oPanel:nClientHeight   - _xGetSX1:nTop
		_xGetSX1:nClientWidth := oPanel:nClientWidth
		_xGetSX1:nHeight := oPanel:nHeight - _xGetSX1:nTop
		_xGetSX1:nWidth := oPanel:nWidth
		_xGetSX1:nRight := oPanel:nRight

	endif

return


/*/{Protheus.doc}KMFRA02F
	Grava campos do tipo MEMO

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
User Function KMFRA02F(oPanel)

	Local aArea := GetArea()
	Local oView := FWViewActive()

	RecLock("Z03",.F.)
	Z03->Z03_PUTSX1 := _cGetSX1
	Z03->Z03_SQL := _cGetSQL
	Z03->(MsUnlock())

	RestArea(aArea)

return


/*/{Protheus.doc}KMFRA02G
	Marca VIEW como modificada

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
User Function KMFRA02G(oView)

	Local aArea := GetArea()
	Local oModel := FWModelActive()
	Local oModelZ03 := oModel:GetModel( 'Z03MASTER' )

	DEFAULT oView := FWViewActive()

	if !INCLUI
		oView:oModel:lModify := .t.
		oView:lModify := .t.
	endif

	RestArea(aArea)

return .t.



/*/{Protheus.doc}KMFRA02I
	Executa expressão SQL

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
User Function KMFRA02I()

	Local aArea := GetArea()
	Local cCrlf := Chr(13) + Chr(10)
	Local aADVPL := StrToArray(Z03->Z03_PUTSX1,cCrlf)
	Local nx, nxt := len(aADVPL)
	Local cError  := ""
	local oLastError := ErrorBlock({|e| cError := e:Description + e:ErrorStack})

	for nx := 1 to nxt
		&(aADVPL[nx])
	next

	ErrorBlock(oLastError)

	if !empty(cError)
		alert(cError)
		RestArea(aArea)
		return
	endif

	if !Empty(Z03->Z03_SX1)

		pergunte(Z03->Z03_SX1,.f.)

		if pergunte(Z03->Z03_SX1,.t.)
			u_KMQGX01A( Z03->Z03_SQL , Z03->Z03_DESC , nil , nil , nil )
		endif
	else

		u_KMQGX01A( Z03->Z03_SQL , Z03->Z03_DESC , nil , nil , nil )

	endif

	RestArea(aArea)

return