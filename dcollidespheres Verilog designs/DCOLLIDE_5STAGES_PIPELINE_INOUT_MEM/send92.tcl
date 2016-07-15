set usb [lindex [get_hardware_names] 0]
set device_name [lindex [get_device_names -hardware_name $usb] 0]
puts "*************************"
puts "programming cable:"
puts $usb
set filename "outputs.txt"
set fileId [open $filename "a+"]


set filename "outputs.txt"
# open the filename for writing
set fileId [open $filename "w"]
# C:\altera_lite\16.0\quartus\bin64\quartus_stp -t send55.tcl
#IR scan codes:  001 -> push
#                010 -> pop

proc push {index value} {
global device_name usb

if {$value > 4294967295} {
return "value entered exceeds 32 bits" }

set push_value [int2bits $value]
set diff [expr {32 - [string length $push_value]%32}]

if {$diff != 32} {
set push_value [format %0${diff}d$push_value 0] }

puts $push_value
device_virtual_ir_shift -instance_index $index -ir_value 1 -no_captured_ir_value
device_virtual_dr_shift -instance_index $index -dr_value $push_value -length 32 -no_captured_dr_value
}

proc pop {index} {
	global device_name usb filename fileId
	variable x
	variable y
	
	device_virtual_ir_shift -instance_index $index -ir_value 2 -no_captured_ir_value
	set x [device_virtual_dr_shift -instance_index 0 -length 32]
	puts $x
	#puts $fileId $x
	

}

proc popfile {index} {
	global device_name usb filename fileId
	variable x
	variable y
	
	device_virtual_ir_shift -instance_index $index -ir_value 2 -no_captured_ir_value
	set x [device_virtual_dr_shift -instance_index 0 -length 32]
	puts $x
	
	set xy [bin2dec $x]
	puts $fileId $x

}

proc int2bits {i} {    
set res ""
while {$i>0} {
set res [expr {$i%2}]$res
set i [expr {$i/2}]}
if {$res==""} {set res 0}
return $res
}

proc bin2dec bin {
    #returns integer equivalent of $bin 
    set res 0
    if {$bin == 0} {
        return 0
    } elseif {[string match -* $bin]} {
        set sign -
        set bin [string range $bin[set bin {}] 1 end]
    } else {
        set sign {}
    }
    foreach i [split $bin {}] {
        set res [expr {$res*2+$i}]
    }
    return $sign$res
}

 # proc hex2float {hex} {
 #       global tcl_platform
 #       #if {$tcl_platform(byteOrder) == "littleEndian"} { set hex [reverse4 $hex] }
 #       set sign [expr $hex >> 31]
 #       set exponent [expr ($hex >> 23) & 0xFF]
 #       set mantissa [expr $hex & ((1 << 23) -1)]
 #       set result [expr 1 + 1.0 * $mantissa / (1 << 23)]
 #       set result [expr {($sign ? -1.0 : 1.0)} * $result]
 #       if {$mantissa == 0 && $exponent == 0} {
 #           set result [expr $result * 0.0]
 #       } else {
 #           set result [expr $result * pow(2, $exponent - 127)]
 #       }
 #       return $result
 #   }

 proc IEEE2float {data byteorder} {
    if {$byteorder == 0} {
        set code [binary scan $data cccc se1 e2f1 f2 f3]
    } else {
        set code [binary scan $data cccc f3 f2 e2f1 se1]
    }
    
    set se1  [expr {($se1 + 0x100) % 0x100}]
    set e2f1 [expr {($e2f1 + 0x100) % 0x100}]
    set f2   [expr {($f2 + 0x100) % 0x100}]
    set f3   [expr {($f3 + 0x100) % 0x100}]
    
    set sign [expr {$se1 >> 7}]
    set exponent [expr {(($se1 & 0x7f) << 1 | ($e2f1 >> 7))}]
    set f1 [expr {$e2f1 & 0x7f}]
    
    set fraction [expr {double($f1)*0.0078125 + \
            double($f2)*3.0517578125e-05 + \
            double($f3)*1.19209289550781e-07}]
    
    set res [expr {($sign ? -1. : 1.) * \
            pow(2.,double($exponent-127)) * \
            (1. + $fraction)}]
    return $res
 } 
 

proc bin2hex bin {
## No sanity checking is done
array set t {
0000 0 0001 1 0010 2 0011 3 0100 4
0101 5 0110 6 0111 7 1000 8 1001 9
1010 a 1011 b 1100 c 1101 d 1110 e 1111 f
}
set diff [expr {4-[string length $bin]%4}]
if {$diff != 4} {
set bin [format %0${diff}d$bin 0] }
regsub -all .... $bin {$t(&)} hex
return [subst $hex]
}

puts "Read floating point add result"
open_device -device_name $device_name -hardware_name $usb
device_lock -timeout 10000
push 2 0x3eb00347
push 2 0xbeb00347
push 2 0x40800000
push 2 0x3f000000
push 2 0x3fa7fe65
push 2 0x3e800000
push 2 0x40800000
push 2 0x3f000000
push 2 0x3eb9ca7d
push 2 0xbeb9ca7d
push 2 0x40800000
push 2 0x3f000000
push 2 0x3fa31ac1
push 2 0x3e800000
push 2 0x40800000
push 2 0x3f000000
push 2 0x3ec391d5
push 2 0xbec391d5
push 2 0x40800000
push 2 0x3f000000
push 2 0x3f9e371e
push 2 0x3e800000
push 2 0x40800000
push 2 0x3f000000
push 2 0x3ecd590c
push 2 0xbecd590c
push 2 0x40800000
push 2 0x3f000000
push 2 0x3f99537a
push 2 0x3e800000
push 2 0x40800000
push 2 0x3f000000
push 2 0x3ed72064
push 2 0xbed72064
push 2 0x40800000
push 2 0x3f000000
push 2 0x3f946fce
push 2 0x3e800000
push 2 0x40800000
push 2 0x3f000000
push 2 0x3ed35bb4
push 2 0xbee7f8ec
push 2 0x40800000
push 2 0x3f000000
push 2 0x3f92ef24
push 2 0x3e871130
push 2 0x40800000
push 2 0x3f000000
push 2 0x3ecf9724
push 2 0xbef8d174
push 2 0x40800000
push 2 0x3f000000
push 2 0x3f916e7a
push 2 0x3e8e2260
push 2 0x40800000
push 2 0x3f000000
push 2 0x3ecbd274
push 2 0xbf04d4ed
push 2 0x40800000
push 2 0x3f000000
push 2 0x3f8fedd0
push 2 0x3e9533b1
push 2 0x40800000
push 2 0x3f000000
push 2 0x3ec80dc3
push 2 0xbf0d4131
push 2 0x40800000
push 2 0x3f000000
push 2 0x3f8e6d26
push 2 0x3e9c44e1
push 2 0x40800000
push 2 0x3f000000
push 2 0x3ec44934
push 2 0xbf15ad75
push 2 0x40800000
push 2 0x3f000000
push 2 0x3f8cec7d
push 2 0x3ea35611
push 2 0x40800000
push 2 0x3f000000
push 2 0x3ec08484
push 2 0xbf1e19b9
push 2 0x40800000
push 2 0x3f000000
push 2 0x3f8b6bd3
push 2 0x3eaa6741
push 2 0x40800000
push 2 0x3f000000
push 2 0x3ebcbff4
push 2 0xbf2685fd
push 2 0x40800000
push 2 0x3f000000
push 2 0x3f89eb29
push 2 0x3eb17870
push 2 0x40800000
push 2 0x3f000000





close $fileId
device_unlock
close_device