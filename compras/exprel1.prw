#Include "Totvs.Ch"
#DEFINE CRLF CHR(10)+CHR(13)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ EXPREL1   ³ Autor ³ Claudio Delcole      ³ Data ³10/03/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ 							                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CLIENTE			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±            
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function EXPREL1()

Local aCampos    := {}
Local aCelulas   := {}

Private cPerg    := "EXPREL1"
Private aHeader  := {}
Private aCols 	 := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSx1(cPerg)	//Ajusta o nome dos parametros 
If Pergunte(cPerg,.T.)
	
	Processa({|lEnd| PROCDADOS(@aCelulas,@aCampos)},"Aguarde...","Pesquisando Dados...")
	MsgRun("Aguarde... Exportando Para MS-Excel...",,{ || ACTBRExcel(aCelulas,aCampos)})
	
Endif

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ EXPREL12  ³ Autor ³ Claudio Delcole      ³ Data ³12/12/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monta os dados para exportação                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PROCDADOS(aCelulas,aCampos)//(aDados),aConta,aCusto)

Local aCampos   := {}
Local aCelulas  := {} 
Local aFiliais	:= {}
Local aDirectory:= {}
Local cFilSUA   := ""
Local cNumSUA   := ""
Local cQuebra	:= ""
Local cQbaFil 	:= ""
Local nVendaB 	:= 0
Local nCanc		:= 0
Local nVendaL 	:= 0
Local nCustoB 	:= 0
Local nCustoC 	:= 0
Local nCustoL 	:= 0
Local nMargem 	:= 0
Local nMarkup 	:= 0
Local nQtdAt  	:= 0
Local nTicket 	:= 0
Local nVlrCusto := 0
Local nCustoIpi := 0
Local nBaseIcm	:= 0
Local VlrLiqAc	:= 0
Local VlrCusAc	:= 0
Local VlrIcmAc	:= 0
Local nVdaBAcu  := 0
Local nCancAcu  := 0
Local nVdaLAcu  := 0
Local nCusBAcu  := 0
Local nCusCAcu  := 0
Local nCusLAcu  := 0
Local nMargAcu	:= 0
Local nMarkAcu	:= 0
Local nTotAtAc  := 0
Local nTotTikAc := 0
Local nMedTikAc	:= 0
Local nPercDesc := 0
Local nBaseIcms := 0
Local nCustTot	:= 0
Local lCabec 	:= .T.
Local lCancela
Local lOk

Private cDirImp	 := ""
Private cARQLOG	 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exclui arquivos Txt.     		                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
aDirectory := Directory("C:\RELATORIO\" + "*.LOG")
For nI := 1 To Len(aDirectory)
	FErase("C:\RELATORIO\"+aDirectory[nI,1])
Next nI
		
cDirImp	 := "C:\RELATORIO\"
cARQLOG	 := cDirImp+"VDAFRANQUIA_CANCELADO_"+DtoS(mv_par03)+"_"+DtoS(mv_par04)+".LOG"

MakeDir(cDirImp)  

cQuery := " SELECT	UA_FILIAL, UA_NUM, UA_CLIENTE, UA_LOJA, UA_OPER, UA_PEDPEND, UA_EMISSAO, UA_STATUS, UA_CANC, UA_VALBRUT, UA_VALMERC, UA_VLRLIQ, UA_VEND, " +CRLF
cQuery += " 		UB_FILIAL, UB_ITEM, UB_NUM, UB_PRODUTO, UB_QUANT, UB_VRUNIT, UB_VLRITEM, UB_BASEICM, UB_PRCTAB, UB_01CANC, UB_01DTCAN, " +CRLF
cQuery += " 		B1_FILIAL, B1_COD, B1_DESC, B1_CUSTD, B1_01PRODP, " +CRLF
cQuery += " 		B4_FILIAL, B4_COD, B4_01MKP, B4_IPI, B4_01VLMON, B4_01VLEMB, B4_01VLFRE " +CRLF
cQuery += " FROM "+RetSqlName("SUA")+" SUA " +CRLF
cQuery += " INNER JOIN "+RetSqlName("SUB")+" SUB ON SUB.D_E_L_E_T_=' ' AND UB_FILIAL=UA_FILIAL AND UB_NUM=UA_NUM " +CRLF
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_=' ' AND B1_COD=UB_PRODUTO " +CRLF
cQuery += " INNER JOIN "+RetSqlName("SB4")+" SB4 ON SB4.D_E_L_E_T_=' ' AND B4_COD=B1_01PRODP " +CRLF
cQuery += " WHERE "+CRLF
cQuery += " 		SUA.D_E_L_E_T_=' ' AND "+CRLF
cQuery += "			(UA_PEDPEND='3' OR UA_PEDPEND='5') AND " +CRLF
cQuery += " 		UA_FILIAL >= '"+mv_par01+"' AND UA_FILIAL <= '"+mv_par02+"' AND " +CRLF
cQuery += " 		UA_EMISSAO >= '"+DtoS(mv_par03)+"' AND UA_EMISSAO <= '"+DtoS(mv_par04)+"' AND " +CRLF
cQuery += " 		UA_VEND <> ' ' " +CRLF
cQuery += " ORDER BY UB_FILIAL,UB_NUM,UB_ITEM " +CRLF

cQuery := ChangeQuery(cQuery)
MsAguarde( { ||dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"TRB",.F.,.T.)},"Aguarde...","Processando Dados...")

dbSelectArea("TRB")
dbGoTop()
cQuebra := TRB->UA_FILIAL+TRB->UA_NUM
ProcRegua(TRB->(RecCount()))

While !Eof()
	IncProc("Gerando Células...")
	
	nPos := Ascan( aFiliais , TRB->UA_FILIAL )
	If nPos==0
		AAdd( aFiliais , TRB->UA_FILIAL )
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona os pedidos totalmente cancelados.			   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	If TRB->UA_CANC=="S" 
		If cQuebra <> TRB->UA_FILIAL+TRB->UA_NUM
			cQuebra  := TRB->UA_FILIAL+TRB->UA_NUM
			lCancela := FilCancAt(TRB->UA_FILIAL+TRB->UA_NUM)
			If lCancela
				nCanc += TRB->UA_VLRLIQ			
			Else
				nCanc += 0
			Endif
			
		Endif
	Endif
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para o campo UB_BASEICM, devido alguns     ³
	//³produtos estao com valores incorretos na base de dados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPercDesc := 0
	nBaseIcms := 0
	If (TRB->UB_01CANC=="S")
		nPercDesc := ( TRB->UA_VLRLIQ  / TRB->UA_VALBRUT )
		nBaseIcms := ( TRB->UB_VLRITEM * nPercDesc )		
	Else
		nBaseIcms := TRB->UB_BASEICM
	Endif
			
	If mv_par05=1 //Analítico
			
		If Len(aCelulas) > 0
			If TRB->UA_FILIAL==cFilSUA .AND. TRB->UA_NUM==cNumSUA //JA EXISTE REGISTRO
			
				SA3->(DbSetOrder(1))
				SA3->(DbSeek(xFilial("SA3")+TRB->UA_VEND))
			
				nCustoIpi	:= TRB->B1_CUSTD * (TRB->B4_IPI/100)
				nCustoFrete	:= (TRB->B1_CUSTD+nCustoIpi) * (TRB->B4_01VLFRE/100)
				nVlrCusto	:= TRB->B1_CUSTD+nCustoIpi+TRB->B4_01VLMON+TRB->B4_01VLEMB+nCustoFrete
			
				AADD(aCelulas,{ "", "", "", "", "", "", TRB->UA_VEND, SA3->A3_NOME, 0, ;
				TRB->UB_FILIAL, TRB->UB_NUM, TRB->UB_PRODUTO, TRB->UB_QUANT, nBaseIcms,TRB->UA_CANC,TRB->UB_01CANC, If(TRB->UB_01CANC=='S',SUBSTR(TRB->UB_01DTCAN,7,2)+"/"+SUBSTR(TRB->UB_01DTCAN,5,2)+"/"+SUBSTR(TRB->UB_01DTCAN,1,4),'') , ;
				TRB->B1_COD, TRB->B1_01PRODP, TRB->B1_DESC, TRB->B1_CUSTD, ;
				TRB->B4_COD, TRB->B4_IPI, TRB->B4_01VLMON, TRB->B4_01VLEMB, TRB->B4_01VLFRE , (TRB->UB_QUANT * nVlrCusto) }) //ADICIONA SOMENTE SUB(ITENS)
				nCustTot += (TRB->UB_QUANT * nVlrCusto)
			Else                                           
			
				SA3->(DbSetOrder(1))
				SA3->(DbSeek(xFilial("SA3")+TRB->UA_VEND))
		
				nCustoIpi	:= TRB->B1_CUSTD * (TRB->B4_IPI/100)
				nCustoFrete	:= (TRB->B1_CUSTD+nCustoIpi) * (TRB->B4_01VLFRE/100)
				nVlrCusto	:= TRB->B1_CUSTD+nCustoIpi+TRB->B4_01VLMON+TRB->B4_01VLEMB+nCustoFrete
			
				AADD(aCelulas,{ TRB->UA_FILIAL+"-"+POSICIONE("SM0",1,cEmpAnt+TRB->UA_FILIAL,"M0_FILIAL"), TRB->UA_NUM, TRB->UA_CLIENTE, TRB->UA_LOJA, TRB->UA_PEDPEND, SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4),TRB->UA_VEND,SA3->A3_NOME,TRB->UA_VLRLIQ,;
				TRB->UB_FILIAL, TRB->UB_NUM, TRB->UB_PRODUTO, TRB->UB_QUANT, nBaseIcms,TRB->UA_CANC,TRB->UB_01CANC, If(TRB->UB_01CANC=='S',SUBSTR(TRB->UB_01DTCAN,7,2)+"/"+SUBSTR(TRB->UB_01DTCAN,5,2)+"/"+SUBSTR(TRB->UB_01DTCAN,1,4),'') ,;
				TRB->B1_COD, TRB->B1_01PRODP, TRB->B1_DESC, TRB->B1_CUSTD, ;
				TRB->B4_COD, TRB->B4_IPI, TRB->B4_01VLMON, TRB->B4_01VLEMB, TRB->B4_01VLFRE , (TRB->UB_QUANT * nVlrCusto) }) //ADICIONA SUA(CABECALHO)
				VlrLiqAc += TRB->UA_VLRLIQ
				nCustTot += (TRB->UB_QUANT * nVlrCusto)
			EndIf
		Else
		           
			SA3->(DbSetOrder(1))
			SA3->(DbSeek(xFilial("SA3")+TRB->UA_VEND))

			nCustoIpi	:= TRB->B1_CUSTD * (TRB->B4_IPI/100)
			nCustoFrete	:= (TRB->B1_CUSTD+nCustoIpi) * (TRB->B4_01VLFRE/100)
			nVlrCusto	:= TRB->B1_CUSTD+nCustoIpi+TRB->B4_01VLMON+TRB->B4_01VLEMB+nCustoFrete

			AADD(aCelulas,{ TRB->UA_FILIAL+"-"+POSICIONE("SM0",1,cEmpAnt+TRB->UA_FILIAL,"M0_FILIAL"), TRB->UA_NUM, TRB->UA_CLIENTE, TRB->UA_LOJA, TRB->UA_PEDPEND, SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4),TRB->UA_VEND,SA3->A3_NOME,TRB->UA_VLRLIQ,;
			TRB->UB_FILIAL, TRB->UB_NUM, TRB->UB_PRODUTO, TRB->UB_QUANT, nBaseIcms,TRB->UA_CANC,TRB->UB_01CANC, If(TRB->UB_01CANC=='S',SUBSTR(TRB->UB_01DTCAN,7,2)+"/"+SUBSTR(TRB->UB_01DTCAN,5,2)+"/"+SUBSTR(TRB->UB_01DTCAN,1,4),'') , ;
			TRB->B1_COD, TRB->B1_01PRODP, TRB->B1_DESC, TRB->B1_CUSTD, ;
			TRB->B4_COD, TRB->B4_IPI, TRB->B4_01VLMON, TRB->B4_01VLEMB, TRB->B4_01VLFRE , (TRB->UB_QUANT * nVlrCusto) }) //ADICIONA SUA(CABECALHO)
			VlrLiqAc += TRB->UA_VLRLIQ
			nCustTot += (TRB->UB_QUANT * nVlrCusto)
		EndIf
		cFilSUA  := TRB->UA_FILIAL
		cNumSUA  := TRB->UA_NUM
		VlrCusAc += TRB->B1_CUSTD
		VlrIcmAc += nBaseIcms
		dbSelectArea("TRB")
		dbSkip()
		
	Else //Sintético
	    
		If lCabec 
			LjWriteLog( cARQLOG, "SITUACAO;FILIAL;EMISSAO;ATEND;ITEM;PRODUTO;DESCRICAO;CUSTO;QUANT;CUSTO_TOTAL;PRECO_VENDA;PRECO_TOTAL" )
			lCabec := .F.
		Endif			
	                  
		nCustoIpi 	:= 0
		nVlrCusto 	:= 0
		nCustoFrete := 0
								
		If Len(cFilSUA) > 0 //Len(aCelulas) > 0
			
			If cFilSUA == TRB->UB_FILIAL //mesma FILIAL - continua				
				If cNumSUA == TRB->UB_NUM //mesmo atendimento - nao carrega valores SUA

					//nCanc		:= nCanc + If( (TRB->UB_01CANC=="S"), nBaseIcms, 0 ) //Itens										
					
					nCustoIpi	:= TRB->B1_CUSTD * (TRB->B4_IPI/100)
					nCustoFrete	:= (TRB->B1_CUSTD+nCustoIpi) * (TRB->B4_01VLFRE/100)
					nVlrCusto	:= TRB->B1_CUSTD+nCustoIpi+TRB->B4_01VLMON+TRB->B4_01VLEMB+nCustoFrete										
					nCustoB 	:= nCustoB + ( nVlrCusto * TRB->UB_QUANT ) 
					
					//nCustoC 	:= nCustoC + If( TRB->UB_01CANC="S", ( nVlrCusto * TRB->UB_QUANT) , 0 )
					
					If TRB->UA_CANC=="S" .And. Empty(TRB->UB_01CANC)
						nCustoC += (nVlrCusto * TRB->UB_QUANT)						
						LjWriteLog( cARQLOG, "|CALL CENTER"+" ; "+TRB->UB_FILIAL+" ; "+SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4)+" ; "+TRB->UB_NUM+" ; "+TRB->UB_ITEM+" ; "+TRB->UB_PRODUTO+" ; "+TRB->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform(TRB->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * TRB->UB_QUANT),"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VLRITEM,"@E 999,999,999.99") )
					
					ElseIf TRB->UA_CANC=="S" .And. TRB->UB_01CANC=="S"
						If TRB->UB_01DTCAN <= DTOS(Mv_Par04)
							nCustoC += (nVlrCusto * TRB->UB_QUANT)						
							LjWriteLog( cARQLOG, "|CALL CENTER"+" ; "+TRB->UB_FILIAL+" ; "+SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4)+" ; "+TRB->UB_NUM+" ; "+TRB->UB_ITEM+" ; "+TRB->UB_PRODUTO+" ; "+TRB->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform(TRB->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * TRB->UB_QUANT),"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VLRITEM,"@E 999,999,999.99") )
						Endif
					
					ElseIf Empty(TRB->UA_CANC) .And. TRB->UB_01CANC=="S"
						If TRB->UB_01DTCAN <= DTOS(Mv_Par04)
							nCustoC += (nVlrCusto * TRB->UB_QUANT)						
							LjWriteLog( cARQLOG, "|GERACAO NCC"+" ; "+TRB->UB_FILIAL+" ; "+SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4)+" ; "+TRB->UB_NUM+" ; "+TRB->UB_ITEM+" ; "+TRB->UB_PRODUTO+" ; "+TRB->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform(TRB->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * TRB->UB_QUANT),"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VLRITEM,"@E 999,999,999.99") )
						Endif
					
					Else
						nCustoC += 0		   
									
					Endif
					
				Else //outro atendimento - carrega valores SUA

					nVendaB := nVendaB + TRB->UA_VLRLIQ //Cabecalho					
					//nCanc	:= nCanc + If( (TRB->UB_01CANC=="S"), nBaseIcms, 0 ) //Itens					
					nVendaL := nVendaB - nCanc //Calculado somente apos agrupamento da FILIAL
					
					nCustoIpi	:= TRB->B1_CUSTD * (TRB->B4_IPI/100)
					nCustoFrete	:= (TRB->B1_CUSTD+nCustoIpi) * (TRB->B4_01VLFRE/100)
					nVlrCusto	:= TRB->B1_CUSTD+nCustoIpi+TRB->B4_01VLMON+TRB->B4_01VLEMB+nCustoFrete										
					nCustoB 	:= nCustoB + ( nVlrCusto * TRB->UB_QUANT  )
					
					//nCustoC := nCustoC + If( TRB->UB_01CANC="S", ( nVlrCusto * TRB->UB_QUANT), 0 )					
					
					If TRB->UA_CANC=="S" .And. Empty(TRB->UB_01CANC)
						nCustoC += (nVlrCusto * TRB->UB_QUANT)						
						LjWriteLog( cARQLOG, "|CALL CENTER"+" ; "+TRB->UB_FILIAL+" ; "+SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4)+" ; "+TRB->UB_NUM+" ; "+TRB->UB_ITEM+" ; "+TRB->UB_PRODUTO+" ; "+TRB->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform(TRB->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * TRB->UB_QUANT),"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VLRITEM,"@E 999,999,999.99") )
					
					ElseIf TRB->UA_CANC=="S" .And. TRB->UB_01CANC=="S"
						If TRB->UB_01DTCAN <= DTOS(Mv_Par04)
							nCustoC += (nVlrCusto * TRB->UB_QUANT)						
							LjWriteLog( cARQLOG, "|CALL CENTER"+" ; "+TRB->UB_FILIAL+" ; "+SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4)+" ; "+TRB->UB_NUM+" ; "+TRB->UB_ITEM+" ; "+TRB->UB_PRODUTO+" ; "+TRB->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform(TRB->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * TRB->UB_QUANT),"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VLRITEM,"@E 999,999,999.99") )
						Endif
					
					ElseIf Empty(TRB->UA_CANC) .And. TRB->UB_01CANC=="S"
						If TRB->UB_01DTCAN <= DTOS(Mv_Par04)
							nCustoC += (nVlrCusto * TRB->UB_QUANT)						
							LjWriteLog( cARQLOG, "|GERACAO NCC"+" ; "+TRB->UB_FILIAL+" ; "+SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4)+" ; "+TRB->UB_NUM+" ; "+TRB->UB_ITEM+" ; "+TRB->UB_PRODUTO+" ; "+TRB->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform(TRB->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * TRB->UB_QUANT),"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VLRITEM,"@E 999,999,999.99") )
						Endif
									
					Else
						nCustoC += 0		   
									
					Endif

					nQtdAt  := nQtdAt + 1 //Contador Cabecalho
					
				EndIf
			
			Else //senao totaliza FILIAL, grava, zera variaveis e grava novos valores
								
				nCustoL := nCustoB - nCustoC
				nMargem := nCustoL / nVendaL
				nMarkup := nVendaL / nCustoL
				nTicket := nVendaB / nQtdAt //nVendaL / nQtdAt
								
				AADD(aCelulas,{ cFilSUA+"-"+POSICIONE("SM0",1,cEmpAnt+cFilSUA,"M0_FILIAL"), nVendaB, nCanc, nVendaL, nCustoB, nCustoC, nCustoL, nMargem, nMarkup, nQtdAt, nTicket })
				
				//Acumulados dos Valores Sintetico
				nVdaBAcu  += nVendaB
				nCancAcu  += nCanc
				nVdaLAcu  += nVendaL
				nCusBAcu  += nCustoB
				nCusCAcu  += nCustoC
				nCusLAcu  += nCustoL
				nTotAtAc  += nQtdAt
				nTotTikAc += nTicket				
				nMargAcu  += nMargem
				nMarkAcu  += nMarkup
				
				nVendaB 	:= 0
				nCanc		:= 0
				nVendaL 	:= 0
				nCustoB 	:= 0
				nCustoC 	:= 0
				nCustoL 	:= 0
				nMargem 	:= 0
				nMarkup 	:= 0
				nQtdAt  	:= 0
				nTicket 	:= 0
				nCustoIpi 	:= 0
				nVlrCusto 	:= 0
				nCustoFrete := 0
				
				nVendaB 	:= nVendaB + TRB->UA_VLRLIQ //Cabecalho
				//nCanc		:= nCanc + If( (TRB->UB_01CANC=="S"), nBaseIcms, 0 ) //Itens								
				nCanc 		+= FiltraNCC( TRB->UB_FILIAL )
				nVendaL 	:= nVendaB - nCanc //Calculado somente apos agrupamento da FILIAL
				
				nCustoIpi	:= TRB->B1_CUSTD * (TRB->B4_IPI/100)
				nCustoFrete	:= (TRB->B1_CUSTD+nCustoIpi) * (TRB->B4_01VLFRE/100)
				nVlrCusto	:= TRB->B1_CUSTD+nCustoIpi+TRB->B4_01VLMON+TRB->B4_01VLEMB+nCustoFrete
				nCustoB 	:= nCustoB + ( nVlrCusto * TRB->UB_QUANT ) 
				
				//nCustoC 	:= nCustoC + If( TRB->UB_01CANC="S", ( nVlrCusto * TRB->UB_QUANT), 0 )		
				
				//Custo dos Produtos dos pedidos cancelados no periodo informado, mas com emissao anterior ao periodo
				nCustoC 	+= FilPedCanc( TRB->UB_FILIAL )				
				
				If TRB->UA_CANC=="S" .And. Empty(TRB->UB_01CANC)
					nCustoC += (nVlrCusto * TRB->UB_QUANT)						
					LjWriteLog( cARQLOG, "|CALL CENTER"+" ; "+TRB->UB_FILIAL+" ; "+SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4)+" ; "+TRB->UB_NUM+" ; "+TRB->UB_ITEM+" ; "+TRB->UB_PRODUTO+" ; "+TRB->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform(TRB->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * TRB->UB_QUANT),"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VLRITEM,"@E 999,999,999.99") )
					
				ElseIf TRB->UA_CANC=="S" .And. TRB->UB_01CANC=="S"
					If TRB->UB_01DTCAN <= DTOS(Mv_Par04)
						nCustoC += (nVlrCusto * TRB->UB_QUANT)						
						LjWriteLog( cARQLOG, "|CALL CENTER"+" ; "+TRB->UB_FILIAL+" ; "+SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4)+" ; "+TRB->UB_NUM+" ; "+TRB->UB_ITEM+" ; "+TRB->UB_PRODUTO+" ; "+TRB->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform(TRB->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * TRB->UB_QUANT),"@E 999,999,999.99") +" ; "+Transform(TRB->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VLRITEM,"@E 999,999,999.99"))
					Endif
					
				ElseIf Empty(TRB->UA_CANC) .And. TRB->UB_01CANC=="S"
					If TRB->UB_01DTCAN <= DTOS(Mv_Par04)
						nCustoC += (nVlrCusto * TRB->UB_QUANT)						
						LjWriteLog( cARQLOG, "|GERACAO NCC"+" ; "+TRB->UB_FILIAL+" ; "+SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4)+" ; "+TRB->UB_NUM+" ; "+TRB->UB_ITEM+" ; "+TRB->UB_PRODUTO+" ; "+TRB->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform(TRB->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * TRB->UB_QUANT),"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VLRITEM,"@E 999,999,999.99") )
					Endif
					
				Else
					nCustoC += 0		   
									
				Endif

				nQtdAt  	:= nQtdAt + 1 //Contador Cabecalho
								
			EndIf

		Else //primeira carga array

			nVendaB 	:= nVendaB + TRB->UA_VLRLIQ //Cabecalho
			//nCanc		:= nCanc + If( (TRB->UB_01CANC=="S"), nBaseIcms, 0 ) //Itens			
			nCanc 		+= FiltraNCC( TRB->UB_FILIAL )
			nVendaL 	:= nVendaB - nCanc //Calculado somente apos agrupamento da FILIAL
			
			nCustoIpi	:= TRB->B1_CUSTD * (TRB->B4_IPI/100)
			nCustoFrete	:= (TRB->B1_CUSTD+nCustoIpi) * (TRB->B4_01VLFRE/100)
			nVlrCusto	:= TRB->B1_CUSTD+nCustoIpi+TRB->B4_01VLMON+TRB->B4_01VLEMB+nCustoFrete
			nCustoB 	:= nCustoB + ( nVlrCusto * TRB->UB_QUANT ) 

			//nCustoC 	:= nCustoC + If( TRB->UB_01CANC="S", ( nVlrCusto * TRB->UB_QUANT ), 0 )
			
			//Custo dos Produtos dos pedidos cancelados no periodo informado, mas com emissao anterior ao periodo
			nCustoC 	+= FilPedCanc( TRB->UB_FILIAL )				
			
			If TRB->UA_CANC=="S" .And. Empty(TRB->UB_01CANC)
				nCustoC += (nVlrCusto * TRB->UB_QUANT)						
				LjWriteLog( cARQLOG, "|CALL CENTER"+" ; "+TRB->UB_FILIAL+" ; "+SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4)+" ; "+TRB->UB_NUM+" ; "+TRB->UB_ITEM+" ; "+TRB->UB_PRODUTO+" ; "+TRB->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform(TRB->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * TRB->UB_QUANT),"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VLRITEM,"@E 999,999,999.99") )
					
			ElseIf TRB->UA_CANC=="S" .And. TRB->UB_01CANC=="S"
				If TRB->UB_01DTCAN <= DTOS(Mv_Par04)
					nCustoC += (nVlrCusto * TRB->UB_QUANT)						
					LjWriteLog( cARQLOG, "|CALL CENTER"+" ; "+TRB->UB_FILIAL+" ; "+SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4)+" ; "+TRB->UB_NUM+" ; "+TRB->UB_ITEM+" ; "+TRB->UB_PRODUTO+" ; "+TRB->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform(TRB->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * TRB->UB_QUANT),"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VLRITEM,"@E 999,999,999.99") )
				Endif
					
			ElseIf Empty(TRB->UA_CANC) .And. TRB->UB_01CANC=="S"
				If TRB->UB_01DTCAN <= DTOS(Mv_Par04)
					nCustoC += (nVlrCusto * TRB->UB_QUANT)						
					LjWriteLog( cARQLOG, "|GERACAO NCC"+" ; "+TRB->UB_FILIAL+" ; "+SUBSTR(TRB->UA_EMISSAO,7,2)+"/"+SUBSTR(TRB->UA_EMISSAO,5,2)+"/"+SUBSTR(TRB->UA_EMISSAO,1,4)+" ; "+TRB->UB_NUM+" ; "+TRB->UB_ITEM+" ; "+TRB->UB_PRODUTO+" ; "+TRB->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform(TRB->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * TRB->UB_QUANT),"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform(TRB->UB_VLRITEM,"@E 999,999,999.99") )
				Endif
					
			Else
				nCustoC += 0		   
									
			Endif
			
			nQtdAt  	:= nQtdAt + 1 //Contador Cabecalho
			
		EndIf
				
		cFilSUA := TRB->UA_FILIAL
		cNumSUA := TRB->UA_NUM
		dbSelectArea("TRB")
		dbSkip()
	EndIf
	
EndDo

If nVendaB > 0 //Apos final arquivo, verifica e grava valor acumulado
	nVendaL := nVendaB - nCanc
	nCustoL := nCustoB - nCustoC
	nMargem := nCustoL / nVendaL                                           '
	nMarkup := nVendaL / nCustoL
	nTicket := nVendaB / nQtdAt //nVendaL / nQtdAt 
	AADD(aCelulas,{ cFilSUA+"-"+POSICIONE("SM0",1,cEmpAnt+cFilSUA,"M0_FILIAL"), nVendaB, nCanc, nVendaL, nCustoB, nCustoC, nCustoL, nMargem, nMarkup, nQtdAt, nTicket })
	
	//Acumulados dos Valores Sintetico
	nVdaBAcu  += nVendaB
	nCancAcu  += nCanc
	nVdaLAcu  += nVendaL
	nCusBAcu  += nCustoB
	nCusCAcu  += nCustoC
	nCusLAcu  += nCustoL
	nTotAtAc  += nQtdAt
	nTotTikAc += nTicket	
	nMargAcu  += nMargem
	nMarkAcu  += nMarkup
EndIf

//Cria celula com Acumulados do Valores Analitico
If VlrLiqAc > 0
	AADD(aCelulas,{"TOTAL","","","","","","","",VlrLiqAc,"","","",0,VlrIcmAc,"","","","","","",VlrCusAc,"",0,0,0,0,nCustTot})
Endif

If nVdaBAcu > 0
	nMargAcu  := nCusLAcu  / nVdaLAcu
	nMarkAcu  := nVdaLAcu  / nCusLAcu
	nMedTikAc := nTotTikAc / Len(aFiliais)
	AADD(aCelulas,{"TOTAL",nVdaBAcu,nCancAcu,nVdaLAcu,nCusBAcu,nCusCAcu,nCusLAcu,nMargAcu,nMarkAcu,nTotAtAc,nMedTikAc})
Endif

AADD(aCampos, { "SUA" , "UA_FILIAL" 	, "FILIAL"		} )
AADD(aCampos, { "SUA" , "UA_NUM" 		, "ATENDIMENT"	} )
AADD(aCampos, { "SUA" , "UA_CLIENTE" 	, "CLIENTE"		} )
AADD(aCampos, { "SUA" , "UA_LOJA" 		, "LOJA"		} )
AADD(aCampos, { "SUA" , "UA_PEDPEND" 	, "STATUS_ATE"	} )
AADD(aCampos, { "SUA" , "UA_EMISSAO" 	, "DATA_EMIS"	} )
AADD(aCampos, { "SUA" , "UA_VEND" 		, "COD_VEND"	} )
AADD(aCampos, { "SA3" , "A3_NOME" 		, "NOM_VEND"	} )
AADD(aCampos, { "SUA" , "UA_VLRLIQ" 	, "VALOR"		} )
AADD(aCampos, { "SUB" , "UB_FILIAL" 	, "FILIAL_IT"	} )
AADD(aCampos, { "SUB" , "UB_NUM" 		, "NUMERO"		} )
AADD(aCampos, { "SUB" , "UB_PRODUTO" 	, "COD_PRODUT"	} )
AADD(aCampos, { "SUB" , "UB_QUANT" 		, "QUANTIDADE"	} )
AADD(aCampos, { "SUB" , "UB_BASEICM" 	, "BASE_ICMS"	} )
AADD(aCampos, { "SUA" , "UA_CANC" 		, "CANC_CALL"	} )
AADD(aCampos, { "SUB" , "UB_01CANC" 	, "CANCELADO"	} )
AADD(aCampos, { "SUB" , "UB_01DTCAN" 	, "DATA_CANC"	} )
AADD(aCampos, { "SB1" , "B1_COD" 		, "CODIGO"		} )
AADD(aCampos, { "SB1" , "B1_01PRODP" 	, "PRODUT_PAI"	} )
AADD(aCampos, { "SB1" , "B1_DESC" 		, "DESCRICAO"	} )
AADD(aCampos, { "SB1" , "B1_CUSTD" 		, "CUSTO"		} )
AADD(aCampos, { "SB4" , "B4_COD" 		, "CODIGO_PAI"	} )
AADD(aCampos, { "SB4" , "B4_IPI" 		, "IPI"			} )
AADD(aCampos, { "SB4" , "B4_01VLMON" 	, "VAL_MONTAG"	} )
AADD(aCampos, { "SB4" , "B4_01VLEMB" 	, "VAL_EMBALA"	} )
AADD(aCampos, { "SB4" , "B4_01VLFRE" 	, "VAL_FRETE"	} )
AADD(aCampos, { "SD2" , "D2_CUSTO1" 	, "CUST_TOTAL"	} )
            
TRB->(dbCloseArea())

//Return(aDados)
Return(aCelulas,aCampos)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ACTBRExcel³ Autor ³ Larson Zordan         ³ Data ³26/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exporta a planilha de trabalho para o Excel.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ACTBRExcel()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MAURANO & MAURANO                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ACTBRExcel(aCelulas,aCampos)//(aDados)
Local aAreaAnt	:= GetArea()
Local aStru		:= {}
Local cArquivo	:= CriaTrab(,.F.)
Local cDirDocs	:= MsDocPath() 
Local cPath    	:= AllTrim(GetTempPath())
Local oExcelApp
Local nX, nZ, nY

If mv_par05=1 //Analitico
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2)) //X3_CAMPO
	For z:=1 to Len(aCampos)
		If SX3->( dbSeek(aCampos[z,2]) )
			If SX3->X3_TIPO=="D"
				AADD( aStru, { aCampos[z,3] , "C", 10, SX3->X3_DECIMAL } )
			Else
				AADD( aStru, { aCampos[z,3] , SX3->X3_TIPO, If(Alltrim(SX3->X3_CAMPO)="UA_FILIAL",30,SX3->X3_TAMANHO), SX3->X3_DECIMAL } )
			EndIf
		EndIf
	Next z
Else //Sintetico
	//nVendaB, nCanc, nVendaL, nCustoB, nCustoC, nCustoL, nMargem, nMarkup, nQtdAt, nTicket
	aAdd( aStru , { "FILIAL"        	,           "C",      30,       0 } ) //maximo 10 caracteres
	aAdd( aStru , { "VEND_BRUTA"   		,           "N",      14,       2 } )
	aAdd( aStru , { "VEND_CANCE" 		,           "N",      14,       2 } )
	aAdd( aStru , { "VEND_LIQUI" 		,           "N",      14,       2 } )
	aAdd( aStru , { "CUSTO_BRUT"    	,           "N",      14,       2 } )
	aAdd( aStru , { "CUSTO_CANC"   		,           "N",      14,       2 } )
	aAdd( aStru , { "CUSTO_LIQU" 		,           "N",      14,       2 } )
	aAdd( aStru , { "MARGEM" 			,           "N",      14,       2 } )
	aAdd( aStru , { "MARKUP" 			,           "N",      14,       2 } )
	aAdd( aStru , { "QTD_ATEND"			,           "N",      14,       2 } )
	aAdd( aStru , { "TICKET_MED"		,           "N",      14,       2 } )
EndIf


dbCreate(cDirDocs+"\"+cArquivo,aStru,"DBFCDX")
dbUseArea(.T.,,cDirDocs+"\"+cArquivo,cArquivo,.F.,.F.)

dbSelectArea(cArquivo)

For nX := 1 To Len(aCelulas)//(aDados)
            RecLock(cArquivo, .T.)
            For nZ := 1 To Len(aStru)
                        &(aStru[nZ, 1]) := aCelulas[nX, nZ]//aDados[nX, nZ]
            Next nZ 
            MsUnLock()
Next nZ

dbCloseArea()

CpyS2T( cDirDocs+"\"+cArquivo+".DBF" , cPath, .T. )

If ! ApOleClient( 'MsExcel' ) 
            MsgStop( "MS-Excel NÃO Instalado ! ")
Else
            oExcelApp := MsExcel():New()
            oExcelApp:WorkBooks:Open( cPath+cArquivo+".DBF" )
            oExcelApp:SetVisible(.T.)
EndIf

RestArea(aAreaAnt)

Return

//Verifica/Inclui perguntas no SX1
Static Function AjustaSX1(cPerg)

Local aArea    := GetArea()
Local aHlpPor1 := {"Informe a Filial de Origem Inicial"}
Local aHlpEsp1 := {"Informe el Sucursal Origen Inicial"}
Local aHlpIng1 := {"Enter the First Branch Origin"}

Local aHlpPor2 := {"Informe a Filial de Origem Final"}
Local aHlpEsp2 := {"Informe el Sucursal Origen Final"}
Local aHlpIng2 := {"Enter the Last Branch Origin "}

Local aHlpPor3 := {"Informe a Data de Emissão Inicial"}
Local aHlpEsp3 := {"Informe la Data Inicial"}
Local aHlpIng3 := {"Enter the First Date"}

Local aHlpPor4 := {"Informe a Data de Emissão Final"}
Local aHlpEsp4 := {"Informe la Data Final"}
Local aHlpIng4 := {"Enter the Last Date"}               

Local aHlpPor5 := {"Informe o Tipo de Processamento: 1=Analítico(Detalhado) ou 2=Sintético(Resumido)"}
Local aHlpEsp5 := {"Informe el Tipo"}
Local aHlpIng5 := {"Enter the Processing Type"}                      

dbSelectArea("SX1")
SX1->(DbSetOrder(1))
SX1->(dbSeek(cPerg))
If !Found()
	PutSx1( cPerg,"01","Filial De ?" 	  ,"Filial De ?"	 	 ,"Filial De ?"		 ,"mv_ch1","C",6,0,0,"G","",""   ,"","","mv_par01","","","","","","","","","","","","","","","","",aHlpPor1,aHlpIng1,aHlpEsp1)
	PutSx1( cPerg,"02","Filial Ate ?"	  ,"Filial Ate ?"   	 ,"Filial Ate ?"	 ,"mv_ch2","C",6,0,0,"G","",""   ,"","","mv_par02","","","","","","","","","","","","","","","","",aHlpPor2,aHlpIng2,aHlpEsp2)
	PutSx1( cPerg,"03","Dt.Emissão De ?"  ,"Dt.Emissão De ?"     ,"Dt.Emissão De ?"  ,"mv_ch3","D",8,0,0,"G","",""   ,"","","mv_par03","","","","","","","","","","","","","","","","",aHlpPor3,aHlpIng3,aHlpEsp3)
	PutSx1( cPerg,"04","Dt.Emissão Ate ?" ,"Dt.Emissão Ate ?"    ,"Dt.Emissão Ate ?" ,"mv_ch4","D",8,0,0,"G","",""   ,"","","mv_par04","","","","","","","","","","","","","","","","",aHlpPor4,aHlpIng4,aHlpEsp4)
	PutSx1( cPerg,"05","Tipo ?" 		  ,"Tipo ?"    			 ,"Tipo ?" 			 ,"mv_ch5","C",1,0,0,"C","",""   ,"","","mv_par05","Analítico","Analítico","Analítico","","Sintético","Sintético","Sintético","","","","","","","","","",aHlpPor5,aHlpIng5,aHlpEsp5)
EndIf
RestArea(aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FilPedCanc  ºAutor  ³Microsiga         º Data ³  13/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o valor dos pedidos cancelados nos meses anterioresº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FilPedCanc( cFilAtu ) 

Local cAlias 	:= GetNextAlias()
Local cQuery 	:= ""
Local nNewValor	:= 0
Local nVlrAbat	:= 0
Local nTotIt	:= 0
Local nPercen	:= 0
Local nVlrNCC	:= 0
Local nVlrCanc	:= 0
Local nCustoIpi	:= 0
Local nCustoFrete:=0
Local nVlrCusto:= 0

//cQuery += " SELECT UA_FILIAL FILIAL,UA_VEND VENDEDOR, UA_EMISSAO EMISSAO,UB_NUM PEDIDO,UA_DESCONT DESCONTO,UA_VALMERC VALOR_BRUTO,SUM(UB_VLRITEM) VALOR "
cQuery += " SELECT UA_FILIAL,UA_EMISSAO,UB_NUM,UB_ITEM,UB_PRODUTO,UB_QUANT,UB_VRUNIT,UB_VLRITEM,B1_DESC,B1_CUSTD,B4_IPI,B4_01VLMON,B4_01VLEMB,B4_01VLFRE
cQuery += " FROM "+RetSqlName("SUB")+" SUB "
cQuery += " INNER JOIN "+RetSqlName("SUA")+" SUA ON UA_FILIAL = '"+cFilAtu+"' AND UA_NUM=UB_NUM AND UA_EMISSAO < '"+DtoS(mv_par03)+"' AND SUA.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_=' ' AND B1_COD=UB_PRODUTO "
cQuery += " INNER JOIN "+RetSqlName("SB4")+" SB4 ON SB4.D_E_L_E_T_=' ' AND B4_COD=B1_01PRODP "
cQuery += " WHERE "
cQuery += " UB_FILIAL = '"+cFilAtu+"' "
cQuery += " AND UB_01DTCAN BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "
cQuery += " AND UB_01CANC = 'S' "
cQuery += " AND SUB.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY UA_FILIAL,UB_NUM,UB_ITEM"
//cQuery += " AND UA_CANC   =  ' ' "
//cQuery += " GROUP BY UA_FILIAL,UA_VEND,UA_EMISSAO,UB_NUM,UA_DESCONT,UA_VALMERC "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

TcSetField(cAlias,"EMISSAO","D",TamSx3("UA_EMISSAO")[1],TamSx3("UA_EMISSAO")[2])

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())                                  
	
	/*
	If (cAlias)->DESCONTO > 0
		nPercen	 := Round((cAlias)->DESCONTO/(cAlias)->VALOR_BRUTO,2)	 	
		nVlrAbat := Round(((cAlias)->VALOR*nPercen),2)		
		nNewValor:= Round((cAlias)->VALOR-nVlrAbat,2)
	Else
		nNewValor := (cAlias)->VALOR
	Endif
	nVlrCanc += nNewValor
	*/
	
	nCustoIpi	:= (cAlias)->B1_CUSTD * ((cAlias)->B4_IPI/100)
	nCustoFrete	:= ((cAlias)->B1_CUSTD+nCustoIpi) * ((cAlias)->B4_01VLFRE/100)
	nVlrCusto	:= (cAlias)->B1_CUSTD+nCustoIpi+(cAlias)->B4_01VLMON+(cAlias)->B4_01VLEMB+nCustoFrete										
	nVlrCanc	+= nVlrCusto * (cAlias)->UB_QUANT
	
	LjWriteLog( cARQLOG, "|GERACAO NCC"+" ; "+(cAlias)->UA_FILIAL+" ; "+SUBSTR((cAlias)->UA_EMISSAO,7,2)+"/"+SUBSTR((cAlias)->UA_EMISSAO,5,2)+"/"+SUBSTR((cAlias)->UA_EMISSAO,1,4)+" ; "+(cAlias)->UB_NUM+" ; "+(cAlias)->UB_ITEM+" ; "+(cAlias)->UB_PRODUTO+" ; "+(cAlias)->B1_DESC+" ; "+Transform(nVlrCusto,"@E 999,999.99")+" ; "+Transform((cAlias)->UB_QUANT,"@E 999999.99")+" ; "+Transform((nVlrCusto * (cAlias)->UB_QUANT),"@E 999,999,999.99")+" ; "+Transform((cAlias)->UB_VRUNIT,"@E 999,999,999.99")+" ; "+Transform((cAlias)->UB_VLRITEM,"@E 999,999,999.99") )

	(cAlias)->(DbSkip())
End
(cAlias)->( dbCloseArea() )

Return nVlrCanc

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FiltraNCC  ºAutor  ³Microsiga         º Data ³  21/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna todas as NCC gerados no periodo informado.		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FiltraNCC( cFilAtu ) 

Local cAlias 	:= GetNextAlias()
Local cQuery 	:= ""
Local cLocDep	:= GetMv("MV_SYLOCDP",,"100001")
Local nVlrCanc	:= 0
Local cDirImp	:= "C:\RELATORIO\"
Local cARQLOG	:= cDirImp+"FINANCEIRO_NCC_"+DtoS(mv_par03)+"_"+DtoS(mv_par04)+".LOG"

MakeDir(cDirImp)  

LjWriteLog( cARQLOG, "SITUACAO;FILIAL_ORIG;FILIAL;PREFIXO;NUMERO;PARCELA;TIPO;EMISSAO;VALOR" )

cQuery += " SELECT FILIAL,PREFIXO,NUMERO,PARCELA,TIPO,EMISSAO,VALOR FROM ("+CRLF
cQuery += " SELECT DISTINCT"+CRLF
cQuery += " 		E1_FILIAL FILIAL,"+CRLF
cQuery += " 		E1_PREFIXO PREFIXO,"+CRLF
cQuery += " 		E1_NUM NUMERO,"+CRLF
cQuery += " 		E1_PARCELA PARCELA,"+CRLF
cQuery += " 		E1_TIPO TIPO,"+CRLF
cQuery += " 		E1_EMISSAO EMISSAO,"+CRLF
cQuery += " 		E1_VALOR VALOR"+CRLF
cQuery += " FROM "+RetSqlName("SUB")+" SUB"+CRLF
cQuery += " INNER JOIN "+RetSqlName("SUA")+" SUA ON UA_NUM=UB_NUM AND SUB.D_E_L_E_T_ = ' '"+CRLF
cQuery += " INNER JOIN "+RetSqlName("SE1")+" SE1 ON E1_FILIAL=UB_XFILPED AND E1_NUM=UB_NUMPV AND E1_TIPO='NCC' AND SE1.D_E_L_E_T_ = ' '"+CRLF
cQuery += " WHERE"+CRLF
cQuery += " UB_FILIAL = '"+cFilAtu+"' AND"+CRLF
cQuery += " UB_FILIAL=UA_FILIAL AND"+CRLF
cQuery += " UB_01CANC = 'S' AND"+CRLF
cQuery += " UB_01DTCAN BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' AND "+CRLF
cQuery += " UB_XFILPED = '"+cLocDep+"' AND"+CRLF
cQuery += " SUB.D_E_L_E_T_ = ' '"+CRLF

cQuery += " UNION ALL"+CRLF

cQuery += " SELECT"+CRLF
cQuery += " 		E1_FILIAL FILIAL,"+CRLF
cQuery += " 		E1_PREFIXO PREFIXO,"+CRLF
cQuery += " 		E1_NUM NUMERO,"+CRLF
cQuery += " 		E1_PARCELA PARCELA,"+CRLF
cQuery += " 		E1_TIPO TIPO,"+CRLF
cQuery += " 		E1_EMISSAO EMISSAO,"+CRLF
cQuery += " 		E1_VALOR VALOR"+CRLF
cQuery += " FROM "+RetSqlName("SE1")+" SE1"+CRLF
cQuery += " WHERE"+CRLF
cQuery += " E1_FILIAL = '"+cFilAtu+"' AND"+CRLF
cQuery += " E1_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' AND"+CRLF
cQuery += " E1_TIPO = 'NCC' AND"+CRLF
cQuery += " SE1.D_E_L_E_T_ = ' '"+CRLF
cQuery += " ) AS TABELA"+CRLF
cQuery += " ORDER BY FILIAL,PREFIXO,NUMERO,PARCELA,TIPO, VALOR"+CRLF

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())                                  
	
	nVlrCanc += (cAlias)->VALOR
	
	LjWriteLog( cARQLOG, "|FINANCEIRO "+" ; "+cFilAtu+" ; "+(cAlias)->FILIAL+" ; "+SUBSTR((cAlias)->EMISSAO,7,2)+"/"+SUBSTR((cAlias)->EMISSAO,5,2)+"/"+SUBSTR((cAlias)->EMISSAO,1,4)+" ; "+(cAlias)->PREFIXO+" ; "+(cAlias)->NUMERO+" ; "+(cAlias)->PARCELA+" ; "+(cAlias)->TIPO+" ; "+Transform((cAlias)->VALOR,"@E 999,999,999.99") )

	(cAlias)->(DbSkip())
End
(cAlias)->( dbCloseArea() )

Return nVlrCanc

Static Function FilCancAt(cOrcamento)

Local nCont  	:= 0
Local nCancel	:= 0
Local lCancel	:= .T.

DbSelectArea("SUB")
DbSetOrder(1)
DbSeek(cOrcamento)
While !Eof() .And. SUB->UB_FILIAL+SUB->UB_NUM == cOrcamento
	
	nCont += 1
	If SUB->UB_01CANC=="S"
		nCancel	+= 1
	Endif
	
	DbSelectArea("SUB")
	DbSkip()
End

If nCont==nCancel
	lCancel	:= .F.
Endif

Return lCancel