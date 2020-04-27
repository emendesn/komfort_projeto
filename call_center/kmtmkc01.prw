#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KMTMKC01  �Autor  �Ellen Santiago      � Data �  23/02/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     �Consulta padr�o retornando o armazem corresponde a loja     ���
�������������������������������������������������������������������������͹��
���Uso       �KOMFORTHOUSE					 				                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function KMTMKC01()

Local _nPosMos  := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_MOSTRUA"})
Local _cLocPad  := GetMv("MV_LOCPAD",,"01")
Local _cLocLoj  := GetMv("SY_LOCPAD",,"01")  
Local _cLocGlp  := GetMV("MV_LOCGLP",,"03")

If aCols[oGetTLV:oBrowse:nAt][_nPosMos] == '1'//Verifica se o produto � novo, assim deve sair do armazem padr�o

	Return(_cLocPad)

ElseIf aCols[oGetTLV:oBrowse:nAt][_nPosMos] == '4'

	Return(_cLocLoj)

Else//busca o armazem da loja

	Return(_cLocLoj)

EndIf

Return()