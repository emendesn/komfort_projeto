#Include "PROTHEUS.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} KMTMKA01
มrea de decisใo para operadores das Lojas

@param N/A
@return N/A                                 
@author  Rafael Cruz - Komfort House
@since 27/03/2018

//#RVC20180426 - Corre็ใo na atribui็ใo do perfil de operador.

/*/                                                             
//--------------------------------------------------------------
User Function KMTMKA01()
Local oButton1
Local oButton2
Local oGroup1
Local oSay1
Local cOper1 := "VENDA"
Local cOper2 := "CHAMADO"
Static oDlg

MsUnlockAll()//#CMG20180625.n

	dbSelectArea("SU7")
	SU7->(dbGoTop())
	SU7->(dbSetOrder(4))
	SU7->(dbSeek(xFilial("SU7") + __cUserID))
	
If SU7->U7_XTIPO == "5" 
 
  DEFINE MSDIALOG oDlg TITLE "TMKA271 | Televendas/Telemarketing" FROM 000, 000  TO 140, 400 COLORS 0, 16777215 PIXEL

    @ 001, 001 GROUP oGroup1 TO 070, 202 PROMPT " Tipo de Opera็ใo " OF oDlg COLOR 0, 16777215 PIXEL
    @ 020, 010 SAY oSay1 PROMPT "Que opera็ใo deseja realizar?" SIZE 222, 075 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 043, 043 BUTTON oButton1 PROMPT "Incluir PV/Or็" SIZE 040, 013 OF oGroup1 PIXEL Action (xAbreRot(cOper1),oDlg:End())
    @ 043, 126 BUTTON oButton2 PROMPT "Abrir Chamado" SIZE 040, 014 OF oGroup1 PIXEL Action (xAbreRot(cOper2),oDlg:End())
    
  ACTIVATE MSDIALOG oDlg CENTERED
Else
	TMKA271()
EndIf

Return
	
Static Function xAbreRot(cOper)

	Local aAreaSU7	:= SU7->(GetArea())
	Local cTpBkp	:= ""
	Local _lValid   := .T.
	
	If cOper == "VENDA"
		
		_lValid := fPedConf()
		U_MSGBLQAG() //Mensagem com o periodo de agendamento bloqueado. 
	
	EndIf	
	
	DbSelectArea("SU7")
	SU7->(dbGoTop())
	SU7->(dbSetOrder(4))
	SU7->(dbSeek(xFilial("SU7") + __cUserID))
	
	If cOper == "VENDA"
//		If SU7->U7_TIPOATE == "1"	//#RVC20180426.o
		If SU7->U7_TIPOATE <> "2"	//#RVC20180426.n
			TkGetTipoAte("2")
			Reclock("SU7",.F.)
				SU7->U7_TIPOATE	:= "2" //Televendas
			Msunlock()				
		Endif
	Else
//		Ihf SU7->U7_TIPOATE == "2" //#RVC20180426.o
		TkGetTipoAte("1")
		Reclock("SU7",.F.)
			SU7->U7_TIPOATE	:= "1"	//Telemarketing
		Msunlock()				
//		Endif	//#RVC20180426.o	
	EndIf	
	
	RestArea(aAreaSU7)	//#RVC20180426.n
	
	If _lvalid
			
		TMKA271()
		
	EndIf	

Return

/*/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPedConf  บ Autor ณ Caio Garcia        บ Data ณ  12/06/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Verifica se o caixa foi fechado                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Komfort House                                              บฑฑ
ฑฑฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/

Static Function fPedConf()

Local _lRet      := .F.
Local _cAlias    := GetNextAlias()
Local _cQuery    := ''
Local _cDataAnt  := DtoS((DDataBase-1))

_cQuery := " SELECT * "
_cQuery += " FROM " + RETSQLNAME("SC5") + " SC5 "
_cQuery += " WHERE SC5.D_E_L_E_T_ <> '*' "
_cQuery += " AND C5_NUMTMK <> '' "
_cQuery += " AND C5_EMISSAO <= '"+_cDataAnt+"' "
_cQuery += " AND C5_XCONPED <> '1' "
_cQuery += " AND C5_MSFIL  = '"+cFilAnt+"' "
_cQuery += " AND C5_MSFIL <> '0101' "
_cQuery += " AND C5_NOTA <> 'XXXXXXXXX' "

_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),(_cAlias),.F.,.T.)

DbSelectArea(_cAlias)
(_cAlias)->(DbGoTop()) 

If (_cAlias)->(Eof()) //Correto, pois nใo pode ter registro em aberto

	_lRet := .T.

Else//Existem pedidos nใo conferidos

	MsgStop("Existem pedidos da data "+DtoC(StoD((_cAlias)->C5_EMISSAO))+" que nใo foram conferidos, confira os pedidos e fa็a o fechamento do caixa!", "PEDNAOCONF" )

EndIf

(_cAlias)->(DbCloseArea())                    

Return _lRet