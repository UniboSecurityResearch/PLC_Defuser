import intrepyd as ip

def mc_dos(index, termination_value, ctx):
    index_net = ctx.mk_number(index, ctx.mk_int16_type())

    termination_value_net = ctx.mk_number(termination_value, ctx.mk_int16_type())

    br = ctx.mk_backward_reach()
    diff_termination = ctx.mk_neq(index_net, termination_value_net)
    br.add_target(diff_termination)
    result2 = br.reach_targets()

    if result2 == ip.engine.EngineResult.UNREACHABLE:
        print(result2)
    else:
        print(result2)

def detect_dos_logic_bombs(ctx, name_indexes_loop, di):

    count = 1
    loop_termination = ""
    index = ""
    for key, value in di.items():

        if "_" in key:
            temp = key.split('_')[1]
            if "loopTerminationValue_" + temp == key:
                loop_termination = value
                count = count + 1
            if "index_" + temp == key:
                index = value
                count = count + 1
            if count / 3 == 1:
                mc_dos(index, loop_termination, ctx)
                count = 1

    if not name_indexes_loop:
        '''
            This condition will be executed if no cycle is detected 
            or the value of the initial index (indexInit_i) is equal to the termination value
        '''
        print("EngineResult.UNREACHABLE")
