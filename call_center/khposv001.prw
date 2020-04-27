#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description                                                     

@param xParam Parameter Description                             
@return xRet Return Description                                 
@author  -
@since 21/03/2019                                                   
/*/                                                             
//--------------------------------------------------------------
user function KHPOSV001()                     
Local oButton1
Local oButton2
Local oComboBo1
Local nAtenLoja :="ND"
Local oComboBo10
Local nAvariaEntre :="ND"
Local oComboBo11
Local nAcompClie :="ND"
Local oComboBo12
Local nQualProd  :="ND"
Local oComboBo13
Local nTroca  :="ND"
Local oComboBo14
Local nCustoBene  :="ND"
Local oComboBo2
Local nAtendVend  :="ND"
Local oComboBo3
Local nAtendGer :="ND"
Local oComboBo4
Local nOportComp :="ND"
Local oComboBo5
Local nAprovaCred :="ND"
Local oComboBo6
Local nAtendSac :="ND"
Local oComboBo7
Local nAgendEntre :="ND"
Local oComboBo8
Local nPrazoEntre :="ND"
Local oComboBo9
Local nAtendMotoris :="ND"
Local oComboBo15
Local nGeral :="ND"
Local cObserv := ""
Local oGet1
Local oSay1
Local oSay10
Local oSay11
Local oSay12
Local oSay13
Local oSay14
Local oSay15
Local oSay16
Local oSay17
Local oSay18
Local oSay19
Local oSay2
Local oSay20
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Local oSay21
Local oSay22
Local cChamado := M->UC_CODIGO
Static oDlg

		DbSelectArea("ZKA")
		ZKA->(dbSetOrder(1)) //ZKA_FILIAL, ZKA_CHAMAD
		ZKA->(DbSeek(xFilial()+cChamado))
		nAtenLoja 	:= Iif(ZKA->ZKA_ATELOJ == "1","Satisfeito",Iif (ZKA->ZKA_ATELOJ == "2","Regular", Iif (ZKA->ZKA_ATELOJ == "3", "Insatisfeito", "ND")))
		nAtendVend  := Iif(ZKA->ZKA_ATENVE == "1","Satisfeito",Iif (ZKA->ZKA_ATENVE == "2","Regular", Iif (ZKA->ZKA_ATENVE == "3", "Insatisfeito", "ND"))) 
		nAtendGer := Iif(ZKA->ZKA_ATENGE  == "1","Satisfeito",Iif (ZKA->ZKA_ATENGE  == "2","Regular", Iif (ZKA->ZKA_ATENGE  == "3", "Insatisfeito", "ND"))) 
	    nOportComp :=  Iif(ZKA->ZKA_OPOCOM == "1","Satisfeito",Iif (ZKA->ZKA_OPOCOM == "2","Regular", Iif (ZKA->ZKA_OPOCOM == "3", "Insatisfeito", "ND"))) 
		nAprovaCred := Iif(ZKA->ZKA_APROCR == "1","Satisfeito",Iif (ZKA->ZKA_APROCR == "2","Regular", Iif (ZKA->ZKA_APROCR  == "3", "Insatisfeito", "ND"))) 
	    nAtendSac :=  Iif(ZKA->ZKA_ATESAC == "1","Satisfeito",Iif (ZKA->ZKA_ATESAC == "2","Regular", Iif (ZKA->ZKA_ATESAC == "3", "Insatisfeito", "ND"))) 
		nAgendEntre :=  Iif(ZKA->ZKA_AGEENT == "1","Satisfeito",Iif (ZKA->ZKA_AGEENT == "2","Regular", Iif (ZKA->ZKA_AGEENT == "3", "Insatisfeito", "ND"))) 
		nAtendMotoris :=  Iif(ZKA->ZKA_ATEMOT == "1","Satisfeito",Iif (ZKA->ZKA_ATEMOT == "2","Regular", Iif (ZKA->ZKA_ATEMOT == "3", "Insatisfeito", "ND"))) 
		nAvariaEntre :=  Iif(ZKA->ZKA_AVAENT == "1","Satisfeito",Iif (ZKA->ZKA_AVAENT == "2","Regular", Iif (ZKA->ZKA_AVAENT == "3", "Insatisfeito", "ND"))) 
		nPrazoEntre := Iif(ZKA->ZKA_PRZENT == "1","Satisfeito",Iif (ZKA->ZKA_PRZENT  == "2","Regular", Iif (ZKA->ZKA_PRZENT  == "3", "Insatisfeito", "ND"))) 
		nAcompClie :=  Iif(ZKA->ZKA_ACOCLI == "1","Satisfeito",Iif (ZKA->ZKA_ACOCLI == "2","Regular", Iif (ZKA->ZKA_ACOCLI == "3", "Insatisfeito", "ND"))) 
		nQualProd := Iif( ZKA->ZKA_QUAPRO== "1","Satisfeito",Iif ( ZKA->ZKA_QUAPRO== "2","Regular", Iif ( ZKA->ZKA_QUAPRO == "3", "Insatisfeito", "ND"))) 
	    nTroca:=   Iif(ZKA->ZKA_TROCA == "1","Satisfeito",Iif (ZKA->ZKA_TROCA == "2","Regular", Iif (ZKA->ZKA_TROCA== "3", "Insatisfeito", "ND"))) 
		nCustoBene := Iif(ZKA->ZKA_CUSBEN  == "1","Satisfeito",Iif (ZKA->ZKA_CUSBEN  == "2","Regular", Iif (ZKA->ZKA_CUSBEN  == "3", "Insatisfeito", "ND"))) 
		nGeral:=   Iif(ZKA->ZKA_GERAL == "1","Satisfeito",Iif (ZKA->ZKA_GERAL == "2","Regular", Iif (ZKA->ZKA_GERAL == "3", "Insatisfeito", "ND"))) 
		cObserv:=  ZKA->ZKA_OBSERV

  DEFINE MSDIALOG oDlg TITLE "Pesquisa de Satisfação do Cliente" FROM 000, 000  TO 550, 700 COLORS 0, 16777215 PIXEL

    @ 022, 044 SAY oSay1 PROMPT "Loja" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 041, 016 SAY oSay2 PROMPT "Ambiente de Loja" SIZE 058, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 053, 016 SAY oSay3 PROMPT "Atendimento do Vendedor" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 067, 016 SAY oSay4 PROMPT "Atendimento do Gerente" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 080, 015 SAY oSay5 PROMPT "Oportunidade de Compra" SIZE 063, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 092, 016 SAY oSay6 PROMPT "Aprovação do Crédito" SIZE 058, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 229 SAY oSay7 PROMPT "Servir ao Cliente" SIZE 068, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 116, 044 SAY oSay8 PROMPT "Logística" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 076, 229 SAY oSay9 PROMPT "Compras" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 119, 229 SAY oSay10 PROMPT "Acompanhamento" SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 041, 175 SAY oSay11 PROMPT "Atendimento do SAC" SIZE 058, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 054, 175 SAY oSay12 PROMPT "Agendamento de Entrega" SIZE 061, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 090, 175 SAY oSay13 PROMPT "Prazo de Entrega" SIZE 042, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 133, 016 SAY oSay14 PROMPT "Atendimento do Motorista" SIZE 062, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 145, 016 SAY oSay15 PROMPT "Avaria na Entrega" SIZE 044, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 134, 170 SAY oSay16 PROMPT "Acompanhamento ao Cliente" SIZE 071, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 145, 170 SAY oSay17 PROMPT "Qualidade do Produto" SIZE 063, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 158, 170 SAY oSay18 PROMPT "Troca" SIZE 047, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 171, 170 SAY oSay19 PROMPT "Custo/Benefício" SIZE 048, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 039, 088 MSCOMBOBOX oComboBo1 VAR nAtenLoja ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 052, 088 MSCOMBOBOX oComboBo2 VAR nAtendVend ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 064, 088 MSCOMBOBOX oComboBo3 VAR nAtendGer ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 077, 088 MSCOMBOBOX oComboBo4 VAR nOportComp ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 091, 088 MSCOMBOBOX oComboBo5 VAR nAprovaCred ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 038, 244 MSCOMBOBOX oComboBo6 VAR nAtendSac ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 052, 244 MSCOMBOBOX oComboBo7 VAR nAgendEntre ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 090, 244 MSCOMBOBOX oComboBo8 VAR nPrazoEntre ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 131, 088 MSCOMBOBOX oComboBo9 VAR nAtendMotoris ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 143, 088 MSCOMBOBOX oComboBo10 VAR nAvariaEntre ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 132, 247 MSCOMBOBOX oComboBo11 VAR nAcompClie ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 145, 247 MSCOMBOBOX oComboBo12 VAR nQualProd ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 157, 247 MSCOMBOBOX oComboBo13 VAR nTroca ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 170, 247 MSCOMBOBOX oComboBo14 VAR nCustoBene ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 168, 088 MSCOMBOBOX oComboBo15 VAR nGeral ITEMS {"Satisfeito","Regular","Insatisfeito","ND"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 198, 019 GET oGet1 VAR cObserv MEMO SIZE 313, 038 OF oDlg COLORS 0, 16777215 PIXEL VALID !Vazio()
    @ 250, 169 BUTTON oButton1 PROMPT "Cancelar" SIZE 076, 013 OF oDlg ACTION(oDlg:End())  PIXEL
    @ 250, 253 BUTTON oButton2 PROMPT "Salvar" SIZE 076, 013 OF oDlg ACTION (GravSat(nAtenLoja,nAtendVend,nAtendGer,nOportComp,nAprovaCred,nAtendSac,nAgendEntre,nAtendMotoris,nAvariaEntre,nPrazoEntre,nAcompClie,nQualProd,nTroca,nCustoBene,nGeral,cObserv),oDlg:End()) PIXEL
    @ 185, 154 SAY oSay20 PROMPT "Observações" SIZE 034, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 169, 016 SAY oSay21 PROMPT "Geral" SIZE 025, 006 OF oDlg COLORS 0, 16777215 PIXEL
    @ 158, 044 SAY oSay22 PROMPT "Media Geral" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED


Static function GravSat(nAtenLoja,nAtendVend,nAtendGer,nOportComp,nAprovaCred,nAtendSac,;
						nAgendEntre,nAtendMotoris,nAvariaEntre,nPrazoEntre,nAcompClie,nQualProd,;
						nTroca,nCustoBene,nGeral,cObserv)


Local dData := Date()
Local cUser := LogUserName()
Local cChamado := M->UC_CODIGO
Local cCodCli := M->UC_CODCONT
Local cxFilial := M->UC_MSFIL
Private cUserEst := SUPERGETMV("KH_OBRIPOS", .T., "001037|001035|001036|001033|000567|000455")


	If __cUserid $ cUserEst
		DbSelectArea("ZKA")
		ZKA->(dbSetOrder(1)) //ZKA_FILIAL, ZKA_CHAMAD
		If ZKA->(DbSeek(xFilial()+cChamado))
							RecLock("ZKA",.F.)
						Else
							RecLock("ZKA",.T.)
						EndIf
							ZKA->ZKA_FILIAL := xFilial()
							ZKA->ZKA_CHAMAD := cChamado
							ZKA->ZKA_CODCLI := cCodCli
							ZKA->ZKA_XMSFIL := cxFilial
							ZKA->ZKA_ATELOJ := Iif(nAtenLoja == "Satisfeito","1",Iif (nAtenLoja == "Regular","2", Iif (nAtenLoja == "Insatisfeito", "3", "4")))
							ZKA->ZKA_ATENVE := Iif(nAtendVend == "Satisfeito","1",Iif (nAtendVend == "Regular","2", Iif (nAtendVend == "Insatisfeito", "3", "4")))
							ZKA->ZKA_ATENGE := Iif(nAtendGer == "Satisfeito","1",Iif (nAtendGer == "Regular","2", Iif (nAtendGer == "Insatisfeito", "3", "4")))
							ZKA->ZKA_OPOCOM := Iif(nOportComp == "Satisfeito","1",Iif (nOportComp == "Regular","2", Iif (nOportComp == "Insatisfeito", "3", "4")))
							ZKA->ZKA_APROCR := Iif(nAprovaCred == "Satisfeito","1",Iif (nAprovaCred == "Regular","2", Iif (nAprovaCred == "Insatisfeito", "3", "4")))
							ZKA->ZKA_ATESAC := Iif(nAtendSac == "Satisfeito","1",Iif (nAtendSac == "Regular","2", Iif (nAtendSac == "Insatisfeito", "3", "4")))
							ZKA->ZKA_AGEENT := Iif(nAgendEntre == "Satisfeito","1",Iif (nAgendEntre == "Regular","2", Iif (nAgendEntre == "Insatisfeito", "3", "4")))
							ZKA->ZKA_ATEMOT := Iif(nAtendMotoris == "Satisfeito","1",Iif (nAtendMotoris == "Regular","2", Iif (nAtendMotoris == "Insatisfeito", "3", "4")))
							ZKA->ZKA_AVAENT := Iif(nAvariaEntre == "Satisfeito","1",Iif (nAvariaEntre == "Regular","2", Iif (nAvariaEntre == "Insatisfeito", "3", "4")))
							ZKA->ZKA_PRZENT := Iif(nPrazoEntre == "Satisfeito","1",Iif (nPrazoEntre == "Regular","2", Iif (nPrazoEntre == "Insatisfeito", "3", "4")))
							ZKA->ZKA_ACOCLI := Iif(nAcompClie == "Satisfeito","1",Iif (nAcompClie == "Regular","2", Iif (nAcompClie == "Insatisfeito", "3", "4")))
							ZKA->ZKA_QUAPRO := Iif(nQualProd == "Satisfeito","1",Iif (nQualProd == "Regular","2", Iif (nQualProd == "Insatisfeito", "3", "4")))
							ZKA->ZKA_TROCA  := Iif(nTroca == "Satisfeito","1",Iif (nTroca == "Regular","2", Iif (nTroca == "Insatisfeito", "3", "4")))
							ZKA->ZKA_CUSBEN := Iif(nCustoBene == "Satisfeito","1",Iif (nCustoBene == "Regular","2", Iif (nCustoBene == "Insatisfeito", "3", "4")))
							ZKA->ZKA_GERAL  := Iif(nGeral == "Satisfeito","1",Iif (nGeral == "Regular","2", Iif (nGeral == "Insatisfeito", "3", "4")))
							ZKA->ZKA_OBSERV := cObserv
							Alert("Prezado Sr.(a) "+ cUser + " Dados das Pesquisa salvos com sucesso!")
							
	Else
	Alert("Prezado Sr.(a) "+ cUser +" Gravação da pesquisa permitida apenas para funcionários do setor Pós Venda")
	Return(.F.)
	EndIf




Return