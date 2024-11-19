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
    def LE_0(self, IN1, IN2):
        OUT = self.context.mk_false()
        loopTerminationValue_i = self.context.mk_number("4", self.context.mk_int16_type(), 'loopTerminationValue_i')
        indexInit_i = self.context.mk_number("0", self.context.mk_int16_type(), 'indexInit_i')
        index_i = self.context.mk_number("0", self.context.mk_int16_type(), 'index_i')
        __tmp_1 = self.context.mk_leq(IN1, IN2)
        __tmp_2 = self.context.mk_ite(__tmp_1, self.context.mk_true(), OUT)
        OUT_1 = __tmp_2
        __tmp_3 = self.context.mk_eq(IN1, self.context.mk_number("75", self.context.mk_int16_type()))
        __tmp_4 = self.context.mk_lt(index_i, self.context.mk_number("4", self.context.mk_int16_type()))
        __tmp_5 = self.context.mk_ite(__tmp_4, self.context.mk_true(), OUT_1)
        OUT_2 = __tmp_5
        __tmp_6 = self.context.mk_lt(index_i, self.context.mk_number("4", self.context.mk_int16_type()))
        __tmp_7 = self.context.mk_ite(__tmp_4, self.context.mk_true(), OUT_2)
        OUT_3 = __tmp_7
        __tmp_8 = self.context.mk_lt(index_i, self.context.mk_number("4", self.context.mk_int16_type()))
        __tmp_9 = self.context.mk_ite(__tmp_4, self.context.mk_true(), OUT_3)
        OUT_4 = __tmp_8
        __tmp_10 = self.context.mk_lt(index_i, self.context.mk_number("4", self.context.mk_int16_type()))
        __tmp_11 = self.context.mk_ite(__tmp_10, self.context.mk_true(), OUT_4)
        __tmp_12 = self.context.mk_ite(__tmp_3, __tmp_11, OUT_1)
        OUT = __tmp_12
        return OUT
    def PLC1(self, level, request):
        pumps_in = self.context.mk_latch("pumps_in", self.context.mk_boolean_type())
        valve_in = self.context.mk_latch("valve_in", self.context.mk_boolean_type())
        low = self.context.mk_latch("low", self.context.mk_boolean_type())
        high = self.context.mk_latch("high", self.context.mk_boolean_type())
        open_req = self.context.mk_latch("open_req", self.context.mk_boolean_type())
        close_req = self.context.mk_latch("close_req", self.context.mk_boolean_type())
        low_1 = self.context.mk_latch("low_1", self.context.mk_int16_type())
        high_1 = self.context.mk_latch("high_1", self.context.mk_int16_type())
        self.context.set_latch_init_next(low_1, self.context.mk_number("20", self.context.mk_int16_type()),self.context.mk_number("20", self.context.mk_int16_type()))
        OUT_LE_0_0 = self.LE_0(level, low_1)
        le_temp = self.context.mk_output(OUT_LE_0_0, "le_00")
        self.context.set_latch_init_next(low, self.context.mk_false(), OUT_LE_0_0)
        self.context.set_latch_init_next(high_1, self.context.mk_number("80", self.context.mk_int16_type()), self.context.mk_number("80", self.context.mk_int16_type()))
        OUT_geq_2 = self.context.mk_geq(level, high_1, "geq2")
        self.context.set_latch_init_next(high, self.context.mk_false(), OUT_geq_2)
        constant3 = self.context.mk_number("1", self.context.mk_int16_type())
        OUT_eq_4 = self.context.mk_eq(request, constant3, "eq4")
        self.context.set_latch_init_next(open_req, self.context.mk_false(), OUT_eq_4)
        constant5 = self.context.mk_number("0", self.context.mk_int16_type())
        OUT_eq_6 = self.context.mk_eq(request, constant5, "eq6")
        self.context.set_latch_init_next(close_req, self.context.mk_false(), OUT_eq_6)
        high_not = self.context.mk_not(high, "high_not")
        or7 = self.context.mk_or(low, pumps_in, "or7")
        and8 = self.context.mk_and(or7, high_not, "and8")
        pumps_out = self.context.mk_output(and8, "pumps_out")
        self.context.set_latch_init_next(pumps_in, self.context.mk_false(), and8)
        low_not = self.context.mk_not(low, "high_not")
        and9 = self.context.mk_and(low_not, open_req)
        or10 = self.context.mk_or(and9, valve_in, "or10")
        close_req_not = self.context.mk_not(close_req, "close_req")
        and11 = self.context.mk_and(or10, close_req_not, "and11")
        valve_out = self.context.mk_output(and11, "valve_out")
        self.context.set_latch_init_next(valve_in, self.context.mk_false(), and11)

        return pumps_out, valve_out

def mk_instance(ctx, name):
    return IEC61131Circuit(ctx, name)

