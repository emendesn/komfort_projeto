#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMFATJ01  ºAutor  ³Ellen Santiago      º Data ³  15/05/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job para liberacao dos pedidos com bloqueio de estoque que º±±
±±º          ³ possuem reservas (SC0)                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Komfort House                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function KMFATJ01(_cEmp, _cFil)

Local cAliax 	:= GetNextAlias()
Local aAreaSC6	:=SC6->(GetArea())
Local aAreaSC9	:=SC9->(GetArea())
Local cQuery	:= ""
Local _cInicio	:= Time()
Local cFilBkp	:= cFilAnt
Local nQtdLib	:= 0

Prepare Environment Empresa _cEmp Filial _cFil TABLES "SC0", "SC9", "SC6" MODULO 'FAT' 
RpcSetType(3)

ConOut("Inicio de execucao do Schedule para liberar pedidos com bloqueio de estoque - KMFATE01")


cQuery := " SELECT	C0_TIPO,C0_DOCRES, C0_SOLICIT, C0_FILRES, C0_PRODUTO,C0_LOCAL,C0_QUANT,C0_NUMLOTE,	" + CRLF
cQuery += "			C0_LOTECTL,C0_LOCALIZ,C0_NUMSERI,SC9.R_E_C_N_O_ SC9RECNO, SC6.R_E_C_N_O_ SC6RECNO, " +CRLF
cQuery += " 		C9_PEDIDO, C6_RESERVA,C6_QTDRESE,C9_RESERVA,C6_PRODUTO, C9_QTDRESE, C6_MSFIL,C6_QTDVEN " +CRLF 
cQuery += " FROM "+RetSqlName("SC9")+" SC9 " +CRLF
cQuery += " INNER JOIN "+RetSqlName("SC6")+" SC6 " +CRLF
cQuery += " 	ON C9_PEDIDO = C6_NUM " + CRLF
cQuery += "		AND C9_RESERVA = C6_RESERVA " + CRLF
cQuery += " 	AND SC9.C9_FILIAL   = SC6.C6_FILIAL " +CRLF
cQuery += " INNER JOIN "+RetSqlName("SC0")+" SC0 " +CRLF
cQuery += " 	ON C6_RESERVA = C0_NUM "+ CRLF
cQuery += "	WHERE SC9.D_E_L_E_T_ = ''		" +CRLF
cQuery += "		AND SC6.D_E_L_E_T_ = ''		" +CRLF
cQuery += "		AND SC9.D_E_L_E_T_ = ''		" +CRLF
cQuery += "		AND C9_BLEST IN ('02','03') " +CRLF

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliax, .T., .T.)

dbSelectArea("SC0")
dbSetOrder(1)

dbSelectArea("SC6")
dbSetOrder(1)

dbSelectArea("SC9")
dbSetOrder(1)

(cAliax)->(dbGoTop())
cFilAnt := "0101"
dbSelectArea(cAliax)


While !(cAliax)->(Eof())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Retorna o saldo reservado para o estoque disponivel        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SC0->(DbSeek(xFilial("SC0")+(cAliax)->C6_RESERVA + (cAliax)->C6_PRODUTO))
			a430Reserv({3,(cAliax)->C0_TIPO,(cAliax)->C0_DOCRES,(cAliax)->C0_SOLICIT,(cAliax)->C0_FILRES},;
				(cAliax)->C6_RESERVA,;
				(cAliax)->C0_PRODUTO,;
				(cAliax)->C0_LOCAL,;
				(cAliax)->C0_QUANT,;
				{(cAliax)->C0_NUMLOTE,;
				(cAliax)->C0_LOTECTL,;
				(cAliax)->C0_LOCALIZ,;
				(cAliax)->C0_NUMSERI})
			SC0->(MsUnLock())
		Endif
				
		SC6->(DbGoTo((cAliax)->SC6RECNO))
				
		Begin Transaction 
			nQtdLib := MaLibDoFat((cAliax)->SC6RECNO,;//	01 -->Posicao Registro No SC6
			(cAliax)->C6_QTDVEN,;			//	02 -->Quantidade a ser liberada
			.F.,; 							//	03 --> Bloqueio de Credito
			.T.,; 							// 	04 --> Bloqueio de Estoque
			.F.,; 							// 	05 --> Avaliacao de Credito
			.T.,; 							// 	06 --> Avaliacao de Estoque
			.F.,; 							// 	07 --> Permite Liberacao Parcial
			.F.,; 							// 	08 --> Tranfere Locais automaticamente
			NIL,; 							// 	09 --> Empenhos ( Caso seja informado nao efetua a gravacao apenas avalia )
			NIL,; 							// 	10 --> CodBlock a ser avaliado na gravacao do SC9
			NIL,;  							// 	11 --> Array com Empenhos previamente escolhidos (impede selecao dos empenhos pelas rotinas)
			NIL,;
			NIL,;
			0)	
		End Transaction
		
		SC6->(DbGoTo((cAliax)->SC6RECNO))
		RecLock("SC6",.F.)
			SC6->C6_RESERVA := ""
			SC6->C6_QTDRESE := 0	
			SC6->C6_QTDLIB := (cAliax)->C6_QTDVEN
		SC6->(MsUnlock())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Etorna a SC9 que esta posicionada, ajustando os saldos da SB2 ³
		//³e liberando a SC5/SC6                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SC9->(DbGoTo((cAliax)->SC9RECNO))
		SC9->(a460Estorna())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Nesse momento foi gerado um novo SC9 por isso a busca deve ser³
		//³feita pelo numero do pedido                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SC9->(MsSeek(xFilial("SC9")+ (cAliax)->C9_PEDIDO ))
		Do While SC9->(!Eof()) .And. SC9->(C9_FILIAL+C9_PEDIDO)==xFilial("SC9")+(cAliax)->C9_PEDIDO
			If SC9->C9_BLCRED=="01"
				a450Grava(1,.T.,.T.,)
				RecLock("SC9",.F.)
					SC9->C9_BLEST	:= ""
					SC9->C9_RESERVA	:= ""
					SC9->C9_QTDRESE	:= 0
					SC9->C9_DATALIB	:= dDataBase		
				SC9->(MsUnlock())
			EndIf
		SC9->(DbSkip())
		EndDo          
		
		If nQtdLib > 0
			Sleep(1500) //Sleep de 2 segundo
			SC6->(MaLiberOk({(cAliax)->C9_PEDIDO},.F.))
		Endif
		
  (cAliax)->(DbSkip()) 			 		
EndDo

(cAliax)->(DbCloseArea())
cFilAnt := cFilBkp

RESET ENVIRONMENT 
ConOut("Fim Da Execução Do Schedule " + Alltrim(ProcName()) + " Tempo Execução: " + ElapTime(_cInicio,Time()))

RestArea(aAreaSC6)
RestArea(aAreaSC9)

Return