module AverageOp #(
    parameter PIXEL_WIDTH = 8
)(clk,arstn,din_data,din_valid,dout_valid,dout_data);
input clk;
input arstn;
input din_valid;
input [PIXEL_WIDTH+4-1:0]din_data;
output dout_valid;
output [PIXEL_WIDTH-1:0]dout_data;

reg [PIXEL_WIDTH+4-1:0]data_delay00;
reg [PIXEL_WIDTH+4-1:0]data_delay10;
reg [PIXEL_WIDTH+4-1:0]data_delay11;
reg [PIXEL_WIDTH+4-1:0]data_delay12;
reg [PIXEL_WIDTH+4-1:0]data_delay20;
reg [PIXEL_WIDTH+4-1:0]data_delay21;
reg [PIXEL_WIDTH+4-1:0]data_delay30;
reg dvalid_delay0;
reg dvalid_delay1;
reg dvalid_delay2;
reg dvalid_delay3;
assign dout_valid = dvalid_delay3;
assign dout_data[PIXEL_WIDTH-1:0] = data_delay30[PIXEL_WIDTH-1:0];
/* First pipe */
always@(posedge clk or negedge arstn)
    begin
        if(~arstn)
            data_delay00 <= 0;
        else
            if(din_valid)
                data_delay00 <= (din_data >> 4);
    end

/* second pipe */
always@(posedge clk or negedge arstn)
    begin
        if(~arstn)
            begin
                data_delay10 <= 0;
                data_delay11 <= 0;
                data_delay12 <= 0;
            end
        else
            begin
                data_delay10 <= data_delay00;
                data_delay11 <= data_delay00 >> 1;
                data_delay12 <= data_delay00 >> 2;
            end
    end
    
/* Third pipe */
always@(posedge clk or negedge arstn)
    begin
        if(~arstn)
            begin
                data_delay20 <= 0;
                data_delay21 <= 0;
            end
        else
            begin
                data_delay20 <= data_delay10 + data_delay11;
                data_delay21 <= data_delay12;
            end
    end

/* Fourth pipe */
always@(posedge clk or negedge arstn)
    begin
        if(~arstn)
            begin
                data_delay30 <= 0;
            end
        else
            begin
                data_delay30 <= data_delay20 + data_delay21;
            end
    end
    
always@(posedge clk or negedge arstn)
    begin
        if(~arstn)
            begin
                dvalid_delay0 <= 0;
                dvalid_delay1 <= 0;
                dvalid_delay2 <= 0;
                dvalid_delay3 <= 0;
            end
        else
            begin
                dvalid_delay0 <= din_valid;
                dvalid_delay1 <= dvalid_delay0;
                dvalid_delay2 <= dvalid_delay1;
                dvalid_delay3 <= dvalid_delay2;
            end
    end
endmodule












