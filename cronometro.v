module cronometro (clock,btn_conta,btn_pausa,btn_reset,btn_para,ESPERA,CONTAR,PARAR,PAUSA,display_seg,display_dec_segs);  
    input clock, btn_conta,btn_pausa,btn_reset,btn_para; //INPUTS DE CLOCK E BOTOES
	 
	 
    output reg ESPERA,CONTAR,PARAR,PAUSA; //SAÍDA QUE IDENTIFICA OS ESTADOS

    reg [9:0] cont_seg; //REGISTRADOR DO CRONOMETRO EM SEGUNDOS
    reg [3:0]cont_dec; //REGISTRADOR DO CRONOMETRO EM DECIMOS DE SEGUNDOS

    reg [1:0] estado_atual; //REGISTRADOR DO ESTADO ATUAL

    output reg [9:0] display_seg=0; //OUTPUT DO DISPLAY EM SEGUNDOS
    output reg [9:0] display_dec_segs=0; //OUTPUT DO DISPLAY EM DECIMOS DE SEGUNDOS

    //reg [3:0] contador=0; 
	 
	 initial begin
		cont_seg = 0;
		cont_dec = 0;
		estado_atual = E_ESPERANDO;
	 end

    parameter E_ESPERANDO =0,E_CONTANDO=1,E_PARADO=2,E_PAUSADO=3; //VALORES DOS ESTADOS

       always @(posedge clock) begin
        case (estado_atual)

				E_ESPERANDO  : begin //ESTADO INICIAL DO CRONOMETRO ESPERA O BOTAO(btn_conta) INICIAR O CRONOMETRO
                    cont_dec<=0;
                    cont_seg<=0;
                    display_dec_segs<=0;
                    display_seg<=0;
						  
                    if(btn_conta==0)begin // SE O BOTAO CONTAR ESTIVER ATIVO TROCA PARA O ESTADO DE CONTAR
                        estado_atual <= E_CONTANDO; //TROCA DO ESTADO PARA CONTANDO  
                         //CONTADOR = 0
                        // DISPLAY = 000.0
                end

				end 
				
				E_CONTANDO  : begin
                    if (btn_para==0) begin
                        estado_atual<=E_PARADO;
                    end else  if (btn_pausa==0) begin
                        estado_atual<=E_PAUSADO;
                    end else if (btn_reset==0) begin
                        estado_atual<=E_ESPERANDO;                       
                    end else begin
								 if(cont_dec == 9) begin
									cont_seg <= cont_seg + 1;             
									cont_dec <= 0;
									display_dec_segs <= 0;
									display_seg <= cont_seg +1;
								end else begin
									cont_dec <= cont_dec + 1;
									display_dec_segs <= cont_dec + 1;
								end 
								 if(cont_seg == 999) begin
										cont_seg <= 0;
										cont_dec <= 0;
										display_dec_segs <= 0;
										display_seg <= 0;
								 end
						  end
                     //CONTADOR = ++
                    // DISPLAY = CONTADOR
				end 

                E_PARADO  : begin        
                    if (btn_conta==0) begin
                        estado_atual<=E_CONTANDO;
                    end else begin
                        cont_seg<=cont_seg;
                        cont_dec<=cont_dec;
                        display_seg<=cont_seg;
                        display_dec_segs<=cont_dec;
                    end
                 // LÓGICA DO CONTADOR PARADO (SEM INCREMENTAR O REGISTRADOR contador)
                 // LÓGICA DO DISPLAY PARADO (QUE NAO RECEBE O VALOR CONTADOR NO REGISTRADOR display)
                        //CONTADOR = PAUSADO
                        // DISPLAY = PAUSADO
                end 

                 E_PAUSADO  : begin
                     if (btn_pausa==0) begin
                        estado_atual<=E_CONTANDO;
                     end else if (btn_reset==0) begin
								estado_atual<=E_ESPERANDO;
							end else begin
                         	if(cont_dec == 9) begin
								cont_seg <= cont_seg + 1;             
								cont_dec <= 0;
							end else begin
								cont_dec <= cont_dec + 1;
							end 
							if(cont_seg == 999) begin
								cont_seg <= 0;
								cont_dec <= 0;
							end
                     end
                 // LÓGICA DO CONTADOR PAUSADO (QUE CONTINUA INCREMENTANDO O REGISTRADOR contador)
                 // LÓGICA DO DISPLAY PAUSADO (QUE NAO RECEBE O VALOR DO CONTADOR NO REGISTRADOR display,
                 //APENAS RECEBE QUANDO VOLTAR A CONTAGEM COM O BOTAO CONTAR(btn_contar))
                        //CONTADOR = ++
                        // DISPLAY = PAUSADO
                 end         
            default: ;
        endcase;
    end
  
    
    always @(posedge btn_conta,posedge btn_reset,posedge btn_pausa,posedge btn_para) begin
        case (estado_atual)
           E_ESPERANDO : begin
               CONTAR=0;
					PARAR=0;
					PAUSA=0;
					ESPERA=1;
           end 
           E_CONTANDO : begin
               CONTAR=1;
					PARAR=0;
					PAUSA=0;
					ESPERA=0;
           end 
           E_PARADO : begin
               CONTAR=0;
					PARAR=1;
					PAUSA=0;
					ESPERA=0;
           end 
           E_PAUSADO : begin
               CONTAR=0;
					PARAR=0;
					PAUSA=1;
					ESPERA=0;
           end 
            default: ;
        endcase;       
    end

endmodule