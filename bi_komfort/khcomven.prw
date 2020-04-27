#include 'protheus.ch'
#include 'parmtype.ch'

//--------------------------------------------------
//Tela Compras x Vendas -  Modulo retirado do 4Bis.
//Everton Santos - 14/11/2019
//--------------------------------------------------
user function KHCOMVEN()
	
Local aSize        := MsAdvSize()
Local cPesq        := Space(50)
Local cOrdPes      := ""
Local aPesq        := {"D=Descricao","C=Codigo"}
Private _aDados     := {} 
Private oLayer     := FWLayer():new()
Private aButtons   := {}
Private cCadastro  := "Vendas X Compras"
Private oTela
Private oLayer
Private oFont11
Private oPainel1
Private oPainel2
Private oPainel3
Private oPainel4
Private oBrowse1
Private oBrowse2 
Private oBrowse3
Private oCombPsq
Private oGet

DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE cCadastro Of oMainWnd PIXEL

AAdd(aButtons,{	'',{|| fExcelG(_aDados) }, "Exportar Excel"} )
EnchoiceBar(oTela,{ || oTela:End() },{ || oTela:End() },.F.,aButtons,,,.F.,.F.,.T.,.F.,.F.)

//Inicializa o FWLayer com a janela que ele pertencera e se sera exibido o botao de fechar
oLayer:init(oTela,.F.)
//Cria as Linhas do Layer
oLayer:AddLine("L01",10,.F.)
oLayer:AddLine("L02",70,.F.)
oLayer:AddLine("L03",20,.F.)
//Cria as colunas do Layer
oLayer:addCollumn('Col01_01',100,.F.,"L01")//Barra superior
oLayer:addCollumn('Col02_01',100,.F.,"L02")//Grid central
oLayer:addCollumn('Col03_01',50,.F.,"L03")//Grid inferior 1
oLayer:addCollumn('Col03_02',50,.F.,"L03")//Grid inferior 2
//Cria as janelas
oLayer:addWindow('Col01_01','C1_Win01_01','Pesquisa',100,.F.,.F.,/**/,"L01",/**/)
oLayer:addWindow('Col02_01','C1_Win02_01','Produtos',  100,.F.,.F.,/**/,"L02",/**/)
oLayer:addWindow('Col03_01','C1_Win03_01','Pedidos de Compra',100,.F.,.F.,/**/,"L03",/**/)
oLayer:addWindow('Col03_02','C1_Win03_02','Pedidos de Venda',100,.F.,.F.,/**/,"L03",/**/)
//Adiciona os paineis aos objetos
oPainel1 := oLayer:GetWinPanel('Col01_01','C1_Win01_01',"L01")
oPainel2 := oLayer:GetWinPanel('Col02_01','C1_Win02_01',"L02")
oPainel3 := oLayer:GetWinPanel('Col03_01','C1_Win03_01',"L03")
oPainel4 := oLayer:GetWinPanel('Col03_02','C1_Win03_02',"L03")

@002,002 MSCOMBOBOX oCombPsq Var cOrdPes  ITEMS aPesq SIZE 050, 013 OF oPainel1 PIXEL
@002,055 MSGET oGet VAR cPesq SIZE 200, 010 OF oPainel1 PIXEL
@002,260 BUTTON "&Pesquisar" SIZE 050, 012 ACTION Processa({|| fCarr(cPesq,cOrdPes)},"Aguarde...","Carregando lista de Produtos...",.F.) OF oPainel1 PIXEL

//Grid Central
oBrowse1 := TwBrowse():New(000, 000, oPainel2:nClientWidth/2, oPainel2:nClientHeight/2,, { 'Produto',;
                                                            							   'Descrição',;
                                                                                           'Tipo',;
                                                                                           'FL',;
                                                                                           'Fornecedor',;
                                                                                           'Tecido',;
                                                                                           'Conjunto',;
                                                                                           'Estoque',;
                                                                                           'Solicitação',;
                                                                                           'Compra',;
                                                                                           'Venda',;
                                                                                           'Agendado',;
                                                                                           'Prioridade',;
                                                                                           'Outros',;
                                                                                           'Necessidade'  },,oPainel2,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
                                                                                           
//Grid Pedidos de Compras                                                                                           
oBrowse2 := TwBrowse():New(000, 000, oPainel3:nClientWidth/2, oPainel3:nClientHeight/2,, { 'Pedido',;
                                                            							   'Emissão',;
                                                                                           'Previsão',;
                                                                                           'Quantidade',;
                                                                                           'Preço',;
                                                                                           'Situação' },,oPainel3,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
                                                                                           
//Grid Pedidos de vendas                                                                                             
oBrowse3 := TwBrowse():New(000, 000, oPainel4:nClientWidth/2, oPainel4:nClientHeight/2,, { 'Pedido',;
                                                            							   'Emissão',;
                                                                                           'Previsão',;
                                                                                           'Quantidade',;
                                                                                           'Preço',;
                                                                                           'Situação' },,oPainel4,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
                                                                                                                                                                                                                                                                   
oBrowse1:bChange := {|| fCarPC(_aDados[oBrowse1:nAt,01]),fCarPV(_aDados[oBrowse1:nAt,01]),SetCab1(_aDados[oBrowse1:nAt,01])}
oBrowse1:nScrollType := 1
oBrowse1:setFocus()

fCarr()

ACTIVATE MSDIALOG oTela CENTERED

return

//Função que carrega o grid prinicpal
Static Function fCarr(cPesq,cOrdPes)
Local nRegistros := nCount := 0    
Local cAlias := getNextAlias()
Local cQuery := ""
Local cPesq1 := "("
Local cPesq2 := ")"
Local cCpo   := IIf(cOrdPes == "D", "SB1.B1_DESC", IIf(cOrdPes == "C", "SB1.B1_COD", "SB1.B1_COD"))
Local aLikes := {}
Local nx
Local lQuery := .F.
Default cOrdPes := "D" 
Default cPesq   := ""

// Retira aspas simples e duplas
cPesq    := StrTran(cPesq,"'"," ")
cPesq    := StrTran(cPesq,'"'," ")

// Retira espacos em branco do campo de pesquisa.
cPesq    := Alltrim(cPesq)

// Transformo a pesquisa digitada em letras maiusculas
cPesq    := Upper(cPesq)

// Gera array com likes da pesquisa.
aLikes   := StrToKArr(cPesq, " ")

// Limpo o array do grid principal
_aDados := {}

//Query retirada do 4bis    
cQuery := " SELECT PRODUTO, DESCRICAO, TIPO, FL, FORNECEDOR,"+CRLF
cQuery += " ''TECIDO,"+CRLF 
cQuery += " ''CONJUNTO,"+CRLF
cQuery += "  ESTOQUE, SOLICITACAO, COMPRA, VENDA, AGENDADO, PRIORIDADE, OUTROS, (VENDA-ESTOQUE-COMPRA) NECESSIDADE"+CRLF
cQuery += " FROM ("+CRLF
cQuery += " 	SELECT PRODUTO, B1_DESC DESCRICAO, CASE WHEN B1_XENCOME = '2' THEN 'ENCOMENDA' ELSE 'GIRO' END TIPO, B1_01FORAL FL, A2_NREDUZ FORNECEDOR,"+CRLF
cQuery += " 		''TECIDO,"+CRLF
cQuery += " 		''CONJUNTO,"+CRLF
cQuery += " 		SUM(ESTOQUE) ESTOQUE, SUM(SOLICITACAO) SOLICITACAO, SUM(COMPRA) COMPRA, SUM(VENDA) VENDA, SUM(AGENDADO) AGENDADO, SUM(PRIORIDADE) PRIORIDADE, SUM(OUTROS) OUTROS"+CRLF 
cQuery += " 	FROM ("+CRLF
cQuery += " 		SELECT C6_PRODUTO PRODUTO, 0 ESTOQUE, 0 SOLICITACAO, 0 COMPRA, (C6_QTDVEN-C6_QTDENT) VENDA,"+CRLF
cQuery += " 			CASE WHEN C6_01AGEND = '1' THEN (C6_QTDVEN-C6_QTDENT) ELSE 0 END AGENDADO,"+CRLF
cQuery += " 			CASE WHEN C6_01AGEND <> '1' AND C6_ENTREG <= CONVERT(VARCHAR,DATEADD(DAY,15,GETDATE()),112) THEN (C6_QTDVEN-C6_QTDENT) ELSE 0 END PRIORIDADE,"+CRLF
cQuery += " 			CASE WHEN C6_01AGEND <> '1' AND C6_ENTREG > CONVERT(VARCHAR,DATEADD(DAY,15,GETDATE()),112) THEN (C6_QTDVEN-C6_QTDENT) ELSE 0 END OUTROS"+CRLF
cQuery += " 		FROM SC6010 SC6 (NOLOCK)"+CRLF
cQuery += " 		INNER JOIN SC5010 SC5 (NOLOCK) ON SC5.D_E_L_E_T_ = '' AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM"+CRLF
cQuery += " 		WHERE SC6.D_E_L_E_T_ = '' AND C6_BLQ = '' AND C6_NOTA = '' AND C6_QTDVEN-C6_QTDENT > 0 AND C5_TIPO = 'N'"+CRLF
cQuery += " 		UNION ALL"+CRLF
cQuery += " 		SELECT B2_COD, B2_QATU, 0, 0, 0, 0, 0, 0"+CRLF
cQuery += " 		FROM " + retSqlName('SB2') + "(NOLOCK) SB2 "+CRLF
cQuery += " 		WHERE SB2.D_E_L_E_T_ = '' AND B2_FILIAL = '0101' AND B2_LOCAL IN ('01')"+CRLF
cQuery += " 		UNION ALL"+CRLF
cQuery += " 		SELECT C1_PRODUTO, 0, C1_QUANT-C1_QUJE, 0, 0, 0, 0, 0"+CRLF
cQuery += " 		FROM SC1010 SC1 (NOLOCK)"+CRLF
cQuery += " 		WHERE SC1.D_E_L_E_T_ = '' AND (C1_QUANT-C1_QUJE) > 0"+CRLF
cQuery += " 		UNION ALL"+CRLF
cQuery += " 		SELECT C7_PRODUTO, 0, 0, C7_QUANT-C7_QUJE, 0, 0, 0, 0"+CRLF
cQuery += " 		FROM SC7010 SC7 (NOLOCK)"+CRLF
cQuery += " 		WHERE SC7.D_E_L_E_T_ = '' AND (C7_QUANT-C7_QUJE) > 0 AND C7_RESIDUO = ''"+CRLF
cQuery += " 	) AS W1"+CRLF
cQuery += " 	INNER JOIN SB1010 SB1 (NOLOCK) ON SB1.D_E_L_E_T_ = '' AND PRODUTO = B1_COD"+CRLF
cQuery += " 	INNER JOIN SA2010 SA2 (NOLOCK) ON SA2.D_E_L_E_T_ = '' AND B1_PROC = A2_COD AND B1_LOJPROC = A2_LOJA"+CRLF
cQuery += " 	WHERE B1_TIPO = 'ME' AND (ESTOQUE > 0 OR VENDA > 0 OR COMPRA > 0)"+CRLF

If !Empty(aLikes)
	For nX := 1 to len(aLikes)
		cQuery += "AND " + cCpo + " LIKE '%"+ aLikes[nX] + "%' " + CRLF
	Next nX
EndIf

cQuery += " 	GROUP BY PRODUTO, B1_DESC, B1_XENCOME, B1_01FORAL, A2_NREDUZ"+CRLF
cQuery += " ) AS W2"+CRLF
cQuery += " ORDER BY FL, FORNECEDOR, TIPO, TECIDO, CONJUNTO, PRODUTO"+CRLF

PlsQuery(cQuery, cAlias)
	
(cAlias)->(dbEval({|| nRegistros++}))
(cAlias)->(dbgotop())
    
procregua(nRegistros)

lQuery := (cAlias)->(!eof())   

while (cAlias)->(!eof())
		
	nCount++
	incproc("Atualizando Dados... " + cValtoChar(nCount) + " de " + cValtoChar(nRegistros))
	
	aAdd(_aDados,{   (cAlias)->PRODUTO,;	
					 (cAlias)->DESCRICAO,;
					 (cAlias)->TIPO,;
					 (cAlias)->FL,;
					 (cAlias)->FORNECEDOR,;
					 SubStr((cAlias)->DESCRICAO , AT('-',   (cAlias)->DESCRICAO)+1 , (RAT('-',   (cAlias)->DESCRICAO)-1) - (AT('-',   (cAlias)->DESCRICAO)+1)),; //Tecido
					 SubStr((cAlias)->DESCRICAO , AT(cPesq1,(cAlias)->DESCRICAO)+3 , (RAT(cPesq2,(cAlias)->DESCRICAO)) - (AT(cPesq1,(cAlias)->DESCRICAO)+3)),; // Conjunto
					 (cAlias)->ESTOQUE,;
					 (cAlias)->SOLICITACAO,;
					 (cAlias)->COMPRA,;
					 (cAlias)->VENDA,;
					 (cAlias)->AGENDADO,;
					 (cAlias)->PRIORIDADE,;
					 (cAlias)->OUTROS,;
					 (cAlias)->NECESSIDADE    })
			 
	(cAlias)->(dbskip())		
end
	
(cAlias)->(dbCloseArea())
    
if len(_aDados) <= 0
   	aAdd(_aDados,{"","","","","","","","","","","","","","",""})
endif


oBrowse1:SetArray(_aDados)

oBrowse1:bLine := {|| { _aDados[oBrowse1:nAt,01],;
                        _aDados[oBrowse1:nAt,02],;
                        _aDados[oBrowse1:nAt,03],;
                        _aDados[oBrowse1:nAt,04],;
                        _aDados[oBrowse1:nAt,05],;
                        _aDados[oBrowse1:nAt,06],;
                        _aDados[oBrowse1:nAt,07],;
                        _aDados[oBrowse1:nAt,08],;
                        _aDados[oBrowse1:nAt,09],;
                        _aDados[oBrowse1:nAt,10],;
                        _aDados[oBrowse1:nAt,11],;
                        _aDados[oBrowse1:nAt,12],;
                        _aDados[oBrowse1:nAt,13],;
                        _aDados[oBrowse1:nAt,14],;
                        _aDados[oBrowse1:nAt,15];
                        }}

fCarPC(Iif(!lQuery,"X",_aDados[oBrowse1:nAt,01]))
fCarPV(Iif(!lQuery,"X",_aDados[oBrowse1:nAt,01]))

oBrowse1:refresh()
oBrowse1:Align := CONTROL_ALIGN_ALLCLIENT
oBrowse1:setFocus()

oLayer:Refresh()
	
Return

//------------------------------------------------------------------------------------------------
//Função que carrega o grid de Pedidos de Compras 
Static Function fCarPC(_cProduto)
    
Local cAlias   := getNextAlias()
Local cQuery   := ""
Local aDadosPC := {}
Local nRegistros := nCount := 0
Default _cProduto := "X"
   
cQuery := " SELECT C7_NUM, C7_EMISSAO, C7_DATPRF, C7_QUANT-C7_QUJE SALDO, C7_PRECO "+CRLF
cQuery += " FROM " + RetSqlName('SC7') + " SC7 (NOLOCK) "+CRLF
cQuery += " WHERE SC7.D_E_L_E_T_ = '' "+CRLF 
cQuery += " AND (C7_QUANT-C7_QUJE) > 0 "+CRLF 
cQuery += " AND C7_RESIDUO = '' "+CRLF
cQuery += " AND C7_PRODUTO = '"+ _cProduto +"' "+CRLF

PlsQuery(cQuery, cAlias)
	
(cAlias)->(dbEval({|| nRegistros++}))
(cAlias)->(dbgotop())
    
procregua(nRegistros)
    
while (cAlias)->(!eof())
		
	nCount++
	incproc("Atualizando Dados... " + cValtoChar(nCount) + " de " + cValtoChar(nRegistros))
	
	aAdd(aDadosPC,{  (cAlias)->C7_NUM,;	
					 (cAlias)->C7_EMISSAO,;
					 (cAlias)->C7_DATPRF,;
					 (cAlias)->SALDO,;
					 (cAlias)->C7_PRECO,;
					 "Em Aberto" })
			 
	(cAlias)->(dbskip())		
end
	
(cAlias)->(dbCloseArea())
    
if len(aDadosPC) <= 0
   	aAdd(aDadosPC,{"","","","","",""})
endif


oBrowse2:SetArray(aDadosPC)

oBrowse2:bLine := {|| { aDadosPC[oBrowse2:nAt,01],;
                        aDadosPC[oBrowse2:nAt,02],;
                        aDadosPC[oBrowse2:nAt,03],;
                        aDadosPC[oBrowse2:nAt,04],;
                        Transform(aDadosPC[oBrowse2:nAt,05], "@E 999,999.99"),;
                        aDadosPC[oBrowse2:nAt,06];
                        }}

oBrowse2:refresh()
oBrowse2:setFocus()
oBrowse2:Align := CONTROL_ALIGN_ALLCLIENT

Return

//-------------------------------------------------------------------------------------------------------------------------------
//Função que carrega o grid de Pedidos de Venda 
Static Function fCarPV(_cProduto)
    
Local cAlias      := getNextAlias()
Local cQuery      := ""
Local aDadosPV    := {}
Local nRegistros  := nCount := 0
Default _cProduto := "X"
   
cQuery := " SELECT C5_NUM, C5_EMISSAO, C6_ENTREG, (C6_QTDVEN-C6_QTDENT) SALDO, C6_PRCVEN, "+CRLF
cQuery += " CASE WHEN C6_01AGEND = '1' THEN 'AGENDADO' "+CRLF
cQuery += "      WHEN C6_01AGEND <> '1' AND C6_ENTREG <= CONVERT(VARCHAR,DATEADD(DAY,15,GETDATE()),112) THEN 'PRIORIDADE' "+CRLF
cQuery += "      ELSE 'OUTROS' END SITUACAO "+CRLF
cQuery += " FROM " + RetSqlName('SC6') + " SC6 (NOLOCK) "+CRLF
cQuery += " INNER JOIN " + RetSqlName('SC5') + " SC5 (NOLOCK) ON SC5.D_E_L_E_T_ = '' AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM "+CRLF
cQuery += " WHERE SC6.D_E_L_E_T_ = '' AND C6_BLQ = '' AND C6_NOTA = '' AND C6_QTDVEN-C6_QTDENT > 0 AND C5_TIPO = 'N' "+CRLF
cQuery += "  AND C6_PRODUTO = '"+ _cProduto +"' "+CRLF

PlsQuery(cQuery, cAlias)
	
(cAlias)->(dbEval({|| nRegistros++}))
(cAlias)->(dbgotop())
    
procregua(nRegistros)
    
while (cAlias)->(!eof())
		
	nCount++
	incproc("Atualizando Dados... " + cValtoChar(nCount) + " de " + cValtoChar(nRegistros))
	
	aAdd(adadosPV,{  (cAlias)->C5_NUM,;	
					 (cAlias)->C5_EMISSAO,;
					 (cAlias)->C6_ENTREG,;
					 (cAlias)->SALDO,;
					 (cAlias)->C6_PRCVEN,;
					 (cAlias)->SITUACAO,;
					  })
			 
	(cAlias)->(dbskip())		
end
	
(cAlias)->(dbCloseArea())
    
if len(aDadosPV) <= 0
   	aAdd(aDadosPV,{"","","","","",""})
endif


oBrowse3:SetArray(aDadosPV)

oBrowse3:bLine := {|| { aDadosPV[oBrowse3:nAt,01],;
                        aDadosPV[oBrowse3:nAt,02],;
                        aDadosPV[oBrowse3:nAt,03],;
                        aDadosPV[oBrowse3:nAt,04],;
                        Transform(aDadosPV[oBrowse3:nAt,05], "@E 999,999.99"),;
                        aDadosPV[oBrowse3:nAt,06]}}

oBrowse3:refresh()
oBrowse3:setFocus()
oBrowse3:Align := CONTROL_ALIGN_ALLCLIENT
	
Return

//--------------------------------------------------------------
Static Function SetCab1(cParam1)
	
	if !(empty(cParam1))
		cCab1 :="Produto: " + Alltrim(cParam1)
		cCab2 :="Pedido de Compra - Produto: " + Alltrim(cParam1)
		cCab3 :="Pedido de Venda - Produto: " + Alltrim(cParam1)
		oLayer:setWinTitle('Col02_01','C1_Win02_01',cCab1 ,"L02" )
		oLayer:setWinTitle('Col03_01','C1_Win03_01',cCab2 ,"L03" )
		oLayer:setWinTitle('Col03_02','C1_Win03_02',cCab3 ,"L03" )
	endif

Return
//--------------------------------------------------------------

//--------------------------------------------------------------
Static Function fExcelG(aItens)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "KHCOMVEN"+substr(time(), 7, 2)+".XLS"
	Local aCab := {}
	Local aFields := {"Produto","Descrição","Tipo","ForaLinha","Fornecedor","Tecido","Conjunto","Estoque","Solicitação","Compra","Venda","Agendado","Prioridade","Outros","Necessidade"}
    Local nx := 0
    Local nr := 0
    Local cTitle := "Lista de produtos"

    if len(aItens) <= 0 
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
		if aCab[nx][8] == "C"// Tipo Caracter
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		elseif aCab[nx][8] == "N"// Tipo Numerico
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],3,2)
		elseif aCab[nx][8] == "D" // Tipo Data
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,3)			
		else
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		endif
	next nx

    for nr := 1 to len(aItens) 
	   	oExcel:AddRow(cNamePlan,cNameTable,{;
	   										aItens[nr][1],;
											aItens[nr][2],;
                                            aItens[nr][3],;
											aItens[nr][4],;
                                            aItens[nr][5],;
                                            aItens[nr][6],;
                                            aItens[nr][7],;
                                            aItens[nr][8],;
                                            aItens[nr][9],;
                                            aItens[nr][10],;
                                            aItens[nr][11],;
                                            aItens[nr][12],;
                                            aItens[nr][13],;
                                            aItens[nr][14],;
                                            aItens[nr][15];
                                            })
	next nr
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
	
Return
