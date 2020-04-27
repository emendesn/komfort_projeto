#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMLOJG01 � Autor � LUIZ EDUARDO F.C.  � Data �  07/03/2017 ���
�������������������������������������������������������������������������͹��                                     
���Descricao � GATILHO NO CAMPO UB_VRUNIT - CALCULA O DESCONTO DO PRODUTO ���
���          � DE ACORDO COM O PRECO UNITARIO DIGITADO                    ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE - LOJA                                       ���
�������������������������������������������������������������������������ͼ��                                     
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMLOJG01()    

Private nUB_VRUNIT  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VRUNIT"})
Private nUB_QUANT   := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_QUANT"}) 
Private nUB_VLRITEM := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VLRITEM"}) 
Private nUB_DESC    := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DESC"})  
Private nUB_VALDESC := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VALDESC"})
Private nUB_PRCTAB  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRCTAB"})                                 
Private nUB_PRODUTO := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})                                 

//������������������������������������������������������������������Ŀ
//� ZERA TODOS OS CAMPOS DE VALORES - LUIZ EDUARDO F.C. - 16.08.2017 �
//��������������������������������������������������������������������
aCols[n,nUB_VRUNIT] 	:= 0
aCols[n,nUB_DESC]		:= 0
aCols[n,nUB_VALDESC] 	:= 0 
aCols[n,nUB_VLRITEM] 	:= 0   
aCols[n,nUB_PRCTAB]     := 0                                                      
                             
//���������������������������������������������������Ŀ
//� CARREGA O PRECO DE TABELA DO PRODUTO - TABELA DA1 �
//�����������������������������������������������������
DbSelectArea("DA1")
DbSetOrder(2)
DbSeek(xFilial("DA1") + aCols[n,nUB_PRODUTO])

//�������������������������������������������
//� ATUALIZA OS CAMPOS COM OS NOVOS VALORES �
//�������������������������������������������                                                                             		
aCols[n,nUB_PRCTAB]		:= DA1->DA1_PRCVEN 
aCols[n,nUB_VRUNIT] 	:= M->UB_VRUNIT
aCols[n,nUB_VALDESC] 	:= aCols[n,nUB_PRCTAB] - M->UB_VRUNIT
aCols[n,nUB_VLRITEM] 	:= M->UB_VRUNIT * aCols[n,nUB_QUANT]                                                                          
aCols[n,nUB_DESC]		:= (((M->UB_VRUNIT / aCols[n,nUB_PRCTAB]) - 1) * 100) * -1

/*
//���������������������������������������Ŀ
//� ATUALIZA O CAMPO "VALOR DE DESCONTO"  �                                                                              
//�����������������������������������������
aCols[n,nUB_VALDESC]	:= aCols[n,nUB_QUANT] * (aCols[n,nUB_PRCTAB] - aCols[n,nUB_VRUNIT])
M->UB_VALDESC			:= aCols[n,nUB_QUANT] * (aCols[n,nUB_PRCTAB] - aCols[n,nUB_VRUNIT])

//��������������������������������������������Ŀ
//� ATUALIZA O CAMPO "PORCENTAGEM DE DESCONTO" �
//����������������������������������������������
aCols[n,nUB_DESC]	:=  (aCols[n,nUB_VLRITEM] - aCols[n,nUB_VALDESC]) / 100 
M->nUB_DESC			:=  (aCols[n,nUB_VLRITEM] - aCols[n,nUB_VALDESC]) / 100 
*/

RETURN(.T.)