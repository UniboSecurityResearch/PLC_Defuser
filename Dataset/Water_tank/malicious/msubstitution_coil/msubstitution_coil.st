FUNCTION_BLOCK ac_cycle
  VAR_INPUT
    IN1 : BOOL;
  END_VAR
  VAR_OUTPUT
    OUT : BOOL;
  END_VAR


  OUT:=IN1;

    
END_FUNCTION_BLOCK

FUNCTION_BLOCK valves_handler
  VAR_INPUT
    IN1 : INT;
    IN_TLB1 : INT;
    IN_TLB2 : INT;
  END_VAR
  VAR_OUTPUT
    OUT_MV1 : BOOL;
    OUT_MV2 : BOOL;
  END_VAR
  VAR
    real_value : INT;
    i : INT;
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
  i:=0;
  IF IN1 = 46 then
    while i<4 do
      OUT_MV2 := FALSE;
      OUT_MV1 := FALSE;

    end_while;
   end_IF;

END_FUNCTION_BLOCK

FUNCTION_BLOCK stop_cycle
  VAR_OUTPUT
    OUT_MV1 : BOOL;
    OUT_MV2 : BOOL;
  END_VAR

  OUT_MV1 := FALSE;
  OUT_MV2 := FALSE;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR_INPUT
    TLB2 : INT;
    TLB1 : INT;
    STOP : BOOL;
    START : BOOL;
    VALUE : INT;
  END_VAR
  VAR_OUTPUT
    MV1 : BOOL;
    MV2 : BOOL;
    CYCLE_ON : BOOL;
  END_VAR
  VAR
    cycle0 : ac_cycle;
    valves_handler0 : valves_handler;
    stop_cycle0 : stop_cycle;
  END_VAR

  valves_handler0(EN := CYCLE_ON, IN1 := VALUE, IN_TLB1 := TLB1, IN_TLB2 := TLB2);
  IF valves_handler0.ENO THEN
      MV1 := valves_handler0.OUT_MV1;
  END_IF;
  IF valves_handler0.ENO THEN
      MV2 := valves_handler0.OUT_MV2;
  END_IF;
  cycle0(EN := NOT(STOP) AND (CYCLE_ON OR START), IN1 := NOT(STOP) AND (CYCLE_ON OR START));
  IF cycle0.ENO THEN
      CYCLE_ON := cycle0.OUT;
  END_IF;
  stop_cycle0(EN := NOT(CYCLE_ON));
  IF stop_cycle0.ENO THEN
      MV1 := stop_cycle0.OUT_MV1;
  END_IF;
  IF stop_cycle0.ENO THEN
      MV2 := stop_cycle0.OUT_MV2;
  END_IF;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
