#include "protheus.ch"

// #########################################################################################
// Projeto: IMPLANTACAO V12
// Modulo : CALL CENTER
// Fonte  : SYVM108
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 06/06/17 | Eduardo Patriani  | Aprovacao de chamados manual enviados pelo Workflow
// ---------+-------------------+-----------------------------------------------------------
User Function SYTMOV16()

Local aArea 		:= GetArea()
Local cCadastro		:= "Workflow de ocorrencias de chamados"
Local aPosObj  		:= {}
Local aObjects  	:= {}
Local aSize     	:= {}
Local aInfo     	:= {}
Local aButtons 		:= {}
Local oDlg
Local oMainWnd

Private cAlias   := GetNextAlias()
Private aItens	 := {}
Private oSt1     := LoadBitmap(GetResources(),'BR_VERDE')
Private oSt2     := LoadBitmap(GetResources(),'BR_PRETO')
Private oSt3     := LoadBitmap(GetResources(),'BR_VERMELHO')


MsgRun("Aguarde... Carregando chamados..",,{ || KHFILDADOS()})
                      
(cAlias)->(DbGotop())
While (cAlias)->(!Eof())

	AAdd(aItens,{	"",;
					(cAlias)->UC_01FIL,;
					(cAlias)->UD_CODIGO,;
					(cAlias)->UD_ITEM,;
					ALLTRIM((cAlias)->X5_DESCRI),;
					ALLTRIM((cAlias)->B1_DESC),;
					ALLTRIM((cAlias)->U9_DESC),;
					STOD((cAlias)->UD_01DTENT),;
					STOD((cAlias)->UC_DATA),;
					ALLTRIM((cAlias)->A1_NOME),;
					ALLTRIM((cAlias)->U7_NOME),;
					""})

								
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

If Len(aItens)==0
	AAdd(aItens,{"","","","","","",CTOD(""),CTOD(""),"","","",""} )
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o calculo automatico de dimensoes de objetos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AAdd(aButtons,{	'',{|| VisualSUC(aItens[oBrwItens:nAt])  }, "Visualizar Chamado SAC <F7>"} )   
SetKey( VK_F7 	  ,{|| VisualSUC(aItens[oBrwItens:nAt])  })

aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .T., .F. } )
AAdd( aObjects, { 070, 100, .F., .T. } )
AAdd( aObjects, { 100, 015, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Dialogo.		                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

oFwLayerRes:= FwLayer():New()
oFwLayerRes:Init(oDlg,.T.)
oFwLayerRes:addLine("CONSULTA",095,.F.)
oFwLayerRes:addCollumn( "COL1",100,.T.,"CONSULTA")
oFWLayerRes:addWindow ( "COL1", "WIN1","Chamados SAC",095,.T.,.F.,,"CONSULTA")

oPanel2:= oFwLayerRes:GetWinPanel("COL1","WIN1","CONSULTA")

oBrwItens:= TwBrowse():New(0,0,0,0,, {'','Filial','Chamado','Item','Assunto','Produto','Ocorrencia','Dt.Entrega','Data','Cliente','Operador','Aprovado'},,oPanel2,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
oBrwItens:SetArray(aItens)
oBrwItens:bLine := {|| { 	IF( aItens[oBrwItens:nAt,01]=="1",oSt1,IF(aItens[oBrwItens:nAt,01]=="2",oSt2,oSt3)) ,;
								aItens[oBrwItens:nAt,02] ,;
								aItens[oBrwItens:nAt,03] ,;
								aItens[oBrwItens:nAt,04] ,;
								aItens[oBrwItens:nAt,05] ,;
								aItens[oBrwItens:nAt,06] ,;
								aItens[oBrwItens:nAt,07] ,;
								aItens[oBrwItens:nAt,08] ,;
								aItens[oBrwItens:nAt,09] ,;
								aItens[oBrwItens:nAt,10] ,;
								aItens[oBrwItens:nAt,11] ,;
								aItens[oBrwItens:nAt,12] }}
oBrwItens:Align:= CONTROL_ALIGN_ALLCLIENT
oBrwItens:bLDblClick := {|| APROVAITEM(aItens[oBrwItens:nAt])  }

ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( EnchoiceBar(oDlg,{|| oDlg:End() }, {||  oDlg:End() },,aButtons) )

RestArea(aArea)

Return

/*--------------------------------------------
@Autor: Eduardo Patriani
@Data: 06/06/2017
@Hora: 15:30:24
@Versão: 
@Descrição: Funcao que filra os dados do chamado
--------------------------------------------*/
Static Function KHFILDADOS()

Local cQuery := ""

cQuery += " SELECT UC_01FIL "
cQuery += " 	  ,UD_CODIGO "
cQuery += " 	  ,UD_ITEM "
cQuery += " 	  ,X5_DESCRI "
cQuery += " 	  ,ISNULL(B1_DESC,'') B1_DESC "
cQuery += " 	  ,U9_DESC "
cQuery += " 	  ,UD_01DTENT "
cQuery += " 	  ,UD_ENVWKF "
cQuery += " 	  ,UC_DATA "
cQuery += " 	  ,A1_NOME "
cQuery += " 	  ,U7_NOME "
cQuery += " FROM "+RetSqlName("SUD")+" SUD (NOLOCK) "
cQuery += " INNER JOIN "+RetSqlName("SUC")+" SUC (NOLOCK) ON UC_FILIAL=UD_FILIAL AND UC_CODIGO=UD_CODIGO AND SUC.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SX5")+" SX5 (NOLOCK) ON X5_FILIAL = '"+XFILIAL("SX5")+"' AND X5_TABELA = 'T1' AND X5_CHAVE=UD_ASSUNTO AND SX5.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SU9")+" SU9 (NOLOCK) ON U9_FILIAL = '"+XFILIAL("SU9")+"' AND U9_CODIGO=UD_OCORREN AND SU9.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) ON A1_FILIAL = '"+XFILIAL("SA1")+"' AND A1_COD+A1_LOJA=UC_CHAVE AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SU7")+" SU7 (NOLOCK) ON U7_FILIAL = '"+XFILIAL("SU7")+"' AND U7_COD=UC_OPERADO AND SU7.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN  "+RetSqlName("SB1")+" SB1 (NOLOCK) ON B1_FILIAL = '"+XFILIAL("SB1")+"' AND B1_COD=UD_PRODUTO AND SUD.D_E_L_E_T_ = ' ' "
cQuery += " WHERE "
cQuery += " 	UD_FILIAL = '"+XFILIAL("SUD")+"' "
cQuery += " AND UD_ENVWKF = 1 "
cQuery += " AND SUD.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY UC_01FIL,UD_CODIGO,UD_ITEM "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

Return

/*--------------------------------------------
@Autor: Eduardo Patriani
@Data: 06/06/2017
@Hora: 15:30:24
@Versão: 
@Uso: Asics Brasil
@Descrição: Funcao que atualiza os dados do
chamado
--------------------------------------------*/
Static Function APROVAITEM( aDados )

Local cObs   	:= ""
Local nOpcao 	:= ""
Local cUsuario 	:= ""
Local cString	:= ""
Local cBody 	:= ""
Local cTo   	:= ""
Local nAviso 	:= 0
Local lRet	 	:= .F.

IF Alltrim(aDados[12]) == "SIM"
	MsgStop("Este item do chamado já encontra-se aprovado.","Atenção")
	Return
ElseIF Alltrim(aDados[12]) == "NAO"
	MsgStop("Este item do chamado já encontra-se reprovado.","Atenção")
	Return
EndIF

nAviso := Aviso( 'SAC' , 'Deseja Aprovar / Reprovar ?' , { 'Aprovar' , 'Reprovar' , 'Sair' } )

If nAviso == 1
	nOpcao := "2"
	INFOOBS(@cObs)
	
ElseIf nAviso == 2
	nOpcao := "3"
	INFOOBS(@cObs)
	
EndIF

If nAviso == 1 .Or. nAviso == 2

	Begin Transaction 
	
	SUC->(DbSetOrder(1))
	SUC->(DbSeek(xFilial("SUC") + aDados[3] ))
	
	SU7->(dbSetOrder(1))
	SU7->(dbSeek(xFilial("SU7")+SUC->UC_OPERADO))	
	cUsuario := SU7->U7_CODUSU
	
	SUD->(DbSetOrder(1))
	IF SUD->(DbSeek(xFilial("SUD") + aDados[3] + aDados[4] ))
			
		Reclock("SUD",.F.)
		Replace SUD->UD_ENVWKF  With nOpcao
		Replace SUD->UD_WFIDRET With dDatabase
		Replace SUD->UD_OBSWKF  With cObs
		MSUnlock()
		
		IF nOpcao == "2"
			aItens[oBrwItens:nAt,01] := "1"
			aItens[oBrwItens:nAt,12] := "SIM"
			cString 				 := " APROVADO "
			oBrwItens:REFRESH()			
			lRet := .T.
		ElseIF nOpcao == "3"
			aItens[oBrwItens:nAt,01] := "2"
			aItens[oBrwItens:nAt,12] := "NAO"
			cString 				 := " REPROVADO "
			oBrwItens:REFRESH()			
			lRet := .T.
		EndIF
		     		
		IF lRet
					
			//Procura dados do operador que originou o chamado.
			PswOrder(1)
			IF PswSeek(cUsuario,.T.)
				aInfo := PswRet(1)
				cTo   := Alltrim(aInfo[1,14])
			EndIF

			//Envia E-mail
			oProcess:=TWFProcess():New("000001","SAC - APROVACAO DE CHAMADO MANUAL")
			oProcess:cSubject := "SAC - APROVACAO DE CHAMADO MANUAL: "+aDados[3]
			oProcess:NewTask("SAC - APROVACAO DE CHAMADO MANUAL","\workflow\reprovacao.htm")
			oProcess:cTo:=cTo
			oProcess:cBody:=cBody
			oHTML:=oProcess:oHTML
			ohtml:ValByName("STATUS"	,cString)
			oHtml:ValByName("CCHAMADO"	,aDados[3] )
			oHtml:ValByName("CMOTIVO"	,cObs )
			oProcess:Start()
				
		EndIF
		
		MsgInfo("Item do chamado atualizado com sucesso.","Atenção")
		
	EndIF
	
	End Transaction 
	
EndIF

Return

/*--------------------------------------------
@Autor: Eduardo Patriani
@Data: 06/06/2017
@Hora: 15:30:24
@Versão: 
@Descrição: Tela para digitação da observacao;
--------------------------------------------*/
Static Function INFOOBS(cObs)

Local oMonoAs := TFont():New( "Courier New", 6, 0 )		//Fonte do MEMO
Local oDlg
Local oObs

DEFINE MSDIALOG oDlg FROM 05,10 TO 270,470 TITLE "Observação" PIXEL

@ 03,04 To 129,228 LABEL "Digite a Informação" OF oDlg PIXEL
@ 12,08 GET oObs VAR cObs OF oDlg MEMO SIZE 215,95 PIXEL Valid !Empty(cObs)

oObs:oFont := oMonoAs

DEFINE SBUTTON FROM 111,200 TYPE 1 ACTION (oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTER

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VisualSUC  º Autor ³ Eduardo Patriani   º Data ³  05/06/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ VISUALIZA O CHAMADO DO PEDIDO.         		                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                                 `
Static Function VisualSUC( aDados )

Local nRecno 	:= 0

aRotina			:= {{ "Pesquisar","AxPesqui" 			,0,1 },;
					{ "Visualizar","AxVisual"   		,0,2 },;
					{ "Chamadas","TK271CallCenter"		,0,3 } }

INCLUI 			:= .F.

DbSelectArea("SUC")
DbSetOrder(1)
DbSeek(xFilial("SUC") + aDados[3] )
nRecno := SUC->(Recno())

TK271CallCenter("SUC",nRecno,2)

Return