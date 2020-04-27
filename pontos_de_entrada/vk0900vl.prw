#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VK0900Vl � Autor � LUIZ EDUARDO F.C.  � Data �  19/10/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � IMPOSTOS BORDERO - CNAB                                    ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function VK0900Vl()

Local nValAbat := 0
Local nValTit  := 0
Local cValTit  := ""

nValAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA)
nValTit  := SE1->E1_VALOR - nValAbat
cValTit  := STRZERO((ROUND(nValTit,2)*100),13)

Return(cValTit)