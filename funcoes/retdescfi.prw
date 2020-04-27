#include 'protheus.ch'
#include 'parmtype.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RETDESCFI Autor � Wellington         � Data �  01/09/18    ���
�������������������������������������������������������������������������͹��
���Retrono da descri��o filial                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

user function RETDESCFI(cVarFil)

      Local cAlias := getNextAlias()
      Local cQuery := ""
      Local cDescFil := ""
      
      Default cVarFil := ""
      
      cQuery := "SELECT * FROM SM0010 WHERE FILFULL = '"+cVarFil+"'"
      
      PLSQuery(cQuery, cAlias)

      if (cAlias)->(!eof())
            cDescFil := (cAlias)->FILIAL
      endif

      (cAlias)->(dbCloseArea())

Return(cDescFil)
