#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"'
#INCLUDE 'FWMVCDef.ch'

#DEFINE ENTER (Chr(13)+Chr(10))
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CloneEstru ºAutor  ³Marcio Nunes      º Data ³  04/11/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável pela criação de uma nova estrutura      º±±
±±º à partirda estrutura Pai da mesma medida                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Komfort House                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CloneEstru
Local aGetArea 	:= GetArea()
Local cQuery	:= ""
Local cAlias 	:= getNextAlias()
Local cProdSim	:= ""
Local cCodOrig 	:= ""
Local clinha	:= ""
Local cTecido	:= ""
Local cCor 		:= ""
Local cMedida	:= ""
Local cUm		:= ""
Local cSegUm	:= ""
Local cGrupo	:= ""
Local cRef		:= "" 
Local cArea		:= ""
Local aRotina 	:= {}

//Parametros do execauto
Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .F.
Private oModel := Nil
	//Variáveis Private para utilização da função Estrut2
Private cAliasTmp   := "ESTRUT"

oModel := FwLoadModel ("MATA010")
oModel:SetOperation(MODEL_OPERATION_INSERT)
oModel:Activate()


//Captura e valida o produto informado pelo usuário
U_A200Clone(@cCodOrig,@clinha,@cTecido,@cCor,@cMedida,@cUm,@cSegUm,@cGrupo,@cRef,@cArea)

	//Pesquisa o produto com a medida similar e cor diferente com estrutura criada
	cProdPai := SUBSTR(cCodOrig,1,10)
	cQuery := "SELECT TOP 1 B1_01PRODP, B1_01MEDID, B1_01COR, B1_COD, B1_DESC, B1_TIPO, B1_UM, B1_SEGUM, B1_GRUPO, G1_COD, G1_COMP, G1_NIV, G1_NIVINV " + ENTER
	cQuery += " FROM SB1010 (NOLOCK) B1" + ENTER
	cQuery += " INNER JOIN SG1010 (NOLOCK) G1 ON G1_COD=B1_COD " + ENTER
	cQuery += " WHERE B1_01PRODP ='"+cProdPai+"' " + ENTER
	cQuery += " AND B1_TIPO='PA' AND B1_01MEDID='"+cMedida+"' " + ENTER
	cQuery += " AND B1_COD <>'"+cCodOrig+"' " + ENTER//GARANTE QUE SERÁ GERADA ESTRUTURA PARA UM NOVO PRODUTO QUE NÃO EXISTA NA SG1 *************
	cQuery += " AND B1_01PAIPC ='1'" //somente produto pai será selecionado         
	cQuery += " AND G1_NIV=01 AND B1.D_E_L_E_T_='' AND G1.D_E_L_E_T_=''  " + ENTER             

	PLSQuery(cQuery, cAlias)

	If (cAlias)->(!Eof())//Captura o Produto para passar como parâmetro na montagem da estrutura
		cProdSim := (cAlias)->B1_COD
	Else
		Alert("Não existe estrutura similar para cópia para a medida"+cMedida) 
		Return .F.
	EndIf

    //Estrutura de origem - Nova estrutura
    U_EtruSG1(cProdSim,cCodOrig,cCor,cUm,cSegUm,cGrupo,clinha,cTecido,cRef,cArea)

	(cAlias)->(dbCloseArea())

RestArea(aGetArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ EtruSG1 ³ Gravação da estrutura  produtos³ Data ³04/11/2019³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Komfort House                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function EtruSG1(cProdSim,cCodPV,cCorNProd,cUm,cSegUm,cGrupo,clinha,cTecido,cRef,cArea)

Local lRet      := .T.
Local aVetor	:= {}
Local cAliasp	:= getNextAlias()
Local _cDescPro	:= ""
Local cDescInf	:= ""
Local aCompAnt	:= {}
Local cCorMont	:= ""
Local nPosA		:= 0
Local cCodPaiA	:= ""
Local nCor		:= 0
Local nLinha	:= 0
Local nTecido	:= 0
Local nTamG1Cod	 := Space(TamSX3("G1_COD")[1])
Local nTamG1Com	 := Space(TamSX3("G1_COMP")[1])
Local nTotal	:= 0
Local aRotina 	:= {}

PRIVATE PARAMIXB2 := {} // variavel para o execauto

//Explode estrutura - http://www.fbsolutions.com.br/tutoriais/estrutura-de-produtos-com-sql/ (Exemplo da query)
//Pesquisa a estrutura do produto similar para criação da nova no sistema
cQueryp := "WITH ESTRUT( FILIAL, CODIGO, CODPAI, CODCOMP, QTD, PERDA, DTINI, DTFIM, NIVEL, NIV, NIVINV, FIXVAR, REVDIM, DESCRICAO, CORPI, LINHA, TECIDO, RECNO ) AS " + ENTER
cQueryp += " ( " + ENTER
cQueryp += " SELECT G1_FILIAL, G1_COD PAI, G1_COD, G1_COMP, G1_QUANT, G1_PERDA, G1_INI, G1_FIM, 1 AS NIVEL, G1_NIV, G1_NIVINV, G1_FIXVAR, G1_REVFIM, B1_DESC, B1_01COR, B1_01LINHA, B1_01TECID, SG1.R_E_C_N_O_ " + ENTER
cQueryp += " FROM SG1010 SG1 (NOLOCK) " + ENTER
cQueryp += " INNER JOIN SB1010 SB1 (NOLOCK) ON B1_COD=G1_COMP " + ENTER
cQueryp += " WHERE SG1.D_E_L_E_T_ = '' " + ENTER
cQueryp += " AND SB1.D_E_L_E_T_ = '' " + ENTER
cQueryp += " AND G1_FILIAL      = '0101' " + ENTER
cQueryp += " UNION ALL  " + ENTER
cQueryp += " SELECT G1_FILIAL, CODIGO, G1_COD, G1_COMP, QTD * G1_QUANT, G1_PERDA, G1_INI, G1_FIM, NIVEL + 1, G1_NIV, G1_NIVINV, G1_FIXVAR, G1_REVFIM, B1_DESC, B1_01COR, B1_01LINHA, B1_01TECID, SG1.R_E_C_N_O_ " + ENTER
cQueryp += " FROM SG1010 SG1 (NOLOCK) " + ENTER
cQueryp += " INNER JOIN SB1010 SB1 (NOLOCK) ON B1_COD=G1_COMP " + ENTER
cQueryp += " INNER JOIN ESTRUT EST " + ENTER
cQueryp += " ON G1_COD = CODCOMP " + ENTER
cQueryp += " WHERE SG1.D_E_L_E_T_ = '' " + ENTER
cQueryp += " AND SB1.D_E_L_E_T_ = '' " + ENTER //FALTAVA O DELETE
cQueryp += " AND SG1.G1_FILIAL = '0101' " + ENTER
cQueryp += " ) " + ENTER
cQueryp += " SELECT * " + ENTER
cQueryp += " FROM ESTRUT E1 " + ENTER
cQueryp += " WHERE E1.CODIGO = '"+cProdSim+"' "    + ENTER

DBUseArea(.T., "TOPCONN", TCGenQry(NIL,NIL,cQueryp), (cAliasp) , .F., .T. ) //comando utilizado para aceitar o comand With                  

    nY := 1
    dbSelectArea("SG1")
	SG1->(dbSetOrder(2))         
    While (cAliasp)->(!Eof())

		//Monta a estrutura para gravação
		aGets := {}
		nPosA   := aScan(aCompAnt, {|x| x[1] == (cAliasp)->CODPAI})//encontra o Cod Pai original para substituir com o novo criado
        cCodPaiA := IIf (nPosA > 0 .And. !Empty(Alltrim(aCompAnt[nPosA][2])),aCompAnt[nPosA][2],(cAliasp)->CODPAI)
		aadd(aGets,{"G1_COD",IIf((cCodPaiA) == cProdSim,cCodPV,cCodPaiA),NIL})//IIf para garantir que alimente o codpai com o código do pedido

		//Muda o produto atual pelo produto criado acima com a cor do produto do pedido
	   	If !Empty(Alltrim((cAliasp)->CORPI))// Caso a cor esteja preenchida eu troco o produto
	   	    
	   		//busca a descrição do produto informado para compor o código
	   		DbSelectArea("SB1")
			SB1->(dbSetOrder(1))                                         
			lRetSB1 := SB1->(dbSeek(xFilial("SB1")+cCodPV))    
	    	If lRetSB1
	    	    cDescInf := SB1->B1_DESC 
			EndIf
			DbCloseArea("SB1")
	   		
			cCorMont := U_MONTCOR(cCodPV,cCorNProd,(cAliasp)->CODPAI, (cAliasp)->CORPI, (cAliasp)->DESCRICAO, cGrupo, cUm,cSegUm,cRef,cArea,cDescInf) //montagem da cor para o produto selecionado
			aadd(aGets,{"G1_COMP",cCorMont,NIL})
		    nCor +=1
			//Anterior Atual, array para substituicao do CodPai pelo novo gerado- somente para mudança de cor
			aadd(aCompAnt,{(cAliasp)->CODCOMP,cCorMont})

		ElseIf SUBSTR((cAliasp)->CODPAI,1,3) <> "KMH" .And. !Empty(Alltrim((cAliasp)->LINHA))// Caso a linha esteja preenchida eu troco o produto
			aadd(aGets,{"G1_COMP",clinha,NIL})
			nLinha +=1
		ElseIf SUBSTR((cAliasp)->CODPAI,1,3) <> "KMH" .And. !Empty(Alltrim((cAliasp)->TECIDO))// Caso o tecido esteja preenchida eu troco o produto
			aadd(aGets,{"G1_COMP",cTecido,NIL})
			nTecido +=1
		Else
			aadd(aGets,{"G1_COMP",(cAliasp)->CODCOMP,NIL})
	   	EndIf

		aadd(aGets,{"G1_TRT",Space(3),NIL})
		aadd(aGets,{"G1_QUANT",(cAliasp)->QTD,NIL})
		aadd(aGets,{"G1_PERDA",0,NIL})
		aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
		aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})

		aadd(aGets,{"G1_NIV",(cAliasp)->NIV,NIL})
		aadd(aGets,{"G1_NIVINV",(cAliasp)->NIVINV,NIL})

		aadd(PARAMIXB2,aGets)

		lRetSG1 := SG1->(dbSeek(xFilial("SG1")+Padr(aGets[2][2],Len(nTamG1Com))+Padr(aGets[1][2],Len(nTamG1Cod))))
		    If !lRetSG1                   
				RecLock("SG1",.T.)
					SG1->G1_FILIAL	:= '0101'
					SG1->G1_COD		:= aGets[1][2]
					SG1->G1_COMP    := aGets[2][2]
					SG1->G1_TRT		:= "   "
					SG1->G1_QUANT   := aGets[4][2]
					SG1->G1_PERDA   := 0
					SG1->G1_INI     := CTOD("01/01/01")
					SG1->G1_FIM	    := CTOD("31/12/49")
					SG1->G1_NIV     := (cAliasp)->NIV
					SG1->G1_NIVINV  := (cAliasp)->NIVINV              
					SG1->G1_FIXVAR 	:= "V"
					SG1->G1_REVFIM 	:= "ZZZ"
					SG1->G1_OBSERV  := cCodPV//GRAVO O NUMERO DO PAI PARA FACILITAR A BUSCA NO SELECT    
				SG1->(MsUnLock())               
		 	EndIf

    	(cAliasp)->(dbskip())
    	nY += 1

    	//Barra de processamento -
    	MsgRun("Criando estrutura...", "Título", {|| SG1->(DbEval({|x| nTotal++})) })
    EndDo
    If nCor == 0
    	Alert("É necessário informar a cor em todos os PIs da estrutura Pai:"+(cAliasp)->CODPAI) 
    	lRet := .F.
    //ElseIf nLinha == 0 -- linha não contempla mais a estrutura - Marcio 17/01/2020
    //	Alert("É necessário informar a linha no PIs da estrutura Pai:"+(cAliasp)->CODPAI)        
    //	lRet := .F.
    ElseIf nTecido == 0
    	Alert("É necessário informar o Tecido no PIs da estrutura Pai:"+(cAliasp)->CODPAI)
    	lRet := .F.
    Else
    	Alert("Estrutura cadastrada com sucesso, por favor efetue a revição da mesma.")
    EndIf
     SG1->(dbCloseArea())
    (cAliasp)->(dbCloseArea())

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MONTCOR ³ Autor ³Marcio Nunes³             Data ³04/112019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina automática para criação dos produtos por cor para o  ³±±
±±³ produto selecionado                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ KomfortHouse                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MONTCOR(cCodPV,cCorNProd,cCodPI,cCorPI,cDescPI,cGrupo,cUm,cSegUm,cRef,cArea,cDescInf)

Local cModCod 		:= ""
Local cCorNew 		:= ""
Local cCodPro		:= ""
Local _cDescPro		:= ""
Local nPos			:= ""
Local cDescPIN		:= ""
Local cTipo			:= ""   
Local cTipoP		:= ""
Local cTaman		:= 0         
Local oModel           
Default cDescInf 	:= ""
//Private aRotina := {}

	//Verifica os tipos de PI's
	If ("CAIXA"$cDescPI)
		cTipo:= "C"
	ElseIf ("BRACO"$cDescPI)
		cTipo:= "B"
	ElseIf ("ENCOSTO"$cDescPI)
		cTipo:= "E"                 
	ElseIf ("ASSENTO"$cDescPI)
		cTipo:= "A"
	ElseIf ("CORTE"$cDescPI)
		cTipo:= "O"
	ElseIf ("MONTAGEM"$cDescPI)
		cTipo:= "M"
	EndIf          
	
	//VERIFICA O TIPO DO PRODUTO                                   
	If (" CT "$cDescInf)
		cTipoP:= "CT"
	ElseIf (" BD "$cDescInf)
		cTipoP:= "BD"
	ElseIf (" BE "$cDescInf)
		cTipoP:= "BE"
	ElseIf (" CH "$cDescInf)
		cTipoP:= "CH" 
	ElseIf (" CH/D "$cDescInf)
		cTipoP:= "CHD"
	ElseIf (" CH/E "$cDescInf)              
		cTipoP:= "CHE"
	ElseIf (" CT/E "$cDescInf)                     
		cTipoP:= "CTE"		  
	ElseIf (" CT/D "$cDescInf)
		cTipoP:= "CTD"  		   		              
	EndIf                                                  
							
	cDescPIN := SUBSTR(cDescPI,1,2)+cTipo //Inicial do código montado atravé da descrição     
	cModCod := SUBSTR(cCodPV,4,3)//Formecedor e Modelo do Produto
	cCorNew := Alltrim(U_TiraGraf (cCorNProd)) 
	cTaman  := Alltrim(SUBSTR(cCodPV,13,2))//captira o Tamanho cadastrado na grade. Ex.: GRAMAL0001QT032  13,0 - "03"
	//Retirada as linhas abaixo pois a cor do probudo não tem mais descrição
	//nPos := AT("-",(cCorNew))-1//Captura a cor do produto para compor o códito antes do traço
	//cCorNew := SUBSTR(cCorNew,1,nPos)//Cor do tecido para compor o código

	//Montagem do código e descrição do produto
	cCodPro  := cDescPIN+cModCod+cTipoP+cCorNew+cTaman //Inicial do produto + Forneceror e Modelo + Tipo + Cor + Tamanho
 	_cDescPro := Alltrim(cDescPIN)+" "+Alltrim(cModCod)+" "+Alltrim(cCorNProd)+" "+Alltrim(cRef)

	DbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	If !SB1->(dbSeek(xFilial("SB1")+cCodPro))  		     
		oModel  := FwLoadModel ("MATA010")                            
		oModel:SetOperation(MODEL_OPERATION_INSERT)
		oModel:Activate()
		oModel:SetValue("SB1MASTER","B1_DESC"		,	Alltrim(_cDescPro))
		oModel:SetValue("SB1MASTER","B1_COD"		,	cCodPro)		
		oModel:SetValue("SB1MASTER","B1_TIPO"		,	"PI")
		oModel:SetValue("SB1MASTER","B1_UM"     	,	Alltrim(cUm))
		oModel:SetValue("SB1MASTER","B1_LOCPAD"		,	"95")
		oModel:SetValue("SB1MASTER","B1_LOCALIZ"    ,	"N")
		oModel:SetValue("SB1MASTER","B1_SEGUM"		,	Alltrim(cSegUm))
		oModel:SetValue("SB1MASTER","B1_PICM"		,	0)
		oModel:SetValue("SB1MASTER","B1_IPI"		,	0)
		oModel:SetValue("SB1MASTER","B1_CONTRAT"	,	"N")
		oModel:SetValue("SB1MASTER","B1_POSIPI"		,	"00000000")
		oModel:SetValue("SB1MASTER","B1_MSBLQL"		,	"2")
		oModel:SetValue("SB1MASTER","B1_GRUPO"		,	cGrupo)
		oModel:SetValue("SB1MASTER","B1_01COR"		,	cCorNProd)
		oModel:SetValue("SB1MASTER","B1_01ARPCP"	,	cArea)

		If (oModel:VldData())
			oModel:CommitData()			 
			If SB1->(dbSeek(xFilial("SB1")+cCodPro))// Garante a gravação correta da descrição **ERRO de framework			
				RecLock("SB1",.F.)
					SB1->B1_DESC := _cDescPro
				SB1->(MsUnlock())			
			EndIf
		Else
			VarInfo("",oModel:GetErrorMessage())
		EndIf
		
	
	EndIf

Return (cCodPro)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TiraGraf ³ Autor ³Marcio Nunes³        Data ³04/11/2019    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ Rotina responsável por retirar caracteres especiais do Produto ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ KomfortHouse                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TiraGraf (cCorCara)
   local cRet := cCorCara
   cRet = strtran (cRet, " ", "")
   cRet = strtran (cRet, ".", "")
   cRet = strtran (cRet, "(", "")
   cRet = strtran (cRet, ")", "")
   cRet = strtran (cRet, "TC", "")//Substitui o TC
Return cRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  A200Clone  ³ Autor ³Marcio Nunes        ³ Data ³04/11/2019³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta tela para informação do produto que será criada a    ³±±
±± estrutura                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ KomfortHouse                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function A200Clone(cCodOrig,clinha,cTecido,cCor,cMedida,cUm,cSegUm,cGrupo,cRef,cArea)  

Local 	oSay
Local 	oSize
Local 	oSize2
Local 	aRotina		:= {}

Private cCodOrig 	:= Criavar("B1_COD" ,.F.)
Private cDescOrig	:= Criavar("B1_DESC" ,.F.)
Private clinha		:= ""
Private cTecido		:= ""
Private cCor		:= ""
Private cMedida		:= ""
Private cUm	   		:= "PC"//INICIALIZADOR
Private	cSegUm		:= ""
Private	cRef		:= ""


	DEFINE MSDIALOG oDlg FROM  140,000 TO 358,615 TITLE OemToAnsi("Clonar estrutura da mesma medida") PIXEL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula dimensões Em linha                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSize := FwDefSize():New(.T.,,,oDlg)
	oSize:AddObject( "LABEL1" 	,  100, 50, .T., .T. ) // Totalmente dimensionavel

	oSize:lProp 	:= .T. // Proporcional
	oSize:aMargins 	:= { 6, 6, 6, 6 } // Espaco ao lado dos objetos 0, entre eles 3

	oSize:Process() 	   // Dispara os calculos

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula dimensões Em Coluna                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSize2 := FwDefSize():New()

	oSize2:aWorkArea := oSize:GetNextCallArea( "LABEL1" )

	oSize2:AddObject( "ESQ",  100, 50, .T., .T. ) // Totalmente dimensionavel

	oSize2:lLateral := .T.
	oSize2:lProp 	:= .T. // Proporcional
	oSize2:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3

	oSize2:Process() 	   // Dispara os calculos

	DEFINE SBUTTON oBtn FROM 800,800 TYPE 5 ENABLE OF oDlg
	@ oSize:GetDimension("LABEL1","LININI"), oSize:GetDimension("LABEL1","COLINI") TO oSize:GetDimension("LABEL1","LINEND"), oSize:GetDimension("LABEL1","COLEND") LABEL OemToAnsi("Novo Produto") OF oDlg PIXEL //"Componente Original"

	@ oSize2:GetDimension("ESQ","LININI")+10, oSize2:GetDimension("ESQ","COLINI")+30 MSGET cCodOrig   F3 "SB1" Picture PesqPict("SB1","B1_COD") Valid NaoVazio(cCodOrig) .And. ExistCpo("SB1",cCodOrig) SIZE 105,09 OF oDlg PIXEL

	@ oSize2:GetDimension("ESQ","LININI")+24, oSize2:GetDimension("ESQ","COLINI")+33 SAY oSay Prompt cDescOrig SIZE 130,6 OF oDlg PIXEL
	@ oSize2:GetDimension("ESQ","LININI")+12, oSize2:GetDimension("ESQ","COLINI") SAY OemtoAnsi("Produto")   SIZE 24,7  OF oDlg PIXEL //"Produto"

	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| If(!Empty(cCodOrig),(lOk:=.T.,oDlg:End()),lOk:=.F.) },{||(lOk:=.F.,oDlg:End())})

dbSelectArea("SB1")
dbSetOrder(1)
If 	!(SB1->(DbSeek(xFilial("SB1") + cCodOrig )))
	Alert("Produto não encontrado")
	Return .F.
ElseIf Empty(SB1->B1_01TECID)
	Alert("Tecido não cadastrado para o produto informado")
	Return .F.
//ElseIf Empty(SB1->B1_01LINHA) -- LINHA RETIRADA DA ESTRUTURA - MARCIO 17/01/2020
//	Alert("Linha não cadastrada para o produto informado")
//	Return .F.
ElseIf Empty(SB1->B1_01COR)
	Alert("Cor não cadastrada para o produto informado")
	Return .F.
ElseIf Empty(SB1->B1_01MEDID)
	Alert("Medida não cadastrada para o produto informado")
	Return .F.
Else
	clinha		:= SB1->B1_01LINHA
	cTecido		:= SB1->B1_01TECID
	cCor		:= SB1->B1_01COR
	cMedida		:= Alltrim(SB1->B1_01MEDID)
	cUm	   		:= SB1->B1_UM
	cSegUm		:= SB1->B1_SEGUM
	cGrupo		:= SB1->B1_GRUPO
	cRef		:= SB1->B1_01DREF 
	cArea		:= SB1->B1_01ARPCP //GRAVA A ÁREA DO PI DO PAI
	Return .T.                                                     
EndIf

Return()
