#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
'±±ºPrograma  ³KMHCADB1  º Autor ³ Vanito Rocha  º Data ³  15/10/19       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina que importa de um .CSV os produtos criando novos    º±±
±±º          ³ Códigos													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST                                                    º±±

±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function KMHCADB1()

Local _cFile := ""
Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .F.
Private vItens:= {}
Private oModel := Nil
Private aRotina := {}

oModel := FwLoadModel ("MATA010")
oModel:SetOperation(MODEL_OPERATION_INSERT)
oModel:Activate()

If xView(@_cFile)
	Processa({|| KHIMPROC(_cFile)}, "Importando Registros ...", "Aguarde")
Else
	Return
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
'±±ºPrograma  ³KHIMPROC	º Autor ³ Vanito Rocha  º Data ³  15/10/19        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function KHIMPROC(_cFile)

Local _nHdl
Local _cLinha := ""
Local _aLinha := {}
Local vItem:= {}
Local xQuant := 0
Local xLocaliz:= ""
Private _lError := .F.


If !File(_cFile)
	MsgStop("O arquivo informado nao existe","KHIMPROC")
	Return
EndIf


_nHdl := fOpen(_cFile)

fClose(_nHdl)
_nHdl := FT_FUse(_cFile)
_nLinhas := FT_FLastRec() - 1

ProcRegua(_nLinhas)
dbSelectArea("SB1")
dbSetOrder(1)


FT_FGoTop()


While !FT_FEOF()
	_cLinha := FT_FReadLn()
	_aLinha := U_KmhSpl(_cLinha, ";")
	DbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	If !SB1->(dbSeek(xFilial("SB1")+_aLinha[1]))
		If _aLinha[1]=='CODIGO'
			FT_FSkip()
			Loop
		Endif
		vItem := {	{"B1_COD",Alltrim(_aLinha[1])						   	   													,NIL},;
		{"B1_UM"     	,_aLinha[7]																								,NIL},;
		{"B1_DESC"  	,_aLinha[2]+" "+_aLinha[3]+" "+_aLinha[5]+" "+_aLinha[6]												,NIL},;
		{"B1_POSIPI"  	,'00000000'																								,NIL},;
		{"B1_TIPO" 		,Alltrim(_aLinha[4])   									   												,NIL},;
		{"B1_UM"   		,_aLinha[7]									   															,NIL},;
		{"B1_SEGUM"		,_aLinha[10]																							,NIL},;
		{"B1_LOCPAD"	,_aLinha[8] 																									,NIL},;
		{"B1_GRUPO"		,_aLinha[9]    																							,NIL},;
		{"B1_MRP"		,_aLinha[11]																							,NIL},;
		{"B1_MSBLQL"	,_aLinha[13]																							,NIL},;
		{"B1_LOCALIZ"	,_aLinha[12]												   											,Nil} }
		
		
		lMsErroAuto := .F.
		FWMVCRotAuto( oModel,"SB1",MODEL_OPERATION_INSERT,{{"SB1MASTER", vItem}})
		
		If lMsErroAuto
			DisarmTransaction()
   			MostraErro()
		Endif
	Endif
	FT_FSkip()
	IncProc()
Enddo

MsgInfo("Fim do processamento","Fim Processamento")

Return


Static Function xView(_cFile)

Local _lOk   := .F.
Local _lFile := .F.
Local _oDlg
Local _lOkBtn
Local _lFileBtn
Local _lCancBtn


DEFINE MSDIALOG _oDlg TITLE "Importação do Cadastro de Produtos" From 0, 0 To 100, 350 PIXEL


@ 08, 08  Say "Esta rotina tem como função importar Cadastro de Produtos." PIXEL

_lCancBtn := SButton():Create(_oDlg, 32, 060, 2, {|| _oDlg:End()}, .T., 'Cancela a rotina', {||.T.})
_lFileBtn := SButton():Create(_oDlg, 32, 095, 14, {|| _lFile := xGetFile(_oDlg, @_cFile, @_lOkBtn)}, .T., 'Seleciona o arquivo a ser importado', {||.T.})
_lOkBtn := SButton():Create(_oDlg, 32, 130, 1, {|| _lOk := .T., _oDlg:End()}, _lFile, 'Processa o arquivo selecionado', {||.T.})


_lOkBtn:lVisibleControl := .F.


Activate MsDialog _oDlg Centered

Return _lOk


Static Function xGetFile(_oDlg, _cFile, _oButton)

Local _cFile := cGetFile( 'CSV|*.csv' , 'Selectione o Arquivo', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE ),.F. )

_oButton:lVisibleControl := !Empty(_cFile)

Return !Empty(_cFile)
