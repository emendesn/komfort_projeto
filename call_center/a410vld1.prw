#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A410VLD1  �Autor  �Microsiga           � Data �  20/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida o preenchimento do campo conforme a regra.           ���
�������������������������������������������������������������������������͹��
���Uso       �Validacao de Campo: UB_FILSAI (Modo de Edicao)              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A410VLD1()

Local aArea 	:= GetArea()
Local cCampo 	:= ReadVar()
Local cConteudo := &(ReadVar())
Local nPosProd	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})
Local nPosBloq	:= GdFieldPos("C6_BLQ")
Local nLinha	:= n

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1") + aCols[nLinha,nPosProd] ))

SB4->(DbSetOrder(1))
SB4->(DbSeek(xFilial("SB4") + SB1->B1_01PRODP ))

If ALTERA
	
	If !aTail( aCols[nLinha] )
		
		//�������������������������������������������������������������H�
		//�Valida o status do pedido para realizar os agendamentos     �
		//�������������������������������������������������������������H�
		If M->C5_PEDPEND == "1" .Or. M->C5_PEDPEND == "2"  .Or. M->C5_PEDPEND == "5"
			
			If Alltrim(cCampo) == "M->C6_DTAGEND"
				MsgInfo("N�o � possivel agendar a entrega para pedidos em Aguardar!","Aten��o")
				Return(.F.)
				
			ElseIf Alltrim(cCampo) == "M->C6_DTMONTA"
				MsgInfo("N�o � possivel agendar a montagem para pedidos em Aguardar!","Aten��o")
				Return(.F.)
				
			Endif
			
		Endif
		
		//������������������������������������������������������������Ŀ
		//�Valida se o produto permite montagem.                       �
		//��������������������������������������������������������������
		If Alltrim(cCampo) == "M->C6_DTMONTA" .And. SB4->B4_01VLMON==0
			MsgInfo("Este produto n�o permite montagem.","Aten��o")
			Return(.F.)
		Endif
		
		If Alltrim(cCampo) == "M->C6_DTMONTA" .And. Alltrim(aCols[nLinha][nPosBloq])=="R"
			MsgInfo("Pedido Cancelado! Montagem n�o permitida.","Aten��o")
			Return(.F.)
		Endif
				
		If Alltrim(cCampo) == "M->C6_DTAGEND" .And. Alltrim(aCols[nLinha][nPosBloq])=="R"
			MsgInfo("Pedido Cancelado! Agendamento n�o permitido.","Aten��o")
			Return(.F.)
		Endif
				          		
		//������������������������������������������������������������Ŀ
		//�Preenche os campos de cabecalho.                            �
		//��������������������������������������������������������������
		If Alltrim(cCampo)=="M->C6_DTAGEND"
			M->C5_DTAGEND := cConteudo
		Else
			M->C5_DTMONTA := cConteudo
		Endif
		
	Endif
	
Endif

RestArea(aArea)

Return(.T.)