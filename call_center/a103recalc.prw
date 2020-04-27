#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE MAXGETDAD 99999
#DEFINE MAXSAVERESULT 99999

#DEFINE MERCADORIA 	1
#DEFINE DESCONTO 	2
#DEFINE ACRESCIMO	3
#DEFINE FRETE		4
#DEFINE DESPESA  	5
#DEFINE BASEDUP		6
#DEFINE	 SUFRAMA	7
#DEFINE	 TOTAL		8

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A103Recalc      ³Autor ³ Microsiga        ³ Data ³ 14/02/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Recalcula os valores do pedido 		               	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Linha do aCols a Ser atualizada                      ³±±
±±³          ³ExpL2: .T. - Indica que so a linha selecionada deve ser atu-³±±
±±³          ³             -lizada.                                       ³±±
±±³          ³ExpL3: .F. - Indica se a chamada vem do valid do campo      ³±±
±±³          ³             UA_TABELA.                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A103Recalc(nLen, lUpdOnlySelected, lAltPre)

Local nLinha	:= 0							// Contador de Linha		
Local nPosAnt	:= 1							// Posicao atual do N no aCols
Local lTudo		:= .F.							// Flag que indica que havera recalculo de todos os itens nas demais funcoes
Local nPProd	:= aPosicoes[1][2]				// Produto
Local nPQtd 	:= aPosicoes[4][2]				// Quantidade	
Local nPVrUnit  := aPosicoes[5][2]				// Valor unitario
Local nPVlrItem	:= aPosicoes[6][2]				// Valor do item
Local nPPrcTab  := aPosicoes[15][2]				// Preco de Tabela
Local nPDesc 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DESC"})
Local nPValDesc	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VALDESC"})
Local nPTabPad	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01TABPA"})
Local nVrUnit	:= 0							// Variavel auxiliar com valor unitario
Local nIniLoop  := 0							// Valor que deve iniciar o loop de atualizacao
Local nFimLoop  := 0							// Valor que deve para o loop de atualizacao
Local lMV_PVRECAL := SuperGetMV("MV_PVRECAL")	// Se não é para atualiza a tabela de preço quando alterada
Local lRecalc    := .F.
Local lCondPg   := (ReadVar()=="M->UA_CONDPG")
Local lCondTab  := .F. 							// Verifica se a condicao escolhida esta na tabela de precos

Default nLen 			:= Len(aCols)			// Valor default e o total de linhas dos itens do televendas
Default lUpdOnlySelected:= .F.					// Indica se deve atualizar apenas a linha informada no primeiro parametro. Por padrao, atualiza todos.
Default lAltPre			:= .F.					// Se a função está sendo executada do Valid do campo UB_01TABPA (Ela foi criada para garantir que só haverá alteração nos valores dos itens baseados na tabela de preço, somento quando o usuário solicitar)

If N <> Nil
	nPosAnt	:= N
Endif

CursorWait()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Zera os valores de desconto, acrescimo, mercadoria e total.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aValores[DESCONTO]  	:= 0
aValores[MERCADORIA]	:= 0
aValores[SUFRAMA]		:= 0
aValores[TOTAL]			:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o valor do UA_DESC4  quando altera a tabela de preço.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAltPre
	TkRegraDesc(2,NIL,@M->UA_DESC4,NIL,M->UA_CONDPG,NIL)
EndIf  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Novas variaveis de controle do loop de atualizacao.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nIniLoop := 1
If lUpdOnlySelected 
	nIniLoop := nLen
Endif        
nFimLoop := nLen

If lCondPg
	dbSelectArea("DA0")
	dbSetOrder(1) 
	If MsSeek(xFilial("DA0")+M->UB_01TABPA)
		lCondTab := DA0_CONDPG == M->UA_CONDPG
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a rotina que ira calcular os valores de Valor Unitario, Valor Item, Desconto e Acrescimo.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLinha := nIniLoop to nFimLoop

	If (!aCols[nLinha][Len(aHeader)+1]) .AND. (!Empty(aCols[nLinha][nPProd]))

		lRecalc := .F.

 		If lCondPg .And. lCondTab .And. aPesqDA1(M->UB_01TABPA,aCols[nLinha][nPProd])
			lRecalc := .T.
		Else 	
			lRecalc := .F.
		Endif	

		If !lRecalc .And. lCondPg// .And.((!(TkRegraDesc(2,NIL,@M->UA_DESC4,NIL,M->UA_CONDPG,NIL)>0) .Or.(!(TkRegraDesc(1,NIL,NIL,NIL,NIL,nLinha) > 0)))) 				
		    If (TkRegraDesc(2,NIL,@M->UA_DESC4,NIL,M->UA_CONDPG,NIL)>0)
				lRecalc := .T.
			ElseIf !lRecalc .And. (TkRegraDesc(1,NIL,NIL,NIL,M->UA_CONDPG,nLinha) > 0)
				lRecalc := .T.	
			Else 	
				lRecalc := .F.
			Endif	
		Endif
		
		If lCondPg .And. !lRecalc
			Loop
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Recalcula os valores somente para os itens que nao foram deletados.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa a rotina que ira calcular os valores de Valor Unitario, Valor Item, Desconto e Acrescimo.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se a tabela nao for vazia pega o preco de tabela,              ³                                   
			//³caso contrario pega o valor informado no Cadastro do Produto   ³
			//³Isso ocorre para manter a compatiblizacao com o SIGAFAT        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aCols[nLinha][nPPrcTab] == 0 .Or. ( lAltPre ) // .And. !lMV_PVRECAL)
				If !Empty(aCols[nLinha][nPTabPad])
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se for uma tabela de preco valida calcula o valor unitario do item (MaTabPrVen)³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nVrUnit := ReTabPrVen(	aCols[nLinha][nPTabPad]	,aCols[nLinha][nPProd]	,aCols[nLinha][nPQtd]	,M->UA_CLIENTE	,;
											M->UA_LOJA				,M->UA_MOEDA			,NIL					,NIL			,;
											NIL						,.T.					,lProspect				)
	 		  	Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ PRIMEIRO TENTA PEGAR O PRECO DO PRODUTO DA TABELA DA1, SE ESTIVER 0 TRAZ DO SB1 - LUIZ EDUARDO F.C. - 22.08.2017 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea("DA1")
					DA1->(DbSetOrder(1))
					DA1->(DbSeek(xFilial("DA1") + cTabPad + aCols[nLinha][nPProd] ))  
					IF DA1->DA1_PRCVEN > 0
						nVrUnit := DA1->DA1_PRCVEN
					Else	 		  		 		  	
						DbSelectArea("SB1")
						DbSetOrder(1)
						If DbSeek( xFilial("SB1")+aCols[nLinha][nPProd] )
							nVrUnit := SB1->B1_PRV1
						Endif
					EndIF	
				Endif
				
				aCols[nLinha][nPVrUnit] := nVrUnit
			
			Else
				nVrUnit := aCols[nLinha][nPPrcTab]
			EndIf
	        
			If nVrUnit > 0
				aCols[nLinha][nPPrcTab] := nVrUnit
			Endif
			
			aCols[nLinha][nPVlrItem]	:= A410Arred(aCols[nLinha][nPQtd]*aCols[nLinha][nPVrUnit],"UB_VLRITEM")
			aCols[nLinha][nPDesc] 		:= 0
			aCols[nLinha][nPValDesc]	:= 0
	      	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se houve desconto em cascata ou se há uma regra de    ³
			//³desconto, atualiza o preço unitário e suas respectivas³
			//³informações.                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If 	(M->UA_DESC4 > 0) .OR. ;
				(M->UA_DESC1 > 0) .OR. ;
				(M->UA_DESC2 > 0) .OR. ;
				(M->UA_DESC3 > 0) .OR. ;
				(lAltPre .And. !lMV_PVRECAL .And. TkRegraDesc(1,NIL,NIL,NIL,NIL,nLinha) > 0)
				
				Tk273DesCab(nLinha,lTudo)
			Endif
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualizacao das informacoes fiscais (MatXFis)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisAlt("IT_QUANT",aCols[nLinha][nPQtd],nLinha)
	MaFisAlt("IT_PRCUNI",aCols[nLinha][nPVrUnit],nLinha)
	MaFisAlt("IT_VALMERC",aCols[nLinha][nPVlrItem],nLinha)

	Tk273RodImposto("NF_DESPESA",aValores[DESPESA]+aValores[ACRESCIMO])		
	Tk273RodImposto("NF_DESCONTO",aValores[DESCONTO])
	
Next nLinha

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Volta a posicao anterior do N ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
n := nPosAnt            

Eval(bListRefresh)

CursorArrow()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ReTabPrVen ³ Autor ³ Henry Fila            ³ Data ³ 20.04.00³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para trazer preco de venda de acordo com a qtde      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpN1: Numerico (Preco de Venda)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Tabela de Preco                                      ³±±
±±³          ³ExpC2: Codigo do Produto                                    ³±±
±±³          ³ExpN3: Quantidade                                           ³±±
±±³          ³ExpC4: Cliente                                              ³±±
±±³          ³ExpC5: Loja                                                 ³±±
±±³          ³ExpN6: Moeda a ser retornada                                ³±±
±±³          ³ExpD7:                                                      ³±±
±±³          ³ExpN8: Tipo                                                 ³±±
±±³          ³       1 = Preco (Default)                                  ³±±
±±³          ³       2 = Fator de acrescimo ou desconto                   ³±±
±±³          ³ExpL9:                                                      ³±±
±±³          ³ExpL10:                                                     ³±±
±±³          ³ExpL11:Se o cliente deve ser tratado como um prospect       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 04/12/06 ³ Conrado Q.    ³ - BOPS: 111439: Criado parâmetro para atu  ³±±
±±³          ³               ³ alização das variáveis estáticas.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReTabPrVen(cTabPreco,cProduto,nQtde,cCliente,cLoja,nMoeda,dDataVld,nTipo,lExec,lAtuEstado,lProspect)

Static cMvEstado
Static cMvNorte

Local aArea     := GetArea()
Local aAreaSB1  := SB1->(GetArea())
Local aStruDA1  := {}

Local cTpOper   := ""
Local cQuery    := ""
Local cAliasDA1 := "DA1"
                              
Local nPrcVen   := 0
Local nResult   := 0
Local nMoedaTab := 1
Local nScan     := 0
Local nY        := 0
Local cMascara  := SuperGetMv("MV_MASCGRD")      
Local nTamProd  := Len(SB1->B1_COD)
Local nFator    := 0

Local lUltResult:= .T.
Local lQuery    := .F.
Local nProcessa := 0
Local lGrade    := MaGrade()
Local lGradeReal:= .F.
Local lPrcDA1   := .F.
Local cProdRef  := cProduto 
Local lSeekDa1  := .F. 
Local lR5      	:= GetRpoRelease("R5")    				// Indica se o release e 11.5
Local lLjcnvB0	:= SuperGetMv("MV_LJCNVB0",,.F.)		// Retorna preço da SB0 na ausência do preço do Produto na DA0 e DA1
Local aUltResult:= {}                                                    

DEFAULT cMvEstado := GetMv("MV_ESTADO")
DEFAULT cMvNorte  := GetMv("MV_NORTE")
DEFAULT nMoeda    := 1
DEFAULT dDataVld  := dDataBase
DEFAULT nTipo     := 1
DEFAULT lExec     := .T.
DEFAULT lAtuEstado:= .F.
DEFAULT lProspect := .F.

If Empty(cTabPreco)
	RestArea(aAreaSB1)
	RestArea(aArea)
	Return(nResult)
Endif

If lAtuEstado
	cMvEstado	:= GetMv("MV_ESTADO")
	cMvNorte	:= GetMv("MV_NORTE")
Endif

If lGrade .And.	MatGrdPrrf(@cProdRef,.T.)
	nTamProd	:= Len(cProdRef)
	lGradeReal	:= .T.	
	cProdRef	:= Padr(cProdRef,Len(DA1->DA1_REFGRD))	
Endif

If ExistBlock("OM010PRC") .And. lExec
	nResult := ExecBlock("OM010PRC",.F.,.F.,{cTabPreco,cProduto,nQtde,cCliente,cLoja,nMoeda,dDataVld,nTipo})
Else

	nScan := aScan(aUltResult,{|x| x[1] == cTabPreco .And. x[2] == cProduto .And. x[3] == nQtde .And. x[4] == cCliente .And. x[5] == cLoja .And. x[6] == nMoeda .And. x[7] == cFilAnt .And. x[10] == lProspect})
			
	If nScan == 0
	
		If !(Empty(cCliente) .And. nQtde == 0 )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se for prospect, pega a informação do mesmo.            ³
			//³Funcionalidade implantada para utilização do televendas,³
			//³já que ele suporta orçamento para prospect.             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lProspect
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Acho o tipo de operacao para busca do preco de venda³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SUS")
				dbSetOrder(1)
				If MsSeek(xFilial("SUS")+cCliente+cLoja)
					Do Case
						Case SUS->US_EST == cMvEstado
							cTpOper := "1"
						Case SUS->US_EST != cMvEstado
							If (SUS->US_EST $ cMvNorte) .And. !(cMvEstado $ cMvNorte)
								cTpOper := "3"
							Else
								cTpOper := "2"
							EndIf						
					EndCase					
				EndIf															
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Acho o tipo de operacao para busca do preco de venda³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SA1")
				dbSetOrder(1)
				If MsSeek(xFilial("SA1")+cCliente+cLoja)
					Do Case
						Case SA1->A1_EST == cMvEstado
							cTpOper := "1"
						Case SA1->A1_EST != cMvEstado
							If (SA1->A1_EST $ cMvNorte) .And. !(cMvEstado $ cMvNorte)
								cTpOper := "3"
							Else
								cTpOper := "2"
							EndIf						
					EndCase					
				EndIf															
			EndIf
		Endif	
	
		dbSelectarea("DA1")
		dbSetOrder(1)
	
		#IFDEF TOP
			If TcSrvType() <> "AS/400"
				lQuery    := .T.
				cAliasDA1 := GetNextAlias()
				aStruDA1  := DA1->(dbStruct())
				cQuery    := ""

				cQuery += "SELECT * "
				cQuery += "FROM "+RetSqlName("DA1")+ " DA1 "
				cQuery += "WHERE "
				cQuery += "DA1.DA1_FILIAL = '"+xFilial("DA1")+"' AND "
				cQuery += "DA1.DA1_CODTAB = '"+cTabPreco+"' AND "
				cQuery += "DA1.DA1_CODPRO = '"+cProduto+"' AND "			
				cQuery += "DA1.DA1_ATIVO = '1' AND  "			
				
	    		cQuery += "( DA1.DA1_DATVIG <= '"+DtoS(dDataVld)+ "' OR DA1.DA1_DATVIG = '"+Dtos(Ctod("//"))+ "' ) AND "
				
				If !(nQtde == 0 .And. Empty(cCliente))
					cQuery += "( DA1.DA1_TPOPER = '"+cTpOper+"' OR DA1.DA1_TPOPER = '4' ) AND "
				Endif                     				
				cQuery += "DA1.D_E_L_E_T_ = ' ' "
								
				cQuery += "ORDER BY "+SqlOrder(DA1->(IndexKey()))
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDA1,.T.,.T.)
				
				If (cAliasDA1)->(!Eof())
					nProcessa := 1      
				Endif
				
				For nY := 1 To Len(aStruDA1)
					If aStruDA1[nY][2]<>"C"
						TcSetField(cAliasDA1,aStruDA1[nY][1],aStruDA1[nY][2],aStruDA1[nY][3],aStruDA1[nY][4])
					EndIf
				Next nY
			Else
		#ENDIF
				lSeekDA1:= aPesqDA1(cTabPreco,cProduto)
				If lSeekDA1
					nProcessa := 1
				Else
					SB1->(dbSetOrder(1))
					If SB1->(MsSeek(xFilial("SB1")+cProduto))
						cGrupo := SB1->B1_GRUPO
						If !Empty(cGrupo)
							dbSelectarea("DA1")
							dbSetOrder(4)
							If MsSeek(xFilial("DA1")+ cTabPreco + cGrupo)
								nProcessa := 2
							EndIf
						EndIF
					Endif
				EndIf
		#IFDEF TOP
			Endif
		#ENDIF
								
		If nProcessa > 0
		
			If nQtde == 0 .And. Empty(cCliente)
				nPrcVen   := (cAliasDA1)->DA1_PRCVEN
				nMoedaTab := (cAliasDA1)->DA1_MOEDA
				nFator    := (cAliasDA1)->DA1_PERDES
				
				lPrcDA1   := .T.
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Busco o preco e analiso a qtde de acordo com a faixa³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(cAliasDA1)
				While (cAliasDA1)->(!Eof()) .And. (cAliasDA1)->DA1_FILIAL == xFilial("DA1") .And.;
									(cAliasDA1)->DA1_CODTAB == cTabPreco .And.;
									If(nProcessa==1,Left((cAliasDA1)->DA1_CODPRO,nTamProd)== cProduto .Or. (cAliasDA1)->DA1_CODPRO==cProduto .Or. (cAliasDA1)->DA1_REFGRD == cProdRef,(cAliasDA1)->DA1_GRUPO==cGrupo)
	
					If nQtde <= (cAliasDA1)->DA1_QTDLOT .And. (cAliasDA1)->DA1_ATIVO == "1"
					
						If Empty((cAliasDA1)->DA1_ESTADO) .And. ((cAliasDA1)->DA1_TPOPER == cTpOper .Or. (cAliasDA1)->DA1_TPOPER == "4")				
						
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica a vigencia do item                                   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							
							nQtdLote := (cAliasDA1)->DA1_QTDLOT
							
							While (cAliasDA1)->(!Eof()) .And. (cAliasDA1)->DA1_FILIAL == xFilial("DA1") .And.;
																(cAliasDA1)->DA1_CODTAB == cTabPreco .And.;
																If(nProcessa==1,Left((cAliasDA1)->DA1_CODPRO,nTamProd)== cProduto .Or. (cAliasDA1)->DA1_CODPRO==cProduto .Or. (cAliasDA1)->DA1_REFGRD == cProdRef ,(cAliasDA1)->DA1_GRUPO==cGrupo) .And.;
																(cAliasDA1)->DA1_QTDLOT == nQtdLote .And.;
																(cAliasDA1)->DA1_DATVIG <= dDataVld
								If nQtde <= (cAliasDA1)->DA1_QTDLOT .And. (cAliasDA1)->DA1_ATIVO == "1" .And.;
									((!Empty((cAliasDA1)->DA1_ESTADO) .And. ( If(lProspect, SUS->US_EST, SA1->A1_EST) == (cAliasDA1)->DA1_ESTADO )).Or.(Empty((cAliasDA1)->DA1_ESTADO) .And. ((cAliasDA1)->DA1_TPOPER == cTpOper .Or. (cAliasDA1)->DA1_TPOPER == "4")))
									
									nPrcVen   := (cAliasDA1)->DA1_PRCVEN
									nMoedaTab := (cAliasDA1)->DA1_MOEDA 
									nFator    := (cAliasDA1)->DA1_PERDES
									
									lPrcDA1   := .T.
								EndIf
												
								dbSelectArea(cAliasDA1)
								dbSkip()
							Enddo
							If lPrcDA1
								Exit
							Endif
	
						ElseIf !Empty((cAliasDA1)->DA1_ESTADO) .And. ( If(lProspect, SUS->US_EST, SA1->A1_EST) == (cAliasDA1)->DA1_ESTADO )
						
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica a vigencia do item                                   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							
							nQtdLote := (cAliasDA1)->DA1_QTDLOT
							
							While (cAliasDA1)->(!Eof()) .And. (cAliasDA1)->DA1_FILIAL == xFilial("DA1") .And.;
																	(cAliasDA1)->DA1_CODTAB == cTabPreco .And.;
																	If(nProcessa==1,Left((cAliasDA1)->DA1_CODPRO,nTamProd)== cProduto .Or. (cAliasDA1)->DA1_CODPRO==cProduto .Or. (cAliasDA1)->DA1_REFGRD == cProdRef,(cAliasDA1)->DA1_GRUPO==cGrupo) .And.;
																	(cAliasDA1)->DA1_QTDLOT == nQtdLote .And.;																
																	(cAliasDA1)->DA1_DATVIG <= dDataVld 
								If nQtde <= (cAliasDA1)->DA1_QTDLOT .And. (cAliasDA1)->DA1_ATIVO == "1" .And.;
									((!Empty((cAliasDA1)->DA1_ESTADO) .And. ( If(lProspect, SUS->US_EST, SA1->A1_EST) == (cAliasDA1)->DA1_ESTADO )).Or.(Empty((cAliasDA1)->DA1_ESTADO) .And. ((cAliasDA1)->DA1_TPOPER == cTpOper .Or. (cAliasDA1)->DA1_TPOPER == "4")))

		
									nPrcVen   := (cAliasDA1)->DA1_PRCVEN
									nMoedaTab := (cAliasDA1)->DA1_MOEDA
									nFator    := (cAliasDA1)->DA1_PERDES
		
									lPrcDA1   := .T.
									
								Endif									
									
								dbSelectArea(cAliasDA1)
								dbSkip()
							Enddo
							If lPrcDA1
								Exit
							Endif	 
							
						EndIf									
					EndIf						
					dbSelectArea(cAliasDA1)
					dbSkip()
				Enddo	     
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Somente atualiza com o SB1 caso nao tenha achado nenhuma tabela    ³
				//³caso contrario retornara o preco zerado                            ³			
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			                                  
				If nTipo == 1 
					If nPrcVen == 0 .And. !lPrcDA1
						If lLjcnvB0 .AND. nModulo == 12
							DbSelectArea("SB0") 
							DbSetOrder(1)
							If DbSeek(xFilial("SB0")+cProduto)
								nPrcVen := SB0->B0_PRV1
							EndIf
						Else  
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ PRIMEIRO TENTA PEGAR O PRECO DO PRODUTO DA TABELA DA1, SE ESTIVER 0 TRAZ DO SB1 - LUIZ EDUARDO F.C. - 22.08.2017 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							DbSelectArea("DA1")
							DA1->(DbSetOrder(1))
							DA1->(DbSeek(xFilial("DA1") + cTabPad + cProduto ))  
							IF DA1->DA1_PRCVEN > 0
								nPrcVen := DA1->DA1_PRCVEN
							Else	 		  		 		  							
								DbSelectArea("SB1") 
								DbSetOrder(1)
								If MsSeek(xFilial("SB1")+cProduto)
									nPrcVen := SB1->B1_PRV1
								EndIf						
							EndIf
						EndIf 
						lUltResult := .F.
					Endif				
				Endif
				
			EndIf
		Else                     
			If nTipo == 1 
				If nPrcVen == 0 .And. !lPrcDA1 
					If lLjcnvB0 .AND. lR5 .AND. nModulo == 12
						DbSelectArea("SB0")        
						DbSetOrder(1)
						If DbSeek(xFilial("SB0")+cProduto)
							nPrcVen := 0 //SB0->B0_PRV1
						EndIf
					Else
						DbSelectArea("SB1") 
						DbSetOrder(1)
						If MsSeek(xFilial("SB1")+cProduto)
							nPrcVen := 0//SB1->B1_PRV1
						EndIf											
					EndIf
				EndIf	
			Endif	
			lUltResult := .F.
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o tipo for para trazer preco converte para a moeda    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		nFator := Iif( nFator == 0, 1, nFator )	
		
		If nTipo == 1
			nResult := xMoeda(nPrcVen,nMoedaTab,nMoeda,,TamSx3("D2_PRCVEN")[2])
		Else 
			nResult	:= nFator
		Endif
		
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Guarda os ultimos resultados                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lUltResult
			aadd(aUltResult,{cTabPreco,cProduto,nQtde,cCliente,cLoja,nMoeda,cFilAnt,nResult,nFator,lProspect})
			If Len(aUltResult) > MAXSAVERESULT
				aUltResult := aDel(aUltResult,1)
				aUltResult := aSize(aUltResult,MAXSAVERESULT)
			EndIf
		EndIf
	Else
	
		If nTipo == 1
			nResult := aUltResult[nScan][8]
		Else                               
			nResult := aUltResult[nScan][9]	
		Endif	
	EndIf                                           
Endif	
If lQuery
	dbSelectArea(cAliasDA1)
	dbCloseArea()
	dbSelectArea("DA1")
Endif	

RestArea(aAreaSB1)
RestArea(aArea)
Return(nResult)
