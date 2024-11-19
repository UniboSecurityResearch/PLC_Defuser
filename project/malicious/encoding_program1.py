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

    def _mk_naked_circuit_impl(self, inputs):
        input_keys = list(inputs)
        request_out = self.PLC2(inputs[input_keys[0]])
        outputs = {}
        outputs['request_out'] = request_out
        return outputs

    def PLC2(self, level):
        request_in = self.context.mk_latch("request_in", self.context.mk_boolean_type())
        open_req = self.context.mk_latch("open_req", self.context.mk_boolean_type())
        close_req = self.context.mk_latch("close_req", self.context.mk_boolean_type())
        low_2 = self.context.mk_latch("low_2", self.context.mk_int16_type())
        high_2 = self.context.mk_latch("high_2", self.context.mk_int16_type())
        self.context.set_latch_init_next(low_2, self.context.mk_number("10", self.context.mk_int16_type()), self.context.mk_number("10", self.context.mk_int16_type()))
        OUT_leq_1 = self.context.mk_leq(level, low_2, "leq1")
        self.context.set_latch_init_next(open_req, self.context.mk_false(), OUT_leq_1)
        self.context.set_latch_init_next(high_2, self.context.mk_number("30", self.context.mk_int16_type()),self.context.mk_number("30", self.context.mk_int16_type()))
        OUT_geq_2 = self.context.mk_geq(level, high_2, "geq2")
        self.context.set_latch_init_next(close_req, self.context.mk_false(), OUT_geq_2)
        close_req_not = self.context.mk_not(close_req, "close_req_not")
        or3 = self.context.mk_or(open_req, request_in, "or3")
        and4 = self.context.mk_and(or3, close_req_not, "and4")
        request_out = self.context.mk_output(and4, "request_out")
        self.context.set_latch_init_next(request_in, self.context.mk_false(), and4)

        return request_out

def mk_instance(ctx, name):
    return IEC61131Circuit(ctx, name)

