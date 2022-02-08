`timescale 1ns / 1ps

module average_tb;
parameter DATA_WIDTH = 8;
parameter BUFFER_DEPTH = 256;
parameter FIFO_WIDTH = 8;
parameter LINE_NUM = 3;
parameter IMAGE_WIDTH = 128;

bit clk;
bit arstn;
bit [DATA_WIDTH-1:0]data_in;
bit datain_valid;
wire [DATA_WIDTH*LINE_NUM-1:0]dout_align;
wire align_valid;
wire [DATA_WIDTH+4-1:0]data_out;
wire dout_valid;

wire [DATA_WIDTH-1:0]data_out0;
wire [DATA_WIDTH-1:0]data_out1;
wire [DATA_WIDTH-1:0]data_out2;
integer i,j;
always #5 clk = ~clk;

initial
    begin
        arstn = 1'b1;
        datain_valid = 1'b0;
        #20
        arstn = 1'b0;
        #20
        arstn = 1'b1;
        for(i=1;i<7;i=i+1)
            begin
                for(j=1;j<129;j=j+1)
                    begin
                        @(posedge clk);
                        #2
                            data_in = j;
                            datain_valid = 1'b1;
                    end
            end
       @(posedge clk);
       //@(posedge clk);
       datain_valid = 1'b0;
       #200 $finish;
    end


assign data_out0[DATA_WIDTH-1:0] = dout_align[DATA_WIDTH-1:0];
assign data_out1[DATA_WIDTH-1:0] = dout_align[2*DATA_WIDTH-1:DATA_WIDTH];
assign data_out2[DATA_WIDTH-1:0] = dout_align[3*DATA_WIDTH-1:2*DATA_WIDTH];
LineAlign #(
    .DATA_WIDTH(DATA_WIDTH),
    .BUFFER_DEPTH(BUFFER_DEPTH),
    .FIFO_WIDTH(FIFO_WIDTH),
    .LINE_NUM(LINE_NUM),
    .IMAGE_WIDTH(IMAGE_WIDTH)
)Inst_LineAlign(
    .clk(clk),
    .arstn(arstn),
    .data_in(data_in),
    .datain_valid(datain_valid),
    .data_out(dout_align),
    .dataout_valid(align_valid));
    
Average3x3 #(
    .LINE_NUM(LINE_NUM),
    .PIXEL_WIDTH(DATA_WIDTH),
    .KX_WIDTH(LINE_NUM),
    .IMAGE_WIDTH(IMAGE_WIDTH)
)Inst_average(
    .clk(clk),
    .arstn(arstn),
    .data_in(dout_align),
    .din_valid(align_valid),
    .data_out(data_out),
    .dout_valid(dout_valid));

wire dout_valid_cap;
wire [DATA_WIDTH+4-1:0]dout_data_cap;

AverageCapture #(
    .PIXEL_WIDTH(DATA_WIDTH)
)Inst_AverageCapture(
    .clk(clk),
    .arstn(arstn),
    .din_data(data_out),
    .din_valid(dout_valid),
    .dout_valid(dout_valid_cap),
    .dout_data(dout_data_cap));

wire [DATA_WIDTH-1:0]op_dout;
wire op_dvalid;
AverageOp #(
        .PIXEL_WIDTH(DATA_WIDTH)
)Inst_AverageOp(
    .clk(clk),
    .arstn(arstn),
    .din_data(dout_data_cap),
    .din_valid(dout_valid_cap),
    .dout_valid(op_dvalid),
    .dout_data(op_dout));
//bit clk;
//bit arstn;
//bit [DATA_WIDTH-1:0]data_in;
//bit datain_valid;
//wire [3*DATA_WIDTH-1:0]data_out;
//wire dataout_valid;
//wire [DATA_WIDTH-1:0]data_out0;
//wire [DATA_WIDTH-1:0]data_out1;
//wire [DATA_WIDTH-1:0]data_out2;
//integer i,j;
//always #5 clk = ~clk;
//initial
//    begin
//        datain_valid = 1'b0;
//        arstn = 1'b1;
//        data_in = 0;
//        #20
//        arstn = 1'b0;
//        #20
//        arstn = 1'b1;
//        for(i=1;i<13;i=i+1)
//            begin
//                for(j=1;j<129;j=j+1)
//                    begin
//                        @(posedge clk);
//                        #2 
//                            data_in = j;
//                            datain_valid = 1'b1;
//                            //$display("%d ",data_in);
//                    end
//                   // $display("\n");
//            end
//        @(posedge clk);
//            datain_valid = 1'b0;
//        #2000 $finish;
//    end




//assign data_out0[DATA_WIDTH-1:0] = data_out[DATA_WIDTH-1:0];
//assign data_out1[DATA_WIDTH-1:0] = data_out[2*DATA_WIDTH-1:DATA_WIDTH];
//assign data_out2[DATA_WIDTH-1:0] = data_out[3*DATA_WIDTH-1:2*DATA_WIDTH];
//LineAlign #(
//    .DATA_WIDTH(DATA_WIDTH),
//    .BUFFER_DEPTH(BUFFER_DEPTH),
//    .FIFO_WIDTH(FIFO_WIDTH),
//    .LINE_NUM(LINE_NUM),
//    .IMAGE_WIDTH(IMAGE_WIDTH)
    
//)DUT(clk,arstn,data_in,datain_valid,data_out,dataout_valid);
endmodule
