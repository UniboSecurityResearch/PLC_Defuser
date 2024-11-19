from intrepyd.context import Context
from encoding_program1 import mk_instance
from utils.requirements import plc2_requirements


def plc2():
    SIM_DEPTH = 2
    ctx = Context()
    enc = mk_instance(ctx, "test_tank")
    level = ctx.mk_input("level", ctx.mk_int16_type())
    # request = ctx.mk_input("request", ctx.mk_int16_type())

    trace = ctx.mk_trace()
    trace.set_value(level, 0, '30')
    trace.set_value(level, 1, '40')
    trace.set_value(level, 2, '60')

    request = enc.PLC2(level)
    sim = ctx.mk_simulator()
    sim.simulate(trace, 2)
    trace_dataframe = trace.get_as_dataframe(ctx.net2name)
    '''
        leq1 -> open_req
        geq2 -> close_req 
     '''
    variables = []
    name_indexes_loop = []
    for key, value in ctx.nets.items():

        if 'level' == key or 'request_in' == key or 'low_2' or 'high_2' == key or 'leq1' == key or 'geq2' == key or 'request_out' == key:
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
    plc2_requirements(ctx, name_indexes_loop, di)
