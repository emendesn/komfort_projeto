#include 'protheus.ch'
#include 'parmtype.ch'

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} TRORESP
Description //Esta rotina carrega os atendimentos do telemarketing para que seja efetuada a troca do responsavel.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 22/02/2020 /*/
//----------------------------------------------------------------------------------------------------
user function TRORESP()
	
Local aSize        := MsAdvSize()
Private _cUser     := SUPERGETMV("KH_USBLQAG", .T., "000478")
Private aDados     := {} 
Private oLayer     := FWLayer():new()
Private aButtons   := {}
Private cCadastro  := "Alterar responsável pelo Atendimento."
Private oTela
Private oFont11
Private oPainel1
Private oPainel2
Private oBrowse1
Private dDateDe    := Date()   
Private dDateAte   := Date()
Private oSay1
Private oSay2
Private oSay3
Private oSay4
Private oSay5
Private oSay6
Private oResp
Private cResp      := space(6)
Private cAltResp   := Space(6)
Private oOper
Private cOper      := space(6)
Private cAssun     := space(6)
Private oAssun
Private oPesq
Private oAlter
Private oRespAlt  


DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE cCadastro Of oMainWnd PIXEL

EnchoiceBar(oTela,{ || oTela:End() },{ || oTela:End() },.F.,aButtons,,,.F.,.F.,.T.,.F.,.F.)

//Inicializa o FWLayer com a janela que ele pertencera e se sera exibido o botao de fechar
oLayer:init(oTela,.F.)
//Cria as Linhas do Layer
oLayer:AddLine("L01",100,.F.)
//Cria as colunas do Layer
oLayer:addCollumn('Col01_01',100,.F.,"L01")
//Cria as janelas
oLayer:addWindow('Col01_01','C1_Win01_01','Pesquisa',35,.T.,.F.,/**/,"L01",/**/)
oLayer:addWindow('Col01_01','C1_Win02_01','Grid',  65,.F.,.F.,/**/,"L01",/**/)
//Adiciona os paineis aos objetos
oPainel1 := oLayer:GetWinPanel('Col01_01','C1_Win01_01',"L01")
oPainel2 := oLayer:GetWinPanel('Col01_01','C1_Win02_01',"L01")

//Grid Central
oBrowse1 := TwBrowse():New(000, 000, oPainel2:nClientWidth/2, oPainel2:nClientHeight/2,, { 'Atendimento',;
                                                            							   'Data Emissao',;
                                                                                           'Cod.Operador',;
																						   'Operador',;
                                                                                           'Status Atendimento',;
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
	
	@  15,  005 Say   oSay3 Prompt 'Responsável:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel1 Pixel 
	@  15,  045 MSGet oResp	Var cResp		        FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T. F3 "SUL" Of oPainel1
	
	@  30,  005 Say   oSay4 Prompt 'Operador:'  	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel1 Pixel 
	@  30,  045 MSGet oOper	Var cOper		        FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	F3 "SU7" Of oPainel1
	
	@  45,  005 Say   oSay5 Prompt 'Assunto:'  	    FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel1 Pixel 
	@  45,  045 MSGet oAssun	Var cAssun		    FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	F3 "TMK020" Of oPainel1
	
	oPesq   := tButton():New(001,200,"Pesquisar",oPainel1,{|| Processa( {|| fCarr()  }, "Aguarde...", "Carregando Dados...", .f.)} ,40,12,,,,.T.,,,,{|| })

    If __cuserId $ _cUser // Só libera a alteração para os usuarios do parametro KH_USBLQAG.
        @  02,  260 Say   oSay6 Prompt 'Alterar Responsável'	FONT oFont11 COLOR CLR_BLUE Size  100, 08 Of oPainel1 Pixel 
        @  10,  260 MSGet oRespAlt	Var cAltResp            FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T. F3 "SUL" Of oPainel1
        oAlter  := tButton():New(022,260,"Alterar",oPainel1,{|| Altera() },40,12,,,,.T.,,,,{|| })
	EndIF
  
  oLayer:Refresh()

Return

Static Function fCarr()

Local nRegistros := 0 
Local nCount := 0    
Local cAlias := getNextAlias()
Local cQuery := ""

aDados := {}
   
cQuery += " SELECT UC_CODIGO,UC_DATA,UC_OPERADO,U7_NOME,UC_STATUS,UC_TIPO,UL_DESC,UD_ASSUNTO,X5_DESCRI,SUC.R_E_C_N_O_  " + CRLF
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

cQuery += " GROUP BY UC_CODIGO,UC_DATA,UC_OPERADO,U7_NOME,UC_STATUS,UC_TIPO,UL_DESC,UD_ASSUNTO,X5_DESCRI,SUC.R_E_C_N_O_  " + CRLF
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
					 zCmbDesc( Alltrim(cValToChar((cAlias)->UC_STATUS)) , "UC_STATUS") ,;
					 (cAlias)->UC_TIPO,;
					 (cAlias)->UL_DESC,;
					 (cAlias)->UD_ASSUNTO,;
					 (cAlias)->X5_DESCRI,;
                     (cAlias)->R_E_C_N_O_  })
			 
	(cAlias)->(dbskip())		
endDo
	
(cAlias)->(dbCloseArea())
    
if len(aDados) <= 0
   	aAdd(aDados,{"","","","","","","","","",""})
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
/*/{Protheus.doc} SetCab1
Description //Altera o cabeçalho do grid com o total de registros da consulta
@param cParam1 Parameter Description
@author  - Everton Santos
@since 22/02/2020 /*/
//--------------------------------------------------------------
//--------------------------------------------------------------
Static Function SetCab1(cParam1)
	
		cCab1 :="Total de registros: " + cValToChar(cParam1)
		oLayer:setWinTitle('Col01_01','C1_Win02_01',cCab1 ,"L01" )

Return
//--------------------------------------------------------------

/*/{Protheus.doc} zCmbDesc
Função que retorna a descrição da opção do Combo selecionada
@type function
@version 1.0
    @param cChave, character, Chave de pesquisa dentro do combo
    @param cCampo, character, Campo do tipo combo
    @param cConteudo, character, Conteúdo no formato de combo
    @return cDescri, Descrição da opção do combo
    @example
    u_zCmbDesc("D", "C5_TIPO", "") //Utilizando por Campo
    u_zCmbDesc("S", "", "S=Sim;N=Não;A=Ambos;") //Utilizando por Conteúdo
/*/
Static Function zCmbDesc(cChave, cCampo, cConteudo)
    Local aArea       := GetArea()
    Local aCombo      := {}
    Local nAtual      := 1
    Local cDescri     := ""
    Default cChave    := ""
    Default cCampo    := ""
    Default cConteudo := ""
     
    //Se o campo e o conteúdo estiverem em branco, ou a chave estiver em branco, não há descrição a retornar
    If (Empty(cCampo) .And. Empty(cConteudo)) .Or. Empty(cChave)
        cDescri := ""
    Else
        //Se tiver campo
        If !Empty(cCampo)
            aCombo := RetSX3Box(GetSX3Cache(cCampo, "X3_CBOX"),,,1)
             
            //Percorre as posições do combo
            For nAtual := 1 To Len(aCombo)
                //Se for a mesma chave, seta a descrição
                If cChave == aCombo[nAtual][2]
                    cDescri := aCombo[nAtual][3]
                EndIf
            Next
             
        //Se tiver conteúdo
        ElseIf !Empty(cConteudo)
            aCombo := StrTokArr(cConteudo, ';')
             
            //Percorre as posições do combo
            For nAtual := 1 To Len(aCombo)
                //Se for a mesma chave, seta a descrição
                If cChave == SubStr(aCombo[nAtual], 1, At('=', aCombo[nAtual])-1)
                    cDescri := SubStr(aCombo[nAtual], At('=', aCombo[nAtual])+1, Len(aCombo[nAtual]))
                EndIf
            Next
        EndIf
    EndIf
     
    RestArea(aArea)
Return cDescri

//--------------------------------------------------------------
/*/{Protheus.doc} Altera
Description //Efetua a alteração do responsavel nos atendimentos carregados no browse.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 22/02/2020 /*/
//--------------------------------------------------------------
Static Function Altera()

Local aArea   := GetArea()
Local nx := 0

If Empty(oBrowse1:AARRAY[1][1])
	MsgStop("Não existem atendimentos carregados para alteração.", "Grid de atendimentos vazio.")
    Return
EndIf

If Empty(cAltResp)
    MsgStop("Responsável para alteração não selecionado.", "Selecione um responsável.")
    Return
EndIf

DBSelectArea("SUC")

Begin Transaction
    For nx := 1 To Len(oBrowse1:AARRAY)

        SUC->(DBGOTO( oBrowse1:AARRAY[nx][10] ))

            IF SUC->(!EOF())
                RecLock("SUC",.F.)
                    SUC->UC_TIPO := cAltResp
                SUC->(msUnlock())
            EndIF

    Next nx
End Transaction

AVISO("Alteração Concluida", "Alterações concluidas com sucesso.")
fCarr()
oBrowse1:Refresh()
oLayer:Refresh()

SUC->(DBCLOSEAREA())
RestArea(aArea)

Return