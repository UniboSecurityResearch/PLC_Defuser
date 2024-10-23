FUNCTION_BLOCK level_filtering
  VAR_INPUT
    IN1 : INT;
    IN_TLB1 : BOOL;
    IN_TLB2 : BOOL;
  END_VAR
  VAR_OUTPUT
    OUT_MV1 : BOOL;
    OUT_MV2 : BOOL;
  END_VAR
  VAR
    i : INT;
    avg : INT;
    sum : INT;
  END_VAR

  i:=1;
  sum := 0;
  while (i < 5) do
    sum := sum + IN1;
    i:=i+1;
  end_while;
  avg:= sum /5;

  IF avg <=20 then
    OUT_MV2 := FALSE;
    OUT_MV1 := TRUE;
  end_IF;
  IF avg >=60 THEN
    OUT_MV2 := TRUE;
    OUT_MV1 := FALSE;
  end_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR_INPUT
    TLB2 : BOOL;
    TLB1 : BOOL;
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
    level_filtering0 : level_filtering;
    _TMP_LT34_ENO : BOOL;
    _TMP_LT34_OUT : BOOL;
  END_VAR

  level_filtering0(EN := CYCLE_ON, IN1 := VALUE, IN_TLB1 := TLB1, IN_TLB2 := TLB2);
  IF level_filtering0.ENO THEN
      MV1 := level_filtering0.OUT_MV1;
  END_IF;
  IF level_filtering0.ENO THEN
      MV2 := level_filtering0.OUT_MV2;
  END_IF;
  _TMP_LT34_OUT := LT(EN := TRUE, IN1 := IN1, IN2 := 5, ENO => _TMP_LT34_ENO);
  CYCLE_ON := NOT(STOP) AND (CYCLE_ON OR START AND _TMP_LT34_OUT);
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
