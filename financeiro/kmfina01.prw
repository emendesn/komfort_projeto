#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �KMFINA01� Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO BANCO ITAU COM CODIGO DE BARRAS        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
���          �                                                            ���
���          �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                                                                

User Function KMFINA01(_cPed)         

Local _lBol     := .F.
Local _cChave   := ""
Local _aTitulos := {}
Local _cBanco   := ""
      
DbSelectArea("SE1")
SE1->(DbOrderNickName("PEDIDOVEND"))
SE1->(DbGoTop())

If SE1->(DbSeek(xFilial("SE1")+_cPed))  
          
    _cChave := xFilial("SE1")+_cPed
    _cBanco := SE1->E1_PORTADO 

	While _cChave == SE1->E1_FILIAL+SE1->E1_PEDIDO
	
		If SE1->E1_TIPO == 'BOL' .And. !Empty(AllTrim(SE1->E1_NUMBCO))
			
			_cBanco := IIF(_cBanco $ "341|033",_cBanco,SE1->E1_PORTADO)
			
			AADD(_aTitulos,{SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)})
		
		EndIf     
	
		SE1->(DbSkip())      
	
	EndDo

Else 

	MsgStop("N�o foi localizado t�tulo para este pedido!","NOPEDIDO")
	
	Return

EndIf          

If Len(_aTitulos) > 0  

	If _cBanco == '341'             
	
		U_KMFINR05(_cPed,_aTitulos)
	
	ElseIf _cBanco == '033'

		U_KMFINR04(_cPed,_aTitulos)
	
	Else
	
	  	MsgStop("O banco desse t�tulo n�o est� dispon�vel, contate o administrador do sistema!","NOBANCO")                                                                                             
	
	EndIf
                                                                   
Else
    
  	MsgStop("N�o foi localizado boletos para este pedido, contate a �rea de cr�dito!","NOBOLETO")
	
EndIf


Return 