#INCLUDE 'RWMAKE.CH'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F200VAR   ºAutor  ³Microsiga           º Data ³  07/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  PONTO ENTRADA RETORNO CNAB RECEBER - MOD 1                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function F200VAR 

Local aValores:=PARAMIXB
Local xBuffer := PARAMIXB[1,16]
Local cNsNum  := PARAMIXB[1,4]

/*
Local nDespes := Subst(xBuffer,176-nAjuste,13)
Local nDescont:= Subst(xBuffer,241-nAjuste,13) 
Local nAbatim := Subst(xBuffer,228-nAjuste,13) 
Local nValRec := Subst(xBuffer,254-nAjuste,13) 
Local nJuros  := Subst(xBuffer,267-nAjuste,13) 
Local nMulta  := Subst(xBuffer,280-nAjuste,13)
Local nOutrDesp:=0 
Local nValCc   :=0
Local dDataCred:= dBaixa
Local cOcorr   := Subst(xBuffer,109-nAjuste,13)
Local cMotBan  := Subst(xBuffer,393-nAjuste,13)
Local dDtVc    := dBaixa

Codigo do Banco0770790                                                            
Numero Titulo  1201260                                                            
Data Ocorrencia1111160                                                            
Vlr Desp Cobr. 1761882                                                            
Vlr Desconto   2412532                                                            
Vlr Abatimento 2282402                                                            
Vlr Recebido   2542662                                                            
Valor Juros    2672792                                                            
Cod Liquidacao 3933940                                                            
Cod Ocorrencia 1091100                                                            
Especie        1741750                                                            
Valor IOF      2152272                                                            
Outros Creditos2802922                                                            
Data Credito   2963010                                                            
Nosso Numero   0630700                                                            
Cod Rejeicao   378385                                                             
Data Vencto                                                                       
Codigo do Banco0050070                                                            
  */

/*
			//³ de entrada em PARAMIXB        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Estrutura de aValores
			//	Numero do T¡tulo	- 01
			//	data da Baixa		- 02
			// Tipo do T¡tulo		- 03
			// Nosso Numero			- 04
			// Valor da Despesa		- 05
			// Valor do Desconto	- 06
			// Valor do Abatiment	- 07
			// Valor Recebido    	- 08
			// Juros				- 09
			// Multa				- 10
			// Outras Despesas		- 11
			// Valor do Credito		- 12
			// Data Credito			- 13
			// Ocorrencia			- 14
			// Motivo da Baixa 		- 15
			// Linha Inteira		- 16
			// Data de Vencto	   	- 17
  */
  
                             
cNsNum := Subs(aValores[1,16],83,11)

If Select('RETCNAB') > 0
   RETCNAB->(DbCloseArea())
End   

//GARANTINDO BUSCA PELO NOSSO NUMERO (E1_NUMBCO)
_cQuery:="SELECT E1_PREFIXO, E1_NUM, E1_PARCELA,E1_IDCNAB  "
_cQuery+=" FROM " + RetSqlName('SE1')
_cQuery+=" WHERE SUBSTRING(E1_NUMBCO,1,11) = '"  +  cNsNum + "'"
_cQuery+=" AND E1_FILIAL = '" + xFilial('SE1') +"'" 
_cQuery+=" AND D_E_L_E_T_ = ' '" 
TCQUERY _cQuery NEW ALIAS 'RETCNAB'
RETCNAB->(DbGoTop())
If RETCNAB->(!BOF()) .AND. RETCNAB->(!EOF())
  // aValores := { { RETCNAB->(E1_PREFIXO+E1_NUM+E1_PARCELA), dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nOutrDesp, nValCc, dDataCred, cOcorr, cMotBan, xBuffer,dDtVc}}
    cNumTit:= RETCNAB->(E1_IDCNAB)     
    //Alert(cNumTit)
End
Return(aValores)                     

            