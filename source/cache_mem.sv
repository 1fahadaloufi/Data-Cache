`include "cache_data_structs.sv"

module cache_mem(
    input logic clk, 
    input cache_req_type cache_req, 

    output cache_res_type cache_res
);


// way0 signals
logic wen0; 
tag_type tag_r0; 
logic[63:0] data_r0; 
logic hit0; 

//way1 signals 
logic wen1; 
tag_type tag_r1; 
logic[63:0] data_r1; 
logic hit1; 

// lru signals
logic lru1;


cache_way WAY0(
    .clk(clk),
    .addr(cache_req.addr), 
    .wen(wen0),
    .tag_w(cache_req.tag),
    .data_w(cache_req.data), 
    
    .data_r(data_r0),
    .tag_r(tag_r0),
    .hit(hit0)
);

cache_way WAY1(
    .clk(clk),
    .addr(cache_req.addr), 
    .wen(wen1),
    .tag_w(cache_req.tag),
    .data_w(cache_req.data), 
    
    .data_r(data_r1),
    .tag_r(tag_r1),
    .hit(hit1)
);

lru_mem LRU(
    .clk(clk),
    .idx(cache_req.addr[IDX_MSB:IDX_LSB]),
    .req_done(cache_req.req_done),
    .hit0(hit0),

    .lru1(lru1)
); 


assign wen0 = ~lru1 & cache_req.rw; 
assign wen1 = lru1 & cache_req.rw; 

always_comb begin
    cache_res.hit = hit0 | hit1; 
    if(~hit1 && (hit0 || ~lru1)) begin
        cache_res.data = data_r0; 
        cache_res.tag  = tag_r0; 
    end 
    else begin
        cache_res.data = data_r1; 
        cache_res.tag = tag_r1; 
    end

end



endmodule 