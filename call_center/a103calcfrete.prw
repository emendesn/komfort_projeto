#INCLUDE "PROTHEUS.CH"

#DEFINE FRETE 4

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A103CALCFRETE � Autor � SYMM CONSULTORIA � Data �19/06/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Recalcula os valores do frete informado nos itens.         ���
�������������������������������������������������������������������������͹��
���Uso       � Casa Cenario.                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function A103CALCFRETE(nVlrFre,nOrigem)

Local aArea		:= GetArea()
Local nPValFre	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01VALFR"})
Local nPTpEntre := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_TPENTRE"})
Local nX		:= 0
Local nLin		:= n
Local lRet 		:= .T.

Default nVlrFre := 0
Default nOrigem := 'I'

If nLin > 0

	//�������������������������������������������������������������H�
	//�Valida a cobranca do frete quando o cliente possui pedido(s)�
	//�em aberto.                                                  �
	//�������������������������������������������������������������H�
	If !Empty(M->UA_01PEDAN) .And. ( nVlrFre > 0 )
		MsgStop("Cliente possui pedido(s) em aberto, n�o deve ser cobrado frete!")
		lRet := .F.
	Endif
	
	//��������������������������������������������������������Ŀ
	//�Valida o preenchimento do valor do frete, conforme op��o�
	//�de entrega escolhida pelo cliente.                      �
	//����������������������������������������������������������
	If (aCols[nLin,nPTpEntre]=='1' .Or. aCols[nLin,nPTpEntre]=='2') .And. nVlrFre > 0
		MsgStop("Cliente optou para retirar o material, n�o deve ser cobrado frete!")
		lRet := .F.
	Endif
	
	If lRet
		
		aValores[FRETE] := nVlrFre
		
		For nX := 1 To Len(aCols)
			If !aTail( aCols[nX] )
				If nLin <> nX
					aValores[FRETE] += aCols[nX,nPValFre]
				Elseif nOrigem=='T'
					aValores[FRETE] += aCols[nX,nPValFre]
				Endif
			Endif
		Next
		
		Tk273RodImposto("NF_FRETE",aValores[FRETE])
		
		// Atualiza o rodape
		Tk273Refresh()
		Eval(bFolderRefresh)
		Eval(bRefresh)
		
	Endif

Endif
	
RestArea(aArea)

Return(lRet)
