`timescale 1ns / 1ps
module fifo(
    input clk,
    input reset,
    input read,
    input write,
    input [7:0] data_in,
    output full,
    output empty,
    output reg [7:0] data_out
    );

    reg [7:0] FIFO_Memory [7:0];
    
    reg [2:0] read_ptr,write_ptr;
    
    reg [3:0] count;
    
    //Generating full and empty signals
    assign full=(count==8);
    assign empty=(count==0);

    //Updating the Counter
    always@(posedge clk or posedge reset) begin
        if(reset)
            count<=0;
        //Both Read and Write 
        else if((!full && write)&&(!empty && read)) 
            count<=count; //No change in Count
        //Only Write Operation
        else if((!full && write)) 
            count<=count+1; //Increment Count
        //Only Read Operation
        else if(!empty&&read)
            count<=count-1; //Decrement Count
        else
            count<=count;
    end
    
    //Updating the Pointers 
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            read_ptr<=0;
            write_ptr<=0;
        end
        else begin
            if(!full&&write)
                write_ptr<=write_ptr+1;
            else
                write_ptr<=write_ptr;
                
            if(!empty&&read)
                read_ptr<=read_ptr+1;
            else
                read_ptr<=read_ptr;
        end
    end 
    
    //Reading Operation
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            data_out<=0;
        end
        else begin
            if(!empty&&read)
                data_out<=FIFO_Memory[read_ptr];
            else
                data_out<=data_out;    
        end
    end
    
    //Writing Operation
    always@(posedge clk) begin
        if(!full&&write) 
            FIFO_Memory[write_ptr]<=data_in;
        else
            FIFO_Memory[write_ptr]<=FIFO_Memory[write_ptr];
    end
       
endmodule
