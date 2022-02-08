module AverageCapture #(
    parameter PIXEL_WIDTH = 8
)
(clk,arstn,din_data,din_valid,dout_valid,dout_data);
input clk;
input arstn;
input [PIXEL_WIDTH+4-1:0]din_data;
input din_valid;
output dout_valid;
output [PIXEL_WIDTH+4-1:0]dout_data;
reg tvalid_delay0;
reg tvalid_delay1;
reg [PIXEL_WIDTH+4-1:0]data_delay0;
reg [PIXEL_WIDTH+4-1:0]data_delay1;
reg [PIXEL_WIDTH+4-1:0]data_reg;
reg dout_valid_reg;

assign dout_valid = dout_valid_reg;
assign dout_data = data_reg;

always@(posedge clk or negedge arstn)
    begin
        if(~arstn)
            begin
                tvalid_delay0 <= 0;
                tvalid_delay1 <= 0;
                data_delay0 <= 0;
                data_delay1 <= 0;
            end
        else
            begin
                tvalid_delay0 <= din_valid;
                tvalid_delay1 <= tvalid_delay0;
                data_delay0 <= din_data;
                data_delay1 <= data_delay0;
            end        
    end

always@(posedge clk or negedge arstn)
    begin
        if(~arstn)
            begin
                data_reg <= 0;
                dout_valid_reg <= 0;
            end
        else
            begin
                if(tvalid_delay0)
                    begin
                        data_reg <= data_delay0;
                        dout_valid_reg <= 1'b1;
                    end
                else if(~tvalid_delay0 & tvalid_delay1)
                    begin
                        data_reg <= data_delay0;
                        dout_valid_reg <= 1'b1;
                    end
                else
                    begin
                        dout_valid_reg <= 1'b0;
                    end
            end
    end
endmodule











