#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"
#Include "FWBROWSE.CH"

/*/{Protheus.doc} SYVM109
Controle de devolução.

@author André Lanzieri
@since 27/12/2016
@version 1.0
/*/
User Function SYVM109()

	Local aAreaAtu 		:= GetArea()
	Local oDlg
	Local cCadastro		:= "Controle de Devolução"
	Local aObjects		:= {}
	Local bDouble		:= { |oBrowse| V109MARK() }
	Local aParamBox 	:= {}
	Local aRet 			:= {}
	Local lRet			:= .T.

	Private cCarga 		:= Space(6)	

	aAdd(aParamBox,{ 1, "Selecione Carga", cCarga, "", "", "DAK2", ".T.", 0, .F. } ) 

	DbSelectArea("DAK")
	DbSetOrder(1)

	While lRet

		If ParamBox( aParamBox, "Filtros...", @aRet,,,,,,,,.F.)

			If DbSeek(xFilial("DAK")+aRet[1])

				If DAK->DAK_FEZNF == '1' .And. DAK->DAK_ACECAR == '1'.And.(DAK->DAK_BLQCAR == '2' .Or. DAK->DAK_BLQCAR == ' ') .And. (DAK->DAK_JUNTOU=='MANUAL' .Or. DAK->DAK_JUNTOU=='ASSOCI' .Or. DAK->DAK_JUNTOU=='JUNTOU')
					MsgInfo("Carga já faturada e retornada, não é possivel seleciona-la.")
				Else
					cCarga	:= aRet[1]
					lRet 	:= .F.
				EndIf

			Else

				MsgInfo("Carga não encontrada.")

			EndIf

		Else

			Return

		EndIf

	EndDo

	aSize := MsAdvSize()
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	Aadd( aObjects, { 000, 000, .T., .F. })
	Aadd( aObjects, { 100, 100, .T., .T. })
	Aadd( aObjects, { 100, 050, .T., .T. })
	aPosObj := MsObjSize(aInfo,aObjects)

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 TO aSize[6],aSize[5] Of oMainWnd PIXEL

	oPanel:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0, 0, .T., .F. )
	oPanel:Align:= CONTROL_ALIGN_ALLCLIENT

	//-----------------------------------------------------------------------------------+
	//							Apresenta Tela de Filtros								 |
	//-----------------------------------------------------------------------------------+

	DEFINE FWBROWSE oBrowse DATA TABLE ALIAS "SF1" OF oPanel

	//----------------------------------------------------------------------------------+
	//							Adiciona Coluna CheckBox								|
	//----------------------------------------------------------------------------------+

	oBrowse:DisableLocate()
	oBrowse:SetUseFilter()

	DbSelectArea("SA1")

	ADD MARKCOLUMN oColumn DATA { ||IIF(!EMPTY(SF1->F1_XCARGA) ,'LBOK','LBNO') } ;
	DOUBLECLICK bDouble OF oBrowse	

	//------------------------------------------------------------------------------------------------------------------------------------------+
	// 												Adiciona as colunas do Browse																|
	//------------------------------------------------------------------------------------------------------------------------------------------+
	ADD COLUMN oColumn DATA { || F1_DOC   																		} 	TITLE RetTitle("F1_DOC")  		SIZE  0 OF oBrowse
	ADD COLUMN oColumn DATA { || F1_SERIE  																		} 	TITLE RetTitle("F1_SERIE") 		SIZE  0 OF oBrowse
	ADD COLUMN oColumn DATA { || F1_FORNECE    																	} 	TITLE RetTitle("F1_FORNECE") 	SIZE  0 OF oBrowse
	ADD COLUMN oColumn DATA { || F1_LOJA   																		}	TITLE RetTitle("F1_LOJA") 		SIZE  0 OF oBrowse

	ADD COLUMN oColumn DATA { || F1_EMISSAO   																	}	TITLE RetTitle("F1_EMISSAO") 	SIZE  0 OF oBrowse

	ADD COLUMN oColumn DATA { || SA1->(DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)), SA1->A1_NREDUZ  	} 	TITLE "Nome Cliente" 			SIZE  0 OF oBrowse

	ADD COLUMN oColumn DATA { || IIF(Empty(SA1->A1_CEPE), SA1->A1_CEP, SA1->A1_CEPE)  	 						} 	TITLE "CEP" 					SIZE  10 PICTURE PesqPict("SA1","A1_CEP") OF oBrowse
	ADD COLUMN oColumn DATA { || IIF(Empty(SA1->A1_ENDENT), SA1->A1_END, SA1->A1_ENDENT)     					} 	TITLE "Endereço" 				SIZE  0 OF oBrowse

	ADD COLUMN oColumn DATA { || IIF(Empty(SA1->A1_BAIRROE), SA1->A1_BAIRRO, SA1->A1_BAIRROE)     				} 	TITLE "Bairro" 					SIZE  0 OF oBrowse
	ADD COLUMN oColumn DATA { || IIF(Empty(SA1->A1_ESTE), SA1->A1_EST, SA1->A1_ESTE)    						} 	TITLE "Estado" 					SIZE  0 OF oBrowse

	ADD COLUMN oColumn DATA { || F1_XCARGA   																	}	TITLE RetTitle("F1_XCARGA") 	SIZE  0 OF oBrowse

	oBrowse:Refresh()
	oBrowse:SetFilterDefault ( "F1_TIPO = 'D' .AND. ( F1_XCARGA == '"+Padr( "",TamSx3("F1_XCARGA")[1])+"' .OR. F1_XCARGA == '"+Padr( cCarga,TamSx3("F1_XCARGA")[1])+"' ) " )

	oBrowse:SetDoubleClick(bDouble)

	ACTIVATE FWBROWSE oBrowse

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , { || oDlg:End() } , { || oDlg:End() },			 ,/*aButtons*/    ,         ,          ,          ,         ,         , .F. ) CENTERED

	RestArea(aAreaAtu)

Return

Static Function V109MARK()

	RecLock('SF1',.F.) // .F. = Alteracao .T. - Inclusao

	If Empty(SF1->F1_XCARGA)
		SF1->F1_XCARGA := cCarga
	Else
		SF1->F1_XCARGA := ""
	EndIf

	SF1->(MsUnlock())

	//oBrowse:Refresh()

Return