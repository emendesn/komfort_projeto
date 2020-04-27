#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA410LEG  บAutor  ณMicrosiga           บ Data ณ  02/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada adiciona cores a legenda                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Template eCommerce                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA410LEG()
Local aCoresB	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPadrใo Protheusณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
aAdd(aCoresB, { "ENABLE"		,"Pedido em Aberto" 				})	//Pedido em Aberto
aAdd(aCoresB, { "DISABLE"		,"Pedido encerrado"					})	//Pedido Encerrado
aAdd(aCoresB, { "BR_AMARELO"	,"Pedido Liberado"					})	//Pedido Liberado
aAdd(aCoresB, { "BR_AZUL"		,"Pedido Bloquedo por regra" 		})	//Pedido Bloquedo por regra
aAdd(aCoresB, { "BR_LARANJA"	,"Pedido Bloquedo por verba"		})	//Pedido Bloquedo por verba
aAdd(aCoresB, { 'BR_PINK'		,"Pedido Parcialmente Entregue"		})	//Pedido Parcialmente Entregue
aAdd(aCoresB, { "BR_PRETO"		,"Pedido Totalmente Entregue"		})	//Pedido Totalmente Entregue
aAdd(aCoresB, { "BR_MARRON"		,"Pedido em Aberto com Entrega(s)"	})	//Pedido Aberto com Entrega
aAdd(aCoresB, { "BR_VIOLETA"	,"Pedido com Bloqueio Financeiro"	})	//Pedido com Bloqueio Financeiro
aAdd(aCoresB, { "BR_BRANCO"	    ,"Pedido com Elimina็ใo de Residuo"	})	//Pedido com Elimina็ใo de Residuo

Return(aCoresB)
