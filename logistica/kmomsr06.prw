#Include "TopConn.ch"
#Include "TbiConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KMOMSR06  �Autor  �Murilo Zoratti        � Data �  05/11/18 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio de Posi��o Vazia                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � komfort                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function KMOMSR06()

Local oReport

oReport := ReportDef()
oReport:PrintDialog()

Return

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���������������������������������������������������������������������������Ĵ��
���Descricao � Cria as Celulas que vao ser Apresentadas no Relatorio          �
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport
Local oSection  
Local _cPerg := "KMOMSR06" 
 	
//����������������������������Ŀ
//� Ajusta e carrega perguntas �
//������������������������������
_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

Pergunte(_cPerg,.T.)
 	 	
oReport:= TReport():New("KMOMSR06","Posi��o Vazia",_cPerg,{|oReport|PrintReport(oReport)},"Posi��o Vazia")
oReport:SetTotalInLine(.f.)
oReport:lParamPage := .f.

oSection := TRSection():New(oReport,"Posi��o Vazia",{"SBE","SBF"})        

TRCell():New(oSection,"ENDERECO","SBE","ENDERECO",,10,,,,,,,,,,,,.F.)
TRCell():New(oSection,"ARMAZEM","BE","ARMAZEM",,02,,,,,,,,,,,,.F.)
TRCell():New(oSection,"FILIAL","BE","FILIAL",,4,,,,,,,,,,,,.F.)
TRCell():New(oSection,"QUANTIDADE","BF","QUANTIDADE",,5,,,,,,,,,,,,.F.)  


//TRFunction():New(oSection:Cell("DAK_COD"),"TOTAL GERAL" ,"COUNT",,,"@E 999999",,.F.,.T.)   


Return oReport

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���������������������������������������������������������������������������Ĵ��
���Descricao � 		Query que alimenta 0 Relatorio                          ��
������������������������������������������������������D���������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function PrintReport(oReport)

Local oSection := oReport:Section(1)
 
BeginSql alias "KMOMSR06" 
	%noParser%

SELECT *
FROM
(SELECT BE_LOCALIZ ENDERECO,BE_LOCAL ARMAZEM, BE_FILIAL FILIAL,SUM(ISNULL(BF_QUANT,0)) QUANTIDADE
FROM SBE010 SBE
LEFT OUTER JOIN SBF010 SBF ON BF_FILIAL = BE_FILIAL AND BF_LOCAL = BE_LOCAL AND BF_LOCALIZ = BE_LOCALIZ AND SBF.%notDel%
WHERE SBE.%notDel%
AND BE_FILIAL = '0101'
AND BE_LOCAL = '01'
AND BE_MSBLQL <> '1'
GROUP BY BE_FILIAL, BE_LOCAL, BE_LOCALIZ ) AS TOTAL
WHERE TOTAL.QUANTIDADE = 0 
AND TOTAL.ENDERECO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
ORDER BY ENDERECO

EndSql

oSection:EndQuery()
MemoWrite('\Querys\KMOMSR06.sql',oSection:GetQuery())
  
oSection:Print()   
oReport:SetPortrait()

Return    

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1� Autor � Bruno Gomes           � Data �  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fAjustSX1(_cPerg)

Local _aArea	:= GetArea()
Local aRegs		:= {}

dbSelectArea("SX1")
dbSetOrder(1)

_cPerg := padr(_cPerg,len(SX1->X1_GRUPO))

Aadd(aRegs,{_cPerg,"01","Rua De...","MV_CH1"   ,"C",15,0,"G","MV_PAR01","SBE","","","","",""})
Aadd(aRegs,{_cPerg,"02","Rua At�..","MV_CH2"   ,"C",15,0,"G","MV_PAR02","SBE","","","","",""})

DbSelectArea("SX1")
DbSetOrder(1)

For _i := 1 To Len(aRegs)
	
	If  !DbSeek(aRegs[_i,1]+aRegs[_i,2])
		RecLock("SX1",.T.)
		Replace X1_GRUPO   with aRegs[_i,01]
		Replace X1_ORDEM   with aRegs[_i,02]
		Replace X1_PERGUNT with aRegs[_i,03]
		Replace X1_VARIAVL with aRegs[_i,04]
		Replace X1_TIPO    with aRegs[_i,05]
		Replace X1_TAMANHO with aRegs[_i,06]
		Replace X1_PRESEL  with aRegs[_i,07]
		Replace X1_GSC     with aRegs[_i,08]
		Replace X1_VAR01   with aRegs[_i,09]
		Replace X1_F3      with aRegs[_i,10]
		Replace X1_DEF01   with aRegs[_i,11]
		Replace X1_DEF02   with aRegs[_i,12]
		Replace X1_DEF03   with aRegs[_i,13]
		Replace X1_DEF04   with aRegs[_i,14]
		Replace X1_DEF05   with aRegs[_i,15]
		MsUnlock()
	EndIf
	
Next _i

RestArea(_aArea)

Return
