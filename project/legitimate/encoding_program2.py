# Translated from plc.xml using intrepyd.iec611312py on 2024-10-29

import intrepyd as ip
import intrepyd.circuit
class IEC61131Circuit(ip.circuit.Circuit):
    def __init__(self, ctx, name):
        ip.circuit.Circuit.__init__(self, ctx, name)
        bool_type = self.context.mk_boolean_type()
        first_tick = self.context.mk_latch("first_tick", bool_type)
        self.context.set_latch_init_next(first_tick, self.context.mk_true(), self.context.mk_false())

    def _mk_inputs(self):
        level = self.context.mk_input('level', self.context.mk_int16_type())
        self.inputs['level'] = level
        request = self.context.mk_input('request', self.context.mk_int16_type())
        self.inputs['request'] = request

    def _mk_naked_circuit_impl(self, inputs):
        input_keys = list(inputs)
        pumps_out, valve_out = self.PLC1(inputs[input_keys[0]], inputs[input_keys[1]])
        outputs = {}
        outputs['pumps_out'] = pumps_out
        outputs['valve_out'] = valve_out
        return outputs

    def PLC1(self, level, request):
        pumps_in = self.context.mk_latch("pumps_in",self.context.mk_boolean_type())
        valve_in = self.context.mk_latch("valve_in",self.context.mk_boolean_type())
        low = self.context.mk_latch("low",self.context.mk_boolean_type())
        high = self.context.mk_latch("high",self.context.mk_boolean_type())
        open_req = self.context.mk_latch("open_req",self.context.mk_boolean_type())
        close_req = self.context.mk_latch("close_req",self.context.mk_boolean_type())
        low_1 = self.context.mk_latch("low_1",self.context.mk_int16_type())
        high_1 = self.context.mk_latch("high_1",self.context.mk_int16_type())
        self.context.set_latch_init_next(low_1,self.context.mk_number("20", self.context.mk_int16_type()),self.context.mk_number("20", self.context.mk_int16_type()))
        OUT_leq_1 = self.context.mk_leq(level,low_1,"leq1")
        self.context.set_latch_init_next(low, self.context.mk_false(), OUT_leq_1)
        self.context.set_latch_init_next(high_1,self.context.mk_number("80", self.context.mk_int16_type()),self.context.mk_number("80", self.context.mk_int16_type()))
        OUT_geq_2 = self.context.mk_geq(level,high_1,"geq2")
        self.context.set_latch_init_next(high, self.context.mk_false(), OUT_geq_2)
        constant3 = self.context.mk_number("1", self.context.mk_int16_type())
        OUT_eq_4 = self.context.mk_eq(request,constant3,"eq4")
        self.context.set_latch_init_next(open_req, self.context.mk_false(), OUT_eq_4)
        constant5 = self.context.mk_number("0", self.context.mk_int16_type())
        OUT_eq_6 = self.context.mk_eq(request,constant5,"eq6")
        self.context.set_latch_init_next(close_req, self.context.mk_false(), OUT_eq_6)
        high_not = self.context.mk_not(high,"high_not")
        or7 = self.context.mk_or(low, pumps_in, "or7")
        and8 = self.context.mk_and(or7, high_not, "and8")
        pumps_out = self.context.mk_output(and8, "pumps_out")
        self.context.set_latch_init_next(pumps_in, self.context.mk_false(), and8)
        low_not = self.context.mk_not(low, "high_not")
        and9 = self.context.mk_and(low_not, open_req)
        or10 = self.context.mk_or(and9, valve_in, "or10")
        close_req_not = self.context.mk_not(close_req,"close_req")
        and11 = self.context.mk_and(or10, close_req_not, "and11")
        valve_out = self.context.mk_output(and11, "valve_out")
        self.context.set_latch_init_next(valve_in, self.context.mk_false(), and11)

        return pumps_out, valve_out

def mk_instance(ctx, name):
    return IEC61131Circuit(ctx, name)

