#include "totvs.ch"
#include 'protheus.ch'	//#RVC20180516.n
#include 'parmtype.ch'	//#RVC20180516.n

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ M460FIM         ºAutor³ Cristiam Rossi             º Data ³ 22/03/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Ponto de Entrada executado na geracao de uma Nota Fiscal de Saida      º±±
±±º         ³ apos o final da transacao                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno  ³ Nenhum                                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ GLOBAL / KOMFORTHOUSE                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ³         ³                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460FIM()

Local aArea    	:= GetArea()
Local aAreaSD2 	:= SD2->( GetArea())
Local aNumSAC	:= {}					//#RVC20180515.n
Local aSE1		:= {}					//#RVC20180515.n
Local cNumSac	:= ""					//#RVC20180515.n
Local cNumPV	:= ""					//#RVC20180515.n
Local cNumNF	:= ""					//#RVC20180515.n
Local cCodCli	:= ""					//#RVC20180515.n
Local cLojCli	:= ""					//#RVC20180515.n
Local nVlrTmp	:= 0 					//#RVC20180515.n
Local cMES     	:= StrZero( Month( SF2->F2_EMISSAO ), 2 )
Local lContinua	:= .F.

SD2->( dbSetOrder( 3 ) )
SF4->( dbSetOrder( 1 ) )
SB1->( dbSetOrder( 1 ) )
SB3->( dbSetOrder( 1 ) )

SD2->( dbSeek( xFilial( "SD2" ) + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) ) )
while ! SD2->( EOF() ) .and.  SF2->(F2_FILIAL + F2_DOC + F2_SERIE) == SD2->(D2_FILIAL + D2_DOC + D2_SERIE)
	//lContinua := .T.
	//#RVC20180514.bn
	If !Empty(SD2->D2_01SAC)
		Aadd(aNumSAC,{SD2->D2_01SAC, SD2->D2_CLIENTE, SD2->D2_LOJA, SD2->D2_PEDIDO, SD2->D2_ITEMPV, SD2->D2_DOC, SD2->D2_ITEM, SD2->D2_TOTAL})
	EndIf
	//#RVC20180514.en
	if SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES)) .and. SF4->F4_ESTOQUE == "S"
		if SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD)) .and. SB1->B1_TIPO == "ME"
			if SB3->( dbSeek( xFilial( "SB3" ) + SD2->D2_COD ) )
				recLock("SB3",.F.)
				&("SB3->B3_Q"+cMES) := &("SB3->B3_Q"+cMES) - SD2->D2_QUANT
				msUnlock()
			endif
		endif
	endif
	//#RVC20180516.bn
	cCodCli	:= SD2->D2_CLIENTE
	cLojCli	:= SD2->D2_LOJA
	cNumPV	:= SD2->D2_PEDIDO 
	cNumNF	:= SD2->D2_DOC
	//#RVC20180516.en
	SD2->( dbSkip() )
end

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GERAÇÃO DE TIT. NDC DE CASOS DE EMPRESTIMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nA := 1 to Len(aNumSAC)
	cNumSac := aNumSAC[nA][1]
	cNumPV	:= aNumSAC[nA][4]
	nVlrTmp	:= aNumSAC[nA][8] 
	For nB := 2 to Len(aNumSAC)
		If aNumSAC[nB][1] == cNumSac .AND. aNumSAC[nB][4] == cNumPV
			nVlrTmp += aNumSAC[nB][8]
		EndIf 
	Next
	If Empty(aSE1)
		Aadd(aSE1,{aNumSAC[nA][1],nVlrTmp})
		ASort(aSE1)
	Else
		If AScan(aSE1,{|x| AllTrim(x[1]) == AllTrim((aNumSAC[nA][1]))}) > 0
			LOOP
		EndIf
		Aadd(aSE1,{aNumSAC[nA][1],nVlrTmp})
		ASort(aSE1)
	EndIf
Next

For nC := 1 to Len(aSE1)
	//				 KMSACA09(    cNumSAC, cCodCli, cLojCli, cNumPV, cNumNF,    nVlrMerc,cTpOp)
	FwMsgRun( ,{|| U_KMSACA09(aSE1[nC][1], cCodCli, cLojCli, cNumPV, cNumNF, aSE1[nC][2],"NDC")}, , "Gerando título NDC de empréstimo ("+ cValToChar(nC) +"/"+ cValToChar(Len(aSE1)) +"), favor aguarde..." )
Next
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³IMPRESSAO DO ROMANEIO DE ENTREGA POR CARGA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Verifico se a rotina foi chamada pela (Transferencia entre filiais)
//Se Sim, não imprime o Mapa de Entrega.
if .F. //#CMG20181016.n - Não chamar mais a impressão - !ISINCALLSTACK('MATA310') //AFD20180608.N
	If !Empty(SF2->F2_CARGA)
		FwMsgRun( ,{|| U_KMOMSR02(SF2->F2_CARGA) }, , "Imprimindo o Mapa de Entrega, por favor aguarde..." )
		FwMsgRun( ,{|| U_KMOMSR01(SF2->F2_CARGA) }, , "Imprimindo o Romaneio, por favor aguarde..." )
	EndIf
endif //AFD20180608.N

RestArea( aAreaSD2 )
RestArea( aArea)   

Return nil
