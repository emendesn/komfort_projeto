#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

#DEFINE DESCONTO 	2

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYVM106  บ Autor ณ SYMM CONSULTORIA   บ Data ณ  08/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida o % Desconto conforma a regra do CPC                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function SYVM106(nPerDesc,cCampo)

Local aArea    		:= GetArea()
Local aAreaSB1		:= SB1->(GetArea())
Local aAreaSB4		:= SB4->(GetArea())
Local aAreaSA3		:= SA3->(GetArea())
Local cAlias   		:= GetNextAlias()
Local nPCodTab 		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01TABPA"})
Local nPCodPro 		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
Local nPDesc 		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DESC"})
Local nPValDesc		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VALDESC"})
Local nPPrcVen		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VRUNIT"})
Local nPPrcTab		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRCTAB"})
Local nPVlrItem		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VLRITEM"})
Local nPQuant		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_QUANT"})

Local cCondPg  		:= M->UA_CONDPG
Local cCodVend		:= M->UA_VEND
Local cCodGere		:= ""
Local cCodSuper		:= ""
Local cTipoCPC 		:= ""
Local cQuery   		:= ""
Local cCodRegra		:= ""
Local nLinha   		:= n
Local nPerVen  		:= 0
Local nPerGer  		:= 0
Local nPerSup  		:= 0
Local nVlMaxDesc	:= 0
Local nVlrTot		:= 0
Local nX			:= 0
Local lRet 	   		:= .T.
Local lOk			:= .T.
Local lVendedor		:= .F.
Local lGerente 		:= .F.
Local lSupervisor	:= .F.
Local lDescItem		:= .F.
Local lCpcPromo		:= .F.
Local lRT			:= !Empty(M->UA_VEND1)
Local lValid		:= aCols[nLinha,nPPrcVen] > aCols[nLinha,nPPrcTab]
Local nVlrItem		:= aCols[nLinha,nPQuant]  * aCols[nLinha,nPPrcTab]
Local nDescTotal	:= aValores[DESCONTO]

Private cTabPad 	:= GetMv("MV_TABPAD")	//Tabela de Preco Padrao
Private cTabMost	:= GetMv("MV_SYTABMO")	//Tabela de Preco de Mostruario
Private cTabProm	:= GetMv("MV_SYTABPR")	//Tabela de Preco Promocional

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1") + aCols[nLinha,nPCodPro] ))

SB4->(DbSetOrder(1))
SB4->(DbSeek(xFilial("SB4") + SB1->B1_01PRODP ))
lCpcPromo := SB4->B4_01CPC=='3'

SA3->(DbSetOrder(1))
If SA3->(DbSeek(xFilial("SA3") + cCodVend 	))
	cCodGere  := SA3->A3_GEREN
	cCodSuper := SA3->A3_SUPER
Else
	MsgStop("Vendedor nใo cadastrado.","Aten็ใo")
	lRet := .F.
Endif

For nX := 1 To Len(aCols)
	If aCols[nX][nPValDesc] > 0
		lDescItem := .T.
		Exit
	Endif
Next

If lDescItem .And. (nDescTotal > 0)
	MsgStop("Desconto nใo permitido, jแ existe desconto no total deste pedido.","Aten็ใo")
	lRet := .F.
Endif

If nPerDesc > 0
	
	If Empty(cCondPg)
		MsgStop("Nใo foi preenchida a condi็ใo de pagamento.","Aten็ใo")
		lRet := .F.
	Endif
	
	If Empty(aCols[nLinha,nPCodTab]) .And. lRet
		MsgStop("Nใo foi preenchida a tabela de pre็o no item do produto.","Aten็ใo")
		lRet := .F.
	Endif
	
	If lRet
		
		If !lCpcPromo
			
			cQuery := " SELECT Z2_CODREG FROM "+RetSqlName("SZ2")+" SZ2 WHERE Z2_FILIAL = '"+xFilial("SZ2")+"' AND Z2_CODTAB = '"+aCols[nLinha,nPCodTab]+"' AND SZ2.D_E_L_E_T_ = ' ' "
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
			
			(cAlias)->(DbGotop())
			If (cAlias)->(!Eof())
				cCodRegra := (cAlias)->Z2_CODREG
			Endif
			(cAlias)->( dbCloseArea() )
			
			If !Empty(cCodRegra)
				
				SZ1->(DbSetOrder(4))
				If SZ1->(DbSeek(xFilial("SZ1") + cCodRegra + cCondPg  ))
					nPerVen  := SZ1->Z1_PERVEND
					nPerGer  := SZ1->Z1_PERGERE
					nPerSup  := SZ1->Z1_PERSUP
				Else
					MsgStop("Regra de Desconto nใo cadastrada.","Aten็ใo")
					lRet := .F.
				Endif
				
			Endif
			
		Else
			
			If lCpcPromo
				
				SZ1->(DbSetOrder(4))
				If SZ1->(DbSeek(xFilial("SZ1") + "001" + cCondPg  ))
					nPerVen  := SZ1->Z1_PERVEND
					nPerGer  := SZ1->Z1_PERGERE
					nPerSup  := SZ1->Z1_PERSUP
				Else
					MsgStop("Regra de Desconto nใo cadastrada.","Aten็ใo")
					lRet := .F.
				Endif
				
			Else
				
				/*
				If (cTabPad == aCols[nLinha,nPCodTab]) .And. !lRT 			//CPC NORMAL
				
				cTipoCPC := "1"
				
				ElseIf (cTabPad == aCols[nLinha,nPCodTab]) .And. lRT 		//CPC PROFISSIONAL
				
				cTipoCPC := "2"
				
				ElseIf (cTabMost == aCols[nLinha,nPCodTab]) .And. !lRT 	//CPC NORMAL
				
				cTipoCPC := "1"
				
				ElseIf (cTabProm == aCols[nLinha,nPCodTab]) .And. !lRT 	//CPC PROMOCIONAL
				
				cTipoCPC := "3"
				
				EndIf
				cQuery := " SELECT Z1_PERVEND,Z1_PERGERE,Z1_PERSUP FROM "+RetSqlName("SZ1")+" SZ1 WHERE SZ1.Z1_FILIAL = '"+xFilial("SZ1")+"' AND SZ1.Z1_TIPOCPC = '"+cTipoCPC+"' AND SZ1.Z1_CONDPG = '"+cCondPg+"' AND SZ1.D_E_L_E_T_ = ' ' ORDER BY Z1_COD
				cQuery := ChangeQuery(cQuery)
				DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
				
				(cAlias)->(DbGotop())
				If (cAlias)->(!Eof())
				nPerVen  := (cAlias)->Z1_PERVEND
				nPerGer  := (cAlias)->Z1_PERGERE
				nPerSup  := (cAlias)->Z1_PERSUP
				Else
				MsgStop("Regra de Desconto nใo cadastrada.","Aten็ใo")
				lRet := .F.
				Endif
				(cAlias)->( dbCloseArea() )
				*/
				
				MsgStop("Regra de Desconto nใo cadastrada.","Aten็ใo")
				lRet := .F.
				
			Endif
			
		Endif
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤTฟ
		//ณBusco o valor maximo do desconto que o vendedor podera conceder,        ณ
		//ณcaso aumente o valor unitario do produto, e nao valido as regras do CPC.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤTู
		If lValid
			If nPerVen > 0
				nVlMaxDesc	:= Round((nVlrItem * nPerVen)/100,2)
				nVlrTot   	:= Round(nVlrItem - nVlMaxDesc,2)
				nPrcBase	:= Round((aCols[nLinha,nPQuant]  * aCols[nLinha,nPPrcVen]) - nVlrTot  ,2)
				nPercMax 	:= nPrcBase / (aCols[nLinha,nPQuant]  * aCols[nLinha,nPPrcVen])
				nPercMax	:= Round(nPercMax * 100,2)
				
				If nPerDesc > nPercMax
					MsgStop("Desconto mแximo permitido ้: "+Alltrim(Str(nPercMax))+" %","Aten็ใo")
					lRet:= .F.
				Endif
			Else
				MsgStop("% Desconto nใo permitido.","Aten็ใo")
				lRet:= .F.
			Endif
		Endif
		
		If lRet .And. !lValid
			
			If (nPerDesc <= nPerVen) .And. (nPerVen > 0)
				lVendedor := .T.
				
			ElseIf (nPerDesc >= nPerVen .And. nPerDesc <= nPerGer) .And. nPerGer > 0
				lGerente := .T.
				
			ElseIf (nPerDesc >= nPerGer .And. nPerDesc <= nPerSup) .And. nPerSup > 0
				lSupervisor := .T.
				
			Endif
			
			If lVendedor
				lRet:= lOk
				
			ElseIf lGerente
				lOk := M106AbSenha(lGerente,cCodGere)
				lRet:= lOk
				
			ElseIf lSupervisor
				lOk := M106AbSenha(lGerente,cCodSuper)
				lRet:= lOk
				
			Else
//				MsgStop("% Desconto nใo permitido.","Aten็ใo")
//				lRet:= .F.
				lRet:= lOk
				
			Endif
			
		Endif
		
	Endif
	
Endif

If !lRet .And. cCampo=='UB_DESC'
	M->UB_DESC		   		:= 0
	aCols[nLinha,nPDesc]	:= 0
	aCols[nLinha,nPValDesc]	:= 0
	
	Tk273Calcula("UB_DESC",nLinha,.F.)
Endif

n := nLinha
Eval(bGDRefresh)

RestArea(aAreaSA3)
RestArea(aAreaSB1)
RestArea(aAreaSB4)
RestArea(aArea)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM106AbSenhaบAutor ณMicrosiga           บ Data ณ  08/04/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAbertura da tela de senha de autorizacao.                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function M106AbSenha(lGerente,cCodSup)

Local aUsers	:= {}
Local aAreaSA3	:= SA3->(GetArea())
Local cBitMap	:= "LOGIN"						// Bitmap utilizado na caixa de dialogo
Local cCaixaAtu	:= cUserName					// Caixa atual
Local cCaixaSup	:= Posicione("SA3",1,xFilial("SA3")+cCodSup,"A3_NOME")
Local cSuperSel := ""
Local nTamUser  := 25                           // Tamanho do campo do usuario
Local nTamPass  := 20                           // Tamanho do campo da senha
Local cSenhaSup	:= Space( nTamPass )			// Senha digitada do supervisor
Local cIDBkp	:= __cUserID					// Guarda o ID do usuario atual
Local cUserBkp	:= cUserName					// Guarda o Nome do usuario atual
Local aRegCx	:= {}
Local lRet		:= .F.

Local oDlgSenha									// Objeto da caixa de dialogo da senha do supervisor
Local oGetSup									// Objeto Get com o nome do superior que informou a senha
Local oGetSenha									// Objeto Get com a senha do superior

PswOrder(1)
If PswSeek(__cUserID)
	aRegCx := PswRet()
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosicione nos dados do superior.                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SA3->(DbSetOrder(1))
SA3->(DbSeek(xFilial("SA3") + cCodSup ))

PswOrder(1)
If PswSeek(SA3->A3_CODUSR,.T.)	//Retorna o arquivo de senhas para a posicao original
	aRegCx := PswRet()
Endif

DEFINE DIALOG oDlgSenha TITLE " Autorizacao do Superior " FROM 20, 20 TO 225,310 PIXEL

@ 0, 0 BITMAP oBmp1 RESNAME cBitMap oF oDlgSenha SIZE 50,140 NOBORDER WHEN .F. PIXEL

@ 05,55 SAY "Vendedor Atual"	PIXEL
@ 15,55 MSGET cCaixaAtu WHEN .F. PIXEL SIZE 80,08

@ 30,55 SAY If(lGerente,"Gerente","Supervisor") PIXEL
@ 40,55 MSGET oGetSup VAR cCaixaSup WHEN .F. PIXEL SIZE 80,08

@ 55,55 SAY If(lGerente,"Senha Gerente","Senha Supervisor") PIXEL
@ 65,55 MSGET oGetSenha VAR cSenhaSup PASSWORD PIXEL SIZE 40,08 VALID VldSenha(cSenhaSup)

DEFINE SBUTTON FROM 85,75  TYPE 1 ACTION ( IIF( !lRet .OR. Empty(cSenhaSup), lRet := VldSenha(cSenhaSup) , .T. ), oDlgSenha:End() ) ENABLE OF oDlgSenha
DEFINE SBUTTON FROM 85,105 TYPE 2 ACTION { || lRet := .F. , oDlgSenha:End() } ENABLE OF oDlgSenha

ACTIVATE MSDIALOG oDlgSenha CENTERED

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura o ID do usuario atualณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
__cUserID := cIDBkp
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura o Nome do usuario atualณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cUserName := cUserBkp

RestArea(aAreaSA3)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldSenha  บAutor  ณMicrosiga           บ Data ณ  02/13/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao da senha digitada.                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldSenha(cSenhaSup)

lRet := PswName(Alltrim(cSenhaSup))

If !lRet
	MsgStop( "Acesso Negado !!" )
Endif

Return lRet
