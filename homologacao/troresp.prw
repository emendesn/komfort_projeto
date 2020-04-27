#include 'protheus.ch'
#include 'parmtype.ch'

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} TRORESP
Description //Esta rotina carrega os atendimentos do telemarketing para que seja efetuada a troca do responsavel.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 15/02/2020 /*/
//----------------------------------------------------------------------------------------------------
user function TRORESP()
	
Local aSize        := MsAdvSize()

Private aDados     := {} 
Private oLayer     := FWLayer():new()
Private aButtons   := {}
Private cCadastro  := "Alterar responsável pelo Atendimento."
Private oTela
Private oLayer
Private oFont11
Private oPainel1
Private oPainel2
Private oBrowse1
Private dDateDe    := Date()   
Private ddateAte   := Date()
Private oSay1
Private oSay2
Private oSay3
Private oSay4
Private oSay5
Private oResp
Private cResp  := space(6)
Private oOper
Private cOper  := space(6)
Private cAssun := space(6)
Private oAssun
Private oPesq  


DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE cCadastro Of oMainWnd PIXEL

EnchoiceBar(oTela,{ || oTela:End() },{ || oTela:End() },.F.,aButtons,,,.F.,.F.,.T.,.F.,.F.)

//Inicializa o FWLayer com a janela que ele pertencera e se sera exibido o botao de fechar
oLayer:init(oTela,.F.)
//Cria as Linhas do Layer
oLayer:AddLine("L01",20,.F.)
oLayer:AddLine("L02",80,.F.)
//Cria as colunas do Layer
oLayer:addCollumn('Col01_01',100,.F.,"L01")//Barra de pesquisa
oLayer:addCollumn('Col02_01',100,.F.,"L02")//Grid principal
//Cria as janelas
oLayer:addWindow('Col01_01','C1_Win01_01','Pesquisa',100,.F.,.F.,/**/,"L01",/**/)
oLayer:addWindow('Col02_01','C1_Win02_01','Grid',  100,.F.,.F.,/**/,"L02",/**/)
//Adiciona os paineis aos objetos
oPainel1 := oLayer:GetWinPanel('Col01_01','C1_Win01_01',"L01")
oPainel2 := oLayer:GetWinPanel('Col02_01','C1_Win02_01',"L02")

//Grid Central
oBrowse1 := TwBrowse():New(000, 000, oPainel2:nClientWidth/2, oPainel2:nClientHeight/2,, { 'Atendimento',;
                                                            							   'Data Emissao',;
                                                                                           'Cod.Operador',;
																						   'Operador',;
                                                                                           'Status',;
                                                                                           'Cod.Responsavel',;
																						   'Responsavel',;
                                                                                           'Cod.Assunto',;
																						   'Desc. Assunto',;
                                                                                           '' },,oPainel2,,,,,,,,,,,, .F.,, .T.,, .T.,,,)

fCarr()                                                                                           
Pesq()
ACTIVATE MSDIALOG oTela CENTERED

return

Static Function Pesq()

    //'Data Abertura De
	@  02,  005 Say  oSay1 Prompt 'Emissão de:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel1 Pixel
	@  01,  045 MSGet oDataDe	Var dDateDe		    FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oPainel1
	//'Data Abertura Ate
	@  02,  100 Say  oSay2 Prompt 'Emissão Até:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel1 Pixel 
	@  01,  140 MSGet oDataAte	Var dDateAte		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oPainel1
	
	@  15,  005 Say   oSay3 Prompt 'Responsavel:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel1 Pixel 
	@  15,  045 MSGet oResp	Var cResp		        FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T. F3 "SUL" Of oPainel1
	
	@  30,  005 Say   oSay4 Prompt 'Operador:'  	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel1 Pixel 
	@  30,  045 MSGet oResp	Var cOper		        FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	F3 "SU7" Of oPainel1
	
	@  45,  005 Say   oSay5 Prompt 'Assunto:'  	    FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel1 Pixel 
	@  45,  045 MSGet oAssun	Var cAssun		    FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	F3 "TMK020" Of oPainel1
	
	oPesq   := tButton():New(001,200,"Pesquisar",oPainel1,{|| fCarr()} ,40,12,,,,.T.,,,,{|| })
	
    oLayer:Refresh()

Return

Static Function fCarr()

Local nRegistros := 0 
Local nCount := 0    
Local cAlias := getNextAlias()
Local cQuery := ""

aDados := {}
   
cQuery += " SELECT UC_CODIGO,UC_DATA,UC_OPERADO,U7_NOME,UC_STATUS,UC_TIPO,UL_DESC,UD_ASSUNTO,X5_DESCRI " + CRLF
cQuery += " FROM " + RetSqlName("SUC") + "(NOLOCK) SUC " + CRLF
cQuery += " INNER JOIN " + RetSqlName("SUD") + "(NOLOCK) SUD ON SUC.UC_CODIGO = SUD.UD_CODIGO " + CRLF
cQuery += " INNER JOIN " + RetSqlName("SU7") + "(NOLOCK) SU7 ON SU7.U7_COD = SUC.UC_OPERADO " + CRLF
cQuery += " INNER JOIN " + RetSqlName("SUL") + "(NOLOCK) SUL ON SUL.UL_TPCOMUN = SUC.UC_TIPO " + CRLF
cQuery += " INNER JOIN " + RetSqlName("SX5") + "(NOLOCK) SX5 ON SX5.X5_CHAVE = SUD.UD_ASSUNTO " + CRLF
cQuery += " WHERE SUC.D_E_L_E_T_ = '' " + CRLF
cQuery += " AND SUD.D_E_L_E_T_ = '' " + CRLF
cQuery += " AND SU7.D_E_L_E_T_ = '' " + CRLF
cQuery += " AND SX5.D_E_L_E_T_ = '' " + CRLF
cQuery += " AND UC_STATUS <> '3' " + CRLF
cQuery += " AND X5_TABELA = 'T1' " + CRLF
cQuery += " AND UC_DATA BETWEEN '"+ DTOS(dDateDe) +"' AND '"+ DTOS(dDateAte) +"' " + CRLF

If !Empty(cResp)
	cQuery += " AND UC_TIPO = '"+ Alltrim(cResp) +"'" + CRLF
EndIf

If !Empty(cOper)
	cQuery += " AND UC_OPERADO = '" + Alltrim(cOper) + "'" + CRLF
EndIF

If !Empty(cAssun)
	cQuery += " AND UD_ASSUNTO = '"+ Alltrim(cAssun) +"'" + CRLF
EndIF

cQuery += " GROUP BY UC_CODIGO,UC_DATA,UC_OPERADO,U7_NOME,UC_STATUS,UC_TIPO,UL_DESC,UD_ASSUNTO,X5_DESCRI " + CRLF
cQuery += " ORDER BY UC_CODIGO " + CRLF  
 
PlsQuery(cQuery, cAlias)
	
(cAlias)->(dbEval({|| nRegistros++}))
(cAlias)->(dbgotop())
    
procregua(nRegistros)

while (cAlias)->(!eof())
		
	nCount++
	incproc("Atualizando Dados... " + cValtoChar(nCount) + " de " + cValtoChar(nRegistros))
	
	aAdd(aDados,{    (cAlias)->UC_CODIGO,;	
					 (cAlias)->UC_DATA,;
					 (cAlias)->UC_OPERADO,;
					 (cAlias)->U7_NOME,;
					 (cAlias)->UC_STATUS,;
					 (cAlias)->UC_TIPO,;
					 (cAlias)->UL_DESC,;
					 (cAlias)->UD_ASSUNTO,;
					 (cAlias)->X5_DESCRI   })
			 
	(cAlias)->(dbskip())		
endDo
	
(cAlias)->(dbCloseArea())
    
if len(aDados) <= 0
   	aAdd(aDados,{"","","","","","","","",""})
endif


oBrowse1:SetArray(aDados)

oBrowse1:bLine := {|| { aDados[oBrowse1:nAt,01],;
                        aDados[oBrowse1:nAt,02],;
                        aDados[oBrowse1:nAt,03],;
                        aDados[oBrowse1:nAt,04],;
                        aDados[oBrowse1:nAt,05],;
						aDados[oBrowse1:nAt,06],;
						aDados[oBrowse1:nAt,07],;
						aDados[oBrowse1:nAt,08],;
                        aDados[oBrowse1:nAt,09] }}

SetCab1(nRegistros)                        

oBrowse1:refresh()
oBrowse1:Align := CONTROL_ALIGN_ALLCLIENT
oBrowse1:setFocus()
oLayer:Refresh()
	
Return

//--------------------------------------------------------------
Static Function SetCab1(cParam1)
	
		cCab1 :="Total de registros: " + cValToChar(cParam1)
		oLayer:setWinTitle('Col02_01','C1_Win02_01',cCab1 ,"L02" )

Return
//--------------------------------------------------------------

