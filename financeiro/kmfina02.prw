#include 'Rwmake.ch'
#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'ParmType.ch'
#INCLUDE "TbiConn.ch"
#include "AP5MAIL.CH"
#include "MSGRAPHI.CH"
#include "report.ch"

#DEFINE CRLF CHR(13)+CHR(10)
#define VK_CTRL_F        6

Static cHK				:= "&"
Static nAltBot			:= 010
Static nDistPad			:= 001

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �KMFINA02    �Autor  �Rafael Cruz       	   � Data �12/11/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Tela de Controle de Concilia��o de Cart�o   		                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/
User Function KMFINA02(lSchedule)
	Local aArea			:= GetArea()
	Local cArqFTP		:= ""

	Private cPerg		:= "KMFINA02"
	Private oArea		:= FWLayer():New()
	Private nPesq		:= 1

	Private nQtAbert	:= 0
	Private nQtEnvia	:= 0
	Private nQtConci	:= 0
	Private nQtBaixa	:= 0
	Private nQtTotal	:= 0
	Private nAberto		:= 0
	Private nEnviado	:= 0
	Private nBaixado	:= 0
	Private nConcil		:= 0
	Private nTotal		:= 0

	Private cVldDel		:= "AllwaysFalse()"
	Private cVldDelT	:= "AllwaysFalse()"
	Private cVldLOk		:= "AllwaysTrue()"
	Private cVldTOk		:= "AllwaysTrue()"
	Private cFieldOk	:= "AllwaysTrue()"
	Private nStyle		:= GD_UPDATE
	Private aCoord		:= MsAdvSize(.F.)//FWGetDialogSize(oMainWnd)
	Private cCadastro	:= "KMFINA02 | Envio de Remessa p/ Concil"
	Private aTamObj		:= Array(4)
	Private lUsuario	:= ( __cUserID $ SuperGetMv("KH_KMFINA2",.F.,"000631") )

	Private oGetRank
	Private oMeter1
	Private oScroll

	Private oQAberto
	Private oQEnviad
	Private oQConcil
	Private oQBaixad
	Private oQTotal
	Private oAberto
	Private oEnviado
	Private oBaixado
	Private oConcil
	Private oTotal

	Private oSt1 := LoadBitmap(GetResources(),'BR_VERDE')
	Private oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')
	Private oSt3 := LoadBitmap(GetResources(),'BR_AZUL')
	Private oSt4 := LoadBitmap(GetResources(),'BR_VIOLETA')
	Private oSt5 := LoadBitmap(GetResources(),'BR_AMARELO')
	Private oSt6 := LoadBitmap(GetResources(),'BR_PRETO')

	Private aHeadRank	:= {}
	Private aTotCodVend	:= {}
	Private aCposRank	:= {}
	Private aColsRank	:= {}
	Private aAlter		:= {}
	Private aBkpPos		:= {}
	Private aHead		:= {}
	Private aScroll		:= {}
	Private aRecSel 	:= {}
	Private aDados		:= {}
	Private aParBkp	    := {}
	Private aHeadBkp	:= {}
	Private aPerg01 	:= {'1-Sim','2-N�o','3-Ambos'}

	Private aPerg00		:= {{'Loja De?'			,"","F3 SM0","GET",""} 	,;
							{'Loja At�?'		,"","F3 SM0","GET",""} 	,;
							{'Operadora De?'	,"","F3 _L9","GET",""} 	,;
							{'Operadora Ate?'	,"","F3 _L9","GET",""} 	,;
							{'Numero de?'		,"","F3 SE1","GET",""} 	,;
							{'Numero at�?'		,"","F3 SE1","GET",""}	,;
							{'Fornec. de?'		,"","F3 SA2","GET",""}	,;
							{'Loja de?'			,"",""		,"GET",""}	,;
							{'Fornec.at�?'		,"","F3 SA2","GET",""}	,;
							{'Loja at�?'		,"",""		,"GET",""}	,;
							{'Dt.Emiss�o de?'	,"",""		,"GET",""}	,;
							{'Dt.Emiss�o at�?'	,"",""		,"GET",""}	,;
							{'Dt.Venc. de?'		,"",""		,"GET",""}	,;
							{'Dt.Venc. at�?'	,"",""		,"GET",""}	,;
							{'J� Enviado(s)?'	,"",""		,"COMBO",aPerg01},;
							{'J� Baixado(s)?'	,"",""		,"COMBO",aPerg01},;
							{'Conciliado(s)?'   ,"",""		,"COMBO",aPerg01}}

	Private lDrill		:= .F.
	Private lRet		:= .F.
	Private cAlias		:= GetNextAlias()
	Private lExc		:= __cUserId $ "000631|000638"
	Private lChbk		:= .F.
	Private	aAllUser	:= FWSFAllUsers()
	Private aCposUsu	:= {"PERMISS"}
	Private aCampos		:= {}
	Private cArqTrb	  	:= CriaTrab(,.F.)
	Private aEmpresas 	:= {}
	Private aArqLogs  	:= {}
	Private aLogs 	  	:= {}
	Private cEmpOfic  	:= cEmpAnt
	Private cFilOfic  	:= cFilAnt

	DEFAULT lSchedule 	:= .F.

	fValidPerg()

	If SX5->(DbSeek(xFilial("SX5") + "_Q" +__cUserID))
		if	Alltrim(SX5->X5_DESCRI)=="1"
			lChbk := .T.
		else
			lChbk := .F.
		endIf
	EndIf

	If ! Pergunte(cPerg,.T.)
		Return
	Endif

	For i:= 1 to Len(aPerg00)
		AADD(aParBkp,{aPerg00[i][1],&("MV_PAR"+cValtoChar(strzero(i,2)))})
	Next

	If !(lSchedule)

		DEFINE FONT oFont10    NAME "Arial"	SIZE 0, -10 BOLD
		DEFINE FONT oFont11    NAME "Arial" SIZE 0, -11 BOLD		//	"Courier New"	SIZE 0,  15 BOLD
		DEFINE FONT oFont11a   NAME "Arial"	SIZE 0, -11 BOLD
		DEFINE FONT oFont13    NAME "Arial"	SIZE 0, -13 ITALIC
		DEFINE FONT oFont10i   NAME "Arial"	SIZE 0, -10 ITALIC

		oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[6],aCoord[5],OemToAnsi(cCadastro),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
		oArea:Init(oTela,.F.)

		oArea:AddLine("L01",30,.T.)
		oArea:AddLine("L02",70,.T.)

		oArea:AddCollumn("L01PARA"  , 50,.F.,"L01")
		oArea:AddCollumn("L01TOTA"  , 40,.F.,"L01")
		oArea:AddCollumn("L01BOTO"  , 10,.F.,"L01")
		oArea:AddCollumn("L01FRET"  ,100,.F.,"L02")

		oArea:AddWindow("L01PARA" ,"L01PARA"  ,"Par�metros"							, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
		oArea:AddWindow("L01TOTA" ,"L01TOTA"  ,"Totais"								, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
		oArea:AddWindow("L01BOTO" ,"L01BOTO"  ,"Fun��es"							, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
		oArea:AddWindow("L01FRET" ,"L01FRET"  ,"T�tulos de Cart�es CC e CD"			, 100,.F.,.F.,/*bAction*/,"L02",/*bGotFocus*/)

		oPainPara  := oArea:GetWinPanel("L01PARA"  ,"L01PARA"  ,"L01")
		oPainTota  := oArea:GetWinPanel("L01TOTA"  ,"L01TOTA"  ,"L01")
		oPainBoto  := oArea:GetWinPanel("L01BOTO"  ,"L01BOTO"  ,"L01")
		oPainRank  := oArea:GetWinPanel("L01FRET"  ,"L01FRET"  ,"L02")

		aCoordTota	:= FWGetDialogSize(oPainTota)

		SetKey(VK_F1,{||fHELP("KMFINA02")})
		SetKey(VK_F2,{||fLeg()})
		SetKey(VK_CTRL_F,{||fLocaliz(.F.)})

		aFill(aTamObj,0)
		DefTamObj(@aTamObj)
		aTamObj[3] := (oPainBoto:nClientWidth)
		aTamObj[4] := (oPainBoto:nClientHeight)

		DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBoto)
		oBotGera := tButton():New(aTamObj[1],aTamObj[2],"&Gerar Dados",oPainBoto,{|| LJMsgRun("Coletando os dados...","Aguarde...",{||fGerDado()})},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

		DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
		oBotPesq := tButton():New(aTamObj[1],aTamObj[2],"&Pesquisar",oPainBoto,{|| fLocaliz(.F.) },aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotPesq:lActive := lRet*/ })

		DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
		oBotImpr := tButton():New(aTamObj[1],aTamObj[2],"&Imprimir",oPainBoto,{|| MsAguarde({|| Alert("Op��o n�o dispon�vel")},'Imprimindo Dados','Aguarde, Imprimindo os Dados')},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotImpr:lActive := lRet*/})

		DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
		oBotExce := tButton():New(aTamObj[1],aTamObj[2],"&Exportar",oPainBoto,{|| Processa( {|| fGeraTXT()}, "Aguarde...", "Extraindo Dados...",.F.)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotImpr:lActive := lExc */})

		DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
		//oBotConc := tButton():New(aTamObj[1],aTamObj[2],"&Conciliar",oPainBoto,{|| Processa( {|| FRecTit()}, "Aguarde...", "Recebendo Dados...",.F.)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotImpr:lActive := lExc*/ })
		oBotConc := tButton():New(aTamObj[1],aTamObj[2],"&Conciliar",oPainBoto,{|| Processa( {|| U_KMFIN02A()}, "Aguarde...", "Recebendo Dados...",.F.)},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotImpr:lActive := lExc*/ })
		//A rotina esta no fonte KMFIN02A

		DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
		oBotCanc := tButton():New(aTamObj[1],aTamObj[2],"&Fechar",oPainBoto,{|| oTela:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

		oScroll2 		:= TScrollBox():New(oPainPara,aCoord[1], aCoord[2], aCoord[3], aCoord[4],.T.,.T.,.T.)
		oScroll2:Align 	:= CONTROL_ALIGN_ALLCLIENT

		@  05, 001 Say  oSay Prompt 'Filial de?'			FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
		@  15, 001 Say  oSay Prompt 'Operadora de?'			FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
		@  25, 001 Say  oSay Prompt 'T�tulo de'				FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
		@  35, 001 Say  oSay Prompt 'Cliente de'			FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
		@  45, 001 Say  oSay Prompt 'Loja de      '			FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
		@  55, 001 Say  oSay Prompt 'Dt.Emiss�o de?'		FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
		@  65, 001 Say  oSay Prompt 'Dt.Vencto. de?'		FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
		@  75, 001 Say  oSay Prompt 'J� Enviado(s)?'		FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
		@  85, 001 Say  oSay Prompt 'Conciliado(s)?'		FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel

		@  05, 140 Say  oSay Prompt 'Filial at�?'			FONT oFont11a COLOR CLR_BLUE Size  70, 08 Of oScroll2 Pixel
		@  15, 140 Say  oSay Prompt 'Operadora at�?'		FONT oFont11a COLOR CLR_BLUE Size  70, 08 Of oScroll2 Pixel
		@  25, 140 Say  oSay Prompt 'T�tulo at�?'			FONT oFont11a COLOR CLR_BLUE Size  70, 08 Of oScroll2 Pixel
		@  35, 140 Say  oSay Prompt 'Cliente at�?'			FONT oFont11a COLOR CLR_BLUE Size  70, 08 Of oScroll2 Pixel
		@  45, 140 Say  oSay Prompt 'Loja at�?'				FONT oFont11a COLOR CLR_BLUE Size  70, 08 Of oScroll2 Pixel
		@  55, 140 Say  oSay Prompt 'Dt.Emiss�o at�?'		FONT oFont11a COLOR CLR_BLUE Size  70, 08 Of oScroll2 Pixel
		@  65, 140 Say  oSay Prompt 'Dt.Vencto. at�?'		FONT oFont11a COLOR CLR_BLUE Size  70, 08 Of oScroll2 Pixel
		@  75, 140 Say  oSay Prompt 'J� Baixado(s)?'		FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel

		@  04,  55 MSGet oMV_PAR01	Var MV_PAR01 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SM0" Of oScroll2	//Filial De
		@  14,  55 MSGet oMV_PAR03	Var MV_PAR03 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "_L9" Of oScroll2	//Operadora De
		@  24,  55 MSGet oMV_PAR05	Var MV_PAR05 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SE1" Of oScroll2	//T�tulo De
		@  34,  55 MSGet oMV_PAR07	Var MV_PAR07 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SA1" Of oScroll2	//Cliente De
		@  44,  55 MSGet oMV_PAR08	Var MV_PAR08 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SA1" Of oScroll2    //Cliente Ate
		@  54,  55 MSGet oMV_PAR11	Var MV_PAR11 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.			 Of oScroll2	//Dt. Emissao De
		@  64,  55 MSGet oMV_PAR13	Var MV_PAR13 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.			 Of oScroll2	//Dt. Venc. De
		TComboBox():New( 74, 55, {|u|if(PCount()>0,MV_PAR15:= val(u),MV_PAR15)} ,aPerg01, 65, 05, oScroll2, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)
		TComboBox():New( 84, 55, {|u|if(PCount()>0,MV_PAR17:= val(u),MV_PAR17)} ,aPerg01, 65, 05, oScroll2, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)

		@  04, 195 MSGet oMV_PAR02	Var MV_PAR02 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SM0" Of oScroll2	//Filial Ate
		@  14, 195 MSGet oMV_PAR04	Var MV_PAR04 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "_L9" Of oScroll2	//Operadora Ate
		@  24, 195 MSGet oMV_PAR06	Var MV_PAR06 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.	F3 "SE1" Of oScroll2	//Titulo Ate
		@  34, 195 MSGet oMV_PAR09	Var MV_PAR09 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.          Of oScroll2	//Loja De
		@  44, 195 MSGet oMV_PAR10	Var MV_PAR10 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.			 Of oScroll2	//Loja Ate
		@  54, 195 MSGet oMV_PAR12	Var MV_PAR12 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.			 Of oScroll2	//Dt. Emissao Ate
		@  64, 195 MSGet oMV_PAR14	Var MV_PAR14 		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  65, 05 When .T.			 Of oScroll2	//Dt. Venc. Ate
		TComboBox():New( 74, 195, {|u|if(PCount()>0,MV_PAR16:= val(u),MV_PAR16)} ,aPerg01, 65, 05, oScroll2, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)

		@  04, 265 Say  oSay Prompt '[F1] Help'			FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel
		@  14, 265 Say  oSay Prompt '[F2] Legendas'		FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oScroll2 Pixel

		oBotBack := tButton():New(035,265,"Charge &Back",oScroll2,{|| MsAguarde( {|| Alert("Op��o n�o dispon�vel")}, 'Charge Back', 'Aguarde. Consultando registro(s)')},50,10,,,,.T.,,,,{|| lChbk})

		If lUsuario
			oBotUsua := tButton():New(046,265,"Cadastro &Usu�rio",oScroll2,{|| MsAguarde({||fCadUsu()},'Cadastro de Usu�rios','Aguarde, Cadastro de Usu�rios')},50,10,,,,.T.,,,,{|| lUsuario })
		EndIf

		@  005, 001 Say  oSay Prompt 'Qtd. Em Aberto'	FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oPainTota Pixel
		@  015, 001 Say  oSay Prompt 'Qtd. Enviado'		FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oPainTota Pixel
		@  025, 001 Say  oSay Prompt 'Qtd. Conciliado'	FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oPainTota Pixel
		@  035, 001 Say  oSay Prompt 'Qtd. Baixado'		FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oPainTota Pixel
		@  045, 001 Say  oSay Prompt 'Qtd. Total'		FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oPainTota Pixel

		@  004, 055 MSGet oQAberto 	Var nQtAbert 		FONT oFont11 COLOR CLR_BLUE	 Pixel SIZE  40, 05 When .F. Picture "@E@R 999,999"	Of oPainTota
		@  014, 055 MSGet oQEnviad 	Var nQtEnvia 		FONT oFont11 COLOR CLR_BLUE	 Pixel SIZE  40, 05 When .F. Picture "@E@R 999,999"	Of oPainTota
		@  024, 055 MSGet oQConcil 	Var nQtConci		FONT oFont11 COLOR CLR_BLUE	 Pixel SIZE  40, 05 When .F. Picture "@E@R 999,999"	Of oPainTota
		@  034, 055 MSGet oQBaixad 	Var nQtBaixa		FONT oFont11 COLOR CLR_BLUE	 Pixel SIZE  40, 05 When .F. Picture "@E@R 999,999"	Of oPainTota
		@  044, 055 MSGet oQTotal 	Var nQtTotal		FONT oFont11 COLOR CLR_BLUE	 Pixel SIZE  40, 05 When .F. Picture "@E@R 999,999"	Of oPainTota

		@  005, 120 Say  oSay Prompt 'Vlr.Em Aberto..R$' 		FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oPainTota Pixel
		@  015, 120 Say  oSay Prompt 'Vlr.Enviado.....R$' 		FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oPainTota Pixel
		@  025, 120 Say  oSay Prompt 'Vlr.Conciliado...R$' 		FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oPainTota Pixel
		@  035, 120 Say  oSay Prompt 'Vlr.Baixado........R$'	FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oPainTota Pixel
		@  045, 120 Say  oSay Prompt 'Vlr.Total.............R$'	FONT oFont11a COLOR CLR_BLUE Size  50, 08 Of oPainTota Pixel

		@  004, 175 MSGet oAberto 	Var nAberto 		FONT oFont11 COLOR CLR_BLUE	 Pixel SIZE  60, 05 When .F. Picture "@E 999,999,999.99" Of oPainTota
		@  014, 175 MSGet oEnviado 	Var nEnviado 		FONT oFont11 COLOR CLR_BLUE	 Pixel SIZE  60, 05 When .F. Picture "@E 999,999,999.99" Of oPainTota
		@  024, 175 MSGet oConcil 	Var nConcil			FONT oFont11 COLOR CLR_BLUE	 Pixel SIZE  60, 05 When .F. Picture "@E 999,999,999.99" Of oPainTota
		@  034, 175 MSGet oBaixado 	Var nBaixado		FONT oFont11 COLOR CLR_BLUE	 Pixel SIZE  60, 05 When .F. Picture "@E 999,999,999.99" Of oPainTota
		@  044, 175 MSGet oTotal 	Var nTotal			FONT oFont11 COLOR CLR_BLUE	 Pixel SIZE  60, 05 When .F. Picture "@E 999,999,999.99" Of oPainTota

		fMontCab()

		oGetRank := MsNewGetDados():New(aCoord[1],aCoord[2],aCoord[6],aCoord[5],      ,""      ,""     ,""      ,aAlter,0,9999,"","" ,"",oPainRank,aHeadRank,aDados,/*{|| DV05C38E()}*//*uChange*/)
		oGetRank:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

		oGetRank:oBrowse:brClicked 	:= {|| LJMsgRun("Classificando...","Aguarde...",{|| fOrdCol(oGetRank:oBrowse:ColPos) } ) }
		oGetRank:oBrowse:bLDblClick := {|| fGerCrt(aDados[oGetRank:nAt,103]) }
		oTela:Activate(,,,.T.,/*valid*/,,{|| processa( {|| fGerDado() }, "Aguarde...", "Atualizando Dados...", .f.)})

		RestArea(aArea)

	Else
	
		fMontCab()

		fGerDado(lSchedule)

		cArqFTP	:= fGeraTXT(lSchedule)

	EndIf

Return IIF(lSchedule , cArqFTP , .T.)

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �fOrdCol    �Autor  �Rafael Cruz     		   � Data �29/12/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Ordena��o de A-Z dos dados com o bot�o direito do mouse           ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/
Static Function fOrdCol(nCol)
	Local nCount:= 1

	If !Empty(aDados) .and. Len(aDados) > 1

		If aDados[1,nCol] > aDados[Len(aDados)-1,nCol]
			aDados := aSort(aDados,1,Len(aDados)-1,{|x,y| x[nCol] < y[nCol] })
		Else
			aDados := aSort(aDados,1,Len(aDados)-1,{|x,y| x[nCol] > y[nCol] })
		EndIf

		oGetRank:SetArray(aDados)
		oGetRank:Refresh()
		oTela:Refresh()

	EndIf
Return
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �fLocaliz    �Autor  �Rafael Cruz     		   � Data �29/12/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Tela de Pesquisa[Ctrl+ F]							                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/
Static Function fLocaliz(lProxima)
	Local aParam	:= {}
	Local aRet		:= {}
	Local aCmpPesq	:= {}
	Local nX
	Local cOldPar01 := MV_PAR01
	Local cOldPar02 := MV_PAR02

	If nPesq == 1
		For nX := 1 To Len(aHeadRank)
			If aHeadRank[nX,8] = "C" .OR. aHeadRank[nX,8] = "D"
				aAdd(aCmpPesq,aHeadRank[nX,1])
			EndIf
		Next nX

		If lProxima
			nPosRank := aScan(aDados,{|x| Alltrim(Upper(cTexPesq)) $ Upper(x[aScan(aHeadRank,{|y|y[1] = aCmpPesq[nTipPesq]})]) },nLinPesq+1)
			If Empty(nPosRank)
				MsgAlert("Texto n�o Encontrado em " + aHeadRank[aScan(aHeadRank,{|y|y[1] = aCmpPesq[nTipPesq]}),1] + ".","N�o Localizado")
			Else
				oGetRank:Goto(nPosRank)
				oGetRank:Refresh()
				nLinPesq := nPosRank
			EndIf
		Else
			nPesq++
			aAdd(aParam, {3, "Campo de Pesquisa",1,aCmpPesq,200,"",.T.})
			aAdd(aParam, {1, "Texto a Pesquisar",Space(30) , "@!", "", "", "", 100, .T.})
			If ParamBox(aParam, "Pesquisa Texto no Browse", @aRet,,,,,,,, .F.)
				nPosRank := aScan(aDados,{|x| Alltrim(Upper(aRet[2])) $ Upper(x[aScan(aHeadRank,{|y|y[1] = aCmpPesq[aRet[1]]})]) })
				If Empty(nPosRank)
					MsgAlert("Texto n�o Encontrado em " + aHeadRank[aScan(aHeadRank,{|y|y[1] = aCmpPesq[aRet[1]]}),1] + ".","N�o Localizado")
				Else
					oGetRank:Goto(nPosRank)
					oGetRank:Refresh()
					nTipPesq := aRet[1]
					cTexPesq := aRet[2]
					nLinPesq := nPosRank
				EndIf
			EndIf
			nPesq:= 1
		EndIf
		oGetRank:oBrowse:SetFocus()
	EndIf
	MV_PAR01 := cOldPar01
	MV_PAR02 := cOldPar02

Return(.T.)

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �fGerDado    �Autor  �Rafael Cruz     		   � Data �29/12/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Query que retorna os dados da consulta			                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/
Static Function fGerDado(lSchedule)
	Local cQuery	:= ""
	Local nCount	:= 1
	Local nRec		:= 0
	Local bQuery	:= {|| Iif(Select((cAlias)) > 0, (cAlias)->(DbCloseArea()), Nil) , dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),(cAlias),.F.,.T.), DbSelectArea((cAlias)), (cAlias)->(dbEval({|| nRec++ })), (cAlias)->(dbGoTop())  }
	Local dDataIni	:= cToD('')
	Local dDataFim	:= cToD('')

	DEFAULT lSchedule	:= .F.

	aDados := {}

	nQtAbert	:= 0
	nQtEnvia	:= 0
	nQtConci	:= 0
	nQtBaixa	:= 0
	nQtTotal	:= 0
	nAberto		:= 0
	nEnviado	:= 0
	nBaixado	:= 0
	nConcil		:= 0
	nTotal		:= 0

	For nI:= 1 to Len(aParBkp)
		aParBkp[nI,2]:= &("MV_PAR"+cValtoChar(strzero(nI,2)))
	Next nI

	//���������������������������������Ŀ
	//� Gera a query                    �
	//�����������������������������������
	cQuery	+= "SELECT   "											+CRLF
	For nY := 2 to Len(aHeadRank)
		if aHeadRank[nY][10] <> 'V'
			cQuery += " " + aHeadRank[nY][2] + "," 					+CRLF
		endIf
	Next
	cQuery	+= " E1_BAIXA, E1_SALDO, E1_NOMCLI,					" 	+CRLF
	cQuery	+= " E1_XTRCID, SUBSTRING(A3_NREDUZ,1,25) AS E1_XVEND" 	+CRLF
	cQuery	+= " FROM  " + RETSQLNAME("SE1")  + " SE1 (NOLOCK) "	+CRLF

	cQuery	+= " LEFT JOIN " + RETSQLNAME("SA1") + " SA1"			+CRLF
	cQuery	+= " ON A1_COD = E1_CLIENTE "							+CRLF
	cQuery	+= " AND A1_LOJA = E1_LOJA "							+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "							+CRLF

	cQuery	+= " LEFT JOIN " + RetSQLName("SE2") + " SE2 (NOLOCK)"	+CRLF
	cQuery	+= " ON E1_NUM = E2_NUM "								+CRLF
	cQuery	+= " AND E1_PARCELA = E2_PARCELA"						+CRLF
	cQuery	+= " AND E1_XPARNSU = E2_XPARNSU"						+CRLF
	cQuery	+= " AND E1_TIPO = E2_TIPO"								+CRLF
	cQuery	+= " AND E1_MSFIL = E2_MSFIL"							+CRLF
	cQuery	+= " AND SE2.D_E_L_E_T_ = ' '"							+CRLF

	cQuery  += " LEFT JOIN " + RETSQLNAME("SA3") + " SA3 (NOLOCK)"	+CRLF
	cQuery  += " ON E1_VEND1 = A3_COD "								+CRLF
	cQuery  += " AND SA3.D_E_L_E_T_ = '' " 							+CRLF

	cQuery	+= " WHERE "											+CRLF
	cQuery	+= "   SE1.D_E_L_E_T_  = ''"							+CRLF
//	cQuery	+= "   AND 	SE1.E1_SALDO > 0 "							+CRLF
	cQuery	+= "   AND 	SE1.E1_TIPO IN ('CC','CD') "				+CRLF
	cQuery  += "   AND  SE1.E1_NSUTEF <> '' "														+CRLF
//	cQuery  += "   AND 	SE1.E1_01NOOPE <> ' ' "														+CRLF
	If !(lSchedule) //Se a chamada da rotina for atraves do agendamento, desconsidera os parametros abaixo (MV_PAR15, MV_PAR16 E MV_PAR17)
		cQuery	+= "   AND 	SE1.E1_NUM BETWEEN '"+ Mv_Par05 +"' AND '"+ Mv_Par06 +"' "					+CRLF
		cQuery	+= "   AND 	SE1.E1_EMISSAO BETWEEN '"+ Dtos(Mv_Par11) +"' AND '"+ Dtos(Mv_Par12) +"' "	+CRLF
		cQuery	+= "   AND 	SE1.E1_VENCTO BETWEEN '"+ Dtos(Mv_Par13) +"' AND '"+ Dtos(Mv_Par14) +"' "	+CRLF
		cQuery  += "   AND 	SE1.E1_MSFIL BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"'"					+CRLF
		cQuery  += "   AND 	SE1.E1_01OPER BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"'"				+CRLF
		cQuery  += "   AND 	SE1.E1_CLIENTE BETWEEN '"+ MV_PAR07 +"' AND '"+ MV_PAR09 +"'"				+CRLF
		cQuery  += "   AND 	SE1.E1_LOJA BETWEEN '"+ MV_PAR08 +"' AND '"+ MV_PAR10 +"'"					+CRLF
		If Mv_Par15 == 2
			cQuery	+= "   AND 	SE1.E1_01DTEXP =  ' ' "+CRLF
		Elseif Mv_Par15 == 1
			cQuery	+= "   AND 	SE1.E1_01DTEXP <> ' ' "+CRLF
		Endif
		If Mv_Par16 == 2
			cQuery	+= "   AND 	SE1.E1_BAIXA =  ' ' "+CRLF
		Elseif Mv_Par16 == 1
			cQuery	+= "   AND 	SE1.E1_BAIXA <> ' ' AND SE1.E1_SALDO = 0 "+CRLF
		Endif
		If Mv_Par17 == 2
			cQuery	+= "   AND 	SE1.E1_XTRCID =  ' ' "+CRLF
		Elseif Mv_Par17 == 1
			cQuery	+= "   AND 	SE1.E1_XTRCID <> ' ' "+CRLF
		Endif
	Else

		//O sistema deve enviar os dados nos dias �teis D+2 exemplo :
		//segunda-feira envia os dados da Quinta passada
		//e na ter�a envia os dados da sexta, s�bado e domingo
		//nos feriados, o sistema deve mandar s� nos dias �teis seguinte tamb�m com mesma regra D+2.

		//Para envio sempre deve ser feito no final do dia as 18:00.
		
		Do Case

			Case !(DataValida(dDataBase ,.T.) == dDataBase) //Se for um feriado

				If !(DoW(dDataBase) == 1) .OR. !(DoW(dDataBase) == 7)//Verifica se a data NAO � s�bado ou domingo

					Do Case

						Case (DoW(dDataBase) == 2) // Se o dia for segunda-feira, envia remessa da �ltima quinta-feira.

							dDataIni	:= dDataBase - 4

							dDataFim	:= dDataIni

						Case (DoW(dDataBase) == 3) // Caso for ter�a, envia dados entre Sexta-feira e domingo

							dDataIni	:= dDataBase - 4

							dDataFim	:= dDataBase - 2

						OtherWise

							dDataIni	:= dDataBase - 2

							dDataFim	:= dDataIni

					EndCase

				EndIf

			Case (DoW(dDataBase) == 2) // Se o dia for segunda-feira, envia remessa da �ltima quinta-feira.

				dDataIni	:= dDataBase - 4

				dDataFim	:= dDataIni

			Case (DoW(dDataBase) == 3) // Caso for ter�a, envia dados entre Sexta-feira e domingo

				dDataIni	:= dDataBase - 4

				dDataFim	:= dDataBase - 2

			OtherWise

				dDataIni	:= dDataBase - 2

				dDataFim	:= dDataIni

		EndCase

		cQuery	+= "   AND 	SE1.E1_EMISSAO BETWEEN '"+ Dtos(dDataIni) +"' AND '"+ Dtos(dDataFim) +"' "	+CRLF
	
	EndIf
	cQuery  += " ORDER BY E1_FILORIG,E1_PREFIXO,E1_NUM,E1_TIPO,E1_PARCELA "+CRLF

	Eval(bQuery)
	TcSetField((cAlias),"E1_EMISSAO","D",08,00)
	TcSetField((cAlias),"E1_VENCTO" ,"D",08,00)
	TcSetField((cAlias),"E1_VENCREA","D",08,00)

	(cAlias)->(dbgotop())

	While (cAlias)->(!EOF())
		If !EMPTY((cAlias)->E1_BAIXA) .AND. (cAlias)->E1_SALDO == 0
				oStatus := oSt2		//BR_VERMELHO
			nQtBaixa += 1
			nBaixado += (cAlias)->E1_VALOR
		ElseIf !EMPTY((cAlias)->E1_BAIXA) .AND. (cAlias)->E1_SALDO > 0
			oStatus := oSt3		//BR_AZUL
			nBaixado += (cAlias)->E1_VALOR
		ElseIf EMPTY((cAlias)->E1_BAIXA) .AND. !EMPTY((cAlias)->E1_01DTEXP) .AND. !EMPTY((cAlias)->E1_XTRCID)
			oStatus := oSt6		//BR_PRETO
			nQtConci+= 1
			nConcil	+= (cAlias)->E1_VALOR
		ElseIf EMPTY((cAlias)->E1_BAIXA) .AND. !EMPTY((cAlias)->E1_01DTEXP)
			oStatus := oSt5		//BR_AMARELO
			nQtEnvia += 1
			nEnviado += (cAlias)->E1_VALOR

		Else
			oStatus := oSt1		//BR_VERDE
			nQtAbert += 1
			nAberto	 += (cAlias)->E1_VALOR
		EndIf
/*
			nQtConci += 1
			nConcil	 += (cAlias)->E1_VALOR
*/
		nQtTotal += 1
		nTotal	 += (cAlias)->E1_VALOR

		aAdd(aDados,{ oStatus,;						//  1
						(cAlias)->(E1_PREFIXO),;	//  2
						(cAlias)->(E1_PREFIXO) + PADR((cAlias)->(E1_NUM),9,' ') + StrZero(U_retParc((cAlias)->(E1_PARCELA)),TamSX3("E1_PARCELA")[1]) + (cAlias)->(E1_TIPO),;										//  3
						StrZero(U_retParc((cAlias)->(E1_PARCELA)),TamSX3("E1_PARCELA")[1]),;	//  4
						(cAlias)->(E1_TIPO),;		//  5
						(cAlias)->(E1_NATUREZ),;	//  6
						(cAlias)->(E1_CLIENTE),;	//  7
						(cAlias)->(E1_LOJA),;		//  8
						IIF(EMPTY((cAlias)->(A1_NOME)),(cAlias)->(E1_NOMCLI),(cAlias)->(A1_NOME)),;		//  9
						(cAlias)->(E1_EMISSAO),;	// 10
						(cAlias)->(E1_VENCTO),;		// 11
						(cAlias)->(E1_VENCREA),;	// 12
						(cAlias)->(E1_VALOR),;		// 13
						(cAlias)->(E1_BASEIRF),;	// 14
						(cAlias)->(E1_IRRF),;		// 15
						(cAlias)->(E1_ISS),;		// 16
						(cAlias)->(E1_HIST),;		// 17
						(cAlias)->(E1_VEND1),;		// 18
						(cAlias)->(E1_VEND2),;		// 19
						(cAlias)->(E1_VEND3),;		// 20
						(cAlias)->(E1_VEND4),;		// 21
						(cAlias)->(E1_VEND5),;		// 22
						(cAlias)->(E1_COMIS1),;		// 23
						(cAlias)->(E1_COMIS2),;		// 24
						(cAlias)->(E1_COMIS3),;		// 25
						(cAlias)->(E1_COMIS4),;		// 26
						(cAlias)->(E1_COMIS5),;		// 27
						(cAlias)->(E1_VALJUR),;		// 28
						(cAlias)->(E1_PORCJUR),;	// 29
						(cAlias)->(E1_MOEDA),;		// 30
						(cAlias)->(E1_VALCOM1),;	// 31
						(cAlias)->(E1_VALCOM2),;	// 32
						(cAlias)->(E1_VALCOM3),;	// 33
						(cAlias)->(E1_VALCOM4),;	// 34
						(cAlias)->(E1_VALCOM5),;	// 35
						(cAlias)->(E1_OCORREN),;	// 36
						(cAlias)->(E1_INSTR1),;		// 37
						(cAlias)->(E1_INSTR2),;		// 38
						(cAlias)->(E1_PEDIDO),;		// 39
						(cAlias)->(E1_VLCRUZ),;		// 40
						(cAlias)->(E1_FLUXO),;		// 41
						(cAlias)->(E1_DESCFIN),;	// 42
						(cAlias)->(E1_DIADESC),;	// 43
						(cAlias)->(E1_TIPODES),;	// 44
						(cAlias)->(E1_INSS),;		// 45
						(cAlias)->(E1_DTACRED),;	// 46
						(cAlias)->(E1_CSLL),;   	// 47
						(cAlias)->(E1_COFINS),;		// 48
						(cAlias)->(E1_PIS),;   		// 49
						(cAlias)->(E1_TXMOEDA),;	// 50
						(cAlias)->(E1_ACRESC),;		// 51
						(cAlias)->(E1_DECRESC),;	// 52
						(cAlias)->(E1_MULTNAT),;	// 53
						(cAlias)->(E1_PROJPMS),;	// 54
						(cAlias)->(E1_DESDOBR),;	// 55
						(cAlias)->(E1_MODSPB),;		// 56
						(cAlias)->(E1_CODORCA),;	// 57
						(cAlias)->(E1_CODIMOV),;	// 58
						(cAlias)->(E1_FILDEB),;		// 59
						(cAlias)->(E1_NUMCRD),;		// 60
						(cAlias)->(E1_FORNISS),;	// 61
						(cAlias)->(E1_SCORGP),;		// 62
						(cAlias)->(E1_FRETISS),;	// 63
						(cAlias)->(E1_TXMDCOR),;	// 64
						(cAlias)->(E1_BCOCLI),;		// 65
						(cAlias)->(E1_MDCRON),; 	// 66
						(cAlias)->(E1_MDCONTR),;  	// 67
						(cAlias)->(E1_MEDNUME),;	// 68
						(cAlias)->(E1_MDPLANI),;	// 69
						(cAlias)->(E1_MDPARCE),;	// 70
						(cAlias)->(E1_MDREVIS),;	// 71
						(cAlias)->(E1_MDREVIS),;	// 72
						(cAlias)->(E1_PREFORI),;	// 73
						(cAlias)->(E1_NUMPRO),;		// 74
						(cAlias)->(E1_INDPRO),; 	// 75
						(cAlias)->(E1_RELATO),; 	// 76
						(cAlias)->(E1_DESCJUR),;	// 77
						(cAlias)->(E1_FABOV),;		// 78
						(cAlias)->(E1_FACS),;		// 79
						(cAlias)->(E1_PARTPDP),;	// 80
						(cAlias)->(E1_TPDP),;		// 81
						(cAlias)->(E1_RETCNTR),;	// 82
						(cAlias)->(E1_MDDESC),;		// 83
						(cAlias)->(E1_MDBONI),;		// 84
						(cAlias)->(E1_MDMULT),;		// 85
						(cAlias)->(E1_CCUSTO),;		// 86
						(cAlias)->(E1_TPDESC),;		// 87
						(cAlias)->(E1_VLMINIS),;	// 88
						(cAlias)->(E1_PARCFAB),;	// 89
						(cAlias)->(E1_PARCFAC),;	// 90
						(cAlias)->(E1_PRINSS),;		// 91
						" ",;						// 92	Removido para for�ar o Concil a utilizar o NSUTEF //(cAlias)->(E1_DOCTEF),;		// 92
						(cAlias)->(E1_NFELETR),;	// 93
						(cAlias)->(E1_NODIA),;		// 94
						(cAlias)->(E1_FMPEQ),;		// 95
						(cAlias)->(E1_PARCFAM),;	// 96
						(cAlias)->(E1_PARCFMP),;	// 97
						(cAlias)->(E1_TURMA),;		// 98
						(cAlias)->(E1_PRISS),;	    // 99
						(cAlias)->(E1_CODIRRF),;	//100
						(cAlias)->(E1_APLVLMN),;	//101
						(cAlias)->(E1_CODISS),;		//102
						(cAlias)->(E1_NSUTEF),;		//103 <<=========
						(cAlias)->(E1_DIACTB),;		//104
						(cAlias)->(E1_CMC7FIN),;	//105
						(cAlias)->(E1_CPFCNPJ),;	//106
						(cAlias)->(E1_NUMSUA),;		//107
						(cAlias)->(E1_PEDPEND),;	//108
						(cAlias)->(E1_USRNAME),;	//109
						(cAlias)->(E1_01SAC),;		//110
						(cAlias)->(E1_01MOTIV),;	//111
						(cAlias)->(E1_01VLBRU),;	//112
						(cAlias)->(E1_01TAXA),;		//113
						(cAlias)->(E1_01QPARC),;	//114
						(cAlias)->(E1_01REDE),;		//115
						(cAlias)->(E1_01NORED),;	//116
						(cAlias)->(E1_01OPER),;		//117
						(cAlias)->(E1_01NOOPE),;	//118
						(cAlias)->(E1_01DTEXP),;	//119
						(cAlias)->(E1_XDESCFI),;	//120
						(cAlias)->(E1_BOLETO),;		//121
						(cAlias)->(E1_ITEMCTA),;	//122
						(cAlias)->(E1_CLVL),;		//123
						(cAlias)->(E1_CODRET),;		//124
						(cAlias)->(E1_CONHTL),;		//125
						(cAlias)->(E1_TCONHTL),;	//126
						(cAlias)->(E1_01VALCX),;	//127
						(cAlias)->(E1_01NUMRA),;	//128
						(cAlias)->(E1_XUSRBOL),;	//129
						(cAlias)->(E1_XNUMBOL),;	//130
						U_retParc((cAlias)->(E1_XPARNSU)),;	//131
						(cAlias)->(E1_XNCART4),;	//132
						IIF(alltrim((cAlias)->(E1_TIPO)) $ "CC",ALLTRIM((cAlias)->(E1_XFLAG)) + " CREDITO",ALLTRIM((cAlias)->(E1_XFLAG)) + " DEBITO"),;	//133
						(cAlias)->(E1_XPEDORI),;	//134
						(cAlias)->(E1_XVEND),;		//135 //Campo virtual mantido por conta do layout aceito pela Concil
						(cAlias)->(E1_XFILUTI),;	//136
						.F.})
		(cAlias)->(dbskip())
	Enddo

	(cAlias)->(dbCloseArea())

	if len(aDados) <= 0
		AAdd(aDados,Array(Len(aHeadRank)+1))
		For wJ := 2 to Len(aHeadRank)
			aDados[Len(aDados)][wJ] := CriaVar(aHeadRank[wJ,2],.F.)
		next
		aDados[Len(aDados)][1] := ""
		aDados[Len(aDados)][Len(aHeadRank)+1] := .F.
    endif

	If !(lSchedule)
		oGetRank:SetArray(aDados)
		oGetRank:oBrowse:SetFocus()
		oGetRank:ForceRefresh()
	EndIf

Return

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �fMontCab   �Autor  �Rafael Cruz     		   � Data �19/04/2016   ���
�������������������������������������������������������������������������������͹��
���Descricao �Monta o cabe�alho da consulta 					                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/
Static Function fMontCab()

	aCampos := {'E1_PREFIXO','E1_NUM','E1_PARCELA','E1_TIPO','E1_NATUREZ','E1_CLIENTE','E1_LOJA','A1_NOME','E1_EMISSAO','E1_VENCTO','E1_VENCREA','E1_VALOR','E1_BASEIRF',;
			    'E1_IRRF','E1_ISS','E1_HIST','E1_VEND1','E1_VEND2','E1_VEND3','E1_VEND4','E1_VEND5','E1_COMIS1','E1_COMIS2','E1_COMIS3','E1_COMIS4','E1_COMIS5','E1_VALJUR',;
				'E1_PORCJUR','E1_MOEDA','E1_VALCOM1','E1_VALCOM2','E1_VALCOM3','E1_VALCOM4','E1_VALCOM5','E1_OCORREN','E1_INSTR1','E1_INSTR2','E1_PEDIDO','E1_VLCRUZ',;
				'E1_FLUXO','E1_DESCFIN','E1_DIADESC','E1_TIPODES','E1_INSS','E1_DTACRED','E1_CSLL','E1_COFINS','E1_PIS','E1_TXMOEDA','E1_ACRESC','E1_DECRESC','E1_MULTNAT',;
				'E1_PROJPMS','E1_DESDOBR','E1_MODSPB','E1_CODORCA','E1_CODIMOV','E1_FILDEB','E1_NUMCRD','E1_FORNISS','E1_SCORGP','E1_FRETISS','E1_TXMDCOR','E1_BCOCLI',;
				'E1_MDCRON','E1_MDCONTR','E1_MEDNUME','E1_MDPLANI','E1_MDPARCE','E1_MDREVIS','E1_NUMMOV','E1_PREFORI','E1_NUMPRO','E1_INDPRO','E1_RELATO','E1_DESCJUR','E1_FABOV',;
				'E1_FACS','E1_PARTPDP','E1_TPDP','E1_RETCNTR','E1_MDDESC','E1_MDBONI','E1_MDMULT','E1_CCUSTO','E1_TPDESC','E1_VLMINIS','E1_PARCFAB','E1_PARCFAC','E1_PRINSS',;
				'E1_DOCTEF','E1_NFELETR','E1_NODIA','E1_FMPEQ','E1_PARCFAM','E1_PARCFMP','E1_TURMA','E1_PRISS','E1_CODIRRF','E1_APLVLMN','E1_CODISS','E1_NSUTEF','E1_DIACTB',;
				'E1_CMC7FIN','E1_CPFCNPJ','E1_NUMSUA','E1_PEDPEND','E1_USRNAME','E1_01SAC','E1_01MOTIV','E1_01VLBRU','E1_01TAXA','E1_01QPARC','E1_01REDE','E1_01NORED','E1_01OPER',;
				'E1_01NOOPE','E1_01DTEXP','E1_XDESCFI','E1_BOLETO','E1_ITEMCTA','E1_CLVL','E1_CODRET','E1_CONHTL','E1_TCONHTL','E1_01VALCX','E1_01NUMRA','E1_XUSRBOL','E1_XNUMBOL',;
				'E1_XPARNSU','E1_XNCART4','E1_XFLAG','E1_XPEDORI','E1_XVEND','E1_XFILUTI'}

	aHeadRank	:= {}
	aDados		:= {}

	aAdd(aHeadRank,{"St.","FLAG","@BMP",1,0,"","��������������","C","","R","","","","V","","",""})

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aCampos)
		If SX3->(DbSeek(aCampos[nX]))
			Aadd(aHeadRank, {AllTrim(X3Titulo()),;	//T�tulo
							 SX3->X3_CAMPO,;		//Campo
							 SX3->X3_PICTURE,;		//Pic
							 SX3->X3_TAMANHO,;		//Tamanho
							 SX3->X3_DECIMAL,;		//Decimal
							 ".F.",;				//Valida��o
							 SX3->X3_USADO,;		//reservado
							 SX3->X3_TIPO,;			//Tipo
							 ""/*SX3->X3_F3*/,;		//Reservado
							 SX3->X3_CONTEXT,;		//Reservado
							 SX3->X3_CBOX,;
							 ".F."})
	    Endif
	Next nX

	if len(aDados) <= 0
		AAdd(aDados,Array(Len(aHeadRank)+1))
		For nZ := 2 to Len(aHeadRank)
			aDados[Len(aDados)][nZ] := CriaVar(aHeadRank[nZ,2],.F.)
		next
		aDados[Len(aDados)][1] := ""
		aDados[Len(aDados)][Len(aHeadRank)+1] := .F.
    endif
Return

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �fValidPerg  �Autor  �Rafael Cruz       		   � Data �12/11/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Tela de Controle de Concilia��o de Cart�o   		                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/
Static Function fValidPerg()
	aRegs       := {}
	DbSelectArea("SX1")
	DbSetOrder(1)

	If !Dbseek(cPerg)
		AADD(aRegs,{cPerg,"01","Filial de?"			,""	,"", "mv_ch1", "C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
		AADD(aRegs,{cPerg,"02","Filial at�?"		,""	,"", "mv_ch2", "C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
		AADD(aRegs,{cPerg,"03","Operadora de?"		,""	,"", "mv_ch3", "C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","_L9",""})
		AADD(aRegs,{cPerg,"04","Operadora ate?"		,""	,"", "mv_ch4", "C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","_L9",""})
		AADD(aRegs,{cPerg,"05","T�tulo de?"			,""	,"", "mv_ch5", "C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","_CCSE1",""})
		AADD(aRegs,{cPerg,"06","T�tulo at�?"		,""	,"", "mv_ch6", "C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","_CCSE1",""})
		AADD(aRegs,{cPerg,"07","Cliente de?"		,""	,"", "mv_ch7", "C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","_CCSA1",""})
		AADD(aRegs,{cPerg,"08","Loja de?"			,""	,"", "mv_ch8", "C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg,"09","Cliente at�?"		,""	,"", "mv_ch9", "C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","_CCSA1",""})
		AADD(aRegs,{cPerg,"10","Loja at�?"			,""	,"", "mv_cha" ,"C",02,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg,"11","Dt.Emiss�o de?"		,""	,"", "mv_chb" ,"D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg,"12","Dt.Emiss�o at�?"	,""	,"", "mv_chc" ,"D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg,"13","Dt.Venc. de?"		,""	,"", "mv_chd" ,"D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg,"14","Dt.Venc. at�?"		,""	,"", "mv_che" ,"D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg,"15","J� Enviado(s)?"		,""	,"", "mv_chf" ,"C",01,0,0,"C","","mv_par15","Sim","","","","","N�o","","","","","Ambos","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg,"16","J� Baixado(s)?"		,""	,"", "mv_chg" ,"C",01,0,0,"C","","mv_par16","Sim","","","","","N�o","","","","","Ambos","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg,"17","Conciliado(s)?"		,""	,"", "mv_chh" ,"C",01,0,0,"C","","mv_par17","Sim","","","","","N�o","","","","","Ambos","","","","","","","","","","","","","","",""})
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
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �fHelp    �Autor  �Rafael Cruz       		   � Data �12/11/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Tela de Controle de Concilia��o de Cart�o   		                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/

Static Function fHelp(cArq)
	Local oDlg
	Local cMemo

	Local oFont
	Local cStartPath := GetSrvProfString("Startpath","")
	Local __cFileLog := StrTran(AllTrim(cStartPath) + "\xHelp\"+cArq+".txt", "\\", "\")

	If File(__cFileLog)

		cMemo := MemoRead(__cFileLog)

		DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15

		DEFINE MSDIALOG oDlg TITLE "Ajuda" From 3,0 to 442,542 PIXEL

		@ 5,5 Get oMemo  VAR cMemo MEMO SIZE 260,188.5 /*When .T.*/ OF oDlg PIXEL READONLY
		oMemo:bRClicked := {||AllwaysTrue()}
		oMemo:oFont:=oFont

		DEFINE SBUTTON  FROM 199,227.5 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga

		ACTIVATE MSDIALOG oDlg CENTER
	Else
		MsgAlert("Op��o n�o Dispon�vel.")
	Endif

Return

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �fGeraTXT  �Autor  �Rafael Cruz       		   � Data �12/11/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Tela de Controle de Concilia��o de Cart�o   		                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/

Static Function fGeraTXT(lSchedule)


Local cArquivo  := CriaTrab(,.F.)
Local cMensage	:= "O(s) par�metro(s) seguinte(s) est�(�o) alterado(s), carregar os dados novamente: " + CRLF
Local lDifer	:= .F.

DEFAULT lSchedule	:= .F.

If !(lSchedule)
	For nI:= 1 to Len(aParBkp)
		If aParBkp[nI,2] <> &("MV_PAR"+cValtoChar(strzero(nI,2)))
			cMensage+= "Par�metro: '"+aParBkp[nI,1]+"', anterior: '"+cvaltochar(aParBkp[nI,2])+"' " + CRLF
			lDifer:= .T.
		EndIf
	Next nI

	If lDifer
		Alert(cMensage)
		Return
	EndIf

EndIf

if nQtEnvia <> 0
	If !(lSchedule)
		if !MsgYesNo("H� registro(s) j� enviado(s). Deseja enviar novamente?","Aten��o")
			MsgInfo("Mude o par�metro 'J� Enviado' e depois Gere os Dados","Procedimento")
			Return
		endIf
	Else
		Return
	EndIf
endIf

If !(lSchedule)

	cPath := cGetFile(,"Selecione o diret�rio de destino",0,"C:\",.T.,GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY, .F.)

Else

	cPath	:= "\SYSTEM\"

EndIf

If !Empty(cPath)

	//���������������������������������Ŀ
	//� Gera o arquivo em formato .CSV. �
	//�����������������������������������
	cArquivo += ".CSV"
	nHandle := FCreate(cPath + cArquivo)
	If nHandle == -1
		MsgStop("Erro na criacao do arquivo Excel. Contate o administrador do sistema"	)
		Return
	EndIf

	Processa({|| fLerTit()})

	//���������������Ŀ
	//�Fecha o arquivo�
	//�����������������
	FClose(nHandle)

Endif

fAtuSe1(lSchedule)
fGerDado(lSchedule)

If !(lSchedule)
	oGetRank:Refresh()
EndIf

Return IIF(lSchedule , cArquivo , "")

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �fLerTit  �Autor  �Rafael Cruz       		   � Data �12/11/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Tela de Controle de Concilia��o de Cart�o   		                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/

Static Function fLerTit()

Local cBuffer 	:= ""
Local nPosNSU	:= 103	//Posi��o referente ao campo E1_NSUTEF

//���������������������������������Ŀ
//� Gera o cabecalho do arquivo.    �
//�����������������������������������

cBuffer := "Prefixo;No. Titulo;Parcela;Tipo;Natureza;Cliente;Loja;Nome Cliente;DT Emissao;Vencimento;Vencto real;Vlr.Titulo;Base Imposto;IRRF;ISS;Historico;Vendedor 1;Vendedor 2;Vendedor 3;Vendedor 4;Vendedor 5;% Comissao 1;% Comissao 2;% Comissao 3;% Comissao 4;% Comissao 5;Taxa Perman.;Porc Juros;Moeda;Vlr. comis.1;Vlr. comis.2;Vlr. comis.3;Vlr. comis.4;Vlr. comis.5;Cod Ocorrenc;Inst.Primar.;Instr.Secund;No. Pedido;Vlr R$;Fluxo Caixa;Desc Financ.;Dias p/ Desc;Tipo Descont;INSS;Data p/ Comp;CSLL;COFINS;PIS/PASEP;Taxa moeda;Acrescimo;Decrescimo;Mult. Natur.;Rateio Proj.;Desdobramen.;Mod. Recebto;Cod. Orcam.;Cod. Imovel;Fil.Debito;Contr Financ;Forn.ISS;PisCof OrgP.;Form Ret ISS;Tx Cor.Moeda;Banco Client;Num. Cronogr;Num. Contrat;Num. Medi��o;Num. Planilh;Num. Parcela;Revis�o;Movimento;Pref Origem;Proc. Refer.;Tp. Processo;Env. Relato;Desc.Juros;Vlr.FABOV;Vlr.FACS;Par. TPDP;Vlr. TPDP;Retencao Ctr;Desconto Ctr;Bonific Ctr;Multa Ctr;C. de Custo;Desc. F100;Vlr Min ISS;Parc.FABOV;Parc.FACS;Prov INSS;Num. NSU;NF Eletr;Seq. Diario;Vl.FUMIPEQ;Parc.FAMAD;Parc.FUMIPEQ;Turma;Prov ISS;Cod.Rec.IRRF;Aplica Vlr.;Cod.Aliq.ISS;NSU SITEF;Cod. Diario;CMC7 CHQ FIN;CPF/CNPJ CHQ;Numero TLV;Ped.Conferid;Usu�rio;Numero SAC;Motivo NCC;Vlr.Bruto;Tx.Atual.Ped;Qtd.Parcelas;Rede Utiliza;Nome Rede;Cod.Operador;Nom.Operador;Data Exporta;Desc.Filial;Gera boleto;Item Contab.;Classe Valor;Cod. Ret.PCC;Conta Hotel;Tipo Conta;Vld.Fech.Cx?;Numero RA;Usr Ger Bol;Num Imp Bol;Parc.NSU;Final Cart�o;Bandeira;Ped Origem;Nome Vend;Fil Utilizad"

FWrite(nHandle, cBuffer + CRLF)

aSort( aDados,,, {|a,b| a[103] + str(a[130]) < b[103] + str(b[130])} )	// ordena por 9-NSU e 6-parcela.

nJ := 1
while nJ <= len( aDados )

	cBuffer := ""

	for nK := 2 to (len(aDados[nJ]) - 1)
		If nK == nPosNSU
			xDados := fAjust(aDados[nJ,nK])
			cBuffer += iif( empty(cBuffer), "", ";" ) + PADL(Alltrim(xDados),10,"0")
		else
			xDados := fAjust(aDados[nJ,nK])
			cBuffer += iif( empty(cBuffer), "", ";" ) + xDados
		EndIf
	next

	FWrite(nHandle, cBuffer + CRLF)

	nJ++
end
Return

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �fAjust  �Autor  �Rafael Cruz       		   � Data �12/11/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Tela de Controle de Concilia��o de Cart�o   		                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/

Static Function fAjust(xDado)

If valtype(xDado) == "C"
	xDado := Alltrim(xDado)
ElseIf valtype(xDado) == "N"
	xDado := STRTRAN(ALLTRIM(STR(xDado)),".",",")
	xDado := cValToChar(xDado)
ElseIF valtype(xDado) == "D"
	xDado := DTOS(xDado)
	xDado := SUBSTR(Alltrim(xDado),7,2)+"/"+SUBSTR(Alltrim(xDado),5,2)+"/"+SUBSTR(Alltrim(xDado),1,4)
EndIf

Return xDado

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �fAtuSe1  �Autor  �Rafael Cruz       		   � Data �12/11/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Tela de Controle de Concilia��o de Cart�o   		                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/
Static Function fAtuSe1(lSchedule)

Local _aArea := SE1->(GetArea())
Local cQuery := ""
Local nRec	 := 0
Local _cAlias	:= GetNextAlias()
Local bQuery	:= {|| Iif(Select((_cAlias)) > 0, (_cAlias)->(DbCloseArea()), Nil) , dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),(_cAlias),.F.,.T.), DbSelectArea((_cAlias)), (_cAlias)->(dbEval({|| nRec++ })), (_cAlias)->(dbGoTop())  }

DEFAULT lSchedule	:= .F.
//������������������������������������������������Ŀ
//�Executa o update para flegar os itens exportados�
//��������������������������������������������������
	cQuery	:= " SELECT E1_PREFIXO, E1_FILORIG, E1_NUM,E1_TIPO,E1_PARCELA, E1_01DTEXP "	+CRLF
	cQuery	+= " FROM  " + RETSQLNAME("SE1")  + " SE1 (NOLOCK) "	+CRLF
	cQuery	+= " INNER JOIN " + RETSQLNAME("SA1") + " SA1"			+CRLF
	cQuery	+= " ON A1_COD = E1_CLIENTE "							+CRLF
	cQuery	+= " AND A1_LOJA = E1_LOJA "							+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "							+CRLF
	cQuery	+= " LEFT JOIN " + RetSQLName("SE2") + " SE2 (NOLOCK)"	+CRLF
	cQuery	+= " ON E1_NUM = E2_NUM "								+CRLF
	cQuery	+= " AND E1_PARCELA = E2_PARCELA"						+CRLF
	cQuery	+= " AND E1_XPARNSU = E2_XPARNSU"						+CRLF
	cQuery	+= " AND E1_TIPO = E2_TIPO"								+CRLF
	cQuery	+= " AND E1_MSFIL = E2_MSFIL"							+CRLF
	cQuery	+= " AND SE2.D_E_L_E_T_ = ' '"							+CRLF
	cQuery	+= " WHERE "											+CRLF
	cQuery	+= "   SE1.D_E_L_E_T_  = ''"							+CRLF
	cQuery	+= "   AND 	SE1.E1_TIPO IN ('CC','CD') "				+CRLF
	cQuery	+= "   AND 	SE1.E1_NUM BETWEEN '"+ Mv_Par05 +"' AND '"+ IIF(Empty(Mv_Par06), 'ZZZZ', MV_PAR06 ) +"' "					+CRLF
	cQuery	+= "   AND 	SE1.E1_EMISSAO BETWEEN '"+ Dtos(Mv_Par11) +"' AND '"+ IIF(Empty(Dtos(Mv_Par12)) , 'ZZZZ' , Dtos(Mv_Par12) ) +"' "	+CRLF
	cQuery	+= "   AND 	SE1.E1_VENCTO BETWEEN '"+ Dtos(Mv_Par13) +"' AND '"+ IIF(Empty(Dtos(Mv_Par14)) , 'ZZZ' , Dtos(Mv_Par14)) +"' "	+CRLF
	cQuery  += "   AND  SE1.E1_NSUTEF <> '' "														+CRLF
	cQuery  += "   AND 	SE1.E1_MSFIL BETWEEN '"+ MV_PAR01 +"' AND '"+ IIF(Empty(MV_PAR02) , 'ZZZ' , MV_PAR02) +"'"					+CRLF
	cQuery  += "   AND 	SE1.E1_01OPER BETWEEN '"+ MV_PAR03 +"' AND '"+ IIF(Empty(MV_PAR04) , 'ZZZ' , MV_PAR04 ) +"'"				+CRLF
	cQuery  += "   AND 	SA1.A1_COD BETWEEN '"+ MV_PAR07 +"' AND '"+ IIF(Empty(MV_PAR09) , 'ZZZ' , MV_PAR09) +"'"					+CRLF
	cQuery  += "   AND 	SA1.A1_LOJA BETWEEN '"+ MV_PAR08 +"' AND '"+ IIF(Empty(MV_PAR10) , 'ZZZ'  , MV_PAR10 ) +"'"					+CRLF
	If Mv_Par15 == 1
		cQuery	+= "   AND 	SE1.E1_01DTEXP =  ' ' "+CRLF
	Elseif Mv_Par15 == 2
		cQuery	+= "   AND 	SE1.E1_01DTEXP <> ' ' "+CRLF
	Endif
	If Mv_Par16 == 1
		cQuery	+= "   AND 	SE1.E1_BAIXA =  ' ' "+CRLF
	Elseif Mv_Par16 == 2
		cQuery	+= "   AND 	SE1.E1_BAIXA <> ' ' AND SE1.E1_SALDO = 0 "+CRLF
	Endif
	cQuery  += " ORDER BY E1_FILORIG,E1_PREFIXO,E1_NUM,E1_TIPO,E1_PARCELA "+CRLF

	//eval(bQuery)

	If(Select(_cAlias) > 0)

		(_cAlias)->(DbCloseArea())

	EndIf

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),(_cAlias),.F.,.T.)

	DbSelectArea((_cAlias))

	(_cAlias)->(dbEval({|| nRec++ }))

	(_cAlias)->(dbGoTop())

	dbSelectArea("SE1")
	SE1->(dbSetOrder(1))
	SE1->(dbGoTop())
	While (_cAlias)->(!EOF())
	If SE1->(dbSeek(xFilial("SE1") + (_cAlias)->E1_PREFIXO + (_cAlias)->E1_NUM + (_cAlias)->E1_PARCELA + (_cAlias)->E1_TIPO))
	RecLock("SE1",.F.)
		SE1->E1_01DTEXP := dDataBase
	MsUnlock()
	endIf
	(_cAlias)->(dbSkip())
	endDo

RestArea(_aArea)

fGerDado(lSchedule)

Return

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �fLeg	  �Autor  �Rafael Cruz       		   � Data �12/11/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Tela de Controle de Concilia��o de Cart�o   		                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/
Static Function fLeg()

    Local aLegenda := {}

    //Monta as legendas (Cor, Legenda)
    aAdd(aLegenda,{"BR_VERDE",      "T�tulo em Aberto"})
    aAdd(aLegenda,{"BR_AMARELO",    "T�tulo Enviado"})
    aAdd(aLegenda,{"BR_VERMELHO",   "T�tulo Baixado"})
    aAdd(aLegenda,{"BR_PRETO",  	"T�tulo Conciliado"})
    aAdd(aLegenda,{"BR_AZUL",     	"T�tulo c/ Baixa Parcial"})

    //Chama a fun��o que monta a tela de legenda
    BrwLegenda("Status", "Posi��o dos t�tulos processados.", aLegenda)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fRecTit       �Autor  �Microsiga       � Data �  10/07/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para a recebimento dos titulos para conciliacao de   ���
���          �cartoes.                                                 	  ���
�������������������������������������������������������������������������͹��
���Uso       � Bio-Ritmo                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fRecTit()

Local cArquivo  := ""
Local cArq01   	:= ""
Local cTipoArq 	:= "Todos os Arquivos *.* | *.* |"
Local cDirDocs 	:= "C:\TEMP\"
Local cDirServ	:= "\importacao\"
Local nX		:= 0
Local nZa		:= 0
Local nHdl		:= 0
Local nHandle	:= 0
Local aCombo	:= {"Sim","N�o"}
Local aArqTemp	:= {}
Local aBoxParam	:= {}
Local aRetParam	:= {}
Local aLeitura	:= {}
Local lGeraSE2	:= .F.
Local cDirLogs 	:= "C:\TEMP\"
Local cStrTXT	:= ""
Local cTp01		:= ""

//Carrego todOs arquivos textos da maquina local para exclui-los
aArqTemp := Directory(cDirDocs+"*.LOG")
aEval(aArqTemp, {|x| FErase(cDirDocs+x[1])})

//Cria Diretorio
MakeDir(cDirDocs)

//Cria Diretorio
MakeDir(cDirServ)

cArquivo := cGetFile(cTipoArq,"Selecione o arquivo para importa��o.",0,,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE,.F.)

IF !Empty(cArquivo)

	//Copia o arquivo local para o servidor
	lRet := CpyT2S( cArquivo , cDirServ , .F. )
	If lRet
		cArquivo := SubStr(cArquivo,RAT("\",cArquivo) + 1,Len(cArquivo))
	Endif
	cArq01 := Substr(cArquivo,1,Len(cArquivo)-4)

	//Abre o arquivo que sera importado
	nHdl := FT_FUSE(cDirServ+cArquivo)
	If nHdl == -1
		MsgStop("Erro na criacao do arquivo."	)
		Return(.T.)
	EndIf

	//�������������������������������������������������������������������������Ŀ
	//� Leitura do arquivo texto e avalia o tipo se B(venda) ou C(concilia��o)  �
	//���������������������������������������������������������������������������
	cStrTXT  := FT_FREADLN()
	aLeitura := Separa(cStrTXT , ";")

	//Gera tabela temporario no BD
	if Substr(Alltrim(aLeitura[1]),1,1) $ "B"
		cTp01 := "B"
		fGeraTmp(cArquivo,cTp01)
	else
		cTp01 := "C"
		fGeraTmp(cArquivo,cTp01)
	endIf

//	Gera tabela temporario no BD
//	fGeraTmp(cArquivo)

	//Carrega os dados na tabela temporario no BD
	Processa( {|| fLerArq(cTp01) } , "Aguarde, Processando Arquivo. Esta opera��o pode levar alguns minutos.")

	if cTp01 == "B"
		//Executa a conciliacao dos cartoes nas empresas carregadas
		For nX := 1 To Len(aEmpresas)

			FwMsgRun( ,{|| U_KMVENARQ(aEmpresas[nX],'01',cEmpOfic,lGeraSE2,cArqTrb,cArq01)  }, , "Aguarde, Conciliando arquivo de VENDA da empresa "+aEmpresas[nx] )

		Next
	else
		//Executa a conciliacao dos cartoes nas empresas carregadas
		For nX := 1 To Len(aEmpresas)

			FwMsgRun( ,{|| U_KMCONARQ(aEmpresas[nX],'01',cEmpOfic,lGeraSE2,cArqTrb,cArq01)  }, , "Aguarde, Conciliando arquivo de PAGAMENTO da empresa "+aEmpresas[nx] )

		Next
	endIf

	//Fecha o arquivo importado.
	If !FCLOSE(nHdl)
		MsgStop("Erro ao fechar arquivo, erro numero: " +  Alltrim(Str(fError())) ,"Atencao!")
	Endif

	// Fecha Area Se Estiver Aberta
	If Select(cArqTrb) > 0
		DbSelectArea(cArqTrb)
		DbCloseArea(cArqTrb)
	EndIf

	//Fecha tabela Temporaria.
	TcDelFile(cArqTrb)

	//Carrego todas arquivos textos do servidor
	aArqTemp := Directory(cDirServ+"*.LOG")

	// Copia do Servidor para a esta��o
	For nZa := 1 To Len(aArqTemp)
		CpyS2T(cDirServ+aArqTemp[nZa,1],cDirDocs,.T.)
	Next
	aEval(aArqTemp, {|x| FErase(cDirServ+x[1])})

	//Carrego todas arquivos textos da maquina local
	aArqLogs := Directory(cDirDocs+"*.LOG")

	//��������������Ŀ
	//�Monta Tela    �
	//����������������
	If Len(aArqLogs) > 0
		For nOpened := 1 To Len(aArqLogs)
			cArqImp := cDirLogs + Alltrim( aArqLogs[nOpened,1] )
			fImpTxt(cArqImp,aLogs)
		Next
	Endif
	fMntTela()

EndIF

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCadUsu       �Autor  �Microsiga       � Data �  10/07/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �															  ���
���          �                                                       	  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCadUsu()

	Local aArea		:= GetArea()
	Local lRet		:= .T.
	Local oAreaUsu		:= FWLayer():New()
	Local aCoordUsu		:= FWGetDialogSize(oMainWnd)

	Local cVldDel	:= "AllwaysFalse()"
	Local cVldDelT	:= "AllwaysFalse()"
	Local cVldLOk	:= "AllwaysTrue()"
	Local cVldTOk	:= "AllwaysTrue()"
	Local cFieldOk	:= "AllwaysTrue()"
	Local nStyle	:= GD_UPDATE

	Private aTamObj	:= Array(4)
	Private cCadastUsu	:= "Cadastro de Usu�rios X Perguntas"

	Private aHeadUsu	:= {}
	Private aColsUsu	:= {}

	aAdd(aHeadUsu,{"Usu�rio"				,"USUARIO"		,"@X"					,15 ,0 ,""				,"","C","","","","",,'V'})
	aAdd(aHeadUsu,{"C�digo"					,"CODIGOU"		,"@!"					,06 ,0 ,""				,"","C","","","","",,'V'})
	aAdd(aHeadUsu,{"Nome Usu�rio"			,"NOMEUSU"		,"@!"					,40 ,0 ,""				,"","C","","","","",,'V'})
	aAdd(aHeadUsu,{"Permiss�es"				,"PERMISS"		,"@!"					,06 ,0 ,"U_fValCmb()"	,"","C","","","1=SIM;2=N�O","",,'A'})
	aAdd(aHeadUsu,{""						,"BRANCO"		,"@!"					,01 ,0 ,""				,"","C","","","","",,'V'})

	SX5->(DbSeek(xFilial("SX5") + "_Q"))
	Do While SX5->X5_FILIAL + SX5->X5_TABELA = xFilial("SX5") + "_Q" .And. ! SX5->(Eof())
		nPosUser := aScan(aAllUser,{|x| x[2] == Alltrim(SX5->X5_CHAVE)})
		If ! Empty(nPosUser)
			Aadd(aColsUsu,{aAllUser[nPosUser,3],Alltrim(SX5->X5_CHAVE),aAllUser[nPosUser,4],Alltrim(SX5->X5_DESCRI),,.F.})
		EndIf
		SX5->(DbSkip())
	EndDo

	oTelaUsu := tDialog():New(aCoordUsu[1],aCoordUsu[2],aCoordUsu[3],aCoordUsu[4],OemToAnsi(cCadastUsu),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	oAreaUsu:Init(oTelaUsu,.F.)

	oAreaUsu:AddLine("L01",100,.T.)

	oAreaUsu:AddCollumn("L01DADOS"  ,020,.F.,"L01")
	oAreaUsu:AddCollumn("L01FOLDER" ,080,.F.,"L01")

	oAreaUsu:AddWindow("L01DADOS" ,"L01BOTOES" ,"Fun��es"										, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oAreaUsu:AddWindow("L01FOLDER","L01FOLD01" ,"Cadastro de Usu�rios x Perguntas"				, 100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)

	oPainBot2  := oAreaUsu:GetWinPanel("L01DADOS"  ,"L01BOTOES"	,"L01")
	oPainFol21 := oAreaUsu:GetWinPanel("L01FOLDER" ,"L01FOLD01"	,"L01")

	oGetUsu := MsNewGetDados():New(aCoordUsu[1],aCoordUsu[2],oPainFol21:nClientWidth/4,oPainFol21:nClientHeight/2,nStyle,cVldLOk,cVldTOk,,aCposUsu,0,9999,cFieldOk,cVldDelT,cVldDel,oPainFol21,@aHeadUsu,@aColsUsu,{|| })
	oGetUsu:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	aFill(aTamObj,0)
	DefTamObj(@aTamObj)
	aTamObj[3] := (oPainBot2:nClientWidth)
	aTamObj[4] := (oPainBot2:nClientHeight)

	DefTamObj(@aTamObj,000,000,-100,nAltBot,.T.,oPainBot2)
	oBotInc := tButton():New(aTamObj[1],aTamObj[2],"&Inclui Usu�rio",oPainBot2,{|| MsAguarde({||fIncUsu()},'Incluindo Usu�rio','Aguarde, Incluindo Usu�rio')},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| /*oBotGera:lActive := .T.*/ })

	DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBotCanc2 := tButton():New(aTamObj[1],aTamObj[2],"&Fecha",oPainBot2,{|| oTelaUsu:End()},aTamObj[3],aTamObj[4],,,,.T.,,,,{|| })

	oTelaUsu:Activate(,,,.T.,/*valid*/,,{|| })

	If SX5->(DbSeek(xFilial("SX5") + "_Q" +__cUserID))
		if	Alltrim(SX5->X5_DESCRI)=="1"
			lChbk := .T.
		else
			lChbk := .F.
		endIf
	EndIf

	RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fIncUsu       �Autor  �Microsiga       � Data �  10/07/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �															  ���
���          �                                                       	  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fIncUsu()

	Local aArea		:= GetArea()
	Local oDlg
	Local cTitle	:= 'Usuarios do Sistema'
	Local cPesq		:= SPACE(50)
	Local aList		:= {}
	Local cList		:= 0
	Local oBold
	Local oList
	Local aGroup	:= {}
	Local aCodigo	:= {}
	Local cRetorno	:= ''
	Local nOpc		:= 0
	Local lRet		:= .T.
	Local nTodos,cSeek
	Local nx

	For nX:=1 To Len(aAllUser)
		Aadd(aList,aAllUser[nX,3])
		Aadd(aCodigo,{aAllUser[nX,3],aAllUser[nX,2],aAllUser[nX,4]})
	Next nX

	aSort(aList)

	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg FROM 114,180 TO 335,600 TITLE cTitle Of oMainWnd PIXEL

		@ 0, 0 BITMAP oBmp RESNAME "PROJETOAP" oF oDlg SIZE 90,255 NOBORDER WHEN .F. PIXEL
		@ 12,60 TO 14,400 Label '' Of oDlg PIXEL
		@ 4  ,66   SAY 'Selecione o Usuario:' Of oDlg PIXEL SIZE 120,9 FONT oBold
		@ 77, 70 SAY 'Pesquisar' of oDlg PIXEL SIZE 30,9
		@ 18,70 LISTBOX oList VAR cList ITEMS aList PIXEL SIZE 127,56 OF oDlg ON DBLCLICK (If(!Empty(cList),(nOpc:=1,oDlg:End()),))
		oList:bChange := {||nList := oList:nAT}

		@ 76, 96 MSGET cPesq VALID If(aScan(aList,{|x| x=Alltrim(cPesq)})>0,;
	   								((oList:nAT :=aScan(aList,{|x| x=Alltrim(cPesq)})),(oList:Refresh())),Nil)  of oDlg PIXEL SIZE 100,9

	    @ 95,155 BUTTON '&Confirma >> '  SIZE 40 ,10  FONT oDlg:oFont ACTION If(!Empty(cList),(nOpc:=1,oDlg:End()),)  OF oDlg PIXEL
	    @ 95,110 BUTTON '<< Ca&ncelar' SIZE 40,10  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpc == 1
		nPosCod		:= aScan(aCodigo,{|x|x[1] == aList[nList]})
		cLogin		:= aCodigo[nPosCod][1]
		cCodUser	:= aCodigo[nPosCod][2]
		cUserNom	:= aCodigo[nPosCod][3]

		If ! Empty(aScan(aColsUsu,{|x|x[2] == cCodUser}))
			MsgAlert("Usu�rio j� cadastrado")
		Else
			nPosUser := aScan(aAllUser,{|x| x[2] == cCodUser})
			If ! Empty(nPosUser)
				Aadd(aColsUsu,{aAllUser[nPosUser,3],cCodUser,aAllUser[nPosUser,4],Space(6),,.F.})
			EndIf
			oGetUsu:SetArray(aColsUsu)
			oGetUsu:Refresh()
			RecLock("SX5",.T.)
			SX5->X5_FILIAL	:= xFilial("SX5")
			SX5->X5_TABELA	:= "_Q"
			SX5->X5_CHAVE	:= cCodUser
			SX5->X5_DESCRI	:= Space(6)
			SX5->X5_DESCSPA	:= cLogin
			SX5->X5_DESCENG := cUserNom
			SX5->(MsUnlock())
			lRet  := .T.
		EndIf
	EndIf

	RestArea(aArea)

Return lRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGeraTMP   �Autor  �                   � Data �  02/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera arquivo temporario fGeraTMP atraves do arquivo XXX     ���
���          �importado atraves do comando APPEND						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function fGeraTMP(cArquivo,cTpArq)

Local aCpoTMP	:= {}
Local aCampos	:= {}

if cTpArq == "B"
	AADD(aCpoTMP, {"B01"		,"C", 03, 0}) // CABECALHO
	AADD(aCpoTMP, {"COD_ERP"	,"C",100, 0}) // COD_ERP
	AADD(aCpoTMP, {"LOJA_FIL"	,"C", 30, 0}) // LOJA_FILIAL
	AADD(aCpoTMP, {"ESTAB"		,"C",100, 0}) // ESTABELECIMENTO
	AADD(aCpoTMP, {"NRO_PARC"	,"C",100, 0}) // NRO_PARCELA
	AADD(aCpoTMP, {"ADQUIREN"	,"C",100, 0}) // ADQUIRENTE
	AADD(aCpoTMP, {"BANDEIRA"	,"C",255, 0}) // BANDEIRA
	AADD(aCpoTMP, {"TIPO_TRA"	,"C",100, 0}) // TIPO_TRANSACAO
	AADD(aCpoTMP, {"TRACKID"	,"C", 20, 0}) // TRACK ID
	AADD(aCpoTMP, {"NSU"		,"C", 30, 0}) // NSU
	AADD(aCpoTMP, {"AUTORIZA"	,"C",100, 0}) // AUTORIZACAO
	AADD(aCpoTMP, {"DT_VENDA"	,"D", 08, 0}) // DATA VENDA
	AADD(aCpoTMP, {"DT_PRVPGT"	,"D", 12, 0}) // DATA PREV PAGTO
	AADD(aCpoTMP, {"VLR_BRUTO"	,"N", 12, 2}) // VALOR BRUTO
	AADD(aCpoTMP, {"VLR_LIQ_"	,"N", 12, 2}) // VALOR LIQUIDO
	AADD(aCpoTMP, {"TAXA"		,"N", 12, 2}) // VALOR TAXA
	AADD(aCpoTMP, {"STATUS"		,"C", 01, 0}) // STATUS
	AADD(aCpoTMP, {"TID"		,"C",100, 0}) // TID
	AADD(aCpoTMP, {"TERMINAL"	,"C",100, 0}) // TERMINAL
	AADD(aCpoTMP, {"MASC_CARD"	,"C", 60, 0}) // MASCARA CARTAO
	AADD(aCpoTMP, {"NRO_RO"		,"C",100, 0}) // NUMERO RESUMO OPER
	AADD(aCpoTMP, {"NOME_ARQ"	,"C",100, 0}) // NOME DO ARQUIVO
else
	AADD(aCpoTMP, {"C01"		,"C", 03, 0}) // CABECALHO
	AADD(aCpoTMP, {"COD_ERP"	,"C",100, 0}) // COD_ERP
	AADD(aCpoTMP, {"LOJA_FIL"	,"C", 30, 0}) // LOJA_FILIAL
	AADD(aCpoTMP, {"ESTAB"		,"C",100, 0}) // ESTABELECIMENTO
	AADD(aCpoTMP, {"TIPO_LAN"	,"C",100, 0}) // TIPO_LANCAMENTO
	AADD(aCpoTMP, {"DESCRICA"	,"C", 10, 0}) // DESCRICAO
	AADD(aCpoTMP, {"NRO_PARC"	,"C",100, 0}) // NRO_PARCELA
	AADD(aCpoTMP, {"ADQUIREN"	,"C",100, 0}) // ADQUIRENTE
	AADD(aCpoTMP, {"BANDEIRA"	,"C",255, 0}) // BANDEIRA
	AADD(aCpoTMP, {"TIPO_TRA"	,"C",100, 0}) // TIPO_TRANSACAO
	AADD(aCpoTMP, {"TRACKID"	,"C", 20, 0}) // TRACK ID
	AADD(aCpoTMP, {"NSU"		,"C", 30, 0}) // NSU
	AADD(aCpoTMP, {"AUTORIZA"	,"C",100, 0}) // AUTORIZACAO
	AADD(aCpoTMP, {"DT_PAGAM"	,"D", 08, 0}) // DT_PAGAMENTO
	AADD(aCpoTMP, {"VLR_PAGO"	,"N", 12, 2}) // VLR_PAGO
	AADD(aCpoTMP, {"TAXA"		,"N", 12, 2}) // TAXA
	AADD(aCpoTMP, {"STATUS"		,"C", 01, 0}) // STATUS
	AADD(aCpoTMP, {"REFER1"		,"C",100, 0}) // REFER1
	AADD(aCpoTMP, {"REFER2"		,"C",100, 0}) // REFER2
	AADD(aCpoTMP, {"NRO_ANTEC"	,"C",100, 0}) // NRO_ANTECIPACAO
	AADD(aCpoTMP, {"VLR_DESC_"	,"N", 12, 2}) // VLR_DESC_ANTECIP
	AADD(aCpoTMP, {"NRO_BANCO"	,"C",100, 0}) // NRO_BANCO
	AADD(aCpoTMP, {"NRO_AGENC"	,"C",100, 0}) // NRO_AGENCIA
	AADD(aCpoTMP, {"NRO_CONTA"	,"C",100, 0}) // NRO_CONTA
	AADD(aCpoTMP, {"TID"		,"C",100, 0}) // TID
	AADD(aCpoTMP, {"TERMINAL"	,"C",100, 0}) // TERMINAL
	AADD(aCpoTMP, {"DT_VENDA"	,"D", 08, 0}) // DATA VENDA
	AADD(aCpoTMP, {"MASC_CARD"	,"C", 60, 0}) // MASCARA CARTAO
	AADD(aCpoTMP, {"NRO_RO"		,"C",100, 0}) // NUMERO RESUMO OPER
	AADD(aCpoTMP, {"NRO_RO_AJ"	,"C",100, 0}) // NUMERO RESUMO OPER AJUSTE
	AADD(aCpoTMP, {"NOME_ARQ"	,"C",100, 0}) // NOME DO ARQUIVO
	AADD(aCpoTMP, {"VLR_MKP"	,"N", 12, 2}) // VALOR MARKUP
	AADD(aCpoTMP, {"VLR_SCHEM"	,"N", 12, 2}) // VALOR SCHEME FEE
	AADD(aCpoTMP, {"VLR_INTER"	,"N", 12, 2}) // VALOR INTERCHANGE
	AADD(aCpoTMP, {"VLR_COMIS"	,"N", 12, 2}) // VALOR COMISSAO
endIf

DBCreate(cArqTrb,aCpoTMP,"TOPCONN")

// Fecha Area Se Estiver Aberta
If Select(cArqTrb) > 0
	DbSelectArea(cArqTrb)
	DbCloseArea(cArqTrb)
EndIf

DbUseArea(.T.,"TOPCONN",cArqTrb,cArqTrb,.T.,.F.)
DbCreateIndex(cArqTrb+"1","COD_ERP",{|| COD_ERP },.F.)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fLerArq   � Autor �        TOTVS          � Data � 16/07/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Faz a leitura do arquivo e realiza a baixa dos titulos.    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fLerArq(cType)

Local aTitulos 	:= {}
Local cLoja_Fil := ""
Local cBuffer

if cType == "B"

	FT_FGOTOP()
	ProcRegua(FT_FLASTREC())

	While !FT_FEOF()

		//����������������������������������������������������������������Ŀ
		//� Leitura do arquivo texto.                                      �
		//������������������������������������������������������������������
		cBuffer  := FT_FREADLN()
		aTitulos := Separa(cBuffer , ";")

		//���������������������������������������������������������`�
		//�Desconsiderar registros do Header (C01) e Trailler (C03)�
		//���������������������������������������������������������`�
		If Alltrim(aTitulos[1]) $ "B01;B03"
			FT_FSKIP(1)
			Loop
		Endif

		IncProc()

		cLoja_Fil := StrTran(aTitulos[03],"CAIXA - ","")

		If Alltrim(aTitulos[07])=="ALG"
			FT_FSKIP(1)
			Loop
		Endif

		RecLock(cArqTrb,.T.)

		REPLACE B01			WITH aTitulos[01]
		REPLACE COD_ERP		WITH aTitulos[02]
		REPLACE LOJA_FIL	WITH cLoja_Fil
		REPLACE ESTAB		WITH aTitulos[04]
		REPLACE NRO_PARC	WITH aTitulos[05]
		REPLACE ADQUIREN	WITH aTitulos[06]
		REPLACE BANDEIRA	WITH aTitulos[07]
		REPLACE TIPO_TRA	WITH aTitulos[08]
		REPLACE TRACKID		WITH aTitulos[09]
		REPLACE NSU			WITH aTitulos[10]
		REPLACE AUTORIZA	WITH aTitulos[11]
		REPLACE DT_VENDA	WITH Ctod(atitulos[12])
		REPLACE DT_PRVPGT	WITH Ctod(atitulos[13])
		REPLACE VLR_BRUTO	WITH fRetVal(aTitulos[14])
		REPLACE VLR_LIQ_	WITH fRetVal(aTitulos[15])
		REPLACE TAXA		WITH fRetVal(aTitulos[16])
		REPLACE STATUS		WITH aTitulos[17]
		REPLACE TID			WITH aTitulos[18]
		REPLACE TERMINAL	WITH aTitulos[19]
		REPLACE MASC_CARD	WITH aTitulos[20]
		REPLACE NRO_RO		WITH aTitulos[21]
		REPLACE NOME_ARQ	WITH aTitulos[22]

		MsUnLock()

		nPos := Ascan( aEmpresas , cLoja_Fil )
		If nPos==0
			AAdd( aEmpresas , cLoja_Fil )
		Endif

		FT_FSKIP(1)
	EndDo

else

	FT_FGOTOP()
	ProcRegua(FT_FLASTREC())

	While !FT_FEOF()

		//����������������������������������������������������������������Ŀ
		//� Leitura do arquivo texto.                                      �
		//������������������������������������������������������������������
		cBuffer  := FT_FREADLN()
		aTitulos := Separa(cBuffer , ";")

		//���������������������������������������������������������`�
		//�Desconsiderar registros do Header (C01) e Trailler (C03)�
		//���������������������������������������������������������`�
		If Alltrim(aTitulos[1]) $ "C01;C03"
			FT_FSKIP(1)
			Loop
		Endif

		IncProc()

		cLoja_Fil := StrTran(aTitulos[03],"CAIXA - ","")

		If Alltrim(aTitulos[05])=="ALG"
			FT_FSKIP(1)
			Loop
		Endif

		RecLock(cArqTrb,.T.)

		REPLACE C01			WITH aTitulos[01]
		REPLACE COD_ERP		WITH aTitulos[02]
		REPLACE LOJA_FIL	WITH cLoja_Fil
		REPLACE ESTAB		WITH aTitulos[04]
		REPLACE TIPO_LAN	WITH aTitulos[05]
		REPLACE DESCRICA	WITH aTitulos[06]
		REPLACE NRO_PARC	WITH aTitulos[07]
		REPLACE ADQUIREN	WITH aTitulos[08]
		REPLACE BANDEIRA	WITH aTitulos[09]
		REPLACE TIPO_TRA	WITH aTitulos[10]
		REPLACE TRACKID		WITH aTitulos[11]
		REPLACE NSU			WITH aTitulos[12]
		REPLACE AUTORIZA	WITH aTitulos[13]
		REPLACE DT_PAGAM	WITH Ctod(atitulos[14])
		REPLACE VLR_PAGO	WITH fRetVal(aTitulos[15])
		REPLACE TAXA		WITH fRetVal(aTitulos[16])
		REPLACE STATUS		WITH aTitulos[17]
		REPLACE REFER1		WITH aTitulos[18]
		REPLACE REFER2		WITH aTitulos[19]
		REPLACE NRO_ANTEC	WITH aTitulos[20]
		REPLACE VLR_DESC_	WITH fRetVal(aTitulos[21])
		REPLACE NRO_BANCO	WITH aTitulos[22]
		REPLACE NRO_AGENC	WITH aTitulos[23]
		REPLACE NRO_CONTA	WITH aTitulos[24]
		REPLACE TID			WITH aTitulos[25]
		REPLACE TERMINAL	WITH aTitulos[26]
		REPLACE DT_VENDA	WITH Ctod(aTitulos[27])
		REPLACE MASC_CARD	WITH aTitulos[28]
		REPLACE NRO_RO		WITH aTitulos[29]
		REPLACE NRO_RO_AJ	WITH aTitulos[30]
		REPLACE NOME_ARQ	WITH aTitulos[31]
		REPLACE VLR_MKP		WITH fRetVal(aTitulos[32])
		REPLACE VLR_SCHEM	WITH fRetVal(aTitulos[33])
		REPLACE VLR_INTER	WITH fRetVal(aTitulos[34])
		REPLACE VLR_COMIS	WITH fRetVal(aTitulos[35])

		MsUnLock()

		nPos := Ascan( aEmpresas , cLoja_Fil )
		If nPos==0
			AAdd( aEmpresas , cLoja_Fil )
		Endif

		FT_FSKIP(1)
	EndDo

endIf
//������������������������������Ŀ
//�Ordena o vetor das empresas   �
//��������������������������������
aEmpresas := ASort(aEmpresas, , , {|x,y|x < y})

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � KMCONARQ � Autor �         TOTVS         � Data � 16/07/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Faz a conciliacao dos cartoes conforme registros lido no   ���
���          � arquivo importado.                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function KMCONARQ(cEmpresa,cFil,cEmpOfic,lGeraSE2,cArqTrb,cArq01)

Local aArea  	:= GetArea()
Local cAlias 	:= GetNextAlias()
Local nValor	:= 0
Local nVlrTX	:= 0
Local cQuery	:= ""
Local cBanco	:= ""
Local cAgencia  := ""
Local cConta    := ""
Local cTpPagto	:= ""
Local cEmpAtu	:= ""
Local cPrefixo	:= ""
Local cNumero	:= ""
Local cParcela	:= ""
Local cTipo		:= ""
Local cCliente	:= ""
Local cLoja		:= ""
Local cChave	:= ""
Local cDirServ	:= "\importacao\"
Local lBcoOk	:= .T.
Local aAdmFin	:= {}

nHandle := MsfCreate(cDirServ+"CONCILIACAO_"+Dtos(Date())+"_FILIAL_"+cEmpresa+".LOG",0)

fWrite(nHandle	,	"OPERACAO"			+ ";" )	// 01
fWrite(nHandle	,	"TIPO_LANCAMENTO"	+ ";" )	// 02
fWrite(nHandle	,	"LOJA_FIL"			+ ";" )	// 03
fWrite(nHandle	,	"COD_ERP"			+ ";" )	// 04
fWrite(nHandle	,	"BANDEIRA"			+ ";" )	// 05
fWrite(nHandle	,	"TIPO_TRANSACAO"	+ ";" )	// 06
fWrite(nHandle	,	"AUTORIZACAO"		+ ";" )	// 07
fWrite(nHandle	,	"PARCELA"			+ ";" )	// 08
fWrite(nHandle	,	"DT_BAIXA"			+ ";" )	// 09
fWrite(nHandle	,	"VALOR"				+ ";" )	// 10
fWrite(nHandle	,	"ID_REGISTRO"		+ ";" )	// 11
fWrite(nHandle	,	"OCORRENCIA"		+ ";" )	// 12
fWrite(nHandle	,	CRLF )

cQuery := " SELECT * FROM "+cArqTrb+" TMP WHERE LOJA_FIL = '"+cEmpresa+"' ORDER BY LOJA_FIL "
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())

	lBcoOk	 := .T.
	cBanco 	 := PADR( (cAlias)->NRO_BANCO  , 3 )
	cAgencia := Strzero( Val( (cAlias)->NRO_AGENC ) , 4 )
	cConta 	 := Alltrim( Str( Val( (cAlias)->NRO_CONTA ) ) )

	lBcoOk 	 := fValSA6(cEmpAnt , @cBanco , @cAgencia , @cConta  )

	//���������������������������������������������Ŀ
	//�Valida a existencia do banco, agencia e conta�
	//�����������������������������������������������

	dbSelectArea("ZK3")
	ZK3->(dbSetOrder(5))
	ZK3->(dbGoTop())
	If !lBcoOk
		Conout("BANCO NAO ENCONTRADO "+cBanco +" "+ cAgencia +" "+ cConta)

		//Grava registros com erros no arquivo
		fWrite(nHandle	,	'PAGAMENTO'									+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
		fWrite(nHandle	,	""											+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->AUTORIZA)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->NRO_PARC)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->DT_PAGAM)			+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->VLR_PAGO)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->TRACKID)						+ ";" )
		fWrite(nHandle	,	"Conta n�o cadastrada: "+cBanco+"/"+cAgencia+"/"+cConta+";" )
		fWrite(nHandle	,	CRLF )

		If ZK3->(dbSeek(xFilial("ZK3") + (cAlias)->TIPO_LAN + (cAlias)->TRACKID))

			RecLock("ZK3",.F.)
				REPLACE ZK3_FILIAL	WITH cEmpAnt
				REPLACE ZK3_TPREG	WITH (cAlias)->C01
				REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
				REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
				REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
				REPLACE ZK3_TPLAN	WITH (cAlias)->TIPO_LAN
				REPLACE ZK3_DESC	WITH (cAlias)->DESCRICA
				REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
				REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
				REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
				REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
				REPLACE ZK3_NSU		WITH (cAlias)->NSU
				REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
				REPLACE ZK3_DTPGTO	WITH Ctod((cAlias)->DT_PAGAM)
				REPLACE ZK3_VLRPAG	WITH (cAlias)->VLR_PAGO
				REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
				REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
				REPLACE ZK3_REF1	WITH (cAlias)->REFER1
				REPLACE ZK3_REF2	WITH (cAlias)->REFER2
				REPLACE ZK3_NRANT	WITH (cAlias)->NRO_ANTEC
				REPLACE ZK3_VLRANT	WITH (cAlias)->VLR_DESC_
				REPLACE ZK3_BANCO	WITH (cAlias)->NRO_BANCO
				REPLACE ZK3_AGENC	WITH (cAlias)->NRO_AGENC
				REPLACE ZK3_CONTA	WITH (cAlias)->NRO_CONTA
				REPLACE ZK3_TID		WITH (cAlias)->TID
				REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
				REPLACE ZK3_DTVEN  	WITH Ctod((cAlias)->DT_VENDA)
				REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
				REPLACE ZK3_FILE	WITH cArq01
				REPLACE ZK3_OBS		WITH "Conta n�o cadastrada: "+cBanco+"/"+cAgencia+"/"+cConta
			MsUnLock()

		else

			RecLock("ZK3",.T.)
				REPLACE ZK3_FILIAL	WITH cEmpAnt
				REPLACE ZK3_TPREG	WITH (cAlias)->C01
				REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
				REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
				REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
				REPLACE ZK3_TPLAN	WITH (cAlias)->TIPO_LAN
				REPLACE ZK3_DESC	WITH (cAlias)->DESCRICA
				REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
				REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
				REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
				REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
				REPLACE ZK3_NSU		WITH (cAlias)->NSU
				REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
				REPLACE ZK3_DTPGTO	WITH Ctod((cAlias)->DT_PAGAM)
				REPLACE ZK3_VLRPAG	WITH nValor
				REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
				REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
				REPLACE ZK3_REF1	WITH (cAlias)->REFER1
				REPLACE ZK3_REF2	WITH (cAlias)->REFER2
				REPLACE ZK3_NRANT	WITH (cAlias)->NRO_ANTEC
				REPLACE ZK3_VLRANT	WITH (cAlias)->VLR_DESC_
				REPLACE ZK3_BANCO	WITH (cAlias)->NRO_BANCO
				REPLACE ZK3_AGENC	WITH (cAlias)->NRO_AGENC
				REPLACE ZK3_CONTA	WITH (cAlias)->NRO_CONTA
				REPLACE ZK3_TID		WITH (cAlias)->TID
				REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
				REPLACE ZK3_DTVEN  	WITH Ctod((cAlias)->DT_VENDA)
				REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
				REPLACE ZK3_FILE	WITH cArq01
				REPLACE ZK3_OBS		WITH "Conta n�o cadastrada: "+cBanco+"/"+cAgencia+"/"+cConta
			MsUnLock()

		endIf

		(cAlias)->(DbSkip())
		Loop
	Endif

	cTpPagto 	:= Alltrim((cAlias)->TIPO_LAN)
	cChave	 	:= Alltrim((cAlias)->COD_ERP)
	cFilAtu		:= xFilial("SE1")

	cPrefixo	:= ""
	cNumero		:= ""
	cParcela	:= ""
	cTipo		:= ""
	cCliente	:= ""
	cLoja		:= ""

	if len(cChave) > 12
		cPrefixo	:= SubStr(cChave,01,3)
		cNumero		:= SubStr(cChave,04,9)
		cParcela	:= SubStr(cChave,13,2)
		cTipo		:= SubStr(cChave,16,3)

		cParcela 	:= iif(len(Alltrim(cNumero))==9,cParcela,aParc[val(cParcela)])
	endif


	nValor		:= (cAlias)->VLR_PAGO

	If !Empty( cChave )

		lOk  := .F.
		lOk1 := .F.

		dbSelectArea("SE1")
		SE1->(DbSetOrder(1))
		SE1->(dbGoTop())

		If SE1->(DbSeek( xFilial("SE1") + cPrefixo + cNumero + PADR(cParcela,TAMSX3("E1_PARCELA")[1]) + PADR(cTipo,TAMSX3("E1_TIPO")[1])))

			cCliente:= SE1->E1_CLIENTE
			cLoja	:= SE1->E1_LOJA

			//����������������������������������������������������������������������������������������Ŀ
			//�Executa a baixa do Titulo quando o tipo de pagamento iniciar com a letra "P" (Pagamento)�
			//������������������������������������������������������������������������������������������
			If Left(cTpPagto,1)=="P" .And. Empty(SE1->E1_BAIXA)

				_nSaldo   :=  SE1->E1_SALDO + SE1->E1_ACRESC - SE1->E1_DECRESC //- _nTotAbat

				_nValTX   := _nSaldo - nValor

				lOk := fBaixaSE1(SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,cBanco,cAgencia,cConta,(cAlias)->DT_PAGAM,_nSaldo)

				If lOk
					CONOUT('TITULO_BAIXADO '+SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)

					//Grava registros com erros no arquivo
					fWrite(nHandle	,	'PAGAMENTO'									+ ";" )
					fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
					fWrite(nHandle	,	""											+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->AUTORIZA)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->NRO_PARC)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->DT_PAGAM)			+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->VLR_PAGO)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->TRACKID)					+ ";" )
					fWrite(nHandle	,	"Titulo baixado"							+ ";" )
					fWrite(nHandle	,	CRLF )

					cLogTXA := fBxTaxa( _nValTX, dDatabase, cBanco,cAgencia,cConta )

					//Grava registros com erros no arquivo
					fWrite(nHandle	,	'PAGAMENTO'									+ ";" )
					fWrite(nHandle	,	"TXA"										+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
					fWrite(nHandle	,	""											+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->AUTORIZA)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->NRO_PARC)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->DT_PAGAM)			+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->VLR_PAGO)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->TRACKID)					+ ";" )
					fWrite(nHandle	,	cLogTXA										+ ";" )
					fWrite(nHandle	,	CRLF )

					(cAlias)->(DbSkip())
					Loop
				Else

					//Grava registros com erros no arquivo
					fWrite(nHandle	,	'PAGAMENTO'									+ ";" )
					fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
					fWrite(nHandle	,	""											+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->AUTORIZA)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->NRO_PARC)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->DT_PAGAM)			+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->VLR_PAGO)					+ ";" )
					fWrite(nHandle	,	Alltrim((cAlias)->TRACKID)					+ ";" )
					fWrite(nHandle	,	"Problema na Baixa"							+ ";" )
					fWrite(nHandle	,	CRLF )
					If ZK3->(dbSeek(xFilial("ZK3") + (cAlias)->TIPO_LAN + (cAlias)->TRACKID))

						RecLock("ZK3",.F.)
							REPLACE ZK3_FILIAL	WITH cEmpAnt
							REPLACE ZK3_TPREG	WITH (cAlias)->C01
							REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
							REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
							REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
							REPLACE ZK3_TPLAN	WITH (cAlias)->TIPO_LAN
							REPLACE ZK3_DESC	WITH (cAlias)->DESCRICA
							REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
							REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
							REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
							REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
							REPLACE ZK3_NSU		WITH (cAlias)->NSU
							REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
							REPLACE ZK3_DTPGTO	WITH Ctod((cAlias)->DT_PAGAM)
							REPLACE ZK3_VLRPAG	WITH (cAlias)->VLR_PAGO
							REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
							REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
							REPLACE ZK3_REF1	WITH (cAlias)->REFER1
							REPLACE ZK3_REF2	WITH (cAlias)->REFER2
							REPLACE ZK3_NRANT	WITH (cAlias)->NRO_ANTEC
							REPLACE ZK3_VLRANT	WITH (cAlias)->VLR_DESC_
							REPLACE ZK3_BANCO	WITH (cAlias)->NRO_BANCO
							REPLACE ZK3_AGENC	WITH (cAlias)->NRO_AGENC
							REPLACE ZK3_CONTA	WITH (cAlias)->NRO_CONTA
							REPLACE ZK3_TID		WITH (cAlias)->TID
							REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
							REPLACE ZK3_DTVEN  	WITH Ctod((cAlias)->DT_VENDA)
							REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
							REPLACE ZK3_FILE	WITH cArq01
							REPLACE ZK3_OBS		WITH "Problema na Baixa"
						MsUnLock()

					else

						RecLock("ZK3",.T.)
							REPLACE ZK3_FILIAL	WITH cEmpAnt
							REPLACE ZK3_TPREG	WITH (cAlias)->C01
							REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
							REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
							REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
							REPLACE ZK3_TPLAN	WITH (cAlias)->TIPO_LAN
							REPLACE ZK3_DESC	WITH (cAlias)->DESCRICA
							REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
							REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
							REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
							REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
							REPLACE ZK3_NSU		WITH (cAlias)->NSU
							REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
							REPLACE ZK3_DTPGTO	WITH Ctod((cAlias)->DT_PAGAM)
							REPLACE ZK3_VLRPAG	WITH nValor
							REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
							REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
							REPLACE ZK3_REF1	WITH (cAlias)->REFER1
							REPLACE ZK3_REF2	WITH (cAlias)->REFER2
							REPLACE ZK3_NRANT	WITH (cAlias)->NRO_ANTEC
							REPLACE ZK3_VLRANT	WITH (cAlias)->VLR_DESC_
							REPLACE ZK3_BANCO	WITH (cAlias)->NRO_BANCO
							REPLACE ZK3_AGENC	WITH (cAlias)->NRO_AGENC
							REPLACE ZK3_CONTA	WITH (cAlias)->NRO_CONTA
							REPLACE ZK3_TID		WITH (cAlias)->TID
							REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
							REPLACE ZK3_DTVEN  	WITH Ctod((cAlias)->DT_VENDA)
							REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
							REPLACE ZK3_FILE	WITH cArq01
							REPLACE ZK3_OBS		WITH "Problema na Baixa"
						MsUnLock()

					endIf
					(cAlias)->(DbSkip())
					Loop
				Endif
			Else
				CONOUT(If(Left(cTpPagto,1)=="P",'BAIXADO_ANTERIORMENTE ','INCLUIDO_ANTERIORMENTE ')+cFilAtu + cPrefixo + cNumero + cParcela + cTipo + cCLiente+cLoja )

				//Grava registros com erros no arquivo
				fWrite(nHandle	,	'PAGAMENTO'									+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
				fWrite(nHandle	,	""											+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->AUTORIZA)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->NRO_PARC)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->DT_PAGAM)			+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->VLR_PAGO)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->TRACKID)					+ ";" )
				fWrite(nHandle	,	IIf(Left(cTpPagto,1)=="P",'BAIXADO_ANTERIORMENTE','INCLUIDO_ANTERIORMENTE')	+ ";" )
				fWrite(nHandle	,	CRLF )

				(cAlias)->(DbSkip())
				Loop
			Endif

			//����������������������������������������������������������������������������������������Ŀ
			//�Executa a inclusao do Titulo quando o tipo de pagamento iniciar com a letra "C" ou "E!  �
			//������������������������������������������������������������������������������������������
			If Left(cTpPagto,1)$"C|E"

				nValor := nValor *-1

				//Grava registros com erros no arquivo
				fWrite(nHandle	,	'CREDITO'									+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
				fWrite(nHandle	,	""											+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->AUTORIZA)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->NRO_PARC)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->DT_PAGAM)			+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->VLR_PAGO)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->TRACKID)					+ ";" )
				fWrite(nHandle	,	"Estorno/Cancelamento/Ajuste j� registrado anteriormente."	+ ";" )
				fWrite(nHandle	,	CRLF )

				If ZK3->(dbSeek(xFilial("ZK3") + (cAlias)->TIPO_LAN + (cAlias)->TRACKID))

					RecLock("ZK3",.F.)

						REPLACE ZK3_FILIAL	WITH cEmpAnt
						REPLACE ZK3_TPREG	WITH (cAlias)->C01
						REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
						REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
						REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
						REPLACE ZK3_TPLAN	WITH (cAlias)->TIPO_LAN
						REPLACE ZK3_DESC	WITH (cAlias)->DESCRICA
						REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
						REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
						REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
						REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
						REPLACE ZK3_NSU		WITH (cAlias)->NSU
						REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
						REPLACE ZK3_DTPGTO	WITH Ctod((cAlias)->DT_PAGAM)
						REPLACE ZK3_VLRPAG	WITH nValor
						REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
						REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
						REPLACE ZK3_REF1	WITH (cAlias)->REFER1
						REPLACE ZK3_REF2	WITH (cAlias)->REFER2
						REPLACE ZK3_NRANT	WITH (cAlias)->NRO_ANTEC
						REPLACE ZK3_VLRANT	WITH (cAlias)->VLR_DESC_
						REPLACE ZK3_BANCO	WITH (cAlias)->NRO_BANCO
						REPLACE ZK3_AGENC	WITH (cAlias)->NRO_AGENC
						REPLACE ZK3_CONTA	WITH (cAlias)->NRO_CONTA
						REPLACE ZK3_TID		WITH (cAlias)->TRACKID
						REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
						REPLACE ZK3_DTVEN  	WITH Ctod((cAlias)->DT_VENDA)
						REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
						REPLACE ZK3_FILE	WITH cArq01
						REPLACE ZK3_OBS		WITH "Charge Back"

					MsUnLock()

				Else

					RecLock("ZK3",.T.)

						REPLACE ZK3_FILIAL	WITH cEmpAnt
						REPLACE ZK3_TPREG	WITH (cAlias)->C01
						REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
						REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
						REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
						REPLACE ZK3_TPLAN	WITH (cAlias)->TIPO_LAN
						REPLACE ZK3_DESC	WITH (cAlias)->DESCRICA
						REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
						REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
						REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
						REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
						REPLACE ZK3_NSU		WITH (cAlias)->NSU
						REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
						REPLACE ZK3_DTPGTO	WITH Ctod((cAlias)->DT_PAGAM)
						REPLACE ZK3_VLRPAG	WITH nValor
						REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
						REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
						REPLACE ZK3_REF1	WITH (cAlias)->REFER1
						REPLACE ZK3_REF2	WITH (cAlias)->REFER2
						REPLACE ZK3_NRANT	WITH (cAlias)->NRO_ANTEC
						REPLACE ZK3_VLRANT	WITH (cAlias)->VLR_DESC_
						REPLACE ZK3_BANCO	WITH (cAlias)->NRO_BANCO
						REPLACE ZK3_AGENC	WITH (cAlias)->NRO_AGENC
						REPLACE ZK3_CONTA	WITH (cAlias)->NRO_CONTA
						REPLACE ZK3_TID		WITH (cAlias)->TRACKID
						REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
						REPLACE ZK3_DTVEN  	WITH Ctod((cAlias)->DT_VENDA)
						REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
						REPLACE ZK3_FILE	WITH cArq01
						REPLACE ZK3_OBS		WITH "Charge Back"

					MsUnLock()

				EndIf
				(cAlias)->(DbSkip())
				Loop
			Endif

		Else
			CONOUT('TITULO_NAO_ENCONTRADO '+cFilAtu+cPrefixo+cNumero+cParcela+cTipo+cCliente+cLoja )

			//Grava registros com erros no arquivo
			fWrite(nHandle	,	'PAGAMENTO'									+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)					+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
			fWrite(nHandle	,	""											+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->AUTORIZA)					+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->NRO_PARC)					+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->DT_PAGAM) 				+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->VLR_PAGO)					+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->TRACKID)					+ ";" )
			fWrite(nHandle	,	"Registro n�o encontrado no sistema"		+ ";" )
			fWrite(nHandle	,	CRLF )

			If ZK3->(dbSeek(xFilial("ZK3") + (cAlias)->TIPO_LAN + (cAlias)->TRACKID))

				RecLock("ZK3",.F.)

					REPLACE ZK3_FILIAL	WITH cEmpAnt
					REPLACE ZK3_TPREG	WITH (cAlias)->C01
					REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
					REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
					REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
					REPLACE ZK3_TPLAN	WITH (cAlias)->TIPO_LAN
					REPLACE ZK3_DESC	WITH (cAlias)->DESCRICA
					REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
					REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
					REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
					REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
					REPLACE ZK3_NSU		WITH (cAlias)->NSU
					REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
					REPLACE ZK3_DTPGTO	WITH Ctod((cAlias)->DT_PAGAM)
					REPLACE ZK3_VLRPAG	WITH nValor
					REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
					REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
					REPLACE ZK3_REF1	WITH (cAlias)->REFER1
					REPLACE ZK3_REF2	WITH (cAlias)->REFER2
					REPLACE ZK3_NRANT	WITH (cAlias)->NRO_ANTEC
					REPLACE ZK3_VLRANT	WITH (cAlias)->VLR_DESC_
					REPLACE ZK3_BANCO	WITH (cAlias)->NRO_BANCO
					REPLACE ZK3_AGENC	WITH (cAlias)->NRO_AGENC
					REPLACE ZK3_CONTA	WITH (cAlias)->NRO_CONTA
					REPLACE ZK3_TID		WITH (cAlias)->TRACKID
					REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
					REPLACE ZK3_DTVEN  	WITH Ctod((cAlias)->DT_VENDA)
					REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
					REPLACE ZK3_FILE	WITH cArq01
					REPLACE ZK3_OBS		WITH "Registro n�o encontrado no sistema"

				MsUnLock()
			Else

				RecLock("ZK3",.T.)

					REPLACE ZK3_FILIAL	WITH cEmpAnt
					REPLACE ZK3_TPREG	WITH (cAlias)->C01
					REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
					REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
					REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
					REPLACE ZK3_TPLAN	WITH (cAlias)->TIPO_LAN
					REPLACE ZK3_DESC	WITH (cAlias)->DESCRICA
					REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
					REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
					REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
					REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
					REPLACE ZK3_NSU		WITH (cAlias)->NSU
					REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
					REPLACE ZK3_DTPGTO	WITH Ctod((cAlias)->DT_PAGAM)
					REPLACE ZK3_VLRPAG	WITH nValor
					REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
					REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
					REPLACE ZK3_REF1	WITH (cAlias)->REFER1
					REPLACE ZK3_REF2	WITH (cAlias)->REFER2
					REPLACE ZK3_NRANT	WITH (cAlias)->NRO_ANTEC
					REPLACE ZK3_VLRANT	WITH (cAlias)->VLR_DESC_
					REPLACE ZK3_BANCO	WITH (cAlias)->NRO_BANCO
					REPLACE ZK3_AGENC	WITH (cAlias)->NRO_AGENC
					REPLACE ZK3_CONTA	WITH (cAlias)->NRO_CONTA
					REPLACE ZK3_TID		WITH (cAlias)->TRACKID
					REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
					REPLACE ZK3_DTVEN  	WITH Ctod((cAlias)->DT_VENDA)
					REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
					REPLACE ZK3_FILE	WITH cArq01
					REPLACE ZK3_OBS		WITH "Registro n�o encontrado no sistema"

				MsUnLock()

			EndIf
			(cAlias)->(DbSkip())
			Loop
		Endif

	Else
		CONOUT('TITULO_NAO_CONCILIADO '+ALLTRIM((cAlias)->NSU) )

		//Grava registros com erros no arquivo
		fWrite(nHandle	,	'PAGAMENTO'									+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_LAN)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
		fWrite(nHandle	,	""											+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->AUTORIZA)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->NRO_PARC)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->DT_PAGAM)			+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->VLR_PAGO)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->TRACKID)					+ ";" )
		fWrite(nHandle	,	"Registro nao conciliado NSU: "	+ ALLTRIM((cAlias)->NSU) + ";" )
		fWrite(nHandle	,	CRLF )

		If ZK3->(dbSeek(xFilial("ZK3") + (cAlias)->TIPO_LAN + (cAlias)->TRACKID))

			RecLock("ZK3",.F.)

				REPLACE ZK3_FILIAL	WITH cEmpAnt
				REPLACE ZK3_TPREG	WITH (cAlias)->C01
				REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
				REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
				REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
				REPLACE ZK3_TPLAN	WITH (cAlias)->TIPO_LAN
				REPLACE ZK3_DESC	WITH (cAlias)->DESCRICA
				REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
				REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
				REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
				REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
				REPLACE ZK3_NSU		WITH (cAlias)->NSU
				REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
				REPLACE ZK3_DTPGTO	WITH Ctod((cAlias)->DT_PAGAM)
				REPLACE ZK3_VLRPAG	WITH nValor
				REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
				REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
				REPLACE ZK3_REF1	WITH (cAlias)->REFER1
				REPLACE ZK3_REF2	WITH (cAlias)->REFER2
				REPLACE ZK3_NRANT	WITH (cAlias)->NRO_ANTEC
				REPLACE ZK3_VLRANT	WITH (cAlias)->VLR_DESC_
				REPLACE ZK3_BANCO	WITH (cAlias)->NRO_BANCO
				REPLACE ZK3_AGENC	WITH (cAlias)->NRO_AGENC
				REPLACE ZK3_CONTA	WITH (cAlias)->NRO_CONTA
				REPLACE ZK3_TID		WITH (cAlias)->TRACKID
				REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
				REPLACE ZK3_DTVEN  	WITH Ctod((cAlias)->DT_VENDA)
				REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
				REPLACE ZK3_FILE	WITH cArq01
				REPLACE ZK3_OBS		WITH "Registro n�o encontrado no sistema"

			MsUnLock()

		Else

			RecLock("ZK3",.T.)

				REPLACE ZK3_FILIAL	WITH cEmpAnt
				REPLACE ZK3_TPREG	WITH (cAlias)->C01
				REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
				REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
				REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
				REPLACE ZK3_TPLAN	WITH (cAlias)->TIPO_LAN
				REPLACE ZK3_DESC	WITH (cAlias)->DESCRICA
				REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
				REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
				REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
				REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
				REPLACE ZK3_NSU		WITH (cAlias)->NSU
				REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
				REPLACE ZK3_DTPGTO	WITH Ctod((cAlias)->DT_PAGAM)
				REPLACE ZK3_VLRPAG	WITH nValor
				REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
				REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
				REPLACE ZK3_REF1	WITH (cAlias)->REFER1
				REPLACE ZK3_REF2	WITH (cAlias)->REFER2
				REPLACE ZK3_NRANT	WITH (cAlias)->NRO_ANTEC
				REPLACE ZK3_VLRANT	WITH (cAlias)->VLR_DESC_
				REPLACE ZK3_BANCO	WITH (cAlias)->NRO_BANCO
				REPLACE ZK3_AGENC	WITH (cAlias)->NRO_AGENC
				REPLACE ZK3_CONTA	WITH (cAlias)->NRO_CONTA
				REPLACE ZK3_TID		WITH (cAlias)->TRACKID
				REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
				REPLACE ZK3_DTVEN  	WITH Ctod((cAlias)->DT_VENDA)
				REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
				REPLACE ZK3_FILE	WITH cArq01
				REPLACE ZK3_OBS		WITH "Registro n�o encontrado no sistema"

			MsUnLock()

		EndIf
		(cAlias)->(DbSkip())
		Loop
	Endif

	//�����������������������������������������������������������������Ŀ
	//�Acumula os valores das taxas para gera��o do contas a pagar.		�
	//�������������������������������������������������������������������
	If (cAlias)->TAXA > 0

		nVlrTX := (cAlias)->TAXA
		nPos   := AScan( aAdmFin, { |x| x[1]+x[2] == Alltrim((cAlias)->LOJA_FIL)+Alltrim((cAlias)->ADQUIREN) } )
		If nPos==0
			AAdd( aAdmFin , { Alltrim((cAlias)->LOJA_FIL) , Alltrim((cAlias)->ADQUIREN) , nVlrTX , (cAlias)->DT_PAGAM } )
		Else
			aAdmFin[nPos,3] += nVlrTX
		Endif

	Endif

	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

//����������������������������������������������������������������������������������������Ŀ
//�Executa a inclusao do Titulo no contas a pagar. 										   �
//��������������������������������������������������������������������������������������
If lGeraSE2
	Conout("GERACAO DO CONTAS A PAGAR")
	For nX1 := 1 To Len(aAdmFin)
		fGeraSE2(aAdmFin[nX1,1],aAdmFin[nX1,2],aAdmFin[nX1,3],aAdmFin[nX1,4])
	Next

Endif

FClose(nHandle)

RestArea(aArea)

fGerDado()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � KMVENARQ � Autor �         TOTVS         � Data � 16/07/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Faz a conciliacao dos cartoes conforme registros lido no   ���
���          � arquivo importado.                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function KMVENARQ(cEmpresa,cFil,cEmpOfic,lGeraSE2,cArqTrb,cArq01)

Local aArea  	:= GetArea()
Local cAlias 	:= GetNextAlias()
Local cQuery	:= ""
Local cEmpAtu	:= ""
Local cPrefixo	:= ""
Local cNumero	:= ""
Local cParcela	:= ""
Local cTipo		:= ""
Local cChave	:= ""
Local cDirServ	:= "\importacao\"
Local nVlrSE1	:= 0
Local nRefT		:= 0
Local nTaxa		:= 0
Local nMarg		:= 0.09
Local aParc 	:= {"1  ","2  ","3  ","4  ","5  ","6  ","7  ","8  ","9  ",;
					"A  ","B  ","C  ","D  ","E  ","F  ","G  ","H  ","I  ",;
					"J  ","K  ","L  ","M  ","N  ","O  ","P  ","Q  ","R  ",;
					"S  ","T  ","U  ","V  ","W  ","X  ","Y  ","Z  "}

nHandle := MsfCreate(cDirServ+"VENDA_"+Dtos(Date())+"_FILIAL_"+cEmpresa+".LOG",0)

fWrite(nHandle	,	"OPERACAO"			+ ";" )	// 01
fWrite(nHandle	,	""					+ ";" )	// 02
fWrite(nHandle	,	"LOJA_FIL"			+ ";" )	// 03
fWrite(nHandle	,	"COD_ERP"			+ ";" )	// 04
fWrite(nHandle	,	"BANDEIRA"			+ ";" )	// 05
fWrite(nHandle	,	"TIPO_TRANSACAO"	+ ";" )	// 06
fWrite(nHandle	,	"AUTORIZACAO"		+ ";" ) // 07
fWrite(nHandle	,	"PARCELA"			+ ";" ) // 08
fWrite(nHandle	,	"DT_VENDA"			+ ";" ) // 09
fWrite(nHandle	,	"VALOR"				+ ";" ) // 10
fWrite(nHandle	,	"ID_REGISTRO"		+ ";" ) // 11
fWrite(nHandle	,	"OCORRENCIA"		+ ";" ) // 12
fWrite(nHandle	,	CRLF )

cQuery := " SELECT * FROM "+cArqTrb+" TMP WHERE LOJA_FIL = '"+cEmpresa+"' ORDER BY LOJA_FIL "
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())

	dbSelectArea("ZK3")
	ZK3->(dbSetOrder(8))
	ZK3->(dbGoTop())

	if Empty(ALLTRIM((cAlias)->COD_ERP))

		//Grava registros com erros no arquivo
		fWrite(nHandle	,	'VENDA'									+ ";" )
		fWrite(nHandle	,	""										+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)				+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)				+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)				+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_TRA)				+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->AUTORIZA)				+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->NRO_PARC)				+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->DT_VENDA)				+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->VLR_BRUTO)			+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->TRACKID)				+ ";" )
		fWrite(nHandle	,	"RECEBIDO PELO ADQUIRENTE S/ COD_ERP"	+ ";" )
		fWrite(nHandle	,	CRLF )

		If ZK3->(dbSeek(xFilial("ZK3") + (cAlias)->B01 + (cAlias)->AUTORIZA + (cAlias)->NRO_PARC))

			RecLock("ZK3",.F.)

				REPLACE ZK3_FILIAL	WITH cEmpAnt
				REPLACE ZK3_TPREG	WITH (cAlias)->B01
				REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
				REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
				REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
				REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
				REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
				REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
				REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
				REPLACE ZK3_NSU		WITH (cAlias)->NSU
				REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
				REPLACE ZK3_DTVEN	WITH Ctod((cAlias)->DT_VENDA)
				REPLACE ZK3_DTPREV	WITH Ctod((cAlias)->DT_PRVPGT)
				REPLACE ZK3_VLRBRT	WITH (cAlias)->VLR_BRUTO
				REPLACE ZK3_VLRLIQ	WITH (cAlias)->VLR_LIQ_
				REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
				REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
				REPLACE ZK3_TID		WITH (cAlias)->TRACKID
				REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
				REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
				REPLACE ZK3_FILE	WITH cArq01
				REPLACE ZK3_OBS		WITH "RECEBIDO PELO ADQUIRENTE S/ COD_ERP"

			MsUnLock()

		Else

			RecLock("ZK3",.T.)

				REPLACE ZK3_FILIAL	WITH cEmpAnt
				REPLACE ZK3_TPREG	WITH (cAlias)->B01
				REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
				REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
				REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
				REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
				REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
				REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
				REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
				REPLACE ZK3_NSU		WITH (cAlias)->NSU
				REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
				REPLACE ZK3_DTVEN	WITH Ctod((cAlias)->DT_VENDA)
				REPLACE ZK3_DTPREV	WITH Ctod((cAlias)->DT_PRVPGT)
				REPLACE ZK3_VLRBRT	WITH (cAlias)->VLR_BRUTO
				REPLACE ZK3_VLRLIQ	WITH (cAlias)->VLR_LIQ_
				REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
				REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
				REPLACE ZK3_TID		WITH (cAlias)->TRACKID
				REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
				REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
				REPLACE ZK3_FILE	WITH cArq01
				REPLACE ZK3_OBS		WITH "RECEBIDO PELO ADQUIRENTE S/ COD_ERP"

			MsUnLock()

		EndIf
		(cAlias)->(DbSkip())
		Loop

	EndIF


	cChave	 	:= Alltrim((cAlias)->COD_ERP)

	cPrefixo	:= ""
	cNumero		:= ""
	cParcela	:= ""
	cTipo		:= ""

	if len(cChave) > 12
		cPrefixo	:= SubStr(cChave,01,3)
		cNumero		:= SubStr(cChave,04,9)
		cParcela	:= SubStr(cChave,13,2)
		cTipo		:= SubStr(cChave,15,3)

		cParcela 	:= iif(len(Alltrim(cNumero))==9.OR.cParcela=="00",cParcela,aParc[val(cParcela)])
	endif


	If !Empty( cChave )

		dbSelectArea("SE1")
		SE1->(DbSetOrder(1))
		SE1->(dbGoTop())

		If SE1->(DbSeek( xFilial("SE1") + cPrefixo + cNumero + PADR(cParcela,TAMSX3("E1_PARCELA")[1]) + PADR(cTipo,TAMSX3("E1_TIPO")[1])))

			nVlrSe1	:= SE1->E1_VALOR

			if Empty(SE1->E1_XTRCID)
				RECLOCK("SE1",.F.)
					SE1->E1_XTRCID	:= ALLTRIM((cAlias)->TRACKID)
					SE1->E1_XSTCONC	:= ALLTRIM((cAlias)->STATUS)
				MSUNLOCK()
			else

				//Grava registros com erros no arquivo
				fWrite(nHandle	,	'VENDA'										+ ";" )
				fWrite(nHandle	,	""											+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_TRA)					+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->AUTORIZA)					+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->NRO_PARC)					+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->DT_VENDA)					+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->VLR_BRUTO)				+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->TRACKID)					+ ";" )
				fWrite(nHandle	,	"REGISTRO J� CONCILIADO"					+ ";" )
				fWrite(nHandle	,	CRLF )

				(cAlias)->(DbSkip())
				Loop

			endIf
		Else

		    //Grava registros com erros no arquivo
			fWrite(nHandle	,	'VENDA'										+ ";" )
			fWrite(nHandle	,	''											+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_TRA)					+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->AUTORIZA)					+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->NRO_PARC)					+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->DT_VENDA)					+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->VLR_BRUTO)				+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->TRACKID)					+ ";" )
			fWrite(nHandle	,	"COD_ERP NAO ENCONTRADO NA BASE"			+ ";" )
			fWrite(nHandle	,	CRLF )

			If ZK3->(dbSeek(xFilial("ZK3") + (cAlias)->B01 + (cAlias)->AUTORIZA + (cAlias)->NRO_PARC))

				RecLock("ZK3",.F.)

					REPLACE ZK3_FILIAL	WITH cEmpAnt
					REPLACE ZK3_TPREG	WITH (cAlias)->B01
					REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
					REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
					REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
					REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
					REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
					REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
					REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
					REPLACE ZK3_NSU		WITH (cAlias)->NSU
					REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
					REPLACE ZK3_DTVEN	WITH Ctod((cAlias)->DT_VENDA)
					REPLACE ZK3_DTPREV	WITH Ctod((cAlias)->DT_PRVPGT)
					REPLACE ZK3_VLRBRT	WITH (cAlias)->VLR_BRUTO
					REPLACE ZK3_VLRLIQ	WITH (cAlias)->VLR_LIQ_
					REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
					REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
					REPLACE ZK3_TID		WITH (cAlias)->TRACKID
					REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
					REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
					REPLACE ZK3_FILE	WITH cArq01
					REPLACE ZK3_OBS		WITH "COD_ERP NAO ENCONTRADO NA BASE"

				MsUnLock()

			Else

				RecLock("ZK3",.T.)

					REPLACE ZK3_FILIAL	WITH cEmpAnt
					REPLACE ZK3_TPREG	WITH (cAlias)->B01
					REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
					REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
					REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
					REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
					REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
					REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
					REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
					REPLACE ZK3_NSU		WITH (cAlias)->NSU
					REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
					REPLACE ZK3_DTVEN	WITH Ctod((cAlias)->DT_VENDA)
					REPLACE ZK3_DTPREV	WITH Ctod((cAlias)->DT_PRVPGT)
					REPLACE ZK3_VLRBRT	WITH (cAlias)->VLR_BRUTO
					REPLACE ZK3_VLRLIQ	WITH (cAlias)->VLR_LIQ_
					REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
					REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
					REPLACE ZK3_TID		WITH (cAlias)->TRACKID
					REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
					REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
					REPLACE ZK3_FILE	WITH cArq01
					REPLACE ZK3_OBS		WITH "COD_ERP NAO ENCONTRADO NA BASE"

				MsUnLock()

			EndIf
			(cAlias)->(DbSkip())
			Loop

		Endif

	Else

		//Grava registros com erros no arquivo
		fWrite(nHandle	,	'VENDA'										+ ";" )
		fWrite(nHandle	,	''											+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_TRA)					+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->AUTORIZA)					+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->NRO_PARC)					+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->DT_VENDA)					+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->VLR_BRUTO)				+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->TRACKID)					+ ";" )
		fWrite(nHandle	,	"ERRO NA ATRIBUICAO DA CHAVE COD_ERP"		+ ";" )
		fWrite(nHandle	,	CRLF )

		If ZK3->(dbSeek(xFilial("ZK3") + (cAlias)->B01 + (cAlias)->AUTORIZA + (cAlias)->NRO_PARC))

			RecLock("ZK3",.F.)

				REPLACE ZK3_FILIAL	WITH cEmpAnt
				REPLACE ZK3_TPREG	WITH (cAlias)->B01
				REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
				REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
				REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
				REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
				REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
				REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
				REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
				REPLACE ZK3_NSU		WITH (cAlias)->NSU
				REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
				REPLACE ZK3_DTVEN	WITH Ctod((cAlias)->DT_VENDA)
				REPLACE ZK3_DTPREV	WITH Ctod((cAlias)->DT_PRVPGT)
				REPLACE ZK3_VLRBRT	WITH (cAlias)->VLR_BRUTO
				REPLACE ZK3_VLRLIQ	WITH (cAlias)->VLR_LIQ_
				REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
				REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
				REPLACE ZK3_TID		WITH (cAlias)->TRACKID
				REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
				REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
				REPLACE ZK3_FILE	WITH cArq01
				REPLACE ZK3_OBS		WITH "ERRO NA ATRIBUICAO DA CHAVE COD_ERP"

			MsUnLock()

		Else

			RecLock("ZK3",.T.)

				REPLACE ZK3_FILIAL	WITH cEmpAnt
				REPLACE ZK3_TPREG	WITH (cAlias)->B01
				REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
				REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
				REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
				REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
				REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
				REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
				REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
				REPLACE ZK3_NSU		WITH (cAlias)->NSU
				REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
				REPLACE ZK3_DTVEN	WITH Ctod((cAlias)->DT_VENDA)
				REPLACE ZK3_DTPREV	WITH Ctod((cAlias)->DT_PRVPGT)
				REPLACE ZK3_VLRBRT	WITH (cAlias)->VLR_BRUTO
				REPLACE ZK3_VLRLIQ	WITH (cAlias)->VLR_LIQ_
				REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
				REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
				REPLACE ZK3_TID		WITH (cAlias)->TRACKID
				REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
				REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
				REPLACE ZK3_FILE	WITH cArq01
				REPLACE ZK3_OBS		WITH "ERRO NA ATRIBUICAO DA CHAVE COD_ERP"

			MsUnLock()

		EndIf
		(cAlias)->(DbSkip())
		Loop

	Endif

	//�����������������������������������������������������������������Ŀ
	//�Acumula os valores das taxas para gera��o do contas a pagar.		�
	//�������������������������������������������������������������������
	dbSelectArea("SE2")
	SE2->(dbSetOrder(1))
	SE2->(dbGoTop())
//	If SE2->(DbSeek( xFilial("SE1") + "TXA" + cNumero + cParcela + cTipo ))
	If SE2->(DbSeek( xFilial("SE2") + "TXA" + cNumero + PADR(cParcela,TAMSX3("E1_PARCELA")[1]) + PADR(cTipo,TAMSX3("E1_TIPO")[1])))

		nTaxa := NoRound(((1 - ((cAlias)->VLR_LIQ_ / (cAlias)->VLR_BRUTO)) * 100),2)

		nRefT := NoRound((((SE2->E2_VALOR/nVlrSE1)) * 100),2)


		If nRefT > (nTaxa - nMarg) .AND. nRefT < (nTaxa + nMarg)
			if Empty(SE2->E2_XTRCID)

				RECLOCK("SE2",.F.)
					SE2->E2_XTRCID := ALLTRIM((cAlias)->TRACKID)
				MSUNLOCK()

			else

				//Grava registros com erros no arquivo
				fWrite(nHandle	,	'VENDA'										+ ";" )
				fWrite(nHandle	,	''											+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
				fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_TRA)					+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->AUTORIZA)					+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->NRO_PARC)					+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->DT_VENDA)					+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->VLR_BRUTO)				+ ";" )
				fWrite(nHandle	,	ALLTRIM((cAlias)->TRACKID)					+ ";" )
				fWrite(nHandle	,	"TITULO CP TAXA J� CONCILIADO"				+ ";" )
				fWrite(nHandle	,	CRLF )

				(cAlias)->(DbSkip())
				Loop

			endif
		Else

			//Grava registros com erros no arquivo
			fWrite(nHandle	,	'VENDA'										+ ";" )
			fWrite(nHandle	,	''											+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
			fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_TRA)					+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->AUTORIZA)					+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->NRO_PARC)					+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->DT_VENDA)					+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->VLR_BRUTO)				+ ";" )
			fWrite(nHandle	,	ALLTRIM((cAlias)->TRACKID)					+ ";" )
			fWrite(nHandle	,	"DIF VLR TX CONCIL: "+ cValToChar(nTaxa) +" VALOR TIT.: " + cValToChar(nRefT) + ";" )
			fWrite(nHandle	,	CRLF )

			If ZK3->(dbSeek(xFilial("ZK3") + (cAlias)->B01 + (cAlias)->AUTORIZA + (cAlias)->NRO_PARC))

			RecLock("ZK3",.F.)

				REPLACE ZK3_FILIAL	WITH cEmpAnt
				REPLACE ZK3_TPREG	WITH (cAlias)->B01
				REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
				REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
				REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
				REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
				REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
				REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
				REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
				REPLACE ZK3_NSU		WITH (cAlias)->NSU
				REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
				REPLACE ZK3_DTVEN	WITH Ctod((cAlias)->DT_VENDA)
				REPLACE ZK3_DTPREV	WITH Ctod((cAlias)->DT_PRVPGT)
				REPLACE ZK3_VLRBRT	WITH (cAlias)->VLR_BRUTO
				REPLACE ZK3_VLRLIQ	WITH (cAlias)->VLR_LIQ_
				REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
				REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
				REPLACE ZK3_TID		WITH (cAlias)->TRACKID
				REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
				REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
				REPLACE ZK3_FILE	WITH cArq01
				REPLACE ZK3_OBS		WITH "DIF VLR TX CONCIL: "+ cValToChar(nTaxa) +" VALOR TIT.: " + cValToChar(nRefT)

			MsUnLock()

			Else

			RecLock("ZK3",.T.)

				REPLACE ZK3_FILIAL	WITH cEmpAnt
				REPLACE ZK3_TPREG	WITH (cAlias)->B01
				REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
				REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
				REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
				REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
				REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
				REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
				REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
				REPLACE ZK3_NSU		WITH (cAlias)->NSU
				REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
				REPLACE ZK3_DTVEN	WITH Ctod((cAlias)->DT_VENDA)
				REPLACE ZK3_DTPREV	WITH Ctod((cAlias)->DT_PRVPGT)
				REPLACE ZK3_VLRBRT	WITH (cAlias)->VLR_BRUTO
				REPLACE ZK3_VLRLIQ	WITH (cAlias)->VLR_LIQ_
				REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
				REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
				REPLACE ZK3_TID		WITH (cAlias)->TRACKID
				REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
				REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
				REPLACE ZK3_FILE	WITH cArq01
				REPLACE ZK3_OBS		WITH "DIF VLR TX CONCIL: "+ cValToChar(nTaxa) +" VALOR TIT.: " + cValToChar(nRefT)

			MsUnLock()

			EndIf
			(cAlias)->(DbSkip())
			Loop

		EndIf
	Else

		//Grava registros com erros no arquivo
		fWrite(nHandle	,	'VENDA'										+ ";" )
		fWrite(nHandle	,	''											+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->LOJA_FIL)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->COD_ERP)					+ ";" )
		fWrite(nHandle	,	Alltrim((cAlias)->BANDEIRA)					+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->TIPO_TRA)					+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->AUTORIZA)					+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->NRO_PARC)					+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->DT_VENDA)					+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->VLR_BRUTO)				+ ";" )
		fWrite(nHandle	,	ALLTRIM((cAlias)->TRACKID)					+ ";" )
		fWrite(nHandle	,	"TITULO CP NAO ENCONTRADO"					+ ";" )
		fWrite(nHandle	,	CRLF )

		If ZK3->(dbSeek(xFilial("ZK3") + (cAlias)->B01 + (cAlias)->AUTORIZA + (cAlias)->NRO_PARC))

			RecLock("ZK3",.F.)

				REPLACE ZK3_FILIAL	WITH cEmpAnt
				REPLACE ZK3_TPREG	WITH (cAlias)->B01
				REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
				REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
				REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
				REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
				REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
				REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
				REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
				REPLACE ZK3_NSU		WITH (cAlias)->NSU
				REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
				REPLACE ZK3_DTVEN	WITH Ctod((cAlias)->DT_VENDA)
				REPLACE ZK3_DTPREV	WITH Ctod((cAlias)->DT_PRVPGT)
				REPLACE ZK3_VLRBRT	WITH (cAlias)->VLR_BRUTO
				REPLACE ZK3_VLRLIQ	WITH (cAlias)->VLR_LIQ_
				REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
				REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
				REPLACE ZK3_TID		WITH (cAlias)->TRACKID
				REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
				REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
				REPLACE ZK3_FILE	WITH cArq01
				REPLACE ZK3_OBS		WITH "TITULO CP NAO ENCONTRADO"

			MsUnLock()

		Else

			RecLock("ZK3",.T.)

				REPLACE ZK3_FILIAL	WITH cEmpAnt
				REPLACE ZK3_TPREG	WITH (cAlias)->B01
				REPLACE ZK3_CHAVE	WITH (cAlias)->COD_ERP
				REPLACE ZK3_FILORI	WITH (cAlias)->LOJA_FIL
				REPLACE ZK3_ESTAB	WITH (cAlias)->ESTAB
				REPLACE ZK3_PARC	WITH (cAlias)->NRO_PARC
				REPLACE ZK3_ADQU	WITH (cAlias)->ADQUIREN
				REPLACE ZK3_BAND	WITH (cAlias)->BANDEIRA
				REPLACE ZK3_TPTRAN	WITH iif(Substr((cAlias)->TIPO_TRA,1,1)$"C","1","2")
				REPLACE ZK3_NSU		WITH (cAlias)->NSU
				REPLACE ZK3_AUTORI	WITH (cAlias)->AUTORIZA
				REPLACE ZK3_DTVEN	WITH Ctod((cAlias)->DT_VENDA)
				REPLACE ZK3_DTPREV	WITH Ctod((cAlias)->DT_PRVPGT)
				REPLACE ZK3_VLRBRT	WITH (cAlias)->VLR_BRUTO
				REPLACE ZK3_VLRLIQ	WITH (cAlias)->VLR_LIQ_
				REPLACE ZK3_TAXA	WITH (cAlias)->TAXA
				REPLACE ZK3_STATUS	WITH (cAlias)->STATUS
				REPLACE ZK3_TID		WITH (cAlias)->TRACKID
				REPLACE ZK3_TERMIN	WITH (cAlias)->TERMINAL
				REPLACE ZK3_MASCCD	WITH (cAlias)->MASC_CARD
				REPLACE ZK3_FILE	WITH cArq01
				REPLACE ZK3_OBS		WITH "TITULO CP NAO ENCONTRADO"

			MsUnLock()

		EndIf
		(cAlias)->(dbSKIP())
		Loop

	EndIf

	(cAlias)->(dbSKIP())
EndDo
(cAlias)->( dbCloseArea() )

FClose(nHandle)

RestArea(aArea)

fGerDado()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fBaixaSE1 � Autor �  Eduardo Patriani     � Data � 16/07/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Baixa o titulo financeiro.                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fBaixaSE1(cFilAtu,cPrefixo,cTitulo,cParcela,cTipo,cCliente,cLoja,cBanco,cAgencia,cConta,dDataPgto,nVlrRec)
Local aBaixa 		:= {}
Local lMSHelpAuto	:= .T.
Local lMsErroAuto 	:= .F.
Local cFilOld		:= cFilAnt
Local lRet			:= .T.

cFilAnt := cFilAtu

AAdd(aBaixa,{"E1_PREFIXO"	,cPrefixo	, Nil})
AAdd(aBaixa,{"E1_NUM"    	,cTitulo	, Nil})
AAdd(aBaixa,{"E1_PARCELA"	,cParcela	, Nil})
AAdd(aBaixa,{"E1_TIPO"   	,cTipo		, Nil})
AAdd(aBaixa,{"E1_CLIENTE"	,cCliente	, Nil})
AAdd(aBaixa,{"E1_LOJA"   	,cLoja		, Nil})
AAdd(aBaixa,{"AUTMOTBX"  	,"NORMAL"  	, Nil})
aAdd(aBaixa,{"AUTVALREC"    ,nVlrRec  	,Nil})
AAdd(aBaixa,{"AUTDTBAIXA"	,Stod(dDataPgto), Nil})
AAdd(aBaixa,{"AUTBANCO"		,cBanco		, Nil})
AAdd(aBaixa,{"AUTAGENCIA"	,cAgencia	, Nil})
AAdd(aBaixa,{"AUTCONTA"		,cConta		, Nil})

MsExecAuto({|x,y|FINA070(x,y)},aBaixa,3)

IF lMsErroAuto
	MostraErro()
	lRet := .F.
EndIF

cFilAnt := cFilOld

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fGeraSE1 � Autor �  Eduardo Patriani     � Data � 16/07/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera  titulo financeiro do tipo NCC.                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fGeraSE1(cFilAtu,cPrefixo,cTitulo,cParcela,cTipo,cCliente,cLoja,nValor,dDataPgto)

Local aRotAuto 		:= {}
Local lMSHelpAuto	:= .T.
Local lMsErroAuto 	:= .F.
Local cNatRec  		:= GetMv("MV_BRNATCA",,"3202A")
Local cFilOld		:= cFilAnt
Local lRet			:= .T.

cFilAnt := cFilAtu

AAdd( aRotAuto, { "E1_PREFIXO", cPrefixo						, NIL } )
AAdd( aRotAuto, { "E1_NUM"    , cTitulo							, NIL } )
AAdd( aRotAuto, { "E1_PARCELA", cParcela						, NIL } )
AAdd( aRotAuto, { "E1_NATUREZ", cNatRec							, NIL } )
AAdd( aRotAuto, { "E1_TIPO"   , cTipo							, NIL } )
AAdd( aRotAuto, { "E1_CLIENTE", cCliente						, NIL } )
AAdd( aRotAuto, { "E1_LOJA"   , cLoja							, NIL } )
AAdd( aRotAuto, { "E1_VALOR"  , nValor							, NIL } )
AAdd( aRotAuto, { "E1_EMISSAO", Stod(dDataPgto)					, NIL } )
AAdd( aRotAuto, { "E1_VENCTO" , Stod(dDataPgto)					, NIL } )
AAdd( aRotAuto, { "E1_VENCREA", DataValida( Stod(dDataPgto) )	, NIL } )

MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto, 3 )

IF lMsErroAuto
	MostraErro()
	lRet := .F.
EndIF

cFilAnt := cFilOld

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fGeraSE2 � Autor �  Eduardo Patriani     � Data � 16/07/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera titulo financeiro no contas a pagar        			  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fGeraSE2(cFilAtu,cAdquirente,nValor,dDataPgto)

Local cForn01		:= GetMv("SY_FORVISA",,"INQFOH01")	//Fornecedor VISANET corresponde ao ADQUIRENTE CIELO
Local cForn02		:= GetMv("SY_FORAMEX",,"77015301")	//Fornecedor BANCO AMERICAN EXPRESS corresponde ao ADQUIRENTE AMEX
Local cForn03		:= GetMv("SY_FORREDE",,"77004801")	//Fornecedor REDECARD corresponde ao ADQUIRENTE REDECARD
Local cNaturez		:= GetMv("SY_NATCONC",,"4201") 		//Natureza
Local cFornece		:= ""
Local cLoja			:= ""
Local cFilOld		:= cFilAnt
Local aRotAuto 		:= {}
Local lMSHelpAuto	:= .T.
Local lMsErroAuto 	:= .F.

//cFilAnt := Right(cFilAtu,2)

// N�O USADA, VISTO QUE O T�TULO J� EXISTE
RETURN .F.

If Alltrim(cAdquirente)=="AMEX"
	cFornece := Left(cForn02,6)
	cLoja	 := Right(cForn02,2)
ElseIf Alltrim(cAdquirente)=="CIELO"
	cFornece := Left(cForn01,6)
	cLoja	 := Right(cForn01,2)
Else
	cFornece := Left(cForn03,6)
	cLoja	 := Right(cForn03,2)
Endif

AAdd( aRotAuto , {"E2_PREFIXO"		,"TXA"					, Nil})
AAdd( aRotAuto , {"E2_NUM"    		,Dtos(dDatabase)		, Nil})
AAdd( aRotAuto , {"E2_PARCELA"		,"01"   				, Nil})
AAdd( aRotAuto , {"E2_TIPO"   		,"TX" 					, Nil})
AAdd( aRotAuto , {"E2_NATUREZ"   	,cNaturez				, 'AlwaysTrue()'})
AAdd( aRotAuto , {"E2_FORNECE" 		,cFornece		   		, Nil})
AAdd( aRotAuto , {"E2_LOJA"   		,cLoja	   				, Nil})
Aadd( aRotAuto , {"E2_EMISSAO"		,Stod(dDataPgto)		, Nil})
Aadd( aRotAuto , {"E2_VENCTO"		,Stod(dDataPgto)		, Nil})
Aadd( aRotAuto , {"E2_VENCREA"		,DataValida(Stod(dDataPgto)), Nil})
Aadd( aRotAuto , {"E2_VALOR"		,nValor					, Nil})

MSExecAuto({|x,y,z| Fina050(x,y,z)},aRotAuto,,3)

If lMsErroAuto
	MostraErro()
Else
	RecLock("SE2",.F.)
	SE2->E2_NATUREZ := cNaturez
//	SE2->E2_DESCNAT := Posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,'ED_DESCRIC')
	Msunlock()
EndIf

cFilAnt := cFilOld

Return(.T.)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fRetVal   �Autor  �SYMM Consultoria    � Data �  02/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function fRetVal(cString)

Local cAux	 := ""
Local nValor := 0

cAux 	:= Subs(cString,1,Len(cString)-2)+","+Right(cString,2)
cString := cAux

nValor := Val(StrTran(StrTran(cString,"."),",","."))

Return nValor

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fValSA6   �Autor  �SYMM Consultoria    � Data �  02/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function fValSA6( cEmpresa , cBanco , cAgencia , cConta)

Local cQuery := ""
Local lRet	 := .F.
Local cAlias := GetNextAlias()

cEmpresa := Alltrim(cEmpresa)

cQuery := " SELECT A6_COD,A6_AGENCIA,A6_NUMCON "
cQuery += " FROM "+retSqlName("SA6")+" SA6 "
cQuery += " WHERE A6_FILIAL = '"+xFilial("SA6")+"' "
cQuery += " AND A6_COD 		= '"+cBanco+"' "
cQuery += " AND A6_AGENCIA 	LIKE '%"+cAgencia+"%' "
cQuery += " AND (A6_NUMCON 	LIKE '%"+cConta+"%' "
cQuery += " or A6_NUMCON 	LIKE '%"+left(cConta, len(cConta)-1)+"%' )"
cQuery += " AND SA6.D_E_L_E_T_ = ' ' "
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	lRet 	 := .T.
	cBanco	 := (cAlias)->A6_COD
	cAgencia := (cAlias)->A6_AGENCIA
	cConta 	 := (cAlias)->A6_NUMCON

	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMntTela �Autor  � SYMM CONSULTORIA   � Data �  18/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina Monta tela com erros encontrados na integra��o       ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fMntTela()
Local aArea		:= GetArea()
Local aTitTwBr	:= {"Opera��o","Lan�amento","Loja","T�tulo","Bandeira","Transa��o","Autoriza��o","Parcela","Data Venda","Valor","ID Concil","Ocorr�ncia"}
Local aTamBrw	:= {50,50,50,50,50,50,50,50,50,50,50,50}
Local oDlgErro

Define MsDialog oDlgErro Title "Retorno da Concilia��o" From 0,0 To 375,790 Pixel Of oDlgErro

	If Len(aLogs) <= 0
		aAdd(aLogs,{""})
	EndIf

	//������������Ŀ
	//�Painel Layer�
	//��������������
	oFwLayer := FwLayer():New()
	oFwLayer:Init(oDlgErro,.F.)

   	//����������Ŀ
	//�1o. Painel�
	//������������
	oFWLayer:addLine("SYERROPV",100, .F.)
	oFWLayer:addCollumn( "COLERROPV",100, .F. , "SYERROPV")
	oFWLayer:addWindow( "COLERROPV", "WINENT", "Retorno da Concilia��o", 100, .F., .F., , "SYERROPV")
	oFwTwbr := oFWLayer:GetWinPanel("COLERROPV","WINENT","SYERROPV")

	oFolder:=TFolder():New(0,0,{"Contas a Receber"},,oFwTwbr,,,,.T.,.F.,0,0)
	oFolder:Align := CONTROL_ALIGN_ALLCLIENT

	//���������������������Ŀ
	//�Titulos nao baixados |
	//�����������������������
	oTwBrowse := TWBrowse():New(00,00,00,00,,aTitTwBr,aTamBrw,oFolder:aDialogs[1],,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	oTwBrowse:SetArray(aLogs)
	oTwBrowse:bLine := {|| {aLogs[oTwBrowse:nAt,1],;
							aLogs[oTwBrowse:nAt,2],;
							aLogs[oTwBrowse:nAt,3],;
							aLogs[oTwBrowse:nAt,4],;
							aLogs[oTwBrowse:nAt,5],;
							aLogs[oTwBrowse:nAt,6],;
							aLogs[oTwBrowse:nAt,7],;
							aLogs[oTwBrowse:nAt,8],;
							aLogs[oTwBrowse:nAt,9],;
							aLogs[oTwBrowse:nAt,10],;
							aLogs[oTwBrowse:nAt,11],;
							aLogs[oTwBrowse:nAt,12]}}
	oTwBrowse:Align := CONTROL_ALIGN_ALLCLIENT

Activate dialog oDlgErro Center

RestArea(aArea)
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fImpTXT   �Autor  � SYMM CONSULTORIA   � Data �  20/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa os arquivos de Logs para apresentacao em tela.      ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fImpTxt(cArquivo,aLogs)

Local cLinha 	:= ""
Local aTitulos	:= {}

FT_FUSE(cArquivo)
FT_FGOTOP()
While !FT_FEOF()

	//����������������Ŀ
	//� Carrega campos �
	//������������������
	cLinha 	:= FT_FREADLN()
	aTitulos:= Separa(cLinha,";")

	If UPPER(aTitulos[1]) == "OPERACAO"
		FT_FSKIP()
		Loop
	Endif
//	           {"Opera��o" ,"Lan�amento","Loja"    ,"T�tulo"   ,"Bandeira" ,"Transa��o","Autoriza��o","Parcela","Data Venda","Valor","ID Concil","Ocorr�ncia"}
	AAdd(aLogs,{aTitulos[1],aTitulos[2],aTitulos[3],aTitulos[4],aTitulos[5],aTitulos[6],aTitulos[7],aTitulos[8],aTitulos[9],aTitulos[10],aTitulos[11],aTitulos[12]})
	FT_FSKIP()
End

FT_FUSE()

aSort( aLogs,,, {|a,b| a[4] + a[3] + a[12] < b[4] + b[3] + b[12]} )

Return(.T.)

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �fBxTaxa    �Autor  �Rafael Cruz       	   � Data �12/11/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Controle de baixa de taxa adm. de Cart�o   		                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/
Static Function fBxTaxa( _nValTX, dDtBx, _xBanco, _xAgencia, _xConta )
Local   aArea       := getArea()
Local   cMsg        := ""
Local   _oldDt      := dDataBase
Local   aBaixa      := {}
Local   lMsErroAuto := .F.
Local   lMsHelpauto := .T.
Default dDtBx       := dDatabase

	dDataBase := dDtBx

	SE2->( dbSetOrder(1) )
	if SE2->( dbSeek( xFilial("SE2") + SE1->("TXA" + E1_NUM + E1_PARCELA + E1_TIPO) ) )

		if SE2->E2_VALOR == _nValTX

			aAdd(aBaixa,{ "E2_PREFIXO" 	, SE2->E2_PREFIXO	 , Nil } )
			aAdd(aBaixa,{ "E2_NUM"     	, SE2->E2_NUM		 , Nil } )
			aAdd(aBaixa,{ "E2_PARCELA" 	, SE2->E2_PARCELA	 , Nil } )
			aAdd(aBaixa,{ "E2_TIPO"    	, SE2->E2_TIPO		 , Nil } )
			aAdd(aBaixa,{ "E2_FORNECE"	, SE2->E2_FORNECE	 , Nil } )
			aAdd(aBaixa,{ "E2_LOJA"    	, SE2->E2_LOJA		 , Nil } )

			aAdd(aBaixa,{ "AUTBANCO"  	, _xBanco			 , Nil } )
			aAdd(aBaixa,{ "AUTAGENCIA"  , _xAgencia			 , Nil } )
			aAdd(aBaixa,{ "AUTCONTA"  	, _xConta			 , Nil } )
			aAdd(aBaixa,{ "AUTMOTBX"  	, "NOR"       		 , Nil } )
			aAdd(aBaixa,{ "AUTDTBAIXA"	, dDataBase  		 , Nil } )
			aAdd(aBaixa,{ "AUTHIST"   	, "Bx retorno Concil", Nil } )
			aAdd(aBaixa,{ "AUTVLRPG"  	, SE2->E2_SALDO		 , Nil } )

			MsExecAuto({|x,y,w,z| Fina080(x,y,w,z)},aBaixa, 3, .F., nil)

			if lMserroAuto
				MostraErro()
			    cMsg := "Taxa do titulo n�o pode ser baixada, verifique!"
			else
				cMsg := "Taxa do titulo baixada"
			endIf
		else
			cMsg := "Taxa do Concil difere da Taxa do Protheus"
		endIf
	else
		cMsg := "Taxa do titulo NAO encontrado, verifique!"
	endif

	conout( cMsg )

	dDataBase := _oldDt

	restArea( aArea )
return cMsg

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  �DefTamOb    �Autor  �Rafael Cruz       	   � Data �12/11/2015   ���
�������������������������������������������������������������������������������͹��
���Descricao �Controle de resolu��o de tela.             		                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Parametros�                                                                  ���
�����������������������������������������������������������������������������������
*/
Static Function DefTamObj(aTamObj,nTOP,nLEFT,nWIDTH,nBOTTOM,lAcVlZr,oObjAlvo)

	Local lRefPerc			:= .F.
	Local nDimen			:= 0

	PARAMTYPE 0	VAR aTamObj		AS Array		OPTIONAL	DEFAULT Array(4)
	PARAMTYPE 1	VAR nTOP		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 2	VAR nLEFT		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 3	VAR nWIDTH		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 4	VAR nBOTTOM		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 5	VAR	lAcVlZr		AS Logical		OPTIONAL	DEFAULT .F.
	PARAMTYPE 6	VAR	oObjAlvo	AS Object		OPTIONAL	DEFAULT Nil

	If ValType(oObjAlvo) == "O"
		lRefPerc := !lRefPerc
	Endif
	If Len(aTamObj) # 4
		aTamObj := Array(4)
	Endif
	If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nTOP))
		If lRefPerc
			If nTOP < 0
				nDimen := IIf(Type("oObjAlvo:nClientHeight") == "U",oObjAlvo:nHeight,oObjAlvo:nClientHeight)
				aTamObj[1] := (Abs(nTOP) / 100) * (nDimen / 2)
			Else
				aTamObj[1] := Abs(nTOP)
			Endif
		Else
			aTamObj[1] := Abs(nTOP)
		Endif
	Endif
	If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nLEFT))
		If lRefPerc
			If nLEFT < 0
				nDimen := IIf(Type("oObjAlvo:nClientWidth") == "U",oObjAlvo:nWidth,oObjAlvo:nClientWidth)
				aTamObj[2] := (Abs(nLEFT) / 100) * (nDimen / 2)
			Else
				aTamObj[2] := Abs(nLEFT)
			Endif
		Else
			aTamObj[2] := Abs(nLEFT)
		Endif
	Endif
	If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nWIDTH))
		If lRefPerc
			If nWIDTH < 0
				nDimen := IIf(Type("oObjAlvo:nClientWidth") == "U",oObjAlvo:nWidth,oObjAlvo:nClientWidth)
				aTamObj[3] := (Abs(nWIDTH) / 100) * (nDimen / 2)
			Else
				aTamObj[3] := Abs(nWIDTH)
			Endif
		Else
			aTamObj[3] := Abs(nWIDTH)
		Endif
	Endif
	If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nBOTTOM))
		If lRefPerc
			If nBOTTOM < 0
				nDimen := IIf(Type("oObjAlvo:nClientHeight") == "U",oObjAlvo:nHeight,oObjAlvo:nClientHeight)
				aTamObj[4] := (Abs(nBOTTOM) / 100) * (nDimen / 2)
			Else
				aTamObj[4] := Abs(nBOTTOM)
			Endif
		Else
			aTamObj[4] := Abs(nBOTTOM)
		Endif
	Endif

Return Nil

User Function fValCmb()

	Local aArea		:= GetArea()
	Local lRet := .T.

	If Empty(Alltrim(M->PERMISS))
		MsgAlert("Por favor, informar a permiss�o.")
		lRet := .F.
	ElseIf !(Substr(Alltrim(M->PERMISS),1,1) $ "12")
		MsgAlert("Permiss�o inv�lida! Somente permitido 'Sim' ou 'N�o' ")
		lRet := .F.
	EndIf

	If lRet
		SX5->(DbSeek(xFilial("SX5")+"_Q"+oGetUsu:aCols[oGetUsu:nAt][2]))
		RecLock("SX5",.F.)
			SX5->X5_DESCRI := Alltrim(M->PERMISS)
		SX5->(MsUnlock())
	EndIf

	RestArea(aArea)

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMntTel2 �Autor  � Rafael Cruz        � Data �  17/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina Monta tela com erros encontrados na integra��o       ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGerCrt(cNSUTEF)
Local aArea		:= GetArea()
Local aRet		:= {}
Local aTitTwBr	:= {"Origem","Loja","C�digo ERP","Parcela","Bandeira","Valor","Autoriza��o","Parc.Concil","Obs."}
Local aTamBrw	:= {50,50,50,50,50,50,50}
Local oDlgErro	:= NIL
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()

cQuery := " SELECT 'PROTHEUS' AS ORIGEM,							" + CRLF
cQuery += " E1_XDESCFI AS LOJA,										" + CRLF
cQuery += " '' AS MOTIVO,											" + CRLF
cQuery += " E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO AS COD_ERP,	" + CRLF
cQuery += " E1_PARCELA AS PARCELA, 									" + CRLF
cQuery += " E1_XFLAG AS BANDEIRA, 									" + CRLF
cQuery += " E1_VALOR AS VALOR, 										" + CRLF
cQuery += " E1_NSUTEF AS AUTOR, 									" + CRLF
cQuery += " E1_XPARNSU AS PARC2 									" + CRLF
cQuery += " FROM " + retSqlName("SE1") + " (NOLOCK) SE1				" + CRLF
cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "'				" + CRLF
cQuery += " AND E1_NSUTEF LIKE '%"+ RIGHT(Alltrim(cNSUTEF), 6) + "'	" + CRLF
cQuery += " AND E1_XTRCID = ' '										" + CRLF
cQuery += " AND SE1.D_E_L_E_T_ = ' '								" + CRLF
cQuery += " UNION													" + CRLF
cQuery += " SELECT 'CONCIL' AS ORIGEM, 								" + CRLF
cQuery += " ZK3_FILORI AS LOJA,										" + CRLF
cQuery += " ZK3_OBS AS MOTIVO,										" + CRLF
cQuery += " ZK3_CHAVE AS COD_ERP, 									" + CRLF
cQuery += " ZK3_PARC AS PARCELA, 									" + CRLF
cQuery += " ZK3_BAND AS BANDEIRA, 									" + CRLF
cQuery += " ZK3_VLRBRT AS VALOR, 									" + CRLF
cQuery += " ZK3_AUTORI AS AUTOR, 									" + CRLF
cQuery += " ZK3_PARC AS PARC2  										" + CRLF
cQuery += " FROM " + retSqlName("ZK3") + " (NOLOCK) ZK3				" + CRLF
cQuery += " WHERE ZK3_FILIAL = '" + xFilial("ZK3") + "'				" + CRLF
cQuery += " AND ZK3_AUTORI LIKE '%"+ RIGHT(Alltrim(cNSUTEF), 6) + "'	" + CRLF
//uery += " AND ZK3_CHAVE = ' '										" + CRLF
cQuery += " AND ZK3.D_E_L_E_T_ = ' '								" + CRLF

If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf

cQry := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)

While (cAlias)->(!EOF())

	aAdd(aRet,{(cAlias)->ORIGEM,;
			   (cAlias)->LOJA,;
			   (cAlias)->COD_ERP,;
			   (cAlias)->PARCELA,;
			   (cAlias)->BANDEIRA,;
			   (cAlias)->VALOR,;
			   (cAlias)->AUTOR,;
			   (cAlias)->PARC2,;
			   (cAlias)->MOTIVO})

	(cAlias)->(dbSkip())
endDo

Define MsDialog oDlgErro Title "Relat�rio de Cr�tica da Concilia��o" From 0,0 To 375,790 Pixel Of oDlgErro

	If Len(aRet) <= 0
		aAdd(aRet,{"","","","","","","","",""})
	EndIf

	//������������Ŀ
	//�Painel Layer�
	//��������������
	oFwLayer := FwLayer():New()
	oFwLayer:Init(oDlgErro,.F.)

   	//����������Ŀ
	//�1o. Painel�
	//������������
	oFWLayer:addLine("KMERROCR",100, .F.)
	oFWLayer:addCollumn( "COLERROCR",100, .F. , "KMERROCR")
	oFWLayer:addWindow( "COLERROCR", "WINENTR", "Retorno da Concilia��o", 100, .F., .F., , "KMERROCR")
	oFwTwbr := oFWLayer:GetWinPanel("COLERROCR","WINENTR","KMERROCR")

	oFolder:=TFolder():New(0,0,{"Contas a Receber"},,oFwTwbr,,,,.T.,.F.,0,0)
	oFolder:Align := CONTROL_ALIGN_ALLCLIENT

	//���������������������Ŀ
	//�Titulos nao baixados |
	//�����������������������
	oTwBrowse := TWBrowse():New(00,00,00,00,,aTitTwBr,aTamBrw,oFolder:aDialogs[1],,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	oTwBrowse:SetArray(aRet)
		oTwBrowse:bLine := {|| {aRet[oTwBrowse:nAt,1],;
								aRet[oTwBrowse:nAt,2],;
								aRet[oTwBrowse:nAt,3],;
								aRet[oTwBrowse:nAt,4],;
								aRet[oTwBrowse:nAt,5],;
								aRet[oTwBrowse:nAt,6],;
								aRet[oTwBrowse:nAt,7],;
								aRet[oTwBrowse:nAt,8],;
								aRet[oTwBrowse:nAt,9]}}
	oTwBrowse:Align := CONTROL_ALIGN_ALLCLIENT

Activate dialog oDlgErro Center

RestArea(aArea)
Return(.T.)
