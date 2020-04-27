#include 'protheus.ch'
#include 'parmtype.ch'

user function KHVISFIL(_cProd)
	Local oButton1
	Local oButton2
	Local oGroup1
	Local oGroup2
	Private oBrwPedi
	Private aPedVen := {}
	Private oSupOk := LoadBitMap(GetResources(), "LBOK")
    Private oSupNo := LoadBitMap(GetResources(), "LBNO")
	Static oTela

	DEFINE MSDIALOG oTela TITLE "Libera Fila" FROM 000, 000  TO 300, 1200 COLORS 0, 16777215 PIXEL

    @ 004, 003 GROUP oGroup1 TO 118, 593 PROMPT "Fila" OF oTela COLOR 0, 16777215 PIXEL
    @ 119, 004 GROUP oGroup2 TO 148, 592 PROMPT "Ação" OF oTela COLOR 0, 16777215 PIXEL
	@ 129, 493 BUTTON oButton1 PROMPT "Confirmar " SIZE 037, 012 OF oTela ACTION(fGralib(_cProd)) PIXEL
    @ 129, 542 BUTTON oButton2 PROMPT "Sair" SIZE 037, 012 OF oTela ACTION(oTela:END()) PIXEL
	
	oBrwPedi := TwBrowse():New(013, 005, 593, 109,, {;
	 '',;
	'Pedido',;
	'Produto',;
	'Item',;
	'Descricao',;
	'Armazem',;
	'Saldo',;
	'Disponivel',;
	'Emp_fisico',;
	'Localizacao',;
	'Fila',;
	'Enderecar',;
	'Lib_Venda',;
	'Entrega',;
	},,oTela,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
	oBrwPedi:bLDblClick := {|| fMarSup(oBrwPedi:nAt)  }
	fGerPed(_cProd)


	ACTIVATE MSDIALOG oTela CENTERED

Return


Static function fGerPed(_cProd)

	Local cAliPed := getNextAlias()
	Local cQuery := ""
	Local nTot := 0
	Local cTot := ""
	aPedVen := {}
	//nTot := val(nValor)
	
cQuery := CRLF + " SELECT  C6_NUM AS PEDIDO,C6_PRODUTO AS PRODUTO, C6_ITEM AS ITEM, C6_DESCRI AS DESCRICAO, C6_LOCAL AS ARMAZEM, "
cQuery += CRLF + "  (SELECT B2_QATU AS LIBERADO FROM " + RetSqlName("SB2") + " (NOLOCK) SB3  "
cQuery += CRLF + "  WHERE SB3.D_E_L_E_T_ = ''  "
cQuery += CRLF + "  AND SB3.B2_LOCAL = '01'  "
cQuery += CRLF + "  AND SB3.B2_FILIAL = '0101' " 
cQuery += CRLF + "  AND SB3.B2_COD = SC6.C6_PRODUTO   "
cQuery += CRLF + "  ) AS SALDO,  "
cQuery += CRLF + "  (SELECT SB9.B2_QATU - (SB9.B2_QEMP+SB9.B2_RESERVA  +( "
cQuery += CRLF + "  (  "
cQuery += CRLF + "  SELECT CASE WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED  "
cQuery += CRLF + "  FROM SC6010 (NOLOCK) C6  "
cQuery += CRLF + " 	WHERE C6.D_E_L_E_T_ <> '*' "  
cQuery += CRLF + " 	AND C6.C6_PRODUTO = SC6.C6_PRODUTO   "
cQuery += CRLF + "  	AND C6.C6_NOTA = ''   "
cQuery += CRLF + "  	AND C6.C6_BLQ <> 'R'  "
cQuery += CRLF + " 	AND C6_QTDEMP = 0 "
cQuery += CRLF + " 	AND C6_QTDVEN > C6_QTDLIB "
cQuery += CRLF + " 	AND C6.C6_CLI <> '000001'  "
cQuery += CRLF + " 	AND C6.C6_FILIAL = '01'  "
cQuery += CRLF + "  )  "
cQuery += CRLF + "  - "
cQuery += CRLF + "  (  "
cQuery += CRLF + "  	SELECT CASE WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED   "
cQuery += CRLF + "  	FROM SC6010 (NOLOCK) C6   "
cQuery += CRLF + " 	WHERE C6.D_E_L_E_T_ <> '*'  " 
cQuery += CRLF + " 	AND C6.C6_PRODUTO = SC6.C6_PRODUTO    "
cQuery += CRLF + " 	AND C6.C6_NOTA = ''  "
cQuery += CRLF + " 	AND C6.C6_BLQ <> 'R'   "
cQuery += CRLF + " 	AND C6_QTDEMP = 0 "
cQuery += CRLF + " 	AND C6_QTDVEN > C6_QTDLIB "
cQuery += CRLF + " 	AND C6.C6_CLI <> '000001'   "
cQuery += CRLF + " 	AND C6.C6_FILIAL = '01' "
cQuery += CRLF + " 	AND C6.C6_XVENDA = '1' "
cQuery += CRLF + "  ) + SB9.B2_QACLASS  "
cQuery += CRLF + "   ) ) AS LIBERADO FROM " + RetSqlName("SB2") + " (NOLOCK) SB9 "
cQuery += CRLF + "  WHERE D_E_L_E_T_ = ''  "
cQuery += CRLF + "  AND SB9.B2_LOCAL = '01'  "
cQuery += CRLF + "  AND SB9.B2_FILIAL = '0101' "
cQuery += CRLF + "  AND SB9.B2_COD = SC6.C6_PRODUTO    "
cQuery += CRLF + "  ) AS DISPONIVEL "
cQuery += CRLF + "  , "
cQuery += CRLF + "  ( "
cQuery += CRLF + "  SELECT  B2_RESERVA AS LIBERADO FROM " + RetSqlName("SB2") + " (NOLOCK)  "
cQuery += CRLF + "  WHERE D_E_L_E_T_ = '' "
cQuery += CRLF + "  AND B2_LOCAL = '01' "
cQuery += CRLF + "  AND B2_FILIAL = '0101' "
cQuery += CRLF + "  AND B2_COD = SC6.C6_PRODUTO   "
cQuery += CRLF + "  ) AS EMP_FISICO, "
cQuery += CRLF + "  C6_LOCALIZ AS LOC_PEDIDO, "
cQuery += CRLF + "   ( "
cQuery += CRLF + "  	 SELECT CASE WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED   "
cQuery += CRLF + "  FROM SC6010 (NOLOCK) C6  "
cQuery += CRLF + "  WHERE C6.D_E_L_E_T_ <> '*'  "
cQuery += CRLF + "  AND C6.C6_PRODUTO = SC6.C6_PRODUTO   "
cQuery += CRLF + " AND C6_NOTA = ''  "
cQuery += CRLF + " AND C6_BLQ <> 'R' "
cQuery += CRLF + "  AND C6_CLI <> '000001' "
cQuery += CRLF + "  AND C6_FILIAL = '01' "
cQuery += CRLF + "  ) AS FILA, "
cQuery += CRLF + "  ( "
cQuery += CRLF + "  SELECT  B2_QACLASS AS LIBERADO FROM " + RetSqlName("SB2") + " (NOLOCK) "
cQuery += CRLF + "  WHERE D_E_L_E_T_ = '' "
cQuery += CRLF + "  AND B2_LOCAL = '01' "
cQuery += CRLF + "  AND B2_FILIAL = '0101' "
cQuery += CRLF + "  AND B2_COD = SC6.C6_PRODUTO   "
cQuery += CRLF + "  ) AS ENDERECAR, "
cQuery += CRLF + "  CASE "
cQuery += CRLF + "  WHEN C6_XVENDA = '1' THEN 'SIM' "
cQuery += CRLF + "  ELSE 'NAO' "
cQuery += CRLF + "  END LIB_VENDA, SUBSTRING(C6_ENTREG ,7,2)+'/'+SUBSTRING(C6_ENTREG ,5,2)+'/'+SUBSTRING(C6_ENTREG ,1,4)   AS ENTREGA, SC6.R_E_C_N_O_ AS RECNO "
cQuery += CRLF + " FROM SC6010(NOLOCK) SC6 "
cQuery += CRLF + " INNER JOIN SB1010(NOLOCK) SB1 ON SC6.C6_PRODUTO = SB1.B1_COD  "
cQuery += CRLF + " INNER JOIN SC5010(NOLOCK) SC5 ON SC6.C6_MSFIL = SC5.C5_MSFIL AND SC6.C6_NUM = SC5.C5_NUM "
cQuery += CRLF + " WHERE C6_FILIAL <> ' ' "
cQuery += CRLF + " AND C6_PRODUTO = '"+_cProd+"' "
cQuery += CRLF + " AND C6_NOTA = ''  "
cQuery += CRLF + " AND C6_BLQ <> 'R'  "
cQuery += CRLF + "  AND C6_CLI <> '000001'  "
cQuery += CRLF + "  AND C6_FILIAL = '01'  "
cQuery += CRLF + "  AND SC6.D_E_L_E_T_ <> '*'  "
cQuery += CRLF + " ORDER BY C6_NUM "
	
	PLSQuery(cQuery,cAliPed)

	While (cAliPed)->(!EOF())

		Aadd(aPedVen, {	oSupNo,;
		(cAliPed)->(PEDIDO),;
		(cAliPed)->(PRODUTO),;
		(cAliPed)->(ITEM),;
		Alltrim((cAliPed)->(DESCRICAO)),;
		(cAliPed)->(ARMAZEM),;
		(cAliPed)->(SALDO),;
		IIF((cAliPed)->(DISPONIVEL) > 0,(cAliPed)->(DISPONIVEL),0) ,;
		(cAliPed)->(EMP_FISICO),;
		(cAliPed)->(LOC_PEDIDO),;
		(cAliPed)->(FILA),;
		(cAliPed)->(ENDERECAR),;
		(cAliPed)->(LIB_VENDA),;
		(cAliPed)->(ENTREGA),;
		(cAliPed)->(RECNO);
		})
		(cAliPed)->(dbskip())

	End

	(cAliPed)->(dbCloseArea())
	
	
	if len(aPedVen) <= 0
		AAdd(aPedVen, {oSupNo,"","","","","",0,0,0,"",0,"","",CTOD("//")})
	endif

	oBrwPedi:SetArray(aPedVen)
	oBrwPedi:bLine := {|| ;
	{aPedVen[oBrwPedi:nAt,01] ,; 
	aPedVen[oBrwPedi:nAt,02] ,;
	aPedVen[oBrwPedi:nAt,03] ,;
	aPedVen[oBrwPedi:nAt,04] ,;
	aPedVen[oBrwPedi:nAt,05] ,;
	aPedVen[oBrwPedi:nAt,06] ,;
	aPedVen[oBrwPedi:nAt,07] ,;
	aPedVen[oBrwPedi:nAt,08] ,;
	aPedVen[oBrwPedi:nAt,09] ,;
	aPedVen[oBrwPedi:nAt,10] ,;
	aPedVen[oBrwPedi:nAt,11] ,;
	aPedVen[oBrwPedi:nAt,12] ,;
	aPedVen[oBrwPedi:nAt,13] ,;
	aPedVen[oBrwPedi:nAt,14] ;
	};
	}

	oBrwPedi:Refresh()

Return 


Static function fGralib(_cProd)
	

	If lConf := Msgyesno("Deseja Prosseguir com a alteração? ","Atenção")
		
			for nx := 1 to len(oBrwPedi:AARRAY)
				if oBrwPedi:AARRAY[nx][1]:CNAME == "LBOK"
					If 	oBrwPedi:AARRAY[nx][15] > 0
						dbSelectArea("SC6")
						SC6->(dbgoto(aPedVen[nx][15]))
						IF !EOF()
							recLock("SC6",.F.)
							SC6->C6_XVENDA := '1'
							SC6->(msUnlock())
						EndIf
					Else
						MsgAlert("Registro não encontrado")
					EndIf
				EndIf
			Next nx
				
		
	EndIf
SC6->(DbCloseArea())
fGerPed(_cProd)
Return 
//--------------------------------------------------------------
/*/{Protheus.doc} fMarc
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fMarSup(nLinha)

    if oBrwPedi:AARRAY[nLinha][1]:CNAME == "LBNO"
        aPedVen[nLinha][1] := oSupOk
    else
        aPedVen[nLinha][1] := oSupNo
    endif
    
    oBrwPedi:refresh()
    

return