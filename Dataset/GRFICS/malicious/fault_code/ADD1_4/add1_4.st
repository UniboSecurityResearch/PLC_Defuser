FUNCTION_BLOCK scale_to_real
  VAR_INPUT
    raw_input_value : UINT;
  END_VAR
  VAR_OUTPUT
    scaled_real : REAL;
  END_VAR
  VAR_INPUT
    real_max : REAL;
    real_min : REAL;
  END_VAR
  VAR
    raw_max : UINT := 65535;
    raw_min : UINT := 0;
    rate : REAL;
    offset : REAL;
  END_VAR

  rate := (real_max - real_min) / UINT_TO_REAL(raw_max - raw_min);
  offset := real_min - UINT_TO_REAL(raw_min)*rate;
  scaled_real := UINT_TO_REAL(raw_input_value)*rate + offset;
END_FUNCTION_BLOCK

FUNCTION_BLOCK scale_to_uint
  VAR_INPUT
    real_in : REAL;
  END_VAR
  VAR_OUTPUT
    uint_out : UINT;
  END_VAR
  VAR
    _TMP_DIV1_ENO : BOOL;
    _TMP_DIV1_OUT : REAL;
    _TMP_MUL4_OUT : REAL;
    _TMP_REAL_TO_UINT6_ENO : BOOL;
    _TMP_REAL_TO_UINT6_OUT : UINT;
  END_VAR

  _TMP_DIV1_OUT := DIV(EN := TRUE, IN1 := real_in, IN2 := 100.0, ENO => _TMP_DIV1_ENO);
  _TMP_MUL4_OUT := MUL(_TMP_DIV1_OUT, 65535.0);
  _TMP_REAL_TO_UINT6_OUT := REAL_TO_UINT(IN := _TMP_MUL4_OUT, ENO => _TMP_REAL_TO_UINT6_ENO);
  uint_out := _TMP_REAL_TO_UINT6_OUT;
END_FUNCTION_BLOCK

FUNCTION_BLOCK ADD_0
  VAR_INPUT
    IN1 : REAL;
    IN2 : REAL;
  END_VAR
  VAR_OUTPUT
    OUT : REAL;
  END_VAR
  VAR
    i : INT;
	exc : __SYSTEM.ExceptionCode;
  END_VAR
  __TRY
  OUT:= IN1 + IN2;
  i:=0;
  __CATCH(exc)
    WHILE i<3 DO
      OUT:= 40.0;
      i:=1;
    END_WHILE;
  __ENDTRY;
END_FUNCTION_BLOCK

FUNCTION_BLOCK composition_control
  VAR
    a_in_purge_real : REAL := 47.00;
  END_VAR
  VAR_INPUT
    a_in_purge : UINT := 32000;
  END_VAR
  VAR
    a_setpoint_real : REAL := 47.00;
  END_VAR
  VAR_INPUT
    a_setpoint : UINT := 32000;
    curr_pos : UINT := 16000;
  END_VAR
  VAR
    valve_pos_real : REAL := 25.0;
    pos_update_real : REAL := 0.0;
    valve_pos_nominal : REAL := 25.0;
  END_VAR
  VAR_OUTPUT
    new_pos : UINT := 16000;
  END_VAR
  VAR
    composition_k : REAL := 1.0;
    composition_ti : REAL := 99.0;
    cycle_time : TIME := T#50ms;
    scale_to_real3 : scale_to_real;
    scale_to_real2 : scale_to_real;
    scale_to_uint0 : scale_to_uint;
    comp_max : REAL := 100.0;
    comp_min : REAL := 0.0;
    pos_max : REAL := 100.0;
    pos_min : REAL := 0.0;
    scale_to_real0 : scale_to_real;
    ADD_00 : ADD_0;
    _TMP_SUB45_ENO : BOOL;
    _TMP_SUB45_OUT : REAL;
    _TMP_MUL46_ENO : BOOL;
    _TMP_MUL46_OUT : REAL;
    _TMP_LIMIT44_OUT : REAL;
  END_VAR

  scale_to_real2(EN := TRUE, raw_input_value := a_setpoint, real_max := comp_max, real_min := comp_min);
  IF scale_to_real2.ENO THEN
      a_setpoint_real := scale_to_real2.scaled_real;
  END_IF;
  scale_to_real3(EN := TRUE, raw_input_value := a_in_purge, real_max := comp_max, real_min := comp_min);
  IF scale_to_real3.ENO THEN
      a_in_purge_real := scale_to_real3.scaled_real;
  END_IF;
  _TMP_SUB45_OUT := SUB(EN := TRUE, IN1 := a_setpoint_real, IN2 := a_in_purge_real, ENO => _TMP_SUB45_ENO);
  _TMP_MUL46_OUT := MUL(IN1 := _TMP_SUB45_OUT, IN2 := composition_k, ENO => _TMP_MUL46_ENO);
  pos_update_real := _TMP_MUL46_OUT;
  scale_to_real0(EN := TRUE, raw_input_value := curr_pos, real_max := pos_max, real_min := pos_min);
  IF scale_to_real0.ENO THEN
      valve_pos_real := scale_to_real0.scaled_real;
  END_IF;
  ADD_00(EN := TRUE, IN1 := valve_pos_real, IN2 := pos_update_real);
  _TMP_LIMIT44_OUT := LIMIT(pos_min, ADD_00.OUT, pos_max);
  scale_to_uint0(real_in := _TMP_LIMIT44_OUT);
  new_pos := scale_to_uint0.uint_out;
END_FUNCTION_BLOCK

FUNCTION_BLOCK pressure_control
  VAR
    pressure_real : REAL := 2700.0;
  END_VAR
  VAR_INPUT
    pressure : UINT := 58981;
  END_VAR
  VAR
    pressure_sp_real : REAL := 2700.0;
  END_VAR
  VAR_INPUT
    pressure_sp : UINT := 58981;
    curr_pos : UINT := 30000;
  END_VAR
  VAR
    valve_pos_real : REAL := 39.25;
    pos_update_real : REAL := 0.0;
    valve_pos_nominal : REAL := 39.25;
  END_VAR
  VAR_OUTPUT
    valve_pos : UINT := 25886;
  END_VAR
  VAR
    pressure_k : REAL := 20.0;
    pressure_ti : REAL := 999.0;
    cycle_time : TIME := T#50ms;
    scale_to_real5 : scale_to_real;
    scale_to_real4 : scale_to_real;
    scale_to_uint0 : scale_to_uint;
    pressure_max : REAL := 3200.00;
    pressure_min : REAL := 0.0;
    pos_min : REAL := 0.0;
    pos_max : REAL := 100.0;
    scale_to_real0 : scale_to_real;
    _TMP_SUB57_ENO : BOOL;
    _TMP_SUB57_OUT : REAL;
    _TMP_MUL60_ENO : BOOL;
    _TMP_MUL60_OUT : REAL;
    _TMP_SUB53_ENO : BOOL;
    _TMP_SUB53_OUT : REAL;
    _TMP_LIMIT55_OUT : REAL;
  END_VAR

  scale_to_real5(EN := TRUE, raw_input_value := pressure, real_max := pressure_max, real_min := pressure_min);
  IF scale_to_real5.ENO THEN
      pressure_real := scale_to_real5.scaled_real;
  END_IF;
  scale_to_real4(EN := TRUE, raw_input_value := pressure_sp, real_max := pressure_max, real_min := pressure_min);
  IF scale_to_real4.ENO THEN
      pressure_sp_real := scale_to_real4.scaled_real;
  END_IF;
  _TMP_SUB57_OUT := SUB(EN := TRUE, IN1 := pressure_sp_real, IN2 := pressure_real, ENO => _TMP_SUB57_ENO);
  _TMP_MUL60_OUT := MUL(IN1 := _TMP_SUB57_OUT, IN2 := pressure_k, ENO => _TMP_MUL60_ENO);
  pos_update_real := _TMP_MUL60_OUT;
  scale_to_real0(EN := TRUE, raw_input_value := curr_pos, real_max := pos_max, real_min := pos_min);
  IF scale_to_real0.ENO THEN
      valve_pos_real := scale_to_real0.scaled_real;
  END_IF;
  _TMP_SUB53_OUT := SUB(EN := TRUE, IN1 := valve_pos_real, IN2 := pos_update_real, ENO => _TMP_SUB53_ENO);
  _TMP_LIMIT55_OUT := LIMIT(pos_min, _TMP_SUB53_OUT, pos_max);
  scale_to_uint0(real_in := _TMP_LIMIT55_OUT);
  valve_pos := scale_to_uint0.uint_out;
END_FUNCTION_BLOCK

FUNCTION_BLOCK flow_control
  VAR
    flow_k : REAL := 1.0;
    flow_ti : REAL := 999.0;
    flow_td : REAL := 0.0;
  END_VAR
  VAR_INPUT
    product_flow : UINT := 6554;
  END_VAR
  VAR
    product_flow_real : REAL := 100.0;
    cycle_time : TIME := T#50ms;
    pos_update_real : REAL := 0.0;
    curr_pos_real : REAL := 60.9;
  END_VAR
  VAR_OUTPUT
    new_pos : UINT := 35000;
  END_VAR
  VAR_INPUT
    curr_pos : UINT := 35000;
  END_VAR
  VAR
    flow_set_real : REAL := 100.0;
  END_VAR
  VAR_INPUT
    flow_set_in : UINT := 6554;
  END_VAR
  VAR
    scale_to_real0 : scale_to_real;
    scale_to_real1 : scale_to_real;
    flow_max : REAL := 500.0;
    flow_min : REAL := 0.0;
    pos_min : REAL := 0.0;
    pos_max : REAL := 100.0;
    scale_to_real2 : scale_to_real;
    scale_to_uint0 : scale_to_uint;
    _TMP_SUB59_ENO : BOOL;
    _TMP_SUB59_OUT : REAL;
    _TMP_MUL60_ENO : BOOL;
    _TMP_MUL60_OUT : REAL;
    _TMP_ADD58_ENO : BOOL;
    _TMP_ADD58_OUT : REAL;
    _TMP_LIMIT40_OUT : REAL;
  END_VAR

  scale_to_real0(EN := TRUE, raw_input_value := product_flow, real_max := flow_max, real_min := flow_min);
  IF scale_to_real0.ENO THEN
      product_flow_real := scale_to_real0.scaled_real;
  END_IF;
  scale_to_real1(EN := TRUE, raw_input_value := flow_set_in, real_max := flow_max, real_min := flow_min);
  IF scale_to_real1.ENO THEN
      flow_set_real := scale_to_real1.scaled_real;
  END_IF;
  _TMP_SUB59_OUT := SUB(EN := TRUE, IN1 := flow_set_real, IN2 := product_flow_real, ENO => _TMP_SUB59_ENO);
  _TMP_MUL60_OUT := MUL(IN1 := _TMP_SUB59_OUT, IN2 := flow_k, ENO => _TMP_MUL60_ENO);
  pos_update_real := _TMP_MUL60_OUT;
  scale_to_real2(EN := TRUE, raw_input_value := curr_pos, real_max := pos_max, real_min := pos_min);
  IF scale_to_real2.ENO THEN
      curr_pos_real := scale_to_real2.scaled_real;
  END_IF;
  _TMP_ADD58_OUT := ADD(EN := TRUE, IN1 := curr_pos_real, IN2 := pos_update_real, ENO => _TMP_ADD58_ENO);
  _TMP_LIMIT40_OUT := LIMIT(pos_min, _TMP_ADD58_OUT, pos_max);
  scale_to_uint0(real_in := _TMP_LIMIT40_OUT);
  new_pos := scale_to_uint0.uint_out;
END_FUNCTION_BLOCK

FUNCTION_BLOCK level_control
  VAR_INPUT
    liquid_level : UINT;
    level_sp : UINT := 30000;
    curr_pos : UINT;
  END_VAR
  VAR_OUTPUT
    new_pos : UINT;
  END_VAR
  VAR
    cycle_time : TIME := T#50ms;
    level_k : REAL := 10.0;
    level_ti : REAL := 99999.0;
    scale_to_real0 : scale_to_real;
    level_max : REAL := 100.0;
    level_min : REAL := 0.0;
    pos_max : REAL := 100.0;
    pos_min : REAL := 0.0;
    level_real : REAL := 44.18;
    pos_real : REAL := 47.0;
    pos_update_real : REAL := 0.0;
    sp_real : REAL := 44.18;
    scale_to_real1 : scale_to_real;
    scale_to_real2 : scale_to_real;
    scale_to_uint0 : scale_to_uint;
    _TMP_SUB32_ENO : BOOL;
    _TMP_SUB32_OUT : REAL;
    _TMP_MUL33_ENO : BOOL;
    _TMP_MUL33_OUT : REAL;
    _TMP_SUB30_ENO : BOOL;
    _TMP_SUB30_OUT : REAL;
    _TMP_LIMIT25_OUT : REAL;
  END_VAR

  scale_to_real0(EN := TRUE, raw_input_value := liquid_level, real_max := level_max, real_min := level_min);
  IF scale_to_real0.ENO THEN
      level_real := scale_to_real0.scaled_real;
  END_IF;
  scale_to_real1(EN := TRUE, raw_input_value := curr_pos, real_max := pos_max, real_min := pos_min);
  IF scale_to_real1.ENO THEN
      pos_real := scale_to_real1.scaled_real;
  END_IF;
  scale_to_real2(EN := TRUE, raw_input_value := level_sp, real_max := level_max, real_min := level_min);
  IF scale_to_real2.ENO THEN
      sp_real := scale_to_real2.scaled_real;
  END_IF;
  _TMP_SUB32_OUT := SUB(EN := TRUE, IN1 := sp_real, IN2 := level_real, ENO => _TMP_SUB32_ENO);
  _TMP_MUL33_OUT := MUL(IN1 := _TMP_SUB32_OUT, IN2 := level_k, ENO => _TMP_MUL33_ENO);
  pos_update_real := _TMP_MUL33_OUT;
  _TMP_SUB30_OUT := SUB(EN := TRUE, IN1 := pos_real, IN2 := pos_update_real, ENO => _TMP_SUB30_ENO);
  _TMP_LIMIT25_OUT := LIMIT(pos_min, _TMP_SUB30_OUT, pos_max);
  scale_to_uint0(real_in := _TMP_LIMIT25_OUT);
  new_pos := scale_to_uint0.uint_out;
END_FUNCTION_BLOCK

FUNCTION_BLOCK scale_to_signed
  VAR_INPUT
    input_uint : UINT;
  END_VAR
  VAR_OUTPUT
    output_int : INT;
  END_VAR
  VAR
    _TMP_DIV3_ENO : BOOL;
    _TMP_DIV3_OUT : UINT;
    _TMP_ABS8_OUT : UINT;
    _TMP_UINT_TO_INT9_ENO : BOOL;
    _TMP_UINT_TO_INT9_OUT : INT;
  END_VAR

  _TMP_DIV3_OUT := DIV(EN := TRUE, IN1 := input_uint, IN2 := 2, ENO => _TMP_DIV3_ENO);
  _TMP_ABS8_OUT := ABS(_TMP_DIV3_OUT);
  _TMP_UINT_TO_INT9_OUT := UINT_TO_INT(IN := _TMP_ABS8_OUT, ENO => _TMP_UINT_TO_INT9_ENO);
  output_int := _TMP_UINT_TO_INT9_OUT;
END_FUNCTION_BLOCK

FUNCTION_BLOCK pressure_override
  VAR
    pressure_real : REAL := 2700.0;
  END_VAR
  VAR_INPUT
    pressure : UINT := 58981;
    curr_sp : UINT := 58981;
  END_VAR
  VAR
    curr_sp_real : REAL := 2700.0;
    product_sp_real : REAL := 100.0;
    sp_update : REAL := 0.0;
    product_sp_nominl : REAL := 100.0;
  END_VAR
  VAR_OUTPUT
    product_sp : UINT := 13107;
  END_VAR
  VAR
    override_sp_real : REAL := 2900.0;
  END_VAR
  VAR_INPUT
    override_sp : UINT := 63350;
  END_VAR
  VAR
    override_k : REAL := 1.0;
    override_ti : REAL := 99999.0;
    cycle_time : TIME := T#50ms;
    scale_to_real7 : scale_to_real;
    pressure_max : REAL := 3000.0;
    pressure_min : REAL := 0.0;
    flow_max : REAL := 500.0;
    flow_min : REAL := 0.0;
    scale_to_real0 : scale_to_real;
    _TMP_SUB86_ENO : BOOL;
    _TMP_SUB86_OUT : REAL;
    _TMP_MUL87_OUT : REAL;
    _TMP_MAX84_ENO : BOOL;
    _TMP_MAX84_OUT : REAL;
    _TMP_ADD85_ENO : BOOL;
    _TMP_ADD85_OUT : REAL;
    _TMP_LIMIT67_ENO : BOOL;
    _TMP_LIMIT67_OUT : REAL;
    _TMP_DIV73_ENO : BOOL;
    _TMP_DIV73_OUT : REAL;
    _TMP_MUL75_OUT : REAL;
    _TMP_REAL_TO_UINT79_ENO : BOOL;
    _TMP_REAL_TO_UINT79_OUT : UINT;
  END_VAR

  scale_to_real7(EN := TRUE, raw_input_value := pressure, real_max := pressure_max, real_min := pressure_min);
  IF scale_to_real7.ENO THEN
      pressure_real := scale_to_real7.scaled_real;
  END_IF;
  _TMP_SUB86_OUT := SUB(EN := TRUE, IN1 := override_sp_real, IN2 := pressure_real, ENO => _TMP_SUB86_ENO);
  _TMP_MUL87_OUT := MUL(_TMP_SUB86_OUT, override_k);
  _TMP_MAX84_OUT := MAX(IN1 := _TMP_MUL87_OUT, IN2 := 0.0, ENO => _TMP_MAX84_ENO);
  sp_update := _TMP_MAX84_OUT;
  scale_to_real0(EN := TRUE, raw_input_value := curr_sp, real_max := flow_max, real_min := flow_min);
  IF scale_to_real0.ENO THEN
      curr_sp_real := scale_to_real0.scaled_real;
  END_IF;
  _TMP_ADD85_OUT := ADD(EN := TRUE, IN1 := curr_sp_real, IN2 := sp_update, ENO => _TMP_ADD85_ENO);
  _TMP_LIMIT67_OUT := LIMIT(MN := 50.0, IN := _TMP_ADD85_OUT, MX := 150.0, ENO => _TMP_LIMIT67_ENO);
  product_sp_real := _TMP_LIMIT67_OUT;
  _TMP_DIV73_OUT := DIV(EN := TRUE, IN1 := product_sp_real, IN2 := 500.0, ENO => _TMP_DIV73_ENO);
  _TMP_MUL75_OUT := MUL(_TMP_DIV73_OUT, 65535.0);
  _TMP_REAL_TO_UINT79_OUT := REAL_TO_UINT(IN := _TMP_MUL75_OUT, ENO => _TMP_REAL_TO_UINT79_ENO);
  product_sp := _TMP_REAL_TO_UINT79_OUT;
END_FUNCTION_BLOCK

PROGRAM main
  VAR
    flow_control0 : flow_control;
  END_VAR
  VAR
    flow_set AT %MW0 : UINT := 13107;
    a_setpoint AT %MW1 : UINT := 30801;
    pressure_sp AT %MW2 : UINT := 55295;
    override_sp AT %MW3 : UINT := 31675;
    level_sp AT %MW4 : UINT := 28835;
  END_VAR
  VAR
    composition_control0 : composition_control;
    scale_to_signed0 : scale_to_signed;
  END_VAR
  VAR
    f1_valve_pos AT %IW0 : UINT := 30000;
    f1_flow AT %IW1 : UINT := 30000;
    f2_valve_pos AT %IW2 : UINT := 30000;
    f2_flow AT %IW3 : UINT := 30000;
    purge_valve_pos AT %IW4 : UINT := 30000;
    purge_flow AT %IW5 : UINT := 30000;
    product_valve_pos AT %IW6 : UINT := 30000;
    product_flow AT %IW7 : UINT := 10000;
    pressure AT %IW8 : UINT := 60000;
    level AT %IW9 : UINT := 30000;
    a_in_purge AT %IW10 : UINT := 30000;
    b_in_purge AT %IW11 : UINT := 10000;
    c_in_purge AT %IW12 : UINT := 10000;
    f1_valve_sp AT %QW0 : UINT := 30000;
    f2_valve_sp AT %QW1 : UINT := 30000;
    purge_valve_sp AT %QW2 : UINT := 30000;
    product_valve_sp AT %QW3 : UINT := 30000;
  END_VAR
  VAR
    product_valve_safe : UINT := 0;
    purge_valve_safe : UINT := 65535;
    f1_valve_safe : UINT := 0;
    f2_valve_safe : UINT := 0;
    pressure_control0 : pressure_control;
  END_VAR
  VAR
    hmi_pressure AT %MW20 : INT;
    hmi_level AT %MW21 : INT;
    hmi_f1_valve_pos AT %MW22 : INT;
    hmi_f1_flow AT %MW23 : INT;
    hmi_f2_valve_pos AT %MW24 : INT;
    hmi_f2_flow AT %MW25 : INT;
    hmi_purge_valve_pos AT %MW26 : INT;
    hmi_purge_flow AT %MW27 : INT;
    hmi_product_valve_pos AT %MW28 : INT;
    hmi_product_flow AT %MW29 : INT;
    scan_count AT %MW30 : UINT := 0;
  END_VAR
  VAR
    scale_to_signed1 : scale_to_signed;
    scale_to_signed2 : scale_to_signed;
    scale_to_signed3 : scale_to_signed;
    scale_to_signed4 : scale_to_signed;
    scale_to_signed5 : scale_to_signed;
    scale_to_signed6 : scale_to_signed;
    scale_to_signed7 : scale_to_signed;
    scale_to_signed8 : scale_to_signed;
    scale_to_signed9 : scale_to_signed;
    pressure_override0 : pressure_override;
    level_control0 : level_control;
  END_VAR
  VAR_EXTERNAL
    run_bit : BOOL;
  END_VAR
  VAR
    _TMP_ADD87_ENO : BOOL;
    _TMP_ADD87_OUT : UINT;
    _TMP_GE91_ENO : BOOL;
    _TMP_GE91_OUT : BOOL;
    _TMP_MOVE92_ENO : BOOL;
    _TMP_MOVE92_OUT : UINT;
  END_VAR

  flow_control0(EN := TRUE, product_flow := product_flow, curr_pos := f1_valve_pos, flow_set_in := flow_set);
  IF flow_control0.ENO THEN
      f1_valve_sp := flow_control0.new_pos;
  END_IF;
  pressure_control0(EN := TRUE, pressure := pressure, pressure_sp := pressure_sp, curr_pos := purge_valve_pos);
  IF pressure_control0.ENO THEN
      purge_valve_sp := pressure_control0.valve_pos;
  END_IF;
  composition_control0(EN := TRUE, a_in_purge := a_in_purge, a_setpoint := a_setpoint, curr_pos := f2_valve_pos);
  IF composition_control0.ENO THEN
      f2_valve_sp := composition_control0.new_pos;
  END_IF;
  pressure_override0(EN := TRUE, pressure := pressure, curr_sp := flow_set, override_sp := override_sp);
  IF pressure_override0.ENO THEN
      flow_set := pressure_override0.product_sp;
  END_IF;
  level_control0(EN := TRUE, liquid_level := level, level_sp := level_sp, curr_pos := product_valve_pos);
  IF level_control0.ENO THEN
      product_valve_sp := level_control0.new_pos;
  END_IF;
  scale_to_signed0(EN := TRUE, input_uint := pressure);
  IF scale_to_signed0.ENO THEN
      hmi_pressure := scale_to_signed0.output_int;
  END_IF;
  scale_to_signed1(EN := TRUE, input_uint := level);
  IF scale_to_signed1.ENO THEN
      hmi_level := scale_to_signed1.output_int;
  END_IF;
  scale_to_signed2(EN := TRUE, input_uint := f1_valve_pos);
  IF scale_to_signed2.ENO THEN
      hmi_f1_valve_pos := scale_to_signed2.output_int;
  END_IF;
  scale_to_signed3(EN := TRUE, input_uint := f2_valve_pos);
  IF scale_to_signed3.ENO THEN
      hmi_f2_valve_pos := scale_to_signed3.output_int;
  END_IF;
  scale_to_signed4(EN := TRUE, input_uint := purge_valve_pos);
  IF scale_to_signed4.ENO THEN
      hmi_purge_valve_pos := scale_to_signed4.output_int;
  END_IF;
  scale_to_signed5(EN := TRUE, input_uint := product_valve_pos);
  IF scale_to_signed5.ENO THEN
      hmi_product_valve_pos := scale_to_signed5.output_int;
  END_IF;
  scale_to_signed6(EN := TRUE, input_uint := f1_flow);
  IF scale_to_signed6.ENO THEN
      hmi_f1_flow := scale_to_signed6.output_int;
  END_IF;
  scale_to_signed7(EN := TRUE, input_uint := f2_flow);
  IF scale_to_signed7.ENO THEN
      hmi_f2_flow := scale_to_signed7.output_int;
  END_IF;
  scale_to_signed8(EN := TRUE, input_uint := purge_flow);
  IF scale_to_signed8.ENO THEN
      hmi_purge_flow := scale_to_signed8.output_int;
  END_IF;
  scale_to_signed9(EN := TRUE, input_uint := product_flow);
  IF scale_to_signed9.ENO THEN
      hmi_product_flow := scale_to_signed9.output_int;
  END_IF;
  _TMP_ADD87_OUT := ADD(EN := TRUE, IN1 := scan_count, IN2 := 1, ENO => _TMP_ADD87_ENO);
  IF _TMP_ADD87_ENO THEN
      scan_count := _TMP_ADD87_OUT;
  END_IF;
  _TMP_GE91_OUT := GE(EN := TRUE, IN1 := scan_count, IN2 := 32000, ENO => _TMP_GE91_ENO);
  _TMP_MOVE92_OUT := MOVE(EN := _TMP_GE91_OUT, IN := 0, ENO => _TMP_MOVE92_ENO);
  IF _TMP_MOVE92_ENO THEN
      scan_count := _TMP_MOVE92_OUT;
  END_IF;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    VAR_GLOBAL
      run_bit AT %QX0.0 : BOOL := 1;
    END_VAR
    TASK MainTask(INTERVAL := T#50ms,PRIORITY := 0);
    PROGRAM instance0 WITH MainTask : main;
  END_RESOURCE
END_CONFIGURATION
