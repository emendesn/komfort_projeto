#include 'protheus.ch'
#include 'parmtype.ch'
#Include "RwMake.CH"
#include "tbiconn.ch"
#Include "Topconn.ch"

/*//////////////////////////////////////////////////////////////////////////
Ponto de entrada da rotina Documento de Entrada
Executado ao termino da inclusao ou classificaçao do documento de entrada
*/////////////////Deo///23/12/17///////////K023////////////////////////////

/*
Nao é possível usar esse P.E devido já existir no patch tttp120_gcv_full_20180112.ptm
do template do modulo SIGAGCV

Ellen 23.03.2018
*/

User function MT103FIM()

Local nOpcX := PARAMIXB[1]   //2-Visualizar,3-Incluir",4-Classificar,5-Excluir
Local nOpc  := PARAMIXB[2]	 //1-Confirmou , 2- Cancelou

//Liberar pedidos que estão bloqueados, aguardando estoque
/*
u_KMCOMA06(cNFiscal, cSerie, cA100For, cLoja,nOpcX,nOpc)
*/

Local aArea    	:= GetArea()
Local aAreaSD1 	:= {}
Local aNFOri	:= {}	//#RVC20180515.n
Local aSD2		:= {}	//#RVC20180515.n
Local aSE5		:= {}
Local cNFD1		:= ""
Local nVlrDev	:= 0
Local nVlrTmp	:= 0
Local lRet		:= .T.
Local nPos		:= 0
Local _lAgeIt  := .F.//#CMG20181015.n
Local _aCabSDA    := {}
Local _aItSDB     := {}
Local _aItensSDB  := {}
Local _nx      	  := 0
Local aCab		  := {}
Local aItem		  := {}
Local xProduto
Local nItemEnd	:= 1
Local _aSDARec  := {}
Local cQuery    := ""
Local lEnder    := .F.
Private lMsErroAuto := .F.//#CMG20181015.n
Private xProd


If nOpcX == 3 .and. nOpc <> 2
	If SF1->F1_TIPO <> "N"
		SD1->(dbSetOrder(1))
		SD1->(dbGoTop())
		SD1->(dbSeek(xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)))
		While SD1->(!EOF()) .AND.  SD1->(D1_FILIAL + D1_DOC + D1_SERIE) == SF1->(F1_FILIAL + F1_DOC + F1_SERIE)
			If !Empty(SD1->D1_NFORI) .AND. !Empty(SF1->F1_01SAC)
				Aadd(aNFOri,{SD1->D1_NFORI, SD1->D1_SERIORI, SD1->D1_FORNECE, SD1->D1_LOJA, SD1->D1_COD, SD1->D1_ITEM, SF1->F1_01SAC, SD1->D1_TOTAL})
			EndIf		  //     1                 2                3              4              5            6               7            8
			SD1->(dbSkip())
		EndDo
		//	EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³GERAÇÃO DE TIT. NCC DE CASOS DE EMPRESTIMO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aNFOri)
			SD2->(dbSetOrder(3))
			SD2->(dbGoTop())
			For nA := 1 to Len(aNFOri)
				//                   D2_FILIAL +  D2_DOC             + D2_SERIE      + D2_CLIENTE    + D2_LOJA       + D2_COD    	 + D2_ITEM
				If SD2->(dbSeek(xFilial("SD2") + SD2->(aNFOri[nA][1] + aNFOri[nA][2] + aNFOri[nA][3] + aNFOri[nA][4] + aNFOri[nA][5] + Right(aNFOri[nA][6],2))))
					//		   NF			,Num SAC	  ,Valor
					Aadd(aSD2,{aNFOri[nA][1],aNFOri[nA][7],aNFOri[nA][8]})
				EndIf
				SD2->(dbSkip())
			Next
		EndIf
		If Len(aSD2) > 2
			For nB := 1 to Len(aSD2)
				cNFD1 	:= aSD2[nB][1]
				nVlrDev	:= aSD2[nB][3]
				For nC := 2 to Len(aSD2)
					If aSD2[nC][1] == cNFD1
						nVlrTmp += nVlrDev
					EndIf
				Next
				If Empty(aSE5)
					Aadd(aSE5,{cNFD1,nVlrTmp})
				Else
					If AScan(aSE5,{|x| AllTrim(x[1]) == AllTrim(aSD2[nB][1])}) > 0
						LOOP
					EndIf
					Aadd(aSE5,{cNFD1,nVlrTmp})
				EndIf
			Next
		ElseIf !Empty(aSD2)
			If Empty(aSE5)
				Aadd(aSE5,{aSD2[1][1],aSD2[1][3]})
			Else
				If AScan(aSE5,{|x| AllTrim(x[1]) == AllTrim(aSD2[1][1])}) == 0
					Aadd(aSE5,{aSD2[1][1],aSD2[1][3]})
				EndIf
			EndIf
		EndIf
		If !Empty(aSE5)
			For nD := 1 to Len(aSE5)
				FwMsgRun( ,{|| U_KMSACA9A(aSE5[nD],3)}, , "Baixando a(s) NDC(s) de empréstimo ("+ cValToChar(nD) +"/"+ cValToChar(Len(aSE5)) +"), favor aguarde..." )
			Next
		EndIf
	EndIf
	
ElseIf nOpcX == 4 .and. nOpc <> 2
	
	If SF1->F1_TIPO == "N" .OR. SF1->F1_TIPO == "D"
		
		cQuery:=" SELECT D1_FILIAL, D1_DOC, D1_LOCAL, D1_NUMSEQ, D1_COD, D1_QUANT, D1_LOJA, D1_FORNECE, D1_SERIE, D1_ITEM FROM "+RETSQLNAME("SD1")+ " SD1 "
		cQuery+=" WHERE SD1.D_E_L_E_T_='' AND SD1.D1_DOC='"+SF1->F1_DOC+"' AND SD1.D1_SERIE='"+SF1->F1_SERIE+"' AND "
		cQuery+=" SD1.D1_FORNECE='"+SF1->F1_FORNECE+"' AND SD1.D1_LOJA='"+SF1->F1_LOJA+"'"
		
		cQuery := ChangeQuery(cQuery)

		if select("TRX") > 0
			TRX->(DBCloseArea())
		EndIf
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRX",.T.,.T.)
		
		TRX->(DBSELECTAREA("TRX"))
		TRX->(dbGoTop())
		
		If Localiza(TRX->D1_COD)
			_lAgeIt := .T.
		Endif
		If _lAgeIt
			If MsgYesNo("Existem itens que podem ser endereçados automaticamente, deseja realizar o agendamento?","ENDEAUT")
				lEnder:= .t.
			EndIf
		EndIf
		
		TRX->(DBSELECTAREA("TRX"))
		cQuery:=""
		While TRX->(!EOF()) .And. (TRX->D1_FILIAL+TRX->D1_DOC+TRX->D1_SERIE+TRX->D1_FORNECE+TRX->D1_LOJA) == SF1->(xFilial("SF1")+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
			
			aCab     := {}
			aIteM    := {}
			aRet	 := {}
			_aSDARec := {}
			
			aAreaSD1 := SD1->(GetArea())
			
			If Select("TRB")>0
				TRB->( dbCloseArea() )
			Endif
			
			cQuery:=" SELECT ZL2_NOTA DOC, ZL2_SERIE SERIE, ZL2_COD COD, ZL2_ITEMNF ITEM, ZL2_LOCAL ARMAZEM, "
			cQuery+=" ZL2_LOCALI ENDERE, ZL2_QUANT QUANT, ZL2_FORNE FORNE, ZL2_ITEMNF, ZL2_LOJA LOJA FROM "+RETSQLNAME("ZL2")+ " (NOLOCK) ZL2 "
			cQuery+=" WHERE ZL2.ZL2_QUANT <> 0 AND  ZL2.D_E_L_E_T_='' AND ZL2.ZL2_NOTA='"+SD1->D1_DOC+"' AND ZL2.ZL2_SERIE='"+TRX->D1_SERIE+"' AND "
			cQuery+=" ZL2.ZL2_FORNE='"+TRX->D1_FORNECE+"' AND ZL2.ZL2_LOJA='"+TRX->D1_LOJA+"' AND ZL2.ZL2_COD='"+TRX->D1_COD+"' "
			cQuery+=" AND ZL2.ZL2_ENDER='N' AND ZL2.ZL2_ITEMNF='"+TRX->D1_ITEM+"'"
			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
			
			TRB->(DBSELECTAREA("TRB"))
			_aItensSDB    := {}
			aCab		  := {}
			aItem		  := {}
			_aSDARec      := {}
			TRB->(DbGotop())
			While !TRB->( Eof())
				If ( nPos:= aScan(_aSDARec,{|R| R[3] == TRB->COD}) ) > 0
					aAdd(_aSDARec,{TRB->DOC , TRB->SERIE , TRB->COD , nItemEnd , TRB->ARMAZEM , TRB->ENDERE,TRB->QUANT , TRB->FORNE,TRB->LOJA })
					nItemEnd+=1
				Else
					AAdd(_aSDARec , { TRB->DOC , TRB->SERIE , TRB->COD , nItemEnd , TRB->ARMAZEM , TRB->ENDERE,TRB->QUANT , TRB->FORNE,TRB->LOJA })
					nItemEnd+=1
				Endif
				TRB->(dbSkip())
			EndDo
			
			TRB->(DBCLOSEAREA())
			If lEnder
				aCab:= {}
				aAdd(aCab,{"DA_FILIAL ", xFilial("SDA")		   	,NIL}) //Filial do sistema
				aAdd(aCab,{"DA_PRODUTO", TRX->D1_COD	       	,NIL}) //Produto
				aAdd(aCab,{"DA_LOCAL"  , TRX->D1_LOCAL        	,NIL}) //Local Padrao
				aAdd(aCab,{"DA_NUMSEQ" , TRX->D1_NUMSEQ		   	,NIL}) //Numero Sequencial
				aAdd(aCab,{"DA_DOC"    , TRX->D1_DOC           	,NIL}) //Nota Fiscal
				
				For _nx := 1 To Len(_aSDARec)
					aItem:={}
					aAdd(aItem,{"DB_FILIAL"  , xFilial("SDB")      			   	   				,NIL}) // Filial do sistema
					aAdd(aItem,{"DB_ITEM"    , StrZero(_aSDARec[_nx,4],TamSX3("DB_ITEM")[1])	,NIL}) // Item
					aAdd(aItem,{"DB_DOC"     , TRX->D1_DOC					   	   				,NIL}) // Item
					aAdd(aItem,{"DB_LOCAL" 	 , _aSDARec[_nx,5]  			   	   				,NIL}) // Local
					aAdd(aItem,{"DB_LOCALIZ" , _aSDARec[_nx,6]  			   	   				,NIL}) // Endereco
					aAdd(aItem,{"DB_DATA"    , dDataBase           				   				,NIL}) // Data
					aAdd(aItem,{"DB_QUANT"   , _aSDARec[_nx,7]  								,NIL}) // Quantidade
					aAdd(_aItensSDB,aItem)
					
				Next _nx
				
				Begin Transaction
				
				If lEnder .AND. Empty(_aSDARec)
					MsgAlert("Nao existem etiquetas Impressas, verifique!!!")
					lRet:= .F.
					Return lRet
				Endif
				
				
				MSExecAuto({|x,y,z| mata265(x,y,z)},aCab,_aItensSDB,3)
				
				If lMsErroAuto
					MostraErro()
					DisarmTransaction()
				Else
					cQuery:=""
					cQuery := "UPDATE "+RetSqlname("ZL2")+" "
					cQuery += "SET ZL2_QUANT = 0, ZL2_ENDER='S' "
					cQuery += "WHERE ZL2_NOTA='"+TRX->D1_DOC+"' AND ZL2_ITEMNF='"+TRX->D1_ITEM+"' AND "
					cQuery += "D_E_L_E_T_=' ' "
					If TcSqlExec(cQuery) < 0
						Alert(TcSqlError())
					Endif
					
				Endif
				End transaction
				//Restaura area do SD1, MsExecAuto MATA265 bagunca area do SD1
				RestArea(aAreaSD1)
			Endif
			TRX->(dbSkip())
		Enddo
		TRX->(dbCloseArea())
	Endif
EndIf
RestArea(aArea)
Return lRet
