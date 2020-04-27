#INCLUDE "TOTVS.CH" //#AFD20180615.N
#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

#DEFINE ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  TMKMOK  º Autor ³ LUIZ EDUARDO F.C.  º Data ³  26/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PONTO DE ENTRADA NA GRAVACAO DO CHAMADO DO SAC.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION TMKMOK()

Local lRet     := .T.
Local cOcorAss := GETMV("MV_OCORASS",,"000004/000005")
Local aOPCTP   := {}
Local aOpcoes  := {}
Local aDEVOPC  := {}
Local aDevo    := {}                                   
Local cTermo   := ""
Local dDtAgen  := stod('22220222')
Local oDlgOpc, oCmbOpc, oCmbDev
Local lConfirm := .F.
Local aPrazo   := {}
Local cQuery   := ""                                                      
Local cQuery1   := ""
Local aAreaSA1a      := SA1->(GetArea())
Local aColsAlter	:= {}
Local lImprime	:= .F.
Local nMotivos	:= 0
Local cDefeito	:= ""
Local cObsLaudo	:= ""
Local nQtObs	:= 0
Local aProdutos	:= {}
Local nY		:= 0
Local cMsg		:= ""
Local dDtVis	:= cToD('')
Local nPosImp	:= 0
Local lReimp	:= .F.

Private n01TIPO   := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01TIPO"})
Private nPRODUTO  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_PRODUTO"})
Private n01PRCVE  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01PRCVE"})
Private n01QTDVE  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01QTDVE"})
Private n01LJORI  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01LJORI"})
Private nOCORREN  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_OCORREN"})
Private n01UM     := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01UM"})
Private nSTATUS   := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_STATUS"})
Private nITEM     := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_ITEM"})
Private nObs      := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_OBS"})
Private nDtEntr   := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01DTENT"})
Private nDescDef  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01DESDE"})
Private nASSUNTO  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_ASSUNTO"})
Private n01PEDID  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01PEDID"})
Private n01PEDOR  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01PEDOR"})
Private nXDESDE2  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_XDESDE2"}) // CRIADA AS VARIAVEIS PARA IDENTIFICAR NO ACOLS OS NOVOS DEFEITOS - LUIZ EDUARDO F.C. - 18.05.2017
Private nXDESDE3  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_XDESDE3"}) // CRIADA AS VARIAVEIS PARA IDENTIFICAR NO ACOLS OS NOVOS DEFEITOS - LUIZ EDUARDO F.C. - 18.05.2017
Private nXIMPLAU  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_XIMPLAU"}) // CAMPO DE CONTROLE DE IMPRESSAO DO LAUDO TECNICO - LUIZ EDUARDO F.C. - 24.05.2017
Private nDESCPRO  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_DESCPRO"})
Private n01RETIR  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01RETIR"})
Private n01DEFEI  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01DEFEI"})
Private nXDEFEI2  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_XDEFEI2"})
Private nXDEFEI3  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_XDEFEI3"})
Private nXNUMTIT  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_XNUMTIT"}) //#AFD20180615.N
Private nXAUTPOR  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_XAUTPOR"}) 
Private nXNumLaudo:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_XLAUDO"})
Private nxUser	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_XUSER"})
Private aGerOrc   := {}
Private aGerPV    := {}
Private aLaudo	  := {}
Private aPedOcor  := {}
Private lImpLaudo := .F. // FAZ O CONTROLE DA IMPRESSAO DO LAUDO TECNICO
Private cTESCont  := GetMV("KM_TESCONT",,"631")
Private cUserEst := SUPERGETMV("KH_OBRIPOS", .T., "001037|001035|001036|001033|000567|000455")
Private cUserCh  := SUPERGETMV("KH_SAC001", .T., "000478|000013|000553|000732|000774|000144|001148|001236")
//TK272AssTmk()

Private cMultiGet := ""
Private cTabela := 'Z1'
Private aCombos := RetSx3Box( Posicione("SX3", 2,"ZK0_AUTPOR", "X3CBox()" ),,, 1 )//separa(cAtorizado,"|",.T.)
Private aAut := {}
Private aDefeitos := {}
Private cAut := ""
Private oCmbAut := nil
Private oCmbDef1 := nil
Private oCmbDef2 := nil
Private oCmbDef3 := nil


//Ponto de entrada para validações internas
If ExistBlock("SYTMKMOK")
	lRet := ExecBlock("SYTMKMOK")
EndIf

if lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ GRAVAR A DESCRICAO DA FILIAL DE ORIGEM - LUIZ EDUARDO F.C. - 16/05/2017                  ³
	//³ VALIDAR PARA QUE ESTA GRAVACAO SO ACONTECA NA INCLUISAO - LUIZ EDUARDO F.C. - 06/08/2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF INCLUI
		M->UC_01FIL := FWFILIALNAME(cEmpAnt,cFilAnt,1)
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE EXISTEM ITENS QUE IRAM GERAR TERMO DE RETIRA - LUIZ EDUARDO F.C. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nTermo:=1 To Len(aCols)
		
		If !(aCols[nTermo][2] =="000008" .Or. aCols[nTermo][2] =="000012" .Or. aCols[nTermo][2] =="000004" .Or. aCols[nTermo][2] =="000005")
			
			//Caso o Cliente esteja com pendência financeira não será permitido a abertura de chamados diferente dos assuntos 000008 e 000012
			//Marcio Nunes - 27/08/2019 - Chamado 11114
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1") + M->UC_CHAVE)
			cCliente := SA1->A1_COD
			cLoja	 := SA1->A1_LOJA
			
			//Posiciona SE1 para verificar pendência financeira onnde a parcela é menor que a data atual e ainda não foi paga
			cQuery2 := "SELECT E1_CLIENTE, E1_NUM, E1_PARCELA, E1_PREFIXO, E1_TIPO, E1_CLIENTE, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO " + ENTER
			cQuery2 += " FROM SE1010  " + ENTER
			cQuery2 += " WHERE E1_TIPO IN('BOL','CH')  " + ENTER
			cQuery2 += " AND E1_CLIENTE='"+ cCliente +"' " + ENTER
			cQuery2 += " AND E1_VENCREA < GETDATE ( )-1  " + ENTER //Considerar 1 dia para constar como atraso
			cQuery2 += " AND E1_SALDO > 0 " + ENTER
			cQuery2 += " AND D_E_L_E_T_='' " + ENTER
			
			cAlias3 := GetNextAlias()
			
			PLSQuery(cQuery2, cAlias3)
			If (cAlias3)->(!Eof()) .And. (!RetCodUsr()$cUserCh)//Usuários chave podem abrir chamados diferentes de 000008 e 000012
				//MsgAlert("","ATENÇÃO")
				Help(NIL, NIL, 'ATENÇÃO', NIL, 'O Cliente possiu pendencia financeira não será permitido a abertura de chamado. KH_SAC001', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Entre em contato com o supervisor da área.'})
				Return .F.
			EndIf
			(cAlias3)->(DbCloseArea())
			
		EndIf
		
		If aCols[nTermo][2] =="000008"
			
			If INCLUI
				//Gravo o operador no chamado para a comunicação 000008
				//Marcio Nunes 26/08/2019 - 10963
				cQuery1 := "SELECT UL_TPCOMUN, UL_XASSUNT, UL_XCODUSR " + ENTER
				cQuery1 += " FROM SUL010 " + ENTER
				cQuery1 += " WHERE UL_XASSUNT='"+ aCols[nTermo][2] +"' AND D_E_L_E_T_='' " + ENTER
				cQuery1 += " AND UL_XCODUSR='"+ RetCodUsr() +"'  " + ENTER
				
				cAlias2 := GetNextAlias()
				
				PLSQuery(cQuery1, cAlias2)
				If (cAlias2)->(!Eof())
					M->UC_TIPO := (cAlias2)->UL_TPCOMUN
				EndIf
				(cAlias2)->(DbCloseArea())
				
				//Verifica o prazo de entrega do fornecedor para o preenchimento do campo UC_FOLLOW, a menor data dos itens será considerada.
				//Marcio Nunes 26/08/2019 - 10963
				cQuery := "SELECT A2_XRPAZO, B4_COD, B4_PROC FROM SB4010 (NOLOCK)  " + ENTER
				cQuery += " INNER JOIN SA2010 ON A2_COD = B4_PROC " + ENTER
				cQuery += "  WHERE B4_COD = SUBSTRING ( '"+ aCols[nTermo][5] +"',1,10) " + ENTER
				cQuery += "  AND A2_XRPAZO <> '' " + ENTER
				
				cAlias1 := GetNextAlias()
				
				PLSQuery(cQuery, cAlias1)
				While (cAlias1)->(!Eof())
					//Guarda os prazos dos fornecedores por produto
					nTotPra := (cAlias1)->A2_XRPAZO
					
					If (cAlias1)->B4_PROC == "000022" //Grallha Azul acrescenta mais 8 dias no prazo
						nTotPra := (cAlias1)->A2_XRPAZO + 8
					EndIf
					aAdd(aPrazo,nTotPra)
					
					(cAlias1)->(DbSkip())
				EndDo
				(cAlias1)->(DbCloseArea())
				
				//Alimenta o campo: UC_FOLLOW, com a menor data do array
				If Len(aPrazo) > 0
					//Sorteia o menor prazo do array e calcula a data
					nPrazo := aSort(aPrazo)
					
					//Retorna a data valida
					dData := DataValida(Date()+nPrazo[1])//Sempre busca o menor resultado
					
					If cValtoChar( DiaSemana( dData,, 3 ) ) == 'Segunda'
						dData += 1
					EndIf
					M->UC_XFOLLOW := dData
				EndIf
			EndIf
		EndIf
		
		cTermo := ALLTRIM(POSICIONE("Z01",1,XFILIAL("Z01") + aCols[nTermo,n01TIPO],"Z01_RETIRA"))
		IF aCols[nTermo,nStatus] == "1" .AND. cTermo == "1"
			//			cTermo := GetSxeNum("ZK0","ZK0_COD")
			cTermo := GetSx8Num("ZK0","ZK0_COD",1)
			
			aOPCTP := RetSx3Box( Posicione("SX3", 2,"ZK0_OPCTP", "X3CBox()" ),,, 1 )
			
			For nTp:=1 To Len(aOPCTP)
				IF !EMPTY(aOPCTP[nTp,1])
					aAdd( aOpcoes , aOPCTP[nTp,1] )
				EndIF
			Next
			
			aDEVOPC := RetSx3Box( Posicione("SX3", 2,"ZK0_TPDEV", "X3CBox()" ),,, 1 )
			
			For nTp:=1 To Len(aDEVOPC)
				IF !EMPTY(aDEVOPC[nTp,1])
					aAdd( aDevo , aDEVOPC[nTp,1] )
				EndIF
			Next
			
			aAdd(aAut, "")
			
			for nx := 1 to len(aCombos)
				if !empty(aCombos[nx,1])
					aAdd(aAut, aCombos[nx,3])
				endif
			next nx
			
			dbSelectArea("SX5")
			SX5->(dbSetOrder(1))
			
			aAdd(aDefeitos,"")
			
			SX5->(dbSeek(xFilial()+cTabela))
			While SX5->X5_TABELA == cTabela
				aAdd(aDefeitos,alltrim(SX5->X5_CHAVE) + '-' + SX5->X5_DESCRI)
				SX5->(dbSkip())
			End
			
			DEFINE DIALOG oDlgOpc TITLE "Termo de Retira" FROM 0,0 TO 400,300 PIXEL STYLE 128
			
			oDlgOpc:LESCCLOSE := .F.
			
			@ 005,005 Say "Termo de Retira : " + cTermo Size 150,010 Pixel Of oDlgOpc
			
			@ 016,005 Say "Tipo Retira : " Size 150,010 Pixel Of oDlgOpc
			
			cOpcao  := aOpcoes[1]
			oCmbOpc := TComboBox():New(014,065,{|u|if(PCount()>0,cOpcao:=u,cOpcao)},aOpcoes,080,010,oDlgOpc,,{||},,,,.T.,,,,,,,,,'cOpcao')
			
			@ 030,005 Say "Tipo Devolução : " Size 150,010 Pixel Of oDlgOpc
			
			cDevo := aDevo[1]
			oCmbDev := TComboBox():New(028,065,{|u|if(PCount()>0,cDevo:=u,cDevo)},aDevo,080,010,oDlgOpc,,{||},,,,.T.,,,,,,,,,'cDevo')
			
			@ 044,005 Say "Data Agendamento : " Size 150,010 Pixel Of oDlgOpc
			@ 042,065 MsGet dDtAgen of oDlgOpc Picture PesqPict('ZK0','ZK0_DTAGEN') Pixel VALID !EMPTY(dDtAgen)
			
			@ 058,005 Say "Autorizado Por : " Size 150,010 Pixel Of oDlgOpc
			cAut := aAut[1]
			oCmbAut := TComboBox():New(056,065,{|u|if(PCount()>0,cAut:=u,cAut)},aAut,080,010,oDlgOpc,,{||},,,,.T.,,,,,,,,,'cAut')
			
			@ 072,005 Say "Defeito 1 : " Size 90,010 Pixel Of oDlgOpc
			cDefeito1 := aDefeitos[1]
			oCmbDef1 := TComboBox():New(070,035,{|u|if(PCount()>0,cDefeito1:=u,cDefeito1)},aDefeitos,110,010,oDlgOpc,,{|| },,,,.T.,,,,,,,,,'cDefeito1')
			
			@ 086,005 Say "Defeito 2 : " Size 90,010 Pixel Of oDlgOpc
			cDefeito2 := aDefeitos[1]
			oCmbDef2 := TComboBox():New(084,035,{|u|if(PCount()>0,cDefeito2:=u,cDefeito2)},aDefeitos,110,010,oDlgOpc,,{||},,,,.T.,,,,,,,,,'cDefeito2')
			
			@ 100,005 Say "Defeito 3 : " Size 90,010 Pixel Of oDlgOpc
			cDefeito3 := aDefeitos[1]
			oCmbDef3 := TComboBox():New(98,035,{|u|if(PCount()>0,cDefeito3:=u,cDefeito3)},aDefeitos,110,010,oDlgOpc,,{||},,,,.T.,,,,,,,,,'cDefeito3')
			
			@ 110, 005 GET oMultiGet VAR cMultiGet MEMO SIZE 142, 066 PIXEL OF oDlgOpc
			
			@ 180,065 BUTTON "&OK" SIZE 50,15 OF oDlgOpc PIXEL ACTION {|| iif(fVldGets(@lConfirm),oDlgOpc:End(),)  }
			@ 180,005 BUTTON "&CANCELAR" SIZE 50,15 OF oDlgOpc PIXEL ACTION {|| lConfirm := .F., oDlgOpc:End() }
			
			ACTIVATE DIALOG oDlgOpc CENTERED
			
			if lConfirm
				
				aCols[nTermo,nObs] := cMultiGet //Observação
				aCols[nTermo,nXAUTPOR] := alltrim(cAut) //Autorização
				
				aCols[nTermo,n01DEFEI] := subString(cDefeito1,1,at('-',cDefeito1)-1) //cod. Defeito
				aCols[nTermo,nDescDef] := subString(cDefeito1,at('-',cDefeito1)+1,len(cDefeito1)) //descrição  Defeito
				
				if !empty(alltrim(cDefeito2))
					aCols[nTermo,nXDEFEI2] := subString(cDefeito2,1,at('-',cDefeito2)-1) //cod. Defeito 2
					aCols[nTermo,nXDESDE2] := subString(cDefeito2,at('-',cDefeito2)+1,len(cDefeito2)) //descrição  Defeito 2
				endif
				
				if !empty(alltrim(cDefeito3))
					aCols[nTermo,nXDEFEI3] := subString(cDefeito3,1,at('-',cDefeito3)-1) //cod. Defeito 3
					aCols[nTermo,nXDESDE3] := subString(cDefeito3,at('-',cDefeito3)+1,len(cDefeito3)) //descrição  Defeito 3
				endif
				
				DbSelectArea("ZK0")
				ZK0->(Reclock("ZK0",.T.))
				ZK0->ZK0_FILIAL := XFILIAL("ZK0")
				ZK0->ZK0_COD    := cTermo
				ZK0->ZK0_PROD   := aCols[nTermo,nPRODUTO]
				ZK0->ZK0_DESCRI := aCols[nTermo,nDESCPRO]
				ZK0->ZK0_NUMSAC := M->UC_CODIGO
				ZK0->ZK0_TIPO   := aCols[nTermo,n01TIPO]
				ZK0->ZK0_CLI    := SUBSTR(M->UC_CHAVE,1,6)
				ZK0->ZK0_LJCLI  := SUBSTR(M->UC_CHAVE,7,2)
				ZK0->ZK0_PEDORI := M->UC_01PED
				ZK0->ZK0_CARGA  := ""
				ZK0->ZK0_NFDEV  := ""
				ZK0->ZK0_SERDEV := ""
				ZK0->ZK0_DATA   := dDataBase
				ZK0->ZK0_STATUS := "1"
				ZK0->ZK0_OBSSAC := aCols[nTermo,nObs]
				ZK0->ZK0_DEFEIT := ALLTRIM(aCols[nTermo,nDescDef]) + " / " + ALLTRIM(aCols[nTermo,nXDESDE2]) + " / " + ALLTRIM(aCols[nTermo,nXDESDE3])
				ZK0->ZK0_OPCTP  := cOpcao
				ZK0->ZK0_TPDEV  := cDevo
				ZK0->ZK0_DTAGEN := dDtAgen
				ZK0->ZK0_AUTPOR := aCols[nTermo,nXAUTPOR]
				ZK0->(MsUnlock())
				
				//Tratamento para gravar a Tabela ZL8 como forma de controle da Fábrica do processo de conserto
				DbSelectArea("ZL8")
				ZL8->(Reclock("ZL8",.T.))
				ZL8->ZL8_FILIAL := XFILIAL("ZL8")
				ZL8->ZL8_COD    := cTermo
				ZL8->ZL8_PROD   := aCols[nTermo,nPRODUTO]
				ZL8->ZL8_DESCRI := aCols[nTermo,nDESCPRO]
				ZL8->ZL8_NUMSAC := M->UC_CODIGO
				ZL8->ZL8_TIPO   := aCols[nTermo,n01TIPO]
				ZL8->ZL8_CLI    := SUBSTR(M->UC_CHAVE,1,6)
				ZL8->ZL8_LJCLI  := SUBSTR(M->UC_CHAVE,7,2)
				ZL8->ZL8_PEDORI := M->UC_01PED
				ZL8->ZL8_CARGA  := ""
				ZL8->ZL8_NFDEV  := ""
				ZL8->ZL8_SERDEV := ""
				ZL8->ZL8_DATA   := dDataBase
				ZL8->ZL8_STATUS := "1"
				ZL8->ZL8_OBSSAC := aCols[nTermo,nObs]
				ZL8->ZL8_DEFEIT := ALLTRIM(aCols[nTermo,nDescDef]) + " / " + ALLTRIM(aCols[nTermo,nXDESDE2]) + " / " + ALLTRIM(aCols[nTermo,nXDESDE3])
				ZL8->ZL8_OPCTP  := cOpcao
				ZL8->ZL8_TPDEV  := cDevo
				ZL8->ZL8_DTAGEN := dDtAgen
				ZL8->ZL8_AUTPOR := aCols[nTermo,nXAUTPOR]
				ZL8->(MsUnlock())
				
				aCols[nTermo,n01RETIR] := ZK0->ZK0_COD
				aCols[nTermo,nStatus]  := "2"
				
				ConfirmSx8() // #CMG20180502.n
				
				//AFD26072018.BN
				_cString := "Deseja atualizar o pedido de origem, com o numero do SAC ?" + chr(13)+chr(10)
				_cString += "OBS: Utilizado somente para Emprestimo do produtos.
				
				if msgYesNo(_cString,"ATUALIZA PEDIDO DE ORIGEM ?")
					if len(alltrim(M->UC_01PED)) == 10 //Verifica se o campo foi preenchido corretamente, filial+pedido (0101+000100)
						MsgRun("Aguarde...","Atualizando pedido de origem",{|| AtuPedOri(LEFT(M->UC_01PED,4), RIGHT(M->UC_01PED,6), M->UC_CODIGO) })
					else
						msgAlert("","ATENÇÃO")
						Help(NIL, NIL, 'ATENÇÃO', NIL, 'O campo Pedido de origem não foi preenchido corretamente!!', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Preencha o campo corretamente para prosseguir.'})
						Return .F.
					endif
				endif
				//AFD26072018.EN
			else
				RollBackSx8()
				Return lConfirm
			endif
		EndIF
	Next
	
	For nOc:=1 To Len(aCols)
		If !aTail( aCols[nOc] )
			IF EMPTY(aCols[nOc,nOCORREN]) .OR. EMPTY(aCols[nOc,nASSUNTO])
				MsgInfo("Existem itens que não estão com o campo [OCORRENCIA] ou o campo [ASSUNTO] preenchido! Por favor preencha!")
				Return(.F.)
			EndIF
		EndIF
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE VAI SER IMPRESSO O LAUDO TECNICO DE ALGUM ITEM DO CHAMADO - LUIZ EDUARDO F.C. - 24.05.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=1 To Len(aCols)
		If !aTail( aCols[nX] )
			IF aCols[nX,nXIMPLAU]=='1'
				lImpLaudo := .T.
				Exit
			ElseIF aCols[nX,nOCORREN] $ cOcorAss .And. aCols[nX,nStatus]=='1' .And. aCols[nX,nXIMPLAU]=='1'
				lImpLaudo := .T.
				Exit
			EndIF
		EndIF
	Next

	If (lImpLaudo)
		If MsgYesNO("Deseja fazer a impressão do laudo técnico?","Atenção")
			aColsAlter	:= {}
			For nX:=1 To Len(aCols)
				If !aTail( aCols[nX] )
					IF aCols[nX,nXIMPLAU]=='1'
						nPosImp	:= nX
						AADD(aColsAlter , nX)
						// INCLUIDO NO ACOLS OS CAMPOS DE DESCRICAO DE DEFEITO 2 E 3 - LUIZ EDUARDO F.C. - 18.05.2017
						//Aadd( aLaudo , { aCols[nX,nPRODUTO] , aCols[nX,nObs] , aCols[nX,nDtEntr] , aCols[nX,nDescDef] } )
						Aadd( aLaudo , { aCols[nX,nPRODUTO] , aCols[nX,nObs] , aCols[nX,nDtEntr] , aCols[nX,nDescDef] , aCols[nX,nXDESDE2] , aCols[nX,nXDESDE3], aCols[nX,nXNumLaudo], aCols[nX,nxUser] } )
						If !(Empty(aLaudo[Len(aLaudo) , 7])) //Verifica se ja houve impressao anterior do laudo
							lReimp	:= .T.
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ ATUALIZA NO SC6 O ITEM PARA ANALISE TECNICA ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						//C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM
						DbSelectArea("SC6")
						SC6->(DbSetOrder(2))
						IF SC6->(DbSeek(xFilial("SC6") + aCols[nX,nPRODUTO] + RIGHT(ALLTRIM(M->UC_01PED),6)))
							SC6->(RecLock("SC6",.F.))
							SC6->C6_01STATU := "4"
							SC6->(MsUnlock())
						EndIF
						SC6->(DbCloseArea())
						
						// ATUALIZA O STATUS DO ITEM DO CHAMADO PARA ENCERRADO - LUIZ EDUARDO F.C. - 24.05.2017
						aCols[nX,nStatus]  := "2"
						// ATUALIZA O CAMPO REIMPRESSAO DO LAUDO TECNICO PARA "2" - NAO - LUIZ EDUARDO F.C. - 24.05.2017
						aCols[nX,nXIMPLAU] := "2"
					ElseIf aCols[nX,nOCORREN] $ cOcorAss .And. aCols[nX,nStatus]=='1' .And. aCols[nX,nXIMPLAU]=='1'
						nPosImp	:= nX
						AADD(aColsAlter , nX)
						// INCLUIDO NO ACOLS OS CAMPOS DE DESCRICAO DE DEFEITO 2 E 3 - LUIZ EDUARDO F.C. - 18.05.2017
						//Aadd( aLaudo , { aCols[nX,nPRODUTO] , aCols[nX,nObs] , aCols[nX,nDtEntr] , aCols[nX,nDescDef] } )
						Aadd( aLaudo , { aCols[nX,nPRODUTO] , aCols[nX,nObs] , aCols[nX,nDtEntr] , aCols[nX,nDescDef] , aCols[nX,nXDESDE2] , aCols[nX,nXDESDE3], aCols[nX,nXNumLaudo] ,aCols[nX,nxUser]} )
						
						If !(Empty(aLaudo[Len(aLaudo) , 7])) //Verifica se ja houve impressao anterior do laudo
							lReimp	:= .T.
						EndIf						
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ ATUALIZA NO SC6 O ITEM PARA ANALISE TECNICA ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						//C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM
						DbSelectArea("SC6")
						SC6->(DbSetOrder(2))
						IF SC6->(DbSeek(xFilial("SC6") + aCols[nX,nPRODUTO] + RIGHT(ALLTRIM(M->UC_01PED),6)))
							SC6->(RecLock("SC6",.F.))
							SC6->C6_01STATU := "4"
							SC6->(MsUnlock())
						EndIF
						SC6->(DbCloseArea())
						
						// ATUALIZA O STATUS DO ITEM DO CHAMADO PARA ENCERRADO - LUIZ EDUARDO F.C. - 24.05.2017
						aCols[nX,nStatus]  := "2"
						// ATUALIZA O CAMPO REIMPRESSAO DO LAUDO TECNICO PARA "2" - NAO - LUIZ EDUARDO F.C. - 24.05.2017
						aCols[nX,nXIMPLAU] := "2"
					EndIF
				EndIF
			Next
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ VERIFICA SE IRA FAZER A IMPRESSAO DO LAUDO TECNICO  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Len(aLaudo) > 0
				
				nMotivos	:= 0
			
				For nX := 1 TO Len(aLaudo)

					cDefeito	:= ""

					cObsLaudo		+= IIF(Empty(aLaudo[nX , 02]) , "" , cValToChar(nX) + "." + ALLTRIM(aLaudo[nX , 02]) + "|" )

					If (SB1->(DbSeek(xFilial("SB1") + aLaudo[nX , 01] )))

						AADD(aProdutos , {SB1->B1_COD , SB1->B1_DESC})

					EndIf

					For nY := 4 TO 6 // Os arrays entre 4 e 6 sao correspondentes aos motivos dos defeitos

						If (!Empty(aLaudo[nX , nY]))

							++nMotivos

							cDefeito	+=  AllTrim(aLaudo[nX , nY]) + Space(3)

						EndIf

					Next nY

					If (nMotivos >= 1)
						
						AADD(aDefeitos , cDefeito)

						lImprime	:= .T.

					Else

						cMsg		+= "Produto : " + aLaudo[nX,1] + " Com quantidade insuficiente de motivos " + CHR(13) + CHR(10)

						Aviso("MOTIVOS INSUFICIENTES" , cMsg)

					EndIf

					//nMotivos	:= 0 //Terminada a validacao, a variavel 'nMotivos' deve ser zerada. Em cada produto, podem ser informados 3 defeitos e, obrigatoriamente, 2 defeitos devem ser informados por produto.

				Next nX

				dDtVis	:= IIF(Empty(SUC->UC_XFOLLOW) , M->UC_XFOLLOW , SUC->UC_XFOLLOW)

				If (Empty(dDtVis))

					lImprime	:= .F.

					Aviso("SEM DATA DE VISITA" , "Data de visita não preenchida")

				Else

					lImprime	:= .T.

				EndIf

				If (Empty(cObsLaudo)) .AND. (nQtObs == 0)

					lImprime	:= .F.

					Aviso("SEM OBS." , "Observação não preenchida.")				

				Else

					lImprime	:= .T.
					
					++nQtObs

				EndIf

				If (lImprime)
					If (lReimp)  //Verifica se o laudo nao foi impresso anteriormente. Somente o Isaias terá acesso a reimpressão
						If !(__cUserid == SuperGetMv("KH_IMPLAUD" , , "000478"))
							lImprime	:= .F.
							Aviso("KH_IMPLAUD" , "Usuário não autorizado para reimpressão do laudo")							
						EndIf
					EndIf
				Else
					Aviso("ERRO" , "CAMPOS OBRIGATÓRIOS NÃO PREENCHIDOS")
					aCols[nPosImp,nXIMPLAU] := "1" //Foram encontrados erros no preenchimento dos campos obrigatorios, mas nao obriga alterar a opcao de imprimir (ou nao) o laudo
					aCols[nPosImp,nStatus]  := "1" //Retorna o status do atendimento para: "em aberto", devido a não impressão do laudo
				EndIf

				If (lImprime)
					FwMsgRun( ,{|| U_SYTMR001(aLaudo,aColsAlter,nXNumLaudo,aProdutos,aDefeitos,cObsLaudo) }, , "Aguarde, gerando a impressão do laudo tecnico..." )
				EndIf

			Endif
		EndIF
	EndIF
	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³VARRE O ACOLS E VERIFICA SE EXISTEM ITENS COM OCORRENCIA ASSISTENCIA TECNICA PARA GERACAO DO LAUDO.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=1 To Len(aCols)
	If !aTail( aCols[nX] )
	If aCols[nX,nOCORREN] $ cOcorAss .And. aCols[nX,nStatus]=='1'
	// INCLUIDO NO ACOLS OS CAMPOS DE DESCRICAO DE DEFEITO 2 E 3 - LUIZ EDUARDO F.C. - 18.05.2017
	//Aadd( aLaudo , { aCols[nX,nPRODUTO] , aCols[nX,nObs] , aCols[nX,nDtEntr] , aCols[nX,nDescDef] } )
	Aadd( aLaudo , { aCols[nX,nPRODUTO] , aCols[nX,nObs] , aCols[nX,nDtEntr] , aCols[nX,nDescDef] , aCols[nX,nXDESDE2] , aCols[nX,nXDESDE3]} )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ATUALIZA NO SC6 O ITEM PARA ANALISE TECNICA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM
	DbSelectArea("SC6")
	SC6->(DbSetOrder(2))
	IF SC6->(DbSeek(xFilial("SC6") + aCols[nX,nPRODUTO] + RIGHT(ALLTRIM(M->UC_01PED),6)))
	SC6->(RecLock("SC6",.F.))
	SC6->C6_01STATU := "4"
	SC6->(MsUnlock())
	EndIF
	SC6->(DbCloseArea())
	Endif
	EndIF
	Next
	*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³VARRE O ACOLS E VERIFICA SE EXISTEM ITENS COM OCORRENCIA [REENTREGA] E COM O CAMPO GERA ORCAMENT = 1 [SIM] ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=1 To Len(aCols)
		If !aTail( aCols[nX] )
			
			IF !Empty(aCols[nX,nOCORREN]) .AND. !Empty(aCols[nX,n01TIPO]) .AND. aCols[nX,nSTATUS] == "1" .AND. Empty(aCols[nX,n01PEDID])
				Z01->(DbSetOrder(1))
				If Z01->(DbSeek(xFilial("Z01") + aCols[nX,n01TIPO] ))
					
					If Z01->Z01_TIPO == '1'
						
						nPos := Ascan(aGerPV,{|x| x[1] == aCols[nX,nOCORREN] })
						If nPos==0
							aAdd( aGerPV , { aCols[nX,nOCORREN] , aCols[nX] } )
						Else
							aAdd( aGerPV[nPos] , aCols[nX] )
						Endif
						aCols[nX,n01PEDID] := "P"
						
					ElseIf Z01->Z01_TIPO == '2'
						
						aAdd( aGerOrc , aCols[nX] )
						aCols[nX,n01PEDID] := "O"
						
					Endif
					
				Endif
				
			EndIF
		EndIF
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE IRA CRIAR ORCAMENTO AUTOMATICO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF Len(aGerOrc) > 0
		FwMsgRun( ,{|| GERAORC()          }, , "Gerando orçamento no Televendas , Por Favor Aguarde..." )
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE IRA CRIAR PEDIDO DE VENDA AUTOMATICO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF Len(aGerPV) > 0
		For nYz := 1 To Len(aGerPV)
			FwMsgRun( ,{|| GERAPED( aGerPV[nYz] ) }, , "Gerando pedido(s), Por Favor Aguarde..." )
		Next
	EndIF
	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE IRA FAZER A IMPRESSAO DO LAUDO TECNICO  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aLaudo) > 0
	If MsgYesNO("Deseja fazer a impressão do laudo técnico?","Atenção")
	For nZ := 1 To Len(aLaudo)
	FwMsgRun( ,{|| U_KMFATR01(aLaudo,nZ) }, , "Aguarde, gerando a impressão do laudo tecnico..." )
	Next
	Endif
	Endif
	*/
	
	For nT:=1 To len(aCols)
		IF aCols[nT,n01PEDID] == "P" .OR. aCols[nT,n01PEDID] == "O"
			aCols[nT,n01PEDID] := ""
		EndIF
	Next
endif

if Empty(alltrim(M->UC_OBS))
	cObs := U_SyLeSYP( M->UC_CODOBS, 81 )
	M->UC_OBS := cObs
endif

if Empty(alltrim(M->UC_OBS))
	MsgAlert("TMKMOK - Campo observação vazio, acione a equipe de Sistemas !!!")
	Return(.F.)
endif

If __cUserid $ cUserEst
	
	
	If Empty(AllTrim(M->UC_XTPERRO))
		Help(NIL, NIL, "Tipo de Erro", NIL, "Campo Tipo Erro Não Preenchido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Preencha o Campo Tipo de Erro"})
		Return(.F.)
	EndIf
	If Empty(AllTrim(M->UC_XSTATUS))
		Help(NIL, NIL, "Status PV", NIL, "Campo Status Pv Não Preenchido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Preecnha o Campo Status PV"})
		Return(.F.)
	EndIf
	If Empty(AllTrim(dtos(M->UC_XFOLLOW)))
		Help(NIL, NIL, "Follow", NIL, "Campo Follow Não Preenchido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Preecnha o Campo Follow"})
		Return(.F.)
	EndIf
	If Empty(AllTrim(M->UC_XFILIAL))
		Help(NIL, NIL, "Loja", NIL, "Campo Loja Não Preenchido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Preecnha o Campo Loja"})
		Return(.F.)
	EndIf
	/*
	If Empty(AllTrim(M->UC_XSATISF))
	Help(NIL, NIL, "Sat  Ate Loja", NIL, "Campo Sat  Ate Loja Não Preenchido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Preecnha o Campo Sat  Ate Loja"})
	Return(.F.)
	EndIf
	If Empty(AllTrim(M->UC_XSATCLI))
	Help(NIL, NIL, "Sat Cliente", NIL, "Campo Sat Cliente Não Preenchido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Preecnha o Campo Sat Cliente"})
	Return(.F.)
	EndIf
	*/
	If  lMsgPesq := MSGYESNO( "Prezado, confirma o preenchimento da pesquisa de Satisfação? ", "Pesquisa" )
	Else
		Return(.F.)
	EndIf    	
	
Endif        
/*
If M->UC_01TROCA > 0 .Or. M->UC_01TRFRE == "1"  //Marcio Nunes - V1T-Z6T-QDX4
	If !(__cUserId == "000478")
	    MsgAlert ("Você não tem permissão para o preenchimento dos campos % Troca Adapt e Desc Fre Ad")
		Return(.F.)
	EndIf
EndIf 
*/
//Everton Santos - MTD-US1-AGTB (Número do ticket: 10882)
If M->UC_PENDENT <= dDataBase
	MsgAlert('A data de retorno não pode ser menor ou igual a data atual.','Data de Retorno Invalida')
    Return(.F.)
EndIf
//-----------------------------------------------------------------------------------------------------

RETURN(lRet) 

//--------------------------------------------------------------
/*/{Protheus.doc} fVldGets
Description //validação de campos
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 14/02/2019 /*/
//--------------------------------------------------------------
Static Function fVldGets(lOk)

Default lOk := .F.

if empty(alltrim(cDefeito1))
	Help(NIL, NIL, 'ATENÇÃO', NIL, 'Campo Defeito 1 Não preenchido.', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Preencha o campo corretamente para prosseguir.'})
	Return lOk
else
	lOk := .T.
endif

Do Case
	Case len(alltrim(cMultiGet)) > TamSx3("UD_OBS")[1]
		Help(NIL, NIL, "ATENÇÃO", NIL, "Por favor informar no maximo "+ cValToChar(TamSx3("UD_OBS")[1] - (16+len(alltrim(cAut)))) +" caracteres no campo Observação.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Preencha o campo corretamente para prosseguir."})
		Return .F.
	Case len(alltrim(cMultiGet)) < 30
		Help(NIL, NIL, "ATENÇÃO", NIL, "Por favor informar no minimo 30 caracteres no campo Observação.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Preencha o campo corretamente para prosseguir."})
		Return .F.
	case empty(alltrim(cAut))
		Help(NIL, NIL, "ATENÇÃO", NIL, "Por favor informar o campo Autorizado Por.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Preencha o campo corretamente para prosseguir."})
		Return .F.
	Case len(alltrim(cMultiGet)) >= 30
		lOk := .T.
EndCase

Return lOk



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  º  GERAORC º Autor º LUIZ EDUARDO F.C.  º Data ³  26/10/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³ GERA ORCAMENTO AUTOMATICO NO TELEVENDAS                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                              `
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION GERAORC()

Local aArea		:= GetArea()
Local cTabPad   := GETMV("MV_TABPAD")
Local cFlBkp    := cFilAnt
Local cCondPg	:= ALLTRIM(POSICIONE("Z01",1,XFILIAL("Z01") + aGerOrc[1,n01TIPO], "Z01_CONDPG"))
Local cTimeIni	:= Time()

Local cRotina	:= "2"
Local cNumero   := ""
Local cMay      := ""
Local cCodCont	:= ""
Local cVendedor	:= ""
Local cTes		:= ""
Local cMidia	:= ""

Local nItem	 	:= 0
Local nValBruto	:= 0

Local aCabec 	:= {}
Local aItens 	:= {}
Local aLinha 	:= {}

Local aAreaSA1  := SA1->(GetArea())
Local aAreaSUA  := SUA->(GetArea())
Local aAreaSC5  := SC5->(GetArea())

If Select("TRB1") > 0
	TRB1->(DbCloseArea())
Endif
BeginSql Alias "TRB1"
	SELECT UA_MIDIA FROM %Table:SUA% SUA (NOLOCK)
	WHERE UA_NUMSC5 = %Exp:aGerOrc[1,n01PEDOR]%
	AND SUA.%NotDel%
EndSql
cMidia := TRB1->UA_MIDIA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BUSCA AS INFORMACOES DO CLIENTE PARA A GERACAO DO ORCAMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1") + M->UC_CHAVE)
cCliente := SA1->A1_COD
cLoja	 := SA1->A1_LOJA
cChave   := cCliente+cLoja

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BUSCA AS INFORMACOES DO CONTATO PARA A GERACAO DO ORCAMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCodCont := M->UC_CODCONT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BUSCA AS INFORMACOES DO OPERADOR PARA A GERACAO DO ORCAMENTO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SU7")
DbSetOrder(1)
DbSeek(xFilial("SU7") + M->UC_OPERADO )
cVendedor := SU7->U7_CODVEN

For nX := 1 To Len(aGerOrc)
	nValBruto += (aGerOrc[nX,n01QTDVE] * aGerOrc[nX,n01PRCVE])
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ConOut(Repl("-",80))
ConOut(PadC("Teste de Inclusao de Atendimento "	,80))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Incluir atendimentos do televendas   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ConOut("Inicio: " +Time())

cFilAnt := IIf( Empty(aGerOrc[1,n01LJORI]) , cFlBkp , aGerOrc[1,n01LJORI] )
cNumero := U_fGerREG(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA OS ARRAYS PARA A MONTAGEM DO ORCAMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Begin Transaction

//Gera Cabecalho do TeleVendas
RECLOCK("SUA",.T.)
SUA->UA_FILIAL	:= xFilial("SUA")
SUA->UA_NUM 	:= cNumero
SUA->UA_CLIENTE	:= cCliente
SUA->UA_LOJA	:= cLoja
SUA->UA_CODCONT	:= cCodCont
SUA->UA_DESCNT  := Posicione("SU5",1,xFilial("SU5")+cCodCont,"U5_CONTAT")
SUA->UA_OPERADO	:= M->UC_OPERADO
SUA->UA_CONDPG	:= cCondPg
SUA->UA_TABELA	:= ""
SUA->UA_EMISSAO	:= dDatabase
SUA->UA_OPER	:= "2"
SUA->UA_TMK		:= "4"
SUA->UA_VEND	:= cVendedor
SUA->UA_MIDIA	:= cMidia
SUA->UA_TPFRETE	:= "C"
SUA->UA_INICIO	:= cTimeIni
SUA->UA_FIM		:= Time()
SUA->UA_DIASDAT := ( CTOD("01/01/2045") - dDatabase )
SUA->UA_HORADAT	:= 86400 - ( (VAL(Substr(cTimeIni,1,2))*3600) + ( VAL(Substr(cTimeIni,4,2))*60) + VAL(Substr(cTimeIni,7,2))  )
SUA->UA_PROSPEC	:= .F.
SUA->UA_STATUS	:= "SUP"
SUA->UA_VALBRUT	:= nValBruto
SUA->UA_DTLIM	:= dDatabase+10
SUA->UA_VALMERC	:= nValBruto
SUA->UA_VLRLIQ	:= nValBruto
SUA->UA_MOEDA	:= 1
SUA->UA_ENTRADA	:= nValBruto
SUA->UA_TPCARGA	:= "2"
SUA->UA_PARCELA	:= 1
SUA->UA_01SAC	:= M->UC_CODIGO
SUA->UA_ENDCOB  := SA1->A1_END
SUA->UA_BAIRROC	:= SA1->A1_BAIRRO
SUA->UA_MUNC	:= SA1->A1_MUN
SUA->UA_CEPC  	:= SA1->A1_CEP
SUA->UA_ESTC  	:= SA1->A1_EST
SUA->UA_ENDENT  := SA1->A1_END
SUA->UA_BAIRROE	:= SA1->A1_BAIRRO
SUA->UA_MUNE	:= SA1->A1_MUN
SUA->UA_CEPE  	:= SA1->A1_CEP
SUA->UA_ESTE   	:= SA1->A1_EST
SUA->UA_FORMPG	:= "R$"
SUA->UA_TIPOCLI	:= "F"
SUA->UA_PEDPEND	:= "4"
SUA->UA_01NFP	:= "2"
MSUNLOCK()

//Gera itens do TeleVendas
For nX:=1 To Len(aGerOrc)
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + AvKey(aGerOrc[nX,nPRODUTO],"B1_COD")))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TRATAMENTO PARA CLIENTES FORA DO ESTADO NAO CONTRIBUINTES - LUIZ EDUARDO F.C. - 12.01.2018 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ALLTRIM(SA1->A1_EST) <> "SP"
		IF SA1->A1_CONTRIB == "2"
			cTes := ALLTRIM(POSICIONE("Z01",1,XFILIAL("Z01") + aGerOrc[nX,n01TIPO], "Z01_TESFOR"))
		Else
			cTes := ALLTRIM(POSICIONE("Z01",1,XFILIAL("Z01") + aGerOrc[nX,n01TIPO], "Z01_TES"))
		EndIF
	Else
		cTes := ALLTRIM(POSICIONE("Z01",1,XFILIAL("Z01") + aGerOrc[nX,n01TIPO], "Z01_TES"))
	EndIF
	
	//cTes := ALLTRIM(POSICIONE("Z01",1,XFILIAL("Z01") + aGerOrc[nX,n01TIPO], "Z01_TES"))
	SF4->(DbSetOrder(1))
	SF4->(DbSeek(xFilial("SF4") + AvKey(cTes,"F4_CODIGO")))
	
	nItem++
	RECLOCK("SUB",.T.)
	SUB->UB_FILIAL	:= xFilial("SUB")
	SUB->UB_NUM		:= cNumero
	SUB->UB_ITEM 	:= StrZero(nItem,2)
	SUB->UB_PRODUTO	:= SB1->B1_COD
	SUB->UB_UM		:= SB1->B1_UM
	SUB->UB_QUANT	:= aGerOrc[nX,n01QTDVE]
	SUB->UB_VRUNIT	:= aGerOrc[nX,n01PRCVE]
	SUB->UB_VLRITEM	:= aGerOrc[nX,n01QTDVE] * aGerOrc[nX,n01PRCVE]
	SUB->UB_TES		:= cTes
	SUB->UB_CF		:= SF4->F4_CF
	SUB->UB_PRCTAB	:= aGerOrc[nX,n01PRCVE]
	SUB->UB_BASEICM	:= aGerOrc[nX,n01QTDVE] * aGerOrc[nX,n01PRCVE]
	SUB->UB_LOCAL	:= ALLTRIM(POSICIONE("Z01",1,XFILIAL("Z01") + aGerOrc[nX,n01TIPO], "Z01_LOCAL "))
	SUB->UB_01DESCL := ALLTRIM(POSICIONE("NNR",1,XFILIAL("NNR") + Z01->Z01_LOCAL, "NNR_DESCRI"))
	SUB->UB_PE		:= POSICIONE("SB1",1,XFILIAL("SB1") + aGerOrc[nX,nPRODUTO], "B1_PE")
	SUB->UB_DTENTRE	:= dDatabase
	SUB->UB_FILSAI	:= aGerOrc[nX,n01LJORI]
	SUB->UB_01TABPA	:= cTabPad
	SUB->UB_XFORFAT	:= "1"
	SUB->UB_TPENTRE	:= "3"
	SUB->UB_CONDENT	:= "1"
	SUB->UB_MOSTRUA	:= "1"
	SUB->UB_EMISSAO	:= dDatabase
	SUB->UB_DTVALID	:= dDatabase+10
	MSUNLOCK()
Next
ConOut("Atendimento incluido com sucesso! ")

MsgInfo("Orçamento número : " + cNumero + " foi criado com sucesso!","Atenção")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ POSICIONA NO PEDIDO ORIGINAL PARA GRAVAR O NUMERO DO CHAMADO DO SAC ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC5")
SC5->(DbGoTop())
SC5->(DbOrderNickName("SC5MSFIL"))
IF SC5->(DbSeek(xFilial("SC5") + RIGHT(M->UC_01PED,6) + LEFT(M->UC_01PED,4) ))
	SC5->(RecLock("SC5",.F.))
	SC5->C5_01SAC := M->UC_CODIGO
	SC5->(MsUnlock())
EndIF

For nT:=1 To len(aCols)
	IF aCols[nT,n01PEDID] == "O"
		aCols[nT,n01PEDID] := cNumero
		aCols[nT,nSTATUS]  := "2"
	EndIF
Next
ConOut("Fim  : "+Time())

If __lSX8
	ConfirmSX8()
Endif

End Transaction

cFilAnt := cFlBkp

RestArea(aArea)
RestArea(aAreaSA1)
RestArea(aAreaSUA)
RestArea(aAreaSC5)

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  º  GERAPED º Autor º LUIZ EDUARDO F.C.  º Data ³  31/10/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³ GERA PEDIDO DE VENDA AUTOMATICO CONFORME A OCORRENCIA      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                              `
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION GERAPED( aGerPV )

Local cNumSC5       := ""
Local cMay          := ""
Local cCliente		:= ""
Local cLojaCli		:= ""
Local cItemPc       := "00"
Local aCabPv	    := {}
Local aItemPV       := {}
Local aItemSC6      := {}
Local lCredito		:= .T.
Local lEstoque		:= .T.
Local lAvCred		:= .F.
Local lAvEst		:= .F.
Local lLiber		:= .T.
Local lTransf    	:= .F.
Local lRetEnv		:= .F.
Local aArea		    := GetArea()
Local aAreaSA1      := SA1->(GetArea())
Local aAreaSC5      := SC5->(GetArea())
Local aAreaSC6      := SC6->(GetArea())
Local aAreaSB2      := SB2->(GetArea())
Local cTes          := ""

//#AFD20180615.BN
Local lRet := .F.
Local aTitulos := {}
Local aItChamado := {}
Local cHistorico := "BAIXA REALIZADA PELA COMPENSAÇÃO DE NCC"
Local nTotalPed := 0
Local cVendSac := Posicione('SA3',7,xFilial('SA3')+__cUserID,'A3_COD')
Local cObs := "" //Observação do pedido de venda
Local lLiberado := .F. //Efetua o controle do agendamento
Local lAgend := .T.
Local aGerSC := {} //Array para geração de SC, para itens sem saldo

Local aHeadPed := {}
Local aItensPed := {}
Local aGerados := {}

Local lOK := .F.

private aTermAgend := {}
Private aTerRet := {}
Private dDataAgTerm := ctod("//")

Private lMSHelpAuto := .T.
Private lMsErroAuto := .F.

Private _nFrete := 0 		//AFD26072018.N
Private _nDespesa := 0 		//AFD26072018.N
Private _lFretDesp := .F.	//AFD26072018.N

//Se o Usuario loggado não tiver cadastro de vendedor, atribui o codigo do vendedor SAC.
if empty(alltrim(cVendSac))
	cVendSac := getmv("KH_VENDSAC", .F., "000537") //Vendedor padrão SAC
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BUSCA AS INFORMACOES DO CLIENTE PARA A GERACAO DO ORCAMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("Z01")
DbSetOrder(1)
DbSeek(xFilial("Z01") + aGerPV[2,n01TIPO])

//#AFD20180615.BN
if Z01->Z01_TPPEDI=="N" .and. Z01->Z01_XBXNCC == '1'
	
	SA1->( DbSetOrder(1) )
	SA1->( DbSeek(xFilial("SA1") + M->UC_CHAVE) )
	cCliente := SA1->A1_COD
	cLojaCli := SA1->A1_LOJA
	
	//#AFD20180420.bn
	//Verifica se o cliente contém pendencia financeira
	if SA1->A1_01PEDFI == '1'
		cMsgPend := "Foi identificado que o cliente "+ SA1->A1_COD +" , Possui pendencia Financeira." +chr(13)+chr(10)
		cMsgPend += "Não sera possivel gerar o pedido de venda." +chr(13)+chr(10)
		MsgAlert(cMsgPend,"Atenção")
		
		Return .F.
	else
		
		//1° Verifico se o cliente possue credito para a geração da replica
		FwMsgRun( ,{|| lRet := foundCred(@nTotalPed, aGerPV, cCliente, cLojaCli, @aTitulos, @aItChamado, @cObs) }, , "Analisando creditos do cliente , Por Favor Aguarde..." )
		
		if !lRet
			Return .F.
		endif
		
		lRet := fProdFL(aGerPV)
		
		if !lRet
			Return .F.
		endif
		
	endif
	//#AFD20180420.en
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TRATAMENTO PARA CLIENTES FORA DO ESTADO NAO CONTRIBUINTES - LUIZ EDUARDO F.C. - 12.01.2018 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ALLTRIM(SA1->A1_EST) <> "SP"
		IF SA1->A1_CONTRIB == "2"
			cTes := Z01->Z01_TESFOR
		Else
			cTes := Z01->Z01_TES
		EndIF
	Else
		cTes := Z01->Z01_TES
	EndIF
	
	//#AFD20180615.EN
elseIf Z01->Z01_TPPEDI=="N"
	
	SA1->( DbSetOrder(1) )
	SA1->( DbSeek(xFilial("SA1") + M->UC_CHAVE) )
	cCliente := SA1->A1_COD
	cLojaCli := SA1->A1_LOJA
	
	//#AFD20180420.bn
	//Verifica se o cliente contém pendencia financeira
	if SA1->A1_01PEDFI == '1'
		cMsgPend := "Foi identificado que o cliente "+ SA1->A1_COD +" , Possui pendencia Financeira." +chr(13)+chr(10)
		cMsgPend += "Não sera possivel gerar o pedido de venda." +chr(13)+chr(10)
		MsgAlert(cMsgPend,"Atenção")
		
		Return .F.
	endif
	//#AFD20180420.en
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TRATAMENTO PARA CLIENTES FORA DO ESTADO NAO CONTRIBUINTES - LUIZ EDUARDO F.C. - 12.01.2018 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ALLTRIM(SA1->A1_EST) <> "SP"
		IF SA1->A1_CONTRIB == "2"
			cTes := Z01->Z01_TESFOR
		Else
			cTes := Z01->Z01_TES
		EndIF
	Else
		cTes := Z01->Z01_TES
	EndIF
	
Else
	
	SB1->( DbSetOrder(1) )
	SB1->( DbSeek(xFilial("SB1") + AvKey(aGerPV[2,nPRODUTO],"B1_COD") ) )
	cCliente := SB1->B1_PROC
	cLojaCli := SB1->B1_LOJPROC
	
Endif

//cNumSC5 := GetSxeNum("SC5","C5_NUM")//#AFD20180420.n - #CMG20180612.o
//			{"C5_NUM"   	, cNumSC5							,Nil},;//#AFD20180615.O
aCabPV:= {;
{"C5_FILIAL" 	, xFilial("SC5") 	        		,Nil},; 	// Filial
{"C5_TIPO" 		, IF(Z01->Z01_TPPEDI=="N","N","B")	,Nil},; 	// Tipo de pedido
{"C5_CLIENTE"	, cCliente 							,Nil},; 	// Codigo do cliente
{"C5_LOJACLI"	, cLojaCli   						,Nil},; 	// Loja do cliente
{"C5_CONDPAG"	, ALLTRIM(Z01->Z01_CONDPG)			,Nil},; 	// Condicao de Pagamento
{"C5_EMISSAO"	, dDataBase							,Nil},; 	// Data de emissao
{"C5_TIPOCLI"	, SA1->A1_TIPO						,Nil},; 	// Tipo do Cliente
{"C5_01PEDMO"	, "2"								,Nil},; 	// Tipo do Cliente
{"C5_01TPOP"	, "1"								,Nil},; 	// Tipo de Operacao 2 = Transferencia
{"C5_TRANSP"	, ALLTRIM(Z01->Z01_TRANSP)			,Nil},; 	// Transportadora
{"C5_01SAC"		, M->UC_CODIGO						,Nil},; 	// Transportadora
{"C5_MOEDA"  	, 1        							,Nil},;	 	// Moeda
{"C5_TPCARGA " 	, "1"      							,Nil},;		// Flag para montar carga
{"C5_VEND1"		, cVendSac							,Nil},;	 	// Vendedor SAC
{"C5_XCONPED"	, "2"								,Nil},;     // Conferencia do caixa
{"C5_FRETE"		, iif(_lFretDesp .and. _nFrete > 0, _nFrete, 0)		,Nil},;  //Valor Frete   	//AFD26072018.BN
{"C5_DESPESA"	, iif(_lFretDesp .and. _nDespesa > 0, _nDespesa, 0)	,Nil}}	 //Valor Despesas	//AFD26072018.BN

For nX := 2 To Len(aGerPV)
	
	cItemPC := Soma1(cItemPc)
	
	aItemSC6	:= {;
	{"C6_ITEM"   	, cItemPc	    																	,Nil},; 	// Numero do Item no Pedido
	{"C6_CLI"    	, cCliente																			,Nil},; 	// Cliente
	{"C6_LOJA"   	, cLojaCli  																		,Nil},; 	// Loja do Cliente
	{"C6_ENTREG" 	, dDataBase    																		,Nil},; 	// Data da Entrega
	{"C6_PRODUTO"	, aGerPV[nX,nPRODUTO]																,Nil},; 	// Codigo do Produto
	{"C6_QTDVEN" 	, aGerPV[nX,n01QTDVE]																,Nil},; 	// Quantidade Vendida
	{"C6_PRUNIT" 	, aGerPV[nX,n01PRCVE]																,Nil},; 	// Preco Unitario Liquido
	{"C6_PRCVEN" 	, aGerPV[nX,n01PRCVE]																,Nil},; 	// Preco Unitario Liquido
	{"C6_VALOR"  	, aGerPV[nX,n01QTDVE] * aGerPV[nX,n01PRCVE]											,Nil},; 	// Valor Total do Item
	{"C6_TES"		, ALLTRIM(cTes)															   			,Nil},; 	// TES
	{"C6_QTDLIB"	, aGerPV[nX,n01QTDVE]																,"AlwaysTrue()"},; 	// Quantidade liberada
	{"C6_LOCAL"  	, ALLTRIM(Z01->Z01_LOCAL)															,Nil}}// armazem de saido
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE ECISTE REGISTRO NO SB2, SE NAO EXISTIR CRIA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SB2")
	SB2->(DbGoTop())
	SB2->(DbSetOrder(1))
	IF !(SB2->(DbSeek(xFilial("SB2") + aGerPV[nX,nPRODUTO] + ALLTRIM(POSICIONE("Z01",1,XFILIAL("Z01") + aGerPV[nX,n01TIPO], "Z01_LOCAL ")))))
		CriaSB2(aGerPV[nX,nPRODUTO],ALLTRIM(POSICIONE("Z01",1,XFILIAL("Z01") + aGerPV[nX,n01TIPO], "Z01_LOCAL ")))
	EndIF
	
	Aadd(aItemPv,aClone(aItemSC6))
Next

MsExecAuto({|x,y,z| mata410(x,y,z)},aCabPV,aItemPv,3)

If lMsErroAuto
	MostraErro()
	Return(.F.)
Else
	ConFirmSX8()//#AFD20180615.N
	
	cNumSC5 := SC5->C5_NUM
	cNumSAC := SC5->C5_01SAC
	
	aAdd(aHeadPed,	{"",;				//STATUS
	SC5->C5_NUM,;		//PEDIDO
	SC5->C5_CLIENTE,;	//CLIENTE
	SC5->C5_LOJACLI,;	//LOJA
	Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"),;	//NOME CLIENTE
	/* EMISSAO */,;		//EMISSAO
	SC5->C5_MSFIL,;		//FILIAL
	"",;				//DESC. FILIAL
	"",;				//TROCA?
	"",;				//CEP
	"",;				//VENDEDOR
	0})
	
	MsgInfo("Pedido criado com sucesso. Número : " + cNumSC5 + " - Filial : " + cFilAnt + " Ocorrencia: "+Posicione("SU9",1,xFilial("SU9")+Alltrim(aGerPV[1]),"U9_DESC"),"Atenção")
	
	if !(empty(alltrim(cOBS)))
		SC5->(RecLock("SC5",.F.))
		MSMM(,TamSx3("C5_XCODOBS") [1],,cOBS,1,,,"SC5","C5_XCODOBS")
		SC5->(MsUnlock())
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a liberacao do pedido sem avaliacao de credito e estoque. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+cNumSC5)
	
	aItensPed := {}
	
	While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cNumSC5
		
		//Itens do Pedido de venda
		aAdd(aItensPed,{"",;				//STATUS
		SC6->C6_ITEM,;		//ITEM
		SC6->C6_PRODUTO,;	//PRODUTO
		"",;				//DESCRICAO
		SC6->C6_QTDVEN,;	//QTD. VENDA
		0,;					//VALOR ITEM
		SC6->C6_LOCAL,;		//LOCAL
		SC6->C6_ENTREG,;	//ENTREGA
		0,;					//QTD. ESTOQUE
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		""})
		
		_nSaldo := 0 //Populado no Retorno da função GetEnd()
		_cUsados := "" //Endereços utilizados
		
		cEndereco := u_getEnd(SC6->C6_PRODUTO, SC6->C6_LOCAL, SC6->C6_QTDVEN, @_cUsados, @_nSaldo)
		
		if _nSaldo > 0
			if Localiza(SC6->C6_PRODUTO)
				
				recLock("SC6",.F.)
				SC6->C6_LOCALIZ := cEndereco
				msUnlock()
				
				lLiberado := u_LibEst(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN,_nSaldo)
				if lLiberado .and. lAgend
					lAgend := .T.
				else
					lAgend := .F.
				endif
			else
				lLiberado := u_LibEst(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN,_nSaldo)
				if lLiberado .and. lAgend
					lAgend := .T.
				else
					lAgend := .F.
				endif
			endif
		else
			//Guardo os itens sem saldo para gerar solicitação de compras
			//{Produto , Quantidade}
			lAgend := .F.
			cEncomeda := Posicione("SB1", 1, xFilial("SB1") + SC6->C6_PRODUTO, "B1_XENCOME")
			if cEncomeda == "2"
				aAdd(aGerSC,{SC6->C6_NUM,SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_QTDVEN})
			endif
		endif
		
		SC6->(DbSkip())
	EndDo
	
	//Liberado para o agendamento
	if lAgend
		//Verifica se existe termo retira para o pedido
		fTerRet(cNumSAC)//C5_01SAC
		
		//Chama a tela de agendamento se todos os itens estiverem liberados ..
		fAgend(aHeadPed,aItensPed)
	endif
	
	//Removida geração da geração de compras
	/*
	if len(aGerSC) > 0
	if msgYesNo("Identificamos que existe itens no PV ("+ cNumSC5 +") que não possuem Estoque."+ ENTER +"Deseja gerar solicitação de comprar ?")
	//Gerar solicitação de compras
	MsgRun("Gerando solicitação de compras...","Aguarde", {|| U_KHGERSC(aGerSC,@aGerados) })
	
	cMsgGer := "Solicitações de compras geradas:" + ENTER
	
	for nx := 1 to len(aGerados)
	cMsgGer += "Numero: "+ aGerados[nx][1] + ENTER
	next nx
	
	MsgInfo(cMsgGer,"SC's GERADAS")
	endif
	endif
	*/
	
	For nT:=1 To len(aCols)
		IF (aCols[nT,n01PEDID] == "P") .And. (aCols[nT,nOCORREN] == aGerPV[1])
			aCols[nT,n01PEDID] := cNumSC5
			aCols[nT,nSTATUS]  := "2"
		EndIF
	Next
	
	//#AFD20180615.BN
	
	if lRet
		
		//Grava o numero do pedido da Replica no Titulo (E1_PEDIDO)
		dbSelectArea("SE1")
		
		if len(aTitulos) > 1
			
			for nx := 1 to len(aTitulos)
				dbGoTo(aTitulos[nx])
				
				if SE1->E1_SALDO >= nTotalPed
					
					FwMsgRun( ,{|| lOK := BXTITAPAG(SE1->E1_NUM, SE1->E1_PREFIXO, cHistorico, nTotalPed, 3) }, , "Realizando compensação do NCC "+ SE1->E1_NUM +" , Por Favor Aguarde..." )
					
					if lOK
						atuSE1(SE1->E1_NUM, SE1->E1_PREFIXO, cNumSC5)
						nTotalPed -= nTotalPed
					endif
					
				Else
					
					nTotalPed -= SE1->E1_SALDO
					
					FwMsgRun( ,{|| lOK := BXTITAPAG(SE1->E1_NUM, SE1->E1_PREFIXO, cHistorico, SE1->E1_SALDO, 3) }, , "Realizando compensação do NCC "+ SE1->E1_NUM +" , Por Favor Aguarde..." )
					
					if lOK
						atuSE1(SE1->E1_NUM, SE1->E1_PREFIXO, cNumSC5)
					else
						nTotalPed += SE1->E1_SALDO
					endif
					
				endif
				
				if nTotalPed <= 0
					exit
				endif
				
			next nx
			
		else
			
			dbGoTo(aTitulos[1])
			
			FwMsgRun( ,{|| lOK := BXTITAPAG(SE1->E1_NUM, SE1->E1_PREFIXO, cHistorico, nTotalPed, 3) }, , "Realizando compensação do NCC , Por Favor Aguarde..." )
			
			if lOK
				atuSE1(SE1->E1_NUM, SE1->E1_PREFIXO, cNumSC5)
			endif
			
		endif
		
	endif
	
	//#AFD20180615.EN
	
EndIF

RestArea(aArea)
RestArea(aAreaSA1)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSB2)

RETURN()

//--------------------------------------------------------------------------|
//	Funtion - foundCred() -> //Verifica se o cliente possui credito 	   	|
//	Uso - Komfort House													   	|
//  By Alexis Duarte - 15/06/2018  											|
//--------------------------------------------------------------------------|
Static Function foundCred(nTotal, aGerPV, cCliente, cLojaCli, aTitulos, aItChamado, cObs)

Local lRet := .F.
Local cQuery := ""
Local cAlias := getNextAlias()
Local nValPed := 0
Local cPedOri := "" 	//AFD26072018.BN

Default cObs := ""

cQuery := "SELECT SUM(E1_SALDO) AS SALDO FROM "+ retSqlName("SE1")
cQuery += "	WHERE E1_FILIAL = ''"
cQuery += "	AND E1_CLIENTE = '"+cCliente+"'"
cQuery += "	AND E1_LOJA = '"+cLojaCli+"'"
cQuery += "	AND E1_PREFIXO IN ('SAC','MAN','CLS')"
cQuery += "	AND E1_NUM IN ("
cQuery += "					SELECT DISTINCT(UD_XNUMTIT) "
cQuery += "					FROM "+ retSqlName("SUD")
cQuery += "					WHERE UD_XNUMTIT <> ' '"
cQuery += "					AND UD_CODIGO = '"+ M->UC_CODIGO +"'"
cQuery += "					AND D_E_L_E_T_ = ' '"
cQuery += "					)"
cQuery += "	AND E1_TIPO = 'NCC'"
cQuery += "	AND E1_SALDO > 0"
cQuery += "	AND D_E_L_E_T_ = ' '"

plsQuery(cQuery,cAlias)

(cAlias)->(dbgotop())
if (cAlias)->(!eof())
	
	for nx := 2 to len(aGerPV)
		if vldTpAcao(aGerPV[nx][n01TIPO])
			nValPed += (aGerPV[nx][n01QTDVE] * aGerPV[nx][n01PRCVE])
			aAdd(aItChamado,(aGerPV[nx][n01QTDVE] * aGerPV[nx][n01PRCVE]))
			
			cObs += aGerPV[nx][nObs] +chr(13)+chr(10)
		endif
	next nx
	
	if (cAlias)->SALDO >= nValPed
		nTotal := nValPed
		lRet := .T.
	else
		msgInfo("O Cliente "+ cCliente +" não possui crédito para emissão da réplica.","ATENÇÃO")
	endif
	
endif

(cAlias)->(dbclosearea())

//---------------------------------------------------------------------------------------------------

cAlias := getNextAlias()

cQuery := "SELECT R_E_C_N_O_ as RECNOSE1 FROM "+ retSqlName("SE1")
cQuery += "	WHERE E1_FILIAL = ''"
cQuery += "	AND E1_CLIENTE = '"+cCliente+"'"
cQuery += "	AND E1_LOJA = '"+cLojaCli+"'"
cQuery += "	AND E1_PREFIXO IN ('SAC','MAN','CLS')"
cQuery += "	AND E1_NUM IN ("
cQuery += "					SELECT DISTINCT(UD_XNUMTIT) "
cQuery += "					FROM "+ retSqlName("SUD")
cQuery += "					WHERE UD_XNUMTIT <> ' '"
cQuery += "					AND UD_CODIGO = '"+ M->UC_CODIGO +"'"
cQuery += "					AND D_E_L_E_T_ = ' '"
cQuery += "					)"
cQuery += "	AND E1_TIPO = 'NCC'"
cQuery += "	AND E1_SALDO > 0"
cQuery += "	AND D_E_L_E_T_ = ' '"
cQuery += "	ORDER BY E1_VALOR"

//   MemoWrite( "C:\spool\tmkmok02.txt", cQuery )

plsQuery(cQuery,cAlias)

(cAlias)->(dbgotop())
while (cAlias)->(!eof())
	
	aAdd(aTitulos,(cAlias)->RECNOSE1)
	
	(cAlias)->(dbSkip())
end

(cAlias)->(dbclosearea())

//AFD26072018.BN
if lRet .AND. len(aTitulos) > 0
	
	dbSelectArea("SE1")
	dbGoTo(aTitulos[1])
	
	cPedOri := SE1->E1_XPEDORI
	
	if !empty(alltrim(cPedOri))
		
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		
		if SC5->(dbSeek(xFilial("SC5")+cPedOri))
			_nFrete := SC5->C5_FRETE
			_nDespesa := SC5->C5_DESPESA
		endif
		
		if (_nFrete + _nDespesa) > 0
			if mSgYesNo("O Pedido de origem contém Frete ou despesa, deseja replicar essas informações para a réplica ?","REPLICAR FRETES E DESPESAS")
				nTotal += (_nFrete + _nDespesa)
				_lFretDesp := .T.
			endif
		else
			//Incluida função para geração de replicas de pedidos do NetGera, Remover apos lançamento dos pedidos..
			xFreteDesp(@_nFrete, @_nDespesa)
			if (_nFrete + _nDespesa) > 0
				nTotal += (_nFrete + _nDespesa)
				_lFretDesp := .T.
			endif
		endif
		
	endif
	
endif
//AFD26072018.EN

Return lRet

Static Function xFreteDesp(_nFrete, _nDespesas)

Local oBtConfirm
Local oFrete
Local oGetDespesas
Local oGetFrete
Local oSayDespesas
Local oSayFrete

Static oDlgFrete

DEFINE MSDIALOG oDlgFrete TITLE "Frete e Despesas" FROM 000, 000  TO 120, 300 COLORS 0, 16777215 PIXEL

@ 001, 002 GROUP oFrete TO 058, 147 PROMPT " Frete e Despesas " OF oDlgFrete COLOR 0, 16777215 PIXEL
@ 013, 007 SAY oSayFrete PROMPT "Valor Frete" SIZE 042, 007 OF oDlgFrete COLORS 0, 16777215 PIXEL
@ 027, 006 SAY oSayDespesas PROMPT "Valor Despesas" SIZE 042, 007 OF oDlgFrete COLORS 0, 16777215 PIXEL
@ 011, 046 MSGET oGetFrete VAR _nFrete SIZE 060, 010 OF oDlgFrete PICTURE "@E 999,999,999.99" COLORS 0, 16777215 PIXEL
@ 025, 046 MSGET oGetDespesas VAR _nDespesas SIZE 060, 010 OF oDlgFrete PICTURE "@E 999,999,999.99" COLORS 0, 16777215 PIXEL
@ 041, 086 BUTTON oBtConfirm PROMPT "Confirmar" SIZE 056, 012 OF oDlgFrete ACTION {|| oDlgFrete:End() } PIXEL

ACTIVATE MSDIALOG oDlgFrete CENTERED

Return .T.

//----------------------------------------------------------|
//	Funtion - vldTpAcao() -> //Valida o tipo de ação 	   	|
//	Uso - Komfort House									   	|
//  By Alexis Duarte - 15/06/2018  							|
//----------------------------------------------------------|
Static Function vldTpAcao(cCodAcao)

Local lRet := .F.
Local aArea := getArea()

dbSelectArea("Z01")
Z01->(dbSetOrder(1))
Z01->(dbgotop())

if dbSeek(xFilial("Z01")+cCodAcao)
	
	if Z01->Z01_XBXNCC == '1'
		lRet := .T.
	endif
	
endif

restArea(aArea)

Return lRet

//--------------------------------------------------------------|
//	Funtion - BXTITAPAG() -> //Realiza a baixa do titulo 	   	|
//	Uso - Komfort House										   	|
//  By Alexis Duarte - 15/06/2018  								|
//--------------------------------------------------------------|
Static Function BXTITAPAG(cNum, cPrefixo, cHistorico, nValor, nOpcao)

Local aBaixa := {}
Local lRet := .T.

Private lMSHelpAuto := .T.
Private lMsErroAuto := .F.

aBaixa := {{"E1_PREFIXO"  ,cPrefixo	              					,Nil},;
{"E1_NUM"      ,cNum            		  					,Nil},;
{"E1_PARCELA"  ,"A "					  					,Nil},;
{"E1_TIPO"     ,"NCC"                  					,Nil},;
{"AUTMOTBX"    ,"BCC"                  					,Nil},;
{"AUTBANCO"    ,"CX1"									,Nil},;
{"AUTAGENCIA"  ,"00001"									,Nil},;
{"AUTCONTA"    ,"0000000001"					 			,Nil},;
{"AUTDTBAIXA"  ,dDataBase              					,Nil},;
{"AUTDTCREDITO",dDataBase              					,Nil},;
{"AUTHIST"     ,cHistorico	          					,Nil},;
{"AUTJUROS"    ,0                      					,Nil},;
{"AUTVALREC"   ,nValor                 					,Nil}}

MSExecAuto({|x,y| Fina070(x,y)},aBaixa,nOpcao)

If lMsErroAuto
	MostraErro()
	lRet := .F.
else
	
	apMsgInfo("Realizada Compensação do Titulo "+ cNum,"SUCCESS")
	
endif

Return lRet

//--------------------------------------------------------------|
//	Funtion - atuSE1() -> //Grava o numero do pedido no Titulo 	|
//	Uso - Komfort House										   	|
//  By Alexis Duarte - 15/06/2018  								|
//--------------------------------------------------------------|
Static Function atuSE1(cNum, cPrefixo, cNumSC5)

Local aArea := getArea()

dbSelectArea("SE1")
SE1->(dbSetOrder(1)) //E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_

if SE1->(dbSeek(xFilial() + cPrefixo + cNum + "A " + "NCC"))
	SE1->(recLock("SE1",.F.))
	SE1->E1_PEDIDO := cNumSC5
	SE1->(msUnlock())
endif

restArea(aArea)

Return

Static function AtuPedOri(_filial, _pedOrigem, _numSac)

Local aArea := getArea()

dbSelectArea("SC5")
SC5->(dbSetOrder(1))
SC5->(dbGoTop())

if SC5->(dbSeek(xFilial()+_pedOrigem))
	recLock("SC5",.F.)
	SC5->C5_01SAC :=_numSac
	msUnlock()
else
	msgAlert("Pedido "+ _pedOrigem +" não foi localizado!","ATENÇÃO")
endif

restArea(aArea)

Return

//--------------------------------------------------------------
/*/{Protheus.doc}
Description => Tela de agendamento do pedido de venda, com dados do pedido e cliente.
@param: aCols -  Parameter Description: acols com o cabeçalho contendo as informaões do pedido de venda
@return: NULL - Return Description: Nenhum
@author - Alexis Duarte
@since 12/09/2018
/*/
//--------------------------------------------------------------
Static Function fAgend(aCols,aItens)

Local cTitulo := "Agendamento de Pedido"
Local cCliente   := aCols[1][3]
Local cLoja      := aCols[1][4]
Local oGroup1
Local oGroup2
Local oGroup3
Local oGroup4
Local oBtnAgendar
Local oBtnAltCli
Local oBtnSair
Local oGetBairro
Local cBairro := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_BAIRRO")
Local oGetCidade
Local oGetDtAgend
Local dGetDtAgend := dDataBase
Local oGetEstado
Local oGetRua
Local cRua := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_END")
Local cDDD := '('+ alltrim(Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_DDD")) +') '
Local oGetTel1
Local cTel1 := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_TEL")
Local oGetTel2
Local cTel2 := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_TEL2")
Local oGetTel3
Local cTel3 := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_XTEL3")
Local oSay12
Local oSayBairro
Local oSayCep
Local cCep := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_CEP")
Local oSayCidade
Local cCidade := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_MUN")
Local oSayDtAgend
Local oSayEstado
Local cEstado := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_EST")
Local oSayObs
Local oSayRua
Local oTelefone1
Local oTelefone2
Local oTelefone3

//Informações do pedido de venda
Local oMsgPed
Local cMsgObsPed := ""

//Informações de entrega
Local oMsgEnt
Local cMsgObsEnt := ""

Local nCont := 0
Local cUsados := ""
Local lGrava := .F.
Local lRet := .F.
Local nx := 0

Static oDlg

fGetMsg(aCols,@cMsgObsPed,@cMsgObsEnt)

Private aCpos := {"A1_END","A1_BAIRRO","A1_EST","A1_CEP", "A1_MUN","A1_DDD","A1_TEL","A1_TEL2","A1_XTEL3","A1_CONTATO","A1_EMAIL","A1_COMPLEM" }
Private cCadastro := "Cadastro de Clientes - Alteração de Cadastro"

//Montagem da Tela
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 530, 390 COLORS 0, 16777215 PIXEL

@ 004, 003 GROUP oGroup1 TO 042, 192 PROMPT " Agendamento do Pedido - " + aCols[1][2] OF oDlg COLOR 0, 16777215 PIXEL
@ 016, 009 SAY oSayObs PROMPT "Deseja agendar todos os itens disponiveis ?" SIZE 110, 007 OF oDlg COLORS 692766, 16777215 PIXEL
@ 029, 010 SAY oSayDtAgend PROMPT "Data do agendamento:" SIZE 056, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 027, 069 MSGET oGetDtAgend VAR dGetDtAgend PICTURE PesqPict("SC6","C6_ENTREG") SIZE 056, 010 OF oDlg  VALID staticCall(AGEND,vldDate,dGetDtAgend) COLORS 0, 16777215 PIXEL
@ 027, 135 BUTTON oBtnAgendar PROMPT "Agendar" SIZE 047, 012 OF oDlg PIXEL

oBtnAgendar:BLCLICKED:= {|| lGrava := .T. , oDlg:End()  }

@ 046, 003 GROUP oGroup2 TO 115, 192 PROMPT " Informações do Cliente - " + alltrim(aCols[1][5])  OF oDlg COLOR 0, 16777215 PIXEL

//Rua
@ 054, 010 SAY oSayRua PROMPT "Rua:" SIZE 015, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 054, 024 SAY oGetRua PROMPT cRua SIZE 162, 007 OF oDlg COLORS 0, 16777215 PIXEL

//Bairro
@ 061, 010 SAY oSayBairro PROMPT "Bairro:" SIZE 018, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 061, 027 SAY oGetBairro PROMPT cBairro SIZE 089, 007 OF oDlg COLORS 0, 16777215 PIXEL

//Cidade
@ 069, 010 SAY oSayCidade PROMPT "Cidade:" SIZE 021, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 069, 030 SAY oGetCidade PROMPT cCidade SIZE 055, 007 OF oDlg COLORS 0, 16777215 PIXEL

//Estado
@ 077, 010 SAY oSayEstado PROMPT "Estado:" SIZE 021, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 077, 031 SAY oGetEstado PROMPT cEstado SIZE 015, 007 OF oDlg COLORS 0, 16777215 PIXEL

//Cep
@ 085, 010 SAY oSayCep PROMPT "CEP:" SIZE 014, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 085, 024 SAY oSay12 PROMPT cCep SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL

//Telefone 1
@ 092, 010 SAY oTelefone1 PROMPT "Telefone 1:" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 092, 039 SAY oGetTel1 PROMPT cDDD + cTel1 SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL

//Telefone 2
@ 099, 010 SAY oTelefone2 PROMPT "Telefone 2:" SIZE 030, 007 OF oGroup2 COLORS 0, 16777215 PIXEL
@ 099, 039 SAY oGetTel2 PROMPT cDDD + cTel2 SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL

//Telefone 3
@ 107, 010 SAY oTelefone3 PROMPT "Telefone 3:" SIZE 030, 007 OF oGroup2 COLORS 0, 16777215 PIXEL
@ 107, 039 SAY oGetTel3 PROMPT cDDD + cTel3 SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL

//Botao com a ação para alterar informações do cadastro do cliente
@ 099, 124 BUTTON oBtnAltCli PROMPT "Alterar dados do Cliente" SIZE 064, 012 OF oDlg PIXEL
oBtnAltCli:BLCLICKED:= {|| AxAltera("SA1",SA1->(Recno()),4,,aCpos) }

//Informações do pedido de venda
@ 118, 003 GROUP oGroup3 TO 172, 192 PROMPT " Observações do Pedido de venda " OF oDlg COLOR 0, 16777215 PIXEL
@ 125, 006 GET oMsgPed VAR cMsgObsPed MEMO SIZE 182, 044 PIXEL OF oDlg

//Informações de entrega, informadas pelo SAC
@ 176, 003 GROUP oGroup4 TO 243, 192 PROMPT " Observações de Entrega " OF oDlg COLOR 0, 16777215 PIXEL
@ 184, 006 GET oMsgEnt VAR cMsgObsEnt MEMO SIZE 182, 057 PIXEL OF oDlg

//Botão Sair
@ 246, 004 BUTTON oBtnSair PROMPT "Sair" SIZE 187, 016 OF oDlg ACTION {|| oDlg:End() } PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

if lGrava
	
	fGravaAll()
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	
	for nx := 1 To Len(aItens)
		if SC6->(DbSeek(xFilial("SC6") + aCols[1][2] + aItens[nx][2] + aItens[nx][3])) //Pedido + Item + Produto
			
			if SC6->C6_QTDEMP < 0
				RecLock("SC6",.F.)
				SC6->C6_QTDEMP := 0
				MsUnlock()
			endif
			
			fAtuMsg(aCols,@cMsgObsPed,@cMsgObsEnt)
			
			RecLock("SC6",.F.)
			SC6->C6_ENTREG  := dGetDtAgend
			SC6->C6_XUSRAGE := cUserName
			SC6->C6_01AGEND := "1"
			MsUnlock()
			
			U_SYTMOV15(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,"3")
			dDataAgTerm := dGetDtAgend
		endif
		
	next nx
	
	AlterDtAgend()
	
endif

Return

//Verifica se existe Termo Retira para o pedido gerado
Static Function fTerRet(cNumSAC)//C5_01SAC

Local cQuery := ""
Local cAlias1 := ""
Local _cAtend := cNumSAC

aTerRet := {}

cQuery := "SELECT ZK0_COD, ZK0_PROD, ZK0_DESCRI, ZK0_NUMSAC, ZK0_CLI, ZK0_LJCLI, ZK0_DTAGEN, ZK0_NUMSAC, ZK0_STATUS, ZK0_CARGA"
cQuery += " FROM "+RetSqlName("ZK0")"
cQuery += " WHERE ZK0_NUMSAC = '"+cNumSAC+"'"
cQuery += " AND D_E_L_E_T_ = ' '"

cAlias1 := getNextAlias()

plsQuery(cQuery,cAlias1)

while (cAlias1)->(!eof())
	
	aAdd(aTerRet,{;
	(cAlias1)->ZK0_COD,;
	(cAlias1)->ZK0_PROD,;
	(cAlias1)->ZK0_DESCRI,;
	(cAlias1)->ZK0_NUMSAC,;
	(cAlias1)->ZK0_CLI,;
	(cAlias1)->ZK0_LJCLI,;
	(cAlias1)->ZK0_DTAGEN,;
	(cAlias1)->ZK0_STATUS,;
	(cAlias1)->ZK0_CARGA})
	
	(cAlias1)->(dbSkip())
end

(cAlias1)->(dbCloseArea())

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fGravaAll
Description

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
Static Function fGravaAll()

Local nx

aTermAgend := {}

for nx := 1 to len(aTerRet)
	if aTerRet[nx][8] <> '3'
		aAdd(aTermAgend,{aTerRet[nx][1],aTerRet[nx][2],aTerRet[nx][3]})
	endif
next nx

if len(aTermAgend) > 0
	msgInfo("Todos os termos retira pendentes, serão agendados juntamente com o pedido.","ATENÇÃO")
endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} AlterDtAgend
Description

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
Static Function AlterDtAgend()

Local aArea := getArea()
Local nx

dbSelectArea("ZK0")
ZK0->(dbSetOrder(1))

for nx := 1 to len(aTermAgend)
	if ZK0->(dbSeek(xFilial("ZK0")+aTermAgend[nx][1]))
		if ZK0->ZK0_STATUS <> '3'
			RecLock("ZK0",.F.)
			ZK0->ZK0_DTAGEN := dDataAgTerm
			msUnLock()
		endif
	endif
next nx

restArea(aArea)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fGetMsg
Description //carrega as observações do pedido de venda
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/09/2018
/*/
//--------------------------------------------------------------
Static Function fGetMsg(acols,cMsgObsPed,cMsgObsEnt)

Local aArea := getArea()

dbSelectArea("SUA")
dbSetOrder(8)

DbSelectArea("SC5")
SC5->(DbSetOrder(1))

if SUA->(dbseek(aCols[1][7]+aCols[1][2]))
	cMsgObsPed := MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1],,,3)
else
	if SC5->(DbSeek(xFilial("SC5") + aCols[1][2]))
		cMsgObsPed := MSMM(SC5->C5_XCODOBS,TamSx3("C5_XCODOBS")[1],,,3)
	else
		cMsgObsPed := ""
	endif
endif

SC5->(DbSeek(xFilial("SC5") + aCols[1][2]))
cMsgObsEnt := MSMM(SC5->C5_XOBSENT,TamSx3("C5_XCODOBS")[1],,,3)

cMsgUser :=  alltrim(LogUserName()) + ' - ' + dtoc(date()) + ' - ' + time() + ENTER
cMsgUser += replicate('-',60) + ENTER

if empty(alltrim(cMsgObsEnt))
	cMsgObsEnt := cMsgUser + cMsgObsEnt
else
	cMsgObsEnt := cMsgObsEnt + ENTER + ENTER + cMsgUser
endif

restArea(aArea)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fAtuMsg
Description //Atualiza as observações do pedido de venda e observações de entrega
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/09/2018
/*/
//--------------------------------------------------------------
Static Function fAtuMsg(aCols,cMsgObsPed,cMsgObsEnt)

Local aArea := getArea()
Local cTerRet := ""

DBSELECTAREA("SUA")
SUA->(DBSETORDER(8))

if SUA->(DBSEEK(aCols[1][7]+aCols[1][2]))
	MSMM(,TamSx3("UA_CODOBS")[1],,cMsgObsPed,1,,,"SUA","UA_CODOBS")
endif

DbSelectArea("SC5")
SC5->(DbSetOrder(1))

if SC5->(DbSeek(xFilial("SC5") + aCols[1][2]))
	MSMM(,TamSx3("C5_XCODOBS")[1],,cMsgObsPed,1,,,"SC5","C5_XCODOBS")
	
	if len(aTermAgend) > 0
		cTerRet := ENTER +ENTER + "**OBSERVAÇÃO: TERMO RETIRA N°:"+aTermAgend[1][1]+" - RETIRAR OS ITENS ABAIXO NO CLIENTE;" + ENTER
		
		for nx := 1 to len(aTermAgend)
			cTerRet += cValToChar(nx) +"-PRODUTO: "+ aTermAgend[nx][2] + ENTER
			cTerRet += cValToChar(nx) +"-DESCRIÇÃO: "+ aTermAgend[nx][3] + ENTER
		next
		
		MSMM(,TamSx3("C5_XCODOBS")[1],,cMsgObsEnt+cTerRet,1,,,"SC5","C5_XOBSENT")
	else
		MSMM(,TamSx3("C5_XCODOBS")[1],,cMsgObsEnt,1,,,"SC5","C5_XOBSENT")
	endif
	
endif

restArea(aArea)

Return

Static Function fProdFL(aGerPV)

Local nx := 0
Local lRet := .T.
Local nSaldoB2 := 0
Local nSaldoC6 := 0

For nx := 2 to len(aGerPV)
	if lRet
		cForaLinha := Posicione('SB1',1,xFilial('SB1')+aGerPV[nx][nPRODUTO],'B1_01FORAL')
		
		if cForaLinha == "F"
			
			cQuery := "SELECT SUM(B2_QATU) AS SALDO_ESTOQUE"
			cQuery += " FROM "+retSqlName("SB2")
			cQuery += " WHERE B2_COD = '"+aGerPV[nx][nPRODUTO]+"'"
			cQuery += " AND B2_LOCAL = '"+ alltrim(posicione("Z01",1,xFilial("Z01") + aGerPV[nx][n01TIPO], "Z01_LOCAL")) +"'" // Retorna o armazem cadastrado no tipo de ação
			cQuery += " AND B2_QATU > 0"
			cQuery += " AND B2_FILIAL = '0101'"
			cQuery += " AND D_E_L_E_T_ = ' '"
			cQuery += " GROUP BY B2_COD"
			
			cAliasSB2 := getNextAlias()
			plsQuery(cQuery,cAliasSB2)
			
			if (cAliasSB2)->(!eof())
				nSaldoB2 := (cAliasSB2)->SALDO_ESTOQUE
			else
				nSaldoB2 := 0
			endif
			
			(cAliasSB2)->(dbclosearea())
			
			cQuery := "SELECT SUM(C6_QTDVEN) AS PEDIDOS_VENDA"
			cQuery += " FROM "+retSqlName("SC6")
			cQuery += " WHERE C6_PRODUTO = '"+aGerPV[nx][nPRODUTO]+"'"
			cQuery += " AND C6_LOCAL = '"+ alltrim(posicione("Z01",1,xFilial("Z01") + aGerPV[nx][n01TIPO], "Z01_LOCAL")) +"'" // Retorna o armazem cadastrado no tipo de ação
			cQuery += " AND C6_CLI != '000001'"
			cQuery += " AND C6_NOTA = ''"
			cQuery += " AND C6_BLQ = ''"
			cQuery += " AND D_E_L_E_T_ = ' '"
			
			cAliasSC6 := getNextAlias()
			
			plsQuery(cQuery,cAliasSC6)
			
			if (cAliasSC6)->(!eof())
				nSaldoC6 := (cAliasSC6)->PEDIDOS_VENDA
			else
				nSaldoC6 := 0
			endif
			
			(cAliasSC6)->(dbclosearea())
			
			if (nSaldoB2 - nSaldoC6) <= 0
				msgAlert("O produto "+ alltrim(aGerPV[nx][nPRODUTO])+ " é Fora de linha e não possui Saldo!","Atenção")
				lRet := .F.
			endif
		endif
	endif
Next nx

Return lRet