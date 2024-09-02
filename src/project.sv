/*
 * Copyright (c) 2024 Yuri Panchul
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_adder_with_flow_control
(
    input  [7:0] ui_in,    // Dedicated inputs
    output [7:0] uo_out,   // Dedicated outputs
    input  [7:0] uio_in,   // IOs: Input path
    output [7:0] uio_out,  // IOs: Output path
    output [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input        ena,      // always 1 when the design is powered, so you can ignore it
    input        clk,      // clock
    input        rst_n     // reset_n - low to reset
);

    // All output pins must be assigned. If not used, assign to 0.

    assign uio_out = '0;
    assign uio_oe  = '0;

    // List all unused inputs to prevent warnings

    wire _unused = & { ena, ui_in [7:3], 1'b0 };

    // User design module instantiation

    adder_with_flow_control
    # (.width (4))
    inst
    (
        .clk       (   clk           ),
        .rst       ( ~ rst_n         ),

        .a_vld     (   ui_in   [0]   ),
        .a_rdy     (   uo_out  [0]   ),
        .a_data    (   uio_in  [3:0] ),

        .b_vld     (   ui_in   [1]   ),
        .b_rdy     (   uo_out  [1]   ),
        .b_data    (   uio_in  [7:4] ),

        .sum_vld   (   uo_out  [2]   ),
        .sum_rdy   (   ui_in   [2]   ),
        .sum_data  (   uo_out  [7:3] )
);


endmodule
