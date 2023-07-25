module lru_mem(
    input logic clk, 
    input logic[4:0] idx, 
    input logic req_done, 
    input logic hit0, 

    output logic lru1
);

logic lru_memory[0:31]; 

initial begin
    for(integer i=0; i < 32; i+=1)
        lru_memory[i] = 1'b0; 
end

assign lru1 = lru_memory[idx]; 

// update memory on rising edge of clock if req is done
always @(posedge clk) begin
    if(req_done)
        lru_memory[idx] = hit0; // if way0 has a hit, way1 is lru
end

endmodule 