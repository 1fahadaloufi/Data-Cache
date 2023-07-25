`include "cache_data_structs.sv"
`timescale 1ns/1ns

module tb_cache_controller();

localparam CLK_PERIOD = 100; 


logic tb_clk; 
logic tb_n_rst; 

// mem interface
mem_res_type tb_mem_res;
mem_req_type tb_mem_req; 

// cpu interface 
cpu_req_type tb_cpu_req; 
cpu_res_type tb_cpu_res; 

// logic[31:0] tb_addr;
// logic tb_wen;
// tag_type tb_tag_w; 
// logic[63:0] tb_data_w; 

//outputs
//cache_res_type tb_cache_res; 
// logic[63:0] tb_data_r; 
// tag_type tb_tag_r; 
// logic tb_hit; 


always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0);
end


cache_controller DUT(
    .clk(tb_clk),
    .n_rst(tb_n_nrst),

    .mem_res(tb_mem_res),
    .mem_req(tb_mem_req),

    .cpu_req(tb_cpu_req),
    .cpu_res(tb_cpu_res)
);
// cache_mem DUT(
//     .clk(tb_clk),
//     .cache_req(tb_cache_req),
    
//     .cache_res(tb_cache_res)
// ); 
// cache_mem DUT(
    
//     // inputs 
//     .clk(tb_clk),
//     .addr(tb_addr),
//     .wen(tb_wen),
//     .tag_w(tb_tag_w),
//     .data_w(tb_data_w),

//     //outputs 
//     .data_r(tb_data_r),
//     .tag_r(tb_tag_r),
//     .hit(tb_hit)
// );

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
end

initial begin

    tb_n_rst = 1'b0; 
    tb_mem_res = 'b0; 
    tb_cpu_req = 'b0;

    #(CLK_PERIOD * 5);  
    // tb_cache_req = 'b0; 

    // #(CLK_PERIOD * 5); 


    // @(negedge tb_clk);
    // tb_cache_req.addr = 32'hf8; 
    // tb_cache_req.rw = 1'b1; 
    // tb_cache_req.data = '1; 
    // tb_cache_req.tag = '{1'b1, 1'b1, tb_cache_req.addr[TAG_MSB:TAG_LSB]}; 
    
    // @(negedge tb_clk); 
    // tb_cache_req.rw = 1'b0; 
    // tb_cache_req.req_done = 1'b1; 

    // @(negedge tb_clk); 
   // tb_cache_req.req_done = 1'b0;

    //#(CLK_PERIOD * 2); 
    // tb_addr = 'b0; 
    // tb_wen = 'b0; 
    // tb_tag_w = 'b0; 
    // tb_data_w = 'b0; 

    // #(CLK_PERIOD * 2);

    // @(negedge tb_clk); 
    // tb_addr = 32'hf8; 
    // tb_data_w = '1; 
    // tb_tag_w = '{1'b1, 1'b1, 24'b0};
    // tb_wen = 1'b1; 
    // @(negedge tb_clk);
    // tb_wen = 1'b0;

    // #(CLK_PERIOD * 2);


    $finish; 

end





endmodule 