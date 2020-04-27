#include 'Protheus.ch'
#include 'FWMVCDEF.CH'

Static _xGetSQL,_xGetSX1
Static _cGetSQL,_cGetSX1
Static CCRLF := Chr(13) + Chr(10)


/*/{Protheus.doc}KMFRA03
	Rotina de cadastro de expressões SQL

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
User Function KMFRA03()
	
	Local oBrowse 
	Private aRotina := MenuDef()
	
	oBrowse := FWMBrowse():NEW()
	oBrowse:SetAlias( "Z03" )
	oBrowse:SetDescription( OemToAnsi("Cadastro de Expresões SQL") )
	oBrowse:SetExecuteDef( 1 )
	oBrowse:SetUseFilter( .T. )
	oBrowse:OptionReport( .F. )
	oBrowse:SetWalkThru( .F. )
	oBrowse:SetAmbiente( .F. )
	oBrowse:SetUseCaseFilter( .T. )
	oBrowse:SetMenuDef( 'KMFRA03' )
	oBrowse:SetFilterDefault( u_KMFRX01( "QAA" , POSICIONE( "QAA" , 6 , Upper(cUserName) , "QAA_MAT" ) , "Z03" , .T. ) )
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

	ADD OPTION aRotina TITLE 'Executar'   	ACTION 'U_KMFRA03I'     OPERATION 1 ACCESS 0

Return aRotina



/*/{Protheus.doc}KMFRA03I
	Executa expressão SQL

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
User Function KMFRA03I()

	Local aArea := GetArea()
	Local cCrlf := Chr(13) + Chr(10)
	Local aADVPL := StrToArray(Z03->Z03_PUTSX1,cCrlf)
	Local nx, nxt := len(aADVPL)

	if !Z03->(eof())

		for nx := 1 to nxt
			&(aADVPL[nx])
		next

		if !Empty(Z03->Z03_SX1)

			pergunte(Z03->Z03_SX1,.f.)

			if pergunte(Z03->Z03_SX1,.t.)
				u_KMQGX01A( Z03->Z03_SQL , Z03->Z03_DESC , nil , nil , nil )
			endif

		else

			u_KMQGX01A( Z03->Z03_SQL , Z03->Z03_DESC , nil , nil , nil )

		endif

	endif

	RestArea(aArea)

return