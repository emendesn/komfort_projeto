/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
'���Programa  �KmhSpl	 � Autor � Vanito Rocha  � Data �  15/10/19       ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina que separa as colunas de um arquivo CSV e retorna   ���
���          � o conte�do de cada linha 								  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST                                                    ���

�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function KmhSpl(cString,cSeparador)

Local aReturn := {}
Local nAt := 0

cString := AllTrim(cString)
If (nAt := At(cSeparador,cString)) > 0
	While !Empty(cString)
		aAdd(aReturn,Left(cString,nAt-1))
		cString := SubStr(cString,nAt+1,Len(cString))
		nAt := At(cSeparador,cString)
		If nAt == 0
			aAdd(aReturn,cString)
			cString := ""
		EndIf
	EndDo
ElseIf !Empty(cString)
	aAdd(aReturn,cString)	
EndIf                        

Return aReturn		                  