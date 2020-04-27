#include "rwmake.ch"
//#INCLUDE �DBTREE.CH�
#include "VKEY.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � EMP650    �Autor �Edilson Nascimento   � Data � 09/09/20   ���
�������������������������������������������������������������������������͹��
��� Desc.     � Altera empenho na emissao da OP                           ���
�������������������������������������������������������������������������͹��
��� Uso       � Inapel Embalagens                                         ���
�������������������������������������������������������������������������ͼ��
�� Acols: [1] Codigo do produto                                           ���
��        [2] Quantidade empenho                                          ���
��        [3] Almoxarifado padrao do Empenho                              ���
��        [4] Sequencia da estrutura                                      ���
��        [5] Sub-Lote                                                    ���
��        [6] Lote                                                        ���
��        [7] Data de Validade do Lote                                    ���
��        [8] Localizacao                                                 ���
��        [9] Numero de Serie                                             ���
��        [10] 1a Unidade de Medida                                       ���
��        [11] Quantidade 2a. Unidade de Medida                           ���
��        [12] 2a. Unidade de medida                                      ���
��        [13] Logico (.t./.f.) Indica se a linha foi deletada            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Emp650()

Local aArea     := GetArea()

    // Processa( {|| AjustEnd( aCols ) }, "Aguarde...", "Ajustanto Enderecos...", .f.)

    FwMsgRun(,{|| AjustEnd( aCols ) }, "Aguarde...", "Ajustanto Enderecos..." )

    RestArea( aArea )

Return(aCols)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustEnd � Autor � Edilson Nascimento    � Data � 08/01/20 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta o end. das materias primas para o armazem 95.       ���
���          � aArray - Array com os produtos a enderecar                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Ponto de Entrada                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
STATIC PROCEDURE AjustEnd( aArray )

Local nPos

    // Procregua( Len( aArray ) )

    FOR nPos := 1 TO Len( aArray )

        IF SB1->(DBSetOrder(1), DBSeek(xFilial("SB1")+aArray[nPos][1])) .AND. SB1->B1_TIPO == "MP"
            aArray[nPos][3] := "95"
        Endif

    NEXT

Return