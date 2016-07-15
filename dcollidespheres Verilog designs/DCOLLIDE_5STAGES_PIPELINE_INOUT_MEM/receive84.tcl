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
# C:\altera_lite\15.1\quartus\bin64\quartus_stp -t send55.tcl
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

proc pushnp {index value} {
global device_name usb

if {$value > 4294967295} {
return "value entered exceeds 32 bits" }

set push_value [int2bits $value]
set diff [expr {32 - [string length $push_value]%32}]

if {$diff != 32} {
set push_value [format %0${diff}d$push_value 0] }

#puts $push_value
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

  proc hex2float {hex} {
        global tcl_platform
        #if {$tcl_platform(byteOrder) == "littleEndian"} { set hex [reverse4 $hex] }
        set sign [expr $hex >> 31]
        set exponent [expr ($hex >> 23) & 0xFF]
        set mantissa [expr $hex & ((1 << 23) -1)]
        set result [expr 1 + 1.0 * $mantissa / (1 << 23)]
        set result [expr {($sign ? -1.0 : 1.0)} * $result]
        if {$mantissa == 0 && $exponent == 0} {
            set result [expr $result * 0.0]
        } else {
            set result [expr $result * pow(2, $exponent - 127)]
        }
        return $result
    }

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

#puts "addressin_in"
#pop 5
puts "addressin_out"
pop 3
puts "addressout"
pop 4
#puts "data 1"
#pop 4
#pop 5
#pop 6
#pop 7
#pop 8
#pop 9
#pop 10
#pop 11
#puts "data 2"
#pop 12
#pop 13
#pop 14
#pop 15
#pop 16
#pop 17
#pop 18
#pop 19

puts "outs memory"
puts "data 0"
pushnp 0 0x00000000
pop 1
pushnp 0 0x00000001
pop 1
pushnp 0 0x00000002
pop 1
pushnp 0 0x00000003
pop 1
pushnp 0 0x00000004
pop 1
pushnp 0 0x00000005
pop 1
pushnp 0 0x00000006
pop 1
puts "data 1"
pushnp 0 0x00000007
pop 1
pushnp 0 0x00000008
pop 1
pushnp 0 0x00000009
pop 1
pushnp 0 0x0000000A
pop 1
pushnp 0 0x0000000B
pop 1
pushnp 0 0x0000000C
pop 1
pushnp 0 0x0000000D
pop 1
puts "data 2"
pushnp 0 0x0000000E
pop 1
pushnp 0 0x0000000F
pop 1
pushnp 0 0x00000010
pop 1
pushnp 0 0x00000011
pop 1
pushnp 0 0x00000012
pop 1
pushnp 0 0x00000013
pop 1
pushnp 0 0x00000014
pop 1
puts "data 3"
pushnp 0 0x00000015
pop 1
pushnp 0 0x00000016
pop 1
pushnp 0 0x00000017
pop 1
pushnp 0 0x00000018
pop 1
pushnp 0 0x00000019
pop 1
pushnp 0 0x0000001A
pop 1
pushnp 0 0x0000001B
pop 1
puts "data 4"
pushnp 0 0x0000001C
pop 1
pushnp 0 0x0000001D
pop 1
pushnp 0 0x0000001E
pop 1
pushnp 0 0x0000001F
pop 1
pushnp 0 0x00000020
pop 1
pushnp 0 0x00000021
pop 1
pushnp 0 0x00000022
pop 1
puts "data 5"
pushnp 0 0x00000023
pop 1
pushnp 0 0x00000024
pop 1
pushnp 0 0x00000025
pop 1
pushnp 0 0x00000026
pop 1
pushnp 0 0x00000027
pop 1
pushnp 0 0x00000028
pop 1
pushnp 0 0x00000029
pop 1
puts "data 6"
pushnp 0 0x0000002A
pop 1
pushnp 0 0x0000002B
pop 1
pushnp 0 0x0000002C
pop 1
pushnp 0 0x0000002D
pop 1
pushnp 0 0x0000002E
pop 1
pushnp 0 0x0000002F
pop 1
pushnp 0 0x00000030
pop 1
puts "data 7"
pushnp 0 0x00000031
pop 1
pushnp 0 0x00000032
pop 1
pushnp 0 0x00000033
pop 1
pushnp 0 0x00000034
pop 1
pushnp 0 0x00000035
pop 1
pushnp 0 0x00000036
pop 1
pushnp 0 0x00000037
pop 1
puts "data 8"
pushnp 0 0x00000038
pop 1
pushnp 0 0x00000039
pop 1
pushnp 0 0x0000003A
pop 1
pushnp 0 0x0000003B
pop 1
pushnp 0 0x0000003C
pop 1
pushnp 0 0x0000003D
pop 1
pushnp 0 0x0000003E
pop 1
puts "data 9"
pushnp 0 0x0000003F
pop 1
pushnp 0 0x00000040
pop 1
pushnp 0 0x00000041
pop 1
pushnp 0 0x00000042
pop 1
pushnp 0 0x00000043
pop 1
pushnp 0 0x00000044
pop 1
pushnp 0 0x00000045
pop 1
puts "data 10"
pushnp 0 0x00000046
pop 1
pushnp 0 0x00000047
pop 1
pushnp 0 0x00000048
pop 1
pushnp 0 0x00000049
pop 1
pushnp 0 0x0000004A
pop 1
pushnp 0 0x0000004B
pop 1
pushnp 0 0x0000004C
pop 1
puts "data 11"
pushnp 0 0x0000004D
pop 1
pushnp 0 0x0000004E
pop 1
pushnp 0 0x0000004F
pop 1
pushnp 0 0x00000050
pop 1
pushnp 0 0x00000051
pop 1
pushnp 0 0x00000052
pop 1
pushnp 0 0x00000053
pop 1

puts "outs"
pop 5
pop 6
pop 7
pop 8
pop 9
pop 10
pop 11

close $fileId
device_unlock
close_device