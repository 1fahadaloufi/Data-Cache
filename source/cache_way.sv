`include "cache_data_structs.sv"
module cache_way(
    input logic clk,
    input logic[31:0] addr,
    input logic wen,
    input tag_type tag_w,
    input logic[63:0] data_w,

    output logic[63:0] data_r, 
    output tag_type tag_r, 
    output logic hit 
);


logic[4:0] index; 
logic[63:0] data_memory[0:31]; 
tag_type tmp; 

tag_type tag_memory[0:31]; 


assign index  = addr[IDX_MSB:IDX_LSB]; 
assign data_r = data_memory[index]; 
assign tag_r  = tag_memory[index]; 

// initial all memories: tag and data to 0s 
initial begin
    for(integer i=0; i < 32; i+=1) begin
        data_memory[i] = 'b0;
        tag_memory[i]  = '{'b0, 'b0, 'b0}; 
    end 
    
end

// write on positive edge of clock
always @(posedge clk) begin
    if(wen) begin
        data_memory[index] = data_w; 
        tag_memory[index]  = tag_w; 
    end
end


always_comb begin: HIT_LOGIC
    tmp = tag_memory[index]; 
    if(tmp.valid && (tmp.tag == addr[TAG_MSB:TAG_LSB]))
        hit = 1'b1; 
    else 
        hit = 1'b0; 
end

endmodule 