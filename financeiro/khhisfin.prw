#include 'protheus.ch'
#include 'parmtype.ch'


#DEFINE ENTER (Chr(13)+Chr(10))

//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -Wellington Raul
@since 11/02/2019
/*/
//--------------------------------------------------------------

User Function KHHISFIN()


Local oButton1
Local oButton2
Local oGet1
Local cHIs:= SA1->A1_XOBSFIN
Local oGet2
Local cNovo := ""
Local oGet3
Local dRetor:= Date()
Local dBolet:= Date()
Local oSay1
Local oSay2
Local oSay3
Local nRadMenu4 := 1 
Private xCliente:=SA1->A1_COD
Private xLoja   :=SA1->A1_LOJA
Static oDlg



DEFINE MSDIALOG oDlg TITLE "Histórico do Cliente" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

@ 027, 013 GET oGet1 VAR cHIs MEMO SIZE 226, 073 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
@ 122, 013 GET oGet2 VAR cNovo MEMO SIZE 221, 077 OF oDlg COLORS 0, 16777215 PIXEL
@ 013, 089 SAY oSay1 PROMPT "Histórico Financeiro" SIZE 064, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 107, 097 SAY oSay2 PROMPT "Novo Histórico" SIZE 044, 009 OF oDlg COLORS 0, 16777215 PIXEL
@ 212, 136 BUTTON oButton1 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION(oDlg:End())  PIXEL
@ 212, 191 BUTTON oButton2 PROMPT "Salvar" SIZE 037, 012 OF oDlg ACTION (KhGrvHis(cNovo,xCliente,xLoja),oDlg:End()) PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function KhGrvHis(cNovaObs,xCliente,xLoja)

Local dData := DATE()
Local cUser := LogUserName()
Local nDifParc := 0
Local cAnexo := "" 
Local xUser:=UsrRetName(__cUserID)

If !EMPTY(cNovaObs)
	DbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If  SA1->(dbSeek(xFilial()+xCliente+xLoja))
		RecLock("SA1", .F.)
		SA1->A1_XOBSFIN += "Usuario: " + xUser + "  Data: " + dtoc(dDatabase) + "   " + (cNovaObs) +  ENTER+ENTER
		MsUnLock()
	EndIf
Else
	MSGINFO( "Nenhuma Informação Inserida", "Aviso" )
	
EndIf

Return
