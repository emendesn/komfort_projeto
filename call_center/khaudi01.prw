#include 'protheus.ch'
#include 'parmtype.ch'


//--------------------------------------------------------------
/*/{Protheus.doc} KHAUDI01
Description //Controle de avaliação de lojas
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 11/03/2019 /*/
//--------------------------------------------------------------

user function KHAUDI01(lRet,cLojaA,dDataSis,cLibera,lRetLi,nRecno)                                
Local oGet1
Local cLoja := SPACE(4)
Local oGet10
Local cSub2Qu1 
Local oGet11
Local cSub2Qu2 
Local oGet12
Local cSub2Qu3 
Local oGet13
Local cSub2Qu4 
Local oGet14
Local cSub2Qu5 
Local oGet15
Local nSubTo2 := 0
Local oGet16
Local cSub3Qu1 
Local oGet17
Local cSub3Qu2 
Local oGet18
Local cSub3Qu3 
Local oGet19
Local nSubTo3 := 0
Local oGet2
Local cGestor := SPACE(30)
Local oGet20
Local nTotal 
Local oGet21
Local cObserv 
Local oGet3
//Local cAuditor := LogUserName()
Local oGet4
Local dData := DATE()
Local dLibera := CTOD("//")
Local oGet5
Local cSub1Qu1 
Local oGet6
Local cSub1Qu2 
Local oGet7
Local cSub1Qu3 
Local oGet8
Local cSub1Qu4 
Local oGet9
Local nSubTo1 := 0
Local oGroup1
Local oGroup2
Local oGroup3
Local oGroup4
Local oGroup5
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
Local oSay21
Local oSay22
Local oSay23
Local oSay24
Local oSay25                                                                                         
Local oSay26
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Default lRetLi := .F.
Default cLibera := 'N'
Default lRet := .F.
Private cUser := RetCodUsr() //Retorna o Codigo do Usuario
Private cAuditor := UsrRetName( cUser )//Retorna o nome do usuario 
Static oDlg


/*--------------------------------------------------------------
Validação de chamadas apartir da Static fAlterAva
No fonte U_KHCON002 Onde é feita a alteração dos dados                                                              
--------------------------------------------------------------*/

If lRet
						
						DbSelectArea("ZKE")
						ZKE->(dbgoto(nRecno)) // Posiciona no Registo da Z18
						if ! EOF()
							cLoja    :=	ZKE->ZKE_LOJA   
							cGestor  :=	ZKE->ZKE_GESTOR 
							cAuditor := ZKE->ZKE_AUDITO 
						    dData    := ZKE->ZKE_DTINCL 
						    cSub1Qu1 := ZKE->ZKE_B1QUE1
						 	cSub1Qu2 := ZKE->ZKE_B1QUE2
							cSub1Qu3 := ZKE->ZKE_B1QUE3
							cSub1Qu4 := ZKE->ZKE_B1QUE4
						    nSubTo1  := ZKE->ZKE_SUBTO1 
							cSub2Qu1 := ZKE->ZKE_B2QUE1
							cSub2Qu2 := ZKE->ZKE_B2QUE2
							cSub2Qu3 := ZKE->ZKE_B2QUE3
							cSub2Qu4 := ZKE->ZKE_B2QUE4 
						    cSub2Qu5 := ZKE->ZKE_B2QUE5
							nSubTo2  := ZKE->ZKE_SUBTO2
							cSub3Qu1 := ZKE->ZKE_B3QUE1
						    cSub3Qu2 := ZKE->ZKE_B3QUE2
							cSub3Qu3 := ZKE->ZKE_B3QUE3
							nSubTo3  := ZKE->ZKE_SUBTO3 
							nTotal   := ZKE->ZKE_TOTAL  
							cObserv  := ZKE->ZKE_OBSERV 
							If lRetLi
							dLibera  := ZKE->ZKE_DTLIBE  
							EndIf
							MsUnLock()
						EndIf

EndIf




  DEFINE MSDIALOG oDlg TITLE "Auditoria Lojas" FROM -354, 000  TO 470, 800 COLORS 0, 16777215 PIXEL

    @ 002, 009 GROUP oGroup1 TO 045, 389 PROMPT "Informações" OF oDlg COLOR 0, 16777215 PIXEL
    @ 011, 014 SAY oSay1 PROMPT "Loja" SIZE 014, 007  OF oDlg COLORS 0, 16777215 PIXEL
    @ 022, 013 SAY oSay2 PROMPT "Gestor" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 032, 013 SAY oSay3 PROMPT "Auditor" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 011, 037 MSGET oGet1 VAR cLoja SIZE 060, 007 F3 "SM0"  OF oDlg COLORS 0, 16777215 PIXEL
    @ 022, 037 MSGET oGet2 VAR cGestor SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 033, 037 MSGET oGet3 VAR cAuditor SIZE 060, 007 When .F. OF oDlg COLORS 0, 16777215 PIXEL
    @ 011, 293 SAY oSay4 PROMPT "Data" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 011, 325 MSGET oGet4 VAR dData SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 022, 293 SAY oSay4 PROMPT "Fechamento" SIZE 033, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 022, 325 MSGET oGet4 VAR dLibera SIZE 060, 007 When lRetLi  OF oDlg COLORS 0, 16777215 PIXEL
    //Grupo 1
    @ 060, 008 GROUP oGroup2 TO 148, 386 PROMPT "Grupo 1" OF oDlg COLOR 0, 16777215 PIXEL
    @ 070, 015 SAY oSay5 PROMPT "1 - EQUIPE  (Sinergia Equipe/ Apresentação Pessoal/ Horário Abertura Loja)" SIZE 227, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 046, 355 SAY oSay6 PROMPT "PONTUAÇÃO" SIZE 034, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 054, 360 SAY oSay7 PROMPT "0 - 0,50" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 084, 016 SAY oSay8 PROMPT "2 - ATENDIMENTO  (Cordial/ Qualificação Produtos)" SIZE 182, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 099, 016 SAY oSay9 PROMPT "3 - SINALIZAÇÃO VISUAL LOJA  (Display A4 / Discos - Tags / Vitrine)" SIZE 180, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 113, 017 SAY oSay10 PROMPT "4 - DECORAÇÃO LOJA - PADRÃO MANUAL V.M." SIZE 169, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 133, 017 SAY oSay11 PROMPT "SUB TOTAL" SIZE 031, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 068, 325 MSCOMBOBOX oGet5 VAR cSub1Qu1 ITEMS {"0.0","0.25","0.50"} SIZE 060, 007 VALID {|| processa( {|| nSubTo1:= fSub1 (cSub1Qu1,cSub1Qu2,cSub1Qu3,cSub1Qu4), nTotal := fTotal (nSubTo1,nSubTo2,nSubTo3) }, "Aguarde...", "Atualizando Dados...", .F.)}  OF oDlg COLORS 0, 16777215 PIXEL
    @ 083, 325 MSCOMBOBOX oGet6 VAR cSub1Qu2 ITEMS {"0.0","0.25","0.50"} SIZE 060, 007 VALID {|| processa( {|| nSubTo1:= fSub1 (cSub1Qu1,cSub1Qu2,cSub1Qu3,cSub1Qu4), nTotal := fTotal (nSubTo1,nSubTo2,nSubTo3)}, "Aguarde...", "Atualizando Dados...", .F.)}  OF oDlg COLORS 0, 16777215 PIXEL
    @ 097, 325 MSCOMBOBOX oGet7 VAR cSub1Qu3 ITEMS {"0.0","0.25","0.50"} SIZE 060, 007 VALID {|| processa( {|| nSubTo1:= fSub1 (cSub1Qu1,cSub1Qu2,cSub1Qu3,cSub1Qu4), nTotal := fTotal (nSubTo1,nSubTo2,nSubTo3)}, "Aguarde...", "Atualizando Dados...", .F.)}  OF oDlg COLORS 0, 16777215 PIXEL
    @ 112, 325 MSCOMBOBOX oGet8 VAR cSub1Qu4 ITEMS {"0.0","0.25","0.50"} SIZE 060, 007 VALID {|| processa( {|| nSubTo1:= fSub1 (cSub1Qu1,cSub1Qu2,cSub1Qu3,cSub1Qu4), nTotal := fTotal (nSubTo1,nSubTo2,nSubTo3)}, "Aguarde...", "Atualizando Dados...", .F.)}  OF oDlg COLORS 0, 16777215 PIXEL
    @ 131, 325 MSGET oGet9 VAR nSubTo1 SIZE 060, 007 When .F. OF oDlg COLORS 0, 16777215 PIXEL
    //Grupo 2
    @ 162, 005 GROUP oGroup3 TO 256, 386 PROMPT "Grupo 2" OF oDlg COLOR 0, 16777215 PIXEL
    @ 171, 018 SAY oSay12 PROMPT "5 - PLANILHA CONTROLE/ MOVIMENTAÇÃO PRODUTOS  (Preenchimento Diário e Correto)" SIZE 240, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 185, 018 SAY oSay13 PROMPT "6 - ORGANIZAÇÃO  (Áreas Internas/ Estoque/ Área de Vendas)" SIZE 229, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 198, 018 SAY oSay14 PROMPT "7 - LIMPEZA GERAL  (Área de Vendas/Área Interna/ Sanitários)" SIZE 222, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 211, 018 SAY oSay15 PROMPT "8 - PROTOCOLO DE CONFERÊNCIA - DOCUMENTOS: ENTRADA/ SAÍDA - TERMOS ANEXADOS AO PROTHEUS. " SIZE 290, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 225, 018 SAY oSay16 PROMPT "9 - CUIDADOS COM OS AGREGADOS/ MOSTRUÁRIOS (Inclusive no Preenchimento de Pedidos)" SIZE 250, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 240, 019 SAY oSay17 PROMPT "SUB TOTAL" SIZE 038, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 171, 325 MSCOMBOBOX oGet10 VAR cSub2Qu1 ITEMS {"0.0","0.35","0.70"} SIZE 060, 007 VALID {|| processa( {|| nSubTo2:= fSub2 (cSub2Qu1,cSub2Qu2,cSub2Qu3,cSub2Qu4,cSub2Qu5), nTotal := fTotal (nSubTo1,nSubTo2,nSubTo3)}, "Aguarde...", "Atualizando Dados...", .F.)}  OF oDlg COLORS 0, 16777215 PIXEL
    @ 185, 325 MSCOMBOBOX oGet11 VAR cSub2Qu2 ITEMS {"0.0","0.35","0.70"} SIZE 060, 007 VALID {|| processa( {|| nSubTo2:= fSub2 (cSub2Qu1,cSub2Qu2,cSub2Qu3,cSub2Qu4,cSub2Qu5), nTotal := fTotal (nSubTo1,nSubTo2,nSubTo3)}, "Aguarde...", "Atualizando Dados...", .F.)}  OF oDlg COLORS 0, 16777215 PIXEL
    @ 198, 325 MSCOMBOBOX oGet12 VAR cSub2Qu3 ITEMS {"0.0","0.35","0.70"} SIZE 060, 007 VALID {|| processa( {|| nSubTo2:= fSub2 (cSub2Qu1,cSub2Qu2,cSub2Qu3,cSub2Qu4,cSub2Qu5), nTotal := fTotal (nSubTo1,nSubTo2,nSubTo3)}, "Aguarde...", "Atualizando Dados...", .F.)}  OF oDlg COLORS 0, 16777215 PIXEL
    @ 211, 325 MSCOMBOBOX oGet13 VAR cSub2Qu4 ITEMS {"0.0","0.35","0.70"} SIZE 060, 007 VALID {|| processa( {|| nSubTo2:= fSub2 (cSub2Qu1,cSub2Qu2,cSub2Qu3,cSub2Qu4,cSub2Qu5), nTotal := fTotal (nSubTo1,nSubTo2,nSubTo3)}, "Aguarde...", "Atualizando Dados...", .F.)}  OF oDlg COLORS 0, 16777215 PIXEL
    @ 225, 325 MSCOMBOBOX oGet14 VAR cSub2Qu5 ITEMS {"0.0","0.35","0.70"} SIZE 060, 007 VALID {|| processa( {|| nSubTo2:= fSub2 (cSub2Qu1,cSub2Qu2,cSub2Qu3,cSub2Qu4,cSub2Qu5), nTotal := fTotal (nSubTo1,nSubTo2,nSubTo3)}, "Aguarde...", "Atualizando Dados...", .F.)}  OF oDlg COLORS 0, 16777215 PIXEL 
    @ 240, 325 MSGET oGet15 VAR nSubTo2 SIZE 060, 007 When .F. OF oDlg COLORS 0, 16777215 PIXEL
    @ 150, 355 SAY oSay18 PROMPT "PONTUAÇÃO" SIZE 034, 006 OF oDlg COLORS 0, 16777215 PIXEL
    @ 157, 360 SAY oSay19 PROMPT "0 - 0,70" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    //Grupo 3
    @ 272, 005 GROUP oGroup4 TO 330, 386 PROMPT "Grupo 3" OF oDlg COLOR 0, 16777215 PIXEL
    @ 279, 015 SAY oSay20 PROMPT "10 - CUIDADOS COM PATRIMÔNIO (Estrutura e Ativos da Empresa em Geral, com Sinalização na transferência)." SIZE 243, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 291, 015 SAY oSay21 PROMPT "11 - INVERSÕES DE MODELOS  (Inclusive com Perdas/ Ganhos Financeiro)" SIZE 195, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 303, 015 SAY oSay22 PROMPT "12 - DIVERGÊNCIAS QUANTIDADES INVENTÁRIO   (Quebras/ Sobras)" SIZE 190, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 317, 014 SAY oSay23 PROMPT "SUB TOTAL" SIZE 038, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 279, 325 MSCOMBOBOX oGet16 VAR cSub3Qu1 ITEMS {"0.0","0.75","1.50"} SIZE 060, 007 VALID {|| processa( {|| nSubTo3:= fSub3 (cSub3Qu1,cSub3Qu2,cSub3Qu3), nTotal := fTotal (nSubTo1,nSubTo2,nSubTo3)}, "Aguarde...", "Atualizando Dados...", .F.)}  OF oDlg COLORS 0, 16777215 PIXEL
    @ 291, 325 MSCOMBOBOX oGet17 VAR cSub3Qu2 ITEMS {"0.0","0.75","1.50"} SIZE 060, 007 VALID {|| processa( {|| nSubTo3:= fSub3 (cSub3Qu1,cSub3Qu2,cSub3Qu3), nTotal := fTotal (nSubTo1,nSubTo2,nSubTo3)}, "Aguarde...", "Atualizando Dados...", .F.)}  OF oDlg COLORS 0, 16777215 PIXEL
    @ 303, 325 MSCOMBOBOX oGet18 VAR cSub3Qu3 ITEMS {"0.0","0.75","1.50"} SIZE 060, 007 VALID {|| processa( {|| nSubTo3:= fSub3 (cSub3Qu1,cSub3Qu2,cSub3Qu3), nTotal := fTotal (nSubTo1,nSubTo2,nSubTo3)}, "Aguarde...", "Atualizando Dados...", .F.)}  OF oDlg COLORS 0, 16777215 PIXEL
    @ 317, 325 MSGET oGet19 VAR nSubTo3 SIZE 060, 007 When .F. OF oDlg COLORS 0, 16777215 PIXEL
    @ 257, 355 SAY oSay24 PROMPT "PONTUAÇÃO" SIZE 033, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 265, 360 SAY oSay25 PROMPT "0 - 1,50" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 335, 286 SAY oSay26 PROMPT "TOTAL" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 334, 325 MSGET oGet20 VAR nTotal  SIZE 060, 007 When .F. OF oDlg COLORS 0, 16777215 PIXEL
    @ 350, 007 GET oGet21 VAR cObserv MEMO SIZE 382, 039 OF oDlg COLORS 0, 16777215 PIXEL
    @ 342, 008 SAY oSay27 PROMPT "Observações" SIZE 037, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 393, 300 BUTTON oButton1 PROMPT "Cancelar" SIZE 037, 012 ACTION(oDlg:End()) OF oDlg PIXEL
    @ 393, 346 BUTTON oButton2 PROMPT "Salvar" SIZE 037, 012 ACTION (fGrava(lRet,cLoja,cGestor,cAuditor,dData,cSub1Qu1,cSub1Qu2,;
    cSub1Qu3,cSub1Qu4,nSubTo1,cSub2Qu1,cSub2Qu2,cSub2Qu3,cSub2Qu4,cSub2Qu5,nSubTo2,cSub3Qu1,cSub3Qu2,cSub3Qu3,nSubTo3,nTotal,cObserv,cLibera,dLibera,lRetLi),oDlg:End()) PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED
  
 
Return
  
 //--------------------------------------------------------------
/*/{Protheus.doc} fSub1
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 05/04/2019 /*/
//--------------------------------------------------------------

Static Function fSub1 (cSub1Qu1,cSub1Qu2,cSub1Qu3,cSub1Qu4)

Local nTotal := (val(cSub1Qu1)+val(cSub1Qu2)+val(cSub1Qu3)+val(cSub1Qu4)) 

Return nTotal

 //--------------------------------------------------------------
/*/{Protheus.doc} fSub2
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 05/04/2019 /*/
//--------------------------------------------------------------

Static Function fSub2 (cSub2Qu1,cSub2Qu2,cSub2Qu3,cSub2Qu4,cSub2Qu5)

Local nTotal := (val(cSub2Qu1)+val(cSub2Qu2)+val(cSub2Qu3)+val(cSub2Qu4)+val(cSub2Qu5)) 

Return nTotal



 //--------------------------------------------------------------
/*/{Protheus.doc} fSub3
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 05/04/2019 /*/
//--------------------------------------------------------------

Static Function fSub3 (cSub3Qu1,cSub3Qu2,cSub3Qu3)

Local nTotal := (val(cSub3Qu1)+val(cSub3Qu2)+val(cSub3Qu3)) 

Return nTotal


 //--------------------------------------------------------------
/*/{Protheus.doc} fSub3
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 05/04/2019 /*/
//--------------------------------------------------------------

Static Function fTotal (nSubTo1,nSubTo2,nSubTo3)

Local nTotal := (nSubTo1+nSubTo2+nSubTo3) 

Return nTotal


//--------------------------------------------------------------
/*/{Protheus.doc} fGrava
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 11/02/2019 /*/
//--------------------------------------------------------------

Static function fGrava(lRet,cLoja,cGestor,cAuditor,dData,cSub1Qu1,cSub1Qu2,cSub1Qu3,cSub1Qu4,nSubTo1,cSub2Qu1,cSub2Qu2,;
						cSub2Qu3,cSub2Qu4,cSub2Qu5,nSubTo2,cSub3Qu1,cSub3Qu2,cSub3Qu3,nSubTo3,nTotal,cObserv,cLibera,dLibera,lRetLi)

Local cUser     := LogUserName()
Local lGrava 	:= .T.
			     		DbSelectArea("ZKE")
						ZKE->(DbSetOrder(1))//ZKE_FILIAL+ZKE_LOJA+ZKE_DTINCL
						If ZKE->(DbSeek(xFilial()+cLoja+dtos(dData)))
							If  lRet
								RecLock("ZKE",.F.)						
								msgAlert("Prezado Sr.(a) "+ cUser + " Dados da Avaliação Alterados com sucesso!")
							Else
								lGrava := .F.
								msgAlert("Prezado Sr.(a) "+ cUser + " A Loja Já possuí avaliação para a data: "+ dtoc(dData)+" Obrigado")
							EndIf
						Else
							RecLock("ZKE",.T.)							
							msgAlert("Prezado Sr.(a) "+ cUser + " Dados da Avaliação salvos com sucesso!")
						EndIf
				
						If lGrava
							ZKE->ZKE_FILIAL := xFilial()
							ZKE->ZKE_LOJA   := cLoja
							ZKE->ZKE_GESTOR := cGestor
							ZKE->ZKE_AUDITO := cAuditor
							ZKE->ZKE_DTINCL := dData
							ZKE->ZKE_B1QUE1 := cSub1Qu1
							ZKE->ZKE_B1QUE2 := cSub1Qu2
							ZKE->ZKE_B1QUE3 := cSub1Qu3
							ZKE->ZKE_B1QUE4 := cSub1Qu4
							ZKE->ZKE_SUBTO1 := nSubTo1
							ZKE->ZKE_B2QUE1 := cSub2Qu1
							ZKE->ZKE_B2QUE2 := cSub2Qu2
							ZKE->ZKE_B2QUE3 := cSub2Qu3
							ZKE->ZKE_B2QUE4 := cSub2Qu4
							ZKE->ZKE_B2QUE5 := cSub2Qu5
							ZKE->ZKE_SUBTO2 := nSubTo2
							ZKE->ZKE_B3QUE1 := cSub3Qu1
							ZKE->ZKE_B3QUE2 := cSub3Qu2
							ZKE->ZKE_B3QUE3 := cSub3Qu3
							ZKE->ZKE_SUBTO3 := nSubTo3
							ZKE->ZKE_TOTAL  := nTotal
							ZKE->ZKE_OBSERV := cObserv
							ZKE->ZKE_LIBERA  := cLibera
							If lRetLi
							ZKE->ZKE_DTLIBE := dLibera
							EndIf
							MsUnLock()
							EndIf
								
									    	
Return


