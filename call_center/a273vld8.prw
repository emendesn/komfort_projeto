// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : A273VLD8
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 05/06/14 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "PROTHEUS.CH"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Montagem da tela de processamento

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     5/06/2014
/*/
//------------------------------------------------------------------------------------------
User Function A273VLD8()

Local lRet	  		:= .T.
Local nX 	  		:= 0
Local cCodigo 		:= CriaVar("UB_PRODUTO")
Local cMens 		:= ""
Local cMensDisp     := ""
Local nPosQuant  	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_QUANT"})
Local nPosProd   	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_PRODUTO"})
Local nPosTes		:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_TES"})
Local nPosLocal 	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_LOCAL"})
Local nPCondEnt		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_CONDENT"})
Local nPTabPad		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01TABPA"})
Local nSaldoEst   	:= 0
Local nQtdVen		:= 0
Local nLinha		:= n
Local aProds		:= {}
Local cFilAtu		:= ''
Local lQtdPrev		:= .F.
Local cLocDep		:= GetMv("MV_SYLOCDP",,"100001")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico se o parametro MV_ESTNEG esta habilitado para barrar o estoque   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If SuperGetMV( "MV_ESTNEG" ) == "N"

If aCols[nLinha][nPCondEnt]$"1|3" .And. aCols[nLinha][nPTabPad] <> "010"
	
	If aCols[nLinha][nPCondEnt]=="1"
		
		If Len(aCols) > 1
			For nI := 1 To Len(aCols)
				If !aTail( aCols[nI] )
					If nI <> nLinha
						If Alltrim(aCols[nLinha][nPosProd])==Alltrim(aCols[nI,nPosProd]) .And. aCols[nI,nPCondEnt]=='1'
							nQtdVen += aCols[nI,nPosQuant]
						Endif
					Endif
				Endif
			Next
		Endif
		
	ElseIf aCols[nLinha][nPCondEnt]=="3"
		
		lQtdPrev := .T.
		
		If Len(aCols) > 1
			For nI := 1 To Len(aCols)
				If !aTail( aCols[nI] )
					If nI <> nLinha
						If Alltrim(aCols[nLinha][nPosProd])==Alltrim(aCols[nI,nPosProd]) .And. aCols[nI,nPCondEnt]=='3'
							nQtdVen += aCols[nI,nPosQuant]
						Endif
					Endif
				Endif
			Next
		Endif
		
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifico se a TES está habilitada para uso do controle de estoque.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SF4->( MsSeek( xFilial( "SF4" ) + aCols[nLinha][nPosTES] ))
	If SF4->F4_ESTOQUE == "S"
		
		AAdd( aProds, Array(3) )
		aProds[Len(aProds)][1] := aCols[nLinha][nPosProd]
		aProds[Len(aProds)][2] := aCols[nLinha][nPosLocal]
		aProds[Len(aProds)][3] := aCols[nLinha][nPosQuant]
		
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Iniciando verificacao de saldo junto ao arquivo SB2.                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len( aProds )
		
		SB1->( DbSetOrder(1) )
		SB1->( DbSeek( xFilial("SB1") + aProds[nX][1] ) )
		
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2") + SB1->B1_PROC + SB1->B1_LOJPROC ))
		If SA2->A2_XFORFAT=="1"
			cFilAtu := xFilial("SB2")
		Else
			cFilAtu := cLocDep
		Endif
		
		//Tratamento para tabela de mostruario armazem 02
		If aProds[nX][2]=="02" .And. cFilAtu<>cLocDep
			cFilAtu := cFilAnt
		Endif
		
		If (SB2->(MsSeek(cFilAtu+aProds[nX][1]+aProds[nX][2])))
			
			If !lQtdPrev
				nSaldoEst := ((SB2->B2_QATU) - (nQtdVen  + SB2->B2_QEMP + SB2->B2_RESERVA + SB2->B2_QPEDVEN))
			Else
				nSaldoEst := SB2->B2_01SALPE - nQtdVen
			Endif
			
			If nSaldoEst < aProds[nX][3]
				lRet := .F.
				cMens += Alltrim(aProds[nX][1]) + " - " + Alltrim(Posicione("SB1",1,xFilial("SB1")+aProds[nX][1],"B1_DESC")) + Chr(10)
			Endif
		Else
			lRet := .F.
			cMens += Alltrim(aProds[nX][1]) + " - " + Alltrim(Posicione("SB1",1,xFilial("SB1")+aProds[nX][1],"B1_DESC")) + Chr(10)
		Endif
		
	Next nX
	
	If !Empty( cMensDisp )
		MsgInfo( "Segue lista dos produtos que estão indisponíveis no estoque: " + CHR(13) + CHR(10) + CHR(13) +  CHR(10) + cMensDisp, "Produtos indisponíveis no estoque" )
		lRet := .F.
	Endif
	
	If !Empty( cMens )
		MsgInfo( cMens, "Produto com estoque negativo" )
		lRet := .F.
	Endif
	
Endif

//Endif

Return lRet
