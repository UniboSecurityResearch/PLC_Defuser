FUNCTION_BLOCK value_filtering
  VAR_INPUT
    IN1 : INT;
  END_VAR
  VAR_OUTPUT
    OUT : INT;
  END_VAR
  VAR
    value_real : INT;
  END_VAR


  value_real := IN1 - 5;
  OUT := value_real;
END_FUNCTION_BLOCK

FUNCTION_BLOCK valves_handler
  VAR_INPUT
    IN1 : INT;
    STOP : BOOL;
    IN_TLB1 : INT;
    IN_TLB2 : INT;
  END_VAR
  VAR_OUTPUT
    OUT_MV1 : BOOL;
    OUT_MV2 : BOOL;
  END_VAR
  VAR
    real_value : INT;
  END_VAR


  real_value :=  IN1 - 5;

  IF real_value <= IN_TLB2 then
    OUT_MV2 := FALSE;
    OUT_MV1 := TRUE;
  end_IF;

  IF real_value >= IN_TLB1 THEN
    OUT_MV2 := TRUE;
    OUT_MV1 := FALSE;
  end_IF;

  IF STOP = TRUE THEN
    OUT_MV2 := FALSE;
    OUT_MV1 := FALSE;
  end_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR_INPUT
    TLB2 : INT;
    TLB1 : INT;
    START : BOOL;
    STOP : BOOL;
    VALUE : INT;
  END_VAR
  VAR_OUTPUT
    MV1 : BOOL;
    MV2 : BOOL;
    CYCLE_ON : BOOL;
  END_VAR
  VAR
    value_filtering0 : value_filtering;
    valves_handler0 : valves_handler;
  END_VAR

  CYCLE_ON := NOT(STOP) AND (CYCLE_ON OR START);
  value_filtering0(IN1 := VALUE);
  valves_handler0(EN := CYCLE_ON, IN1 := value_filtering0.OUT, STOP := STOP, IN_TLB1 := TLB1, IN_TLB2 := TLB2);
  IF valves_handler0.ENO THEN
      MV1 := valves_handler0.OUT_MV1;
  END_IF;
  IF valves_handler0.ENO THEN
      MV2 := valves_handler0.OUT_MV2;
  END_IF;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION