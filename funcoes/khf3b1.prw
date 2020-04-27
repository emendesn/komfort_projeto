#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KHF3B1   � Autor � Jonas L. Souza Jr  � Data �  07/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Consulta padrao feita em partes da descricao               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort House - Compatibilizado por Rafael Cruz 23/02/18   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function KHF3B1()

// Declaracao de variaveis.
Local lRet		:= .F.
Local aArea		:= GetArea()
Local nSB1RecNo	:= 0
Local cSB1Cod	:= Space(TamSX3("B1_COD")[1])

Local oDlgPesq
Local bOk        := {|| IIf(empty(aLista[oLBox:nAt, 1]), Alert("Selecione um produto v�lido!"), (nSB1RecNo := aLista[oLBox:nAt, 1], cSB1Cod := aLista[oLBox:nAt, 3],oDlgPesq:End()))}
Local bCancel    := {|| oDlgPesq:End()} 
Local bView		 := {|| F3B1Vis(aLista[oLBox:nAt, 1]) }
Local aUsuario	 := PswRet(1)
Local lHierarq	 := .F.	    
Local lLibBloq	 := SuperGetMV("KH_LIBBLOQ", .T.)

Local oCombPsq  
Local oCombTCl
Local oGetPsq
Local cPesq      := Space(200)
Local aLista     := {}
Local aPesq      := {"D=Descricao","C=Codigo","N=Cod.Netge"}  
Local aTipo      := {"C=Comercial", "T=Todos"}
//Local cOrdPes    := "D"	//#RVC20180504.o
Local cOrdPes    := ""		//#RVC20180504.n 
Local cTipoCli   := ""
Local bPesq      := {|| F3B1Search(cPesq, oDlgPesq, oLBox, cOrdPes, aLista, oGetPsq, lHierarq, cTipoCli), .T.}
Local bSaldo      := {|| fSaldo(), .T.}

Default cOrdPes	:= "D"
Private oLBox

Static cPesqOld 
Static cAreaOld

cPesqOld := "" 
cAreaOld := ""

DbselectArea("SA3")
DbsetOrder(7)           

If DbSeek(xFilial("SA3")+aUsuario[01][01])
	lHierarq := .T.	   
	cTipoCli := "C"
Else
	lHierarq := .F. 
	cTipoCli := "T"
EndIf
SA3->(dbCloseArea())

//�������������������������������������������������Ŀ
//� Montagem da Tela de consulta.                   �
//���������������������������������������������������   
DEFINE MSDIALOG oDlgPesq TITLE "Consulta de produtos" FROM 0, 0 to 585, 800 PIXEL

@ 265, 248 BUTTON "OK"			ACTION EVal(bOk)		SIZE 050, 015 OF oDlgPesq PIXEL 
@ 265, 299 BUTTON "Cancelar"	ACTION EVal(bCancel)	SIZE 050, 015 OF oDlgPesq PIXEL 
@ 265, 350 BUTTON "Visualizar"	ACTION EVal(bView)		SIZE 050, 015 OF oDlgPesq PIXEL 

//�������������������������������������������������Ŀ
//� Area de pesquisa.                               �
//���������������������������������������������������
@01, 02 TO 25, 400 LABEL "Pesquisa" OF oDlgPesq PIXEL
@10, 05 COMBOBOX oCombPsq Var cOrdPes  ITEMS aPesq SIZE 50, 10 OF oDlgPesq PIXEL   
     
oGetPsq := TGet():New(10, 55, {|U| IIf(PCount() == 0, cPesq, cPesq := U)},oDlgPesq, 290, 008, "@!",,,,,,,.T.,,.F.,,.F.,,,.F.,,,cPesq,,,)  

@ 010, 345 BUTTON "&Pesquisar" SIZE 050, 010 ACTION EVal(bPesq) OF oDlgPesq PIXEL     

//�������������������������������������������������������������������������������������������������Ĵ[�
//�Permite o usuario escolher se devera apresentar apenas produtos do comercial ou todos os produtos�
//�������������������������������������������������������������������������������������������������Ĵ[�

@ 027, 002 TO 50, 400 LABEL "�rea de Produtos" OF oDlgPesq PIXEL
@ 035, 005 MSCOMBOBOX oCombTCl VAR cTipoCli ITEMS aTipo SIZE 50, 10 OF oDlgPesq PIXEL When lLibBloq  

@ 035, 345 BUTTON "&Estoque" SIZE 050, 010 ACTION EVal(bSaldo) OF oDlgPesq PIXEL     

//�������������������������������������������������Ŀ
//� Area de produtos.                               �
//���������������������������������������������������

@ 052, 002 TO 260, 400 LABEL "Produtos" OF oDlgPesq PIXEL     
@ 060, 006 LISTBOX oLBox FIELDS HEADER "Codigo", "Descricao", "Prod.Pai","Cod.Netgera" SIZE 390, 195 OF oDlgPesq PIXEL ON DBLCLICK(Eval(bOk))  

F3B1AtuList(oLBox, aLista, .F.)  
oLBox:aColSizes := {080,030,030,030}

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


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F3B1Search�Autor  �Jonas L. Souza Jr   � Data �  11/12/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pesquisa de produtos                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Dovac                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F3B1Search(cPesq, oDlgPesq, oLbx, cOrdPes, aLista, oGetPsq, lHierarq, cTipoCli)

// Declaracao de variaveis.
Local aArea      := GetArea()
Local cQuery     := ""
Local cAlsTrab   := GetNextAlias()

Local cCpo       := ""
Local aLikes     := {}
Local nX

If cTipoCli == "T"
	cCpo := IIf(cOrdPes == "D", "SB1.B1_DESC", IIf(cOrdPes == "N", "SB1.B1_CODANT", "SB1.B1_COD"))
Else
	cCpo := IIf(cOrdPes == "D", "SB1.B1_DESC", IIf(cOrdPes == "N", "SB1.B1_CODANT", "SB1.B1_COD"))
EndIf


// Verifica se o usuario alterou o campo de pesquisa.
If cPesqOld <> cPesq .Or. cAreaOld <> cTipoCli  .Or. Empty(cPesq) 
	cPesqOld := cPesq 
	cAreaOld := cTipoCli
	
	// Retira aspas simples e duplas
	cPesq    := StrTran(cPesq,"'"," ")
	cPesq    := StrTran(cPesq,'"'," ")

	// Retira espacos em branco do campo de pesquisa.
	cPesq    := Alltrim(cPesq)

	// Apaga a lista de produtos para refaze-la.
	aLista   := {}
	
	// Se o usuario nao digitou nada, nao faz a pesquisa.
	If !empty(cPesq)		
		// Gera array com likes da pesquisa.
		aLikes   := StrToKArr(cPesq, " ")
		
		// Query de pesquisa de produtos.
		cQuery := "SELECT SB1.R_E_C_N_O_ RECNO,"	+ CRLF
		cQuery += "SB1.B1_COD COD, " 				+ CRLF
		cQuery += "SB1.B1_DESC DESCRICAO,"			+ CRLF
		cQuery += "SB1.B1_TIPO TIPO, "				+ CRLF
		cQuery += "SB1.B1_CODANT NETGERA,"			+ CRLF
		cQuery += "SB1.B1_01PRODP PRODPAI "			+ CRLF
		// Tabela de produtos.
		cQuery += "FROM " + RetSQLName("SB1") + " SB1 " + CRLF 
		cQuery += "WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "' " + CRLF 
		If !Empty(aLikes)
			For nX := 1 to len(aLikes)
				cQuery += "AND " + cCpo + " LIKE '%"+ aLikes[nX] + "%' " + CRLF
			Next nX
		EndIf
		If lHierarq .Or. cTipoCli == "C"
			// Tipo de produto.
			cQuery += "AND SB1.B1_TIPO IN ('ME','MC','AT','SV','MP','AC','PA') " + CRLF 
		EndIf    
		cQuery += "AND SB1.D_E_L_E_T_ = ' ' " + CRLF						
		cQuery += "ORDER BY " + cCpo
		dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), cAlsTrab, .F., .T.)
			
		aLista :={}   		
		Do While !(cAlsTrab)->(EOF())
				(cAlsTrab)->(aAdd(aLista, {RECNO, COD, DESCRICAO, PRODPAI, NETGERA}))
				(cAlsTrab)->(dbSkip())
		EndDo
		(cAlsTrab)->(dbCloseArea())
	Endif   
	
 	// Atualiza listbox.
	F3B1AtuList(oLbx, aLista)
	oGetPsq:SetFocus() 		
  
EndIf

RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F3B1AtuList�Autor �Jonas L. Souza Jr   � Data �  11/07/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualizacao do objeto listbox.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Dovac                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F3B1AtuList(oLbx, aLista)

// Se a lista nao possui nenhum registro, deixa listbox com uma linha em branco.
If empty(aLista)
	aAdd(aLista, {0, CriaVar("B1_COD", .F.), CriaVar("B1_DESC", .F.), CriaVar("B1_01PRODP", .F.), CriaVar("B1_CODANT", .F.)})
Endif

oLbx:SetArray(aLista)
oLbx:bLine := {|| {	Transform(aLista[oLbx:nAt, 2],PesqPict("SB1","B1_COD")),;		//CODIGO
					Transform(aLista[oLbx:nAt, 3],PesqPict("SB1","B1_DESC")),;		//DESCRICAO
 					Transform(aLista[oLbx:nAt, 4],PesqPict("SB1","B1_01PRODP")),;	//CODIGO PAI
 					Transform(aLista[oLbx:nAt, 5],PesqPict("SB1","B1_CODANT"))}}	//NETGERA
 					
oLbx:Refresh()

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F3B1Vis   �Autor  �Jonas L. Souza Jr   � Data �  04/16/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Visualiza cadastro do produto                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Dovac                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F3B1Vis(nRecSb1)
DEFAULT nRecSb1 := 0

If Empty(nRecSb1)
	ApMsgStop("Para visualizar selecione produto v�lido!")
Else
	DbSelectArea("SB1")
	DbGoTo(nRecSb1)
	A010Visul("SB1",SB1->(Recno()),2)
EndIf

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fSaldo
Description //Descri��o da Fun��o
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 31/05/2019 /*/
//--------------------------------------------------------------
Static Function fSaldo()

	MaViewSB2(oLBox:AARRAY[oLBox:NAT][2],,/*LOCAL*/)
	
Return .T.