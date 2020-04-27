#include 'protheus.ch'
#include 'parmtype.ch'

user function KHFIN005()

	Local Cancelar
	Local NSU
	Local Numero
	Local oGet1
	Local oGet2
	Local oGet3
	Local oGet4
	Local oGroup1
	Local oGroup2
	Local Pesquisar
	Local Prefixo
	Local Salvar
	Local Tipo
	Private cxPref := Criavar("E1_PREFIXO")
	Private xNumero := SPACE(9)
	Private cTipo := Criavar("E1_DOCTEF")
	Private cNsu := Criavar("E1_NSUTEF")
	Private nValor := Criavar("E1_SALDO")
	Private oBrwForma
	Private aReceb := {}
	Private oSupOk := LoadBitMap(GetResources(), "LBOK")
    Private oSupNo := LoadBitMap(GetResources(), "LBNO")
	Static oTela
	cxPref := GetMv("KM_PREFIXO")

	DEFINE MSDIALOG oTela TITLE "Altera NSU" FROM 000, 000  TO 600, 700 COLORS 0, 16777215 PIXEL


	@ 006, 001 GROUP oGroup1 TO 060, 344 PROMPT "Filtros" OF oTela COLOR 0, 16777215 PIXEL
	@ 064, 001 GROUP oGroup2 TO 269, 344 PROMPT "Informações" OF oTela COLOR 0, 16777215 PIXEL
	@ 279, 260 BUTTON Cancelar PROMPT "Cancelar" SIZE 037, 012 OF oTela ACTION(oTela:End()) PIXEL
	@ 279, 305 BUTTON Salvar PROMPT "Salvar" SIZE 037, 012 OF oTela ACTION(fGraNsu())  PIXEL 
	@ 014, 014 SAY Prefixo PROMPT "Prefixo" SIZE 025, 007 OF oTela COLORS 0, 16777215 PIXEL
	if  cxPref == "ADM"
		@ 027, 014 MSGET oGet1 VAR cxPref SIZE 039, 010 OF oTela COLORS 0, 16777215 PIXEL
	Else
		@ 027, 014 MSGET oGet1 VAR cxPref SIZE 039, 010 when .F. OF oTela COLORS 0, 16777215 PIXEL
	EndIf
	@ 014, 071 SAY Numero PROMPT "Numero" SIZE 025, 007 OF oTela COLORS 0, 16777215 PIXEL
	@ 027, 070 MSGET oGet2 VAR xNumero SIZE 060, 010 OF oTela COLORS 0, 16777215 PIXEL
	@ 014, 150 SAY Tipo PROMPT "Nsu" SIZE 025, 007 OF oTela COLORS 0, 16777215 PIXEL
	@ 027, 151 MSGET oGet3 VAR cTipo SIZE 039, 010 OF oTela COLORS 0, 16777215 PIXEL
	
	@ 027, 281 BUTTON Pesquisar PROMPT "Pesquisar" SIZE 037, 012 OF oTela ACTION(fGerae1()) PIXEL
	@ 272, 016 SAY NSU PROMPT "Novo NSU" SIZE 045, 007 OF oTela COLORS 0, 16777215 PIXEL
	@ 280, 016 MSGET oGet4 VAR cNsu SIZE 060, 010 OF oTela COLORS 0, 16777215 PIXEL
	

	
	

	oBrwForma := TwBrowse():New(071, 005, 345, 200,, {;
	 '',;
	'Prefixo',;
	'Numero',;
	'Parcela',;
	'Tipo',;
	'NSU',;
	'Valor',;
	'Nome',;
	'Codigo',;
	'Orçamento',;
	},,oTela,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
	oBrwForma:bLDblClick := {|| fMarSup(oBrwForma:nAt)  }


	fGerae1()


	ACTIVATE MSDIALOG oTela CENTERED

Return


Static function fGerae1()

	Local cAliE1 := getNextAlias()
	Local cQuery := ""
	Local nTot := 0
	Local cTot := ""
	aReceb := {}
	//nTot := val(nValor)
	
	do case
	case EMPTY(cxPref)
	MsgAlert("É necessário informar o Prefixo do titulo para Fazer a Pesquisa")
	Return 
	endcase
	
	if !EMPTY(xNumero)
	
	cQuery := " SELECT  E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO,E1_DOCTEF,E1_VALOR, E1_NOMCLI,E1_CLIENTE,E1_NUMSUA,R_E_C_N_O_ FROM SE1010(NOLOCK) " +CRLF
	cQuery += " WHERE E1_PREFIXO = '"+cxPref+"' " +CRLF
	cQuery += " AND E1_NUM = '"+xNumero+"'" +CRLF
	cQuery += " AND E1_TIPO <> 'BOL' " +CRLF
	iF !EMPTY(cTipo)
	cQuery += " AND E1_DOCTEF = '"+cTipo+"' " +CRLF
	EndIf
	If nValor > 0
		cTot:=  cvaltochar(nValor)
		cQuery += " AND E1_VALOR = '"+cTot+"' " +CRLF
	EndIf
	cQuery += " AND D_E_L_E_T_ = '' " +CRLF


	PLSQuery(cQuery,cAliE1)

	While (cAliE1)->(!EOF())

		Aadd(aReceb, {	oSupNo,;
		(cAliE1)->(E1_PREFIXO),;
		(cAliE1)->(E1_NUM),;
		(cAliE1)->(E1_PARCELA),;
		(cAliE1)->(E1_TIPO),;
		(cAliE1)->(E1_DOCTEF),;
		(cAliE1)->(E1_VALOR),;
		(cAliE1)->(E1_NOMCLI),;
		(cAliE1)->(E1_CLIENTE),;
		(cAliE1)->(E1_NUMSUA),;
		(cAliE1)->(R_E_C_N_O_);
		})
		(cAliE1)->(dbskip())

	End

	(cAliE1)->(dbCloseArea())
	
	EndIf
	
	if len(aReceb) <= 0
		AAdd(aReceb, {oSupNo,"","","","","","","","","",0})
	endif

	oBrwForma:SetArray(aReceb)
	oBrwForma:bLine := {|| ;
	{aReceb[oBrwForma:nAt,01] ,; 
	aReceb[oBrwForma:nAt,02] ,;
	aReceb[oBrwForma:nAt,03] ,;
	aReceb[oBrwForma:nAt,04] ,;
	aReceb[oBrwForma:nAt,05] ,;
	aReceb[oBrwForma:nAt,06] ,;
	aReceb[oBrwForma:nAt,07] ,;
	aReceb[oBrwForma:nAt,08] ,;
	aReceb[oBrwForma:nAt,09] ,;
	aReceb[oBrwForma:nAt,10] ,;
	aReceb[oBrwForma:nAt,11];
	};
	}

	oBrwForma:Refresh()

Return 


Static function fGraNsu()


	Local lConf := .F.
	
	
	do case
		case EMPTY(cxPref)
		MsgAlert("É necessário informar o Prefixo do titulo para alterar a NSU")
		Return
		case EMPTY(xNumero)
		MsgAlert("É necessário informar o numero do titulo para alterar a NSU")
		Return 
	endcase
	
	If lConf := Msgyesno("Deseja Prosseguir com a alteração? ","Atenção")
		
			for nx := 1 to len(oBrwForma:AARRAY)
				if oBrwForma:AARRAY[nx][1]:CNAME == "LBOK"
					if !EMPTY(cNsu)
						dbSelectArea("SE1")
						SE1->(dbgoto(aReceb[nx][11]))
						IF !EOF()
						recLock("SE1",.F.)
						SE1->E1_NSUTEF := cNsu
						SE1->E1_DOCTEF := cNsu
						SE1->(msUnlock())
						EndIf
					Else
					MsgAlert("Informe um valor para a NSU")
					EndIf
				EndIf
			Next nx
				
		
	EndIf
	cNsu := "         "

 fGerae1()
 
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

    if oBrwForma:AARRAY[nLinha][1]:CNAME == "LBNO"
        aReceb[nLinha][1] := oSupOk
    else
        aReceb[nLinha][1] := oSupNo
    endif
    
    oBrwForma:refresh()
    
Return
