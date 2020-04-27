#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "MsOle.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE CRLF CHR(10)+CHR(13)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SYTMR002  �Autor  � Eduardo Patriani   � Data �  21/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera relatorio do Orcamento de venda utilizando o modelo   ���
���Desc.     � .DOT a partir da gravacao do orcamento. 					  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SYTMR002()

Local cORCAMENTO 	:= SUA->UA_NUM
Local cDATABASE  	:= DTOC(dDatabase)
Local cEMISSAO  	:= DTOC(SUA->UA_EMISSAO)
Local cVENDEDOR 	:= POSICIONE("SA3",1,XFILIAL("SA3")+SUA->UA_VEND,"A3_NOME") 
Local cTRANSPORTE 	:= POSICIONE("SA4",1,XFILIAL("SA4")+SUA->UA_TRANSP,"A4_NOME") 
Local cCLIENTE 		:= "" 
Local cCPF 			:= "" 
Local cIE 			:= "" 
Local cENDERECO 	:= "" 
Local cBAIRRO 		:= "" 
Local cCEP 			:= "" 
Local cCIDADE 		:= "" 
Local cUF 			:= "" 
Local cTEL1 		:= "" 
Local cTEL2 		:= "" 
Local cCONTATO 		:= "" 
Local cCFOP 		:= "" 
Local cDESCFOP 		:= "" 
Local cDESDE 		:= "" 
Local cULTCOM 		:= "" 
Local cITEM01 		:= "" 
Local cCODIGO01 	:= "" 
Local cTP01 		:= "" 
Local cDESC01 		:= "" 
Local nPB01 		:= "" 
Local nPL01 		:= ""
Local nQTDE01 		:= ""
Local cUM01 		:= "" 
Local nPRECO01 		:= "" 
Local nIPI01 		:= "" 
Local nVALOR01 		:= "" 
Local nICM01 		:= "" 
Local cENDENT 		:= "" 
Local cBAIRENT 		:= "" 
Local cCEPENT 		:= "" 
Local cCIDENT 		:= "" 
Local cUFENT 		:= "" 
Local cOBS 			:= "" 
Local cTPFRETE 		:= "" 
Local cFormaPG 		:= "" 
Local nQTDETOT 		:= 0
Local nVLRTOT 		:= 0
Local nPESOTOT 		:= 0
Local nM3TOT 		:= 0
Local nTOTICM 		:= 0
Local nTOTIPI 		:= 0
Local nOUTDESP 		:= 0
Local nTOTGERAL 	:= 0
Local nContador		:= 0
Local nLastKey  	:= 0
Local nResto		:= 0
Local nX			:= 0
Local dPREVENT 		:= CTOD("")
Local nQtdChk		:= 0
Local nCheck 		:= 0
Local aCheque		:= {}
Local aAdm          := {}	//Rogerio Doms em 13/03/2017
Local aAreaSL4		:= {}
Local cCheque		:= "" 
Local cLocal        := "C:\ORCAMENTO"

Private cPathSrv	:= "\modelos\"
Private cPathTer	:= "c:\modelos\"
Private cArquivo 	:= "orcamento.dotx"
Private aForma      := {}
Private oWord 		:= Nil   

U_FM_Direct( cLocal, .F., .F. )

dbSelectArea("SM0")
dbSetOrder(1)
dbSeek(cEmpAnt+cFilAnt)

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA))

cCLIENTE 	:= ALLTRIM(SA1->A1_NOME)
cCPF	 	:= SA1->A1_CGC
cIE		 	:= SA1->A1_INSCR
cENDERECO	:= ALLTRIM(SA1->A1_END)
cBAIRRO		:= ALLTRIM(SA1->A1_BAIRRO)
cCEP		:= SA1->A1_CEP
cCIDADE		:= ALLTRIM(SA1->A1_MUN)
cUF			:= SA1->A1_EST
cTEL1		:= SA1->A1_TEL
cTEL2		:= SA1->A1_TEL2
cCONTATO	:= ALLTRIM(SA1->A1_CONTATO)
cDESDE 		:= SA1->A1_DTCAD
cULTCOM		:= SA1->A1_ULTCOM
cENDENT		:= IF(!EMPTY(SA1->A1_ENDENT)	,ALLTRIM(SA1->A1_ENDENT)	,cENDERECO)
cBAIRENT	:= IF(!EMPTY(SA1->A1_BAIRROE)	,ALLTRIM(SA1->A1_BAIRROE)	,cBAIRRO)
cCEPENT		:= IF(!EMPTY(SA1->A1_CEPE)		,SA1->A1_CEPE				,cCEP)
cCIDENT		:= IF(!EMPTY(SA1->A1_MUNE)		,ALLTRIM(SA1->A1_MUNE)		,cCIDADE)
cUFENT		:= IF(!EMPTY(SA1->A1_ESTE)		,SA1->A1_ESTE				,cUF)

//Se endere�o de entrega estiver em branco, substitui pelo endere�o do cliente
if ALLTRIM(cENDENT) == ""
	cENDENT		:= cENDERECO
	cBAIRENT	:= cBAIRRO 
	cCEPENT		:= cCEP 
	cCIDENT		:= cCIDADE 
	cUFENT		:= cUF 
ENDIF

/*+--------------+
| Cria Diret�rio |
+----------------+*/
MakeDir(Trim(cPathTer))

If !File(cPathSrv+cArquivo) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
	MsgStop( "O arquivo n�o foi encontrado no Servidor.","Aten��o" )
	Return
EndIf

/*+---------------------------------------------+
| Apaga o arquivo caso j� exista no diret�rio |
+---------------------------------------------+*/
If File(cPathTer+cArquivo)
	FErase(cPathTer+cArquivo)
Endif

CpyS2T(cPathSrv+cArquivo,cPathTer,.T.)

If nLastKey == 27
	Return
Endif

/*+---------------------------------------------+
| Inicializa o Ole com o MS-Word 97 ( 8.0 )   |
+---------------------------------------------+*/
BeginMsOle()
oWord := OLE_CreateLink()
OLE_NewFile(oWord,cPathTer+cArquivo)

OLE_SetDocumentVar(oWord, 'nome_filial'		, AllTrim(SM0->M0_FILIAL)		)
OLE_SetDocumentVar(oWord, 'end_filial'		, AllTrim(SM0->M0_ENDENT)		)
OLE_SetDocumentVar(oWord, 'bairro_filial'	, AllTrim(SM0->M0_BAIRENT)		)
OLE_SetDocumentVar(oWord, 'mun_filial'		, AllTrim(SM0->M0_CIDENT)		)
OLE_SetDocumentVar(oWord, 'est_filial'		, AllTrim(SM0->M0_ESTENT)		)
OLE_SetDocumentVar(oWord, 'cep_filial'		, Transform(SM0->M0_CEPENT,"@R 99999-999" )	)
OLE_SetDocumentVar(oWord, 'tel_filial'		, AllTrim(SM0->M0_TEL)			)

OLE_SetDocumentVar(oWord, 'cORCAMENTO'		, cORCAMENTO 	)
OLE_SetDocumentVar(oWord, 'cDATABASE'		, cDATABASE		)
OLE_SetDocumentVar(oWord, 'cEMISSAO'		, cEMISSAO		)
OLE_SetDocumentVar(oWord, 'cVENDEDOR'		, cVENDEDOR		)
OLE_SetDocumentVar(oWord, 'cTRANSPORTE'		, cTRANSPORTE	)
OLE_SetDocumentVar(oWord, 'cCLIENTE'		, cCLIENTE		)
OLE_SetDocumentVar(oWord, 'cCPF'			, cCPF			)
OLE_SetDocumentVar(oWord, 'cIE'				, cIE			)
OLE_SetDocumentVar(oWord, 'cENDERECO'		, cENDERECO		)
OLE_SetDocumentVar(oWord, 'cBAIRRO'			, cBAIRRO		)
OLE_SetDocumentVar(oWord, 'cCEP'			, cCEP			)
OLE_SetDocumentVar(oWord, 'cCIDADE'			, cCIDADE		)
OLE_SetDocumentVar(oWord, 'cUF'				, cUF			)
OLE_SetDocumentVar(oWord, 'cTEL1'			, cTEL1			)
OLE_SetDocumentVar(oWord, 'cTEL2'			, cTEL2			)
OLE_SetDocumentVar(oWord, 'cCONTATO'		, cCONTATO		)
OLE_SetDocumentVar(oWord, 'cTRANSPORTE'		, cTRANSPORTE	)
OLE_SetDocumentVar(oWord, 'cVENDEDOR'		, cVENDEDOR		)
OLE_SetDocumentVar(oWord, 'cCFOP'			, cCFOP			)
OLE_SetDocumentVar(oWord, 'cDESCFOP'		, cDESCFOP		)
OLE_SetDocumentVar(oWord, 'cDESDE'			, cDESDE		)
OLE_SetDocumentVar(oWord, 'cULTCOM'			, cULTCOM		)
OLE_SetDocumentVar(oWord, 'cENDENT'			, cENDENT		)
OLE_SetDocumentVar(oWord, 'cBAIRENT'		, cBAIRENT		)
OLE_SetDocumentVar(oWord, 'cCEPENT'			, cCEPENT		)
OLE_SetDocumentVar(oWord, 'cCIDENT'			, cCIDENT		)
OLE_SetDocumentVar(oWord, 'cUFENT'			, cUFENT		)

SUB->(DbSetOrder(1))
SUB->(DbSeek(xFilial("SUB") + cORCAMENTO ))
While !Eof() .And. SUB->UB_FILIAL + SUB->UB_NUM == xFilial("SUB") + cORCAMENTO

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial('SB1') + SUB->UB_PRODUTO ))

	nContador++
	
	OLE_SetDocumentVar(oWord, 'cITEM'+Strzero(nContador,2)		, SUB->UB_ITEM	 	)	
	OLE_SetDocumentVar(oWord, 'cCODIGO'+Strzero(nContador,2)	, SUB->UB_PRODUTO 	)	
	OLE_SetDocumentVar(oWord, 'cTP'+Strzero(nContador,2)		, SB1->B1_TIPO		)	
	//OLE_SetDocumentVar(oWord, 'cDESC'+Strzero(nContador,2)		, SB1->B1_DESC		)	
	OLE_SetDocumentVar(oWord, 'cDESC'+Strzero(nContador,2)		, ALLTRIM(SB1->B1_DESC) + "  //  " + ALLTRIM(SUB->UB_DESCPER))	// PEGA A DESCRICAO DO CAMPO C6_DESCRI - LUIZ EDUARDO F.C. - 11.08.2017
	OLE_SetDocumentVar(oWord, 'nPB'+Strzero(nContador,2)		, Alltrim(Transform(SB1->B1_PESBRU	,"@E 999.99")))
	OLE_SetDocumentVar(oWord, 'nPL'+Strzero(nContador,2)		, Alltrim(Transform(SB1->B1_PESO	,"@E 999.99")))
	OLE_SetDocumentVar(oWord, 'nQTDE'+Strzero(nContador,2)		, Alltrim(Transform(SUB->UB_QUANT	,"@E 999.99")))
	OLE_SetDocumentVar(oWord, 'cUM'+Strzero(nContador,2)		, SUB->UB_UM )	
	OLE_SetDocumentVar(oWord, 'nPRECO'+Strzero(nContador,2)		, Alltrim(Transform(SUB->UB_VRUNIT	,"@E 999,999,999.99")))
	OLE_SetDocumentVar(oWord, 'nIPI'+Strzero(nContador,2)		, Alltrim(Transform(SB1->B1_IPI		,"@E 99.99")))	
	OLE_SetDocumentVar(oWord, 'nVALOR'+Strzero(nContador,2)		, Alltrim(Transform(SUB->UB_VLRITEM	,"@E 999,999,999.99")))
	OLE_SetDocumentVar(oWord, 'nICM'+Strzero(nContador,2)		, Alltrim(Transform(SB1->B1_PICM	,"@E 99.99")))	
	
	If SUB->UB_DTENTRE >= dPREVENT
		dPREVENT := SUB->UB_DTENTRE
	Endif
	
	If Empty(cCFOP)
		cCFOP 		:= SUB->UB_CF 
		cDESCFOP 	:= POSICIONE("SF4",1,xFilial("SF4")+SUB->UB_TES,"F4_TEXTO")
	Endif	
	nQTDETOT 	+= SUB->UB_QUANT
	nVLRTOT 	+= SUB->UB_VLRITEM
	nPESOTOT 	+= (SB1->B1_PESBRU * SUB->UB_QUANT)
	nM3TOT 		:= 0
	
	/*
	Alterado em 13/07/2017 - Rog�rio Doms
	Verificado se existe item do or�amento com observa��o de venda de medida
	especial. Se encontrado um observa��o informar no campo Obs que existe
	itens com medida especial
	*/
	If ! Empty(SUB->UB_01DESME) .And. Empty(cOBS)
		cOBS := "Este Or�amento cont�m Item com Medida Especial"+CRLF
	EndIf
	
	/*Fim de altera��o  */
	
	SUB->(DbSkip())
End

nResto := (10 - nContador)
For nX := 1 To nResto
	nContador++

	OLE_SetDocumentVar(oWord, 'cITEM'+Strzero(nContador,2)		, ""	)	
	OLE_SetDocumentVar(oWord, 'cCODIGO'+Strzero(nContador,2)	, ""	)	
	OLE_SetDocumentVar(oWord, 'cTP'+Strzero(nContador,2)		, ""	)	
	OLE_SetDocumentVar(oWord, 'cDESC'+Strzero(nContador,2)		, ""	)	
	OLE_SetDocumentVar(oWord, 'nPB'+Strzero(nContador,2)		, ""	)	
	OLE_SetDocumentVar(oWord, 'nPL'+Strzero(nContador,2)		, ""	)	
	OLE_SetDocumentVar(oWord, 'nQTDE'+Strzero(nContador,2)		, ""	)	
	OLE_SetDocumentVar(oWord, 'cUM'+Strzero(nContador,2)		, ""	)	
	OLE_SetDocumentVar(oWord, 'nPRECO'+Strzero(nContador,2)		, ""	)	
	OLE_SetDocumentVar(oWord, 'nIPI'+Strzero(nContador,2)		, ""	)	
	OLE_SetDocumentVar(oWord, 'nVALOR'+Strzero(nContador,2)		, ""	)	
	OLE_SetDocumentVar(oWord, 'nICM'+Strzero(nContador,2)		, ""	)	
Next

aAdm 	:= {}
nQtdChk	:= RetQtdChk(cORCAMENTO,"CH")
nQtdBol	:= RetQtdChk(cORCAMENTO,"BOL")
nCheck	:= 0
nTotBol	:= 0

//Carrega as forma de pagamento da venda.
If Select("TRB1XX") > 0
	TRB1XX->(DbCloseArea())
EndIf

BeginSql Alias "TRB1XX"
	SELECT *
	FROM %Table:SL4% SL4 (NOLOCK)
		WHERE 	L4_FILIAL = %xFilial:SL4% AND
				L4_NUM 	  = %Exp:cORCAMENTO% AND
				L4_ORIGEM = 'SIGATMK' AND
				SL4.%NotDel%
	ORDER BY L4_FILIAL,L4_NUM,L4_FORMA DESC
EndSql

While TRB1XX->(!Eof())
	
	If ALLTRIM(TRB1XX->L4_FORMA) == "CH"
		
		If !Empty(TRB1XX->L4_OBS)
			aCheque := Separa(TRB1XX->L4_OBS,"|")
		Endif
		
		If Len(aCheque) > 0
			cCheque:= aCheque[4]
		Else
			cCheque	:= ""
		Endif
		
		nCheck++
		
		cFormaPG += ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nCheck))+"/"+AllTrim(Str(nQtdChk))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" N� "+AllTrim(cCheque)+CRLF
		cFormaPG += "Bco. "+Alltrim(aCheque[1])+" Ag. "+Alltrim(aCheque[2])+" CC. "+Alltrim(aCheque[3])+" - CPF "+Alltrim(Transform(cCPF,"@R 999.999.999-99"))+CRLF

	ElseIf ALLTRIM(TRB1XX->L4_FORMA) == "BOL"
	
		nTotBol++
		
		cFormaPG += ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nTotBol))+"/"+AllTrim(Str(nQtdBol))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" - Aut. "+TRB1XX->L4_AUTORIZ + CRLF
				
	ElseIf Alltrim(TRB1XX->L4_FORMA)=="CC" .Or. Alltrim(TRB1XX->L4_FORMA)=="CD"
		
		nPos := aScan( aAdm , { |x| x[1]+x[2] ==  Alltrim(TRB1XX->L4_FORMA)+Alltrim(TRB1XX->L4_ADMINIS) } )
		
		If nPos == 0
			Aadd(aAdm,{ Alltrim(TRB1XX->L4_FORMA) , Alltrim(TRB1XX->L4_ADMINIS) , 1 , TRB1XX->L4_VALOR , TRB1XX->L4_VALOR , TRB1XX->L4_AUTORIZ  })
		Else
			aAdm[nPos][3] += 1
			aAdm[nPos][5] += TRB1XX->L4_VALOR
		EndIf
		
	Else
		
		cFormaPG += ALLTRIM(TRB1XX->L4_FORMA) +" no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+CRLF
		
	EndIf
	
	TRB1XX->(DbSkip())
EndDo

/*
Alterado em 13/03/2017 - Rog�rio Doms
Carrega Administradora do Cart�p e Quantidade de Parelas para ser impreeso
*/
For nX := 1 To Len(aAdm)
	cFormaPG += aAdm[nX][01] + " - " + aAdm[nX][02] + " - Total Parcelas: " + StrZero(aAdm[nX][03],3) +" - Vlr. Parcela: "+ Alltrim(Transform(aAdm[nX][04],"@E 999,999,999.99")) +" - Valor Total: "+ Alltrim(Transform(aAdm[nX][05],"@E 999,999,999.99")) +"- NSU "+aAdm[nX][06] + CRLF
Next nX
/* Fim da altera��o*/

cOBS 		+= MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
cTPFRETE 	:= If(SUA->UA_TPFRETE=="C","CIF","FOB")

OLE_SetDocumentVar(oWord, 'cCFOP'		, cCFOP 		)
OLE_SetDocumentVar(oWord, 'cDESCFOP'	, cDESCFOP		)
OLE_SetDocumentVar(oWord, 'cTPFRETE'	, cTPFRETE		)
OLE_SetDocumentVar(oWord, 'cFormaPG'	, cFormaPG		)
OLE_SetDocumentVar(oWord, 'dPREVENT'	, dPREVENT		)
OLE_SetDocumentVar(oWord, 'cOBS'		, cOBS 			)

nTOTICM 	:= SUA->UA_VALICM
nTOTIPI 	:= SUA->UA_VALIPI
nOUTDESP 	:= SUA->UA_FRETE+SUA->UA_DESPESA
nTOTGERAL 	:= SUA->UA_VALBRUT

OLE_SetDocumentVar(oWord, 'nQTDETOT'	, Alltrim(Transform(nQTDETOT 	,"@E 999999999.99")))
OLE_SetDocumentVar(oWord, 'nVLRTOT'		, Alltrim(Transform(nVLRTOT 	,"@E 999,999,999.99")))
OLE_SetDocumentVar(oWord, 'nPESOTOT'	, Alltrim(Transform(nPESOTOT 	,"@E 999,999,999.99")))
OLE_SetDocumentVar(oWord, 'nM3TOT'		, Alltrim(Transform(nM3TOT 		,"@E 999,999,999.99")))
OLE_SetDocumentVar(oWord, 'nTOTICM'		, Alltrim(Transform(nTOTICM 	,"@E 999,999,999.99")))
OLE_SetDocumentVar(oWord, 'nTOTIPI'		, Alltrim(Transform(nTOTIPI 	,"@E 999,999,999.99")))
OLE_SetDocumentVar(oWord, 'nOUTDESP'	, Alltrim(Transform(nOUTDESP 	,"@E 999,999,999.99")))
OLE_SetDocumentVar(oWord, 'nTOTGERAL'	, Alltrim(Transform(nTOTGERAL 	,"@E 999,999,999.99")))

OLE_UpDateFields(oWord)

cFileSave := cLocal + "\ORCAMENTO_"+cORCAMENTO+".docx"
OLE_SaveAsFile( oWord,cFileSave )

OLE_CloseLink( oWord ) // Encerra link

Sleep(2000)
ShellExecute('Open',cFileSave,'','',1) 

MsgInfo("Foi criado um arquivo [ORCAMENTO_"+cORCAMENTO+".docx] na pasta [" + cLocal + "]!!!")

Return Nil

/*/{Protheus.doc} RetQtdChk
Retorna quantidade de cheques selecionados na forma de pagamento.

@author Andr� Lanzieri
@since 23/12/2016
@version 1.0
/*/
Static Function RetQtdChk(cORCAMENTO,cForma)

	Local cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	Local _nRec		:= 0
	
	cQuery += " SELECT SL4.L4_FORMA FROM "+RetSqlName("SL4")+" SL4					"		
	
	cQuery += " WHERE SL4.L4_FILIAL = '"+xFilial("SL4")+"' 							"
	cQuery += "	AND SL4.L4_NUM 		= '"+Padr(cORCAMENTO,TamSx3("L4_NUM")[1])+"' 	"
	cQuery += "	AND SL4.L4_FORMA 	= '"+Padr(cForma,TamSx3("L4_FORMA")[1])+"' 		"
	cQuery += " AND SL4.D_E_L_E_T_ 	= ' '											"
	
	TCQUERY cQuery NEW ALIAS (cAlias)
	
	Count to _nRec //quantidade registros
		
	(cAlias)->(DbCloseArea())
					
Return(_nRec)