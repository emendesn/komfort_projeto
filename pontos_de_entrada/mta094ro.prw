#include "totvs.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA094RO  �Autor  � Cristiam Rossi     � Data �  25/05/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. rotina de libera��o de documentos no Compras          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � KomfortHouse / Global                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA094RO()
Local aRotina := paramIXB[1]

	aAdd(aRotina,{"Conhecimento","U_MT094DOC", 0, 4, 0, Nil }) //"Conhecimento"	

return aClone( aRotina )


//-----------------------
User Function MT094DOC()
Local   aArea   := getArea()
Private aRotina := { {"","",0,1,0,nil}, {"Conhecimento","U_MT094DOC",0,2,0,nil} }

	if SCR->CR_TIPO == "PC"		// � pedido de compras
		SC7->( dbSetOrder(1) )
		if SC7->( dbSeek( xFilial("SC7") + left(SCR->CR_NUM, 6), .T.) )
			dbSelectArea("SC7")
			MsDocument( "SC7", SC7->(Recno()), 2 )
		else
			msgAlert( "Pedidos de Compras n�o encontrado!!!", "Conhecimento" )
		endif
		
	else
		msgAlert( "S� � poss�vel ver Documentos de Pedidos de Compras", "Conhecimento" )
	endif

	restArea( aArea )
return nil
