#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SYTMOV07 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  11/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ TELA DE MONITOR DE CLIENTES                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION SYTMOV13()

Local aArea		 := GetArea()
Local aAreaSUA   := SUA->(GetArea())
Local aAreaSA1   := SA1->(GetArea())
Local aAreaAC8   := AC8->(GetArea())
Local aAreaSU5   := SU5->(GetArea())
Local nCodCont   := ""
Local cMay       := ""

DbSelectArea("SU5")
SU5->(DbOrderNickName("SU501SAI"))
IF !SU5->(DbSeek(xFilial("SU5") + M->UA_CLIENTE + M->UA_LOJA))
	If MsgYesNo("Deseja criar um contato (que será utilizado pelo SAC) para este cliente?","Atenção")   		
		Begin Transaction
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ BUSCANDO A NUMERACAO SEQUENCIAL PARA O CODIGO DO CONTATO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SU5")
		SU5->(DbSetOrder(1))
		nCodCont := GetSxeNum("SU5","U5_CODCONT")
		cMay := "SU5"+Alltrim(xFilial("SU5"))+nCodCont
		
		While (MsSeek(xFilial("SU5")+nCodCont) .OR. !MayIUseCode(cMay))
			nCodCont := Soma1(nCodCont,Len(nCodCont))
		EndDo   
		
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ GRAVANDO AS INFORMACOES DO CONTATO - SU5 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SU5->(RecLock("SU5",.T.))
		SU5->U5_FILIAL  := xFilial("SU5")
		SU5->U5_CODCONT := nCodCont
		SU5->U5_CONTAT  := SA1->A1_NOME
		SU5->U5_END     := SA1->A1_END
		SU5->U5_BAIRRO  := SA1->A1_BAIRRO
		SU5->U5_MUN     := SA1->A1_MUN
		SU5->U5_EST     := SA1->A1_EST
		SU5->U5_CEP     := SA1->A1_CEP
		SU5->U5_CODPAIS := SA1->A1_DDI
		SU5->U5_DDD     := SA1->A1_DDD
		SU5->U5_FONE    := SA1->A1_TEL
		SU5->U5_FCOM1   := SA1->A1_TEL2
		SU5->U5_EMAIL   := SA1->A1_EMAIL
		SU5->U5_URL     := SA1->A1_HPAGE
		SU5->U5_ATIVO   := "1" // ATIVO SIM
		SU5->U5_STATUS  := "2" // CADASTRO ATUALIZADO
		SU5->U5_MSBLQL  := "2" // STATUS ATIVO
		SU5->U5_01SAI   := SA1->A1_COD + SA1->A1_LOJA
		SU5->(MsUnLock())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ GRAVANDO AS INFORMACOES NA TABELA DE RELACIONAMENTO DE ENTIDADES - CONTATO X CLIENTE - AC8 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("AC8")
		AC8->(RecLock("AC8",.T.))
		AC8->AC8_FILIAL := xFilial("AC8")
		AC8->AC8_ENTIDA := "SA1"
		AC8->AC8_CODENT := SA1->A1_COD + SA1->A1_LOJA
		AC8->AC8_CODCON := nCodCont
		AC8->(MsUnLock())
		
		End Transaction
		
		ConfirmSX8()		//#RVC20181126.n
		
	EndIF
EndIF

RestArea(aArea)
RestArea(aAreaSUA)
RestArea(aAreaSA1)
RestArea(aAreaAC8)
RestArea(aAreaSU5)

RETURN(M->UA_CLIENTE)                     
