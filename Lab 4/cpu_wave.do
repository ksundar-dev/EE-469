onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpustim/clk
add wave -noupdate /cpustim/reset
add wave -noupdate -radix hexadecimal /cpustim/PC_out
add wave -noupdate -radix binary /cpustim/dut/instruction
add wave -noupdate /cpustim/dut/flag_negative
add wave -noupdate /cpustim/dut/flag_overflow
add wave -noupdate /cpustim/dut/ALU_negative
add wave -noupdate /cpustim/dut/ALU_zero
add wave -noupdate /cpustim/dut/ALU_overflow
add wave -noupdate /cpustim/dut/ALU_carry_out
add wave -noupdate -label X0 -radix decimal {/cpustim/dut/rf/regout[0]}
add wave -noupdate -label X1 -radix decimal {/cpustim/dut/rf/regout[1]}
add wave -noupdate -label X2 -radix decimal {/cpustim/dut/rf/regout[2]}
add wave -noupdate -label X3 -radix decimal -childformat {{{/cpustim/dut/rf/regout[3][63]} -radix decimal} {{/cpustim/dut/rf/regout[3][62]} -radix decimal} {{/cpustim/dut/rf/regout[3][61]} -radix decimal} {{/cpustim/dut/rf/regout[3][60]} -radix decimal} {{/cpustim/dut/rf/regout[3][59]} -radix decimal} {{/cpustim/dut/rf/regout[3][58]} -radix decimal} {{/cpustim/dut/rf/regout[3][57]} -radix decimal} {{/cpustim/dut/rf/regout[3][56]} -radix decimal} {{/cpustim/dut/rf/regout[3][55]} -radix decimal} {{/cpustim/dut/rf/regout[3][54]} -radix decimal} {{/cpustim/dut/rf/regout[3][53]} -radix decimal} {{/cpustim/dut/rf/regout[3][52]} -radix decimal} {{/cpustim/dut/rf/regout[3][51]} -radix decimal} {{/cpustim/dut/rf/regout[3][50]} -radix decimal} {{/cpustim/dut/rf/regout[3][49]} -radix decimal} {{/cpustim/dut/rf/regout[3][48]} -radix decimal} {{/cpustim/dut/rf/regout[3][47]} -radix decimal} {{/cpustim/dut/rf/regout[3][46]} -radix decimal} {{/cpustim/dut/rf/regout[3][45]} -radix decimal} {{/cpustim/dut/rf/regout[3][44]} -radix decimal} {{/cpustim/dut/rf/regout[3][43]} -radix decimal} {{/cpustim/dut/rf/regout[3][42]} -radix decimal} {{/cpustim/dut/rf/regout[3][41]} -radix decimal} {{/cpustim/dut/rf/regout[3][40]} -radix decimal} {{/cpustim/dut/rf/regout[3][39]} -radix decimal} {{/cpustim/dut/rf/regout[3][38]} -radix decimal} {{/cpustim/dut/rf/regout[3][37]} -radix decimal} {{/cpustim/dut/rf/regout[3][36]} -radix decimal} {{/cpustim/dut/rf/regout[3][35]} -radix decimal} {{/cpustim/dut/rf/regout[3][34]} -radix decimal} {{/cpustim/dut/rf/regout[3][33]} -radix decimal} {{/cpustim/dut/rf/regout[3][32]} -radix decimal} {{/cpustim/dut/rf/regout[3][31]} -radix decimal} {{/cpustim/dut/rf/regout[3][30]} -radix decimal} {{/cpustim/dut/rf/regout[3][29]} -radix decimal} {{/cpustim/dut/rf/regout[3][28]} -radix decimal} {{/cpustim/dut/rf/regout[3][27]} -radix decimal} {{/cpustim/dut/rf/regout[3][26]} -radix decimal} {{/cpustim/dut/rf/regout[3][25]} -radix decimal} {{/cpustim/dut/rf/regout[3][24]} -radix decimal} {{/cpustim/dut/rf/regout[3][23]} -radix decimal} {{/cpustim/dut/rf/regout[3][22]} -radix decimal} {{/cpustim/dut/rf/regout[3][21]} -radix decimal} {{/cpustim/dut/rf/regout[3][20]} -radix decimal} {{/cpustim/dut/rf/regout[3][19]} -radix decimal} {{/cpustim/dut/rf/regout[3][18]} -radix decimal} {{/cpustim/dut/rf/regout[3][17]} -radix decimal} {{/cpustim/dut/rf/regout[3][16]} -radix decimal} {{/cpustim/dut/rf/regout[3][15]} -radix decimal} {{/cpustim/dut/rf/regout[3][14]} -radix decimal} {{/cpustim/dut/rf/regout[3][13]} -radix decimal} {{/cpustim/dut/rf/regout[3][12]} -radix decimal} {{/cpustim/dut/rf/regout[3][11]} -radix decimal} {{/cpustim/dut/rf/regout[3][10]} -radix decimal} {{/cpustim/dut/rf/regout[3][9]} -radix decimal} {{/cpustim/dut/rf/regout[3][8]} -radix decimal} {{/cpustim/dut/rf/regout[3][7]} -radix decimal} {{/cpustim/dut/rf/regout[3][6]} -radix decimal} {{/cpustim/dut/rf/regout[3][5]} -radix decimal} {{/cpustim/dut/rf/regout[3][4]} -radix decimal} {{/cpustim/dut/rf/regout[3][3]} -radix decimal} {{/cpustim/dut/rf/regout[3][2]} -radix decimal} {{/cpustim/dut/rf/regout[3][1]} -radix decimal} {{/cpustim/dut/rf/regout[3][0]} -radix decimal}} -subitemconfig {{/cpustim/dut/rf/regout[3][63]} {-radix decimal} {/cpustim/dut/rf/regout[3][62]} {-radix decimal} {/cpustim/dut/rf/regout[3][61]} {-radix decimal} {/cpustim/dut/rf/regout[3][60]} {-radix decimal} {/cpustim/dut/rf/regout[3][59]} {-radix decimal} {/cpustim/dut/rf/regout[3][58]} {-radix decimal} {/cpustim/dut/rf/regout[3][57]} {-radix decimal} {/cpustim/dut/rf/regout[3][56]} {-radix decimal} {/cpustim/dut/rf/regout[3][55]} {-radix decimal} {/cpustim/dut/rf/regout[3][54]} {-radix decimal} {/cpustim/dut/rf/regout[3][53]} {-radix decimal} {/cpustim/dut/rf/regout[3][52]} {-radix decimal} {/cpustim/dut/rf/regout[3][51]} {-radix decimal} {/cpustim/dut/rf/regout[3][50]} {-radix decimal} {/cpustim/dut/rf/regout[3][49]} {-radix decimal} {/cpustim/dut/rf/regout[3][48]} {-radix decimal} {/cpustim/dut/rf/regout[3][47]} {-radix decimal} {/cpustim/dut/rf/regout[3][46]} {-radix decimal} {/cpustim/dut/rf/regout[3][45]} {-radix decimal} {/cpustim/dut/rf/regout[3][44]} {-radix decimal} {/cpustim/dut/rf/regout[3][43]} {-radix decimal} {/cpustim/dut/rf/regout[3][42]} {-radix decimal} {/cpustim/dut/rf/regout[3][41]} {-radix decimal} {/cpustim/dut/rf/regout[3][40]} {-radix decimal} {/cpustim/dut/rf/regout[3][39]} {-radix decimal} {/cpustim/dut/rf/regout[3][38]} {-radix decimal} {/cpustim/dut/rf/regout[3][37]} {-radix decimal} {/cpustim/dut/rf/regout[3][36]} {-radix decimal} {/cpustim/dut/rf/regout[3][35]} {-radix decimal} {/cpustim/dut/rf/regout[3][34]} {-radix decimal} {/cpustim/dut/rf/regout[3][33]} {-radix decimal} {/cpustim/dut/rf/regout[3][32]} {-radix decimal} {/cpustim/dut/rf/regout[3][31]} {-radix decimal} {/cpustim/dut/rf/regout[3][30]} {-radix decimal} {/cpustim/dut/rf/regout[3][29]} {-radix decimal} {/cpustim/dut/rf/regout[3][28]} {-radix decimal} {/cpustim/dut/rf/regout[3][27]} {-radix decimal} {/cpustim/dut/rf/regout[3][26]} {-radix decimal} {/cpustim/dut/rf/regout[3][25]} {-radix decimal} {/cpustim/dut/rf/regout[3][24]} {-radix decimal} {/cpustim/dut/rf/regout[3][23]} {-radix decimal} {/cpustim/dut/rf/regout[3][22]} {-radix decimal} {/cpustim/dut/rf/regout[3][21]} {-radix decimal} {/cpustim/dut/rf/regout[3][20]} {-radix decimal} {/cpustim/dut/rf/regout[3][19]} {-radix decimal} {/cpustim/dut/rf/regout[3][18]} {-radix decimal} {/cpustim/dut/rf/regout[3][17]} {-radix decimal} {/cpustim/dut/rf/regout[3][16]} {-radix decimal} {/cpustim/dut/rf/regout[3][15]} {-radix decimal} {/cpustim/dut/rf/regout[3][14]} {-radix decimal} {/cpustim/dut/rf/regout[3][13]} {-radix decimal} {/cpustim/dut/rf/regout[3][12]} {-radix decimal} {/cpustim/dut/rf/regout[3][11]} {-radix decimal} {/cpustim/dut/rf/regout[3][10]} {-radix decimal} {/cpustim/dut/rf/regout[3][9]} {-radix decimal} {/cpustim/dut/rf/regout[3][8]} {-radix decimal} {/cpustim/dut/rf/regout[3][7]} {-radix decimal} {/cpustim/dut/rf/regout[3][6]} {-radix decimal} {/cpustim/dut/rf/regout[3][5]} {-radix decimal} {/cpustim/dut/rf/regout[3][4]} {-radix decimal} {/cpustim/dut/rf/regout[3][3]} {-radix decimal} {/cpustim/dut/rf/regout[3][2]} {-radix decimal} {/cpustim/dut/rf/regout[3][1]} {-radix decimal} {/cpustim/dut/rf/regout[3][0]} {-radix decimal}} {/cpustim/dut/rf/regout[3]}
add wave -noupdate -label X4 -radix decimal {/cpustim/dut/rf/regout[4]}
add wave -noupdate -label X5 -radix decimal {/cpustim/dut/rf/regout[5]}
add wave -noupdate -label X6 -radix decimal {/cpustim/dut/rf/regout[6]}
add wave -noupdate -label X7 -radix decimal {/cpustim/dut/rf/regout[7]}
add wave -noupdate -label X8 -radix decimal {/cpustim/dut/rf/regout[8]}
add wave -noupdate -label X9 -radix decimal {/cpustim/dut/rf/regout[9]}
add wave -noupdate -label X10 -radix decimal {/cpustim/dut/rf/regout[10]}
add wave -noupdate -label X11 -radix decimal {/cpustim/dut/rf/regout[11]}
add wave -noupdate -label X12 -radix decimal {/cpustim/dut/rf/regout[12]}
add wave -noupdate -label X13 -radix decimal {/cpustim/dut/rf/regout[13]}
add wave -noupdate -label X14 -radix decimal {/cpustim/dut/rf/regout[14]}
add wave -noupdate -label X15 -radix decimal {/cpustim/dut/rf/regout[15]}
add wave -noupdate -label X16 -radix decimal {/cpustim/dut/rf/regout[16]}
add wave -noupdate -label X17 -radix decimal {/cpustim/dut/rf/regout[17]}
add wave -noupdate -label X18 -radix decimal {/cpustim/dut/rf/regout[18]}
add wave -noupdate -label X19 -radix decimal {/cpustim/dut/rf/regout[19]}
add wave -noupdate -label X20 -radix decimal {/cpustim/dut/rf/regout[20]}
add wave -noupdate -label X21 -radix decimal {/cpustim/dut/rf/regout[21]}
add wave -noupdate -label X22 -radix decimal {/cpustim/dut/rf/regout[22]}
add wave -noupdate -label X23 -radix decimal {/cpustim/dut/rf/regout[23]}
add wave -noupdate -label X24 -radix decimal {/cpustim/dut/rf/regout[24]}
add wave -noupdate -label X25 -radix decimal {/cpustim/dut/rf/regout[25]}
add wave -noupdate -label X26 -radix decimal {/cpustim/dut/rf/regout[26]}
add wave -noupdate -label X27 -radix decimal {/cpustim/dut/rf/regout[27]}
add wave -noupdate -label X28 -radix decimal {/cpustim/dut/rf/regout[28]}
add wave -noupdate -label X29 -radix decimal {/cpustim/dut/rf/regout[29]}
add wave -noupdate -label X30 -radix decimal {/cpustim/dut/rf/regout[30]}
add wave -noupdate -label X31 -radix decimal {/cpustim/dut/rf/regout[31]}
add wave -noupdate -label {mem[0]} -radix hexadecimal {/cpustim/dut/dmem/mem[0]}
add wave -noupdate -label {mem[1]} -radix hexadecimal {/cpustim/dut/dmem/mem[1]}
add wave -noupdate -label {mem[2]} -radix hexadecimal {/cpustim/dut/dmem/mem[2]}
add wave -noupdate -label {mem[3]} -radix hexadecimal {/cpustim/dut/dmem/mem[3]}
add wave -noupdate -label {mem[4]} -radix hexadecimal {/cpustim/dut/dmem/mem[4]}
add wave -noupdate -label {mem[5]} -radix hexadecimal {/cpustim/dut/dmem/mem[5]}
add wave -noupdate -label {mem[6]} -radix hexadecimal {/cpustim/dut/dmem/mem[6]}
add wave -noupdate -label {mem[7]} -radix hexadecimal {/cpustim/dut/dmem/mem[7]}
add wave -noupdate -label {mem[8]} -radix hexadecimal {/cpustim/dut/dmem/mem[8]}
add wave -noupdate -label {mem[9]} -radix hexadecimal {/cpustim/dut/dmem/mem[9]}
add wave -noupdate -label {mem[10]} -radix hexadecimal {/cpustim/dut/dmem/mem[10]}
add wave -noupdate -label {mem[11]} -radix hexadecimal {/cpustim/dut/dmem/mem[11]}
add wave -noupdate -label {mem[12]} -radix hexadecimal {/cpustim/dut/dmem/mem[12]}
add wave -noupdate -label {mem[13]} -radix hexadecimal {/cpustim/dut/dmem/mem[13]}
add wave -noupdate -label {mem[14]} -radix hexadecimal {/cpustim/dut/dmem/mem[14]}
add wave -noupdate -label {mem[15]} -radix hexadecimal {/cpustim/dut/dmem/mem[15]}
add wave -noupdate -label {mem[16]} -radix hexadecimal {/cpustim/dut/dmem/mem[16]}
add wave -noupdate -label {mem[17]} -radix hexadecimal {/cpustim/dut/dmem/mem[17]}
add wave -noupdate -label {mem[18]} -radix hexadecimal {/cpustim/dut/dmem/mem[18]}
add wave -noupdate -label {mem[19]} -radix hexadecimal {/cpustim/dut/dmem/mem[19]}
add wave -noupdate -label {mem[20]} -radix hexadecimal {/cpustim/dut/dmem/mem[20]}
add wave -noupdate -label {mem[21]} -radix hexadecimal {/cpustim/dut/dmem/mem[21]}
add wave -noupdate -label {mem[22]} -radix hexadecimal {/cpustim/dut/dmem/mem[22]}
add wave -noupdate -label {mem[23]} -radix hexadecimal {/cpustim/dut/dmem/mem[23]}
add wave -noupdate -label {mem[24]} -radix hexadecimal {/cpustim/dut/dmem/mem[24]}
add wave -noupdate -label {mem[25]} -radix hexadecimal {/cpustim/dut/dmem/mem[25]}
add wave -noupdate -label {mem[26]} -radix hexadecimal {/cpustim/dut/dmem/mem[26]}
add wave -noupdate -label {mem[27]} -radix hexadecimal {/cpustim/dut/dmem/mem[27]}
add wave -noupdate -label {mem[28]} -radix hexadecimal {/cpustim/dut/dmem/mem[28]}
add wave -noupdate -label {mem[29]} -radix hexadecimal {/cpustim/dut/dmem/mem[29]}
add wave -noupdate -label {mem[30]} -radix hexadecimal {/cpustim/dut/dmem/mem[30]}
add wave -noupdate -label {mem[31]} -radix hexadecimal {/cpustim/dut/dmem/mem[31]}
add wave -noupdate /cpustim/dut/RegWrite
add wave -noupdate /cpustim/dut/MemRead
add wave -noupdate /cpustim/dut/MemWrite
add wave -noupdate /cpustim/dut/ALUCntrl
add wave -noupdate /cpustim/dut/branch_taken
add wave -noupdate /cpustim/dut/IsBR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 220
configure wave -valuecolwidth 120
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {31004295168 ps}
