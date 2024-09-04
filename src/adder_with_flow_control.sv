   `define FLOW_CONTROL_BUFFER fcb_1_single_allows_back_to_back
// `define FLOW_CONTROL_BUFFER fcb_2_single_half_perf_no_comb_path
   `define FLOW_CONTROL_BUFFER fcb_3_single_for_pipes_with_global_stall
// `define FLOW_CONTROL_BUFFER fcb_4_wrapped_2_deep_fifo
// `define FLOW_CONTROL_BUFFER fcb_5_double_buffer_from_dally_harting

module adder_with_flow_control
# (
    parameter width = 8
)
(
    input                    clk,
    input                    rst,

    input                    a_vld,
    output                   a_rdy,
    input  [width     - 1:0] a_data,

    input                    b_vld,
    output                   b_rdy,
    input  [width     - 1:0] b_data,

    output                   sum_vld,
    input                    sum_rdy,
    output [width + 1 - 1:0] sum_data
);

    //------------------------------------------------------------------------

    wire               a_down_vld;
    wire               a_down_rdy;
    wire [width - 1:0] a_down_data;

    `FLOW_CONTROL_BUFFER
    # (.w (width))
    buffer_a
    (
        .clk       ( clk         ),
        .rst       ( rst         ),

        .up_vld    ( a_vld       ),
        .up_rdy    ( a_rdy       ),
        .up_data   ( a_data      ),

        .down_vld  ( a_down_vld  ),
        .down_rdy  ( a_down_rdy  ),
        .down_data ( a_down_data )
    );

    //------------------------------------------------------------------------

    wire               b_down_vld;
    wire               b_down_rdy;
    wire [width - 1:0] b_down_data;

    `FLOW_CONTROL_BUFFER
    # (.w (width))
    buffer_b
    (
        .clk       ( clk         ),
        .rst       ( rst         ),

        .up_vld    ( b_vld       ),
        .up_rdy    ( b_rdy       ),
        .up_data   ( b_data      ),

        .down_vld  ( b_down_vld  ),
        .down_rdy  ( b_down_rdy  ),
        .down_data ( b_down_data )
    );

    //------------------------------------------------------------------------

    // Task: Add logic using the template below
    //
    // wire               sum_up_vld = ...
    // wire               sum_up_rdy;
    // wire [width - 1:0] sum_up_data  = ...
    //
    // assign a_down_rdy = ...
    // assign b_down_rdy = ...

    wire                   sum_up_vld  = a_down_vld  & b_down_vld;
    wire                   sum_up_rdy;
    wire [width + 1 - 1:0] sum_up_data = a_down_data + b_down_data;

    wire   nobody_vld = ~ a_down_vld & ~ b_down_vld;

    assign a_down_rdy = (b_down_vld & sum_up_rdy) | nobody_vld;
    assign b_down_rdy = (a_down_vld & sum_up_rdy) | nobody_vld;

    //------------------------------------------------------------------------

    `FLOW_CONTROL_BUFFER
    # (.w (width + 1))
    buffer_sum
    (
        .clk       ( clk         ),
        .rst       ( rst         ),

        .up_vld    ( sum_up_vld  ),
        .up_rdy    ( sum_up_rdy  ),
        .up_data   ( sum_up_data ),

        .down_vld  ( sum_vld     ),
        .down_rdy  ( sum_rdy     ),
        .down_data ( sum_data    )
    );

endmodule
