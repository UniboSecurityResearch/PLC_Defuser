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
        pump_out = self.PLC3(inputs[input_keys[0]])
        outputs = {}
        outputs['pump_out'] = pump_out
        return outputs

    def PLC3(self, level):
        pump_in = self.context.mk_latch("pump_in", self.context.mk_boolean_type())
        low = self.context.mk_latch("low", self.context.mk_boolean_type())
        high = self.context.mk_latch("high", self.context.mk_boolean_type())
        low_3 = self.context.mk_latch("low_3", self.context.mk_int16_type())
        high_3 = self.context.mk_latch("high_3", self.context.mk_int16_type())
        self.context.set_latch_init_next(low_3, self.context.mk_number("5", self.context.mk_int16_type()), self.context.mk_number("5", self.context.mk_int16_type()))
        OUT_leq_1 = self.context.mk_leq(level, low_3, "leq1")
        self.context.set_latch_init_next(low, self.context.mk_false(), OUT_leq_1)
        self.context.set_latch_init_next(high_3, self.context.mk_number("15", self.context.mk_int16_type()),self.context.mk_number("15", self.context.mk_int16_type()))
        OUT_geq_2 = self.context.mk_geq(level, high_3, "geq2")
        self.context.set_latch_init_next(high, self.context.mk_false(), OUT_geq_2)
        low_not = self.context.mk_not(low, "low")
        or3 = self.context.mk_or(high, pump_in, "or3")
        and4 = self.context.mk_and(or3, low_not, "and4")
        pump_out = self.context.mk_output(and4, "pump_out")
        self.context.set_latch_init_next(pump_in, self.context.mk_false(), and4)

        return pump_out


def mk_instance(ctx, name):
    return IEC61131Circuit(ctx, name)

