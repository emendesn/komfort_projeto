#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMFINR02 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  16/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELATORIO DE CONFERENCIA DE CAIXA                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION KMFINR02()

Local cDesc1    := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2    := "de acordo com os parametros informados pelo usuario."
Local cDesc3    := ""
Local cPict     := ""
Local titulo    := "RELATORIO DE CONFERENCIA DE CAIXA"
Local nLin      := 80
Local Cabec1    := "     Forma de Pagamento               Valor "
Local Cabec2    := ""
Local imprime   := .T.
Local aOrd      := {}
Local aPergunta := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "M"
Private nomeprog    := "KMFINR02"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "KMFINR02"
Private cString     := ""         
Private aLojas := {}

aLojas := {}
SM0->(DbGoTop())
While SM0->(!EOF())
     aAdd( aLojas , { ALLTRIM(SM0->M0_CODFIL) , ALLTRIM(SM0->M0_FILIAL)} ) 
     SM0->(DbSkip())
EndDo


Aadd(aPergunta,{PadR("KMFINR02",10),"01","Loja de  ?" 					,"MV_CH1" ,"C",04,00,"G","MV_PAR01",""         ,""         ,"","","","SM0"})
Aadd(aPergunta,{PadR("KMFINR02",10),"02","Loja até ?" 					,"MV_CH2" ,"C",04,00,"G","MV_PAR02",""         ,""         ,"","","","SM0"})
Aadd(aPergunta,{PadR("KMFINR02",10),"03","Data de ?" 				    ,"MV_CH3" ,"D",08,00,"G","MV_PAR03",""         ,""         ,"","","",""   })
Aadd(aPergunta,{PadR("KMFINR02",10),"04","Data até ?" 				    ,"MV_CH4" ,"D",08,00,"G","MV_PAR04",""         ,""         ,"","","",""   })
Aadd(aPergunta,{PadR("KMFINR02",10),"05","Forma de ?" 				    ,"MV_CH5" ,"C",03,00,"G","MV_PAR05",""         ,""         ,"","","","SAE"})
Aadd(aPergunta,{PadR("KMFINR02",10),"06","Forma até ?" 					,"MV_CH6" ,"C",03,00,"G","MV_PAR06",""         ,""         ,"","","","SAE"})
Aadd(aPergunta,{PadR("KMFINR02",10),"07","Tipo Relatorio"			    ,"MV_CH7" ,"N",01,00,"C","MV_PAR07","Analitico","Sintetico","","","",""   })
Aadd(aPergunta,{PadR("KMFINR02",10),"08","Ordenar por ?"			    ,"MV_CH8" ,"N",01,00,"C","MV_PAR08","Titulo","Pedido","Nome","","",""	  })

VldSX1(aPergunta)

If !Pergunte(aPergunta[1,1],.T.)
	Return(Nil)
EndIf

IF ALLTRIM(cFilAnt) <> "0101"
	MsgInfo("Você pode visualizar somente as vendas da sua loja!")
	MV_PAR01 := cFilAnt
	MV_PAR02 := cFilAnt
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ LUIZ EDUARDO F.C.  º Data ³  16/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cQuery := ""
Local cQry   := ""
Local cQE5	 := ""	//#RVC20180530.n
Local aPV	 := {}
Local cQLoja := ""
Local nTotal := 0 
Local nLoja  := 0   
//Local cPrefixo		:= " "	//#RVC20181005.o
Local nTotalGeral	:= 0	//#AFD20183004.n
Local nTotalLoja	:= 0	//#RVC20180531.n
Local nTotalRa		:= 0	//#RVC20180531.n
Local nRecRA		:= 0
Local nQuebra		:= 75

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

@nLin,005 PSAY "PARAMETROS DO RELATORIO"
nLin++
@nLin,005 PSAY "Loja de   ? '" + MV_PAR01 + "'"
@nLin,060 PSAY "Loja ate  ? '" + MV_PAR02 + "'"
nLin++
@nLin,005 PSAY "Data de   ? '" + DTOC(MV_PAR03) + "'"
@nLin,060 PSAY "Data ate  ? '" + DTOC(MV_PAR04) + "'"
nLin++
@nLin,005 PSAY "Forma de  ? '" + MV_PAR05 + "'"
@nLin,060 PSAY "Forma ate ? '" + MV_PAR06 + "'"
nLin++
@nLin,005 PSAY "Tipo Relatorio ? '" + IIF(MV_PAR07=1,"Analitico","Sintetico") + "'"
@nLin,060 PSAY "Ordernar por ? '" + IIF(MV_PAR08=1,"Título",IIF(MV_PAR08=2,"Pedido","Nome")) + "'"
nLin++
@nLin,000 PSAY REPLICATE("-",130)


IF MV_PAR07 = 2	//Sintético
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(RecCount())
	
	//#RVC20180531.bn
//	cQLoja := " SELECT E1_MSFIL FROM " + RETSQLNAME("SE1") + " SE1 "			//#RVC20181005.o
 	cQLoja := " SELECT E1_MSFIL AS FILIAL FROM " + RETSQLNAME("SE1") + " SE1 "	//#RVC20181005.n
	cQLoja += " WHERE  E1_FILIAL = '    ' "
	cQLoja += " AND SE1.D_E_L_E_T_ = ' ' "
	cQLoja += " AND E1_MSFIL    BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "
	cQLoja += " AND E1_EMISSAO  BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'  "
	cQLoja += " AND E1_01OPER   BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'  "
	cQLoja += " GROUP BY E1_MSFIL " //#RVC20180529.o
	cQLoja += " ORDER BY E1_MSFIL "
		
	If Select("TLJ") > 0
		TLJ->(DbCloseArea())
	EndIf
	
	cQLoja := ChangeQuery(cQLoja)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQLoja),"TLJ",.F.,.T.)
	
	if TLJ->(BOF()) .AND. TLJ->(EOF())
	
		cQLoja := " SELECT C5_MSFIL AS FILIAL FROM " + RETSQLNAME("SC5") + " SC5 "
		cQLoja += " WHERE C5_FILIAL = '" + xFILIAL("SC5") + "'"
		cQLoja += " AND C5_MSFIL BETWEEN '" + Alltrim(MV_PAR01) + "' AND '" + Alltrim(MV_PAR02) + "' "
		cQLoja += " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
		cQLoja += " AND D_E_L_E_T_ = '' "
		cQLoja += " GROUP BY C5_MSFIL " 
		cQLoja += " ORDER BY C5_MSFIL " 
	
		If Select("TLJ") > 0
			TLJ->(DbCloseArea())
		EndIf
	
		cQLoja := ChangeQuery(cQLoja)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQLoja),"TLJ",.F.,.T.)
		
	endIf
	
	While TLJ->(!EOF())
		
		If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif                                            

//		nLoja	:= Ascan(aLojas,{|x| Alltrim(x[1]) == Alltrim(TLJ->E1_MSFIL)})	//#RVC20181005.o	
		nLoja	:= Ascan(aLojas,{|x| Alltrim(x[1]) == Alltrim(TLJ->FILIAL)})	//#RVC20181005.n
		
		nLin := nLin + 2
//		@nLin,000 PSAY "**** LOJA -> " + TLJ->E1_MSFIL + " / " + IIF(nLoja>0,aLojas[nLoja,2],)	//#RVC20181005.o
		@nLin,000 PSAY "**** LOJA -> " + TLJ->FILIAL + " / " + IIF(nLoja>0,aLojas[nLoja,2],)	//#RVC20181005.n
		@nLin,005 PSAY REPLICATE("_",50)
		nLin++
		//#RVC20180531.en
		
//		cQuery := " SELECT E1_TIPO, E1_01NOOPE, SUM(E1_VALOR) AS VALOR, SUM(E1_01TAXA) AS TAXA, SUM(E1_01VLBRU) AS VALBRU "				//#RVC20180531.o
		cQuery := " SELECT E1_TIPO, E1_01OPER, E1_01NOOPE, SUM(E1_VALOR) AS VALOR, SUM(E1_01TAXA) AS TAXA, SUM(E1_01VLBRU) AS VALBRU "	//#RVC20180531.n
		cQuery += " FROM " + RETSQLNAME("SE1") + " SE1 "
		cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
		cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
//		cQuery += " AND E1_MSFIL    BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "	//#RVC20180531.o
//		cQuery += " AND E1_MSFIL    = '" + TLJ->E1_MSFIL + "'  "							//#RVC20181005.o
		cQuery += " AND E1_MSFIL    = '" + TLJ->FILIAL + "'  "								//#RVC20181005.n
		cQuery += " AND E1_EMISSAO  BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'  "
		cQuery += " AND E1_01OPER   BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'  "
//		cQuery += " GROUP BY E1_01NOOPE, E1_TIPO "				//#RVC20180531.o           
		cQuery += " GROUP BY E1_01OPER, E1_01NOOPE, E1_TIPO "	//#RVC20180531.n
		
		If Select("TRB") > 0
			TRB->(DbCloseArea())
		EndIf
		
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		
		While TRB->(!EOF()) 
//			if (TRB->E1_TIPO <> 'RA ' .AND. TRB->E1_TIPO <> 'NCC') //#AFD20183004.n
			if (TRB->E1_TIPO <> 'RA ' .AND. TRB->E1_TIPO <> 'NCC' .AND. TRB->E1_TIPO <> 'RAN') //#RVC20180530.n
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o cancelamento pelo usuario...                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lAbortPrint
					@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					Exit
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao do cabecalho do relatorio. . .                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//				If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas... #AFD20180427.o
//				If nLin > 90 // Salto de Página. Neste caso o formulario tem 55 linhas... #AFD20180427.n	//#RVC20180531.o
				If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas... #AFD20180427.n	//#RVC20180531.n
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				
				@nLin,005 PSAY IIF(EMPTY(TRB->E1_01OPER),TRB->E1_TIPO,TRB->E1_01OPER) 	//#RVC20180531.n
//				@nLin,005 PSAY IIF(EMPTY(TRB->E1_01NOOPE),TRB->E1_TIPO,TRB->E1_01NOOPE)	//#RVC20180531.o
				@nLin,010 PSAY IIF(EMPTY(TRB->E1_01NOOPE),TRB->E1_TIPO,TRB->E1_01NOOPE)	//#RVC20180531.n
//				@nLin,060 PSAY Transform(TRB->VALOR,PesqPict('SE1','E1_VALOR'))
				@nLin,025 PSAY Transform(TRB->VALOR,PesqPict('SE1','E1_VALOR'))
				
				nLin   := nLin + 1 // Avanca a linha de impressao
				nTotal := nTotal + TRB->VALOR
			endif		
			TRB->(DbSkip())
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas... #AFD20180427.o
//		If nLin> 90 // Salto de Página. Neste caso o formulario tem 55 linhas...#AFD20180427.n	//#RVC20180531.o
		If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...				//#RVC20180531.n
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		//#RVC20180528.bo
		//Removido conforme solicitado no ticket n.° 8LZ-DP5-SA7B
		/*
		nLin := nLin + 1
		@nLin,005 PSAY "TOTAL RECEBIMENTO(S) -> R$ " +  Transform(nTotal,PesqPict('SE1','E1_VALOR'))
		@nLin,005 PSAY REPLICATE("_",50) //#AFD20183004.n
		nLin := nLin + 1
		@nLin,000 PSAY REPLICATE("-",130)*/
		//#RVC20180528.eo
	
		nTotalLoja	:= nTotal	//#RVC20180531.n
//		nTotalGeral := nTotal	//#AFD20183004.n	//#RVC20180531.n
		nTotal 		:= 0 		//#AFD20183004.n

		//#RVC20180528.bo
		//Removido conforme solicitado no ticket n.° 8LZ-DP5-SA7B
		/*	
		nLin := nLin + 2 //#AFD20183004.n
		//#AFD20183004.bn	
		TRB->(DBGOTOP())
			
		While TRB->(!EOF()) 
			if (TRB->E1_TIPO == 'RA ' .OR. TRB->E1_TIPO == 'NCC')
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o cancelamento pelo usuario...                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lAbortPrint
					@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					Exit
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao do cabecalho do relatorio. . .                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//				If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas... #AFD20180427.o
				If nLin> 90 // Salto de Página. Neste caso o formulario tem 55 linhas... #AFD20180427.n
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				@nLin,005 PSAY IIF(EMPTY(TRB->E1_01NOOPE),TRB->E1_TIPO,TRB->E1_01NOOPE)
//				@nLin,060 PSAY Transform(TRB->VALOR,PesqPict('SE1','E1_VALOR'))
				@nLin,025 PSAY Transform(TRB->VALOR,PesqPict('SE1','E1_VALOR'))
				
				nLin   := nLin + 1 // Avanca a linha de impressao
				nTotal := nTotal + TRB->VALOR
			endif
			TRB->(DbSkip())
		EndDo
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		If nLin> 90 // Salto de Página. Neste caso o formulario tem 55 linhas...AFD
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		nLin := nLin + 1
	
		@nLin,005 PSAY "TOTAL CRÉDITO(S) -> R$ " +  Transform(nTotal,PesqPict('SE1','E1_VALOR'))
		@nLin,005 PSAY REPLICATE("_",50)
		nLin := nLin + 1
		@nLin,000 PSAY REPLICATE("-",130)
				
		nTotalGeral -= nTotal
		
//		nLin := nLin + 2	//#RVC20180528.o
		nLin := nLin + 1	//#RVC20180528.n
		@nLin,005 PSAY "TOTAL GERAL(S) -> R$ " +  Transform(nTotalGeral,PesqPict('SE1','E1_VALOR'))
		@nLin,005 PSAY REPLICATE("_",50)
		nLin++
		//#AFD20183004.en */
		//#RVC20180528.eo
	
		//#RVC20180531.bn
		If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
			
		nLin := nLin + 1
		@nLin,005 PSAY "TOTAL " + IIF(nLoja>0,aLojas[nLoja,2],) + " -> R$ " +  Transform(nTotalLoja,PesqPict('SE1','E1_VALOR'))
	
		nTotalGeral += nTotalLoja
		nTotalLoja 	:= 0
		//#RVC20180531.en
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ BUSCA DOS TITULOS DE APROVEITAMENTO (RA) - TICKET 8LZ-DP5-SA7B - 29.05.2018 by Rafael Cruz³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
//		cPrefixo := RetPfx(TLJ->E1_MSFIL)	//#RVC20181005.o
		
		cQry := " SELECT C5_MSFIL, C5_NUM  FROM " + RETSQLNAME("SC5") + " SC5 "
		cQry += " WHERE C5_FILIAL = '" + xFILIAL("SC5") + "'"
//		cQry += " AND C5_MSFIL = '" + TLJ->E1_MSFIL + "'"											//#RVC20181005.o
		cQry += " AND C5_MSFIL = '" + TLJ->FILIAL + "'"												//#RVC20181005.n
		cQry += " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
		cQry += " AND D_E_L_E_T_ = '' "
		cQry += " ORDER BY 2,1 " 			
		If Select("TPV") > 0
			TPV->(DbCloseArea())
		EndIf
	
		cQry := ChangeQuery(cQry)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TPV",.F.,.T.)
			
		aPV := {}
			
		While TPV->(!EOF())
			Aadd(aPV,{TPV->C5_MSFIL, TPV->C5_NUM})
			TPV->(DbSkip())
		EndDo
			
		cQE5 := ""
			
		If !Empty(aPV)
			cQE5 := " SELECT E5_PREFIXO, E5_PARCELA, E5_NUMERO, E5_HISTOR, E1_NOMCLI, E1_EMISSAO, E5_VALOR FROM " + RetSqlName("SE5") + " SE5"
			cQE5 += " INNER JOIN " + RetSqlName("SE1") + " SE1 "
			cQE5 += " ON E5_FILIAL = '" + xFilial("SE5") + "'"
			cQE5 += " AND E5_PREFIXO = E1_PREFIXO "
			cQE5 += " AND E5_NUMERO = E1_NUM "
			cQE5 += " AND E5_PARCELA = E1_PARCELA "
			cQE5 += " AND E5_TIPO = E1_TIPO "
			cQE5 += " WHERE E5_FILIAL = '" + xFilial("SE5") + "'"			
			cQE5 += " AND E5_TIPO IN ('RA','NCC') "
			If Len(aPV) == 1
//				cQE5 += " AND E5_HISTOR LIKE '" + cPrefixo + ALLTRIM(aPV[1][2]) + "' "							//#RVC20181005.o
				cQE5 += " AND E5_HISTOR LIKE '%" + Substr(ALLTRIM(aPV[1][1]),3,2) + ALLTRIM(aPV[1][2]) + "' "	//#RVC20181005.n
			Else
//				cQE5 += " AND E5_HISTOR LIKE '" + cPrefixo + ALLTRIM(aPV[1][2]) + "' "							//#RVC20181005.o
				cQE5 += " AND E5_HISTOR LIKE '%" + Substr(ALLTRIM(aPV[1][1]),3,2) + ALLTRIM(aPV[1][2]) + "' "	//#RVC20181005.n
				For nA := 2 to Len(aPV)
//					cQE5 += " OR E5_HISTOR LIKE '" + cPrefixo + ALLTRIM(aPV[nA][2]) + "' "							//#RVC20181005.o
					cQE5 += " OR E5_HISTOR LIKE '%" + Substr(ALLTRIM(aPV[nA][1]),3,2) + ALLTRIM(aPV[nA][2]) + "' "	//#RVC20181005.n
				Next nA
			EndIf
//			cQE5 += " AND E5_TIPODOC = 'BA' "		//#RVC20180606.o //Removido p/ considerar todos os tipos de baixa
			cQE5 += " AND E5_SITUACA <> 'C' "		//#RVC20180611.n
			cQE5 += " AND SE5.D_E_L_E_T_ = ' ' "
			cQE5 += " AND SE1.D_E_L_E_T_ = ' ' "
			cQE5 += " ORDER BY E5_PREFIXO, "
			cQE5 += "		   E5_NUMERO, "
			cQE5 += "		   E5_PARCELA "
			
			If Select("TRA") > 0
				TRA->(DbCloseArea())
			EndIf
		
			cQE5 := ChangeQuery(cQE5)
			DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQE5),"TRA",.F.,.T.)
		
			While TRA->(!EOF())
				nTotalRa += TRA->E5_VALOR
				TRA->(DbSkip())
			EndDo
		EndIf
		
		If !Empty(nTotalRA)
			If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			nLin++
			@nLin,005 PSAY "TOTAL RA UTILIZADO"+ " -> R$ " +  Transform(nTotalRA,PesqPict('SE1','E1_VALOR'))
						
			nTotalRa := 0
			
		EndIF
		
		@nLin,005 PSAY REPLICATE("_",50)
		
		TLJ->(dbSkip())
	EndDo
	
	//#RVC20180531.bn
	If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	nLin := nLin + 2
	@nLin,005 PSAY "TOTAL GERAL(S) -> R$ " +  Transform(nTotalGeral,PesqPict('SE1','E1_VALOR'))
	@nLin,005 PSAY REPLICATE("_",50)
	nLin++
	//#RVC20180531.en
	
Else //Analítico
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(RecCount())

	cQLoja := " SELECT E1_MSFIL AS FILIAL FROM " + RETSQLNAME("SE1") + " SE1 " 	 //#RVC20181005.n	
//	cQLoja := " SELECT E1_MSFIL FROM " + RETSQLNAME("SE1") + " SE1 " 			 //#RVC20181005.o
//	cQLoja := " SELECT E1_MSFIL, E1_PREFIXO FROM " + RETSQLNAME("SE1") + " SE1 " //#RVC20180529.o
	//cQLoja += " INNER JOIN SM0010 SM0 ON FILFULL = E1_MSFIL "
	cQLoja += " WHERE  E1_FILIAL = '    ' "
	cQLoja += " AND SE1.D_E_L_E_T_ = ' ' "
	cQLoja += " AND E1_MSFIL    BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "
	cQLoja += " AND E1_EMISSAO  BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'  "
	cQLoja += " AND E1_01OPER   BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'  "
	cQLoja += " GROUP BY E1_MSFIL " //#RVC20180529.o
//	cQLoja += " GROUP BY E1_MSFIL, E1_PREFIXO " //#RVC20180529.n
	cQLoja += " ORDER BY E1_MSFIL "
		
	If Select("TLJ") > 0
		TLJ->(DbCloseArea())
	EndIf
	
	cQLoja := ChangeQuery(cQLoja)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQLoja),"TLJ",.F.,.T.)
	
	if TLJ->(BOF()) .AND. TLJ->(EOF())
	
		cQLoja := " SELECT C5_MSFIL AS FILIAL FROM " + RETSQLNAME("SC5") + " SC5 "
		cQLoja += " WHERE C5_FILIAL = '" + xFILIAL("SC5") + "'"
		cQLoja += " AND C5_MSFIL BETWEEN '" + Alltrim(MV_PAR01) + "' AND '" + Alltrim(MV_PAR02) + "' "
		cQLoja += " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
		cQLoja += " AND D_E_L_E_T_ = '' "
		cQLoja += " GROUP BY C5_MSFIL "
		cQLoja += " ORDER BY C5_MSFIL " 
	
		If Select("TLJ") > 0
			TLJ->(DbCloseArea())
		EndIf
	
		cQLoja := ChangeQuery(cQLoja)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQLoja),"TLJ",.F.,.T.)
		
	endIf
	
	While TLJ->(!EOF())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
//		If nLin > 90 // Salto de Página. Neste caso o formulario tem 55 linhas...	//#RVC20180531.o
		If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...	//#RVC20180531.n
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		nLin++                                               
//		nLoja	:= Ascan(aLojas,{|x| Alltrim(x[1]) == TLJ->E1_MSFIL})			//#RVC20180530.o
//		nLoja	:= Ascan(aLojas,{|x| Alltrim(x[1]) == Alltrim(TLJ->E1_MSFIL)})	//#RVC20181005.o
		nLoja	:= Ascan(aLojas,{|x| Alltrim(x[1]) == Alltrim(TLJ->FILIAL)})	//#RVC20181005.n

//		@nLin,025 PSAY " LOJA -> " + TLJ->E1_MSFIL + " / " + IIF(nLoja>0,aLojas[nLoja,2],)		//#RVC20181005.o
		@nLin,000 PSAY "**** LOJA -> " + TLJ->FILIAL + " / " + IIF(nLoja>0,aLojas[nLoja,2],)	//#RVC20181005.n
		@nLin,005 PSAY REPLICATE("_",50)
		nLin++
		
		//#RVC20180528.o
//		cQuery := " SELECT E1_TIPO, E1_01NOOPE,SUM(E1_VALOR) AS VALOR, E1_01OPER FROM " + RETSQLNAME("SE1") + " SE1 "
		//#RVC20180528.n
		cQuery := " SELECT E1_TIPO, E1_01NOOPE,SUM(E1_VALOR) AS VALOR, E1_01OPER, E1_NSUTEF FROM " + RETSQLNAME("SE1") + " SE1 "
//		cQuery += " INNER JOIN SM0010 SM0 ON FILFULL = E1_MSFIL "
		cQuery += " WHERE  E1_FILIAL = '" + XFILIAL("SE1") + "' "
		cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
//		cQuery += " AND E1_MSFIL = '" + TLJ->E1_MSFIL + "' "	//#RVC20181005.o
		cQuery += " AND E1_MSFIL = '" + TLJ->FILIAL + "' "		//#RVC20181005.n
		cQuery += " AND E1_EMISSAO  BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'  "
//		cQuery += " AND E1_TIPO NOT IN ('RA','NCC')"						//#RVC20180530.o	
		cQuery += " AND E1_TIPO NOT IN ('RA','NCC','RAN')"					//#RVC20180530.n
//		cQuery += " GROUP BY E1_01NOOPE, E1_01OPER, E1_TIPO "				//#RVC20180528.o		
		cQuery += " GROUP BY E1_01NOOPE, E1_01OPER, E1_TIPO, E1_NSUTEF "	//#RVC20180528.n
		
		If Select("TRB") > 0
			TRB->(DbCloseArea())
		EndIf
		
		PLSQuery(cQuery, "TRB")
		//cQuery := ChangeQuery(cQuery)
		//DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		TRB->(dbGoTop())
		While TRB->(!EOF())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
//			If nLin > 90 // Salto de Página. Neste caso o formulario tem 55 linhas...	#RVC20180531.o
			If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...	#RVC20180531.n			
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			//IMPRESSÃO DO TIPO DE ADMINISTRADORA FINANCEIRA
			nLin++	//#RVC20180601.n
			@nLin,005 PSAY IIF(EMPTY(TRB->E1_01OPER),TRB->E1_TIPO,TRB->E1_01OPER) 	//#RVC20180327.n
//			@nLin,005 PSAY IIF(EMPTY(TRB->E1_01NOOPE),TRB->E1_TIPO,TRB->E1_01NOOPE)	//#RVC20180327.o
			@nLin,010 PSAY IIF(EMPTY(TRB->E1_01NOOPE),TRB->E1_TIPO,TRB->E1_01NOOPE)	//#RVC20180327.n
//			@nLin,060 PSAY Transform(TRB->VALOR,PesqPict('SE1','E1_VALOR'))
			@nLin,025 PSAY Transform(TRB->VALOR,PesqPict('SE1','E1_VALOR'))
			@nLin,005 PSAY REPLICATE("_",50)
//			nLin := nLin + 2	//#RVC20180601.o
			nLin := nLin + 1	//#RVC20180601.n
				
			//IMPRESSÃO DAS DESCRIÇÕES DAS COLUNAS
//			@nLin,005 PSAY "Título Financeiro  Qtde.Parcelas  Pedido     Nome                                    Dt.Emissão               Valor"	//#RVC20180528.o
			@nLin,005 PSAY "Título/Prefixo    Qtd.  Aut./Cheque  Pedido  Nome                                    Dt.Emissão               Valor"	//#RVC20180528.n
			
			nLin   := nLin + 1 // Avanca a linha de impressao	
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ MODIFICADO A QUERY PARA TRAZER OS RESULTADOS AGLUTINADOS - LUIZ EDUARDO F.C. - 18.07.2017 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//			cQry := " SELECT E1_NUM, E1_PREFIXO, E1_PARCELA, E1_PEDIDO, A1_NOME, E1_LOJA, E1_EMISSAO, E1_VALOR FROM " + RETSQLNAME("SE1") + " SE1 "	//#RVC20180528.o
//			cQry := " SELECT E1_NUM, E1_PREFIXO, COUNT(*) AS E1_PARCELA, E1_PEDIDO, A1_NOME, E1_LOJA, E1_EMISSAO, SUM(E1_VALOR) AS E1_VALOR FROM " + RETSQLNAME("SE1") + " SE1 " //#RVC20180528.n
			cQry := " SELECT E1_NUM, E1_PREFIXO, COUNT(*) AS E1_PARCELA, E1_PEDIDO, A1_NOME, E1_LOJA, E1_EMISSAO, SUM(E1_VALOR) AS E1_VALOR, E1_NSUTEF FROM " + RETSQLNAME("SE1") + " SE1 "
//			cQry += " INNER JOIN SM0010 SM0 ON FILFULL = E1_MSFIL "
			cQry += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = E1_CLIENTE "
			cQry += " AND A1_LOJA = E1_LOJA "
			cQry += " WHERE  E1_FILIAL = '" + XFILIAL("SE1") + "' "
			cQry += " AND A1_FILIAL = '" + XFILIAL("SA1") + "' "
			cQry += " AND SE1.D_E_L_E_T_ = ' ' "
			cQry += " AND SA1.D_E_L_E_T_ = ' ' "
//			cQry += " AND E1_MSFIL = '" + TLJ->E1_MSFIL + "' "
			cQry += " AND E1_MSFIL = '" + TLJ->FILIAL + "' "
			cQry += " AND E1_01OPER = '" + TRB->E1_01OPER + "' " 
			cQry += " AND E1_TIPO = '" + TRB->E1_TIPO + "' "
			cQry += " AND E1_EMISSAO  BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'  "
			cQry += " AND E1_NSUTEF = '" + TRB->E1_NSUTEF + "' "										//#RVC20180528.n
//			cQry += " GROUP BY E1_NUM, E1_PREFIXO, E1_PEDIDO, A1_NOME, E1_LOJA, E1_EMISSAO, E1_NSUTEF " //#RVC20180528.o
			cQry += " GROUP BY E1_NUM, E1_PREFIXO, E1_PEDIDO, A1_NOME, E1_LOJA, E1_EMISSAO, E1_NSUTEF " //#RVC20180528.n
/*			
			//Ordernação
			//#RVC20180528.bn
			If MV_PAR08 == 2
				cQry += " ORDER BY E1_PEDIDO"
			ElseIf MV_PAR08 == 3
				cQry += " ORDER BY A1_NOME"
			EndIf
			//#RVC20180528.en
*/			
			If Select("TMP") > 0
				TMP->(DbCloseArea())
			EndIf
			
			cQry := ChangeQuery(cQry)
			DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TMP",.F.,.T.)
			
			While TMP->(!EOF())
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao do cabecalho do relatorio. . .                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//				If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
//				If nLin > 90 // Salto de Página. Neste caso o formulario tem 55 linhas...	#RVC20180531.o
				If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...	#RVC20180531.n
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				@nLin,005 PSAY TMP->E1_NUM + " - " + TMP->E1_PREFIXO
				@nLin,025 PSAY TMP->E1_PARCELA	//#RVC20180528.o	@nLin,030 PSAY TMP->E1_PARCELA
				@nLin,029 PSAY TMP->E1_NSUTEF	//#RVC20180528.n
				@nLin,042 PSAY TMP->E1_PEDIDO	//#RVC20180528.o	@nLin,039 PSAY TMP->E1_PEDIDO
				@nLin,050 PSAY TMP->A1_NOME
				@nLin,090 PSAY DTOC(STOD(TMP->E1_EMISSAO))
				@nLin,100 PSAY Transform(TMP->E1_VALOR,PesqPict('SE1','E1_VALOR'))
				
				nLin   := nLin + 1
				
				TMP->(DbSkip())
			EndDo
			
			If Select("TMP") > 0
				TMP->(DbCloseArea())
			EndIf
			
			cQry := ""
//			@nLin,000 PSAY REPLICATE("-",130)	//#RVC20180601.o
//			nLin := nLin + 1					//#RVC20180601.o
			
			nTotal := nTotal + TRB->VALOR
			
			TRB->(DbSkip())
		EndDo
		
		
//		nTotalGeral := nTotal	//#RVC20180601.o
		nTotalLoja	:= nTotal	
			
//		If nLin> 90 // Salto de Página. Neste caso o formulario tem 55 linhas...		//#RVC20180531.o
		If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...	//#RVC20180531.n
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		//#RVC20180601.bo
//		nLin := nLin + 1	
//		@nLin,005 PSAY "TOTAL GERAL -> R$ " +  Transform(nTotalGeral,PesqPict('SE1','E1_VALOR'))	
//		@nLin,000 PSAY REPLICATE("_",50)
//		nLin++
		//#RVC20180601.eo
		
		//#AFD20183004.en*/
		
//		If nLin > 90 // Salto de Página. Neste caso o formulario tem 55 linhas...		//#RVC20180531.o
		If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...	//#RVC20180531.n
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		//#RVC20180529.bn
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ BUSCA DOS TITULOS DE APROVEITAMENTO (RA) - TICKET 8LZ-DP5-SA7B - 29.05.2018 by Rafael Cruz³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
//		cPrefixo := RetPfx(TLJ->E1_MSFIL)	//#RVC20181005.o
		
		cQry := " SELECT C5_MSFIL, C5_NUM  FROM " + RETSQLNAME("SC5") + " SC5 "
		cQry += " WHERE C5_FILIAL = '" + xFILIAL("SC5") + "' "
//		cQry += " AND C5_MSFIL = '" + TLJ->E1_MSFIL + "'"											//#RVC20181005.o
		cQry += " AND C5_MSFIL = '" + TLJ->FILIAL + "'"												//#RVC20181005.n
		cQry += " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
		cQry += " AND D_E_L_E_T_ = '' "
		cQry += " ORDER BY 2,1 " 
					
		If Select("TPV") > 0
			TPV->(DbCloseArea())
		EndIf

		cQry := ChangeQuery(cQry)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TPV",.F.,.T.)
		
		aPV := {}
		
		While TPV->(!EOF())
			Aadd(aPV,{TPV->C5_MSFIL, TPV->C5_NUM})
			TPV->(DbSkip())
		EndDo
		
		cQE5 := ""
		
		If !Empty(aPV)
			cQE5 := " SELECT E5_PREFIXO, E5_PARCELA, E5_NUMERO, E5_HISTOR, E1_NOMCLI, E1_EMISSAO, E5_VALOR FROM " + RetSqlName("SE5") + " SE5"
			cQE5 += " INNER JOIN " + RetSqlName("SE1") + " SE1 "
			cQE5 += " ON E5_FILIAL = '" + xFilial("SE5") + "'"
			cQE5 += " AND E5_PREFIXO = E1_PREFIXO "
			cQE5 += " AND E5_NUMERO = E1_NUM "
			cQE5 += " AND E5_PARCELA = E1_PARCELA "
			cQE5 += " AND E5_TIPO = E1_TIPO "
			cQE5 += " WHERE E5_FILIAL = '" + xFilial("SE5") + "'"			
			cQE5 += " AND E5_TIPO IN ('RA','NCC') "
			If Len(aPV) == 1
//				cQE5 += " AND E5_HISTOR LIKE '" + cPrefixo + ALLTRIM(aPV[1][2]) + "' "							//#RVC20181005.o
				cQE5 += " AND E5_HISTOR LIKE '%" + Substr(ALLTRIM(aPV[1][1]),3,2) + ALLTRIM(aPV[1][2]) + "' "	//#RVC20181005.n
			Else
//				cQE5 += " AND E5_HISTOR LIKE '" + cPrefixo + ALLTRIM(aPV[1][2]) + "' "							//#RVC20181005.o
				cQE5 += " AND E5_HISTOR LIKE '%" + Substr(ALLTRIM(aPV[1][1]),3,2) + ALLTRIM(aPV[1][2]) + "' "	//#RVC20181005.n
				For nA := 2 to Len(aPV)
//					cQE5 += " OR E5_HISTOR LIKE '" + cPrefixo + ALLTRIM(aPV[nA][2]) + "' "							//#RVC20181005.o
					cQE5 += " OR E5_HISTOR LIKE '%" + Substr(ALLTRIM(aPV[nA][1]),3,2) + ALLTRIM(aPV[nA][2]) + "' "	//#RVC20181005.n
				Next nA
			EndIf
			cQE5 += " AND E5_TIPODOC = 'BA' "
			cQE5 += " AND SE5.D_E_L_E_T_ = ' ' "
			cQE5 += " AND SE1.D_E_L_E_T_ = ' ' "
			cQE5 += " ORDER BY E5_PREFIXO, "
			cQE5 += "		   E5_NUMERO, "
			cQE5 += "		   E5_PARCELA "
			
			If Select("TRA") > 0
				TRA->(DbCloseArea())
			EndIf
	
			cQE5 := ChangeQuery(cQE5)
			DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQE5),"TRA",.F.,.T.)
			
			Count to nRecRa	
			
			TRA->(dbGoTop())
			
			If nRecRa > 0
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao do cabecalho do relatorio. . .                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				nLin++				
				@nLin,005 PSAY "TÍTULO(S) R.A. APROVEITADO(S) EM PEDIDO(S) "
				@nLin,005 PSAY REPLICATE("_",50)
						
				If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
					
				nLin++
				@nLin,005 PSAY "Título/Prefixo     Parcela        Pedido     Nome                                    Dt.Emissão               Valor"		
				nLin++
			
				While TRA->(!EOF())
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Impressao do cabecalho do relatorio. . .                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
					Endif
								
					@nLin,005 PSAY TRA->E5_NUMERO + " - " + TRA->E5_PREFIXO
					@nLin,030 PSAY TRA->E5_PARCELA
					@nLin,039 PSAY RIGHT(ALLTRIM(TRA->E5_HISTOR),6)
					@nLin,050 PSAY TRA->E1_NOMCLI
					@nLin,090 PSAY DTOC(STOD(TRA->E1_EMISSAO))
					@nLin,100 PSAY Transform(TRA->E5_VALOR,PesqPict('SE1','E1_VALOR'))
						
					nLin++
					
					nTotalRa += TRA->E5_VALOR
						
					TRA->(DbSkip())
				EndDo
				
				If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
									
				nLin++
				@nLin,005 PSAY "TOTAL RA UTILIZADO ->" 
				@nLin,030 PSAY "R$ " +  Transform(nTotalRa,PesqPict('SE1','E1_VALOR'))
			EndIf

		
		EndIf
		
		nTotalGeral += nTotalLoja
		nTotalRA := 0
				
		If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
				
		nLin := nLin + 1
//		@nLin,005 PSAY "TOTAL " + IIF(nLoja>0,aLojas[nLoja,2],) + " -> R$ "	//#RVC20180601.o
 		@nLin,005 PSAY "TOTAL " + IIF(nLoja>0,aLojas[nLoja,2],) + " ->"		//#RVC20180601.n
		@nLin,030 PSAY + "R$ " + Transform(nTotalLoja,PesqPict('SE1','E1_VALOR'))
		@nLin,000 PSAY REPLICATE("_",55)
		nLin++
		
		nTotalLoja 	:= 0	
		
		TLJ->(DbSkip())
		
	EndDo	
	//#RVC20180529.en
	
	If nLin > nQuebra // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	nLin := nLin + 1	
	@nLin,005 PSAY "TOTAL GERAL -> R$ " +  Transform(nTotalGeral,PesqPict('SE1','E1_VALOR'))	
	@nLin,000 PSAY REPLICATE("_",55)
	nLin++
	
	
	//#RVC20180528.bo
	//Removido conforme solicitado no ticket n.° 8LZ-DP5-SA7B
	/*		
	//#AFD20183004.bn
	nTotalGeral := nTotal

	nLin := nLin + 1
	@nLin,005 PSAY "TOTAL RECEBIMENTO(S) -> R$ " +  Transform(nTotal,PesqPict('SE1','E1_VALOR'))
	@nLin,000 PSAY REPLICATE("_",50)
		
	nLin := nLin+3
	nTotal := 0	
	
	TLJ->(DbGoTop())
	
	While TLJ->(!EOF())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		nLin++                                               
//		nLoja	:= Ascan(aLojas,{|x| Alltrim(x[1]) == TLJ->E1_MSFIL})

//		@nLin,025 PSAY " LOJA -> " + TLJ->E1_MSFIL + " / " + IIF(nLoja>0,aLojas[nLoja,2],)
//		@nLin,02 PSAY "** LOJA -> " + TLJ->E1_MSFIL + " / " + IIF(nLoja>0,aLojas[nLoja,2],)
//		nLin++
//		@nLin,05 PSAY "________________________________"
//		nLin++
		
		cQuery := " SELECT E1_TIPO, E1_01NOOPE,SUM(E1_VALOR) AS VALOR, E1_01OPER FROM " + RETSQLNAME("SE1") + " SE1 "
		//cQuery += " INNER JOIN SM0010 SM0 ON FILFULL = E1_MSFIL "
		cQuery += " WHERE  E1_FILIAL = '" + XFILIAL("SE1") + "' "
		cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
		cQuery += " AND E1_MSFIL = '" + TLJ->E1_MSFIL + "' "
		cQuery += " AND E1_EMISSAO  BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'  "
		cQuery += " AND E1_TIPO IN ('RA','NCC')"
		cQuery += " GROUP BY E1_01NOOPE, E1_01OPER, E1_TIPO "
		
		If Select("TRB") > 0
			TRB->(DbCloseArea())
		EndIf
		
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		TRB->(dbGoTop())
		While TRB->(!EOF())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			If nLin> 90 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@nLin,005 PSAY IIF(EMPTY(TRB->E1_01OPER),TRB->E1_TIPO,TRB->E1_01OPER) 	//#RVC20180327.n
//			@nLin,005 PSAY IIF(EMPTY(TRB->E1_01NOOPE),TRB->E1_TIPO,TRB->E1_01NOOPE)	//#RVC20180327.o
			@nLin,010 PSAY IIF(EMPTY(TRB->E1_01NOOPE),TRB->E1_TIPO,TRB->E1_01NOOPE)	//#RVC20180327.n
//			@nLin,060 PSAY Transform(TRB->VALOR,PesqPict('SE1','E1_VALOR'))
			@nLin,025 PSAY Transform(TRB->VALOR,PesqPict('SE1','E1_VALOR'))
			@nLin,005 PSAY REPLICATE("_",50)
			nLin   := nLin + 2
			
			@nLin,005 PSAY "Título Financeiro  Qtde.Parcelas  Pedido     Nome                                    Dt.Emissão               Valor"
			
			nLin   := nLin + 1 // Avanca a linha de impressao
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ MODIFICADO A QUERY PARA TRAZER OS RESULTADOS AGLUTINADOS - LUIZ EDUARDO F.C. - 18.07.2017 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//cQry := " SELECT E1_NUM, E1_PREFIXO, E1_PARCELA, E1_PEDIDO, A1_NOME, E1_LOJA, E1_EMISSAO, E1_VALOR FROM " + RETSQLNAME("SE1") + " SE1 "
			cQry := " SELECT E1_NUM, E1_PREFIXO, COUNT(*) AS E1_PARCELA, E1_PEDIDO, A1_NOME, E1_LOJA, E1_EMISSAO, SUM(E1_VALOR) AS E1_VALOR FROM " + RETSQLNAME("SE1") + " SE1 "
			//cQry += " INNER JOIN SM0010 SM0 ON FILFULL = E1_MSFIL "
			cQry += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = E1_CLIENTE "
			cQry += " AND A1_LOJA = E1_LOJA "
			cQry += " WHERE  E1_FILIAL = '" + XFILIAL("SE1") + "' "
			cQry += " AND A1_FILIAL = '" + XFILIAL("SA1") + "' "
			cQry += " AND SE1.D_E_L_E_T_ = ' ' "
			cQry += " AND SA1.D_E_L_E_T_ = ' ' "
			cQry += " AND E1_MSFIL = '" + TLJ->E1_MSFIL + "' "
			cQry += " AND E1_01OPER = '" + TRB->E1_01OPER + "' " 
			cQry += " AND E1_TIPO = '" + TRB->E1_TIPO + "' "
			cQry += " AND E1_EMISSAO  BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'  "
			cQry += " GROUP BY E1_NUM, E1_PREFIXO, E1_PEDIDO, A1_NOME, E1_LOJA, E1_EMISSAO "
			
			If Select("TMP") > 0
				TMP->(DbCloseArea())
			EndIf
			
			cQry := ChangeQuery(cQry)
			DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TMP",.F.,.T.)
			
			While TMP->(!EOF())
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao do cabecalho do relatorio. . .                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//				If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas... //#AFD20183004.o
				If nLin> 90 // Salto de Página. Neste caso o formulario tem 55 linhas... //#AFD20183004.n
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				@nLin,005 PSAY TMP->E1_NUM + " - " + TMP->E1_PREFIXO
				@nLin,030 PSAY TMP->E1_PARCELA
				@nLin,039 PSAY TMP->E1_PEDIDO
				@nLin,050 PSAY TMP->A1_NOME
				@nLin,090 PSAY DTOC(STOD(TMP->E1_EMISSAO))
				@nLin,100 PSAY Transform(TMP->E1_VALOR,PesqPict('SE1','E1_VALOR'))
				
				nLin   := nLin + 1
				
				TMP->(DbSkip())
			EndDo
			
			If Select("TMP") > 0
				TMP->(DbCloseArea())
			EndIf
			
			cQry := ""
			@nLin,000 PSAY REPLICATE("-",130)
			nLin := nLin + 1
			
			nTotal := nTotal + TRB->VALOR
			
			TRB->(DbSkip())
		EndDo
		TLJ->(DbSkip())
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas... //#AFD20183004.o
	If nLin> 90 // Salto de Página. Neste caso o formulario tem 55 linhas... //#AFD20183004.n
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	nLin := nLin + 1
	@nLin,005 PSAY "TOTAL CRÉDITO(S) -> R$ " +  Transform(nTotal,PesqPict('SE1','E1_VALOR'))
	@nLin,000 PSAY REPLICATE("_",50)	
		
	nTotalGeral -= nTotal
	
	If nLin> 90 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	nLin := nLin + 3	
	@nLin,05 PSAY "TOTAL GERAL -> R$ " +  Transform(nTotalGeral,PesqPict('SE1','E1_VALOR'))	
	@nLin,000 PSAY REPLICATE("_",50)
	//#AFD20183004.en*/
	//#RVC20180528.eo
	
	nLin := nLin+1
	nTotal := 0	
	
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  VldSX1  º Autor ³ LUIZ EDUARDO F.C.  º Data ³  05/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDACAO DE PERGUNTAS DO SX1                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VldSX1(aPergunta)

Local i
Local aAreaBKP := GetArea()

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

For i := 1 To Len(aPergunta)
	SX1->(RecLock("SX1",!dbSeek(aPergunta[i,1]+aPergunta[i,2])))
	SX1->X1_GRUPO 		:= aPergunta[i,1]
	SX1->X1_ORDEM		:= aPergunta[i,2]
	SX1->X1_PERGUNT		:= aPergunta[i,3]
	SX1->X1_VARIAVL		:= aPergunta[i,4]
	SX1->X1_TIPO		:= aPergunta[i,5]
	SX1->X1_TAMANHO		:= aPergunta[i,6]
	SX1->X1_DECIMAL		:= aPergunta[i,7]
	SX1->X1_GSC			:= aPergunta[i,8]
	SX1->X1_VAR01		:= aPergunta[i,9]
	SX1->X1_DEF01		:= aPergunta[i,10]
	SX1->X1_DEF02		:= aPergunta[i,11]
	SX1->X1_DEF03		:= aPergunta[i,12]
	SX1->X1_DEF04		:= aPergunta[i,13]
	SX1->X1_DEF05		:= aPergunta[i,14]
	SX1->X1_F3			:= aPergunta[i,15]
	SX1->(MsUnlock())
Next i

RestArea(aAreaBKP)

Return(Nil)

Static Function RetPfx(cMSFIL)

	Local cPrefixo := ""

//	dbSelectArea(SX6)
	SX6->(dbSetOrder(1))
	If SX6->(dbSeek(cMSFIL+"KM_PREFIXO"))
		cPrefixo := ALLTRIM(SX6->X6_CONTEUD)
	EndIf
//	SX6->(dbCloseArea())

Return cPrefixo