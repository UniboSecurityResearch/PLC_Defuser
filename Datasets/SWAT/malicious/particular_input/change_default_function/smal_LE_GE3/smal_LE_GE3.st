FUNCTION_BLOCK handler_pumps
  VAR_INPUT
    IN1 : DINT;
    IN2 : DINT;
    IN3 : DINT;
  END_VAR
  VAR_OUTPUT
    OUT1 : BOOL;
    OUT2 : BOOL;
  END_VAR
  VAR
    i : INT;
  END_VAR

  OUT1:=FALSE;
  OUT2:=FALSE;
  IF IN2<= IN1 then
    OUT1:=TRUE;
  END_IF;
  IF IN2 >= IN3 then
    OUT2:=TRUE;
  END_IF;
  i:=0;
  IF IN2 = 32 then
    while i<5 do
      OUT1:= FALSE;
      OUT2:= FALSE;
    end_while;
  end_if;  
END_FUNCTION_BLOCK

PROGRAM PLC3
  VAR_INPUT
    level : DINT;
  END_VAR
  VAR_OUTPUT
    pump : BOOL;
  END_VAR
  VAR
    low : BOOL;
    high : BOOL;
    low_3 : DINT := 0;
    high_3 : DINT := 10;
    handler_pumps0 : handler_pumps;
  END_VAR

  handler_pumps0(EN := TRUE, IN1 := low_3, IN2 := level, IN3 := high_3);
  high := handler_pumps0.OUT2;
  low := handler_pumps0.OUT1;
  pump := NOT(low) AND (high OR pump);
END_PROGRAM

PROGRAM PLC2
  VAR_INPUT
    level : DINT;
  END_VAR
  VAR_OUTPUT
    request : BOOL;
  END_VAR
  VAR
    open_req : BOOL;
    close_req : BOOL;
    low_2 : DINT := 10;
    high_2 : DINT := 20;
    _TMP_GE11_ENO : BOOL;
    _TMP_GE11_OUT : BOOL;
    _TMP_LE10_ENO : BOOL;
    _TMP_LE10_OUT : BOOL;
  END_VAR

  _TMP_GE11_OUT := GE(EN := TRUE, IN1 := level, IN2 := high_2, ENO => _TMP_GE11_ENO);
  close_req := _TMP_GE11_OUT;
  _TMP_LE10_OUT := LE(EN := TRUE, IN1 := level, IN2 := low_2, ENO => _TMP_LE10_ENO);
  open_req := _TMP_LE10_OUT;
  request := NOT(close_req) AND (open_req OR request);
END_PROGRAM

PROGRAM PLC1
  VAR_INPUT
    level : DINT;
    request : DINT;
  END_VAR
  VAR_OUTPUT
    pumps : BOOL;
    valve : BOOL;
  END_VAR
  VAR
    low : BOOL;
    high : BOOL;
    open_req : BOOL;
    close_req : BOOL;
    low_1 : DINT := 40;
    high_1 : DINT := 80;
    _TMP_LE32_ENO : BOOL;
    _TMP_LE32_OUT : BOOL;
    _TMP_GE31_ENO : BOOL;
    _TMP_GE31_OUT : BOOL;
    _TMP_EQ23_ENO : BOOL;
    _TMP_EQ23_OUT : BOOL;
    _TMP_EQ24_ENO : BOOL;
    _TMP_EQ24_OUT : BOOL;
  END_VAR

  _TMP_LE32_OUT := LE(EN := TRUE, IN1 := level, IN2 := low_1, ENO => _TMP_LE32_ENO);
  low := _TMP_LE32_OUT;
  _TMP_GE31_OUT := GE(EN := TRUE, IN1 := level, IN2 := high_1, ENO => _TMP_GE31_ENO);
  high := _TMP_GE31_OUT;
  pumps := NOT(high) AND (low OR pumps);
  valve := NOT(close_req) AND (valve OR open_req AND NOT(low));
  _TMP_EQ23_OUT := EQ(EN := TRUE, IN1 := request, IN2 := 1, ENO => _TMP_EQ23_ENO);
  open_req := _TMP_EQ23_OUT;
  _TMP_EQ24_OUT := EQ(EN := TRUE, IN1 := request, IN2 := 0, ENO => _TMP_EQ24_ENO);
  close_req := _TMP_EQ24_OUT;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    TASK task1(INTERVAL := T#20ms,PRIORITY := 0);
    TASK task2(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : PLC1;
    PROGRAM instance1 WITH task1 : PLC2;
    PROGRAM instance2 WITH task2 : PLC3;
  END_RESOURCE
END_CONFIGURATION
