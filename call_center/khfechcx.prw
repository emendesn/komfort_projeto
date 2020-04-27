#include 'protheus.ch'
#include 'parmtype.ch'

//--------------------------------------------------------------
/*/{Protheus.doc} KHFECHCX
Description

@param xParam Parameter Description
@return xRet Return Description
@author Wellington Raul Pinto
@since 11/11/2019
/*/
//--------------------------------------------------------------
user function KHFECHCX()

Local oButton1
Local oButton2
Local oGet1
Local oGet2
Local oSay1
Local oSay2
Private dData := DATE()
Private xFilial := SPACE(4)
Private aCxFech := {}


Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Fechamento ADM" FROM 000, 000  TO 100, 500 COLORS 0, 16777215 PIXEL

    @ 010, 010 SAY oSay1 PROMPT "Filial: " SIZE 015, 007  OF oDlg COLORS 0, 16777215 PIXEL
    @ 009, 141 SAY oSay2 PROMPT "Data:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 033, 144 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oDlg ACTION(fFechaC(),oDlg:End()) PIXEL
    @ 033, 200 BUTTON oButton2 PROMPT "Sair" SIZE 037, 012 OF oDlg ACTION(oDlg:End()) PIXEL
    @ 008, 044 MSGET oGet1 VAR xFilial SIZE 060, 010 F3 "SM0" OF oDlg COLORS 0, 16777215 PIXEL
    @ 008, 180 MSGET oGet2 VAR dData SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

	
return



Static function fFechaC()

Local lConf := .F.
Local cQuery := ""
Local cAliasC5 := GetNextALias()


cQuery := CRLF + " SELECT C5_NUM, SC5.R_E_C_N_O_  AS RECNO"
cQuery += CRLF + " FROM SC5010 (NOLOCK) SC5 "
cQuery += CRLF + " INNER JOIN SA3010 (NOLOCK) SA3 ON A3_COD = C5_VEND1 "
cQuery += CRLF + " INNER JOIN SA1010 (NOLOCK) SA1 ON A1_COD = C5_CLIENTE " 
cQuery += CRLF + " AND A1_LOJA = C5_LOJACLI "
cQuery += CRLF + " INNER JOIN SUA010 (NOLOCK) SUA ON UA_NUM = C5_NUMTMK "
cQuery += CRLF + " AND UA_FILIAL = C5_MSFIL "
cQuery += CRLF + " WHERE C5_FILIAL <> ' ' "
cQuery += CRLF + " AND A3_FILIAL = '" + XFILIAL("SA3") + "' "
cQuery += CRLF + " AND A1_FILIAL = '" + XFILIAL("SA1") + "' "
cQuery += CRLF + " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += CRLF + " AND SA3.D_E_L_E_T_ = ' ' "
cQuery += CRLF + "  AND SA1.D_E_L_E_T_ = ' ' "
cQuery += CRLF + " AND C5_NUMTMK <> ' ' "
cQuery += CRLF + " AND C5_MSFIL = '"+xFilial+"' "
cQuery += CRLF + " AND C5_EMISSAO = '"+DTOS(dData)+"'"
cQuery += CRLF + " AND C5_XCONPED <> '1' "
cQuery += CRLF + " AND UA_FILIAL <> ' ' "
cQuery += CRLF + " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += CRLF + " AND SUA.D_E_L_E_T_ = ' ' "

PLSQuery(cQuery,cAliasC5)

	While (cAliasC5)->(!EOF())

		Aadd(aCxFech, {	(cAliasC5)->(C5_NUM),;
		(cAliasC5)->(RECNO)})
		(cAliasC5)->(dbskip())

	End

	(cAliasC5)->(dbCloseArea())
	

	If Len(aCxFech) == 0 
	MsgInfo("Todos os pedidos de : "+DTOS(dData)+" já foram conferidos.")
	return 
	EndIf
	
	If lConf := Msgyesno("Deseja Prosseguir com O Fechamento do caixa? ","Atenção")
		
			iF aCxFech[1][2] >0	
				for ny := 1 to len(aCxFech)
					SC5->(dbgoto(aCxFech[ny][2]))
					recLock("SC5",.F.)
					SC5->C5_XCONPED := '1'
					SC1->C5_XFECADM := '1'
					SC5->(msUnlock())
				next ny
				MsgInfo("Caixa fechado, data : "+DTOS(dData))
			Else
			MsgInfo("Todos os pedidos de : "+DTOS(dData)+" já foram conferidos.")
			return
			EndIf
			
	EndIf
	
return 


