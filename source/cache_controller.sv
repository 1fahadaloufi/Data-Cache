`include "cache_data_structs.sv"
module cache_controller(
    input logic clk, 
    input logic n_rst, 

    //memory interface
    input mem_res_type mem_res,
    output mem_req_type mem_req, 

    // cpu interface
    input cpu_req_type cpu_req,
    output cpu_res_type cpu_res
);

cache_req_type cache_req; 
cache_res_type cache_res; 

typedef enum logic[1:0] {IDLE, ALLOCATE, WRITE_BACK} state_t; 

state_t curr_state, next_state; 

cache_mem CACHE_MEM(
    .clk(clk),
    .cache_req(cache_req),

    .cache_res(cache_res)
); 


always_comb begin: CONTROLLER_LOGIC
    // default signals
    next_state = curr_state; // no change in state
    mem_req = '{1'b0, 1'b0, cpu_req.addr, cache_res.data}; // the 1'b0s are rw and valid bits 
    cpu_res = '{'b0, 'b0}; // data ='b0, req_done = 'b0; 
    cache_req = '{cache_res.tag, 'b0, 'b0, cpu_req.addr, cache_res.data}; // the 'b0s are data, tag, rw and req done bits
    
    cache_req.tag.tag = cpu_req.addr[TAG_MSB:TAG_LSB]; 
    cache_req.tag.valid = 1'b1; 

    // select correct word to read & write 
    if(cpu_req.addr[WORD_SEL_BIT]) begin
        cpu_res.data = cache_res.data[63:32];
        cache_req.data[63:32] = cpu_req.data;
    end 
    else begin
        cpu_res.data = cache_res.data[31:0];
        cache_req.data[31:0] = cpu_req.data; 
    end  
    

    // FSM Logic
    case(curr_state)
        IDLE: begin
            if(cpu_req.valid && cache_res.hit) begin
                cpu_res.req_done = 1'b1; 
                if(cpu_req.rw) begin
                    cache_req.tag.dirty = 1'b1; 
                    cache_req.rw = 1'b1; 
                end
            end 
            else if(cpu_req.valid && ~cache_res.hit) begin
                mem_req.valid = 1'b1;
                if(cache_res.tag.dirty) begin
                    next_state = WRITE_BACK; 
                    mem_req.rw = 1'b1;  
                    mem_req.addr = {cache_res.tag.tag, cpu_req.addr[IDX_MSB:IDX_LSB], 3'b0}; 
                end
                else begin
                    next_state = ALLOCATE; 
                end
            end 
        end

        WRITE_BACK: begin
            if(mem_res.ready) begin
                mem_req.valid = 1'b1; 
                mem_req.rw = 1'b1; 
                next_state = ALLOCATE; 
            end
        end

        ALLOCATE: begin
            if(mem_res.ready) begin
                cache_req.rw = 1'b1; 
                cache_req.data = mem_res.data; 
                next_state = IDLE; 
            end
        end
    endcase 


    cache_req.req_done = cpu_res.req_done; // same signal goes to both cpu(let it know req is done) and cache (to update lru memory)
    
end 


always_ff @(posedge clk, negedge n_rst) begin
    if(~n_rst)
        curr_state <= IDLE; 
    else 
        curr_state <= next_state; 
end


endmodule 