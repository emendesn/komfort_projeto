#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} CALCCOM
Description //Esta rotina efetua o calculo das comissões de Vendedores e Gestores.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 13/03/2020 /*/
//----------------------------------------------------------------------------------------------------
USER FUNCTION CALCCOM()

    Local aSize        := MsAdvSize() 
    Private cCadastro := "Calculo de Comissões"
    Private oTela
    Private oLayer := FWLayer():new()
    Private aButtons   := {}
	Private oPainel1
    Private oPainel2
    Private oPainel3
    Private oPainel4
    Private oPainel5
    Private oBrowse1
    Private oBrowse2
    Private oSay1
    Private oLoja
    Private cLoja := Space(4)
    Private oSay2
    Private oData
    Private dData := Date()
    Private oSay3
    Private oVend
    Private cVend := Space(6)
    Private oSay4
    Private oGest
    Private cGest := Space(6)
    Private oAdd1
    private oAdd2
    Private aVend := {}
    Private aGestor := {}
    Private aBrowse := {{"","","","",""}}
    Private oSay5
    Private oSay6
    Private oSay7
    Private oLimp
    Private oCalc
    Private oGrava
    Private oCtlj3
    Private nCtlj3  := 0
    Private oCtlj35
    Private nCtlj35 := 0
    Private oCtlj4
    Private nCtlj4  := 0
    Private oCtven3
    Private nCtven3 := 0
    Private oCtven35
    Private nCtven35 := 0
    Private oCtven4
    Private nCtven4 := 0
    Private oCtind3
    Private nCtind3 := 0
    Private oCtind35
    Private nCtind35 := 0
    Private oCtind4
    Private nCtind4 := 0
    Private lGrava  := .T.
    
    //Inicio tela
    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE cCadastro Of oMainWnd PIXEL

    AAdd(aButtons,{	'',{|| U_CALCCOMR() }, "Relatorio Comissões"} )

    EnchoiceBar(oTela,{ || oTela:End() },{ || oTela:End() },.F.,aButtons,,,.F.,.F.,.T.,.F.,.F.)
    
    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    //Inicializa o FWLayer com a janela que ele pertencera e se sera exibido o botao de fechar
	oLayer:init(oTela,.F.)
	
	//Cria as Linhas do Layer
    oLayer:AddLine("L01",25,.F.)
	oLayer:AddLine("L02",50,.F.)
	oLayer:AddLine("L03",25,.F.)

    //Cria as colunas do Layer
	oLayer:addCollumn('Col01_01',050,.F.,"L01")//Parametros
    oLayer:addCollumn('Col01_02',050,.F.,"L01")//Cotas
	oLayer:addCollumn('Col02_01',050,.F.,"L02")//Grid vendedores
    oLayer:addCollumn('Col02_02',050,.F.,"L02")//Grid Gestores
    oLayer:addCollumn('Col03_01',100,.F.,"L03")//Totais
    
    //Cria as Janelas do Layer
    oLayer:addWindow('Col01_01','C1_Win01_01','Parametros',100,.F.,.F.,/**/,"L01",/**/)
    oLayer:addWindow('Col01_02','C1_Win01_02','Cotas',100,.F.,.F.,/*{|| }*/,"L01",/**/)
    oLayer:addWindow('Col02_01','C2_Win02_01','Vendedores',100,.F.,.F.,/**/,"L02",/**/)
    oLayer:addWindow('Col02_02','C2_Win02_02','Gestor',100,.F.,.F.,/**/,"L02",/**/)
    oLayer:addWindow('Col03_01','C3_Win03_01','',100,.F.,.F.,/**/,"L03",/**/)
 
    oPainel1 := oLayer:getWinPanel('Col01_01','C1_Win01_01',"L01")//Parametros
    oPainel2 := oLayer:getWinPanel('Col01_02','C1_Win01_02',"L01")//Cotas Diarias
	oPainel3 := oLayer:getWinPanel('Col02_01','C2_Win02_01',"L02")//Grid de Vendedores
    oPainel4 := oLayer:getWinPanel('Col02_02','C2_Win02_02',"L02")//Grid de gestores
    oPainel5 := oLayer:getWinPanel('Col03_01','C3_Win03_01',"L03")//Ações

    oBrowse1 := TwBrowse():New(000, 000, oPainel3:nClientWidth/2, oPainel3:nClientHeight/2,, {  'Codigo',;
                                                                                                'Vendedor',;
                                                                                                'Vendas',;
                                                                                                'Porcentagem',;
                                                                                                'Total' },,oPainel3,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oBrowse1:SetArray(aBrowse)
    oBrowse1:bLine := {|| { aBrowse[oBrowse1:nAt,01],aBrowse[oBrowse1:nAt,02],aBrowse[oBrowse1:nAt,03],aBrowse[oBrowse1:nAt,04],aBrowse[oBrowse1:nAt,05] }}
                                                                                                
    
    oBrowse2 := TwBrowse():New(000, 000, oPainel4:nClientWidth/2, oPainel4:nClientHeight/2,, {  'Codigo',;
                                                                                                'Gestor',;
                                                                                                'Vendas Loja',;
                                                                                                'Porcentagem',;
                                                                                                'Total' },,oPainel4,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oBrowse2:SetArray(aBrowse)
    oBrowse2:bLine := {|| { aBrowse[oBrowse2:nAt,01],aBrowse[oBrowse2:nAt,02],aBrowse[oBrowse2:nAt,03],aBrowse[oBrowse2:nAt,04],aBrowse[oBrowse2:nAt,05] }}
   
    Pesq()
    oBrowse1:AARRAY := {}
    oBrowse2:AARRAY := {}
    
    ACTIVATE MSDIALOG oTela CENTERED

Return()

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Pesq
Description //Função que carrega os objetos de pesquisa e botões na tela.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 13/03/2020 /*/
//----------------------------------------------------------------------------------------------------
Static Function Pesq()

    //'Loja
	@  001, 002 Say  oSay1 Prompt 'Loja:' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel1 Pixel
	@  001, 020 MSGet oLoja Var cLoja FONT oFont11 COLOR CLR_BLUE Pixel SIZE  20, 05 When .T. F3 "SM0"	Of oPainel1 Picture "9999"
	
    //'Data 
	@  001, 055 Say  oSay2 Prompt 'Data:' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel1 Pixel 
	@  001, 072 MSGet oData	Var dData	  FONT oFont11 COLOR CLR_BLUE Pixel SIZE  40, 05 When .T.	Of oPainel1 VALID {|| CotaLoja()} 

    //Vendedor
    @  015, 002 Say   oSay3 Prompt 'Vendedor:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel1 Pixel 
	@  015, 035 MSGet oVend	Var cVend		    FONT oFont11 COLOR CLR_BLUE Pixel SIZE  20, 05 When .T. F3 "SA3" Of oPainel1 Picture "999999"
    oAdd1    := tButton():New(015,072,"Adicionar",oPainel1, {|| MsgRun("Adicionando Vendedor...","Aguarde", {|| AddVend()})   } ,40,10,,,,.T.,,,,{|| })

    //Gestor
    @  030, 002 Say   oSay4 Prompt 'Gestor:'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel1 Pixel 
    @  030, 035 MSGet oGest	Var cGest		    FONT oFont11 COLOR CLR_BLUE Pixel SIZE  20, 05 When .T. F3 "SA3" Of oPainel1 Picture "999999"
    oAdd2    := tButton():New(030,072,"Adicionar",oPainel1,{|| MsgRun("Adicionando Gestor...","Aguarde", {|| AddGest()})} ,40,10,,,,.T.,,,,{|| })
    
    oLimp    := tButton():New(001,275,"Limpar Tela",   oPainel1,{|| Limpar() } ,50,20,,,,.T.,,,,{|| })
    oCalc    := tButton():New(005,005,"Calcular Comissões",oPainel5,{|| Calcula() } ,50,20,,,,.T.,,,,{|| })
    oGrava   := tButton():New(005,085,"Gravar Comissões",oPainel5,{|| Grava() } ,50,20,,,,.T.,,,,{|| })

    //Cotas
    @  001, 075 Say  oSay5 Prompt '3,00 %' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel2 Pixel
    @  001, 150 Say  oSay6 Prompt '3,50 %' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel2 Pixel
    @  001, 225 Say  oSay7 Prompt '4,00 %' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel2 Pixel

    @  010, 065 MSGet oCtlj3    Var nCtlj3  FONT oFont11 COLOR CLR_BLUE Pixel SIZE  40, 05 When .F. Of oPainel2 Picture "@E 999,999.99"
    @  010, 140 MSGet oCtlj35   Var nCtlj35 FONT oFont11 COLOR CLR_BLUE Pixel SIZE  40, 05 When .F. Of oPainel2 Picture "@E 999,999.99"
    @  010, 215 MSGet oCtlj4    Var nCtlj4  FONT oFont11 COLOR CLR_BLUE Pixel SIZE  40, 05 When .F. Of oPainel2 Picture "@E 999,999.99"

    @  020, 065 MSGet oCtven3   Var nCtven3  FONT oFont11 COLOR CLR_BLUE Pixel SIZE  40, 05 When .F. Of oPainel2 Picture "@E 999,999.99"
    @  020, 140 MSGet oCtven35  Var nCtven35 FONT oFont11 COLOR CLR_BLUE Pixel SIZE  40, 05 When .F. Of oPainel2 Picture "@E 999,999.99"
    @  020, 215 MSGet oCtven4   Var nCtven4  FONT oFont11 COLOR CLR_BLUE Pixel SIZE  40, 05 When .F. Of oPainel2 Picture "@E 999,999.99"

    @  030, 065 MSGet oCtind3  Var nCtind3  FONT oFont11 COLOR CLR_BLUE Pixel SIZE  40, 05 When .F. Of oPainel2 Picture "@E 999,999.99"
    @  030, 140 MSGet oCtind35 Var nCtind35 FONT oFont11 COLOR CLR_BLUE Pixel SIZE  40, 05 When .F. Of oPainel2 Picture "@E 999,999.99"
    @  030, 215 MSGet oCtind4  Var nCtind4  FONT oFont11 COLOR CLR_BLUE Pixel SIZE  40, 05 When .F. Of oPainel2 Picture "@E 999,999.99"
  
    oLayer:Refresh()

Return

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} AddVend
Description //Função que adiciona o vendedor no grid de vendedores.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 13/03/2020 /*/
//----------------------------------------------------------------------------------------------------
Static Function AddVend()

Local cNomeV  := Alltrim(Posicione("SA3",1, xFilial("SA3") + cVend, "A3_NOME"))
Local nx := 0

If Empty(cLoja)
    MsgAlert("Campo Loja Vazio.","Atenção" )
    Return
EndIf

If Empty(nCtlj3)
    MsgAlert("Cotas da loja não informada.","Atenção")
    Return
EndIf

If Empty(cVend)
    MsgAlert("Campo Vendedor vazio.","Atenção")
    Return
EndIf

For nx := 1 To Len(oBrowse1:Aarray)
    If oBrowse1:Aarray[nx,1] == cVend
        MsgAlert("Vendedor ja adicionado ao Grid.","Atenção")
        Return
    EndIf
Next nx

aAdd(aVend,{ cVend,;
             cNomeV,;
             VendaInd(cLoja,cVend,dData),;
              0,;
              0 })

if len(aVend) <= 0
   	aAdd(aVend,{"","",0,0,0})
endif

oBrowse1:SetArray(aVend)

oBrowse1:bLine := {|| { aVend[oBrowse1:nAt,01],;
                        aVend[oBrowse1:nAt,02],;
                        Transform(aVend[oBrowse1:nAt,03], "@E 999,999.99"),;
                        aVend[oBrowse1:nAt,04],;
                        aVend[oBrowse1:nAt,05] }}

CotInd()

cVend := space(6)

oBrowse1:Align := CONTROL_ALIGN_ALLCLIENT
oBrowse1:refresh()
oLayer:Refresh()                        

Return

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} VendaInd
Description //Função que carrega o total de vendas do vendedor para loja e data especificadas.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 13/03/2020 /*/
//----------------------------------------------------------------------------------------------------
Static Function VendaInd(cLoja,cVend,dData)

Local cQuery  := ""
Local cAlias  := GetNextAlias()
Local nValor  := 0

Default cLoja := ""
Default cvend := ""
Default dData := Date()

cQuery := " SELECT ISNULL(SUM(E1_VALOR),0) VENDAS FROM SE1010(NOLOCK) " + CRLF 
cQuery += " WHERE E1_MSFIL = '" + cLoja +"' " + CRLF
cQuery += " AND E1_VEND1 = '" + cVend +"' " + CRLF
cQuery += " AND E1_EMISSAO = '"+ DTOS(dData)+"' " + CRLF
cQuery += " AND E1_TIPO IN ('R$','CD','CC','DOC','BOL','CHK') " + CRLF
cQuery += " AND D_E_L_E_T_ = '' "

PlsQuery(cQuery, cAlias)
  
If (cAlias)->(!EOF())
      nValor := (cAlias)->VENDAS
EndIF

(cAlias)->(dbCloseArea())

Return nValor

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} AddGest
Description //Função que adiciona os gestores no grid de Gestores.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 13/03/2020 /*/
//----------------------------------------------------------------------------------------------------
Static Function AddGest()

Local cNomeG  := Alltrim(Posicione("SA3",1, xFilial("SA3") + cGest, "A3_NOME"))
Local nx := 0

If Empty(cLoja)
    MsgAlert("Campo Loja Vazio.","Atenção" )
    Return
EndIf

If Empty(nCtlj3)
    MsgAlert("Cotas da loja não informada.","Atenção")
    Return
EndIf

If Empty(cGest)
    MsgAlert("Campo Gestor vazio.","Atenção")
    Return
EndIf

For nx := 1 To Len(oBrowse2:Aarray)
    If oBrowse2:Aarray[nx,1] == cGest
        MsgAlert("Gestor ja adicionado ao Grid.","Atenção")
        Return
    EndIf
Next nx

aAdd(aGestor,{ cGest,;
               cNomeG,;
               VendaLj(cLoja, dData),;
               0,;
               0 })

if len(aGestor) <= 0
   	aAdd(aGestor,{"","",0,0,0})
endif

oBrowse2:SetArray(aGestor)

oBrowse2:bLine := {|| { aGestor[oBrowse2:nAt,01],;
                        aGestor[oBrowse2:nAt,02],;
                        Transform(aGestor[oBrowse2:nAt,03], "@E 999,999.99"),;
                        aGestor[oBrowse2:nAt,04],;
                        aGestor[oBrowse2:nAt,05] }}

cGest := Space(6)

oBrowse2:Align := CONTROL_ALIGN_ALLCLIENT
oBrowse2:refresh()
oLayer:Refresh()                        

Return

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} VendaLj
Description //Função que carrega o total de vendas da loja em determinada data.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 13/03/2020 /*/
//----------------------------------------------------------------------------------------------------
Static Function VendaLj(cLoja, dData)

Local cQuery  := ""
Local cAlias  := GetNextAlias()
Local nValor  := 0

Default cLoja := ""
Default dData := Date()

cQuery := " SELECT ISNULL(SUM(E1_VALOR),0) TOTAL FROM SE1010(NOLOCK) " + CRLF 
cQuery += " WHERE E1_MSFIL = '" + cLoja +"' " + CRLF
cQuery += " AND E1_EMISSAO = '"+ DTOS(dData)+"' " + CRLF
cQuery += " AND E1_TIPO IN ('R$','CD','CC','DOC','BOL','CHK') " + CRLF
cQuery += " AND D_E_L_E_T_ = '' "

PlsQuery(cQuery, cAlias)

If (cAlias)->(!EOF())
    nValor := (cAlias)->TOTAL
EndIf

(cAlias)->(dbCloseArea())

Return nValor

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} CotaLoja
Description //Função que carrega os valores das comissões cadastrados na tabela ZK1010 de acordo com a loja e data informada.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 13/03/2020 /*/
//----------------------------------------------------------------------------------------------------
Static Function CotaLoja()

Local cQuery := ""
Local cAlias := GetnextAlias()

If Empty(cLoja)
    MsgAlert("Campo Loja Vazio.","Atênção")
    Return
EndIf

cQuery := " SELECT ZK1_FILIAL,ZK1_DATA,ZK1_META1,ZK1_META2,ZK1_META3 FROM ZK1010(NOLOCK) " + CRLF 
cQuery += " WHERE D_E_L_E_T_ = '' " + CRLF
cQuery += " AND ZK1_FILIAL = '"+ cLoja +"' " + CRLF
cQuery += " AND ZK1_DATA = '"+ DTOS(dData)+"' " 

PlsQuery(cQuery, cAlias)

iF (cAlias)->(!eof())
    nCtlj3  := (cAlias)->ZK1_META1
    nCtlj35 := (cAlias)->ZK1_META2
    nCtlj4  := (cAlias)->ZK1_META3
    CotInd()
    Recalc()
else
    MsgAlert("Não existem cotas cadastradas para esta data.","Atenção")
    nCtlj3  := 0
    nCtlj35 := 0
    nCtlj4  := 0 
EndIf    

(cAlias)->(dbCloseArea())

lGrava := .T.

Return

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} CotInd
Description //Função que calcula as cotas pela loja e individuais.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 13/03/2020 /*/
//----------------------------------------------------------------------------------------------------
Static Function CotInd()

Local nx := 0
Local ny := 0

//Preenche as cotas diarias individuais 3%
nCtven3 :=  nCtlj3 / Len(oBrowse1:Aarray)
nCtind3 :=  nCtven3 + ((nCtven3/100)*10)

//Preenche as cotas diarias individuais 3,5%
nCtven35 :=  nCtlj35 / Len(oBrowse1:Aarray)
nCtind35 :=  nCtven35 + ((nCtven35/100)*10) 

//Preenche as cotas diarias individuais 4%
nCtven4 :=  nCtlj4 / Len(oBrowse1:Aarray)
nCtind4 :=  nCtven4 + ((nCtven4/100)*10) 

For nx := 1 To Len(oBrowse1:AARRAY)
    oBrowse1:AARRAY[nx,4] := 0
    oBrowse1:AARRAY[nx,5] := 0
Next nx

For ny := 1 To Len(oBrowse2:AARRAY)
    oBrowse2:AARRAY[ny,4] := 0
    oBrowse2:AARRAY[ny,5] := 0
Next ny 

Return 

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Recalc
Description //Função que recalcula os valores de venda por vendedor e total de loja.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 13/03/2020 /*/
//----------------------------------------------------------------------------------------------------
Static Function Recalc()

Local nx := 0
Local ny := 0

If Len(oBrowse1:AARRAY) > 0
    For nx := 1 To Len(oBrowse1:AARRAY)
        oBrowse1:AARRAY[nx,3] := VendaInd(cLoja,oBrowse1:AARRAY[nx,1],dData)
    Next nx
EndIF
oBrowse1:Refresh()

If Len(oBrowse2:AARRAY) > 0
    For ny := 1 To Len(oBrowse2:AARRAY)
        oBrowse2:AARRAY[ny,3] := VendaLj(cLoja,dData)
    Next ny
EndIF
oBrowse2:Refresh()

Return

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Limpar
Description //Função que limpa os campos e grids.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 13/03/2020 /*/
//----------------------------------------------------------------------------------------------------
Static Function Limpar()

cLoja    := Space(4)
dData    := Date()
cVend    := Space(6)
cGest    := Space(6)
nCtlj3   := 0
nCtlj35  := 0
nCtlj4   := 0
nCtven3  := 0
nCtven35 := 0
nCtven4  := 0
nCtind3  := 0
nCtind35 := 0
nCtind4  := 0
oBrowse1:AARRAY := {}
oBrowse2:AARRAY := {}
aVend    := {}
aGestor  := {}

lGrava   := .T.

Return

//----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Calcula
Description //Função que calcula a porcentagem e o valor total de comissão.
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 13/03/2020 /*/
//----------------------------------------------------------------------------------------------------
Static Function Calcula()

Local nx := 0
Local ny := 0

If Len(oBrowse1:AARRAY) == 0 .Or. Len(oBrowse2:AARRAY) == 0
    MsgAlert("Não é possivel calcular comissão. Grid Vazio.", "Atenção")
    Return
EndIF

//Calculo Comissão Gestor
For ny := 1 To Len(oBrowse2:AARRAY)
    If oBrowse2:AARRAY[ny,1] == "000062" //Tratamento especifico para a loja Guarapiranga. Usuario Fernando Mozetic
        oBrowse2:AARRAY[ny,4] := 0.75
        oBrowse2:AARRAY[ny,5] := Round(oBrowse2:AARRAY[ny,3]/100*oBrowse2:AARRAY[ny,4], 2)
        oBrowse2:Refresh()
    Else
        Do Case
            Case oBrowse2:AARRAY[ny,3] >= nCtlj35     

                oBrowse2:AARRAY[ny,4] := 1.5
                oBrowse2:AARRAY[ny,5] := Round(oBrowse2:AARRAY[ny,3]/100*oBrowse2:AARRAY[ny,4], 2)
                oBrowse2:Refresh()

            Case oBrowse2:AARRAY[ny,3] >= nCtlj3 .and. oBrowse2:AARRAY[ny,3] <  nCtlj35

                oBrowse2:AARRAY[ny,4] := 1.25
                oBrowse2:AARRAY[ny,5] := Round(oBrowse2:AARRAY[ny,3]/100*oBrowse2:AARRAY[ny,4], 2)
                oBrowse2:Refresh()

            Case oBrowse2:AARRAY[ny,3] < nCtlj3 

                oBrowse2:AARRAY[ny,4] := 1
                oBrowse2:AARRAY[ny,5] := Round(oBrowse2:AARRAY[ny,3]/100*oBrowse2:AARRAY[ny,4], 2)
                oBrowse2:Refresh()    
        EndCase
    EndIF
Next ny    

//Calculo Comissão Vendedores
For nx := 1 To Len(oBrowse1:AARRAY)
    Do Case 
        
        Case oBrowse2:AARRAY[1,3] >= nCtlj4 
            
            If oBrowse1:AARRAY[nx,3] >= nCtven4 
               
                oBrowse1:AARRAY[nx,4] := 4
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()

            ElseIf oBrowse1:AARRAY[nx,3] >= nCtind4

                oBrowse1:AARRAY[nx,4] := 4
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()
            
            Else

                oBrowse1:AARRAY[nx,4] := 2.5
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()            

            EndIF     
        
        Case oBrowse2:AARRAY[1,3] >= nCtlj35 .and. oBrowse2:AARRAY[1,3] < nCtlj4

            If oBrowse1:AARRAY[nx,3] >= nCtven35 
                
                oBrowse1:AARRAY[nx,4] := 3.5
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()

            ElseIf oBrowse1:AARRAY[nx,3] >= nCtind35

                oBrowse1:AARRAY[nx,4] := 3.5
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()
            
            Else

                oBrowse1:AARRAY[nx,4] := 2.5
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()

            EndIf    
        
        Case oBrowse2:AARRAY[1,3] >= nCtlj3 .and. oBrowse2:AARRAY[1,3] < nCtlj35

            If oBrowse1:AARRAY[nx,3] >= nCtven3 
                
                oBrowse1:AARRAY[nx,4] := 3
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()

            ElseIf oBrowse1:AARRAY[nx,3] >= nCtind3

                oBrowse1:AARRAY[nx,4] := 3
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()
            
            Else

                oBrowse1:AARRAY[nx,4] := 2.5
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()

            EndIf

        Case oBrowse2:AARRAY[1,3] < nCtlj3

            If oBrowse1:AARRAY[nx,3] >= nCtind4
                oBrowse1:AARRAY[nx,4] := 4
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()
            
            ElseIf oBrowse1:AARRAY[nx,3] >= nCtind35 .AND. oBrowse1:AARRAY[nx,3] < nCtind4
                oBrowse1:AARRAY[nx,4] := 3.5
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()
            
            ElseIf oBrowse1:AARRAY[nx,3] >= nCtind3 .AND. oBrowse1:AARRAY[nx,3] < nCtind35 
                oBrowse1:AARRAY[nx,4] := 3
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()
            
            Else 
                oBrowse1:AARRAY[nx,4] := 2.5
                oBrowse1:AARRAY[nx,5] := Round(oBrowse1:AARRAY[nx,3]/100*oBrowse1:AARRAY[nx,4], 2)
                oBrowse1:Refresh()
            EndIF              
    EndCase
Next nx

Return

//---------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Grava
Description //Função que grava os dados na tabela de comissões de venda(Z22010)
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 16/03/2020 /*/
//----------------------------------------------------------------------------------------------------

Static Function Grava()

Local aDados := {}
Local nx := 0
Local ny := 0
Local nq := 0
Local cDescLj := Alltrim(Posicione("SM0",1,cEmpAnt+cLoja,"M0_FILIAL"))
Local cUsrInc := Alltrim(UsrRetName(__cUserId))

If ! lGrava
    MsgAlert("Gravação ja efetuada. Altere a data para calculo","Atenção")
    Return
EndIf

If Len(oBrowse1:AARRAY) == 0 .OR. Len(oBrowse2:AARRAY) == 0
    MsgAlert("Grid de vendedores ou gestores vazio","Atenção")
    Return
ENDIF

If oBrowse1:AARRAY[1,4] == 0 .OR. oBrowse2:AARRAY[1,4] == 0
    MsgAlert("Comissões não calculadas. Efetue o calculo das comissões para gravar.","Atenção")
    Return
EndIF

aDados := {}

For nx := 1 To Len(oBrowse1:AARRAY)

    AADD(aDados, { cLoja,;
                   dData,;
                   'Vendedor',;
                   oBrowse1:AARRAY[nx,1],; 
                   oBrowse1:AARRAY[nx,2],;
                   oBrowse1:AARRAY[nx,3],;
                   oBrowse1:AARRAY[nx,4],;
                   oBrowse1:AARRAY[nx,5] })

Next nx

For ny := 1 To Len(oBrowse2:AARRAY)

    AADD(aDados, { cLoja,;
                   dData,;
                   'Gestor',;
                   oBrowse2:AARRAY[ny,1],; //Codigo de usuario
                   oBrowse2:AARRAY[ny,2],; // Nome usuario
                   oBrowse2:AARRAY[ny,3],; // vendas
                   oBrowse2:AARRAY[ny,4],; // Porcentagem
                   oBrowse2:AARRAY[ny,5] }) // Total

Next ny

dbSelectArea("Z22")
dbSetOrder(1)

For nq := 1 To Len(aDados)

    If dbSeek(cLoja + DTOS(dData) + aDados[nq,4]) // Codigo Loja + Data + Codigo usuario
        Reclock("Z22", .F.)   
    Else
        RecLock("Z22", .T.)
    EndIF
        Z22->Z22_LOJA   := aDados[nq,1]
        Z22->Z22_DESCLJ := cDescLj
        Z22->Z22_DATA   := aDados[nq,2]
        Z22->Z22_CARGO  := aDados[nq,3]
        Z22->Z22_CODFUN := aDados[nq,4]
        Z22->Z22_NOME   := aDados[nq,5]
        Z22->Z22_VENDA  := aDados[nq,6]
        Z22->Z22_PORCEN := aDados[nq,7]
        Z22->Z22_COMISS := aDados[nq,8]
        Z22->Z22_USRINC := cUsrInc
        Z22->Z22_DTINC  := dDataBase
        Z22->(MsUnlock())     
Next nq

Z22->(dbCloseArea())

MsgAlert("Efetuada gravação das comissões.", "Comissões Gravadas")

lGrava := .F.

Return