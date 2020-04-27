#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"

#DEFINE ENTER (Chr(13)+Chr(10))

Static nAltBot		:= 010
Static nDistPad		:= 001

//--------------------------------------------------------------
/*/{Protheus.doc} KHSAC003
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 30/10/2018 /*/
//--------------------------------------------------------------
USER FUNCTION KHSAC003()

    Local cDescricao := "Aprovação NCC Troca"
    Local cPerg := "KHSAC003"
	
	Private _cUser := SUPERGETMV("KH_SAC003", .T., "000478")
	Private lAcesso := .F.
	Private nOrder := 0 
    
	Private oTela
    Private aInfo := {}
	Private oLayer := FWLayer():new()
	Private aSize := FWGetDialogSize(oMainWnd)
    Private aButtons := {}
    Private aAlter := {}
    
	Private oParam
    Private oTermos
    Private oBotoes
    Private oPedidos
	Private oTitulos
	
    Private oGridNCC := nil
    Private aHeaderNCC := {}
    Private aNCC := {}

    Private oGridTit := nil
    Private aHeaderTit := {}
    Private aTitulos := {}

	Private oGridTerRet := nil
    Private aHeadTerRet := {}
    Private aTermos := {}    

	Private cPesqCli := space(50)
    
    Private oCliente
    Private cNomeCli := space(100)

	Private oDataDe
	Private oDataAte
    
    Private oParam
    private oOpcoes
    Private nOpcoes := 1

	Private oSt1 := LoadBitmap(GetResources(),'BR_VERDE') 	//BAIXADO
	Private oSt2 := LoadBitmap(GetResources(),'BR_AZUL') 	//ABERTO
	Private oSt3 := LoadBitmap(GetResources(),'BR_VERMELHO')//VENCIDO
	Private oSt4 := LoadBitmap(GetResources(),'BR_LARANJA')	//BAIXA PARCIAL

    Private oFont11

	Private nPFlag := nPTitulo := nPPrefixo := nPParcela := nPTipo := nPEmissao := nPCliente := nPLojaCli := nPNome := nPChamado := nPTroca := nPUserName := 0

	Private oPesquisa
	Private oConfNCC
	Private oReprova
	Private oConheci
    Private oSair

	if __cUserid $ _cUser
		lAcesso := .T.
	endif

    aObjects := {}
    AAdd( aObjects, { 100 , 100, .T. , .T. , .F. } )
    AAdd( aObjects, { 100 , 100, .T. , .T. , .F. } )
    AAdd( aObjects, { 100 , 100, .T. , .T. , .F. } )
    AAdd( aObjects, { 100 , 100, .T. , .T. , .F. } )

    aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5 , 5 , 5 , 5 }
    
    aPosObj := MsObjSize( aInfo, aObjects, .T. , .F. )
   
    oTela := tDialog():New(aSize[1],aSize[2],aSize[3],aSize[4],OemToAnsi(cDescricao),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
    
    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    //Verifica e cria perguntes
	xPutSx1(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	Endif	

    //Inicializa o FWLayer com a janela que ele pertencera e se sera exibido o botao de fechar
	oLayer:init(oTela,.F.)
	
	//Cria as Linhas do Layer
    oLayer:AddLine("L01",27,.F.)
	oLayer:AddLine("L02",43,.F.)
	oLayer:AddLine("L03",30,.F.)

    //Cria as colunas do Layer
	oLayer:addCollumn('Col01_01',90,.F.,"L01")//Parametros
	oLayer:addCollumn('Col01_02',10,.F.,"L01")//Acoes/botoes

    oLayer:addCollumn('Col02_01',100,.F.,"L02")//Pedidos

    oLayer:addCollumn('Col03_01',50,.F.,"L03")//Termos
    oLayer:addCollumn('Col03_02',50,.F.,"L03")//Titulos

    oLayer:addWindow('Col01_01','C1_Win01_01','Parametros',100,.F.,.F.,/**/,"L01",/**/)
    oLayer:addWindow('Col01_02','C1_Win01_02','Botoes',100,.F.,.F.,/**/,"L01",/**/)
	oLayer:addWindow('Col02_01','C2_Win02_01','Pedidos',100,.F.,.F.,/*{|| }*/,"L02",/**/)
    oLayer:addWindow('Col03_01','C3_Win03_01','Termos',100,.F.,.F.,/**/,"L03",/**/)
    oLayer:addWindow('Col03_02','C3_Win03_02','Titulos - Legenda F5',100,.F.,.F.,/**/,"L03",/**/)

    oParam := oLayer:getWinPanel('Col01_01','C1_Win01_01',"L01")
    oBotoes := oLayer:getWinPanel('Col01_02','C1_Win01_02',"L01")
    oPedidos := oLayer:getWinPanel('Col02_01','C2_Win02_01',"L02")
	oTermos := oLayer:getWinPanel('Col03_01','C3_Win03_01',"L03")
    oTitulos := oLayer:getWinPanel('Col03_02','C3_Win03_02',"L03")
	
    CriaParam()
    CriaBotoes()
    fHeadNCC()
    fHeadTit()
	fHeadTerRet()

	bAction := {|| fCarrTit(oGridNCC:acols[oGridNCC:nat][nPChamado]),;
					fCarrTermos(oGridNCC:acols[oGridNCC:nat][nPCliente],oGridNCC:acols[oGridNCC:nat][nPLojaCli]),;
					SetCab1(oGridNCC:acols[oGridNCC:nat][nPTitulo])}

	oGridNCC := MsNewGetDados():New(aSize[1],aSize[2],oPedidos:nClientWidth/2,oPedidos:nClientHeight/2,;
				,"","","",aAlter,0,9999,"","" ,"",oPedidos,aHeaderNCC,aNCC,{|| Eval(bAction)})

	oGridNCC:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGridNCC:oBrowse:bLDblClick	:= {|| fMarc(oGridNCC:NAT) }
	oGridNCC:oBrowse:bHeaderClick := {|o, iCol| fMarcAll(iCol), oGridNCC:Refresh()}
	
	oGridTit := MsNewGetDados():New(aSize[1],aSize[2],oTitulos:nClientWidth/2,oTitulos:nClientHeight/2,,"","","",aAlter,0,9999,"","" ,"",oTitulos,aHeaderTit,aTitulos)
	oGridTit:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	oGridTerRet := MsNewGetDados():New(aSize[1],aSize[2],oTermos:nClientWidth/2,oTermos:nClientHeight/2,,"","","",aAlter,0,9999,"","" ,"",oTermos,aHeadTerRet,aTermos)
	oGridTerRet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	SetKey(VK_F5, {|| lgFinanc()})
	SetKey(VK_F4, {|| lgTermoRet()})

    oTela:Activate(,,,.T.,/*valid*/,,{|| processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .F.) } )

Return()


//--------------------------------------------------------------
/*/{Protheus.doc} fHeadNCC
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 30/10/2018 /*/
//--------------------------------------------------------------
Static Function fHeadNCC()

    aHeaderNCC := {}
	
	aAdd(aHeaderNCC,{"","FLAG","@BMP",1,0,"","€€€€€€€€€€€€€€","C","","R","","","","V","","",""})
    aAdd(aHeaderNCC,{"Numero","E1_NUM",PesqPict("SE1","E1_NUM"),TamSX3("E1_NUM")[1],TamSX3("E1_NUM")[2],,"",TamSX3("E1_NUM")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderNCC,{"Prefixo","E1_PREFIXO",PesqPict("SE1","E1_PREFIXO"),TamSX3("E1_PREFIXO")[1],TamSX3("E1_PREFIXO")[2],,"",TamSX3("E1_PREFIXO")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderNCC,{"Parcela","E1_PARCELA",PesqPict("SE1","E1_PARCELA"),TamSX3("E1_PARCELA")[1],TamSX3("E1_PARCELA")[2],,"",TamSX3("E1_PARCELA")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderNCC,{"Tipo","E1_TIPO",PesqPict("SE1","E1_TIPO"),TamSX3("E1_TIPO")[1],TamSX3("E1_TIPO")[2],,"",TamSX3("E1_TIPO")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderNCC,{"Emissao","E1_EMISSAO",PesqPict("SE1","E1_EMISSAO"),TamSX3("E1_EMISSAO")[1],TamSX3("E1_EMISSAO")[2],,"",TamSX3("E1_EMISSAO")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderNCC,{"Cod.Cliente","C5_CLIENTE",PesqPict("SC5","C5_CLIENTE"),TamSX3("C5_CLIENTE")[1],TamSX3("C5_CLIENTE")[2],,"",TamSX3("C5_CLIENTE")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderNCC,{"Loja","C5_LOJACLI",PesqPict("SC5","C5_LOJACLI"),TamSX3("C5_LOJACLI")[1],TamSX3("C5_LOJACLI")[2],,"",TamSX3("C5_LOJACLI")[3]	,"","","","",,'V',,,})	
	aAdd(aHeaderNCC,{"Nome","A1_NOME",PesqPict("SA1","A1_NOME"),TamSX3("A1_NOME")[1],TamSX3("A1_NOME")[2],,"",TamSX3("A1_NOME")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderNCC,{"Chamado Sac","UC_CODIGO",PesqPict("SUC","UC_CODIGO"),TamSX3("UC_CODIGO")[1],TamSX3("UC_CODIGO")[2],,"",TamSX3("UC_CODIGO")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderNCC,{"Troca","TROCA","",3,0,,"","C"	,"","","","",,'V',,,})
    aAdd(aHeaderNCC,{"Usuario","E1_USRNAME",PesqPict("SE1","E1_USRNAME"),TamSX3("E1_USRNAME")[1],TamSX3("E1_USRNAME")[2],,"",TamSX3("E1_USRNAME")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderNCC,{"","","",1,0,,"","C"	,"","","","",,'V',,,})

	nPFlag := GdFieldPos("FLAG",aHeaderNCC)
	nPTitulo := GdFieldPos("E1_NUM",aHeaderNCC)
	nPPrefixo := GdFieldPos("E1_PREFIXO",aHeaderNCC)
	nPParcela := GdFieldPos("E1_PARCELA",aHeaderNCC)
	nPTipo := GdFieldPos("E1_TIPO",aHeaderNCC)
	nPEmissao := GdFieldPos("E1_EMISSAO",aHeaderNCC)
	nPCliente := GdFieldPos("C5_CLIENTE",aHeaderNCC)
	nPLojaCli := GdFieldPos("C5_LOJACLI",aHeaderNCC)
    nPNome := GdFieldPos("A1_NOME",aHeaderNCC)
    nPChamado := GdFieldPos("UC_CODIGO",aHeaderNCC)
    nPTroca := GdFieldPos("TROCA",aHeaderNCC)
    nPUserName := GdFieldPos("E1_USRNAME",aHeaderNCC)
    
Return()

//--------------------------------------------------------------
/*/{Protheus.doc} fHeadTit
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 30/10/2018 /*/
//--------------------------------------------------------------
Static Function fHeadTit()

    aHeaderTit := {}
    
	aAdd(aHeaderTit,{"       ","Status    ","@BMP                      ",2                      ,0                      ,,"","C"                    ,"","","","",,'V',,,})
    aAdd(aHeaderTit,{"Prefixo","E1_PREFIXO",PesqPict("SE1","E1_PREFIXO"),TamSX3("E1_PREFIXO")[1],TamSX3("E1_PREFIXO")[2],,"",TamSX3("E1_PREFIXO")[3],"","","","",,'V',,,})
	aAdd(aHeaderTit,{"Numero","E1_NUM",PesqPict("SE1","E1_NUM"),TamSX3("E1_NUM")[1],TamSX3("E1_NUM")[2],,"",TamSX3("E1_NUM")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderTit,{"Parcela","E1_PARCELA",PesqPict("SE1","E1_PARCELA"),TamSX3("E1_PARCELA")[1],TamSX3("E1_PARCELA")[2],,"",TamSX3("E1_PARCELA")[3],"","","","",,'V',,,})	
	aAdd(aHeaderTit,{"Tipo","E1_TIPO",PesqPict("SE1","E1_TIPO"),TamSX3("E1_TIPO")[1],TamSX3("E1_TIPO")[2],,"",TamSX3("E1_TIPO")[3]	,"","","","",,'V',,,})
	aAdd(aHeaderTit,{"Cod. Cliente","E1_CLIENTE",PesqPict("SE1","E1_CLIENTE"),TamSX3("E1_CLIENTE")[1],TamSX3("E1_CLIENTE")[2],,"",TamSX3("E1_CLIENTE")[3],"","","","",,'V',,,})
	aAdd(aHeaderTit,{"Nome","E1_NOMCLI",PesqPict("SE1","E1_NOMCLI"),TamSX3("E1_NOMCLI")[1],TamSX3("E1_NOMCLI")[2],,"",TamSX3("E1_NOMCLI")[3],"","","","",,'V',,,})
	aAdd(aHeaderTit,{"Valor","E1_VALOR",PesqPict("SE1","E1_VALOR"),TamSX3("E1_VALOR")[1],TamSX3("E1_VALOR")[2],,"",TamSX3("E1_VALOR")[3],"","","","",,'V',,,})
	aAdd(aHeaderTit,{"Saldo","E1_SALDO",PesqPict("SE1","E1_SALDO"),TamSX3("E1_SALDO")[1],TamSX3("E1_SALDO")[2],,"",TamSX3("E1_SALDO")[3],"","","","",,'V',,,})
    
Return()

//--------------------------------------------------------------
/*/{Protheus.doc} fHeadTerRet
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 04/11/2018 /*/
//--------------------------------------------------------------
Static Function fHeadTerRet()

	aHeadTerRet := {}
	
	aAdd(aHeadTerRet,{"       ","Status    ","@BMP                      ",2                      ,0                      ,,"","C"                    ,"","","","",,'V',,,})
	aAdd(aHeadTerRet,{"Codigo","ZK0_COD",PesqPict("ZK0","ZK0_COD"),TamSX3("ZK0_COD")[1],TamSX3("ZK0_COD")[2],,"",TamSX3("ZK0_COD")[3],"","","","",,'V',,,})
	aAdd(aHeadTerRet,{"Cod. Produto","ZK0_PROD",PesqPict("ZK0","ZK0_PROD"),TamSX3("ZK0_PROD")[1],TamSX3("ZK0_PROD")[2],,"",TamSX3("ZK0_PROD")[3],"","","","",,'V',,,})
	aAdd(aHeadTerRet,{"Descrição","ZK0_DESCRI",PesqPict("ZK0","ZK0_DESCRI"),30,TamSX3("ZK0_DESCRI")[2],,"",TamSX3("ZK0_DESCRI")[3],"","","","",,'V',,,})
	aAdd(aHeadTerRet,{"Chamado","ZK0_NUMSAC",PesqPict("ZK0","ZK0_NUMSAC"),TamSX3("ZK0_NUMSAC")[1],TamSX3("ZK0_NUMSAC")[2],,"",TamSX3("ZK0_NUMSAC")[3],"","","","",,'V',,,})
	aAdd(aHeadTerRet,{"Status","ZK0_STATUS",PesqPict("ZK0","ZK0_STATUS"),TamSX3("ZK0_STATUS")[1],TamSX3("ZK0_STATUS")[2],,"",TamSX3("ZK0_STATUS")[3],"","","","",,'V',,,})
	aAdd(aHeadTerRet,{"Dt. Agendamento","ZK0_DTAGEN",PesqPict("ZK0","ZK0_DTAGEN"),TamSX3("ZK0_DTAGEN")[1],TamSX3("ZK0_DTAGEN")[2],,"",TamSX3("ZK0_DTAGEN")[3],"","","","",,'V',,,})
	aAdd(aHeadTerRet,{"Tipo Retirada"  ,"ZK0_OPCTP",PesqPict("ZK0","ZK0_OPCTP"),TamSX3("ZK0_OPCTP")[1],TamSX3("ZK0_OPCTP")[2],,"",TamSX3("ZK0_OPCTP")[3],"C","","","",,'V',,,})
	aAdd(aHeadTerRet,{"Obs SAC"        ,"ZK0_OBSSAC",PesqPict("ZK0","ZK0_OBSSAC"),TamSX3("ZK0_OBSSAC")[1],TamSX3("ZK0_OBSSAC")[2],,"",TamSX3("ZK0_OBSSAC")[3],"C","","","",,'V',,,})
	aAdd(aHeadTerRet,{"Defeito"        ,"ZK0_DEFEIT",PesqPict("ZK0","ZK0_DEFEIT"),TamSX3("ZK0_DEFEIT")[1],TamSX3("ZK0_DEFEIT")[2],,"",TamSX3("ZK0_DEFEIT")[3],"C","","","",,'V',,,})
	aAdd(aHeadTerRet,{"Autorizacao"    ,"ZK0_AUTPOR",PesqPict("ZK0","ZK0_AUTPOR"),TamSX3("ZK0_AUTPOR")[1],TamSX3("ZK0_AUTPOR")[2],,"",TamSX3("ZK0_AUTPOR")[3],"C","","","",,'V',,,})
	
Return()

//--------------------------------------------------------------
/*/{Protheus.doc} CriaParam
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 31/10/2018 /*/
//--------------------------------------------------------------
Static Function CriaParam()
	
	Local cParam := space(100)
	
	//'Cliente De
	@  02,  000 Say  oSay Prompt 'Cliente de:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oParam Pixel
	@  01,  045 MSGet oMV_PAR01	Var MV_PAR01		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	F3 "SA1" Of oParam 
	@  01,  096 MSGet oMV_PAR02 Var MV_PAR02		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  10, 05 When .T. Of oParam
	
	//'Cliente Ate
	@  12,  000 Say  oSay Prompt 'Cliente Ate:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oParam Pixel
	@  11,  045 MSGet oMV_PAR03	Var MV_PAR03		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	F3 "SA1"	Of oParam 
	@  11,  096 MSGet oMV_PAR04	Var MV_PAR04		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  10, 05 When .T.	Of oParam
	
	//Pedido de
	@  02,  118 Say  oSay Prompt 'Chamado de:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oParam Pixel
	@  01,  157 MSGet oMV_PAR05	Var MV_PAR05		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  35, 05 When .T.	F3 "SUC01" Of oParam
	
	//Pedido Ate
	@  12,  118 Say  oSay Prompt 'Chamado Ate:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oParam Pixel
	@  11,  157 MSGet oMV_PAR06	Var MV_PAR06		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  35, 05 When .T.	F3 "SUC01" Of oParam 
   
	//'Nome Cliente
	@  24,  00 Say  oSay Prompt 'Nome Cliente:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oParam Pixel
	@  23,  45 MSGet oCliente	Var cNomeCli		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  100, 05 When .T. Of oParam PICTURE "@!" VALID {|| processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)} 
	
	//'Codigo ou descrição => Produto
    @  23,  155 MSCOMBOBOX oOpcoes VAR nOpcoes      ITEMS {"Codigo","CPF/CNPJ"} SIZE 044, 010 OF oParam COLORS 0, 16777215 PIXEL
  	@  23,  198 MSGet oCliente	Var cPesqCli		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  70, 05 When .T. Of oParam PICTURE "@!" VALID {|| processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)} 
	
	//'Data Abertura De
	@  02,  200 Say  oSay Prompt 'Emissão de:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oParam Pixel
	@  01,  240 MSGet oDataDe	Var MV_PAR07		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oParam
	
	//'Data Abertura Ate
	@  12,  200 Say  oSay Prompt 'Emissão Ate:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oParam Pixel
	@  11,  240 MSGet oDataAte	Var MV_PAR08		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oParam 

Return



//Cria Perguntes
Static Function xPutSx1(cPerg)
	
	cPerg      := PADR(cPerg,10)
	aRegs       := {}
	
	DbSelectArea("SX1")
	DbSetOrder(1)
	
	If !Dbseek(cPerg)

		Aadd(aRegs,{cPerg,"01","Cliente de  ?" 			,"","C","mv_ch1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
		Aadd(aRegs,{cPerg,"02","Loja Cliente de  ?"		,"","C","mv_ch2","C",02,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"03","Cliente até  ?" 		,"","C","mv_ch3","C",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
		Aadd(aRegs,{cPerg,"04","Loja Cliente até  ?"	,"","C","mv_ch4","C",02,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"05","Chamado de  ?" 			,"","C","mv_ch5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SUC01",""})
		Aadd(aRegs,{cPerg,"06","Chamado até  ?"			,"","C","mv_ch6","C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SUC01",""})
		Aadd(aRegs,{cPerg,"07","Data de ?"				,"","D","mv_ch3","D",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"08","Data até ?"				,"","D","mv_ch4","D",08,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	Endif

	For i:=1 to LEN(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= LEN(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Else
					exit
				Endif
			Next
			MsUnlock()
		Endif
	Next

Return

//--------------------------------------------------------------
/*/{Protheus.doc} CriaBotoes
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 31/10/2018 /*/
//--------------------------------------------------------------    
Static Function CriaBotoes()

    Local aTamBot := Array(4)

    aFill(aTamBot,0)
	//Adpta o tamanho dos botoes na tela
	StaticCall(AGEND,DefTamBot,@aTamBot)
	aTamBot[3] := (oBotoes:nClientWidth)
	aTamBot[4] := (oBotoes:nClientHeight)
    
	StaticCall(AGEND,DefTamBot,@aTamBot,000,000,-100,nAltBot,.T.,oBotoes)
	oPesquisa := tButton():New(aTamBot[1],aTamBot[2],"&Pesquisar",oBotoes,{|| processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .F.)},aTamBot[3],aTamBot[4],,,,.T.,,,,{|| oPesquisa:lActive := lAcesso })
	       
    StaticCall(AGEND,DefTamBot,@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    oConfNCC := tButton():New(aTamBot[1],aTamBot[2],"&Aprovar NCC",oBotoes,{|| fConfNCC() },aTamBot[3],aTamBot[4],,,,.T.,,,,{|| oConfNCC:lActive := lAcesso })
    
	StaticCall(AGEND,DefTamBot,@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    oReprova := tButton():New(aTamBot[1],aTamBot[2],"&Reprovar NCC",oBotoes,{|| fReprova() },aTamBot[3],aTamBot[4],,,,.T.,,,,{|| oReprova:lActive := lAcesso })
    
   	StaticCall(AGEND,DefTamBot,@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    oConheci := tButton():New(aTamBot[1],aTamBot[2],"&Conhecimento",oBotoes,{|| fConhece(oGridNCC:acols[oGridNCC:nat][nPCliente],oGridNCC:acols[oGridNCC:nat][nPLojaCli]) },aTamBot[3],aTamBot[4],,,,.T.,,,,{|| oConheci:lActive := lAcesso })

    StaticCall(AGEND,DefTamBot,@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    oSair := tButton():New(aTamBot[1],aTamBot[2],"&Sair",oBotoes,{|| oTela:end() },aTamBot[3],aTamBot[4],,,,.T.,,,,{|| oSair:lActive := lAcesso })

    oLayer:Refresh()

Return

//Recebe Cliente e Loja e retorna o banco de conhecimento.
Static Function fConhece(_cCli, _cLoja)
    
    Local aArea := getArea()
    Local cAlias := "SA1"
    Local lExcelConnect := .F.
	Local aRecACB := {}
	Local nOper := 1
	Local nOpc := 4
	
	Private aRotina := {}
	
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	
	SA1->(dbSeek(xFilial()+_cCli+_cLoja))
    
    for nx := 1 to 4
		Aadd(aRotina,{"Conhecimento","MsDocument('SA1',SA1->(RecNo()), 4)", 0, 4,0,NIL})
	next nx
		
	MsDocument( cAlias, SA1->(RecNo()), nOpc, , nOper, aRecACB , lExcelConnect)	
                
	restArea(aArea)
	
Return
//--------------------------------------------------------------
/*/{Protheus.doc} fCarr
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
//Carrega os dados referentes aos pedidos de venda, de acordo com os parametros informados
Static Function fCarr()
    
	Local cAlias := getNextAlias()
    Local oStatus := nil

    dbSelectArea("ZK0")
	ZK0->(dbSetorder(5))
    
    aNCC := {}
    
    cQuery := "SELECT E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_EMISSAO ,E1_XCONFSC, E1_01SAC, E1_USRNAME, A1_NOME" +CRLF
    cQuery += "FROM SE1010 SE1 (NOLOCK) " +CRLF
    cQuery += "INNER JOIN SUC010 SUC (NOLOCK) ON SE1.E1_01SAC = SUC.UC_CODIGO" +CRLF
    cQuery += "AND SUC.D_E_L_E_T_ = ' ' " +CRLF
    cQuery += "INNER JOIN SA1010 SA1 (NOLOCK) ON SE1.E1_CLIENTE = SA1.A1_COD AND SE1.E1_LOJA = SA1.A1_LOJA" +CRLF
	
    if !empty(alltrim(cNomeCli))
		cQuery += " AND A1_NOME LIKE ('"+ alltrim(cNomeCli) +"%')"+CRLF
	endif
    
 	if oOpcoes:nat == 1
		if !empty(alltrim(cPesqCli))
			cQuery += " AND A1_COD = '"+ alltrim(cPesqCli) +"'"	+CRLF
		endif
	else
		if !empty(alltrim(cPesqCli))
			cQuery += " AND A1_CGC = '"+ alltrim(cPesqCli) +"'"	+CRLF
		endif
	endif
    
    cQuery += " AND SA1.D_E_L_E_T_ = ' ' " +CRLF
    cQuery += " WHERE E1_CLIENTE BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR03 + "' " +CRLF
	cQuery += " AND E1_XCONFSC = 'N' " +CRLF
    cQuery += " AND E1_LOJA BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR04 + "' " +CRLF
	cQuery += " AND E1_EMISSAO BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' " +CRLF
	cQuery += " AND E1_01SAC BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " +CRLF
    cQuery += " AND SE1.D_E_L_E_T_ = ' ' " +CRLF
	cQuery += " ORDER BY 1,2,3" +CRLF

	//MemoWrite( "C:\spool\khsac003.txt", cQuery )
	
	PLSQuery(cQuery, cAlias)
	
	nRegistros := 0
	nCount := 0
	
	(cAlias)->(dbEval({|| nRegistros++}))
    (cAlias)->(dbgotop())
    
    procregua(nRegistros)
    
    while (cAlias)->(!eof())
		
		nCount++
		incproc("Atualizando Dados... " + cValtoChar(nCount) + " de " + cValtoChar(nRegistros))
		
		//Verifica se existe termo em aberto para o cliente com o status 1 - Pendente.
		ZK0->(dbSetorder(4))
		if ZK0->(dbSeek(xFilial("ZK0")+(cAlias)->E1_CLIENTE+(cAlias)->E1_LOJA))
			while ZK0->(!eof()) .AND. ZK0_CLI == (cAlias)->E1_CLIENTE .AND. ZK0_LJCLI == (cAlias)->E1_LOJA
				if ZK0->ZK0_STATUS == '1'
					cTermo := "SIM"
				else
					cTermo := "NÃO"
				endif
				ZK0->(dbSkip())
			End	
		else
			cTermo := "NÃO"
		endif

		aAdd(aNCC,{ "LBNO",;	
						(cAlias)->(E1_NUM),;
						(cAlias)->(E1_PREFIXO),;
						(cAlias)->(E1_PARCELA),;
						(cAlias)->(E1_TIPO),;
                        (cAlias)->(E1_EMISSAO),;
                        (cAlias)->(E1_CLIENTE),;
                        (cAlias)->(E1_LOJA),;
						(cAlias)->(A1_NOME),;
						(cAlias)->(E1_01SAC),;
						cTermo,;
						(cAlias)->E1_USRNAME,;						
						"",;
						.F.})
	(cAlias)->(dbskip())		
	end
	
	(cAlias)->(dbCloseArea())
    
    if len(aNCC) <= 0
    	aAdd(aNCC,{"LBNO","","","","",ctod(""),"","","","","","","",.F.})
    else
		aNCC := aSort(aNCC,,,{|x,y| x[nPTitulo] < y[nPTitulo] })
	endif
    
	oGridNCC:SetArray(aNCC) 
	oGridNCC:oBrowse:SetFocus()
	oGridNCC:ForceRefresh()

	fCarrTit(oGridNCC:acols[oGridNCC:nat][nPChamado])
	fCarrTermos(oGridNCC:acols[oGridNCC:nat][nPCliente],oGridNCC:acols[oGridNCC:nat][nPLojaCli])

	SetCab1(oGridNCC:acols[oGridNCC:nat][nPTitulo])
	
	oLayer:Refresh()
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrTit
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 01/11/2018 /*/
//--------------------------------------------------------------
Static Function fCarrTit(_cNumSac)

	Local cAlias := getNextAlias()
    Local cQuery := ""
	Local oStatus := nil

	default _cNumSac := 'X'

	iif(Empty(Alltrim(_cNumSac)),_cNumSac:='X',)

	aTitulos := {}

	cQuery := "SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_NOMCLI, E1_VALOR, E1_SALDO, E1_VENCREA"+ CRLF
	cQuery += "FROM SE1010"+ CRLF
	cQuery += "WHERE E1_01SAC = '"+ _cNumSac +"'"+ CRLF
	cQuery += "AND D_E_L_E_T_ = ' '

	plsQuery(cQuery,cAlias)
	
	While (cAlias)->(!eof())

		if (cAlias)->E1_SALDO == (cAlias)->E1_VALOR  .and. ddatabase <= (cAlias)->E1_VENCREA//Em ABerto
			oStatus := oSt2
		else
			oStatus := oSt4 //Baixa Parcial

			if ddatabase > (cAlias)->E1_VENCREA .and. (cAlias)->E1_SALDO > 0 //Vencido
				oStatus := oSt3
			endif

		endif  
		
		if (cAlias)->E1_SALDO == 0 //Baixado
			oStatus := oSt1
		endif
								
		aAdd(aTitulos,{ oStatus,;
						(cAlias)->E1_PREFIXO,;
						(cAlias)->E1_NUM,;
						(cAlias)->E1_PARCELA,;
						(cAlias)->E1_TIPO,;
						(cAlias)->E1_CLIENTE,;
						(cAlias)->E1_NOMCLI,;
						(cAlias)->E1_VALOR,;
						(cAlias)->E1_SALDO,;
						.F.})

	(cAlias)->(DbSkip())
	EndDo
    
	(cAlias)->(dbCloseArea())

    if len(aTitulos) <= 0
    	aAdd(aTitulos,{"","","","","","","",0,0,.F.})
    endif 
    
	oGridTit:SetArray(aTitulos)  
	oGridTit:ForceRefresh()
	oLayer:Refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrTermos
Description //Carrega os termos/retira do cliente posicionado
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 04/11/2018 /*/
//--------------------------------------------------------------
Static Function fCarrTermos(_Cliente,_Loja)

	Local oStatus    := nil
	Local cTipoOper  := ""
	Local cAutPor    := ""
	Local cDescriTer := ""
	
	cQuery := ""
	cAlias := getNextAlias()

	aTermos := {}

	cQuery := "SELECT * "+ ENTER
	cQuery += "FROM ZK0010"+ ENTER
	cQuery += "WHERE ZK0_CLI = '"+ _Cliente+"'"+ ENTER
	cQuery += "AND ZK0_LJCLI = '"+ _Loja +"'"+ ENTER
	cQuery += "AND D_E_L_E_T_ = ' '"

	plsQuery(cQuery,cAlias)
	
	nRegistros := 0

	(cAlias)->(dbEval({|| nRegistros++}))
    (cAlias)->(dbgotop())

	SetCab0(nRegistros)

	While (cAlias)->(!eof())
	
		Do Case
		   Case (cAlias)->ZK0_STATUS == '1'
			  cDescriTer := "Pendente"
			  oStatus := oSt2
		   Case (cAlias)->ZK0_STATUS == '2'
			  cDescriTer := "Carga Montada"
			  oStatus := oSt4
		   Case (cAlias)->ZK0_STATUS == '3'
			  cDescriTer := "Finalizado"
			  oStatus := oSt1
		   Otherwise
			  cDescriTer := "Não Entregue"
			  oStatus := oSt3
		EndCase
		
		Do case
			Case (cAlias)->ZK0_OPCTP == '1'
				cTipoOper := "Troca"
			Case (cAlias)->ZK0_OPCTP == '2'
				cTipoOper := "Cancelamento"
			Case (cAlias)->ZK0_OPCTP == '3'
				cTipoOper := "Conserto"
			Case (cAlias)->ZK0_OPCTP == '4'
				cTipoOper := "TJ/PROCON"
			Case (cAlias)->ZK0_OPCTP == '5'
				cTipoOper := "Emprestimo"
		EndCase
		
		Do Case
			Case AllTrim((cAlias)->ZK0_AUTPOR) == '1'
				 cAutPor := "SAC KOMFORT"
			Case AllTrim((cAlias)->ZK0_AUTPOR) == '2'
				 cAutPor := "GRALHA AZUL"
			Case AllTrim((cAlias)->ZK0_AUTPOR) == '3'
				 cAutPor := "ENELE"
			Case Alltrim((cAlias)->ZK0_AUTPOR) == '4'
				 cAutPor := "LINO FORTE"
			Case AllTrim((cAlias)->ZK0_AUTPOR) == '5'
				 cAutPor := "DIRETORIA"
			Otherwise
				 cAutPor := (cAlias)->ZK0_AUTPOR
		EndCase		 
				
		aAdd(aTermos,{	 oStatus,;
						(cAlias)->ZK0_COD,;
						(cAlias)->ZK0_PROD,;
						(cAlias)->ZK0_DESCRI,;
						(cAlias)->ZK0_NUMSAC,;
						 cDescriTer,;
						(cAlias)->ZK0_DTAGEN,;
						 cTipoOper,;
						(cALias)->ZK0_OBSSAC,;
						(cAlias)->ZK0_DEFEIT,;
						 cAutPor,;
						.F. })
	(cAlias)->(DbSkip())
	EndDo
    
	(cAlias)->(dbCloseArea())

    if len(aTermos) <= 0
    	aAdd(aTermos,{"","","","","","",ctod(""),"","","","",.F.})
		SetCab0(0)
    endif 
    
	oGridTerRet:SetArray(aTermos)  
	oGridTerRet:ForceRefresh()
	oLayer:Refresh()

Return()

//--------------------------------------------------------------
/*/{Protheus.doc} fMarcAll
Description //Marcar/Desmarcar todos itens da tela.
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 31/10/2018 /*/
//--------------------------------------------------------------
Static Function fMarcAll(nColuna)

	Local nx := 0
	
	if nOrder++ == 0
		if nColuna == nPFlag
			for nx := 1 To Len(oGridNCC:aCols)
				if oGridNCC:aCols[nx,nPFlag] == "LBNO"
					oGridNCC:aCols[nx,nPFlag] := "LBTIK"
				else
					oGridNCC:aCols[nx,nPFlag] := "LBNO"
				endif
			next nx
		endif
	else
		nOrder := 0
	endif

	oGridNCC:Refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fMarc
Description //Marca o checkbox da linha posicionada. 
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 31/10/2018 /*/
//--------------------------------------------------------------
Static Function fMarc(nLin) 

	if (oGridNCC:aCols[nLin,nPFlag] == "LBNO")
		oGridNCC:aCols[nLin,nPFlag] := "LBTIK"
	else
		oGridNCC:aCols[nLin,nPFlag] := "LBNO"
	endif
	
	oGridNCC:Refresh()
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} SetCab1
Description //seta o pedido posicionado no cabeçalho
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/09/2018
/*/
//--------------------------------------------------------------
Static Function SetCab1(cParam1)
	
	if !(empty(cParam1))
		cCab :="Titulo: " + Alltrim(cParam1)
		oLayer:setWinTitle('Col02_01' ,'C2_Win02_01',cCab ,"L02" )
	endif

Return


//--------------------------------------------------------------
/*/{Protheus.doc} SetCab0
Description //seta o cabeçalho dos termos retira com a quantidade
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/09/2018
/*/
//--------------------------------------------------------------
Static Function SetCab0(cParam1)
	
	if cParam1 >= 0
		cCab :="Termos: " + Alltrim(cValtoChar(cParam1)) + "  - Legenda F4"
		oLayer:setWinTitle('Col03_01' ,'C3_Win03_01',cCab ,"L03" )
	endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fConfNCC
Description //Efetua a gravação dos campos responsaveis pela conferencia do pedido
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 05/11/2018 /*/
//--------------------------------------------------------------
Static Function fConfNCC()

	Local lReproc := .F.

	dbSelectArea("SE1")
	SE1->(dbSetorder(1))// E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_)

	For nx := 1 to Len(oGridNCC:aCols)

		if oGridNCC:aCols[nx][nPFlag] == "LBTIK"
			
			if SE1->(Dbseek(xFilial("SE1")+oGridNCC:aCols[nx][nPPrefixo]+oGridNCC:aCols[nx][nPTitulo]+oGridNCC:aCols[nx][nPParcela]+oGridNCC:aCols[nx][nPTipo]))
				RecLock("SE1",.F.)
                    SE1->E1_XCONFSC := "S"
					SE1->E1_XCONFUS := LogUserName()
					SE1->E1_XCONFDT := date()
				SE1->(MsUnlock())
			endif

			lReproc := .T.

		endif
		
	Next nx
	
	if lReproc
		processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .f.)
	else
		msgAlert("Não existe Itens selecionados para Conferência.")
	endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} lgTermoRet
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 06/11/2018 /*/
//--------------------------------------------------------------
Static Function lgFinanc()    

    Local aLegenda := {}

    //Monta as legendas (Cor, Legenda)
    aAdd(aLegenda,{"BR_AZUL",    	"Em Aberto"})
    aAdd(aLegenda,{"BR_VERDE",      "Baixado"})
    aAdd(aLegenda,{"BR_VERMELHO",   "Vencido"})
    aAdd(aLegenda,{"BR_LARANJA",  	"Baixa Parcial"})

    //Chama a função que monta a tela de legenda
    BrwLegenda("STATUS TITULOS", "Status Titulos", aLegenda) 
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} lgTermoRet
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 06/11/2018 /*/
//--------------------------------------------------------------
Static Function lgTermoRet()

	Local aLegenda := {}
     
    //Monta as legendas (Cor, Legenda)
    aAdd(aLegenda,{"BR_AZUL",    	"Pendente"})
    aAdd(aLegenda,{"BR_VERDE",      "Finalizado"})
    aAdd(aLegenda,{"BR_VERMELHO",   "Não Entregue"})
    aAdd(aLegenda,{"BR_LARANJA",  	"Carga Montada"})

    //Chama a função que monta a tela de legenda
    BrwLegenda("STATUS TERMOS RETIRA", "Status Termos Retira", aLegenda) 

Return


//--------------------------------------------------------------
/*/{Protheus.doc} NomeDaFuncao
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 06/11/2018 /*/
//--------------------------------------------------------------

Static Function fReprova()                        
	
	Local lReproc := .F.
	Local aArray := {}
    private lMsErroAuto := .F.

	dbSelectArea("SE1")
	SE1->(dbSetorder(1))

	For nx := 1 to Len(oGridNCC:aCols)
	
		lReproc := .F.
        aArray := {}
        lMsErroAuto := .F.

		if oGridNCC:aCols[nx][nPFlag] == "LBTIK"

			if empty(alltrim(oGridNCC:aCols[nx][nPTitulo]))
				msgInfo("A linha selecionada esta vazia.","Atenção")
				Return(processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .F.))			
			endif

            if SE1->(Dbseek(xFilial("SE1")+oGridNCC:aCols[nx][nPPrefixo]+oGridNCC:aCols[nx][nPTitulo]+oGridNCC:aCols[nx][nPParcela]+oGridNCC:aCols[nx][nPTipo]))
                
                if !(SE1->E1_SALDO <> SE1->E1_VALOR)

                    aArray := { { "E1_PREFIXO"  , SE1->E1_PREFIXO   , NIL },;
                                { "E1_NUM"      , SE1->E1_NUM       , NIL },;
                                { "E1_TIPO"     , SE1->E1_TIPO      , NIL },;
                                { "E1_NATUREZ"  , SE1->E1_NATUREZ   , NIL },;
                                { "E1_CLIENTE"  , SE1->E1_CLIENTE   , NIL },;
                                { "E1_LOJA"      ,SE1->E1_LOJA      , NIL },;
                                { "E1_EMISSAO"  , SE1->E1_EMISSAO   , NIL },;
                                { "E1_VENCTO"   , SE1->E1_VENCTO    , NIL },;
                                { "E1_VENCREA"  , SE1->E1_VENCREA   , NIL },;
                                { "CBCOAUTO"    , SE1->E1_PORTADO   , NIL },;
                                { "CAGEAUTO"    , SE1->E1_AGEDEP    , NIL },;
                                { "CCTAAUTO"    , SE1->E1_CONTA     , NIL },;
                                { "E1_VALOR"    , SE1->E1_VALOR     , NIL }}

                    lReproc := .T.

                else
                    msgAlert("O titulo "+ SE1->E1_NUM +" ja foi utilizado, por favor realizar o cancelamento.","ATENÇÃO")
                endif
   
            endif
		endif
		
		if lReproc
			if fTelReprov(oGridNCC:aCols[nx][nPTitulo],oGridNCC:aCols[nx][nPUserName])
				    
				MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

                If lMsErroAuto
                    msgAlert("Não foi Possivel Realizar o cancelamento do titulo "+ SE1->E1_NUM +".","ATENÇÃO")
                    MostraErro()
                Else
                    apMsgAlert("Título "+ SE1->E1_NUM +" Excluido com sucesso!","SUCCESS")
                Endif

			endif
		endif

	Next nx
 	
Return(processa( {|| fCarr() }, "Aguarde...", "Atualizando Dados...", .F.))

//--------------------------------------------------------------
/*/{Protheus.doc} fTelReprov
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 06/11/2018 /*/
//--------------------------------------------------------------
Static Function fTelReprov(_cTitulo,_cUsuario)

	Local oCancelar
	Local oConfirmar
	Local oGetMsg
	Local cGetMsg := Space(500)
	Local lOk := .F.
	Local cAssunto := "Rejeição do Titulo NCC: "+_cTitulo
	Local cMensagem := ""
	Local cPara := U_EmailUsr(alltrim(_cUsuario))

	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Motivo da Rejeição" FROM 000, 000  TO 400, 500 COLORS 0, 16777215 PIXEL

    @ 003, 002 GET oGetMsg VAR cGetMsg OF oDlg MULTILINE SIZE 244, 175 COLORS 0, 16777215 HSCROLL NOBORDER PIXEL
    @ 180, 005 BUTTON oCancelar PROMPT "Cancelar" SIZE 119, 015 OF oDlg ACTION {|| oDlg:end() } PIXEL
    @ 180, 126 BUTTON oConfirmar PROMPT "Confirmar" SIZE 120, 015 OF oDlg ACTION {|| lOk:=.T., oDlg:end() } PIXEL

  	ACTIVATE MSDIALOG oDlg CENTERED

	if lOk
		cMensagem := cGetMsg
		processa( {|| U_sendMail( cPara, cAssunto, cMensagem ) }, "Aguarde...", "Enviando email de Rejeição...", .F.)
	endif

Return lOk

