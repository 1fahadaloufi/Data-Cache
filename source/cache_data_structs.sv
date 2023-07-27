`ifndef DATA_STRUCTS
`define DATA_STRUCTS 

parameter TAG_MSB = 31;
parameter TAG_LSB = 8;

parameter IDX_MSB = 7; 
parameter IDX_LSB = 3; 

parameter WORD_SEL_BIT = 2; 

typedef struct packed {
    logic valid;
    logic dirty; 
    logic[23:0] tag;
} tag_type;


/* 
-------------------------------------------
Cache Memory & Controller Interface Signals
--------------------------------------------
*/

// Controller -> Cache interface
typedef struct packed {
    tag_type tag; 
    logic rw;
    logic req_done; 
    
    logic[31:0] addr;
    logic[63:0] data;
} cache_req_type; // cache request type

// Cache -> Controller 
typedef struct packed {
    logic hit;
    tag_type tag;  
    
    logic[63:0] data;
} cache_res_type; //cache response type

/* 
-------------------------------------------
Main Memory & Controller Interface Signals
--------------------------------------------
*/

// memory -> controller
typedef struct packed {
    logic ready;
    logic[63:0] data; 
} mem_res_type; 

// controller -> memory
typedef struct packed {
    logic rw; 
    logic valid; 
    logic[31:0] addr; 
    logic[63:0] data; 
} mem_req_type; 

/* 
-------------------------------------------
CPU & Controller Interface Signals
--------------------------------------------
*/

// cpu -> controller
typedef struct packed{
    logic rw; 
    logic valid; 
    logic[31:0] addr; 
    logic[31:0] data; 
} cpu_req_type; 

// controller -> cpu
typedef struct packed{
    logic req_done;
    logic[31:0] data;  
} cpu_res_type; 

`endif 
