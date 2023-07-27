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


// clock
always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0);
end


cache_controller DUT(
    .clk(tb_clk),
    .n_rst(tb_n_rst),

    .mem_res(tb_mem_res),
    .mem_req(tb_mem_req),

    .cpu_req(tb_cpu_req),
    .cpu_res(tb_cpu_res)
);

main_mem MAIN_MEM(
    .clk(tb_clk), 

    .mem_res(tb_mem_res),

    .mem_req(tb_mem_req)
); 

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
end

// simulation starts here 
initial begin
    tb_n_rst = 1'b0; 
    tb_cpu_req = 'b0;

    #(CLK_PERIOD * 2);

    @(negedge tb_clk);
    tb_n_rst = 1'b1; 

    // TEST CASE 1: Write to cache index 28, upper word
    tb_cpu_req.addr = 32'he4; 
    tb_cpu_req.data = 32'habcdefab; 
    tb_cpu_req.rw = 1'b1; 
    tb_cpu_req.valid = 1'b1; 


    @(posedge tb_cpu_res.req_done); 
    @(posedge tb_clk);
    tb_cpu_req.valid = 1'b0; 

    // then read the data

    @(posedge tb_clk); 
    tb_cpu_req.rw = 1'b0; 
    tb_cpu_req.valid = 1'b1; 

    @(posedge tb_clk); 
    tb_cpu_req.valid = 1'b0;
    @(posedge tb_clk); 

    // TEST CASE 2: write to same index in different way, lower word
    tb_cpu_req.addr = 32'h1e0; 
    tb_cpu_req.data = 32'habcabcaa; 
    tb_cpu_req.rw = 1'b1; 
    tb_cpu_req.valid = 1'b1; 

    @(posedge tb_clk); 
    @(posedge tb_cpu_res.req_done); 
    @(posedge tb_clk); 
    tb_cpu_req.valid = 1'b0; 




    // TEST CASE 3: Test write back policy 
    tb_cpu_req.addr = 32'h2e0; // should write to way 1 @ index 28
    tb_cpu_req.data = 32'hfafafa00; 
    tb_cpu_req.rw = 1'b1; 
    tb_cpu_req.valid = 1'b1; 
    
    @(posedge tb_clk);
    @(posedge tb_cpu_res.req_done);
    @(posedge tb_clk);
    tb_cpu_req.valid = 1'b0; 
    
    
    #(CLK_PERIOD * 10); 


    $finish; 

end

initial begin
    #(CLK_PERIOD * 30); 
    $finish; 
end

endmodule 

module main_mem(
    input logic clk, 
    input mem_req_type mem_req,

    output mem_res_type mem_res
);

logic[63:0] mem_data[0:1024]; 
logic ready1, ready2; 

initial begin
    ready1 = 1'b0;
    ready2 = 1'b0; 
    mem_res = 'b0; 
end

always_comb begin
    for(integer i = 0; i < 1024; i += 1) begin
        mem_data[i] = 'b0; 
    end
        if(mem_req.valid == 1'b1) begin
            if(mem_req.rw) begin
                mem_data[mem_req.addr >> 3] = mem_req.data; 
            end
            else begin
                mem_res.data = mem_data[mem_req.addr >> 3];
            end
            ready1 = 1'b1; 
        end
        else 
            ready1 = 1'b0; 
end

// takes 2 clock cycles to process any mem request 
always_ff @(posedge clk) begin
    mem_res.ready <= ready2; 
    ready2 <= ready1; 
end



endmodule 