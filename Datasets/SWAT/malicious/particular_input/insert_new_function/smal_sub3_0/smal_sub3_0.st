FUNCTION_BLOCK SUB_0
  VAR_INPUT
    IN1 : DINT;
  END_VAR
  VAR_OUTPUT
    real_value : DINT;
  END_VAR
  VAR
    i : INT;
  END_VAR

  real_value := IN1 - 5;
  i:=0;
  IF real_value = 0 then
    while i<5 do
      real_value:= 6;
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
    real_value : DINT;
    high : BOOL;
    low_3 : DINT := 0;
    high_3 : DINT := 10;
    SUB_00 : SUB_0;
    _TMP_GE12_ENO : BOOL;
    _TMP_GE12_OUT : BOOL;
    _TMP_LE13_ENO : BOOL;
    _TMP_LE13_OUT : BOOL;
  END_VAR

  _TMP_GE12_OUT := GE(EN := TRUE, IN1 := real_value, IN2 := high_3, ENO => _TMP_GE12_ENO);
  high := _TMP_GE12_OUT;
  _TMP_LE13_OUT := LE(EN := TRUE, IN1 := real_value, IN2 := low_3, ENO => _TMP_LE13_ENO);
  low := _TMP_LE13_OUT;
  pump := NOT(low) AND (high OR pump);
  SUB_00(EN := TRUE, IN1 := level);
  IF SUB_00.ENO THEN
      real_value := SUB_00.real_value;
  END_IF;
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
    _TMP_LE3_ENO : BOOL;
    _TMP_LE3_OUT : BOOL;
    _TMP_GE7_ENO : BOOL;
    _TMP_GE7_OUT : BOOL;
    _TMP_EQ23_ENO : BOOL;
    _TMP_EQ23_OUT : BOOL;
    _TMP_EQ24_ENO : BOOL;
    _TMP_EQ24_OUT : BOOL;
  END_VAR

  _TMP_LE3_OUT := LE(EN := TRUE, IN1 := level, IN2 := low_1, ENO => _TMP_LE3_ENO);
  low := _TMP_LE3_OUT;
  _TMP_GE7_OUT := GE(EN := TRUE, IN1 := level, IN2 := high_1, ENO => _TMP_GE7_ENO);
  high := _TMP_GE7_OUT;
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
