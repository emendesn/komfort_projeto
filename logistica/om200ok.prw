#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"
#include "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  OM200OK บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  27/06/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ PONTO DE ENTRADA ANTES DA GRAVACAO DA CARGA                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION OM200OK()

Local cQuery   := ""
Local aButtons := {}
Local oLogo, oFnt, oPanel, oFiltro
Local lFleg    := .F.
Local nPos	   :=0
Local oBrw	   := Nil
Local bPesq    := {|| KHPESQ(cCombo1, oBrw ), .T.}
Local _lSeleci := .F.
Local _cCarga  := ParamIXB[2][1][2] 
Local cMotorista  := ParamIXB[2][1][13] //Codigo do motorista

Private cNomeMotor := ""

Private _lGrava   := .F.
Private _oDlg
Private _aTermos  := {}
Private _aTerSel  := {}
Private _aTerBkp  := {}
Private cTexto   := dDataBase
Private _aPedSel	 := {}
//Private oOk 	   := LoadBitmap( GetResources(), "CHECKED" )
//Private oNo 	   := LoadBitmap( GetResources(), "UNCHECKED" )

Private oLbx2
Private oLbx3
Private oOK := LoadBitmap(GetResources(),'BR_VERDE')
Private oNO := LoadBitmap(GetResources(),'BR_VERMELHO')
Private oNcon := LoadBitmap(GetResources(),'BR_CINZA')
//Private oOk      := LoadBitmap( GetResources(), "LBOK" )
//Private oNo      := LoadBitmap( GetResources(), "LBNO" )
Private oChk     := Nil
Private _lSai := .F.

Private aSalvAmb := {}
Private cVar     := Nil
Private _cTitulo  := "CARGA x TERMO"
Private _lRet    := .F.
Private _l       := .T.
Private _lC      := .T.
Private lMark    := .F.
Private lChk     := .F.

Private _cQuery		:= ""
Private _cQuery2    := ""
Private QRYSE1      := GetNextAlias()
Private nLastKey    := 0
Private _cParcel    := ""
Private _cDataBx    := ""
Private _aConc      := {}
Private _aConcN     := {}

Private oBitmap1
Private oButton1
Private oButton2
Private oButton3
Private oButton4
Private oFolder1
Private oFont1 := TFont():New("Times New Roman",,015,,.F.,,,,,.F.,.F.)
Private oListBox1
Private nListBox1 := 1
Private oListBox2
Private nListBox2 := 1
Private _oDialog
Private cCombo1  := ""
Private aList	   := {}
Private _cInfo                     
Private _cRecSel := ""

Private _cTpTro := ""

DbSelectArea("DA4")
DA4->(DbSetOrder(1))

if DA4->(dbSeek(xFilial()+cMotorista))
	cNomeMotor := DA4->DA4_NOME
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ VERIFICA DATA DE ENTREGA DE TODOS OS ITENS ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({|| _lGrava:= KHK039()},"Aguarde...")

If _lGrava
	
	_lGrava := .F.
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ FILTRA OS TERMOS DE RETIRA ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := " SELECT CASE WHEN C5_NOTA <> '' THEN C5_NOTA ELSE '' END AS NOTA, "
	cQuery += " CASE WHEN C5_SERIE <> '' THEN C5_SERIE ELSE '' END AS SERIE, "
	cQuery += " CASE WHEN C5_EMISSAO <> '' THEN C5_EMISSAO ELSE '' END AS EMISSAO, ZK0_CARGA CARGA, "
	cQuery += " '' AS DT_EMISNF, ZK0_PEDORI, '' AS DT_EMISPED, ZK0_CLI, ZK0_LJCLI, A1_NOME, "
	cQuery += " A1_END, A1_BAIRRO, A1_EST, A1_CEP, A1_MUN, A1_COMPLEM, A1_DDD, A1_TEL, A1_TEL2, A1_XTEL3, "
	cQuery += " ZK0_COD, ZK0_PROD, ZK0_DESCRI, ZK0_NUMSAC, ZK0_DATA, ZK0_MSFIL, ZK0_DTAGEN, ZK0.R_E_C_N_O_ ZKRECNO, C5_NUM, ZK0_OPCTP "
	cQuery += " FROM " + RETSQLNAME("ZK0") + " ZK0 "
	cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = ZK0_CLI AND A1_LOJA = ZK0_LJCLI "
	cQuery += " LEFT JOIN " + RETSQLNAME("SC5") + " SC5 ON C5_FILIAL = '"+XFILIAL("SC5")+"' "
	cQuery += " AND C5_01SAC = ZK0_NUMSAC "
	cQuery += " WHERE ZK0_FILIAL = '" + XFILIAL("ZK0") + "' "
	cQuery += " AND A1_FILIAL = '" + XFILIAL("SA1") + "' "
	cQuery += " AND ZK0.D_E_L_E_T_ <> '*' "
	cQuery += " AND ZK0_STATUS = '1' "
	cQuery += " AND ZK0_CARGA = ' ' "
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	TRB->(DbGoTop())
	
	If TRB->(EOF())
		Return
	EndIf
	
	While TRB->(!EOF())                                                                              
	
		If TRB->ZK0_OPCTP == '1'
			_cTpTro := 'TROCA'
		ElseIf TRB->ZK0_OPCTP == '2'
			_cTpTro := 'CANCELAMENTO'
		ElseIf TRB->ZK0_OPCTP == "3"
			_cTpTro := 'CONSERTO'
		ElseIf TRB->ZK0_OPCTP == "4"
			_cTpTro := 'TJ/PROCON'
		ElseIf TRB->ZK0_OPCTP == "5"
			_cTpTro := 'EMPRESTIMO'
		Else
			_cTpTro := 'NรO INFORMADO'       
		EndIf	
			
		For nX := 1 To Len(_aPedSel)
			
			//aadd(_aPedSel,{TRBPED->PED_PEDIDO,TRBPED->PED_ITEM,TRBPED->PED_MARCA,TRBPED->PED_CODCLI,TRBPED->PED_LOJA,cEntreg})
			
			If AllTrim(TRB->C5_NUM) ==  _aPedSel[nX][1]	.And. !(cValToChar(TRB->(ZKRECNO)) $ _cRecSel)
				
				_lSeleci := .T.
				
				_cRecSel += cValToChar(TRB->(ZKRECNO))+"|" 
				
				aAdd( _aTerSel , {.T.,;
				ALLTRIM(TRB->NOTA) + " - " + ALLTRIM(TRB->SERIE),;
				DtoC(StoD(TRB->ZK0_DTAGEN)),;
				AllTrim(TRB->ZK0_PEDORI),;
				AllTrim(TRB->ZK0_CLI)+TRB->ZK0_LJCLI,;
				AllTrim(TRB->A1_NOME),;
				AllTrim(TRB->A1_END)+" , "+AllTrim(TRB->A1_BAIRRO)+" , "+AllTrim(TRB->A1_MUN)+" - "+AllTrim(TRB->A1_EST),;
				TRB->A1_CEP,;
				AllTrim(TRB->A1_COMPLEM),;
				"("+AllTrim(TRB->A1_DDD)+")"+AllTrim(TRB->A1_TEL)+"/"+AllTrim(TRB->A1_TEL2)+"/"+AllTrim(TRB->A1_XTEL3),;
				AllTrim(TRB->ZK0_COD),;
				AllTrim(TRB->ZK0_PROD),;
				AllTrim(TRB->ZK0_DESCRI),;
				AllTrim(TRB->ZK0_NUMSAC),;
				TRB->(ZKRECNO),;
				_cTpTro} )
				
			EndIf
			
		Next nX
		
		If !_lSeleci
			
			aAdd( _aTermos , {.F.,;
			ALLTRIM(TRB->NOTA) + " - " + ALLTRIM(TRB->SERIE),;
			DtoC(StoD(TRB->ZK0_DTAGEN)),;
			AllTrim(TRB->ZK0_PEDORI),;
			AllTrim(TRB->ZK0_CLI)+TRB->ZK0_LJCLI,;
			AllTrim(TRB->A1_NOME),;
			AllTrim(TRB->A1_END)+" , "+AllTrim(TRB->A1_BAIRRO)+" , "+AllTrim(TRB->A1_MUN)+" - "+AllTrim(TRB->A1_EST),;
			TRB->A1_CEP,;
			AllTrim(TRB->A1_COMPLEM),;
			"("+AllTrim(TRB->A1_DDD)+")"+AllTrim(TRB->A1_TEL)+"/"+AllTrim(TRB->A1_TEL2)+"/"+AllTrim(TRB->A1_XTEL3),;
			AllTrim(TRB->ZK0_COD),;
			AllTrim(TRB->ZK0_PROD),;
			AllTrim(TRB->ZK0_DESCRI),;
			AllTrim(TRB->ZK0_NUMSAC),;
			TRB->(ZKRECNO),;
			_cTpTro} )
			
		EndIf
		
		_lSeleci := .F.
		TRB->(DbSkip())
		
	EndDo
	
	FAmarra()
	
	IF _lGrava
		
		DbSelectArea("ZK0")
		ZK0->(DbSetOrder(1))
		ZK0->(DbGoTop())
		
		For nX:=1 To Len(_aTerSel)
			
			If _aTerSel[nX,1]
				
				ZK0->(DbGoTop())
				ZK0->(DbGoTo(_aTerSel[nX,15]))
				
				RecLock("ZK0",.F.)
				
				ZK0->ZK0_CARGA  := _cCarga
				ZK0->ZK0_STATUS := "2"
				ZK0->ZK0_CODMOT := cMotorista
				ZK0->ZK0_NOMMOT := cNomeMotor
				
				ZK0->(MsUnlock())
				
				U_KMOMSR04(_aTerSel[nX,15])
				
			EndIf
			
		Next _nx
		
	EndIf
	
Endif

RETURN(_lGrava)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKHK039    บ Autor ณ GLOBAL	         บ Data ณ  18/01/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Nao permitir montagem de carga selecionando parcialmente osบฑฑ
ฑฑบ          ณ itens, quando estes possuem a mesma data de entrega		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

STATIC FUNCTION KHK039 ( )

Local aArea 	:= GetArea()
Local aAreaSC5 	:= SC5->(GetArea())
Local aAreaSC6 	:= SC6->(GetArea())
Local aAreaTRB	:= TRBPED->(GetArea())
Local cEntreg	:=""
Local lContinua	:= .T.
Local aNofleg 	:= {}
Local nQtd		:= 0
Local _nPos     := 0
Local _aPedIt   := {}
Local _aPeds    := {}
Local _nx       := 0
Local _cNum     := ""
Private cPedido	:= PARAMIXB[1][1][5]

DbSelectArea("SC6")
SC6->(DbSetOrder(1))

TRBPED->(DbGoTop())
While TRBPED->(!Eof())
	If !Empty(TRBPED->PED_MARCA) //Itens marcados
		If SC6->(DbSeek(xFilial("SC6")+TRBPED->PED_PEDIDO + TRBPED->PED_ITEM ))
			cEntreg := SC6->C6_ENTREG
			aadd(_aPedSel,{TRBPED->PED_PEDIDO,TRBPED->PED_ITEM,TRBPED->PED_MARCA,TRBPED->PED_CODCLI,TRBPED->PED_LOJA,cEntreg})
			
			//#CMG20180903.bn
			If Len(_aPeds) > 0
				
				_nPos := Ascan(_aPeds,{|x|Alltrim(X[1])==TRBPED->PED_PEDIDO})
				
				If !(_nPos > 0)
					
					AADD(_aPeds,{TRBPED->PED_PEDIDO})
					
				EndIf
				
			Else
				
				AADD(_aPeds,{TRBPED->PED_PEDIDO})
				
			EndIf
			
			AADD(_aPedIt,{TRBPED->PED_PEDIDO+TRBPED->PED_ITEM})
			//#CMG20180903.en
			
		Endif
	Else	// Itens nao marcados
		If SC6->(DbSeek(xFilial("SC6")+TRBPED->PED_PEDIDO + TRBPED->PED_ITEM ))
			cEntreg := SC6->C6_ENTREG
			aadd(aNofleg,{TRBPED->PED_PEDIDO,TRBPED->PED_ITEM,TRBPED->PED_MARCA,TRBPED->PED_CODCLI,TRBPED->PED_LOJA,cEntreg})
		Endif
	EndIf
	TRBPED->(DbSkip())
EndDo

PROCREGUA(Len(_aPedSel))

aSort(_aPeds,,,{|x,y|x[1]<y[1]})
aSort(_aPedIt,,,{|x,y|x[1]<y[1]})

For nX :=1 To Len(_aPedSel)
	Incproc()
	If Ascan( aNofleg ,{|x| x[1]+ DToS(x[6]) == _aPedSel[nX][1] + DtoS(_aPedSel[nX][6])  }) > 0
		lContinua := .F.
		Exit
	Endif
Next nX

If !lContinua
	MsgStop("Nao ้ possํvel realizar a montagem de carga faltando " + Chr(10)+Chr(13) ;
	+ "itens do pedido com mesma data de entrega dos demais.";
	+ Chr(10)+Chr(13) + " Verifique o pedido!", "Aten็ใo")
Else
	
	For _nx := 1 To Len(_aPeds)
		
		SC6->(DbGoTop())
		SC6->(DbSeek(xFilial("SC6")+_aPeds[_nx,1]))
		
		While SC6->(!Eof()) .And. Alltrim(SC6->C6_NUM) == Alltrim(_aPeds[_nx,1])
			
			If Empty(AllTrim(SC6->C6_NOTA))
			
				If !(Ascan( _aPedIt ,{|x| x[1] == SC6->C6_NUM+SC6->C6_ITEM}) > 0)
					_cNum := SC6->C6_NUM+" "+SC6->C6_ITEM
					lContinua := .F.
					Exit
				Endif
			
			EndIf
			
			SC6->(DbSkip())
			
		EndDo
		
		If !lContinua
			Exit
		EndIf
		
	Next _nx
	
	If !lContinua
	
		//MsgStop("Faltando itens do pedido "+_cNum+" - Verifique o pedido!", "Aten็ใo")
	
		If MsgYesNo("O pedido "+_cNum+" nใo estแ completo, deseja faturar parcial?","FATPARC1")
		
			lContinua := MsgYesNo("ATENวรO! Tem certeza que deseja gerar um faturamento parcial?","FATPARC2")
		
		EndIf
		
	EndIf
	
EndIf


RestArea( aArea )
RestArea( aAreaSC5 )
RestArea( aAreaSC6 )
RestArea( aAreaTRB )

Return ( lContinua )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAmarra   บAutor ณ Caio Garcia         บ Data ณ  23/05/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function FAmarra()

aList := {"0-Todos","1-Data Agendamento","2-Ped.Original", "3-Termo Retira","4-C๓d.Produto","5-N๚mero Chamado"}

If Len(_aTerSel) == 0
	AADD(_aTerSel,{.F.,"","","","","","","","","","","","","","",""})
EndIf
//aCopy(_aTermos,_aTerSel)

DEFINE MSDIALOG _oDlg TITLE _cTitulo FROM 000, 000  TO 570, 1200 COLORS 0, 16777215 PIXEL

@ 004, 002 FOLDER oFolder1 SIZE 598, 280 OF _oDlg ITEMS "Termos","Termos Selecionados" COLORS 0, 16777215 MESSAGE "pasta1" PIXEL Of _oDlg
@ 000, 000 LISTBOX oListBox1 VAR cVar FIELDS HEADER ;
"","Nota Fiscal","Tipo Termo","Agendamento","Ped.Original","C๓d.Cliente","Cliente","Endere็o","CEP","Complemento","Tel.Contato","Termo Retira","C๓d.Produto","Produto","N๚mero Chamado";
SIZE 597, 220 OF oFolder1:aDialogs[1] COLORS 0, 16777215 FONT oFont1 PIXEL ON dblClick(_aTermos[oListBox1:nAt,1] := !_aTermos[oListBox1:nAt,1],oListBox1:Refresh())
oListBox1:SetArray( _aTermos )
oListBox1:bLine := {|| {IIf(_aTermos[oListBox1:nAt,1],oOk,oNo)	,;
_aTermos[oListBox1:nAt,2],; //NOTA
_aTermos[oListBox1:nAt,16],; //TIPO DO TERMO
_aTermos[oListBox1:nAt,3],; //DT AGENDAMENTO
_aTermos[oListBox1:nAt,4],; //PEDIDO
_aTermos[oListBox1:nAt,5],;  //COD.CLIENTE
_aTermos[oListBox1:nAt,6],; //NOME CLIENTE
_aTermos[oListBox1:nAt,7],;//END
_aTermos[oListBox1:nAt,8],;//CEP
_aTermos[oListBox1:nAt,9],; //COMPLEMENTO
_aTermos[oListBox1:nAt,10],;   //TEL
_aTermos[oListBox1:nAt,11],;   //TERMO
_aTermos[oListBox1:nAt,12],;   //COD.PROD
_aTermos[oListBox1:nAt,13],;   //DESCR
_aTermos[oListBox1:nAt,14]}}    // SAC


oCombo1 := 	TComboBox():New(235,180,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aList,80,100,oFolder1:aDialogs[1],,{||AltComb(cCombo1)},,,,.T.,,,.F.,{||.T.},.T.,,)

@235,270 MSGET _cInfo PICTURE PesqPict("ZK0","ZK0_COD")  When .F. SIZE 85,13 PIXEL OF oFolder1:aDialogs[1]

@ 230, 360 BUTTON oButton1 PROMPT "Filtrar"       SIZE 050, 025 OF oFolder1:aDialogs[1] ACTION (fFiltrar(Left(cCombo1,1),_cInfo),oListBox1:Refresh(),oListBox2:Refresh()) PIXEL  Of _oDlg
@ 230, 440 BUTTON oButton2 PROMPT "Inverte"       SIZE 050, 025 OF oFolder1:aDialogs[1] ACTION (fInverte(1),oListBox1:Refresh(),oListBox2:Refresh()) PIXEL  Of _oDlg
@ 230, 520 BUTTON oButton3 PROMPT "Processa"      SIZE 050, 025 OF oFolder1:aDialogs[1] ACTION (fProcessa(1),oListBox1:Refresh(),oListBox2:Refresh()) PIXEL  Of _oDlg
@ 230, 440 BUTTON oButton3 PROMPT "Retorna Termo" SIZE 050, 025 OF oFolder1:aDialogs[2] ACTION (fProcessa(2),oListBox1:Refresh(),oListBox2:Refresh()) PIXEL  Of _oDlg
@ 230, 520 BUTTON oButton4 PROMPT "Confirma"      SIZE 050, 025 OF oFolder1:aDialogs[2] ACTION IIF(fFinaliza(),(_oDlg:End()),(oListBox1:Refresh(),oListBox2:Refresh())) PIXEL Of _oDlg
@ 230, 360 BUTTON oButton5 PROMPT "Inverte"       SIZE 050, 025 OF oFolder1:aDialogs[2] ACTION (fInverte(2),oListBox1:Refresh(),oListBox2:Refresh()) PIXEL  Of _oDlg

@ 223, 005 BITMAP oBitmap1 SIZE 058, 046 OF oFolder1:aDialogs[1] RESOURCE "logo1" FILENAME "modelos\logo.jpg" NOBORDER PIXEL Of _oDlg
@ 223, 005 BITMAP oBitmap1 SIZE 058, 046 OF oFolder1:aDialogs[2] RESOURCE "logo1" FILENAME "modelos\logo.jpg" NOBORDER PIXEL Of _oDlg

@ 000, 000 LISTBOX oListBox2 VAR cVar FIELDS HEADER ;
"","Nota Fiscal","Tipo Termo","Agendamento","Ped.Original","C๓d.Cliente","Cliente","Endere็o","CEP","Complemento","Tel.Contato","Termo Retira","C๓d.Produto","Produto","N๚mero Chamado";
SIZE 597, 220 OF oFolder1:aDialogs[2] COLORS 0, 16777215 FONT oFont1 PIXEL ON dblClick(_aTerSel[oListBox2:nAt,1] := !_aTerSel[oListBox2:nAt,1],oListBox2:Refresh())
oListBox2:SetArray(_aTerSel)
oListBox2:bLine := {|| {IIf(_aTerSel[oListBox2:nAt,1],oOk,oNo)	,;
_aTerSel[oListBox2:nAt,2] ,;
_aTerSel[oListBox2:nAt,16] ,; //TIPO DO TERMO
_aTerSel[oListBox2:nAt,3] ,;
_aTerSel[oListBox2:nAt,4] ,;
_aTerSel[oListBox2:nAt,5] ,;
_aTerSel[oListBox2:nAt,6] ,;
_aTerSel[oListBox2:nAt,7] ,;
_aTerSel[oListBox2:nAt,8] ,;
_aTerSel[oListBox2:nAt,9] ,;
_aTerSel[oListBox2:nAt,10] ,;
_aTerSel[oListBox2:nAt,11] ,;
_aTerSel[oListBox2:nAt,12] ,;
_aTerSel[oListBox2:nAt,13] ,;
_aTerSel[oListBox2:nAt,14]}}

ACTIVATE MSDIALOG _oDlg CENTERED Valid Cancela()

If !_lSai
	
	Close(_oDlg)
	
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltComb   บAutor ณ Caio Garcia         บ Data ณ  23/05/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AltComb(cCombo1)

If left(cCombo1,1) == '0'
	_cInfo := Space(TAMSX3("ZK0_PEDORI")[1])
	@235,270  MSGET _cInfo PICTURE PesqPict("ZK0","ZK0_PEDORI") When .F. SIZE 85,13 PIXEL OF oFolder1:aDialogs[1]
ElseIf left(cCombo1,1) == '1'
	_cInfo := CtoD("//")
	@235,270 MSGET _cInfo PICTURE PesqPict("ZK0","ZK0_DTAGEN") SIZE 85,13 PIXEL OF oFolder1:aDialogs[1]
Elseif left(cCombo1,1) == '2'
	_cInfo := Space(TAMSX3("ZK0_PEDORI")[1])
	@235,270  MSGET _cInfo PICTURE PesqPict("ZK0","ZK0_PEDORI") SIZE 85,13 PIXEL OF oFolder1:aDialogs[1]
Elseif left(cCombo1,1) == '3		'
	_cInfo := Space(TAMSX3("ZK0_COD")[1])
	@235,270  MSGET _cInfo PICTURE PesqPict("ZK0","ZK0_COD") SIZE 85,13 PIXEL OF oFolder1:aDialogs[1]
Elseif left(cCombo1,1) == '4'
	_cInfo := Space(TAMSX3("ZK0_PROD")[1])
	@235,270  MSGET _cInfo PICTURE PesqPict("ZK0","ZK0_PROD") F3 "SB1" SIZE 85,13 PIXEL OF oFolder1:aDialogs[1]
Elseif left(cCombo1,1) == '5'
	_cInfo := Space(TAMSX3("ZK0_COD")[1])
	@235,270  MSGET _cInfo PICTURE PesqPict("ZK0","ZK0_COD") SIZE 85,13 PIXEL OF oFolder1:aDialogs[1]
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcessa   บAutor ณ Caio Garcia       บ Data ณ  23/05/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fProcessa(_nOpc)

Local _nQt  := 0
Local _lFim := .T.
Local _lSel := .F.

If _nOpc == 1
	
	While _lFim
		
		_nQt  := Len(_aTermos)
		
		For _nx := 1 To _nQt
			
			If _nx == _nQt
				
				_lFim := .F.
				
			EndIf
			
			If _aTermos[_nx,1]
				
				_lSel := .T.
				
				AADD(_aTerSel,{_aTermos[_nx,1],;
				_aTermos[_nx,2],;
				_aTermos[_nx,3],;
				_aTermos[_nx,4],;
				_aTermos[_nx,5],;
				_aTermos[_nx,6],;
				_aTermos[_nx,7],;
				_aTermos[_nx,8],;
				_aTermos[_nx,9],;
				_aTermos[_nx,10],;
				_aTermos[_nx,11],;
				_aTermos[_nx,12],;
				_aTermos[_nx,13],;
				_aTermos[_nx,14],;
				_aTermos[_nx,15],;
				_aTermos[_nx,16]})
				
				If Empty(Alltrim(_aTerSel[1,3]))
					
					aDel(_aTerSel,1)
					ASize(_aTerSel,(Len(_aTerSel)-1))
					
				EndIf
				
				_nQt--
				aDel(_aTermos,_nx)
				aSize(_aTermos,_nQt)
				Exit
				
			EndIf
			
		Next _nx
		
	EndDo
	
Else
	
	If Empty(Alltrim(_aTerSel[1,3]))
		
		Alert("Nใo existe itens selecionados!")
		Return
		
	EndIf
	
	While _lFim
		
		_nQt  := Len(_aTerSel)
		
		For _nx := 1 To _nQt
			
			If _nx == _nQt
				
				_lFim := .F.
				
			EndIf
			
			If !(_aTerSel[_nx,1])
				
				_lSel := .T.
				
				AADD(_aTermos,{_aTerSel[_nx,1],;
				_aTerSel[_nx,2],;
				_aTerSel[_nx,3],;
				_aTerSel[_nx,4],;
				_aTerSel[_nx,5],;
				_aTerSel[_nx,6],;
				_aTerSel[_nx,7],;
				_aTerSel[_nx,8],;
				_aTerSel[_nx,9],;
				_aTerSel[_nx,10],;
				_aTerSel[_nx,11],;
				_aTerSel[_nx,12],;
				_aTerSel[_nx,13],;
				_aTerSel[_nx,14],;
				_aTerSel[_nx,15],;
				_aTerSel[_nx,16]})
				
				_nQt--
				aDel(_aTerSel,_nx)
				aSize(_aTerSel,_nQt)
				Exit
				
			EndIf
			
		Next _nx
		
	EndDo
	
EndIf

If !_lSel
	
	Alert("Nenhum item foi selecionado!")
	
EndIf

Return

Static Function fInverte(_nOpc)

If _nOpc == 1
	
	For _nx := 1 To Len(_aTermos)
		
		If _aTermos[_nx,1]
			
			_aTermos[_nx,1] := .F.
			
		Else
			
			_aTermos[_nx,1] := .T.
			
		EndIf
		
	Next _nx
Else
	
	For _nx := 1 To Len(_aTerSel)
		
		If _aTerSel[_nx,1]
			
			_aTerSel[_nx,1] := .F.
			
		Else
			
			_aTerSel[_nx,1] := .T.
			
		EndIf
		
	Next _nx
	
	
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfFiltrar    บAutor ณ Caio Garcia       บ Data ณ  23/05/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fFiltrar(_cOpc,_cInfo)

Local _cRecnos := ""
Local _aBkp    := {}
Local _aNovo   := {}

If Empty(_cInfo) .And. _cOpc <> '0'
	
	Alert("Informe uma op็ใo de filtro!")
	Return
	
EndIf

If SubsTr(_cOpc,1,1) == '1'//Data
	
	TRB->(DbGoTop())
	While TRB->(!EOF())
		
		If StoD(TRB->ZK0_DTAGEN) == _cInfo
			
			If Len(_aTerSel) > 0
				
				If !Empty(Alltrim(_aTerSel[1,3]))
					
					For _nx := 1 To Len(_aTerSel)
						
						_cRecnos += AllTrim(Str(_aTerSel[_nx,15]))+"|"
						
					Next _nx
					
				EndIf
				
			EndIf
			
			If !(AllTrim(Str(TRB->(ZKRECNO))) $ _cRecnos)

				If TRB->ZK0_OPCTP == '1'
					_cTpTro := 'TROCA'
				ElseIf TRB->ZK0_OPCTP == '2'
					_cTpTro := 'CANCELAMENTO'
				ElseIf TRB->ZK0_OPCTP == "3"
					_cTpTro := 'CONSERTO'
				ElseIf TRB->ZK0_OPCTP == "4"
					_cTpTro := 'TJ/PROCON'
				ElseIf TRB->ZK0_OPCTP == "5"
					_cTpTro := 'EMPRESTIMO'
				Else
					_cTpTro := 'NรO INFORMADO'       
				EndIf	
				
				aAdd( _aNovo , {.F.,;
				ALLTRIM(TRB->NOTA) + " - " + ALLTRIM(TRB->SERIE),;
				DtoC(StoD(TRB->ZK0_DTAGEN)),;
				AllTrim(TRB->ZK0_PEDORI),;
				AllTrim(TRB->ZK0_CLI)+TRB->ZK0_LJCLI,;
				AllTrim(TRB->A1_NOME),;
				AllTrim(TRB->A1_END)+" , "+AllTrim(TRB->A1_BAIRRO)+" , "+AllTrim(TRB->A1_MUN)+" - "+AllTrim(TRB->A1_EST),;
				TRB->A1_CEP,;
				AllTrim(TRB->A1_COMPLEM),;
				"("+AllTrim(TRB->A1_DDD)+")"+AllTrim(TRB->A1_TEL)+"/"+AllTrim(TRB->A1_TEL2)+"/"+AllTrim(TRB->A1_XTEL3),;
				AllTrim(TRB->ZK0_COD),;
				AllTrim(TRB->ZK0_PROD),;
				AllTrim(TRB->ZK0_DESCRI),;
				AllTrim(TRB->ZK0_NUMSAC),;
				TRB->(ZKRECNO),;
				_cTpTro} )
				
			EndIf
			
		EndIf
		
		TRB->(DbSkip())
		
	EndDo
	
ElseIf SubsTr(_cOpc,1,1) == '2'//Pedido
	
	TRB->(DbGoTop())
	While TRB->(!EOF())
		
		If AllTrim(TRB->ZK0_PEDORI) == Alltrim(_cInfo)
			
			If Len(_aTerSel) > 0
				
				If !Empty(Alltrim(_aTerSel[1,3]))
					
					For _nx := 1 To Len(_aTerSel)
						
						_cRecnos += AllTrim(Str(_aTerSel[_nx,15]))+"|"
						
					Next _nx
					
				EndIf
				
			EndIf
			
			If !(AllTrim(Str(TRB->(ZKRECNO))) $ _cRecnos)

				If TRB->ZK0_OPCTP == '1'
					_cTpTro := 'TROCA'
				ElseIf TRB->ZK0_OPCTP == '2'
					_cTpTro := 'CANCELAMENTO'
				ElseIf TRB->ZK0_OPCTP == "3"
					_cTpTro := 'CONSERTO'
				ElseIf TRB->ZK0_OPCTP == "4"
					_cTpTro := 'TJ/PROCON'
				ElseIf TRB->ZK0_OPCTP == "5"
					_cTpTro := 'EMPRESTIMO'
				Else
					_cTpTro := 'NรO INFORMADO'       
				EndIf	
				
				aAdd( _aNovo , {.F.,;
				ALLTRIM(TRB->NOTA) + " - " + ALLTRIM(TRB->SERIE),;
				DtoC(StoD(TRB->ZK0_DTAGEN)),;
				AllTrim(TRB->ZK0_PEDORI),;
				AllTrim(TRB->ZK0_CLI)+TRB->ZK0_LJCLI,;
				AllTrim(TRB->A1_NOME),;
				AllTrim(TRB->A1_END)+" , "+AllTrim(TRB->A1_BAIRRO)+" , "+AllTrim(TRB->A1_MUN)+" - "+AllTrim(TRB->A1_EST),;
				TRB->A1_CEP,;
				AllTrim(TRB->A1_COMPLEM),;
				"("+AllTrim(TRB->A1_DDD)+")"+AllTrim(TRB->A1_TEL)+"/"+AllTrim(TRB->A1_TEL2)+"/"+AllTrim(TRB->A1_XTEL3),;
				AllTrim(TRB->ZK0_COD),;
				AllTrim(TRB->ZK0_PROD),;
				AllTrim(TRB->ZK0_DESCRI),;
				AllTrim(TRB->ZK0_NUMSAC),;
				TRB->(ZKRECNO),;
				_cTpTro} )
				
			EndIf
			
		EndIf
		
		TRB->(DbSkip())
		
	EndDo
	
ElseIf SubsTr(_cOpc,1,1) == '3'//Termo
	
	TRB->(DbGoTop())
	While TRB->(!EOF())
		
		If Alltrim(TRB->ZK0_COD) == Alltrim(_cInfo)
			
			If Len(_aTerSel) > 0
				
				If !Empty(Alltrim(_aTerSel[1,3]))
					
					For _nx := 1 To Len(_aTerSel)
						
						_cRecnos += AllTrim(Str(_aTerSel[_nx,15]))+"|"
						
					Next _nx
					
				EndIf
				
			EndIf
			
			If !(AllTrim(Str(TRB->(ZKRECNO))) $ _cRecnos)
				       
				If TRB->ZK0_OPCTP == '1'
					_cTpTro := 'TROCA'
				ElseIf TRB->ZK0_OPCTP == '2'
					_cTpTro := 'CANCELAMENTO'
				ElseIf TRB->ZK0_OPCTP == "3"
					_cTpTro := 'CONSERTO'
				ElseIf TRB->ZK0_OPCTP == "4"
					_cTpTro := 'TJ/PROCON'
				ElseIf TRB->ZK0_OPCTP == "5"
					_cTpTro := 'EMPRESTIMO'
				Else
					_cTpTro := 'NรO INFORMADO'       
				EndIf					
				
				aAdd( _aNovo , {.F.,;
				ALLTRIM(TRB->NOTA) + " - " + ALLTRIM(TRB->SERIE),;
				DtoC(StoD(TRB->ZK0_DTAGEN)),;
				AllTrim(TRB->ZK0_PEDORI),;
				AllTrim(TRB->ZK0_CLI)+TRB->ZK0_LJCLI,;
				AllTrim(TRB->A1_NOME),;
				AllTrim(TRB->A1_END)+" , "+AllTrim(TRB->A1_BAIRRO)+" , "+AllTrim(TRB->A1_MUN)+" - "+AllTrim(TRB->A1_EST),;
				TRB->A1_CEP,;
				AllTrim(TRB->A1_COMPLEM),;
				"("+AllTrim(TRB->A1_DDD)+")"+AllTrim(TRB->A1_TEL)+"/"+AllTrim(TRB->A1_TEL2)+"/"+AllTrim(TRB->A1_XTEL3),;
				AllTrim(TRB->ZK0_COD),;
				AllTrim(TRB->ZK0_PROD),;
				AllTrim(TRB->ZK0_DESCRI),;
				AllTrim(TRB->ZK0_NUMSAC),;
				TRB->(ZKRECNO),;
				_cTpTro} )
				
			EndIf
			
		EndIf
		
		TRB->(DbSkip())
		
	EndDo
	
ElseIf SubsTr(_cOpc,1,1) == '4'//Produto
	
	TRB->(DbGoTop())
	While TRB->(!EOF())
		
		If AllTrim(TRB->ZK0_PROD) == Alltrim(_cInfo)
			
			If Len(_aTerSel) > 0
				
				If !Empty(Alltrim(_aTerSel[1,3]))
					
					For _nx := 1 To Len(_aTerSel)
						
						_cRecnos += AllTrim(Str(_aTerSel[_nx,15]))+"|"
						
					Next _nx
					
				EndIf
				
			EndIf
			
			If !(AllTrim(Str(TRB->(ZKRECNO))) $ _cRecnos)

				If TRB->ZK0_OPCTP == '1'
					_cTpTro := 'TROCA'
				ElseIf TRB->ZK0_OPCTP == '2'
					_cTpTro := 'CANCELAMENTO'
				ElseIf TRB->ZK0_OPCTP == "3"
					_cTpTro := 'CONSERTO'
				ElseIf TRB->ZK0_OPCTP == "4"
					_cTpTro := 'TJ/PROCON'
				ElseIf TRB->ZK0_OPCTP == "5"
					_cTpTro := 'EMPRESTIMO'
				Else
					_cTpTro := 'NรO INFORMADO'       
				EndIf	
				
				aAdd( _aNovo , {.F.,;
				ALLTRIM(TRB->NOTA) + " - " + ALLTRIM(TRB->SERIE),;
				DtoC(StoD(TRB->ZK0_DTAGEN)),;
				AllTrim(TRB->ZK0_PEDORI),;
				AllTrim(TRB->ZK0_CLI)+TRB->ZK0_LJCLI,;
				AllTrim(TRB->A1_NOME),;
				AllTrim(TRB->A1_END)+" , "+AllTrim(TRB->A1_BAIRRO)+" , "+AllTrim(TRB->A1_MUN)+" - "+AllTrim(TRB->A1_EST),;
				TRB->A1_CEP,;
				AllTrim(TRB->A1_COMPLEM),;
				"("+AllTrim(TRB->A1_DDD)+")"+AllTrim(TRB->A1_TEL)+"/"+AllTrim(TRB->A1_TEL2)+"/"+AllTrim(TRB->A1_XTEL3),;
				AllTrim(TRB->ZK0_COD),;
				AllTrim(TRB->ZK0_PROD),;
				AllTrim(TRB->ZK0_DESCRI),;
				AllTrim(TRB->ZK0_NUMSAC),;
				TRB->(ZKRECNO),;
				_cTpTro} )
				
			EndIf
			
		EndIf
		
		TRB->(DbSkip())
		
	EndDo
	
ElseIf SubsTr(_cOpc,1,1) == '5'//SAC
	
	TRB->(DbGoTop())
	While TRB->(!EOF())
		
		If AllTrim(TRB->ZK0_NUMSAC) == Alltrim(_cInfo)
			
			If Len(_aTerSel) > 0
				
				If !Empty(Alltrim(_aTerSel[1,3]))
					
					For _nx := 1 To Len(_aTerSel)
						
						_cRecnos += AllTrim(Str(_aTerSel[_nx,15]))+"|"
						
					Next _nx
					
				EndIf
				
			EndIf
			
			If !(AllTrim(Str(TRB->(ZKRECNO))) $ _cRecnos)

				If TRB->ZK0_OPCTP == '1'
					_cTpTro := 'TROCA'
				ElseIf TRB->ZK0_OPCTP == '2'
					_cTpTro := 'CANCELAMENTO'
				ElseIf TRB->ZK0_OPCTP == "3"
					_cTpTro := 'CONSERTO'
				ElseIf TRB->ZK0_OPCTP == "4"
					_cTpTro := 'TJ/PROCON'
				ElseIf TRB->ZK0_OPCTP == "5"
					_cTpTro := 'EMPRESTIMO'
				Else
					_cTpTro := 'NรO INFORMADO'       
				EndIf	
				
				aAdd( _aNovo , {.F.,;
				ALLTRIM(TRB->NOTA) + " - " + ALLTRIM(TRB->SERIE),;
				DtoC(StoD(TRB->ZK0_DTAGEN)),;
				AllTrim(TRB->ZK0_PEDORI),;
				AllTrim(TRB->ZK0_CLI)+TRB->ZK0_LJCLI,;
				AllTrim(TRB->A1_NOME),;
				AllTrim(TRB->A1_END)+" , "+AllTrim(TRB->A1_BAIRRO)+" , "+AllTrim(TRB->A1_MUN)+" - "+AllTrim(TRB->A1_EST),;
				TRB->A1_CEP,;
				AllTrim(TRB->A1_COMPLEM),;
				"("+AllTrim(TRB->A1_DDD)+")"+AllTrim(TRB->A1_TEL)+"/"+AllTrim(TRB->A1_TEL2)+"/"+AllTrim(TRB->A1_XTEL3),;
				AllTrim(TRB->ZK0_COD),;
				AllTrim(TRB->ZK0_PROD),;
				AllTrim(TRB->ZK0_DESCRI),;
				AllTrim(TRB->ZK0_NUMSAC),;
				TRB->(ZKRECNO),;
				_cTpTro} )
				
			EndIf
			
		EndIf
		
		TRB->(DbSkip())
		
	EndDo
	
Else
	
	TRB->(DbGoTop())
	While TRB->(!EOF())
		
		If Len(_aTerSel) > 0
			
			If !Empty(Alltrim(_aTerSel[1,3]))
				
				For _nx := 1 To Len(_aTerSel)
					
					_cRecnos += AllTrim(Str(_aTerSel[_nx,15]))+"|"
					
				Next _nx
				
			EndIf
			
		EndIf
		
		If !(AllTrim(Str(TRB->(ZKRECNO))) $ _cRecnos)

			If TRB->ZK0_OPCTP == '1'
				_cTpTro := 'TROCA'
			ElseIf TRB->ZK0_OPCTP == '2'
				_cTpTro := 'CANCELAMENTO'
			ElseIf TRB->ZK0_OPCTP == "3"
				_cTpTro := 'CONSERTO'
			ElseIf TRB->ZK0_OPCTP == "4"
				_cTpTro := 'TJ/PROCON'
			ElseIf TRB->ZK0_OPCTP == "5"
				_cTpTro := 'EMPRESTIMO'
			Else
				_cTpTro := 'NรO INFORMADO'
			EndIf
						
			aAdd( _aNovo , {.F.,;
			ALLTRIM(TRB->NOTA) + " - " + ALLTRIM(TRB->SERIE),;
			DtoC(StoD(TRB->ZK0_DTAGEN)),;
			AllTrim(TRB->ZK0_PEDORI),;
			AllTrim(TRB->ZK0_CLI)+TRB->ZK0_LJCLI,;
			AllTrim(TRB->A1_NOME),;
			AllTrim(TRB->A1_END)+" , "+AllTrim(TRB->A1_BAIRRO)+" , "+AllTrim(TRB->A1_MUN)+" - "+AllTrim(TRB->A1_EST),;
			TRB->A1_CEP,;
			AllTrim(TRB->A1_COMPLEM),;
			"("+AllTrim(TRB->A1_DDD)+")"+AllTrim(TRB->A1_TEL)+"/"+AllTrim(TRB->A1_TEL2)+"/"+AllTrim(TRB->A1_XTEL3),;
			AllTrim(TRB->ZK0_COD),;
			AllTrim(TRB->ZK0_PROD),;
			AllTrim(TRB->ZK0_DESCRI),;
			AllTrim(TRB->ZK0_NUMSAC),;
			TRB->(ZKRECNO),;
			_cTpTro} )
			
		EndIf
		
		TRB->(DbSkip())
		
	EndDo
	
EndIf

If Len(_aNovo) == 0
	
	Alert("Nใo foram encontrados registros com os parโmetros informados!")
	
Else
	
	For _nx := 1 To Len(_aTermos)
		
		aDel(_aTermos,1)
		
		If Len(_aTermos) == 0
			
			Exit
			
		EndIf
		
	Next _nx
	
	If Len(_aNovo) > Len(_aTermos)
		
		For _nx := 1 To Len(_aTermos)
			
			_aTermos[_nx] := _aNovo[_nx]
			
		Next _nx
		
		aSize(_aTermos,Len(_aTermos))
		
		For _nx := _nx To Len(_aNovo)
			
			AADD(_aTermos,{_aNovo[_nx,1],;
			_aNovo[_nx,2],;
			_aNovo[_nx,3],;
			_aNovo[_nx,4],;
			_aNovo[_nx,5],;
			_aNovo[_nx,6],;
			_aNovo[_nx,7],;
			_aNovo[_nx,8],;
			_aNovo[_nx,9],;
			_aNovo[_nx,10],;
			_aNovo[_nx,11],;
			_aNovo[_nx,12],;
			_aNovo[_nx,13],;
			_aNovo[_nx,14],;
			_aNovo[_nx,15],;
			_aNovo[_nx,16]})
			
		Next _nx
		
	Else
		
		For _nx := 1 To Len(_aNovo)
			
			_aTermos[_nx] := _aNovo[_nx]
			
		Next _nx
		
		aSize(_aTermos,Len(_aNovo))
		
	EndIf
	
EndIf

Return .T.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldInfo    บAutor ณ Caio Garcia       บ Data ณ  23/05/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fVldInfo(_cInfo)

_oDialog:Refresh()


Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCancela     บAutor ณ Caio Garcia       บ Data ณ  23/05/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function Cancela()

_lSai := .T.

Return(_lSai)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfFinaliza   บAutor ณ Caio Garcia       บ Data ณ  23/05/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fFinaliza()

Local _lFinaliza := .F.

If Len(_aTerSel) > 0
	
	If !Empty(Alltrim(_aTerSel[1,3]))
		
		
		If MsgYesNo("Confirma finaliza็ใo da rotina e impressใo dos termos selecionados?","CONFIRMA?")
			
			_lSai := .T.
			_lGrava := .T.
			_lFinaliza := .T.
			
		Else
			
			_lGrava := .F.
			
		EndIf
		
	Else
		
		If MsgYesNo("Nenhum termo foi selecionado, confirma?","CONFIRMA?")
			
			_lSai := .T.
			_lGrava := .T.
			_lFinaliza := .T.
			
		EndIf
		
	EndIf
	
Else
	
	If MsgYesNo("Nenhum termo foi selecionado, confirma?","CONFIRMA?")
		
		_lSai := .T.
		_lGrava := .T.
		_lFinaliza := .T.
		
	EndIf
	
EndIf

Return _lFinaliza
