from intrepyd.context import Context
from encoding_program2 import mk_instance
from utils.requirements import plc1_requirements


def plc1():
    SIM_DEPTH = 2
    ctx = Context()
    enc = mk_instance(ctx, "test_tank")
    level = ctx.mk_input("level", ctx.mk_int16_type())
    request = ctx.mk_input("request", ctx.mk_int16_type())
    IN1 = ctx.mk_input("IN1", ctx.mk_boolean_type())

    trace = ctx.mk_trace()

    trace.set_value(level, 0, '10')
    trace.set_value(request, 0, '0')
    trace.set_value(IN1,0, 'T')
    trace.set_value(level, 1, '90')
    trace.set_value(request, 1, '1')
    trace.set_value(IN1, 1, 'T')
    trace.set_value(level, 2, '90')
    trace.set_value(request, 2, '1')
    trace.set_value(IN1, 2, 'T')
    pumps, valve = enc.PLC1(level, request)

    sim = ctx.mk_simulator()

    sim.simulate(trace, 2)
    trace_dataframe = trace.get_as_dataframe(ctx.net2name)
    variables = []
    name_indexes_loop = []
    '''
        le_00 -> low 
        geq2  -> high 
        eq6  -> close_req
        eq4  -> open_req
    '''

    for key, value in ctx.nets.items():
        if 'le_00' == key or 'geq2'==key or 'high_1' == key or 'low_1' == key or 'eq6' == key or 'eq4' == key or \
                'pumps_out' == key or 'pumps_in' == key or 'valve_in'== key or 'valve_out' == key or 'level' == key or 'request' == key:
                sim.add_watch(ctx.nets.get(key))
                variables.append(key)

    for key, value in ctx.nets.items():
        temp = key.split('_')[0]
        if 'index' == temp or 'loopTerminationValue' == temp or 'indexInit' == temp:
            if key[-1] not in name_indexes_loop:
                name_indexes_loop.append(key[-1])
            variables.append(key)
            sim.add_watch(ctx.nets.get(key))
    sim.simulate(trace, 2)
    di = {}
    for variable in variables:
        if variable not in trace_dataframe.columns:
            for i in range(0, SIM_DEPTH + 1):
                a = ctx.nets.get(variable)
                trace_dataframe.loc[variable, i] = trace.get_value(ctx.nets.get(variable), i)
                di[variable] = trace.get_value(ctx.nets.get(variable), i)

    print(trace_dataframe)
    plc1_requirements(ctx,name_indexes_loop,di)
