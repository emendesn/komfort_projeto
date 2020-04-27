#include 'protheus.ch'
#include 'parmtype.ch'
#include 'FWMBrowse.ch'

User Function OM460MNU()

ADD OPTION aRotina TITLE "Carga Presa" ACTION "U_LibCar()" OPERATION 6 ACCESS 0
	
Return

User Function LibCar()

Local _aArea:= GetArea()
Local _cFil := DAK_FILIAL
Local _cCod := DAK_COD
Local _cSeq := DAK_SEQCAR

DAK->(DbSetorder(1))

If DAK->(DbSeek(_cFil + _cCod + _cSeq))
	If !EMPTY(DAK_OK)
		RecLock("DAK",.F.)
			DAK->DAK_FEZNF := '1'
		MsUnlock()
		
		MsgAlert("Carga  "+ _cCod + "  Liberada com sucesso.")
	Else
		MsgAlert("Selecione o registro para liberação da carga presa.")
	EndIf
Else
	MsgAlert("Carga não encontrada.")	
EndIf

RestArea(_aArea)

Return