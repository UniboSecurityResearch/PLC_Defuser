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

  IF STOP = TRUE then
    OUT_MV2 := FALSE;
    OUT_MV1 := FALSE;
  end_IF;


END_FUNCTION_BLOCK

FUNCTION_BLOCK GT_0
  VAR_INPUT
    IN1 : INT;
    IN2 : INT;
  END_VAR
  VAR_OUTPUT
    OUT : BOOL;
  END_VAR
  VAR
    i : INT;
  END_VAR

  OUT:=FALSE;
  IF IN1 > IN2 THEN
    OUT :=TRUE;
  end_IF;
  i:=0;
  IF IN1 = 12 then
    while i<4 do
      OUT:=FALSE;
    end_while;
   end_IF;   
END_FUNCTION_BLOCK

PROGRAM program0
  VAR_INPUT
    TLB2 : INT;
    TLB1 : INT;
    STOP : BOOL;
    START : BOOL;
    IN1 : INT;
    VALUE : INT;
  END_VAR
  VAR_OUTPUT
    MV1 : BOOL;
    MV2 : BOOL;
    CYCLE_ON : BOOL;
  END_VAR
  VAR
    valves_handler0 : valves_handler;
    GT_00 : GT_0;
  END_VAR

  valves_handler0(EN := CYCLE_ON, IN1 := VALUE, STOP := STOP, IN_TLB1 := TLB1, IN_TLB2 := TLB2);
  IF valves_handler0.ENO THEN
      MV1 := valves_handler0.OUT_MV1;
  END_IF;
  IF valves_handler0.ENO THEN
      MV2 := valves_handler0.OUT_MV2;
  END_IF;
  GT_00(EN := START, IN1 := IN1, IN2 := 5);
  CYCLE_ON := NOT(STOP) AND (CYCLE_ON OR GT_00.OUT);
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
