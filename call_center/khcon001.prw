#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"

#Define ENTER Chr(10)+Chr(13)
//--------------------------------------------------------------
/*/{Protheus.doc} KHCON001
Description

@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 05/04/2019
/*/
//--------------------------------------------------------------
User Function KHCON001(lRet,cCod,dDataVid)
Local oButton1
Local oButton2
Local oButton3
Local oGet1
Local cLoja := SPACE(10)
Local oGet10
Local cHrVideo := SPACE(10)
Local oGet12
Local nQst3 := ""
Local oGet14
Local nQst4 := ""
Local oGet16
Local nQst5 := ""
Local oGet18
Local nQst6 := ""
Local oGet19
Local nQst7 := ""
Local dDtAva := DATE()
Local oGet2
Local cVendedor := SA3->A3_NREDUZ
Local oGet20
Local nPedido := 0
Local oGet21
Local nQtdAten := 0
Local oGet22
Local cRetorno := "NAO"
Local oGet23
Local nAprove := 0
Local oGet25
Local cLink := SPACE(50)
Local oGet26
Local cObs := ""
Local oGet28
Local nQst7 := ""
Local oGet3
Local oGet31
Local nQst8 := ""
Local oGet32
Local nQst9 := Space(10)
Local cHora := TIME()
Local oGet5
Local dSistema := DATE()
Local oGet6
Local nQst1 :=  ""
Local nTotal
Local oGet9
Local nQst2 := ""
Local oSay1
Local oSay10
Local oSay11
Local oSay12
Local oSay13
Local oSay14
Local oSay15
Local oSay16
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Local oComboBo1:=Space(3)
Local oComboBo2:=Space(3)
Local oComboBo3:=Space(3)
Local oComboBo4:=Space(3)
Local oComboBo5:=Space(3)
Local oComboBo6:=Space(3)
Local oComboBo7:=Space(3)
Local oComboBo8
Local oComboBo9
Local oComboBo10
Local cAvali := LogUserName()
local aRfun := {}
Local cCodVend := SA3->A3_COD
Local xPic := "@E 9.9"
Default lRet := .F.
Static oDlg


/*--------------------------------------------------------------
Validação de chamadas apartir da Static fAlterAva
No fonte U_KHCON002 Onde é feita a alteração dos dados
--------------------------------------------------------------*/

If lRet

	//Montagem do select pois o seek por data não retorna - 22/07/2019 - Marcio Nunes - 10807
	dbSelectArea("ZKB")                                                      
	cQuery1 := "SELECT ZKB_VENDED,ZKB_DTVIDE, ZKB_HRSIST, ZKB_HRVIDE, ZKB_DTSIST, ZKB_AVALIA, ZKB_QTDPED, ZKB_RETORN, ZKB_QTDATE, ZKB_LINK, "+ ENTER
	cQuery1 += " ISNULL(CAST(CAST(ZKB.ZKB_OBS AS VARBINARY(1024)) AS VARCHAR(1024)),'') AS ZKB_OBS,  "+ ENTER //TRATAMENTPO PARA CAMPO MEMO
	cQuery1 += " ZKB_TOTPON, ZKB_LOJA, ZKB_CODVEN, ZKB_PONT1, ZKB_PONT2, ZKB_PONT3, ZKB_PONT4, ZKB_PONT5, ZKB_PONT6, ZKB_PONT7, ZKB_PONT10, ZKB_APROVE "+ ENTER
	cQuery1 += " FROM "+ retSqlName("ZKB")+ " ZKB "+ ENTER         
	cQuery1 += " WHERE ZKB_DTVIDE = '"+dtos(dDataVid)+"' "+ ENTER                  
	cQuery1 += " AND ZKB_CODVEN = '"+cCod+"' AND D_E_L_E_T_='' "+ ENTER  
	
	cAliasV := getNextAlias()
	PLSQuery(cQuery1, cAliasV)
	
	If  (cAliasV)->(!Eof())
		cVendedor := Alltrim((cAliasV)->ZKB_VENDED)
		dDtAva    := (cAliasV)->ZKB_DTVIDE
		cHora     := (cAliasV)->ZKB_HRSIST
		cHrVideo  := (cAliasV)->ZKB_HRVIDE
		dSistema  := (cAliasV)->ZKB_DTSIST
		cAvali    := (cAliasV)->ZKB_AVALIA
		nPedido   := (cAliasV)->ZKB_QTDPED
		cRetorno  := (cAliasV)->ZKB_RETORN
		nQtdAten  := (cAliasV)->ZKB_QTDATE
		cLink     := (cAliasV)->ZKB_LINK          
		nTotal    := (cAliasV)->ZKB_TOTPON
		cObs      := (cAliasV)->ZKB_OBS
		cLoja     := (cAliasV)->ZKB_LOJA
		cCodVend  := (cAliasV)->ZKB_CODVEN
		nQst1     := cValtoChar((cAliasV)->ZKB_PONT1)
		nQst2     := cValtoChar((cAliasV)->ZKB_PONT2)
		nQst3     := cValtoChar((cAliasV)->ZKB_PONT3)
		nQst4     := cValtoChar((cAliasV)->ZKB_PONT4)
		nQst5     := cValtoChar((cAliasV)->ZKB_PONT5)
		nQst6     := cValtoChar((cAliasV)->ZKB_PONT6)
		nQst7     := cValtoChar((cAliasV)->ZKB_PONT7)
		nQst9	  := (cAliasV)->ZKB_PONT10
		nAprove   := (cAliasV)->ZKB_APROVE	
	EndIf
	
EndIf   


DEFINE FONT oFont NAME "Arial" SIZE 0, -11 BOLD
DEFINE MSDIALOG oDlg TITLE "Avaliação Monitoria" FROM 000, 000  TO 650, 755 COLORS 0, 16777215 PIXEL

@ 004, 016 SAY oSay1 PROMPT "Loja:" SIZE 024, 006 OF oDlg COLORS 0, 16777215 PIXEL
@ 004, 080 SAY oSay2 PROMPT "Vendedor:" SIZE 025, 007  OF oDlg COLORS 0, 16777215 PIXEL
@ 007, 277 SAY oSay3 PROMPT "Avaliador:" SIZE 031, 007  OF  oDlg COLORS 0, 16777215 PIXEL
@ 012, 016 MSGET oGet1 VAR cLoja SIZE 060, 010 F3 "SM0"  OF oDlg COLORS 0, 16777215 PIXEL
@ 012, 080 MSGET oGet2 VAR cVendedor SIZE 060, 010 When .F. OF oDlg COLORS 0, 16777215 PIXEL
@ 005, 312 MSGET oGet3 VAR cAvali SIZE 060, 010 When .F. OF oDlg COLORS 0, 16777215 PIXEL
@ 019, 277 SAY oSay4 PROMPT "Hora Sistema:" SIZE 036, 007  OF oDlg COLORS 0, 16777215 PIXEL
@ 017, 312 MSGET oGet4 VAR cHora SIZE 060, 010 When .F. OF oDlg COLORS 0, 16777215 PIXEL
@ 033, 277 SAY oSay5 PROMPT "Data Sistema:" SIZE 036, 007  OF oDlg COLORS 0, 16777215 PIXEL
@ 029, 312 MSGET oGet5 VAR dSistema SIZE 060, 010 When .F. OF oDlg COLORS 0, 16777215 PIXEL
@ 045, 280 SAY oSay6 PROMPT "PONTUAÇÃO:" SIZE 035, 006 OF oDlg COLORS 0, 16777215 PIXEL

@ 055, 280 MSCOMBOBOX oComboBo1 VAR nQst1 ITEMS {"0","0.5","1"} SIZE 030, 010 VALID {|| processa( {|| nTotal:= fTotal(nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7)}, "Aguarde...", "Atualizando Dados...", .F.)} OF oDlg COLORS 0, 16777215 PIXEL
oSay10:= TSay():New(045,016,{||'QUESTÕES:'  },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)//
oSay1:= TSay():New(055,016,{||'1 - RECEPÇÃO DO VENDEDOR AO CLIENTE NA PORTA (COM RAPIDEZ) - DE 0 A 1 PONTO'  },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)//
oSay2:= TSay():New(075,016,{||'2 - APRESENTAÇÃO E POSTURA DO VENDEDOR AO RECEBER O CLIENTE - DE 0 A 1 PONTO'  },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)//
@ 075, 280 MSCOMBOBOX oComboBo2 VAR nQst2 ITEMS {"0","0.5","1"} SIZE 030, 010 VALID {|| processa( {|| nTotal:= fTotal(nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7)}, "Aguarde...", "Atualizando Dados...", .F.)} OF oDlg COLORS 0, 16777215 PIXEL

@ 045, 325 SAY oSay8 PROMPT "Hora Video:" SIZE 037, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 055, 325 MSGET oGet10 VAR cHrVideo Picture "@E 99:99:99" SIZE 047, 010 OF oDlg COLORS 0, 16777215 PIXEL
oSay3:= TSay():New(095,016,{||'3 - VENDEDOR APRESENTOU OPÇÕES AO CLIENTE (ESCADA PRODUTOS) - DE 0 A 1 PONTO'  },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)//
@ 095, 280 MSCOMBOBOX oComboBo3 VAR nQst3 ITEMS {"0","0.5","1"} SIZE 030, 010 VALID {|| processa( {|| nTotal:= fTotal(nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7)}, "Aguarde...", "Atualizando Dados...", .F.)} OF oDlg COLORS 0, 16777215 PIXEL
oSay4:= TSay():New(115,016,{||'4 - HOUVE A QUALIFICAÇÃO DO PRODUTO PELO VENDEDOR - DE 0 A 1,5 PONTOS'  },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)//
@ 115, 280 MSCOMBOBOX oComboBo4 VAR nQst4 ITEMS {"0","0.5","1","1.5"} SIZE 030, 010 VALID {|| processa( {|| nTotal:= fTotal(nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7)}, "Aguarde...", "Atualizando Dados...", .F.)} OF oDlg COLORS 0, 16777215 PIXEL
oSay5:= TSay():New(135,016,{||'5 - CLIENTE RECEBEU ATENDIMENTO DE REPIQUE ANTES DE DEIXAR A LOJA - DE 0 A 1,5 PONTOS'  },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)//
@ 135, 280 MSCOMBOBOX oComboBo5 VAR nQst5 ITEMS {"0","0.5","1","1.5"} SIZE 030, 010 VALID {|| processa( {|| nTotal:= fTotal(nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7)}, "Aguarde...", "Atualizando Dados...", .F.)} OF oDlg COLORS 0, 16777215 PIXEL
oSay6:= TSay():New(155,016,{||'6 - ATENÇÃO DO VENDEDOR AO CLIENTE DURANTE TODO ATENDIMENTO - DE 0 A 2,0 PONTOS'  },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)//
//@ 155, 280 MSCOMBOBOX oComboBo6 VAR nQst6 ITEMS {"0","0.5","1","1.5","2.0"} SIZE 030, 010 VALID {|| processa( {|| nTotal:= fTotal(nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7)}, "Aguarde...", "Atualizando Dados...", .F.)} OF oDlg COLORS 0, 16777215 PIXEL
_aIt6 :={}
_aAux := {"0","0.5","1","1.5","2.0"}
npos := aScan(_aAux,{|R| R== nQst6 })
nx:= 0
aAdd(_aIt6,nQst6)
aEval(_aAux,{|R|nx++,if(npos <> nx,aAdd(_aIt6,R),Nil) })
oComboBo6 := TComboBox():New(155,280,{|u|if(PCount()>0,nQst6:=u,nQst6)}, _aIt6,030,010,oDlg,,{|| processa( {|| nTotal:= fTotal(nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7)}, "Aguarde...", "Atualizando Dados...", .F.)  },,,,.T.,,,,,,,,,'nQst6')
@ 076, 325 SAY oSay9 PROMPT "Data Video:" SIZE 036, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 085, 325 MSGet oGet19 Var dDtAva FONT oFont COLOR CLR_BLACK Pixel  SIZE 047, 010 VALID {|| processa( {|| nPedido:= fConSc5(dDtAva, cLoja, cCodVend)}, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oDlg
@ 099, 325 SAY oSay10 PROMPT "QTD Pedido:" SIZE 036, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 108, 325 MSGet oGet20 Var nPedido FONT oFont COLOR CLR_BLACK Pixel  SIZE 047, 010 When .F. Of oDlg
@ 124, 325 SAY oSay11 PROMPT "Atendimentos:" SIZE 036, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 134, 325 MSGet oGet21 Var nQtdAten Picture "@E 99"  FONT oFont COLOR CLR_BLACK Pixel  SIZE 047, 010 VALID {|| processa( {|| nAprove := fAprovei(nPedido,nQtdAten)}, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oDlg
@ 152, 325 SAY oSay12 PROMPT "10 por Venda?" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 163, 325 MSCOMBOBOX oComboBo10 VAR cRetorno ITEMS {"SIM","NAO"} SIZE 047, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 185, 325 SAY oSay13 PROMPT "Aproveitamento:" SIZE 041, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 216, 014 SAY oSay14 PROMPT "Link Gravação:" SIZE 041, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 195, 325 MSGet oGet23 Var nAprove Picture "@E 999"+"%" FONT oFont COLOR CLR_BLACK Pixel  SIZE 047, 010 When .F. Of oDlg
@ 214, 322 MSGet oGet24 Var nTotal Picture "@E 99.9" FONT oFont COLOR CLR_BLACK Pixel  SIZE 050, 010 When .F. Of oDlg
@ 216, 277 SAY oSay15 PROMPT "Total de Pontos:" SIZE 043, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 214, 061 MSGET oGet25 VAR cLink SIZE 213, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 236, 014 SAY oSay16 PROMPT "Observação" SIZE 036, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 252, 012 GET oGet26 VAR cObs MEMO SIZE 360, 045 OF oDlg COLORS 0, 16777215 PIXEL
@ 304, 285 BUTTON oButton1 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION(oDlg:End()) PIXEL
@ 304, 333 BUTTON oButton2 PROMPT "Salvar" SIZE 037, 012 OF oDlg ACTION (fGrava(lRet,cVendedor,dDtAva,cHora,dSistema,cAvali,;
cHrVideo,nAprove,nQtdAten,cRetorno,nPedido,cLink,cObs,cLoja,nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7,nQst9,cCodVend),oDlg:End()) PIXEL
@ 304, 012 BUTTON oButton3 PROMPT "PVs" SIZE 037, 012 OF oDlg ACTION(fVerPV(dDtAva,cLoja)) PIXEL
oSay7:= TSay():New(175,016,{||'7 - VENDEDOR LEVOU CLIENTE PARA MESA DE NEGOCIAÇÃO - DE 0 A 2,0 PONTOS'  },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)//
//@ 175, 280 MSCOMBOBOX oComboBo7 VAR nQst7 ITEMS {"0","0.5","1","1.5","2.0"} SIZE 030, 012 VALID {|| processa( {|| nTotal:= fTotal(nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7)}, "Aguarde...", "Atualizando Dados...", .F.)} OF oDlg COLORS 0, 16777215 PIXEL
_aIt7 :={}
_aAux := {"0","0.5","1","1.5","2.0"}
npos := aScan(_aAux,{|R| R== nQst7 })
nx:= 0
aAdd(_aIt7,nQst7)
aEval(_aAux,{|R|nx++,if(npos <> nx,aAdd(_aIt7,R),Nil) })
oComboBo7 := TComboBox():New(175,280,{|u|if(PCount()>0,nQst7:=u,nQst7)}, _aIt7,030,010,oDlg,,{|| processa( {|| nTotal:= fTotal(nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7)}, "Aguarde...", "Atualizando Dados...", .F.)  },,,,.T.,,,,,,,,,'nQst7')
oSay9:= TSay():New(195,016,{||'8 - QUANTO TEMPO O CLIENTE PERMANECEU EM LOJA (EM MINUTOS)'  },oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)//
@ 195, 280 MSGET oGet32 VAR nQst9 Picture "@E 99:99:99" SIZE 030, 010 VALID {|| processa( {|| nTotal:= fTotal(nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7)}, "Aguarde...", "Atualizando Dados...", .F.) } OF oDlg COLORS 0, 16777215 PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fInfCliente
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 11/02/2019 /*/
//--------------------------------------------------------------

Static function fGrava(lRet,cVendedor,dDtAva,cHora,dSistema,cAvali,cHrVideo,nAprove,nQtdAten,cRetorno,nPedido,cLink,;
cObs,cLoja,nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7,nQst9,cCodVend)


Local nTotal 	:= val(nQst1)+val(nQst2)+val(nQst3)+val(nQst4)+val(nQst5)+val(nQst6)+val(nQst7)
Local nAprove 	:= NOROUND((nPedido /nQtdAten)*100,0)
Local cUser 	:= LogUserName()
Local lGrava 	:= .T.


DbSelectArea("ZKB")
ZKB->(DbSetOrder(4))//ZKB_FILIAL+ZKB_CODVEN+ ZKB_DTSIST
If ZKB->(DbSeek(xFilial()+cCodVend+dtos(dDtAva)))
	If  lRet
		RecLock("ZKB",.F.)
		Alert("Prezado Sr.(a) "+ cUser + " Dados da Avaliação Alterados com sucesso!")
	Else
		lGrava := .F.
		Alert("Prezado Sr.(a) "+ cUser + " O Vendedor Já possuí avaliação para a data: "+ dtoc(dDtAva)+" Obrigado")
	EndIf
Else
	RecLock("ZKB",.T.)
	Alert("Prezado Sr.(a) "+ cUser + " Dados da Avaliação salvos com sucesso!")
EndIf

If lGrava
	ZKB->ZKB_FILIAL := xFilial()
	ZKB->ZKB_VENDED := cVendedor
	ZKB->ZKB_DTVIDE := dDtAva
	ZKB->ZKB_HRSIST := cHora
	ZKB->ZKB_HRVIDE := cHrVideo
	ZKB->ZKB_DTSIST := dSistema
	ZKB->ZKB_AVALIA := cAvali
	ZKB->ZKB_QTDPED := nPedido
	ZKB->ZKB_RETORN := cRetorno
	ZKB->ZKB_QTDATE := nQtdAten
	ZKB->ZKB_LINK   := cLink
	ZKB->ZKB_TOTPON := nTotal
	ZKB->ZKB_OBS    := cObs //
	ZKB->ZKB_LOJA   := cLoja //
	ZKB->ZKB_CODVEN := cCodVend
	ZKB->ZKB_PONT1  := Val(nQst1)
	ZKB->ZKB_PONT2  := Val(nQst2)
	ZKB->ZKB_PONT3  := Val(nQst3)
	ZKB->ZKB_PONT4  := Val(nQst4)
	ZKB->ZKB_PONT5  := Val(nQst5)
	ZKB->ZKB_PONT6  := Val(nQst6)
	ZKB->ZKB_PONT7  := Val(nQst7)
	ZKB->ZKB_PONT10  := nQst9
	ZKB->ZKB_APROVE := nAprove
	MsUnLock()
EndIf


Return
//--------------------------------------------------------------
/*/{Protheus.doc} fConSc5
Description: Quantidade de pedidos com Financeiro.
Tratamento para desconsiderar Trocas.
Mesma logica do COmercila 4BIS.
Marcio Nunes - Chamado:
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 05/04/2019 /*/
//--------------------------------------------------------------
Static function fConSc5(dDtAva,cLoja, cCodVend)

Local cQuery  		:= ""
Local cAliasPed  	:= ""
Local nPedido 		:= 0
Default cCodVend 	:= "" 

If (cCodVend == "")
	cCodVend := SA3->A3_COD
EndIf

Default	cLoja := ""//recebe a loja para não trazer pedidos a mais na query

dbSelectArea("SC5")
cQuery := "SELECT C5_NUM AS QTD "+ ENTER
cQuery += " FROM "+ retSqlName("SC5")+ " SC5 "+ ENTER
cQuery += " INNER JOIN "+ retSqlName("SUA")+ " UA  ON C5_NUMTMK=UA_NUM AND C5_MSFIL=UA_FILIAL "+ ENTER
cQuery += " INNER JOIN "+ retSqlName("SE1")+ " SE1 ON C5_MSFIL = E1_MSFIL AND (C5_NUM = E1_NUM AND C5_01SAC='' OR (C5_NUM = E1_PEDIDO AND C5_01SAC='')) AND C5_CLIENTE = E1_CLIENTE AND C5_LOJACLI = E1_LOJA "+ENTER
cQuery += " WHERE C5_EMISSAO = '"+dtos(dDtAva)+"' "+ ENTER
cQuery += " AND UA_VEND = '"+cCodVend+"' "+ ENTER
cQuery += " AND C5_MSFIL = '"+cLoja+"' "+ ENTER
cQuery += " AND SC5.D_E_L_E_T_ = '' "+ ENTER
cQuery += " AND SE1.D_E_L_E_T_ = '' "+ ENTER
cQuery += " AND UA.D_E_L_E_T_ ='' "+ ENTER
cQuery += " GROUP BY C5_NUM "+ ENTER

cAliasPed := getNextAlias()
PLSQuery(cQuery, cAliasPed)

While (cAliasPed)->(!Eof())
	nPedido += 1
	(cAliasPed)->(DbSkip())
EndDo

Return nPedido

//--------------------------------------------------------------
/*/{Protheus.doc} fAprovei
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 05/04/2019 /*/
//--------------------------------------------------------------
Static Function fAprovei(nPedido,nQtdAten)


Local nAprove := NOROUND((nPedido /nQtdAten)*100,0)




Return nAprove

//--------------------------------------------------------------
/*/{Protheus.doc} fTotal
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 05/04/2019 /*/
//--------------------------------------------------------------

Static Function fTotal(nQst1,nQst2,nQst3,nQst4,nQst5,nQst6,nQst7)

Local nTotal := (val(nQst1)+val(nQst2)+val(nQst3)+val(nQst4)+val(nQst5)+val(nQst6)+val(nQst7))

Return nTotal


//--------------------------------------------------------------
/*/{Protheus.doc} fTotal
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 05/04/2019 /*/
//--------------------------------------------------------------
Static function fConLoj(dDtAva)

Local cQuery  := ""
Local cAliasLoj := ""
Local cLoja := ""
LocaL cCodVend := SA3->A3_COD

dbSelectArea("SC5")
cQuery := "SELECT C5_MSFIL as LOJA"+ ENTER
cQuery += " FROM "+ retSqlName("SC5")+ ""+ ENTER
cQuery += " WHERE C5_EMISSAO = '"+dtos(dDtAva)+"'"+ ENTER
cQuery += " AND C5_VEND1 = '"+cCodVend+"'"+ ENTER
cQuery += " AND D_E_L_E_T_ = ' '"+ ENTER

cAliasLoj := getNextAlias()
PLSQuery(cQuery, cAliasLoj)
DbSelectArea(cAliasLoj)
(cAliasLoj)->(DbGoTop())
cLoja := (cAliasLoj)->LOJA
(cAliasLoj)->(dbCloseArea())

Return cLoja
//--------------------------------------------------------------

//--------------------------------------------------------------
Static Function fVerPV(dData, cLoja)

Local cAlias    := getNextAlias()
Local cQuery    := ''
Local nQnt      := 0
Local aSize     := MsAdvSize()
Local aPedVen   := {}
Local oTela 
Local oBrowse
Local aButtons := {} 

cQuery := " SELECT C5_NUM, C5_CLIENTE,C5_MSFIL, C5_VEND1, C5_EMISSAO " + CRLF
cQuery += " FROM SC5010(NOLOCK) SC5 " + CRLF
cQuery += " INNER JOIN SUA010(NOLOCK) SUA ON C5_NUMTMK = UA_NUM AND C5_MSFIL = UA_FILIAL " + CRLF 
cQuery += " INNER JOIN SE1010(NOLOCK) SE1 ON C5_MSFIL = E1_MSFIL AND (C5_NUM = E1_NUM AND C5_01SAC='' OR (C5_NUM = E1_PEDIDO AND C5_01SAC='')) AND C5_CLIENTE = E1_CLIENTE AND C5_LOJACLI = E1_LOJA " + CRLF
cQuery += " WHERE C5_MSFIL = '"+ cLoja +"' " + CRLF 
cQuery += " AND C5_CLIENTE <> '000001' " + CRLF 
cQuery += " AND C5_EMISSAO = '"+ DTOS(dData) +"' " + CRLF 
cQuery += " AND SC5.D_E_L_E_T_ = '' " + CRLF 
cQuery += " AND SE1.D_E_L_E_T_ = '' " + CRLF 
cQuery += " AND SUA.D_E_L_E_T_ ='' " + CRLF
cQuery += " GROUP BY C5_NUM, C5_CLIENTE,C5_MSFIL, C5_VEND1, C5_EMISSAO " + CRLF 
cQuery += " ORDER BY C5_NUM " + CRLF

PLSQuery(cQuery, cAlias)

while (cAlias)->(!eof())
	  nQnt++	
	  Aadd(aPedVen,{nQnt,;
	               (cAlias)->C5_NUM,;
	               Posicione("SA1",1,xFilial("SA1")+(cAlias)->C5_CLIENTE+(cAlias)->C5_MSFIL,"A1_NOME"),;
	               Posicione("SA3",1,xFilial("SA3")+(cAlias)->C5_VEND1,"A3_NOME"),;
	               (cAlias)->C5_EMISSAO })
	  (cALias)->(dbSkip())			 
EndDo

(cAlias)->(dbCloseArea())

If Len(aPedVen) <= 0
	Aadd(aPedVen,{0,'','','',CTOD("")})
EndIf

DEFINE MSDIALOG oTela FROM 0,0 TO 400, 800 TITLE "Pedidos de Venda da Loja " + cLoja Of oMainWnd PIXEL

AAdd(aButtons,{	'',{|| Regra() }, "Regra dos Pedidos"} )

EnchoiceBar(oTela,{ || },{ || oTela:End() },.F.,aButtons,,,.F.,.F.,.T.,.F.,.F.)

oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],,{'Nº','PEDIDO','CLIENTE','VENDEDOR','EMISSAO'},,oTela,,,,,,,,,,,, .F.,, .T.,, .T.,,,)

oBrowse:Setarray(aPedVen) 

oBrowse:bLine := {||,{aPedVen[oBrowse:nAt,01],aPedVen[oBrowse:nAt,02],aPedVen[oBrowse:nAt,03],aPedVen[oBrowse:nAt,04],aPedVen[oBrowse:nAt,05]}}
 														 
oBrowse:Align := CONTROL_ALIGN_ALLCLIENT 

oBrowse:Refresh()
 														 
ACTIVATE MSDIALOG oTela CENTERED

Return

//--------------------------------------------------------

//Tela para informar a regra definida pela monitoria para trazer os pedidos.
//--------------------------------------------------------
Static Function Regra()

Local otela
Local oSay1
Local oSay2
Local oFont

DEFINE MSDIALOG oTela FROM 0,0 TO 200, 600 TITLE "Regras definidas" Of oMainWnd PIXEL

oFont:= Tfont():New('courier new',, -12,.T.)

@ 010, 010 SAY oSay1 PROMPT "Considera: Todos os pedidos do dia e pedidos provenientes de RA." SIZE 500,20 FONT oFont OF oTela PIXEL

@ 030, 010 SAY oSay2 PROMPT "Não Considera: Pedidos do dia provenientes de Cancela Substitui e RA sem pedido." SIZE 500,20 FONT oFont OF oTela PIXEL


ACTIVATE MSDIALOG oTela CENTERED

return

//--------------------------------------------------------------