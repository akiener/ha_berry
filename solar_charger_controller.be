import string

def create_state_update_command(state, ac_charge_current_ampere)
    var output = "PSET" + state

    if (0 <= ac_charge_current_ampere && ac_charge_current_ampere <= 60)
        #- Format:
         - PSET BCDEFG HH.H II.I JJ.J KK.K LLL MMM NNNN OO PP QQ KK SS  TUV WW.W <CHK><cr>
         -#
        var output_split = string.split(output, 35 #-MMM ...-#)
        var mmm_rest = string.split(output_split[1], 3 #-MMM-#)
        var previous_mmm = number(mmm_rest[0])
        # print("previous setting [AC Chg curr]:", previous_mmm, "A")
        # print("     new setting [AC Chg curr]:", ac_charge_current_ampere, "A")
        var new_mmm = string.format("%03d", int(ac_charge_current_ampere))
        output = output_split[0] + new_mmm + mmm_rest[1]
    else
        print("ERROR: ac_charge_current_ampere:", ac_charge_current_ampere, "out of range [0,60]")
    end

    return output
end

def calculate_checksum(command)
    var chksum = 1
    for i: 0..(size(command) - 1)
        var char = command[i]
        # print("char:", char)
        # print("byte:", string.byte(char))
        chksum += string.byte(char)
    end

    return string.hex(chksum)
end

def calculate_target_ampere(electricity_meter_v, sum_inverter_v)
    # TODO implement
    return 44
end

var state = "001103 56.0 54.0 44.0 42.0 060 030 0000 00 00 00 00 00001 52.0"
var target_a = calculate_target_ampere(123)
var command = create_state_update_command(state, target_a)
print("previous state:    ", state)
print("     new state:", command)

var chksum = calculate_checksum(command)
print("checksum:", chksum)

print(bytes().fromstring("PQSE") + bytes(calculate_checksum("PQSE")) + bytes().fromstring("\n"))
