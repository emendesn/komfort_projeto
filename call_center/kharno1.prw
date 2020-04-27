#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ±±
±±³Funcao ³KHARNO1      ³ Autor ³ Vanito Rocha           ³ Data ³26/06/19  ±±
±±ÃÄÄÄÄÄÄÄÁÄÄÂÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ±±
±±³Descricao ³ Carregar tela de Orçamentos Pendentes na abertura do sistema±±
±±³          ³ de acordo com a Tabela SU7 e seus supervisores e o          ±±
±±³          ³ parâmetro KH_ADMORCA onde ficam os gestores                 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function KHARNO1(cFilIni,cFilFim)

Local aSize     	:= MsAdvSize()
Local aButtons  	:= {}
Local nx			:=0
Private cxFilLg 	:= cFilAnt
Private cUsrGer 	:= ""
Private cCodGer		:=SuperGetMV("KH_ADMORCA",.F.,"001184")
Private aOrcPriori 	:= {}
Private aOrcFila 	:= {}
Private oTela, oOrcPriori, oOrcFila
Private oSpDiv
Private oBrwSup
Private oBrwInf
Private cOrder := "decrescente"


DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "Controle de Orçamentos" Of oMainWnd PIXEL

oPanel := TPanel():New(000,000,,oTela, NIL, .T., .F., NIL, NIL,000,000, .T., .F. )
oPanel:Align := CONTROL_ALIGN_ALLCLIENT

oSpDiv := TSplitter():New( 30,01,oTela,675,270, 1 ) // Orientacao Vertical
oSpDiv:setCSS("QSplitter::handle:vertical{background-color: #0080FF; height: 4px;}")
oSpDiv:align := CONTROL_ALIGN_ALLCLIENT
oPnlSup := TPanel():New(000,000,,oSpDiv, NIL, .T., .F., NIL, NIL,aSize[6],aSize[5], .T., .F. )
oPnlInf := TPanel():New(150,000,,oSpDiv, NIL, .T., .F., NIL, NIL,aSize[6],aSize[5], .T., .F. )

//Orcamentos sem Pedidos
oBrwSup := TwBrowse():New(005, 005, aSize[6], aSize[5],, {'Filial','Orcamento','Cod. Cliente','Loja Cliente','Nome Cliente','Contato','Data Orcamento', 'Valor Orc.'},,oPnlSup,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
CarregaOrc()
oBrwSup:SetArray(aOrcPriori)
oBrwSup:bLDblClick := {|| fSetOPeracao(aOrcPriori[oBrwSup:nAt][1],aOrcPriori[oBrwSup:nAt][2],aOrcPriori[oBrwSup:nAt][9]),oBrwSup:AARRAY := aOrcPriori,oBrwSup:Refresh() }
oBrwSup:Align := CONTROL_ALIGN_ALLCLIENT

//Pedidos com Titulos no Financeiro
oBrwInf := TwBrowse():New(005, 005, aSize[6], aSize[5],, {'Filial','Cod. Cliente','Loja Cliente','Nome Cliente','Tipo','Valor','Data Pedido'},,oPnlInf,,,,,,,,,,,, .F.,, .T.,, .T.,,,)

oBrwInf:bLDblClick := {|| /*fSetOPeracao(oBrwInf:nColPos,aOrcFila[oBrwInf:nAt])*/  }
oBrwInf:bHeaderClick := {|o, iCol| fSetOrder(iCol), oBrwInf:Refresh()}
CarregaRa()
oBrwSup:bLine := {|| {   alltrim(U_RETDESCFI(aOrcPriori[oBrwSup:nAt,01])) ,;
aOrcPriori[oBrwSup:nAt,02] ,;
aOrcPriori[oBrwSup:nAt,03] ,;
aOrcPriori[oBrwSup:nAt,04] ,;
aOrcPriori[oBrwSup:nAt,05] ,;
aOrcPriori[oBrwSup:nAt,06] ,;
aOrcPriori[oBrwSup:nAt,07] ,;
aOrcPriori[oBrwSup:nAt,08] }}

SetKey(VK_F5, {|| processa( {|| CarregaOrc(), CarregaRa() }, "Aguarde...", "Carregando os RA´s...", .f.) })

If Empty(aOrcPriori[oBrwSup:nAt,04])
	
	Return
	
Endif

ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || oTela:End()} , { || oTela:End() },, aButtons)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ±±
±±³Funcao ³CarregaOrc      ³ Autor ³ Vanito Rocha        ³ Data ³26/06/19  ±±
±±ÃÄÄÄÄÄÄÄÁÄÄÂÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ±±
±±³Descricao ³ Carregar tela de Orçamentos Pendentes na abertura do sistema±±
±±³          ³ de acordo com a Tabela SU7 e seus supervisores e o          ±±
±±³          ³ parâmetro KH_ADMORCA onde ficam os gestores                 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function CarregaOrc()

Local cAlias := getNextAlias()
Local cQuery := ""
Local cStatus := ""

cQuery := " SELECT UA_FILIAL FILIAL, UA_NUM ORCAMENTO, CASE WHEN UA_OPER='2' THEN 'ORCAMENTO' ELSE 'PEDIDO' END TIPO, "
cQuery += " A1_COD CODIGO_CLIENTE, UA_LOJA LOJA_CLIENTE , A1_NOME NOME_CLIENTE, UA_CLIENTE CODIGO_CLIENTE, "
cQuery += " UA_DESCNT CONTATO, UA_EMISSAO, UA_VLRLIQ,SUA.R_E_C_N_O_ SUARECNO "
cQuery += " FROM SUA010 SUA JOIN SA1010 (NOLOCK) SA1 ON SUA.UA_CLIENTE=SA1.A1_COD AND SUA.UA_LOJA=SA1.A1_LOJA "
cQuery += " WHERE SUA.UA_OPER IN ('2') AND SUA.D_E_L_E_T_=''  AND SUA.UA_EMISSAO >='20190501' AND UA_STATUS<>'CAN' AND UA_FILIAL BETWEEN '"+cFilIni+"' AND '"+cFilFim+"'"
cQuery += " ORDER BY UA_FILIAL, UA_NUM "

PLSQuery(cQuery, cAlias)

aOrcPriori := {}

while (cAlias)->(!eof())
	
	aAdd(aOrcPriori,{   (cAlias)->FILIAL,;
	(cAlias)->ORCAMENTO,;
	(cAlias)->CODIGO_CLIENTE,;
	(cAlias)->LOJA_CLIENTE,;
	Posicione("SA1",1,xFilial("SA1")+(cAlias)->CODIGO_CLIENTE+(cAlias)->LOJA_CLIENTE,"A1_NOME"),;
	(cAlias)->CONTATO,;
	(cAlias)->UA_EMISSAO ,;
	Transform((cAlias)->UA_VLRLIQ,PesqPict("SUA","UA_VLRLIQ")),;
	(cAlias)->SUARECNO })
	
	(cAlias)->(dbskip())
End

(cAlias)->(dbCloseArea())

if len(aOrcPriori) == 0
	AAdd(aOrcPriori, {"","","","","","",CTOD("  /  /  "),Transform(0,PesqPict("SUA","UA_VLRLIQ"))})
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ±±
±±³Funcao ³CarregaRa       ³ Autor ³ Vanito Rocha        ³ Data ³26/06/19  ±±
±±ÃÄÄÄÄÄÄÄÁÄÄÂÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ±±
±±³Descricao ³ Carregar tela de Orçamentos Pendentes na abertura do sistema±±
±±³          ³ de acordo com a Tabela SU7 e seus supervisores e o          ±±
±±³          ³ parâmetro KH_ADMORCA onde ficam os gestores                 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CarregaRa()

Local cAlias := getNextAlias()
Local cQuery := ""
Local cStatus := ""

cQuery := " SELECT E1_MSFIL, E1_PEDIDO, E1_CLIENTE, E1_LOJA, "
cQuery += " E1_SALDO, E1_TIPO, E1_EMISSAO,R_E_C_N_O_ E1RECNO FROM SE1010 "
cQuery += " WHERE E1_TIPO IN ('RA') AND E1_SALDO > 0 AND D_E_L_E_T_='' AND E1_MSFIL BETWEEN '"+cFilIni+"' AND '"+cFilFim+"'"
cQuery += " ORDER BY E1_MSFIL, E1_PEDIDO "
PLSQuery(cQuery, cAlias)

aOrcFila := {}

while (cAlias)->(!eof())
	
	aAdd(aOrcFila,{(cAlias)->E1_MSFIL,;
	(cAlias)->E1_CLIENTE,;
	(cAlias)->E1_LOJA,;
	Posicione("SA1",1,xFilial("SA1")+(cAlias)->E1_CLIENTE+(cAlias)->E1_LOJA,"A1_NOME"),;
	(cAlias)->E1_TIPO,;
	Transform((cAlias)->E1_SALDO,PesqPict("SE1","E1_SALDO")),;
	(cAlias)->E1_EMISSAO,;
	(cAlias)->E1RECNO})
	
	(cAlias)->(dbskip())
End

(cAlias)->(dbCloseArea())

if len(aOrcFila) == 0
	AAdd(aOrcPriori, {"","","","","","",CTOD("  /  /  "),Transform(0,PesqPict("SUA","UA_VLRLIQ"))})
endif

If Len(aOrcFila) > 0
	oBrwInf:SetArray(aOrcFila)
	
	oBrwInf:bLine := {|| {   alltrim(U_RETDESCFI(aOrcFila[oBrwInf:nAt,01])) ,;
	aOrcFila[oBrwInf:nAt,02] ,;
	aOrcFila[oBrwInf:nAt,03] ,;
	aOrcFila[oBrwInf:nAt,04] ,;
	aOrcFila[oBrwInf:nAt,05] ,;
	aOrcFila[oBrwInf:nAt,06] ,;
	aOrcFila[oBrwInf:nAt,07] }}
	
Endif
oBrwInf:Align := CONTROL_ALIGN_ALLCLIENT

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ±±
±±³Funcao ³fSetOrder       ³ Autor ³ Vanito Rocha        ³ Data ³26/06/19  ±±
±±ÃÄÄÄÄÄÄÄÁÄÄÂÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ±±
±±³Descricao ³ Carregar tela de Orçamentos Pendentes na abertura do sistema±±
±±³          ³ de acordo com a Tabela SU7 e seus supervisores e o          ±±
±±³          ³ parâmetro KH_ADMORCA onde ficam os gestores                 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fSetOrder(iCol)

if iCol == 4
	if cOrder == "decrescente"
		oBrwInf:aarray := aSort(oBrwInf:aarray, , , {|x,y| x[iCol] > y[iCol]})
		cOrder := "crescente"
	else
		oBrwInf:aarray := aSort(oBrwInf:aarray, , , {|x,y| x[iCol] < y[iCol]})
		cOrder := "decrescente"
	endif
	
	oBrwInf:Refresh()
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ±±
±±³Funcao ³fSetOPeracao    ³ Autor ³ Vanito Rocha        ³ Data ³26/06/19  ±±
±±ÃÄÄÄÄÄÄÄÁÄÄÂÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ±±
±±³Descricao ³ Carregar tela de Orçamentos Pendentes na abertura do sistema±±
±±³          ³ de acordo com a Tabela SU7 e seus supervisores e o          ±±
±±³          ³ parâmetro KH_ADMORCA onde ficam os gestores                 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fSetOPeracao(c_Filial,c_Orcam,nUARecno)
Local lRet := .F.

If MsgNoYes("Deseja exluir o orçamento: "+c_Orcam+", da Filial: "+c_Filial+"?","EXCLUSAO ORÇAMENTO")
	u_fTK150Ex("SUA",nUARecno,5,c_Orcam)
	CarregaOrc() // Após a exlcusão chama a função para recarregar a tela
	lRet := .T.
Endif
Return lRet
