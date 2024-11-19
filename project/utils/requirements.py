from utils.detect_dos import detect_dos_logic_bombs


def plc1_requirements(ctx, name_indexes_loop, dict_variables):
    for key, value in dict_variables.items():
        if key == 'geq2':
            if value == "T":
                high = ctx.mk_true()

            else:
                high = ctx.mk_false()
        if key == 'le_00' or key == 'leq1':
            if value == "T":
                low = ctx.mk_true()
            else:
                low = ctx.mk_false()
        if key == 'eq6':
            if value == "T":
                close_req = ctx.mk_true()
            else:
                close_req = ctx.mk_false()
        if key == 'eq4':
            if value == "T":
                open_req = ctx.mk_true()
            else:
                open_req = ctx.mk_false()
        if key == 'pumps_out':
            if value == "T":
                pumps_out = ctx.mk_true()
            else:
                pumps_out = ctx.mk_false()
        if key == 'pumps_in':
            if value == "T":
                pumps_in = ctx.mk_true()
            else:
                pumps_in = ctx.mk_false()
        if key == 'valve_in':
            if value == "T":
                valve_in = ctx.mk_true()
            else:
                valve_in = ctx.mk_false()
        if key == 'valve_out':
            if value == "T":
                valve_out = ctx.mk_true()
            else:
                valve_out = ctx.mk_false()
        if key == 'high_1':
            high_1 = ctx.mk_number(value, ctx.mk_int16_type())
        if key == 'low_1':
            low_1 = ctx.mk_number(value, ctx.mk_int16_type())
        if key == 'level':
            level = ctx.mk_number(value, ctx.mk_int16_type())
        if key == 'request':
            request = ctx.mk_number(value, ctx.mk_int16_type())

    print("\nlow ↔ ¬(level ≤ low_1)")
    br = ctx.mk_backward_reach()
    first_requirement = ctx.mk_neq(low, ctx.mk_leq(level, low_1))
    br.add_target(first_requirement)
    result = br.reach_targets()
    print(result)
    print("\nhigh ↔ ¬(level ≥ high_1)")
    br = ctx.mk_backward_reach()
    second_requirement = ctx.mk_neq(high, ctx.mk_geq(level, high_1))
    br.add_target(second_requirement)
    result = br.reach_targets()
    print(result)
    print("\nopen_req ↔ ¬(request ≡ 1) ")
    br = ctx.mk_backward_reach()
    third_requirement = ctx.mk_neq(open_req, ctx.mk_eq(ctx.mk_number("1", ctx.mk_int16_type()), request))
    br.add_target(third_requirement)
    result = br.reach_targets()
    print(result)
    print("\nclose_req ↔ ¬ (request ≡ 0)  ")
    br = ctx.mk_backward_reach()
    fourth_requirement = ctx.mk_neq(close_req, ctx.mk_eq(ctx.mk_number("0", ctx.mk_int16_type()), request))
    br.add_target(fourth_requirement)
    result = br.reach_targets()
    print(result)
    print("\npumps_out ↔ ¬((low ∨ pumps_in) ∧ ¬high)")
    br = ctx.mk_backward_reach()
    fifth_requirement = ctx.mk_neq(pumps_out, ctx.mk_and(ctx.mk_or(low, pumps_in), ctx.mk_not(high)))
    br.add_target(fifth_requirement)
    result = br.reach_targets()
    print(result)
    print("\nvalve_out ↔ ¬(((¬low ∧ open_req) ∨ valve_in) ∧ ¬close_req)")
    br = ctx.mk_backward_reach()
    fifth_requirement = ctx.mk_neq(valve_out, ctx.mk_and(ctx.mk_or(ctx.mk_and(ctx.mk_not(low), open_req), valve_in),
                                                         ctx.mk_not(close_req)))
    br.add_target(fifth_requirement)
    result = br.reach_targets()
    print(result)
    print("\n TRUE ↔ ¬(index ≡ loop_termination_value)")
    detect_dos_logic_bombs(ctx, name_indexes_loop, dict_variables)


def plc2_requirements(ctx, name_indexes_loop, dict_variables):
    for key, value in dict_variables.items():
        if key == 'geq2':
            if value == "T":
                close_req = ctx.mk_true()
            else:
                close_req = ctx.mk_false()
        if key == 'leq1':
            if value == "T":
                open_req = ctx.mk_true()
            else:
                open_req = ctx.mk_false()
        if key == 'request_in':
            if value == "T":
                request_in = ctx.mk_true()
            else:
                request_in = ctx.mk_false()
        if key == 'request_out':
            if value == "T":
                request_out = ctx.mk_true()
            else:
                request_out = ctx.mk_false()
        if key == 'high_2':
            high_2 = ctx.mk_number(value, ctx.mk_int16_type())
        if key == 'low_2':
            low_2 = ctx.mk_number(value, ctx.mk_int16_type())
        if key == 'level':
            level = ctx.mk_number(value, ctx.mk_int16_type())

    print("\nopen_req ↔ ¬(level ≤ low_2)")
    br = ctx.mk_backward_reach()
    first_requirement = ctx.mk_neq(open_req, ctx.mk_leq(level, low_2))
    br.add_target(first_requirement)
    result = br.reach_targets()
    print(result)
    print("\nclose_req ↔ ¬(level ≥ high_2)")
    br = ctx.mk_backward_reach()
    second_requirement = ctx.mk_neq(close_req, ctx.mk_geq(level, high_2))
    br.add_target(second_requirement)
    result = br.reach_targets()
    print(result)
    print("\n request_out ↔ ¬((open_req ∨ request_in) ∧ ¬close_req")
    br = ctx.mk_backward_reach()
    third_requirement = ctx.mk_neq(request_out, ctx.mk_and(ctx.mk_or(open_req, request_in), ctx.mk_not(close_req)))
    br.add_target(third_requirement)
    result = br.reach_targets()
    print(result)
    print("\n TRUE ↔ ¬(index ≡ loop_termination_value)")
    detect_dos_logic_bombs(ctx, name_indexes_loop, dict_variables)


def plc3_requirements(ctx, name_indexes_loop, dict_variables):
    for key, value in dict_variables.items():
        if key == 'geq2':
            if value == "T":
                high = ctx.mk_true()

            else:
                high = ctx.mk_false()

        if key == 'leq1':
            if value == "T":
                low = ctx.mk_true()
            else:
                low = ctx.mk_false()
        if key == 'pump_in':
            if value == "T":
                pump_in = ctx.mk_true()
            else:
                pump_in = ctx.mk_false()
        if key == 'pump_out':
            if value == "T":
                pump_out = ctx.mk_true()
            else:
                pump_out = ctx.mk_false()
        if key == 'high_3':
            high_3 = ctx.mk_number(value, ctx.mk_int16_type())

        if key == 'low_3':
            low_3 = ctx.mk_number(value, ctx.mk_int16_type())
        if key == 'level':
            level = ctx.mk_number(value, ctx.mk_int16_type())

    print("\nlow ↔ ¬(level ≤ low_3)")
    br = ctx.mk_backward_reach()
    first_requirement = ctx.mk_neq(low, ctx.mk_leq(level, low_3))
    br.add_target(first_requirement)
    result = br.reach_targets()
    print(result)
    print("\nhigh ↔ ¬(level ≥ high_3)")
    br = ctx.mk_backward_reach()
    second_requirement = ctx.mk_neq(high, ctx.mk_geq(level, high_3))
    br.add_target(second_requirement)
    result = br.reach_targets()
    print(result)
    print("\n pump_out ↔ ¬((high ∨ pump_in) ∧ ¬low")
    br = ctx.mk_backward_reach()
    third_requirement = ctx.mk_neq(pump_out, ctx.mk_and(ctx.mk_or(high, pump_in), ctx.mk_not(low)))
    br.add_target(third_requirement)
    result = br.reach_targets()
    print(result)
    print("\n TRUE ↔ ¬(index ≡ loop_termination_value)")
    detect_dos_logic_bombs(ctx, name_indexes_loop, dict_variables)
