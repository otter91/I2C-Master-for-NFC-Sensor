onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /e/uut/val_send
add wave -noupdate -format Literal /e/uut/val_rec
add wave -noupdate -format Logic /e/uut/clk
add wave -noupdate -format Logic /e/uut/rst
add wave -noupdate -format Logic /e/uut/load_val
add wave -noupdate -format Logic /e/uut/load_add
add wave -noupdate -format Logic /e/uut/read_val
add wave -noupdate -format Literal /e/uut/shift_mode
add wave -noupdate -format Logic /e/uut/bit_cnt2_ena
add wave -noupdate -format Logic /e/uut/bit_cnt16_ena
add wave -noupdate -format Literal /e/uut/sda_mode
add wave -noupdate -format Literal /e/uut/scl_mode
add wave -noupdate -format Logic /e/uut/sda_ena
add wave -noupdate -format Logic /e/uut/scl_ena
add wave -noupdate -format Logic /e/uut/data_bit1_s
add wave -noupdate -format Logic /e/uut/data_bit2_s
add wave -noupdate -format Logic /e/uut/sda_pre_s
add wave -noupdate -format Logic /e/uut/scl_pre_s
add wave -noupdate -format Logic /e/uut/sda
add wave -noupdate -format Logic /e/uut/scl
add wave -noupdate -format Logic /e/uut/ack
add wave -noupdate -format Logic /e/uut/rw
add wave -noupdate -format Logic /e/uut/cout2
add wave -noupdate -format Logic /e/uut/cout16
add wave -noupdate -format Literal /e/uut/add_shift_s
add wave -noupdate -format Literal /e/uut/in_shift_s
add wave -noupdate -format Literal /e/uut/out_shift_s
add wave -noupdate -format Literal /e/uut/temp
add wave -noupdate -format Literal /e/uut/bit2_s
add wave -noupdate -format Literal /e/uut/bit16_s
add wave -noupdate -format Logic /e/uut/bit2_cnt_s
add wave -noupdate -format Literal /e/uut/bit16_cnt_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {148430 ps} 0}
configure wave -namecolwidth 165
configure wave -valuecolwidth 85
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {21608 ps} {209390 ps}
