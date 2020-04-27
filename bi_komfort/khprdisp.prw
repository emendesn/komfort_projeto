#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "topconn.ch"
#INCLUDE "RWMAKE.CH"

//Everton Santos - 17/10/2019
//Tela de Produtos Disponiveis no estoque do CD.
User Function KHPRDISP()

// Declaracao de variaveis.
Local lRet		 := .F.
Local aArea		 := GetArea()
Local nSB1RecNo	 := 0
Local cSB1Cod	 := Space(TamSX3("B1_COD")[1])
Local oDlgPesq
Local bCancel    := {|| oDlgPesq:End()} 
Local aUsuario	 := PswRet(1)
Local oCombPsq  
Local oCombTCl
Local oGetPsq
Local cPesq      := Space(250)
Local aLista     := {}
Local aPesq      := {"D=Descricao","C=Codigo"}  
Local cOrdPes    := ""		
Local bPesq      := {|| F3B1Search(cPesq, oDlgPesq, oLBox, cOrdPes, aLista, oGetPsq,), .T.}
Default cOrdPes	 := "D"
Static cPesqOld  := ""
Private oLBox
Private oSay
Private oFont11
Private nTotal   := 0

DEFINE FONT oFont11 NAME "Arial" SIZE 0, -14 BOLD

//Montagem da Tela de consulta.                   
DEFINE MSDIALOG oDlgPesq TITLE "Consulta de Produtos Disponíveis" FROM 0, 0 to 600, 1100 PIXEL


//Area de pesquisa.                               
@01, 02 TO 25, 550 LABEL "Pesquisa" OF oDlgPesq PIXEL
@10, 05 COMBOBOX oCombPsq Var cOrdPes  ITEMS aPesq SIZE 50, 10 OF oDlgPesq PIXEL   
@ 010, 495 BUTTON "&Pesquisar Todos" SIZE 050, 010 ACTION Processa({||EVal(bPesq)},"Aguarde...","Carregando lista de Produtos...",.F.) OF oDlgPesq PIXEL      
oGetPsq := TGet():New(10, 55, {|U| IIf(PCount() == 0, cPesq, cPesq := U)},oDlgPesq, 430, 008, "@!",,,,,,,.T.,,.F.,,.F.,,,.F.,,,cPesq,,,)  
// Area de produtos.                               
@ 030, 002 TO 275, 550 LABEL "Produtos" OF oDlgPesq PIXEL     
@ 040, 006 LISTBOX oLBox FIELDS HEADER "Codigo","Descricao","Armazem","Disponível","FL","Preço Venda" SIZE 540, 230 OF oDlgPesq PIXEL
@ 280, 500 BUTTON "&Sair"	ACTION EVal(bCancel)	SIZE 050, 015 OF oDlgPesq PIXEL
@ 280, 445 BUTTON "&Excel"	ACTION fExcelG(aLista)	SIZE 050, 015 OF oDlgPesq PIXEL
@ 280, 006 Say  oSay Prompt "Total de Produtos disponiveis: "+ cValToChar(nTotal)+ "" FONT oFont11 COLOR CLR_BLUE Size  200, 12 Of oDlgPesq Pixel  

F3B1AtuList(oLBox, aLista, .F.)  
oLBox:aColSizes := {080,030,030,030,030,030}

oGetPsq:SetFocus()

ACTIVATE MSDIALOG oDlgPesq Centered //ON INIT EnchoiceBar(oDlgPesq, bOk, bCancel,, aButtons)

// Se o usuario confirmou.
If nSB1RecNo > 0
	dbSelectArea("SB1")
	dbGoTo(nSB1RecNo)	
	lRet := .T.
Else
	RestArea(aArea)
EndIf       

Return lRet

//-----------------------------------------------------------------------------------
Static Function F3B1Search(cPesq, oDlgPesq, oLbx, cOrdPes, aLista, oGetPsq)

// Declaracao de variaveis.
Local aArea      := GetArea()
Local cQuery     := ""
Local cAlsTrab   := GetNextAlias()
Local cCpo       := IIf(cOrdPes == "D", "SB1.B1_DESC", IIf(cOrdPes == "C", "SB1.B1_COD", "SB1.B1_COD"))
Local aLikes     := {}
Local nX
Local nR
Local cLocal     := ""
Local cAlias     := GetNextAlias()
Local nRegistros := 0
Local nCount     := 0
Local aLista     := {}


	// Retira aspas simples e duplas
	cPesq    := StrTran(cPesq,"'"," ")
	cPesq    := StrTran(cPesq,'"'," ")

	// Retira espacos em branco do campo de pesquisa.
	cPesq    := Alltrim(cPesq)

	// Apaga a lista de produtos para refaze-la.
	aLista   := {}
	
		// Gera array com likes da pesquisa.
		aLikes   := StrToKArr(cPesq, " ")
		
		/*
		cQuery := "SELECT DISTINCT " + CRLF
		cQuery += "B1_COD CODIGO," + CRLF
		cQuery += "B1_DESC DESCRICAO," + CRLF
		cQuery += "B2_LOCAL ARMAZEM," + CRLF
		cQuery += "ISNULL((SB2.B2_QATU - (SB2.B2_QEMP + SB2.B2_RESERVA + (SELECT CASE " + CRLF
		cQuery += "											              WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 " + CRLF 
		cQuery += "											              ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED " + CRLF
		cQuery += "														  FROM SC6010(NOLOCK) SC6 " + CRLF
		cQuery += "														  WHERE SC6.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += "														  AND C6_PRODUTO = SB1.B1_COD " + CRLF
		cQuery += "														  AND C6_NOTA = '' " + CRLF
		cQuery += "														  AND C6_BLQ <> 'R' " + CRLF
		cQuery += "														  AND C6_QTDEMP = 0 " + CRLF
		cQuery += "														  AND C6_QTDVEN > C6_QTDLIB " + CRLF
		cQuery += "														  AND C6_CLI <> '000001' " + CRLF
		cQuery += "														  AND C6_FILIAL = '"+xFilial("SC6")+"'" + CRLF
		cQuery += "														  AND C6_LOCAL = '01') + SB2.B2_QACLASS) ),0) DISPONIVEL," + CRLF
		cQuery += "B1_01FORAL FORA_LINHA" + CRLF
		cQuery += "FROM SB1010 SB1 (NOLOCK)" + CRLF
		cQuery += "INNER JOIN " + RetSqlName("SB2") + " (NOLOCK) SB2 ON B2_COD = B1_COD AND B2_LOCAL = '01' AND B2_FILIAL = '0101' AND SB2.D_E_L_E_T_ = '' " + CRLF
		cQuery += "WHERE SB1.B1_FILIAL = '" +xFilial("SB1")+ "'" + CRLF 
		cQuery += "AND (SB2.B2_QATU - (SB2.B2_QEMP + SB2.B2_RESERVA + (SELECT CASE " + CRLF
		cQuery += "													   WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 " + CRLF
		cQuery += "													   ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED " + CRLF
		cQuery += "													   FROM SC6010(NOLOCK) SC6 " + CRLF
		cQuery += "													   WHERE SC6.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += "													   AND C6_PRODUTO = SB1.B1_COD " + CRLF
		cQuery += "													   AND C6_NOTA = '' " + CRLF
		cQuery += "													   AND C6_BLQ <> 'R' " + CRLF
		cQuery += "													   AND C6_QTDEMP = 0 " + CRLF
		cQuery += "													   AND C6_QTDVEN > C6_QTDLIB " + CRLF
		cQuery += "													   AND C6_CLI <> '000001' " + CRLF 
		cQuery += "													   AND C6_FILIAL = '"+xFilial("SC6")+"'" + CRLF
		cQuery += "													   AND C6_LOCAL = '01')+ SB2.B2_QACLASS) ) > 0 " + CRLF
		
		If !Empty(aLikes)
			For nX := 1 to len(aLikes)
				cQuery += "AND " + cCpo + " LIKE '%"+ aLikes[nX] + "%' " + CRLF
			Next nX
		EndIf
		
		cQuery += "AND SB1.B1_XACESSO <> '1' " + CRLF
		cQuery += "AND SB1.B1_MSBLQL <> '1'" + CRLF 
		cQuery += "AND SB1.B1_TIPO IN ('ME','PA') " + CRLF 
		cQuery += "AND SB1.D_E_L_E_T_ = ' ' " + CRLF						
		cQuery += "ORDER BY " + cCpo
		*/
		
		cQuery += " SELECT DISTINCT " + CRLF
		cQuery += " B1_COD CODIGO, " + CRLF
		cQuery += " B1_DESC DESCRICAO, " + CRLF
		cQuery += " B2_LOCAL ARMAZEM, " + CRLF
		cQuery += " ISNULL((SB2.B2_QATU - (SB2.B2_QEMP + SB2.B2_RESERVA + ((SELECT CASE " + CRLF
		cQuery += " 											   WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 " + CRLF
		cQuery += " 											   ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED " + CRLF 
		cQuery += " 											   FROM SC6010(NOLOCK) SC6 " + CRLF 
		cQuery += " 											   WHERE SC6.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " 											   AND C6_PRODUTO = SB1.B1_COD " + CRLF 
		cQuery += " 											   AND C6_NOTA = '' " + CRLF
		cQuery += " 											   AND C6_BLQ <> 'R' " + CRLF
		cQuery += " 											   AND C6_QTDEMP = 0 " + CRLF
		cQuery += " 											   AND C6_QTDVEN > C6_QTDLIB " + CRLF
		cQuery += " 											   AND C6_CLI <> '000001' " + CRLF
		cQuery += " 											   AND C6_FILIAL = '01' " + CRLF
		cQuery += " 											   AND C6_LOCAL = '01' " + CRLF
		cQuery += " 											   )-(SELECT CASE " + CRLF
		cQuery += " 												  WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 " + CRLF
		cQuery += " 												  ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED " + CRLF
		cQuery += " 												  FROM SC6010(NOLOCK) SC6 " + CRLF
		cQuery += " 												  WHERE SC6.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " 												  AND C6_PRODUTO = SB1.B1_COD " + CRLF
		cQuery += " 												  AND C6_NOTA = '' " + CRLF
		cQuery += " 												  AND C6_BLQ <> 'R' " + CRLF
		cQuery += " 												  AND C6_QTDEMP = 0 " + CRLF
		cQuery += " 												  AND C6_QTDVEN > C6_QTDLIB " + CRLF
		cQuery += " 												  AND C6_CLI <> '000001' " + CRLF
		cQuery += " 												  AND C6_FILIAL = '01' " + CRLF
		cQuery += " 												  AND C6_LOCAL = '01' " + CRLF
		cQuery += " 												  AND C6_XVENDA = '1')) + SB2.B2_QACLASS) ),0) DISPONIVEL, " + CRLF
		cQuery += " B1_01FORAL FORA_LINHA " + CRLF
		cQuery += " FROM SB1010 SB1 (NOLOCK) " + CRLF
		cQuery += " INNER JOIN " + RetSqlName("SB2") + " (NOLOCK) SB2 ON B2_COD = B1_COD AND B2_LOCAL = '01' AND B2_FILIAL = '0101' AND SB2.D_E_L_E_T_ = '' " + CRLF
		cQuery += " WHERE SB1.B1_FILIAL = '' " + CRLF
		cQuery += " AND (SB2.B2_QATU - (SB2.B2_QEMP + SB2.B2_RESERVA + ((SELECT CASE " + CRLF
		cQuery += " 											WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 " + CRLF
		cQuery += " 											ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED " + CRLF
		cQuery += " 											FROM SC6010(NOLOCK) SC6 " + CRLF
		cQuery += " 											WHERE SC6.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " 											AND C6_PRODUTO = SB1.B1_COD " + CRLF
		cQuery += " 											AND C6_NOTA = '' " + CRLF
		cQuery += " 											AND C6_BLQ <> 'R' " + CRLF
		cQuery += " 											AND C6_QTDEMP = 0 " + CRLF
		cQuery += " 											AND C6_QTDVEN > C6_QTDLIB " + CRLF
		cQuery += " 											AND C6_CLI <> '000001' " + CRLF
		cQuery += " 											AND C6_FILIAL = '01' " + CRLF
		cQuery += " 											AND C6_LOCAL = '01')-(SELECT CASE " + CRLF
		cQuery += " 																  WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 " + CRLF
		cQuery += " 																  ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED " + CRLF
		cQuery += " 																  FROM SC6010(NOLOCK) SC6 " + CRLF
		cQuery += " 																  WHERE SC6.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += " 																  AND C6_PRODUTO = SB1.B1_COD " + CRLF
		cQuery += " 																  AND C6_NOTA = '' " + CRLF
		cQuery += " 																  AND C6_BLQ <> 'R' " + CRLF
		cQuery += " 																  AND C6_QTDEMP = 0 " + CRLF
		cQuery += " 																  AND C6_QTDVEN > C6_QTDLIB " + CRLF
		cQuery += " 																  AND C6_CLI <> '000001' " + CRLF
		cQuery += " 																  AND C6_FILIAL = '01' " + CRLF
		cQuery += " 																  AND C6_LOCAL = '01' " + CRLF
		cQuery += " 																  AND C6_XVENDA = '1')) + SB2.B2_QACLASS)) > 0 " + CRLF
		cQuery += " 
		
		If !Empty(aLikes)
			For nX := 1 to len(aLikes)
				cQuery += "AND " + cCpo + " LIKE '%"+ aLikes[nX] + "%' " + CRLF
			Next nX
		EndIf	
		
		cQuery += " AND SB1.B1_XACESSO <> '1' " + CRLF
		cQuery += " AND SB1.B1_MSBLQL <> '1' " + CRLF
		cQuery += " AND SB1.B1_TIPO IN ('ME','PA') " + CRLF  
		cQuery += " AND SB1.D_E_L_E_T_ = ' ' " + CRLF						
		cQuery += "ORDER BY " + cCpo
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), cAlsTrab, .F., .T.)
			
		(cAlsTrab)->(dbEval({|| nRegistros++}))
		(cAlsTrab)->(dbgotop())
		
		ProcRegua(nRegistros)   		
		
		nTotal := 0
		
		Do While !(cAlsTrab)->(EOF())
				 nCount++
				 incproc("Atualizando Dados...")
				 
				 (cAlsTrab)->(aAdd(aLista, { CODIGO,;
				  							 DESCRICAO,;
				  							 ARMAZEM,;
				  							 DISPONIVEL,;
				  							 FORA_LINHA,;
				  							 PrcVen(CODIGO)}))
				 (cAlsTrab)->(dbSkip())
		EndDo
		
		For nR := 1 To Len(aLista)
			nTotal += aLista[nR][4]
        Next nR
        
		(cAlsTrab)->(dbCloseArea())
	   
	
 	// Atualiza listbox.
	F3B1AtuList(oLbx, aLista)
	oGetPsq:SetFocus() 		
  
RestArea(aArea)
Return

//-------------------------------------------------------------------------------------
Static Function F3B1AtuList(oLbx, aLista)

// Se a lista nao possui nenhum registro, deixa listbox com uma linha em branco.
If empty(aLista)
	aAdd(aLista, {CriaVar("B1_COD", .F.), CriaVar("B1_DESC", .F.), CriaVar("B2_LOCAL", .F.), CriaVar("B2_QATU", .F.), CriaVar("B1_01FORAL", .F.), CriaVar("DA1_PRCVEN", .F.)})
Endif

oLbx:SetArray(aLista)
oLbx:bLine := {|| {	Transform(aLista[oLbx:nAt, 1],PesqPict("SB1","B1_COD")),;		//CODIGO
					Transform(aLista[oLbx:nAt, 2],PesqPict("SB1","B1_DESC")),;		//DESCRICAO
					Transform(aLista[oLbx:nAt, 3],PesqPict("SB2","B2_LOCAL")),;		//ARMAZEM
 					Transform(aLista[oLbx:nAt, 4],PesqPict("SB2","B2_QATU")),;	    //QT DISPONIVEL
 					Transform(aLista[oLbx:nAt, 5],PesqPict("SB1","B1_01FORAL")),;	//FORA DE LINHA
 					Transform(aLista[oLbx:nAt, 6],PesqPict("DA1","DA1_PRCVEN"))}}	//PREÇO DE VENDA
				
oLbx:Refresh()

Return
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
//Função para retornar o Preço de venda do produto
Static Function PrcVen(cCodPro)

Local nPrcven := 0
Local lPreco := .T.
		
nPrcven := KMHTAB001(cCodPro,lPreco)
			
If nPrcven == 0			
	lPreco := .F.
	nPrcven := KMHTAB001(cCodPro,lPreco)	
EndIf	
		
Return nPrcven
//-----------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------
//Valida o preço na tabela 001
Static Function KMHTAB001(cCodPro,lPreco)

Local cQuery := ""
Local nPrcven := 0
Default lPreco := .F.

cQuery := "SELECT * " + CRLF
cQuery += "FROM " + RetSQLName("DA1") + " DA1 " + CRLF
cQuery += "INNER JOIN " + RetSQLName("DA0") + " DA0 " + CRLF
cQuery += "ON DA0_CODTAB = DA1_CODTAB " + CRLF 
cQuery += "WHERE DA0_ATIVO = '1'" + CRLF 
If (lPreco)
	cQuery += "AND DA0_CODTAB <> '001' AND DA0_CODTAB <> '002'" + CRLF
Else 
	cQuery += "AND DA1_CODTAB = '001' " + CRLF	
EndIf
cQuery += "AND DA1_CODPRO = '" + cCodPro + "' " + CRLF
cQuery += "AND DA1.D_E_L_E_T_ = '' " + CRLF
cQuery += "AND DA0.D_E_L_E_T_ = '' " + CRLF

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TempDA1",.F.,.T.)

While !(TempDA1->(EOF()))
	nPrcven := TempDA1->DA1_PRCVEN
	TempDA1->(DBSkip())
EndDo

If Select("TempDA1") > 0
	TempDA1->(DbCloseArea())
EndIf

Return nPrcven
//------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------
Static Function fExcelG(aItens)

	Local oExcel   := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "KHPRDISP"+substr(time(), 7, 2)+".XLS"
	Local aCab     := {}
	Local aFields  := {"B1_COD", "B1_DESC", "B2_LOCAL", "Disponível", "B1_01FORAL", "DA1_PRCVEN"}
	Local nx       := 0
    Local cTitle   := "Lista de produtos"

    if Empty(aItens[1][1]) 
        Return(msginfo("Não ha dados para impressão...","ATENÇÃO"))
    endif
    
    DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nx := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nx]))
	    	Aadd(aCab, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		ELSE
			Aadd(aCab,{aFields[nx],"","","","","","","C","","","",""})
		Endif
	Next nx           
    
   	cNamePlan := cNameTable := cTitle
	oExcel:AddworkSheet(cNamePlan)
	oExcel:AddTable (cNamePlan,cNameTable)
	
	//Colunas do Excel ----------------------------------------
	for nx := 1 to Len(aCab)
		if     aCab[nx][8] == "C"// Tipo Caracter
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		elseif aCab[nx][8] == "N"// Tipo Numerico
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],3,2)
		elseif aCab[nx][8] == "D" // Tipo Data
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,3)			
		else
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		endif
	next nx
	//Linhas do Excel
    for nx := 1 to len(aItens) 
	   	oExcel:AddRow(cNamePlan,cNameTable,{aItens[nx][1],;
											aItens[nx][2],;
                                            aItens[nx][3],;
											aItens[nx][4],;
                                            aItens[nx][5],;
                                            aItens[nx][6]})
	next nx
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
Return


