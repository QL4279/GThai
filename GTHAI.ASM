;======================================================================
;        Disassembly of file :VTHAI.COM
;       25 Line VGA Thai driver
;       Source re-created and customized by Gary Butler
; Must be assembled with Borland Turbo Assembler
; Command line:
;   tasm /m2 gthai
;   tlink /t gthai
;======================================================================
        .xlist
        INCLUDE GTHAI.INC
        .list

;============================================================
Code_Seg SEGMENT PUBLIC
         ASSUME ES:Code_Seg,CS:Code_Seg,SS:Code_Seg,DS:Code_Seg
;============================================================

         ORG   00100H
;------------------------------------------------------------

GTHAI:
        JMP   INIT              ;Go init TSR

DRIVER_VERSION   DW    VERSION_ID

CURRENT_MODE   DB    0                 ;THAI/ENGLISH MODE
L0106H   DB    2

;======================================================================
;        Control Panel fields
;======================================================================

OPTION_TABLE LABEL BYTE
DISPMODE                DB THAI_25      ;1. Eng/8 Line Thai/25 Line Thai
DISPXLAT                DB 0            ;2. Xlate display?
DISPLAY_COLUMN_ADJUST   DB 1            ;3. Display column adjust
THAIMODE                DB 1            ;4. Startup mode
PANEL_5                 DB 0            ;5.
SPACE_A0                DB 0            ;6. Use 0A0h for space?
WHICHPTR                DB IBMPRO       ;7. Epson=0 IBM=1
PRT_XLAT                DB 0            ;8. Xlate print
PCOMPOSE                DB THAIPRT3     ;9. 0=NO INTERCEPT

OPTION_SAVE_LENGTH = $ - GTHAI

VMODEFLAG DB 0
;======================================================================
;        Printer line spacing variables
;        Default = 4 Lines per inch
;======================================================================

LPI_TOP         DB    DFLT_TOP_LPI      ;LINE SPACE INCREMENT - LEADING
LPI_MIDDLE      DB    DFLT_MDL_LPI      ;Spacing between middle & main
LPI_MAIN        DB    DFLT_MAIN_LPI     ;Spacing between main & bottom
LPI_FINAL       DB    DFLT_BTM_LPI      ;Trailing line space

;======================================================================
XLAT_TBL DB    0,1,2,3,4,5,6,7
         DB    8,9,0AH,0BH,0CH,0DH,0EH,0FH
         DB    10H,11H,12H,13H,14H,15H,16H
         DB    17H,18H,19H,1AH,1BH,1CH,1DH,1EH,1FH
         DB    20H,21H,22H,23H,24H,25H,26H,27H,28H
         DB    29H,2AH,2BH,2CH,2DH,2EH,2FH
         DB    30H,31H,32H,33H,34H,35H,36H,37H,38H
         DB    39H,3AH,3BH,3CH,3DH,3EH,3FH
         DB    40H,41H
         DB    42H,43H,44H,45H,46H,47H
         DB    48H,49H,4AH,4BH,4CH,4DH
         DB    4EH,4FH,50H,51H,52H,53H
         DB    54H,55H,56H,57H,58H,59H
         DB    5AH,5BH,5CH,5DH,5EH,5FH
         DB    60H,61H,62H,63H,64H,65H
         DB    66H,67H,68H,69H,6AH,6BH
         DB    6CH,6DH,6EH,6FH,70H,71H
         DB    72H,73H,74H,75H,76H,77H
         DB    78H,79H,7AH,7BH,7CH,7DH
         DB    7EH,7FH,95H,97H,9BH,9DH
         DB    9FH,9EH,98H,9AH,9CH,96H
         DB    99H,0FAH,0FBH,0EEH,0EFH,0DFH
         DB    0F0H,0F1H,0F2H,0F3H,0F4H,0F5H
         DB    0F6H,0F7H,0F8H,0F9H,0A3H,0A5H
         DB    0DCH,0DDH,0DEH,0DBH,0A0H,0A1H
         DB    0A2H,0A4H,0A6H,0A7H,0A8H,0A9H
         DB    0AAH,0ABH,0ACH,0ADH,0AEH,0AFH
         DB    0B0H,0B1H,0B2H,0B3H,0B4H,0B5H
         DB    0B6H,0B7H,0B8H,0B9H,0BAH,0BBH
         DB    0BCH,0BDH,0BEH,0BFH,0C0H,0C1H
         DB    0C2H,0C3H,0C4H,0C5H,0C7H,0C8H
         DB    0C9H,0CAH,0CBH,0CCH,0CDH,0CEH
         DB    0D0H,0C6H,0D2H,0D3H,0E0H,0E1H
         DB    0E2H,0E3H,0E4H,0E6H,0CFH,0D8H
         DB    0D9H,0D4H,0D5H,0D6H,0D7H,0D1H
         DB    0EDH,0E7H,0E8H,0E9H,0EAH,0EBH
         DB    0ECH,0DAH,0FCH,0FDH,0FEH,0FFH
         DB    80H,81H,82H,83H,84H,85H
         DB    86H,87H,88H,89H,8AH,8BH
         DB    8CH,8DH,8EH,8FH,90H,91H
         DB    92H,93H,94H,0FFH
         DB    0,1,2,3,4,5,6,7
         DB    8,9,0AH,0BH,0CH,0DH,0EH,0FH
         DB    10H,11H,12H,13H,14H,15H
         DB    16H,17H,18H,19H,1AH,1BH
         DB    1CH,1DH,1EH,1FH,20H,21H
         DB    22H,23H,24H,25H,26H,27H
         DB    28H,29H,2AH,2BH,2CH,2DH
         DB    2EH,2FH,30H,31H,32H,33H
         DB    34H,35H,36H,37H,38H,39H
         DB    3AH,3BH,3CH,3DH,3EH,3FH
         DB    40H,41H,42H,43H,44H,45H
         DB    46H,47H,48H,49H,4AH,4BH
         DB    4CH,4DH,4EH,4FH,50H,51H
         DB    52H,53H,54H,55H,56H,57H
         DB    58H,59H,5AH,5BH,5CH,5DH
         DB    5EH,5FH,60H,61H,62H,63H
         DB    64H,65H,66H,67H,68H,69H
         DB    6AH,6BH,6CH,6DH,6EH,6FH
         DB    70H,71H,72H,73H,74H,75H
         DB    76H,77H,78H,79H,7AH,7BH
         DB    7CH,7DH,7EH,7FH,0EAH,0EBH
         DB    0ECH,0EDH,0EEH,0EFH,0F0H,0F1H
         DB    0F2H,0F3H,0F4H,0F5H,0F6H,0F7H
         DB    0F8H,0F9H,0FAH,0FBH,0FCH,0FDH
         DB    0FEH,80H,89H,81H,86H,8AH
         DB    87H,82H,88H,83H,85H,84H
         DB    0A0H,0A1H,0A2H,9AH,0A3H,9BH
         DB    0A4H,0A5H,0A6H,0A7H,0A8H,0A9H
         DB    0AAH,0ABH,0ACH,0ADH,0AEH,0AFH
         DB    0B0H,0B1H,0B2H,0B3H,0B4H,0B5H
         DB    0B6H,0B7H,0B8H,0B9H,0BAH,0BBH
         DB    0BCH,0BDH,0BEH,0BFH,0C0H,0C1H
         DB    0C2H,0C3H,0CDH,0C4H,0C5H,0C6H
         DB    0C7H,0C8H,0C9H,0CAH,0CBH,0D6H
         DB    0CCH,0DDH,0CEH,0CFH,0D9H,0DAH
         DB    0DBH,0DCH,0D7H,0D8H,0E5H,9FH
         DB    9CH,9DH,9EH,8FH,0D0H,0D1H
         DB    0D2H,0D3H,0D4H,0,0D5H,0DFH
         DB    0E0H,0E1H,0E2H,0E3H,0E4H,0DEH
         DB    8DH,8EH,90H,91H,92H,93H
         DB    94H,95H,96H,97H,98H,99H
         DB    8BH,8CH,0E6H,0E7H,0E8H,0FFH

PRTXLTBL LABEL BYTE  
 DB    0,   1,   2,   3,   4,   5,   6,   7,   8,   9, 0AH, 0BH, 0CH, 0DH, 0EH, 0FH
 DB  10H, 11H, 12H, 13H, 14H, 15H, 16H, 17H, 18H, 19H, 1AH, 1BH, 1CH, 1DH, 1EH, 1FH
 DB  20H, 21H, 22H, 23H, 24H, 25H, 26H, 27H, 28H, 29H, 2AH, 2BH, 2CH, 2DH, 2EH, 2FH
 DB  30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 3AH, 3BH, 3CH, 3DH, 3EH, 3FH
 DB  40H, 41H, 42H, 43H, 44H, 45H, 46H, 47H, 48H, 49H, 4AH, 4BH, 4CH, 4DH, 4EH, 4FH
 DB  50H, 51H, 52H, 53H, 54H, 55H, 56H, 57H, 58H, 59H, 5AH, 5BH, 5CH, 5DH, 5EH, 5FH
 DB  60H, 61H, 62H, 63H, 64H, 65H, 66H, 67H, 68H, 69H, 6AH, 6BH, 6CH, 6DH, 6EH, 6FH
 DB  70H, 71H, 72H, 73H, 74H, 75H, 76H, 77H, 78H, 79H, 7AH, 7BH, 7CH, 7DH, 7EH, 7FH
 DB 0EAH,0EBH,0ECH,0EDH,0EEH,0EFH,0F0H,0F1H,0F2H,0F3H,0F4H,0F5H,0F6H,0F7H,0F8H,0F9H
 DB 0FAH,0FBH,0FCH,0FDH,0FEH, 80H, 89H, 81H, 86H, 8AH, 87H, 82H, 88H, 83H, 85H, 84H
 DB 0A0H,0A1H,0A2H, 9AH,0A3H, 9BH,0A4H,0A5H,0A6H,0A7H,0A8H,0A9H,0AAH,0ABH,0ACH,0ADH
 DB 0AEH,0AFH,0B0H,0B1H,0B2H,0B3H,0B4H,0B5H,0B6H,0B7H,0B8H,0B9H,0BAH,0BBH,0BCH,0BDH
 DB 0BEH,0BFH,0C0H,0C1H,0C2H,0C3H,0CDH,0C4H,0C5H,0C6H,0C7H,0C8H,0C9H,0CAH,0CBH,0D6H
 DB 0CCH,0DDH,0CEH,0CFH,0D9H,0DAH,0DBH,0DCH,0D7H,0D8H,0E5H, 9FH, 9CH, 9DH, 9EH, 8FH
 DB 0D0H,0D1H,0D2H,0D3H,0D4H,   0,0D5H,0DFH,0E0H,0E1H,0E2H,0E3H,0E4H,0DEH,   0,0D5H
 DB  90H, 91H, 92H, 93H, 94H, 95H, 96H, 97H, 98H, 99H, 8BH, 8CH,0E6H,0E7H,0E8H,0E9H

L0414H   DB    20H,21H,0B2H,2FH,2CH,3FH
         DB    5FH,0A2H,28H,29H,2EH,25H
         DB    0D0H,0F1H,0A8H,0BEH,0F0H,20H
         DB    0F2H,0F3H,0F4H,0F5H,0D9H,0F7H
         DB    0F8H,0F9H,0A6H,0E4H,0BFH,0F6H
         DB    0A9H,0CCH,22H,0EBH,0DFH,0B0H
         DB    0D3H,0E6H,0B3H,0ECH,0D7H,0ABH
         DB    0BCH,0AAH

L0440H   DB    0E2H,0CEH,0C8H,0B6H,0B2H,0EAH
         DB    0ADH,0B8H,0C9H,0BDH,0C0H,0C4H
         DB    0AFH,0D6H,0AEH,0E3H,5CH,0ACH
         DB    0D8H,2DH,60H,0E9H,0D4H,0C5H
         DB    0A7H,0C2H,0A1H,0D1H,0D5H,0C1H
         DB    0D2H,0B9H,0E0H,0CAH,0A4H,0C7H
         DB    0E1H,0E7H,0CDH,0B7H,0C3H,0B4H
         DB    0CBH,0B5H,0BEH,0E8H,0BAH,0CFH
         DB    7CH,20H,7EH,7FH

;----------------------------------------------------------------------  
BBSMSG_TEXT_COLOR = (WHITE_BG+RED)
BBSMSG_EDGE = BRIGHT_WHITE
BBSMSG_SHADOW = BLACK
BBSMSG_COLUMN   DW    0000H  ;Starting column of "Bulletin Board" Message
BBSMSG_ROW = 250

MSG_BBS  LABEL BYTE
; Customization by Gary Butler
        DB      _SPACE,_C,u_,s_,t_,o_,m_,i_,z_,a_,t_,i_,o_,n_
        DB      _SPACE,b_,y_,_SPACE
        DB      _G,a_,r_,y_,_SPACE,_B,u_,t_,l_,e_,r_,_SPACE
BBSMSG_LEN = $-MSG_BBS
        DB      END_OF_STRING

L04EAH           DW    L6382H
SET_EDGE_COLOR   DW    MONO_SET_EDGE_COLOR
SET_SHADOW_COLOR DW    MONO_SET_SHADOW_COLOR
CURSOR_CALC      DW    MONO_CALC_CURSOR
L04F2H           DW    L65FCH
NEXT_LINE        DW    MONO_NEXT_LINE
PREV_LINE        DW    MONO_PREV_LINE
DRAW_CURSOR          DW    DRAW_CURSOR_MONO
L04FAH           DW    L6541H
L04FCH           DW    L6571H
L04FEH           DW    L64FAH
CRTBASE          DW    0000H            ;CRT Controller base address port
VID_SEG          DW    0B000H
VIDBUF           DW    0B800H

L0506H      DW    0000H
L0508H      DW    24 DUP(0)
L0538H      DW    0000H
MSGVECT     DW    INIT_EGA

FNAMESEG    DW    0H             ;FILENAME SEGMENT POINTER
FNAMEOFF    DW    0H             ;FILENAME OFFSET POINTER

;------------------------------------------------------------
; SAVE POINTERS FOR ORIGINAL SYSTEM INTERRUPT VECTORS
;------------------------------------------------------------
OLDINT8     DW    0H                ;TIMER INT SAVE OFFSET
OLDSEG8     DW    0H
OLDINT9     DW    0H                ;KEYBOARD INT SAVE
OLDSEG9     DW    0H
OLDINT10    DW    0H                ;VIDEO INT SAVE
OLDSEG10    DW    0H
OLDINT17    DW    0H                ;PRINTER INT SAVE
OLDSEG17    DW    0H
OLDINT1D    DW    0H
OLDSEG1D    DW    0H
OLDINT24    DW    0H
OLDSEG24    DW    0H
;======================================================================
; VIDEO SAVE AREA
;======================================================================

VID_SAVE    DB  4000 DUP(0)      ;VIDEO BUFFER
VIDLINE2 = VID_SAVE+160         ;ADDRESS OF LINE 2 - Used for quick scroll

TEXT_COLOR  DB  0
CURSOR_SAVE DW  0000H               ;CURSOR ROW/COL
L14FBH      DB  14 DUP(0)
USER_WIDTH  DW  0000H
USER_HEIGHT DW  0000H
            DW  640
            DW  350
VID_OFFSET  DW  0000H

L1513H      DB  0
L1514H      DB  0

;======================================================================
; BIT PATTERNS
;======================================================================
PATTERN_POINTER   DW    PATTERN_FF

PATTERN_FF      DB    0FFH,0FFH,0FFH,0FFH
                DB    0FFH,0FFH,0FFH,0FFH

PATTERN_00      DB    0,0,0,0
                DB    0,0,0,0

PATTERN_AA55    DB    0AAH,55H,0AAH,55H
                DB    0AAH,55H,0AAH,55H


L152FH   DB    32 DUP(1)
         DB    96 DUP(4)
         DB    32 DUP(2)
         DB    48 DUP(5)
         DB    6,8,6,6,8,8
         DB    8,8,7,7,7
         DB    12 DUP(6)
         DB    8,9,9,9,9,9
         DB    8,5,5
         DB    10 DUP(3)
         DB    6 DUP(5)

;======================================================================
; FONT TABLES
;======================================================================
        .xlist
FONT_1   LABEL BYTE
        INCLUDE GT_FONT1.INC

FONT_2   LABEL BYTE
        INCLUDE GT_FONT2.INC
        .list

;End of font tables
;======================================================================

;        
;        Maximum allowable values for menu fields
;        
;
MAXOPT0  DB   3                 ;Field 0 - Eng/1 Line Thai/25 Line Thai
MAXOPT1  DB   2                 ;Field 1 - Xlate display?
MAXOPT2  DB   8                 ;Field 2 - DISPLAY_COLUMN_ADJUST
MAXOPT3  DB   3                 ;Field 3 - THAIMODE
MAXOPT4  DB   4                 ;Field 4 - 
;----------------------------------------------------------------------
; MAXOPT5 is the field for 0x20 or 0xa0 as space char. 0xA0 causes too
; many problems, so restrict to 0x20
;----------------------------------------------------------------------
;//gb//MAXOPT5  DB   2                 ;Field 5 - SPACE_A0
MAXOPT5  DB   1                 ;Field 5 - SPACE_A0
;----------------------------------------------------------------------
MAXOPT6  DB   2                 ;Field 6 - WHICHPTR
MAXOPT7  DB   4                 ;Field 7 - PRT_XLAT
MAXOPT8  DB   4                 ;Field 8 - PCOMPOSE


MSG22 LABEL BYTE
FLD0_MSG1 DB _PHO_SAMPHAO,_SARA_AA,_SO_RUSI,_SARA_AA,_O_ANG,_MAI_HAN_AKAT,_NGO_NGU,_KO_KAI,_RU,_SO_RUSI,_SPACE,_SPACE,_SPACE,END_OF_STRING
FLD0_MSG2 DB _SARA_MAI_MALAI,_THO_THAHAN,_YO_YAK,_SPACE,_8,_SPACE,_BO_BAIMAI,_RO_RUA,_RO_RUA,_THO_THAHAN,_MAI_HAN_AKAT,_DO_DEK,_SPACE,END_OF_STRING
FLD0_MSG3 DB _SARA_MAI_MALAI,_THO_THAHAN,_YO_YAK,_SPACE,_2,_5,_SPACE,_BO_BAIMAI,_RO_RUA,_RO_RUA,_THO_THAHAN,_MAI_HAN_AKAT,_DO_DEK,END_OF_STRING

FLD1_MSG0 DB _SO_SUA,_PERIOD,_MO_MA,_PERIOD,_O_ANG,_PERIOD,7 DUP(_SPACE),END_OF_STRING
FLD1_MSG1 DB 13 DUP(_SPACE),END_OF_STRING      ;Blank - filled by program

FLD2_MSG0 DB _SARA_MAI_MALAI,_MO_MA,_MAI_EK,_CHO_CHANG,_DO_DEK,_SARA_E,_CHO_CHANG,_YO_YAK,_SO_SUA,_RO_RUA,_SARA_A,_SPACE,_SPACE,END_OF_STRING
FLD2_MSG1 DB _PHO_PHAN,_BO_BAIMAI,_SPACE,_1,_SPACE,s_,p_,a_,c_,e_,_SPACE,_SPACE,_SPACE,END_OF_STRING
FLD2_MSG2 DB _PHO_PHAN,_BO_BAIMAI,_SPACE,_2,_SPACE,s_,p_,a_,c_,e_,s_,_SPACE,_SPACE,END_OF_STRING
FLD2_MSG3 DB _PHO_PHAN,_BO_BAIMAI,_SPACE,_3,_SPACE,s_,p_,a_,c_,e_,s_,_SPACE,_SPACE,END_OF_STRING
FLD2_MSG4 DB _PHO_PHAN,_BO_BAIMAI,_SPACE,_4,_SPACE,s_,p_,a_,c_,e_,s_,_SPACE,_SPACE,END_OF_STRING
FLD2_MSG5 DB _PHO_PHAN,_BO_BAIMAI,_SPACE,_5,_SPACE,s_,p_,a_,c_,e_,s_,_SPACE,_SPACE,END_OF_STRING
FLD2_MSG6 DB _PHO_PHAN,_BO_BAIMAI,_SPACE,_6,_SPACE,s_,p_,a_,c_,e_,s_,_SPACE,_SPACE,END_OF_STRING
FLD2_MSG7 DB _PHO_PHAN,_BO_BAIMAI,_SPACE,_7,_SPACE,s_,p_,a_,c_,e_,s_,_SPACE,_SPACE,END_OF_STRING

FLD3_MSG0 DB _PHO_SAMPHAO,_SARA_AA,_SO_RUSI,_SARA_AA,_O_ANG,_MAI_HAN_AKAT,_NGO_NGU,_KO_KAI,_RU,_SO_RUSI,_SPACE,_SPACE,_SPACE,END_OF_STRING
FLD3_MSG1 DB _SARA_MAI_MALAI,_THO_THAHAN,_YO_YAK,_SARA_E,_KO_KAI,_SO_RUSI,_MO_MA,_NO_NEN,_SARA_II,_SPACE,_SPACE,_SPACE,_SPACE,END_OF_STRING
FLD3_MSG2 DB 13 DUP(_SPACE),END_OF_STRING      ;Blank - filled by program

FLD4_MSG0 DB _TO_TAO,_MAI_HAN_AKAT,_WO_WAEN,_SARA_E,_LO_LING,_KHO_KHAI,_SPACE,_SPACE,_SPACE,_SPACE,_SPACE,_SPACE,_SPACE,END_OF_STRING
FLD4_MSG1 DB _SARA_E,_SO_SUA,_MAI_THO,_NO_NU,_SARA_E,_DO_DEK,_SARA_II,_MAI_EK,_YO_YAK,_WO_WAEN,_SPACE,_SPACE,_SPACE,END_OF_STRING
FLD4_MSG2 DB _SARA_E,_SO_SUA,_MAI_THO,_NO_NU,_KHO_KHWAI,_SARA_UU,_MAI_EK,_SPACE,_SPACE,_SPACE,_SPACE,_SPACE,_SPACE,END_OF_STRING
FLD4_MSG3 DB _TO_TAO,_MAI_HAN_AKAT,_WO_WAEN,_SARA_EE,_RO_RUA,_SARA_E,_NGO_NGU,_SARA_AA,_SPACE,_SPACE,_SPACE,_SPACE,_SPACE,END_OF_STRING

;======================================================================
; Space character - A0H or 20H
;======================================================================
FLD5_MSG0 DB _2,_0,_H,10 DUP(_SPACE),END_OF_STRING
;//GB//FLD5_MSG1 DB _A,_0,_H,10 DUP(_SPACE),END_OF_STRING

;======================================================================
; Which printer?
; 1. Epson
; 2. IBM Pro.
;======================================================================
FLD6_MSG0 DB _E,p_,s_,o_,n_,_SPACE,_L,_Q,_HYPHEN,_5,_5,_0,_SPACE,END_OF_STRING
FLD6_MSG1 DB _I,_B,_M,_SPACE,_P,r_,o_,_PERIOD,_SPACE,_SPACE,_SPACE,_SPACE,_SPACE,END_OF_STRING

FLD7_MSG0 DB _SO_SUA,_PERIOD,_MO_MA,_PERIOD,_O_ANG,_PERIOD,_SPACE,_SPACE,_SPACE,_SPACE,_SPACE,_SPACE,_SPACE,END_OF_STRING
FLD7_MSG1 DB 13 DUP(_SPACE),END_OF_STRING      ;Blank - filled by program
FLD7_MSG2 DB _SO_SUA,_PERIOD,_MO_MA,_PERIOD,_O_ANG,_PERIOD,_SPACE,_TO_TAO,_MAI_EK,_O_ANG,_HO_HIP,_MAI_HAN_AKAT,_WO_WAEN,END_OF_STRING
FLD7_MSG3 DB 13 DUP(_SPACE),END_OF_STRING      ;Blank - filled by program

FLD8_MSG0 DB _PHO_SAMPHAO,_SARA_AA,_SO_RUSI,_SARA_AA,_O_ANG,_MAI_HAN_AKAT,_NGO_NGU,_KO_KAI,_RU,_SO_RUSI,_SPACE,_SPACE,_SPACE,END_OF_STRING
FLD8_MSG1 DB _SARA_MAI_MALAI,_THO_THAHAN,_YO_YAK,_SPACE,_1,_SPACE,_RO_RUA,_SARA_A,_DO_DEK,_MAI_HAN_AKAT,_BO_BAIMAI,_SPACE,_SPACE,END_OF_STRING
FLD8_MSG2 DB _SARA_MAI_MALAI,_THO_THAHAN,_YO_YAK,_SPACE,_3,_SPACE,_RO_RUA,_SARA_A,_DO_DEK,_MAI_HAN_AKAT,_BO_BAIMAI,_SPACE,_SPACE,END_OF_STRING
FLD8_MSG3 DB _SARA_MAI_MALAI,_THO_THAHAN,_YO_YAK,_SPACE,_4,_SPACE,_RO_RUA,_SARA_A,_DO_DEK,_MAI_HAN_AKAT,_BO_BAIMAI,_SPACE,_SPACE,END_OF_STRING

CUR_FLD  DB   0                 ;CURRENT MENU FIELD

;======================================================================
; Critical Error Handler
;======================================================================
CRIT_ERR PROC NEAR
        CALL  BEEP
        XOR   AL,AL
        IRET                    ;Return from interrupt.
CRIT_ERR ENDP

;------------------------------------------------------------
SAVE_SCREEN PROC  NEAR
;------------------------------------------------------------
         MOV   AX,BIOS_SEG                      ;POINT DS TO BIOS DATA AREA
         MOV   DS,AX
         MOV   AX,WORD PTR DS:[BIOS_CURSOR_ADDRESS]      ;Get cursor position for video page 0
         MOV   WORD PTR CS:[CURSOR_SAVE],AX
;         MOV   DS,CS:[VID_SEG]
;         MOV   BYTE PTR DS:[7FFFH],0
         MOV  CS:VMODEFLAG, 0 ;//TEST//
         CMP   CS:[DISPMODE],ENGLISH
         JNZ   @@Exit
         MOV   AX,CS
         MOV   ES,AX
         XOR   SI,SI
         MOV   DI,OFFSET VID_SAVE
         MOV   CX,SCREEN_SIZE
         REPZ MOVSW              ;Move wrd, DS:SI to ES:DI ++.
         MOV   CS:[DISPMODE],THAI_25
         MOV   AX,3
         CALL  CS:[L04EAH]
         MOV   CS:[DISPMODE],ENGLISH
@@Exit:
         MOV   ES,WORD PTR CS:[VIDBUF]
         MOV   AX,CS
         MOV   DS,AX
         RET
SAVE_SCREEN ENDP

;------------------------------------------------------------
RESTORE_SCREEN PROC NEAR
;------------------------------------------------------------
         MOV   DX,GRAPHICS_ADDRESS_REG
         MOV   AX,1 
         OUT   DX,AX
         CMP   CS:[DISPMODE],ENGLISH
         JNZ   NOT_MODE_0
         MOV   AX,3
         CALL  CS:[L04EAH]
NOT_MODE_0:  
         PUSH   CS
         POP    DS
         MOV   ES,[VID_SEG]
         MOV   SI,OFFSET VID_SAVE
         XOR   DI,DI
         MOV   CX,SCREEN_SIZE
RESTORE_LOOP:  
         LODSW                          ;Load AX with wrd at DS:SI ++.
         AND   AH,7FH                   ;Strip high bit of AH
         STOSW                          ;Store wrd in AX in ES:DI ++.
         LOOP  RESTORE_LOOP             ;Dec CX, loop if CX<>0.
         MOV   DX,WORD PTR [CURSOR_SAVE] ;Restore cursor position
         XOR   BH,BH
         MOV   AH,VID_SET_CURSOR_POS     ;BIOS set Cursor position
         PUSHF                           ;Push flag register.
         CALL  DWORD PTR CS:[OLDINT10]   ;Call original vid int
;         MOV   BYTE PTR ES:[7FFFH],3
         MOV CS:VMODEFLAG,3 ;//TEST//
         MOV   AX,CS
         MOV   ES,AX
         MOV   DI,OFFSET VID_SAVE
         MOV   CX,SCREEN_SIZE
         REPZ STOSW              ;Store wrd in AX in ES:DI ++.
         RET
RESTORE_SCREEN ENDP

;======================================================================
; Display Control Panel to allow user to change
; configuration parameters
;======================================================================
PANEL PROC  NEAR    ;POP UP CONTROL PANEL
         mov  ah,25h
         mov  al,24h
         push cs
         pop  ds
         mov  dx,offset CRIT_ERR
         int  21h

         CALL  SAVE_SCREEN
         MOV   [MENU_LEFT_COLUMN],PANEL_LEFT_COLUMN
         MOV   [MENU_TOP_ROW],PANEL_TOP_ROW
         MOV   [MENU_WIDTH],PANEL_WIDTH
         MOV   [MENU_HEIGHT],PANEL_HEIGHT
         MOV   [MENU_FRAME_WIDTH],PANEL_FRAME_WIDTH
         MOV   [MENU_EDGE_WIDTH],PANEL_EDGE_WIDTH
         MOV   [MENU_FRAME_COLOR],PANEL_FRAME_COLOR
         MOV   [MENU_BACKGROUND_COLOR],PANEL_BG_COLOR
         MOV   [MENU_EDGE_COLOR],PANEL_EDGE_COLOR
         MOV   [MENU_SHADOW_COLOR],PANEL_SHADOW_COLOR
         MOV   [MENU_TITLE_MSG],OFFSET MSG_GTHAI
         CALL  DO_MENU
;----------------------------------------------------------------------
; Show BBS message
;----------------------------------------------------------------------  
         MOV   AX,BBSMSG_SHADOW
         CALL  [SET_SHADOW_COLOR]
         MOV   AX,BBSMSG_EDGE
         CALL  [SET_EDGE_COLOR]
         MOV   CX,WORD PTR [BBSMSG_COLUMN]
         MOV   DX,BBSMSG_ROW
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,(BBSMSG_LEN*8)+2
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,CHAR_HEIGHT
         CALL  DRAW_LINE
         MOV   AX,BBSMSG_SHADOW
         CALL  [SET_EDGE_COLOR]
         MOV   CX,WORD PTR [BBSMSG_COLUMN]
         ADD  CX,(BBSMSG_LEN*8)+1
         MOV   DX,BBSMSG_ROW+CHAR_HEIGHT
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,-((BBSMSG_LEN*8)+1)         ;-113
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,-CHAR_HEIGHT
         CALL  DRAW_LINE
         MOV   [TEXT_COLOR],BBSMSG_TEXT_COLOR
         MOV   CX,WORD PTR [BBSMSG_COLUMN]
         INC   CX
         MOV   DX,BBSMSG_ROW+1                  ;226
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET MSG_BBS
         CALL  DO_MSG

         MOV   AX,BLACK
         CALL  [SET_SHADOW_COLOR]
         MOV   CX,10
         MOV   DX,30
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   AX,BLACK
         CALL  [SET_EDGE_COLOR]
         MOV   CX,250
         MOV   DX,168
         CALL  L42A8H
         MOV   AX,BLACK
         CALL  [SET_EDGE_COLOR]
         MOV   CX,250
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,168
         CALL  DRAW_LINE
         MOV   AX,WHITE
         CALL  [SET_EDGE_COLOR]
         MOV   CX,260
         MOV   DX,198
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,-250
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,-168
         CALL  DRAW_LINE
         MOV   AX,BLACK
         CALL  [SET_SHADOW_COLOR]
         MOV   CX,280
         MOV   DX,30
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   AX,BLACK
         CALL  [SET_EDGE_COLOR]
         MOV   CX,250
         MOV   DX,168
         CALL  L42A8H
         MOV   AX,BLACK
         CALL  [SET_EDGE_COLOR]
         MOV   CX,250
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,168
         CALL  DRAW_LINE
         MOV   AX,WHITE
         CALL  [SET_EDGE_COLOR]
         MOV   CX,530
         MOV   DX,198
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,-250
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,-168
         CALL  DRAW_LINE
;----------------------------------------------------------------------  
; Show SETTING button
;----------------------------------------------------------------------  
         MOV   AX,MSG_SETTING_SHADOW
         CALL  [SET_SHADOW_COLOR]
         MOV   AX,MSG_SETTING_EDGE
         CALL  [SET_EDGE_COLOR]
         MOV   CX,MSG_SETTING_X
         MOV   DX,MSG_SETTING_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,(MSG_SETTING_LEN*8)+2
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,CHAR_HEIGHT
         CALL  DRAW_LINE
         MOV   AX,MSG_SETTING_SHADOW
         CALL  [SET_EDGE_COLOR]
         MOV   CX,MSG_SETTING_X+(MSG_SETTING_LEN*8)+1
         MOV   DX,MSG_SETTING_Y+CHAR_HEIGHT
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,-((MSG_SETTING_LEN*8)+1)
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,-CHAR_HEIGHT
         CALL  DRAW_LINE
         MOV   [TEXT_COLOR],MSG_SETTING_TEXT_COLOR
         MOV   CX,MSG_SETTING_X+1
         MOV   DX,MSG_SETTING_Y+1
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET MSG_SETTING
         CALL  DO_MSG
;----------------------------------------------------------------------  
; Show HELPING button
;----------------------------------------------------------------------
         MOV   AX,MSG_HELPING_SHADOW
         CALL  [SET_SHADOW_COLOR]
         MOV   AX,MSG_HELPING_EDGE
         CALL  [SET_EDGE_COLOR]
         MOV   CX,MSG_HELPING_X
         MOV   DX,MSG_HELPING_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,(MSG_HELPING_LEN*8)+2
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,CHAR_HEIGHT
         CALL  DRAW_LINE
         MOV   AX,MSG_HELPING_SHADOW
         CALL  [SET_EDGE_COLOR]
         MOV   CX,MSG_HELPING_X+(MSG_HELPING_LEN*8)+1
         MOV   DX,MSG_HELPING_Y+CHAR_HEIGHT
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,-((MSG_HELPING_LEN*8)+1)
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,-CHAR_HEIGHT
         CALL  DRAW_LINE
         MOV   [TEXT_COLOR],MSG_HELPING_TEXT_COLOR
         MOV   CX,MSG_HELPING_X+1
         MOV   DX,MSG_HELPING_Y+1
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET PANEL_MSG_HELPING
         CALL  DO_MSG
;----------------------------------------------------------------------  
; Show VERSION button
;----------------------------------------------------------------------
         MOV   AX,BLACK
         CALL  [SET_SHADOW_COLOR]
         MOV   AX,BRIGHT_WHITE
         CALL  [SET_EDGE_COLOR]
         MOV   CX,MSG_VERSION_X
         MOV   DX,MSG_VERSION_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,(P_MSG_VERSION_LEN*8)+2
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,CHAR_HEIGHT
         CALL  DRAW_LINE
         MOV   AX,MSG_VERSION_SHADOW
         CALL  [SET_EDGE_COLOR]
         MOV   CX,MSG_VERSION_X+(P_MSG_VERSION_LEN*8)+1
         MOV   DX,MSG_VERSION_Y+CHAR_HEIGHT
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,-((P_MSG_VERSION_LEN*8)+1)
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,-CHAR_HEIGHT
         CALL  DRAW_LINE
         MOV   [TEXT_COLOR],MSG_VERSION_TEXT_COLOR
         MOV   CX,MSG_VERSION_X+1
         MOV   DX,MSG_VERSION_Y+1
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET PANEL_MSG_VERSION
         CALL  DO_MSG

;----------------------------------------------------------------------
; Show F2 - SAVE OPTIONS button
;----------------------------------------------------------------------  
         MOV   AX,MSG_F2_SHADOW
         CALL  [SET_SHADOW_COLOR]
         MOV   AX,MSG_F2_EDGE
         CALL  [SET_EDGE_COLOR]
         MOV   CX,MSG_F2_X
         MOV   DX,MSG_F2_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,(MSG_F2_LEN*8)+2
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,CHAR_HEIGHT
         CALL  DRAW_LINE
         MOV   AX,MSG_F2_SHADOW
         CALL  [SET_EDGE_COLOR]
         MOV   CX,MSG_F2_X+(MSG_F2_LEN*8)+1
         MOV   DX,MSG_F2_Y+CHAR_HEIGHT
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,-((MSG_F2_LEN*8)+1)
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,-CHAR_HEIGHT
         CALL  DRAW_LINE
         MOV   [TEXT_COLOR],MSG_F2_TEXT_COLOR
         MOV   CX,MSG_F2_X+1
         MOV   DX,MSG_F2_Y+1
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET PANEL_MSG_F2
         CALL  DO_MSG
;----------------------------------------------------------------------
; Show ESC button
;----------------------------------------------------------------------  
         MOV   AX,BLACK 
         CALL  [SET_SHADOW_COLOR]
         MOV   AX,BRIGHT_WHITE  
         CALL  [SET_EDGE_COLOR]
         MOV   CX,ESC_MSG_X
         MOV   DX,ESC_MSG_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,(P_ESC_MSG_LEN*8)+2
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,CHAR_HEIGHT
         CALL  DRAW_LINE
         MOV   AX,BLACK
         CALL  [SET_EDGE_COLOR]
         MOV   CX,ESC_MSG_X+(P_ESC_MSG_LEN*8)+1
         MOV   DX,ESC_MSG_Y+CHAR_HEIGHT
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,-((P_ESC_MSG_LEN*8)+1)
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,-CHAR_HEIGHT
         CALL  DRAW_LINE
         MOV   [TEXT_COLOR],(WHITE_BG + BLACK)
         MOV   CX,ESC_MSG_X+1
         MOV   DX,ESC_MSG_Y+1
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET PANEL_MSG_ESC
         CALL  DO_MSG
;----------------------------------------------------------------------
; Display KEYTICK message
;----------------------------------------------------------------------  
         MOV   [TEXT_COLOR],PANEL_TEXT_COLOR
         MOV   CX,MSG_KEYTICK_X
         MOV   DX,MSG_KEYTICK_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET MSG_KEYTICK
         CALL  DO_MSG
;----------------------------------------------------------------------  
; Display CTRL-TICK message
;----------------------------------------------------------------------
         MOV   CX,MSG_CTRLTICK_X
         MOV   DX,MSG_CTRLTICK_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET MSG_CTRLTICK
         CALL  DO_MSG
;----------------------------------------------------------------------  
; Display ALT-TICK message
;----------------------------------------------------------------------
         MOV   CX,MSG_ALTTICK_X
         MOV   DX,MSG_ALTTICK_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET MSG_ALTTICK
         CALL  DO_MSG
;----------------------------------------------------------------------
; Display BACKSLASH message
;----------------------------------------------------------------------  
         MOV   CX,MSG_BACKSLASH_X
         MOV   DX,MSG_BACKSLASH_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET MSG_BACKSLASH
         CALL  DO_MSG
;----------------------------------------------------------------------
; Display FIELD1_PROMPT
;----------------------------------------------------------------------  
         MOV   CX,FIELD1_PROMPT_X
         MOV   DX,FIELD1_PROMPT_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET FIELD1_PROMPT
         CALL  DO_MSG
;----------------------------------------------------------------------
; Display FIELD2_PROMPT
;----------------------------------------------------------------------  
         MOV   CX,FIELD2_PROMPT_X
         MOV   DX,FIELD2_PROMPT_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET FIELD2_PROMPT
         CALL  DO_MSG
;----------------------------------------------------------------------
; Display FIELD3_PROMPT
;----------------------------------------------------------------------  
         MOV   CX,FIELD3_PROMPT_X
         MOV   DX,FIELD3_PROMPT_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET FIELD3_PROMPT
         CALL  DO_MSG
;----------------------------------------------------------------------
; Display FIELD4_PROMPT
;----------------------------------------------------------------------  
         MOV   CX,FIELD4_PROMPT_X
         MOV   DX,FIELD4_PROMPT_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET FIELD4_PROMPT
         CALL  DO_MSG
;----------------------------------------------------------------------
; Display FIELD5_PROMPT
;----------------------------------------------------------------------  
         MOV   CX,FIELD5_PROMPT_X
         MOV   DX,FIELD5_PROMPT_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET FIELD5_PROMPT
         CALL  DO_MSG
;----------------------------------------------------------------------
; Display PROMPT_SPACE prompt (field 6)
;----------------------------------------------------------------------  
         MOV   CX,PROMPT_SPACE_X
         MOV   DX,PROMPT_SPACE_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET PROMPT_SPACE
         CALL  DO_MSG
;----------------------------------------------------------------------
; Display FIELD7_PROMPT
;----------------------------------------------------------------------  
         MOV   CX,FIELD7_PROMPT_X
         MOV   DX,FIELD7_PROMPT_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET FIELD7_PROMPT
         CALL  DO_MSG
;----------------------------------------------------------------------
; Display FIELD8_PROMPT
;----------------------------------------------------------------------  
         MOV   CX,FIELD8_PROMPT_X
         MOV   DX,FIELD8_PROMPT_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET FIELD8_PROMPT
         CALL  DO_MSG
;----------------------------------------------------------------------
; Display FIELD9_PROMPT
;----------------------------------------------------------------------  
         MOV   CX,FIELD9_PROMPT_X
         MOV   DX,FIELD9_PROMPT_Y
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET FIELD9_PROMPT
         CALL  DO_MSG
;----------------------------------------------------------------------
OPTION_FIELD_X = 150
;----------------------------------------------------------------------
PANEL_KEY_ENTRY:
         MOV   BX,8H
DISPLOOP:
         MOV   AL,BYTE PTR [BX]+OFFSET OPTION_TABLE
         MOV   SI,BX
FLDLOOP: 
         DEC   SI
         JL    SKIP1             ;All fields done, exit loop
         ADD   AL,BYTE PTR [SI]+MAXOPT0
         JMP   SHORT FLDLOOP     ;Loop through all fields
SKIP1:   
         MOV   CL,14             ;Length of field messages
         MUL   CL                ;Multiply AL * 14
         MOV   SI,OFFSET MSG22
         ADD   SI,AX
         MOV   CX,OPTION_FIELD_X
         MOV   DX,BX
         SHL   DX,1
         SHL   DX,1
         SHL   DX,1
         SHL   DX,1
         ADD   DX,40
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         CALL  DO_MSG
         DEC   BX
         JGE   DISPLOOP
MENULOOP:
         MOV   AX,YELLOW
         CALL  [SET_EDGE_COLOR]
         MOV   CX,142
         XOR   DH,DH
         MOV   DL,[CUR_FLD]
         SHL   DX,1
         SHL   DX,1
         SHL   DX,1
         SHL   DX,1
         ADD   DX,40
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,14
         CALL  L441CH

L3FB2H:  
         MOV   AH,KBD_STATUS              ;Check kbd status
         INT   16H               ;Call keyboard
         JZ    L3FB2H            ;No keys ready, go around
         XOR   AH,AH             ;Keyboard read
         INT   16H               ;Get key
         PUSH  AX                ;Save it.
         MOV   CX,14
         CALL  L441CH
         POP   AX                ;Restore key
         CMP   AX,11BH           ;ESC key?
         JZ    PANEL_EXIT            ;Take down popup menu and return
         CMP   AX,4800H          ;UP ARROW?
         JNZ   NOTUPARW          ;No, go around
         DEC   [CUR_FLD]         ;Decrement field number
         JNS   MENULOOP          ;Didn't go neg, so get next key
         MOV   [CUR_FLD],8       ;Went neg, wrap to bottom
         JMP   SHORT MENULOOP    ;Get another key
NOTUPARW:
         CMP   AX,5000H          ;DOWN ARROW?
         JNZ   NOTDNARW          ;No, go around
         INC   [CUR_FLD]         ;Increment field number
         CMP   [CUR_FLD],8       ;Greater than 8?
         JBE   MENULOOP          ;No, get another key
         MOV   [CUR_FLD],AL      ;Wrap to field 0
         JMP   SHORT MENULOOP    ;Get another key
NOTDNARW:
         CMP   AX,4B00H          ;LEFT ARROW?
         JNZ   NOTLFARW          ;No, go around
         XOR   BH,BH
         MOV   BL,[CUR_FLD]
         DEC   BYTE PTR [BX]+OPTION_TABLE;Decrement field value
         JNS   LFT_DONE          ;Below zero? No, go ahead
         MOV   AL,BYTE PTR [BX]+MAXOPT0;Yes, wrap to max value
         DEC   AX                ;Decrement value
         MOV   BYTE PTR [BX]+OPTION_TABLE,AL;Store new value
LFT_DONE:
         JMP  PANEL_KEY_ENTRY

NOTLFARW:
         CMP   AX,4D00H          ;RIGHT ARROW?
         JZ    INCR_FLD          ;Yes, go do it
         CMP   AX,1C0DH          ;RETURN KEY?
         JNZ   NOT_INCR          ;NO, go around
INCR_FLD:
         XOR   BH,BH
         MOV   BL,[CUR_FLD]      ;Get current field number
         INC   BYTE PTR [BX]+OPTION_TABLE;Increment value
         MOV   AL,BYTE PTR [BX]+OPTION_TABLE;Get new value
         CMP   AL,BYTE PTR [BX]+MAXOPT0;New value too large?
         JC    VAL_OK            ;No, go around
         MOV   BYTE PTR [BX]+OPTION_TABLE,BH
VAL_OK: 
         JMP PANEL_KEY_ENTRY

NOT_INCR:
         CMP   AX,3C00H          ;F2 KEY?
         JNZ   MENU_END          ;NO, go around
         CALL  STORE_OPTIONS           ;Write new values to GTHAI.COM

MENU_END:
         JMP   MENULOOP          ;Back to menu loop

PANEL_EXIT:  
         mov  ah,25h
         mov  al,24h
         lds  dx,dword ptr cs:[oldint24]
         int  21h
         JMP   RESTORE_SCREEN           ;RFT
PANEL ENDP
;----------------------------------------------------------------------
; Control panel message area
;----------------------------------------------------------------------
MSG_GTHAI   DB  _SPACE,_G,t_,h_,a_,i_,_SPACE,_HYPHEN,_SPACE
            DB  _2,_5,_SPACE,_L,i_,n_,e_,_SPACE,_T,h_,a_,i_,_SPACE
            DB  _D,i_,s_,p_,l_,a_,y_,_SPACE,a_,n_,d_,_SPACE,_P,r_,i_,n_,t_
            DB  _SPACE
            DB  _D,r_,i_,v_,e_,r_,_SPACE
MSG_GTHAI_LEN = $-MSG_GTHAI
            DB END_OF_STRING

;----------------------------------------------------------------------
MSG_SETTING_X = 95
MSG_SETTING_Y = 9
MSG_SETTING_SHADOW = BLACK
MSG_SETTING_EDGE = BRIGHT_WHITE
MSG_SETTING_TEXT_COLOR = (WHITE_BG + BLACK)
MSG_SETTING DB  _SPACE,_S,_E,_T,_T,_I,_N,_G,_S,_SPACE
MSG_SETTING_LEN = $-MSG_SETTING
            DB END_OF_STRING
;----------------------------------------------------------------------
MSG_HELPING_X = 375
MSG_HELPING_Y = 9
MSG_HELPING_SHADOW = BLACK
MSG_HELPING_EDGE = BRIGHT_WHITE
MSG_HELPING_TEXT_COLOR = (WHITE_BG + BLACK)

PANEL_MSG_HELPING DB _SPACE,_H,_O,_T,_SPACE,_K,_E,_Y,_S,_SPACE
MSG_HELPING_LEN = $-PANEL_MSG_HELPING
            DB END_OF_STRING

;----------------------------------------------------------------------
MSG_VERSION_X = 199
MSG_VERSION_Y = 209
MSG_VERSION_SHADOW = BLACK
MSG_VERSION_EDGE = BRIGHT_WHITE
MSG_VERSION_TEXT_COLOR = (WHITE_BG + BLACK)

PANEL_MSG_VERSION DB _SPACE,_V,e_,r_,s_,i_,o_,n_,_SPACE
                  VERSION_ENCODED
                  DB   _SPACE
P_MSG_VERSION_LEN = $-PANEL_MSG_VERSION
                  DB END_OF_STRING

;----------------------------------------------------------------------
MSG06_X = 215
MSG06_Y = 225
MSG06_EDGE = BRIGHT_WHITE
MSG06_SHADOW = BLACK
MSG06_TEXT_COLOR = (WHITE_BG+BLACK)

MSG06 DB   _SPACE,_THAI_ONE,_SPACE,_TO_TAO,_SARA_U,_LO_LING
      DB   _SARA_AA,_KHO_KHWAI,_MO_MA,_SPACE,_THAI_TWO,_THAI_FIVE
      DB   _THAI_THREE,_THAI_THREE,_SPACE
MSG06_LEN = $-MSG06-1               ;Don't Count vowel _SARA_U
      DB END_OF_STRING

;----------------------------------------------------------------------
MSG_F2_X = 23
MSG_F2_Y = 225
MSG_F2_EDGE = BRIGHT_WHITE
MSG_F2_SHADOW = BLACK
MSG_F2_TEXT_COLOR = (WHITE_BG+BLACK)

PANEL_MSG_F2   DB   _SPACE,_F,_2,_SPACE
               DB _HYPHEN,_SPACE
               DB _S,a_,v_,e_,_SPACE,_S,e_,t_,t_,i_,n_,g_,s_,_SPACE
MSG_F2_LEN = $-PANEL_MSG_F2
              DB  END_OF_STRING

;----------------------------------------------------------------------
ESC_MSG_X = 383      ;423
ESC_MSG_Y = 225
PANEL_MSG_ESC DB _SPACE,_E,_S,_C,_SPACE,_HYPHEN,_SPACE,_E,x_,i_,t_,_SPACE
P_ESC_MSG_LEN = $-PANEL_MSG_ESC
              DB  END_OF_STRING

;----------------------------------------------------------------------
PANEL_TEXT_COLOR = (BLACK_BG+WHITE)
;----------------------------------------------------------------------
MSG_KEYTICK_X = 310
MSG_KEYTICK_y = 40
MSG_KEYTICK DB   _K,e_,y_,_SPACE,_LEFT_TICK,_SPACE
            DB   _SPACE,_SPACE,_SPACE,_SPACE,_SPACE,_SPACE
            DB   _SARA_MAI_MALAI,_THO_THAHAN,_YO_YAK,_SLASH,_O_ANG,_MAI_HAN_AKAT
            DB   _NGO_NGU,_KO_KAI,_RU,_SO_RUSI
MSG_KEYTICK_LEN = $-MSG_KEYTICK
            DB   END_OF_STRING

;----------------------------------------------------------------------
MSG_CTRLTICK_X = 310
MSG_CTRLTICK_Y = 56
MSG_CTRLTICK   DB   _K,e_,y_,_SPACE,_C,t_,r_,l_,_PLUS,_LEFT_TICK
               DB   _SPACE,_SPACE
               DB   _SARA_E,_KHO_KHAI,_MAI_THO,_SARA_AA,_SO_SUA,_SARA_UU
               DB   _MAI_EK,_THAI_SPACE,m_,e_,n_,u_
MSG_CTRLTICK_LEN = $-MSG_CTRLTICK
               DB   END_OF_STRING

;----------------------------------------------------------------------
MSG_ALTTICK_X = 310
MSG_ALTTICK_Y = 72
MSG_ALTTICK   DB   _K,e_,y_,_SPACE,_A,l_,t_,_PLUS,_LEFT_TICK
              DB   _SPACE,_SPACE,_SPACE
              DB   _SARA_E,_LO_LING,_SARA_I,_KO_KAI,_RO_RUA,_SARA_A
              DB   _BO_BAIMAI,_BO_BAIMAI,_PHO_SAMPHAO,_SARA_AA,_SO_RUSI,_SARA_AA
              DB   _SARA_MAI_MALAI,_THO_THAHAN,_YO_YAK
MSG_ALTTICK_LEN = $-MSG_ALTTICK
            DB END_OF_STRING

;----------------------------------------------------------------------
MSG_BACKSLASH_X = 310
MSG_BACKSLASH_Y = 88
MSG_BACKSLASH DB   _K,e_,y_,_SPACE,_SARA_MAI_MALAI,_THO_THAHAN
              DB   _YO_YAK,_PLUS,_BACKSLASH,_SPACE,_SPACE,_SPACE
              DB   _TO_TAO,_MAI_HAN_AKAT,_WO_WAEN,_O_ANG,_MAI_HAN_AKAT,_KO_KAI
              DB   _SO_RUSI,_RO_RUA,_SPACE,_LEFT_TICK
MSG_BACKSLASH_LEN = $-MSG_BACKSLASH
            DB END_OF_STRING

;----------------------------------------------------------------------
FIELD1_PROMPT_X = 22
FIELD1_PROMPT_Y = 40
FIELD1_PROMPT    DB   _KO_KAI,_SARA_AA,_RO_RUA,_SARA_EE,_SO_SUA,_DO_DEK
         DB   _NGO_NGU,_PHO_PHUNG,_LO_LING,_CHO_CHAN,_O_ANG,_PHO_SAMPHAO
         DB   _SARA_AA,_PHO_PHAN
FIELD1_PROMPT_LEN = $-FIELD1_PROMPT
            DB END_OF_STRING

;----------------------------------------------------------------------
FIELD2_PROMPT_X = 22
FIELD2_PROMPT_Y = 56
FIELD2_PROMPT   DB   _RO_RUA,_HO_HIP,_MAI_HAN_AKAT,_SO_SUA,_PHO_SAMPHAO,_SARA_AA
        DB   _SO_RUSI,_SARA_AA,_SARA_MAI_MALAI,_THO_THAHAN,_YO_YAK
FIELD2_PROMPT_LEN = $-FIELD2_PROMPT
            DB END_OF_STRING

;----------------------------------------------------------------------
FIELD3_PROMPT_X = 22
FIELD3_PROMPT_Y = 72
FIELD3_PROMPT   DB   _CHO_CHAN,_SARA_AM,_NO_NU,_WO_WAEN,_NO_NU,_CHO_CHANG
        DB   _DO_DEK,_SARA_E,_CHO_CHANG,_YO_YAK,_SO_SUA,_RO_RUA
        DB   _SARA_A
FIELD3_PROMPT_LEN = $-FIELD3_PROMPT
            DB END_OF_STRING

;----------------------------------------------------------------------
FIELD4_PROMPT_X = 22
FIELD4_PROMPT_Y = 88
FIELD4_PROMPT   DB   _SARA_EE,_PO_PLA,_MAI_THO,_NO_NU,_PHO_PHAN,_SARA_I
        DB   _MO_MA,_PHO_PHAN,_THANTHAKHAT
FIELD4_PROMPT_LEN = $-FIELD4_PROMPT
            DB END_OF_STRING

;----------------------------------------------------------------------
FIELD5_PROMPT_X = 22
FIELD5_PROMPT_Y = 104
FIELD5_PROMPT   DB   _TO_TAO,_MAI_HAN_AKAT,_WO_WAEN,_TO_TAO,_SARA_II,_KO_KAI
        DB   _RO_RUA,_O_ANG,_BO_BAIMAI
FIELD5_PROMPT_LEN = $-FIELD5_PROMPT
        DB END_OF_STRING

;----------------------------------------------------------------------
PROMPT_SPACE_X = 22
PROMPT_SPACE_Y = 120
PROMPT_SPACE DB   _S,p_,a_,c_,e_,_SPACE
          DB   _PHO_SAMPHAO,_SARA_AA,_SO_RUSI,_SARA_AA,_SARA_MAI_MALAI,_THO_THAHAN
          DB   _YO_YAK
PROMPT_SPACE_LEN = $-PROMPT_SPACE
          DB END_OF_STRING

;----------------------------------------------------------------------
FIELD7_PROMPT_X = 22
FIELD7_PROMPT_Y = 136
FIELD7_PROMPT   DB   _CHO_CHANG,_NO_NU,_SARA_I,_DO_DEK,_SARA_E,_KHO_KHWAI
        DB   _RO_RUA,_SARA_UEE,_MAI_EK,_O_ANG,_NGO_NGU,_PHO_PHAN
        DB   _SARA_I,_MO_MA,_PHO_PHAN,_THANTHAKHAT
FIELD7_PROMPT_LEN = $-FIELD7_PROMPT
        DB END_OF_STRING

;----------------------------------------------------------------------
FIELD8_PROMPT_X = 22
FIELD8_PROMPT_Y = 152
FIELD8_PROMPT   DB   _RO_RUA,_HO_HIP,_MAI_HAN_AKAT,_SO_SUA,_SARA_E,_KHO_KHWAI
        DB   _RO_RUA,_SARA_UEE,_MAI_EK,_O_ANG,_NGO_NGU,_PHO_PHAN
        DB   _SARA_I,_MO_MA,_PHO_PHAN,_THANTHAKHAT
FIELD8_PROMPT_LEN = $-FIELD8_PROMPT
        DB END_OF_STRING

;----------------------------------------------------------------------
FIELD9_PROMPT_X = 22
FIELD9_PROMPT_Y = 168
FIELD9_PROMPT   DB   _RO_RUA,_SARA_A,_DO_DEK,_MAI_HAN_AKAT,_BO_BAIMAI,_KO_KAI
        DB   _SARA_AA,_RO_RUA,_PHO_PHAN,_SARA_I,_MO_MA,_PHO_PHAN
        DB   _THANTHAKHAT
FIELD9_PROMPT_LEN = $-FIELD9_PROMPT
        DB END_OF_STRING

;======================================================================
;
;        Pointers to custom video functions

VIDFUNCS LABEL WORD 
         DW     CSTVID00        ;Check driver installed, get version
         DW     CSTVID01        ;Set config options
         DW     STORE_OPTIONS   ;Write options to driver file
         DW     CSTVID03        ;Set foreground/background colors
         DW     CSTVID04        ;
         DW     CSTVID05        ;
         DW     CSTVID06        ;Get foreground/background colors
         DW     CSTVID07        ;
         DW     CSTVID08        ;Get menu width set by user
         DW     CSTVID09        ;Get menu height set by user
         DW     CSTVID0A        ;Get menu width
         DW     CSTVID0B        ;Get menu height
         DW     CSTVID0C        ;
         DW     CSTVID0D        ;Set menu width & height
         DW     CSTVID0E        ;
         DW     CSTVID0F        ;
         DW     CSTVID10        ;
         DW     CSTVID11        ;
         DW     CSTVID12        ;Display message
         DW     REMOVE_TSR      ;Unload TSR from memory - function 13h
CSTVID_MAX = ($-VIDFUNCS)/2

CSTM_VID PROC NEAR
         CMP   AH,(CSTVID_MAX+1) OR 80H  ;93H            ;Mode (-80h) = 0 - 12h
         JNC   BAD_MODE
         PUSH  AX                ;Save mode
         CLD                     ;Set forward direction flag.
         SUB   AH,80H            ;Strip high bit
         MOV   AL,AH             ;move mode to al
         XOR   AH,AH             ;clear ah
         MOV   DI,OFFSET VIDFUNCS
         SHL   AX,1              ;Double mode # to index
         ADD   DI,AX             ;... into table
         POP   AX                ;Restore original mode value
         CALL  WORD PTR CS:[DI]  ;Call custom function

BAD_MODE:
         IRET                    ;Return from interrupt.
CSTM_VID ENDP

REMOVE_TSR PROC NEAR
        _push bx,si,di,ds,es
         XOR   AX,AX
         MOV   DS,AX
         MOV   AX,CS
         CMP   AX,WORD PTR DS:[INT_TBL_SEG_TIMER]     ;TIMER
         JNZ   CANT_REMOVE
         CMP   AX,WORD PTR DS:[INT_TBL_SEG_KBD]     ;KEYBOARD
         JNZ   CANT_REMOVE
         CMP   AX,WORD PTR DS:[INT_TBL_SEG_VIDEO]     ;VIDEO
         JNZ   CANT_REMOVE
         CMP   AX,WORD PTR DS:[INT_TBL_SEG_PRINTER]     ;PRINTER
         JZ OK_TO_REMOVE
CANT_REMOVE:
         MOV  AL,0FFH             ;INDICATE FAILURE
         JMP  SHORT RMV_EXIT
OK_TO_REMOVE:
         CALL KILL_TSR
         MOV  AL,0                ; FLAG SUCCESS
RMV_EXIT:
         _pop es,ds,di,si,bx
         RET
REMOVE_TSR ENDP
;------------------------------------------------------------
ENCRYPT_STRING PROC  NEAR
;------------------------------------------------------------
         MOV   DI,CS:[MSGVECT]
         MOV   CX,100H
ENCRYPT_LOOP:  
         LODSB                   ;Load AL with byt at DS:SI ++.
         XOR   AL,END_OF_STRING
         STOSB                   ;Store byt in AL in ES:DI ++.
         CMP   AL,END_OF_STRING
         LOOPNZ ENCRYPT_LOOP           ;Dec CX, loop if NZ and CX<>0.
         RET
ENCRYPT_STRING ENDP


;------------------------------------------------------------
; Check for driver installed, set options
; Entry: AH = 80H
; If BX = 0: Return AX = DRIVER_VERSION
;                   ES = our code segment
; else       Return AL = byte at BX + L0106H
;------------------------------------------------------------
CSTVID00 PROC  NEAR
         XOR   AH,AH
         OR    BX,BX
         JNZ   C00_EXIT
         MOV   AX,CS
         MOV   ES,AX
         MOV   AX,WORD PTR CS:[DRIVER_VERSION]
         RET
C00_EXIT:
         MOV   AL,BYTE PTR CS:[BX]+L0106H
         RET
CSTVID00 ENDP

;------------------------------------------------------------
; Set configuration options
; Entry: AH = 81H
;        BL = Option to set
;        AL = New value
;------------------------------------------------------------
CSTVID01 PROC  NEAR
         OR    BX,BX
         JZ    C01_EXIT
         AND   BX,0FH
         MOV   BYTE PTR CS:[BX]+L0106H,AL
C01_EXIT:
         RET
CSTVID01 ENDP

;------------------------------------------------------------
; Called internally when F2 is pressed in control panel
; Called from user app with
;       AH = 82H
;------------------------------------------------------------
STORE_OPTIONS PROC  NEAR      ;Write settings to GTHAI.COM
         _PUSH AX,BX,DX,DS
         MOV   DS,CS:[FNAMESEG]
         MOV   DX,CS:[FNAMEOFF]
         MOV   AX,(DOS_OPEN_FILE SHL 8 + O_RDRW)  ;3D02H Open file, read/write
         INT   21H
         JC    WRIT_ERR
         MOV   BX,AX               ;Move file handle to BX
         MOV   CX,OPTION_SAVE_LENGTH
         PUSH   CS
         POP    DS
         MOV   DX,OFFSET GTHAI     ;point to start of program
         MOV   AH,DOS_WRITE_HANDLE
         INT   21H
         MOV   AH,DOS_CLOSE_FILE
         INT   21H
WRIT_ERR:
         _POP  DS,DX,BX,AX
         RET
STORE_OPTIONS ENDP

;------------------------------------------------------------
; Entry: AH = 83H
;        AL = Background color SHL 8 + Foreground color
;------------------------------------------------------------
CSTVID03 PROC  NEAR     ;SET TEXT_COLOR
         MOV   CS:[TEXT_COLOR],AL
         RET
CSTVID03 ENDP

;------------------------------------------------------------
; Entry AH = 84H
;------------------------------------------------------------
CSTVID04 PROC  NEAR
         JMP   CS:[SET_EDGE_COLOR]
CSTVID04 ENDP

;------------------------------------------------------------
; Entry AH = 85H
;------------------------------------------------------------
CSTVID05 PROC  NEAR
        JMP   CS:[SET_SHADOW_COLOR]
CSTVID05 ENDP

;------------------------------------------------------------
; Entry: AH = 86H
; Exit:  AL = Background color SHL 8 + Foreground color
;------------------------------------------------------------
CSTVID06 PROC  NEAR   ;GET TEXT_COLOR
         MOV   AL,CS:[TEXT_COLOR]
         RET
CSTVID06 ENDP

;------------------------------------------------------------
; Entry: AH = 87H
; Exit:  AL = L1514H
;------------------------------------------------------------
CSTVID07 PROC  NEAR
         MOV   AL,CS:[L1514H]
         RET
CSTVID07 ENDP

;------------------------------------------------------------
; Entry: AH = 88H
; Exit:  AX = USER_WIDTH
;------------------------------------------------------------
CSTVID08 PROC  NEAR
         MOV   AX,WORD PTR CS:[USER_WIDTH]
         RET
CSTVID08 ENDP

;------------------------------------------------------------
; Entry: AH = 89H
; Exit:  AX = USER_HEIGHT
;------------------------------------------------------------
CSTVID09 PROC  NEAR
         MOV   AX,WORD PTR CS:[USER_HEIGHT]
         RET
CSTVID09 ENDP

;------------------------------------------------------------
; Entry: AH = 8AH
; Exit:  AX = MENU_WIDTH
;------------------------------------------------------------
CSTVID0A PROC  NEAR
         MOV   AX,CS:[MENU_WIDTH]
         RET
CSTVID0A ENDP

;------------------------------------------------------------
; Entry: AH = 8BH
; Exit:  AX = MENU_HEIGHT
;------------------------------------------------------------
CSTVID0B PROC  NEAR
         MOV   AX,CS:[MENU_HEIGHT]
         RET
CSTVID0B ENDP

;------------------------------------------------------------
; Entry: AH = 8CH
; Exit:  
;------------------------------------------------------------
CSTVID0C PROC  NEAR
         OR    AL,AL
         JNZ   CVID0C_1
         MOV   AX,(VID_SETMODE SHL 8 + TEXT_80X25)
         INT   10H               ;Set the display mode to (03).
         RET

CVID0C_1:
         PUSH  DS
;         MOV   DS,CS:[VID_SEG]
;         MOV   BYTE PTR DS:[7FFFH],0
         MOV CS:VMODEFLAG, 0  ;//TEST//
         MOV   AX,3H
         MOV   BYTE PTR CS:[DISPMODE],THAI_25
         CALL  CS:[L04EAH]
         POP   DS
         RET
CSTVID0C ENDP

;------------------------------------------------------------
; Entry: AH = 8DH
;        CX = MENU_WIDTH
;        DX = MENU_HEIGHT
;------------------------------------------------------------
CSTVID0D PROC  NEAR
         MOV   WORD PTR CS:[USER_WIDTH],CX
         MOV   WORD PTR CS:[USER_HEIGHT],DX
         ADD   CX,CS:[MENU_LEFT_COLUMN]
         ADD   DX,CS:[MENU_TOP_ROW]
         JMP   CS:[CURSOR_CALC]         ;RFT
CSTVID0D ENDP

;------------------------------------------------------------
CSTVID0E PROC  NEAR
         MOV   ES,WORD PTR CS:[VIDBUF]
         MOV   DI,WORD PTR CS:[VID_OFFSET]
         MOV   AL,CS:[L1513H]
         MOV   DX,GRAPHICS_ADDRESS_REG
         MOV   AL,8
         OUT   DX,AL
         INC   DX
         JMP   CS:[L04FEH]
CSTVID0E ENDP

;------------------------------------------------------------
CSTVID0F PROC  NEAR
         PUSH  DS

         PUSH  CS
         POP   DS

         MOV   ES,WORD PTR [VIDBUF]
         CALL  DRAW_LINE

         POP   DS
         RET
CSTVID0F ENDP

;------------------------------------------------------------
CSTVID10 PROC  NEAR
         _PUSH  SI,ES,SI,DS
         MOV   DI,OFFSET MENU_LEFT_COLUMN
         MOV   AX,CS
         MOV   ES,AX
         MOV   CX,10
         REPZ MOVSW              ;Move wrd, DS:SI to ES:DI ++.
         XOR   AX,AX
         OR    BYTE PTR [SI],AL
         JZ    CV10_1
         LDS   SI,DWORD PTR [SI] ;Load DS:SI with 32b pointer.
         CALL  ENCRYPT_STRING
         MOV   AX,CS:[MSGVECT]
CV10_1:  
         MOV   ES:[MENU_TITLE_MSG],AX
         PUSH  CS
         POP   DS
         MOV   ES,WORD PTR [VIDBUF]
         CALL  DO_MENU
         POP   DS
         POP   SI
         MOV   DI,OFFSET MENU_LEFT_COLUMN
         MOV   AX,CS
         MOV   ES,AX
         MOV   CX,10
         REPZ MOVSW              ;Move wrd, DS:SI to ES:DI ++.
         POP   ES
         POP   SI
         RET
CSTVID10 ENDP

;------------------------------------------------------------
CSTVID11 PROC  NEAR
         PUSH  DS
         MOV   DX,CS
         MOV   DS,DX
         MOV   ES,WORD PTR [VIDBUF]
         MOV   SI,OFFSET FONT_2
         MOV   DI,WORD PTR [VID_OFFSET]
         MOV   AH,[TEXT_COLOR]
         OR    AH,AH
         JNS   CV11_1
         OR    AL,AL
         JNS   CV11_1
         AND   AX,7F7FH
         MOV   SI,OFFSET FONT_1
CV11_1:  
         CALL  [L04FCH]
         POP   DS
         RET
CSTVID11 ENDP

;------------------------------------------------------------
; Encrypt string and display message
;------------------------------------------------------------
CSTVID12 PROC  NEAR
         PUSH  DS
         MOV   DX,CS
         MOV   ES,DX
         CALL  ENCRYPT_STRING
         MOV   DS,DX
         MOV   ES,WORD PTR [VIDBUF]
         MOV   SI,[MSGVECT]
         CALL  DO_MSG
         POP   DS
         RET
CSTVID12 ENDP

;======================================================================
;        Parameter table for DO_MENU
;======================================================================
MENU_LEFT_COLUMN        DW  0H
MENU_TOP_ROW            DW  0H
MENU_WIDTH              DW  0H
MENU_HEIGHT             DW  0H
MENU_FRAME_WIDTH        DW  0H
MENU_EDGE_WIDTH         DW  0H
MENU_BACKGROUND_COLOR   DW  0H
MENU_FRAME_COLOR        DW  0H
MENU_EDGE_COLOR         DW  0H
MENU_SHADOW_COLOR       DW  0H
MENU_TITLE_MSG          DW  0H
MENUP0B                 DW  0H
MENUP0C                 DW  0H
MENUP0D                 DW  0H
MENUP0E                 DW  0H
MENUP0F                 DW  0H
MENUP10                 DB  0
MENUP11                 DB  0

L4226H PROC NEAR
         ROR   AL,1
         ADC   DI,0
         RET
L4226H ENDP

L422CH PROC NEAR
         ROL   AL,1
         SBB   DI,0
         RET
L422CH ENDP


;------------------------------------------------------------
DRAW_LINE   PROC  NEAR
         MOV   BX,OFFSET L4226H
         MOV   SI,[NEXT_LINE]
         OR    CX,CX
         JNS   L4242H
         NEG   CX
         MOV   BX,OFFSET L422CH
L4242H:  
         OR    DX,DX
         JNS   L424CH
         NEG   DX
         MOV   SI,[PREV_LINE]
L424CH:  
         CMP   CX,DX            ;Is DX > CX ?
         JNC   L4254H           ;No, go ahead
         XCHG  CX,DX            ;Swap
         XCHG  BX,SI
L4254H:  
         JCXZ  L427CH            ;Jump if CX=0.
         MOV   [MENUP0E],SI
         MOV   [MENUP0D],BX
         MOV   BX,DX
         MOV   DX,GRAPHICS_ADDRESS_REG
         MOV   AL,8
         OUT   DX,AL
         INC   DX
         MOV   DI,WORD PTR [VID_OFFSET]
         MOV   AL,[L1513H]
         OR    BX,BX
         JNZ   L427DH
L4272H:  
         CALL  [L04FEH]
         CALL  [MENUP0D]
         LOOP  L4272H            ;Dec CX, loop if CX<>0.
L427CH:  
         RET
DRAW_LINE ENDP

L427DH PROC NEAR
         SHL   BX,1
         MOV   [MENUP0B],BX
         SUB   BX,CX
         SHL   CX,1
         MOV   [MENUP0C],CX
         SHR   CX,1
L428DH:  
         CALL  [L04FEH]
         OR    BX,BX
         JS    L429DH
         SUB   BX,[MENUP0C]
         CALL  [MENUP0E]

L429DH:  
         ADD   BX,[MENUP0B]
         CALL  [MENUP0D]
         LOOP  L428DH            ;Dec CX, loop if CX<>0.
         RET
L427DH ENDP

;------------------------------------------------------------
L42A8H PROC  NEAR
         XOR   AX,AX
         MOV   BYTE PTR [MENUP10],AL
         MOV   BYTE PTR [MENUP11],AL
         MOV   [MENUP0F],AX
         MOV   DI,WORD PTR [VID_OFFSET]
         MOV   AL,[L1513H]
         MOV   [MENUP0C],DX
         OR    AL,AL
         JS    L42CDH
L42C2H:  
         JCXZ  L42E7H                 ;Jump if CX=0.
         OR    BYTE PTR [MENUP10],AL
         DEC   CX
         SHR   AL,1
         JNZ   L42C2H
L42CDH:  
         MOV   AX,CX
         SHR   AX,1
         SHR   AX,1
         SHR   AX,1
         MOV   [MENUP0F],AX
         AND   CX,7H
         JZ    L42E7H
         XOR   CX,7H
         MOV   AL,0FEH
         SHL   AL,CL
         MOV   BYTE PTR [MENUP11],AL
L42E7H:  
         MOV   DX,GRAPHICS_ADDRESS_REG
         MOV   AL,8
         OUT   DX,AL
         INC   DX                       ;Bump to GRAPHICS DATA REG
         MOV   SI,WORD PTR [PATTERN_POINTER]
         XOR   BX,BX
L42F4H:  
         PUSH  DI
         MOV   BH,BYTE PTR [BX+SI]
         MOV   AL,BYTE PTR [MENUP10]
         OR    AL,AL
         JZ    L430BH
         OUT   DX,AL
         MOV   AH,AL
         AND   AH,BH
         NOT   AL
         AND   AL,BYTE PTR ES:[DI]
         OR    AL,AH
         STOSB                   ;Store byt in AL in ES:DI ++.
L430BH:  
         MOV   CX,[MENUP0F]
         JCXZ  L4316H            ;Jump if CX=0.
         MOV   AL,BH
         OUT   DX,AL
         REPZ STOSB              ;Store byt in AL in ES:DI ++.
L4316H:  
         MOV   AL,BYTE PTR [MENUP11]
         OR    AL,AL
         JZ    L432AH
         OUT   DX,AL
         MOV   AH,AL
         AND   AH,BH
         NOT   AL
         AND   AL,BYTE PTR ES:[DI]
         OR    AL,AH
         STOSB                   ;Store byt in AL in ES:DI ++.
L432AH:  
         POP   DI
         CALL  [NEXT_LINE]
         INC   BX
         AND   BX,7H
         DEC   [MENUP0C]
         JNZ   L42F4H
         RET
L42A8H ENDP

;------------------------------------------------------------
P_0019   PROC  NEAR
;------------------------------------------------------------
DO_MSG:  
         PUSH BX
         PUSH BP
         MOV   DI,WORD PTR [VID_OFFSET] ;POINT TO SCREEN
@@1:
         LODSB                   ;Load AL with byt at DS:SI ++.
         XOR   AL,END_OF_STRING
         JNZ   @@3
         POP  BP
         POP  BX
         RET

@@2:  
         MOV   AH,[TEXT_COLOR]
         XCHG  SI,BP
         CALL  [L04FCH]
         MOV   SI,BP
         INC   DI
         JMP   @@1
@@3:  
         XOR   BX,BX
         MOV   BP,OFFSET FONT_2
         MOV   BL,AL
         CMP   BYTE PTR [BX]+L152FH,5
         JNZ   @@2
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         ADD   BX,BP
         MOV   BP,OFFSET L14FBH
         MOV   CX,7
@@4:  
         MOV   AX,WORD PTR [BX]
         MOV   WORD PTR CS:[BP]+0,AX
         INC   BX
         INC   BX
         INC   BP
         INC   BP
         LOOP  @@4                    ;Dec CX, loop if CX<>0.
         MOV   BP,OFFSET L14FBH
         MOV   BL,BYTE PTR [SI]
         XOR   BL,5
         JZ @@10

         XOR   BH,BH
         MOV   AH,BYTE PTR [BX]+L152FH
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         ADD   BX,OFFSET FONT_2
         MOV   CL,7
         CMP   AH,7
         JNZ   @@6
@@5:  
         MOV   AX,WORD PTR [BX]
         OR    WORD PTR CS:[BP]+0,AX
         INC   BX
         INC   BX
         INC   BP
         INC   BP
         LOOP  @@5            ;Dec CX, loop if CX<>0.
         MOV   BP,OFFSET L14FBH
         INC   SI
         MOV   BL,BYTE PTR [SI]
         XOR   BL,5
         JZ    @@6
         XOR   BH,BH
         MOV   AH,BYTE PTR [BX]+L152FH
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         ADD   BX,OFFSET FONT_2
         MOV   CL,7
@@6:  
         CMP   AH,8
         JNZ   @@8
@@7:  
         MOV   AX,WORD PTR [BX]
         OR    WORD PTR CS:[BP]+0,AX
         INC   BX
         INC   BX
         INC   BP
         INC   BP
         LOOP  @@7            ;Dec CX, loop if CX<>0.
         MOV   BP,OFFSET L14FBH
         INC   SI
         MOV   BL,BYTE PTR [SI]
         XOR   BL,5
         JZ    @@10
         XOR   BH,BH
         MOV   AH,BYTE PTR [BX]+L152FH
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         ADD   BX,OFFSET FONT_2+2
         MOV   CL,6
@@8:  
         CMP   AH,HT
         JNZ   @@10
@@9:  
         MOV   AX,WORD PTR [BX]
         OR    WORD PTR CS:[BP]+0,AX
         INC   BX
         INC   BX
         INC   BP
         INC   BP
         LOOP  @@9            ;Dec CX, loop if CX<>0.
         MOV   BP,OFFSET L14FBH
         INC   SI

@@10:  
         MOV   AL,CH
         JMP   @@2
P_0019   ENDP

;------------------------------------------------------------
P_001A   PROC  NEAR
;------------------------------------------------------------
L441CH:  
         MOV   AX,CYAN
         CALL  [SET_SHADOW_COLOR]
         MOV   AL,0FFH
         MOV   BL,14
         MOV   BH,CL
         MOV   DI,WORD PTR [VID_OFFSET]
@@1:  
         MOV   SI,DI
@@2:  
         CALL  [L04FEH]
         INC   DI
         LOOP  @@2            ;Dec CX, loop if CX<>0.
         MOV   CL,BH
         MOV   DI,SI
         CALL  [NEXT_LINE]
         DEC   BL
         JNZ   @@1
         MOV   AX,BLACK
         CALL  [SET_SHADOW_COLOR]
         RET
P_001A   ENDP

;------------------------------------------------------------
P_001B   PROC  NEAR
;------------------------------------------------------------
L444AH:  
         MOV   AX,BLACK
         CALL  [SET_SHADOW_COLOR]
         CMP   [MENU_BACKGROUND_COLOR],0FFFFH
         JZ    @@1
         MOV   AX,[MENU_BACKGROUND_COLOR]
         CALL  [SET_EDGE_COLOR]
         MOV   CX,[MENU_LEFT_COLUMN]
         MOV   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,[MENU_WIDTH]
         MOV   DX,[MENU_HEIGHT]
         CALL  L42A8H

@@1:  
         MOV   SI,[MENU_EDGE_WIDTH]
         OR    SI,SI
@@2:  
         JNZ   @@3
         RET

@@3:  
         MOV   CX,[MENU_LEFT_COLUMN]
         ADD   CX,[MENU_WIDTH]
         ADD   CX,SI
         DEC   CX
         MOV   DX,[MENU_TOP_ROW]
         SUB   DX,SI
         CALL  [CURSOR_CALC]
         MOV   AX,[MENU_SHADOW_COLOR]
         CALL  [SET_EDGE_COLOR]
         MOV   AL,[L1513H]
         MOV   CX,[MENU_HEIGHT]
         SHL   SI,1              ;Note, reference to 0044A3
         ADD   CX,SI
         DEC   CX
@@4:  
         CALL  [L04FEH]
         CALL  [NEXT_LINE]
         LOOP  @@4            ;Dec CX, loop if CX<>0.
         MOV   CX,[MENU_WIDTH]
         ADD   CX,SI
         DEC   CX
@@5:  
         CALL  [L04FEH]
         ROL   AL,1
         SBB   DI,0
         LOOP  @@5            ;Dec CX, loop if CX<>0.
         MOV   AX,[MENU_EDGE_COLOR]
         CALL  [SET_EDGE_COLOR]
         MOV   DI,WORD PTR [VID_OFFSET]
         MOV   AL,[L1513H]
         MOV   CX,[MENU_WIDTH]
         ADD   CX,SI
         DEC   CX
@@6:  
         CALL  [L04FEH]
         ROL   AL,1
         SBB   DI,0
         LOOP  @@6            ;Dec CX, loop if CX<>0.
         MOV   CX,[MENU_HEIGHT]
         ADD   CX,SI
@@7:  
         CALL  [L04FEH]
         CALL  [NEXT_LINE]
         LOOP  @@7            ;Dec CX, loop if CX<>0.
         SHR   SI,1
         DEC   SI
         JMP   SHORT @@2
P_001B   ENDP

;------------------------------------------------------------
SHOW_MENU  PROC  FAR
;------------------------------------------------------------
DO_MENU:
         MOV   AX,[MENU_FRAME_WIDTH]
         INC   AX
         INC   AX
         SUB   [MENU_LEFT_COLUMN],AX
         SUB   [MENU_TOP_ROW],AX
         SHL   AX,1
         ADD   [MENU_WIDTH],AX
         ADD   [MENU_HEIGHT],AX
         CMP   [MENU_TITLE_MSG],0
         JZ    @@1
         SUB   [MENU_TOP_ROW],15
         ADD   [MENU_HEIGHT],15
@@1:  
         MOV   AX,[MENU_BACKGROUND_COLOR]
         XCHG  AX,[MENU_FRAME_COLOR]
         MOV   [MENU_BACKGROUND_COLOR],AX
         CALL  L444AH
         MOV   AX,[MENU_BACKGROUND_COLOR]
         XCHG  AX,[MENU_FRAME_COLOR]
         MOV   [MENU_BACKGROUND_COLOR],AX
         CMP   [MENU_FRAME_WIDTH],0
         JZ    @@2
         MOV   AX,[MENU_FRAME_WIDTH]
         INC   AX
         INC   AX
         ADD   [MENU_LEFT_COLUMN],AX
         ADD   [MENU_TOP_ROW],AX
         SHL   AX,1
         SUB   [MENU_WIDTH],AX
         SUB   [MENU_HEIGHT],AX
         MOV   AX,[MENU_EDGE_COLOR]
         MOV   BX,[MENU_SHADOW_COLOR]
         MOV   [MENU_SHADOW_COLOR],AX
         MOV   [MENU_EDGE_COLOR],BX
         CALL  L444AH

@@2:  
         CMP   [MENU_TITLE_MSG],0
         JZ    MSG_EXIT
         MOV   [MENU_HEIGHT],14
         MOV   [MENU_EDGE_WIDTH],1
         MOV   AX,[MENU_EDGE_COLOR]
         MOV   BX,[MENU_SHADOW_COLOR]
         MOV   CX,[MENU_FRAME_COLOR]
         MOV   [MENU_SHADOW_COLOR],AX
         MOV   [MENU_EDGE_COLOR],BX
         MOV   [MENU_BACKGROUND_COLOR],CX
         CALL  L444AH
         MOV   SI,[MENU_TITLE_MSG]
         XOR   CX,CX
COUNT_LOOP:
         LODSB                          ;Get a character
         XOR   AL,END_OF_STRING         ;Decode character
         JZ    COUNT_DONE               ;If END_OF_MESSAGE, we're done
         CMP   AL,MAI_HAN_AKAT          ;Thai vowel, don't count it
         JZ    COUNT_LOOP
         CMP   AL,SARA_I                ;Check range SARA_I to PHINTHU
         JC    BUMP_COUNT               ;If below range, count it
         CMP   AL,PHINTHU
         JBE   COUNT_LOOP               ;If in range, don't count it
         CMP   AL,MAI_TAI_KHU           ;Check range MAI_TAI_KHU to NIKKHAHIT
         JC    BUMP_COUNT               ;If below range, count it
         CMP   AL,NIKKHAHIT
         JBE   COUNT_LOOP               ;If in range, don't count it, 
BUMP_COUNT:                             ;else, drop through and bump count
         INC   CX
         JMP   COUNT_LOOP
COUNT_DONE:  
         MOV   AX,[MENU_WIDTH]          ;Center title in window
         SHL   CX,1
         SHL   CX,1
         SHL   CX,1                     ;Title length /8
         SUB   AX,CX                    ;MENU_WIDTH - (Title/8)
         SHR   AX,1                     ;Center of menu
         ADD   AX,[MENU_LEFT_COLUMN]    ;Offset from left edge
         MOV   CX,AX
         MOV   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         ADD   [MENU_TOP_ROW],15
         MOV   SI,[MENU_TITLE_MSG]
         MOV   [TEXT_COLOR],TITLE_COLOR
         JMP   DO_MSG

MSG_EXIT:
         RETN
SHOW_MENU ENDP

L45E1H   DB   THO_THAN
L45E2H   DW    L4BADH
L45E4H   DW    L4B42H
L45E6H   DW    L4C2EH

         DB     THO_NANGMONTHO
         DW     L4BADH
         DW     L4B42H
         DW     L4C2EH

         DB     THO_PHUTHAO
         DW     L4BADH
         DW     L4B42H
         DW     L4C2EH

         DB     NO_NEN
         DW     L4BC1H
         DW     L4731H
         DW     L47B5H

         DB     NO_NEN
         DW     L4BC1H
         DW     L4836H
         DW     L4731H

         DB     NO_NEN
         DW     L4BC1H
         DW     L4A3EH
         DW     L4731H

         DB     NO_NEN
         DW     L4BC1H
         DW     L4836H
         DW     L4939H

         DB     BO_BAIMAI
         DW     L4BC1H
         DW     L4836H
         DW     L49BDH

         DB     NO_NEN
         DW     L4BC1H
         DW     L4A3EH
         DW     L47B5H

         DB     BO_BAIMAI
         DW     L4BC1H
         DW     L4A3EH
         DW     L4939H

         DB     BO_BAIMAI
         DW     L4BC1H
         DW     L4939H
         DW     L49BDH

         DB     BO_BAIMAI
         DW     L4BC1H
         DW     L4A3EH
         DW     L49BDH

         DB     BO_BAIMAI
         DW     L4BBEH
         DW     L4A3EH
         DW     L4939H

         DB     BO_BAIMAI
         DW     L4BBEH
         DW     L4836H
         DW     L4939H

         DB     BO_BAIMAI
         DW     L4BBEH
         DW     L4A3EH
         DW     L4731H

         DB     NO_NEN
         DW     L4BC1H
         DW     L4836H
         DW     L47B5H

         DB     RU
         DW     L4BA8H
         DW     L48B8H
         DW     L4731H

         DB     RU
         DW     L4BADH
         DW     L4836H
         DW     L48B8H

         DB     RU
         DW     L4BADH
         DW     L4836H
         DW     L48B8H

         DB     RU
         DW     L4BA8H
         DW     L48B8H
         DW     L4731H

         DB     RU
         DW     L4BA8H
         DW     L4836H
         DW     L48B8H

         DB     RU
         DW     L4BADH
         DW     L4836H
         DW     L48B8H

         DB     O_ANG
         DW     L4BADH
         DW     L4AC0H
         DW     L4731H

         DB     RU
         DW     L4BA8H
         DW     L48B8H
         DW     L4939H

         DB     O_ANG
         DW     L4BA3H
         DW     L4AC0H
         DW     L4939H

         DB     O_ANG
         DW     L4BADH
         DW     L4AC0H
         DW     L49BDH

         DB     O_ANG
         DW     L4BA3H
         DW     L4A3EH
         DW     L4AC0H

         DB     O_ANG
         DW     L4BA3H
         DW     L4A3EH
         DW     L4AC0H

         DB     O_ANG
         DW     L4BA3H
         DW     L4AC0H
         DW     L4939H

         DB     O_ANG
         DW     L4BA3H
         DW     L4A3EH
         DW     L4AC0H

         DB     O_ANG
         DW     L4BA3H
         DW     L4A3EH
         DW     L4AC0H

         DB     O_ANG
         DW     L4BADH
         DW     L4A3EH
         DW     L4AC0H

         DB     RU
         DW     L4BA8H
         DW     L4836H
         DW     L48B8H

         DB     O_ANG
         DW     L4BADH
         DW     L4A3EH
         DW     L4AC0H

         DB     RU
         DW     L4BA8H
         DW     L4836H
         DW     L48B8H

         DB     RU
         DW     L4BADH
         DW     L48B8H
         DW     L4939H

         DB     O_ANG
         DW     L4BADH
         DW     L4AC0H
         DW     L4731H

         DB     O_ANG
         DW     L4BADH
         DW     L4AC0H
         DW     L47B5H

         DB     RU
         DW     L4BADH
         DW     L48B8H
         DW     L49BDH

         DB     RU
         DW     L4BA8H
         DW     L4836H
         DW     L48B8H

         DB     RU
         DW     L4BA8H
         DW     L4A3EH
         DW     L4AC0H

         DB     ' '
         DW     L4BEFH
         DW     L4836H
         DW     L4731H

         DB     RU
         DW     L4BA8H
         DW     L48B8H
         DW     L47B5H

         DB     0DBH
         DW     L4BADH
         DW     L4B42H
         DW     L4C2EH

         DB     0DCH
         DW     L4BADH
         DW     L4B42H
         DW     L4C2EH

         DB     0DDH
         DW     L4BADH
         DW     L4B42H
         DW     L4C2EH

         DB     0DEH
         DW     L4BADH
         DW     L4B42H
         DW     L4C2EH

         DB     BAHT
         DW     L4BADH
         DW     L4B42H
         DW     L4C2EH

;------------------------------------------------------------
P_001D   PROC  NEAR
;------------------------------------------------------------

L4731H:  
         PUSH  SI
L4732H:
         MOV   WORD PTR [SI],AX
L4734H:  
         SUB   SI,0A0H
         MOV   AX,WORD PTR [SI]
         XOR   AH,80H
         JNS   @@Exit
         CMP   AL,NO_NEN
         JZ    L4732H
         CMP   AL,PHINTHU
         JZ L48B9H

         CMP   AL,SARA_II
         JZ L4AC1H

         CMP   AL,FO_FAN
         JZ L4837H

         CMP   AL,THO_THONG
         JZ L4A3FH

         CMP   AL,RO_RUA
         JNZ   NOT_RO_RUA
         CALL  L48B8H
         JMP   SHORT L4734H
NOT_RO_RUA:  
         CMP   AL,LU
         JNZ   NOT_LU
         CALL  L4AC0H
         JMP   SHORT L4734H
NOT_LU:  
         CMP   AL,DO_DEK
         JNZ   NOT_DO_DEK
         CALL  L4836H
         JMP   SHORT L4734H
NOT_DO_DEK:
         CMP   AL,TO_TAO
         JNZ   NOT_TO_TAO
         CALL  L4A3EH
         JMP   SHORT L4734H
NOT_TO_TAO:
         CMP   AL,YO_YAK
         JNZ   NOT_YO_YAK
         CALL  L4836H
         JMP   L48BBH

NOT_YO_YAK:  
         CMP   AL,MAI_HAN_AKAT
         JNZ   NOT_MAI_HAN_AKAT
         CALL  L4A3EH
         JMP   L4AC3H

NOT_MAI_HAN_AKAT:  
         CMP   AL,LO_LING
         JNZ   NOT_LO_LING
         CALL  L4836H
         MOV   AX,WORD PTR [SI]
         CALL  L48B8H
         JMP   SHORT L4734H
NOT_LO_LING:  
         CMP   AL,SARA_U
         JNZ   NOT_SARA_U
         CALL  L4A3EH
         MOV   AX,WORD PTR [SI]
         CALL  L4AC0H
         JMP   L4734H
NOT_SARA_U:  

@@Exit:
         POP   SI
         RET
P_001D   ENDP

;------------------------------------------------------------
P_001E   PROC  NEAR
;------------------------------------------------------------
L47B5H:  
         PUSH  SI
L47B6H:  
         MOV   WORD PTR [SI],AX
L47B8H:  
         ADD   SI,0A0H
         MOV   AX,WORD PTR [SI]
         XOR   AH,80H
         JNS   NOT_SARA_U
         CMP   AL,NO_NEN
         JZ    L47B6H
         CMP   AL,SARA_UU
         JZ    L4837H
         CMP   AL,PHO_PHAN
         JZ L4A3FH

L47D2H:  
         CMP   AL,PHO_SAMPHAO
         JZ L48B9H

L47D9H:  
         CMP   AL,SARA_I
         JZ L4AC1H

L47E0H:  
         CMP   AL,DO_DEK
         JNZ   @@1
         CALL  L4836H
         JMP   SHORT L47B8H
@@1:  
         CMP   AL,TO_TAO
         JNZ   @@2
         CALL  L4A3EH
         JMP   SHORT L47B8H
@@2:  
         CMP   AL,RO_RUA
         JNZ   @@3
         CALL  L48B8H
         JMP   SHORT L47B8H
@@3:  
         CMP   AL,LU
         JNZ   @@4
         CALL  L4AC0H
         JMP   SHORT L47B8H
@@4:  
        CMP   AL,MO_MA
         JNZ   @@5
         CALL  L4836H
         JMP   L48BBH

@@5:  
        CMP   AL,PAI_YAN_NOI
         JNZ   @@6
         CALL  L4A3EH
         JMP   L4AC3H

@@6:  
        CMP   AL,LO_LING
         JNZ   @@7
         CALL  L4836H
         MOV   AX,WORD PTR [SI]
         CALL  L48B8H
         JMP   SHORT L47B8H
@@7:  
        CMP   AL,SARA_U
         JNZ   L4834H
         CALL  L4A3EH
         MOV   AX,WORD PTR [SI]
         CALL  L4AC0H
         JMP   SHORT L47B8H
L4834H:  
        POP   SI
         RET
P_001E   ENDP


;------------------------------------------------------------
P_001F   PROC  NEAR
;------------------------------------------------------------

L4836H:  
        PUSH  SI

L4837H:  
        MOV   WORD PTR [SI],AX
L4839H:  
        DEC   SI
         DEC   SI
         MOV   AX,WORD PTR [SI]
         XOR   AH,80H
         JNS   L4834H
         CMP   AL,RU
         JZ    L4837H
         CMP   AL,PHINTHU
         JZ L47B6H

        CMP   AL,SARA_UE
         JZ L49BEH

        CMP   AL,PHO_SAMPHAO
         JZ L4732H

        CMP   AL,SARA_AM
         JZ L493AH

        CMP   AL,YO_YAK
         JNZ   @@1
         CALL  L47B5H
         JMP   SHORT L4839H
@@1:  
        CMP   AL,SARA_AA
         JNZ   @@2
         CALL  L49BDH
         JMP   SHORT L4839H
@@2:  
        CMP   AL,MO_MA
         JNZ   @@3
         CALL  L4731H
         JMP   SHORT L4839H
@@3:  
        CMP   AL,SARA_A
         JNZ   @@4
         CALL  L4939H
         JMP   SHORT L4839H
@@4:  
        CMP   AL,RO_RUA
         JNZ   @@5
         CALL  L47B5H
         JMP   L4734H

@@5:  
        CMP   AL,LU
         JNZ   @@6
         CALL  L49BDH
         JMP   L493CH

@@6:  
        CMP   AL,LO_LING
         JNZ   @@7
         CALL  L4731H
         MOV   AX,WORD PTR [SI]

        CALL  L47B5H
         JMP   SHORT L4839H
@@7:  
        CMP   AL,SARA_U
         JNZ   @@8
         CALL  L4939H
         MOV   AX,WORD PTR [SI]
         CALL  L49BDH
         JMP   SHORT L4839H
@@8:  
        POP   SI
         RET
P_001F   ENDP

;------------------------------------------------------------
P_0020   PROC  NEAR
;------------------------------------------------------------
L48B8H:  
        PUSH  SI
L48B9H:  
        MOV   WORD PTR [SI],AX
L48BBH:  
        INC   SI
         INC   SI
         MOV   AX,WORD PTR [SI]
         XOR   AH,80H
         JS    L48C7H
         JMP   L4834H
L48C7H:  
        CMP   AL,RU
         JZ    L48B9H
         CMP   AL,FO_FAN
         JZ L47B6H
L48D2H:  
        CMP   AL,THO_THAHAN
         JZ L49BEH

L48D9H:  
        CMP   AL,SARA_UU
         JZ L4732H

L48E0H:  
        CMP   AL,FO_FA
         JZ    L493AH
         CMP   AL,YO_YAK
         JNZ   L48EDH
         CALL  L47B5H
         JMP   SHORT L48BBH
L48EDH:  
        CMP   AL,SARA_AA
         JNZ   L48F6H
         CALL  L49BDH
         JMP   SHORT L48BBH
L48F6H:  
        CMP   AL,MO_MA
         JNZ   L48FFH
         CALL  L4731H
         JMP   SHORT L48BBH
L48FFH:  
        CMP   AL,SARA_A
         JNZ   L4908H
         CALL  L4939H
         JMP   SHORT L48BBH
L4908H:  
        CMP   AL,DO_DEK
         JNZ   L4912H
         CALL  L47B5H
         JMP   L4734H

L4912H:  
        CMP   AL,TO_TAO
         JNZ   L491BH
         CALL  L49BDH
         JMP   SHORT L493CH
L491BH:  
        CMP   AL,LO_LING
         JNZ   L4929H
         CALL  L47B5H
         MOV   AX,WORD PTR [SI]
         CALL  L4731H
         JMP   SHORT L48BBH
L4929H:  
        CMP   AL,SARA_UEE
         JNZ   L4937H
         CALL  L49BDH
         MOV   AX,WORD PTR [SI]
         CALL  L4939H
         JMP   SHORT L48BBH
L4937H:  
        POP   SI
         RET
P_0020   ENDP

;------------------------------------------------------------
P_0021   PROC  NEAR
;------------------------------------------------------------
L4939H:  
        PUSH  SI
L493AH:  
        MOV   WORD PTR [SI],AX
L493CH:  
        SUB   SI,0A0H
         MOV   AX,WORD PTR [SI]
         XOR   AH,80H
         JNS   L4937H
         CMP   AL,BO_BAIMAI
         JZ    L493AH
         CMP   AL,SARA_UE
         JZ L48B9H

L4952H:  
        CMP   AL,SO_RUSI
         JZ L4AC1H

L4959H:  
        CMP   AL,THO_THAHAN
         JZ L4837H

L4960H:  
        CMP   AL,PO_PLA
         JZ L4A3FH

L4967H:  
        CMP   AL,WO_WAEN
         JNZ   L4970H
         CALL  L48B8H
         JMP   SHORT L493CH
L4970H:  
        CMP   AL,LO_CHULA
         JNZ   L4979H
         CALL  L4AC0H
         JMP   SHORT L493CH
L4979H:  
        CMP   AL,THO_THUNG
         JNZ   L4982H
         CALL  L4836H
         JMP   SHORT L493CH
L4982H:  
        CMP   AL,NO_NU
         JNZ   L498BH
         CALL  L4A3EH
         JMP   SHORT L493CH
L498BH:  
        CMP   AL,SARA_AA
         JNZ   L4995H
         CALL  L4836H
         JMP   L48BBH

L4995H:  
        CMP   AL,HO_HIP
         JNZ   L499FH
         CALL  L4A3EH
         JMP   L4AC3H

L499FH:  
        CMP   AL,SARA_UEE
         JNZ   L49ADH
         CALL  L4836H
         MOV   AX,WORD PTR [SI]
         CALL  L48B8H
         JMP   SHORT L493CH
L49ADH:  
        CMP   AL,HO_NOK_HUK
         JNZ   L49BBH
         CALL  L4A3EH
         MOV   AX,WORD PTR [SI]
         CALL  L4AC0H
         JMP   SHORT L493CH
L49BBH:  
        POP   SI
         RET
P_0021   ENDP


;------------------------------------------------------------
P_0022   PROC  NEAR
;------------------------------------------------------------
L49BDH:  
        PUSH  SI

L49BEH:  
        MOV   WORD PTR [SI],AX
L49C0H:  
        ADD   SI,0A0H
         MOV   AX,WORD PTR [SI]
         XOR   AH,80H
         JNS   L49BBH
         CMP   AL,BO_BAIMAI
         JZ    L49BEH
         CMP   AL,FO_FA
         JZ L4837H

L49D6H:  
        CMP   AL,PHO_PHUNG
         JZ    L4A3FH
         CMP   AL,SARA_AM
         JZ L48B9H

L49E1H:  
        CMP   AL,SO_SALA
         JZ L4AC1H

L49E8H:  
        CMP   AL,THO_THUNG
         JNZ   L49F1H
         CALL  L4836H
         JMP   SHORT L49C0H
L49F1H:  
        CMP   AL,NO_NU
         JNZ   L49FAH
         CALL  L4A3EH
         JMP   SHORT L49C0H
L49FAH:  
        CMP   AL,WO_WAEN
         JNZ   L4A03H
         CALL  L48B8H
         JMP   SHORT L49C0H
L4A03H:  
        CMP   AL,LO_CHULA
         JNZ   L4A0CH
         CALL  L4AC0H
         JMP   SHORT L49C0H
L4A0CH:  
        CMP   AL,SARA_A
         JNZ   L4A16H
         CALL  L4836H
         JMP   L48BBH

L4A16H:  
        CMP   AL,SO_SUA
         JNZ   L4A20H
         CALL  L4A3EH
         JMP   L4AC3H

L4A20H:  
        CMP   AL,SARA_UEE
         JNZ   L4A2EH
         CALL  L4836H
         MOV   AX,WORD PTR [SI]
         CALL  L48B8H
         JMP   SHORT L49C0H
L4A2EH:  
        CMP   AL,HO_NOK_HUK
         JNZ   L4A3CH
         CALL  L4A3EH
         MOV   AX,WORD PTR [SI]
         CALL  L4AC0H
         JMP   SHORT L49C0H
L4A3CH:  
        POP   SI
         RET
P_0022   ENDP


;------------------------------------------------------------
P_0023   PROC  NEAR
;------------------------------------------------------------
L4A3EH:  
        PUSH  SI

L4A3FH:  
        MOV   WORD PTR [SI],AX
L4A41H:  
        DEC   SI
         DEC   SI
         MOV   AX,WORD PTR [SI]
         XOR   AH,80H
         JNS   L4A3CH
         CMP   AL,O_ANG
         JZ    L4A3FH
         CMP   AL,SARA_II
         JZ L47B6H

L4A55H:  
        CMP   AL,SO_RUSI
         JZ L49BEH

L4A5CH:  
        CMP   AL,SARA_I
         JZ L4732H

L4A63H:  
        CMP   AL,SO_SALA
         JZ L493AH

L4A6AH:  
        CMP   AL,MAI_HAN_AKAT
         JNZ   L4A73H
         CALL  L47B5H
         JMP   SHORT L4A41H
L4A73H:  
        CMP   AL,HO_HIP
         JNZ   L4A7CH
         CALL  L49BDH
         JMP   SHORT L4A41H
L4A7CH:  
        CMP   AL,PAI_YAN_NOI
         JNZ   L4A85H
         CALL  L4731H
         JMP   SHORT L4A41H
L4A85H:  
        CMP   AL,SO_SUA
         JNZ   L4A8EH
         CALL  L4939H
         JMP   SHORT L4A41H
L4A8EH:  
        CMP   AL,LU
         JNZ   L4A98H
         CALL  L47B5H
         JMP   L4734H

L4A98H:  
        CMP   AL,LO_CHULA
         JNZ   L4AA2H
         CALL  L49BDH
         JMP   L493CH

L4AA2H:  
        CMP   AL,SARA_U           ;Note, reference to 004AA3
         JNZ   L4AB0H
         CALL  L47B5H
         MOV   AX,WORD PTR [SI]
         CALL  L4731H
         JMP   SHORT L4A41H
L4AB0H:  
        CMP   AL,HO_NOK_HUK
         JNZ   L4ABEH
         CALL  L49BDH
         MOV   AX,WORD PTR [SI]
         CALL  L4939H
         JMP   SHORT L4A41H
L4ABEH:  
        POP   SI
         RET
P_0023   ENDP


;------------------------------------------------------------
P_0024   PROC  NEAR
;------------------------------------------------------------
L4AC0H:  
        PUSH  SI

L4AC1H:  
        MOV   WORD PTR [SI],AX
L4AC3H:  
        INC   SI
         INC   SI
         MOV   AX,WORD PTR [SI]
         XOR   AH,80H
         JNS   L4ABEH
         CMP   AL,O_ANG
         JZ    L4AC1H
         CMP   AL,THO_THONG
         JZ L47B6H

L4AD7H:  
        CMP   AL,PO_PLA
         JZ L49BEH

L4ADEH:  
        CMP   AL,PHO_PHAN
         JZ L4732H

L4AE5H:  
        CMP   AL,PHO_PHUNG
         JZ L493AH

L4AECH:  
        CMP   AL,MAI_HAN_AKAT
         JNZ   L4AF5H
         CALL  L47B5H
         JMP   SHORT L4AC3H
L4AF5H:  
        CMP   AL,HO_HIP
         JNZ   L4AFEH
         CALL  L49BDH
         JMP   SHORT L4AC3H
L4AFEH:  
        CMP   AL,PAI_YAN_NOI
         JNZ   L4B07H
         CALL  L4731H
         JMP   SHORT L4AC3H
L4B07H:  
        CMP   AL,SO_SUA
         JNZ   L4B10H
         CALL  L4939H
         JMP   SHORT L4AC3H
L4B10H:  
        CMP   AL,TO_TAO
         JNZ   L4B1AH
         CALL  L47B5H
         JMP   L4734H

L4B1AH:  
        CMP   AL,NO_NU
         JNZ   L4B24H
         CALL  L49BDH
         JMP   L493CH

L4B24H:  
        CMP   AL,SARA_U
         JNZ   L4B32H
         CALL  L47B5H
         MOV   AX,WORD PTR [SI]
         CALL  L4731H
         JMP   SHORT L4AC3H
L4B32H:  
        CMP   AL,HO_NOK_HUK
         JNZ   L4B40H
         CALL  L49BDH
         MOV   AX,WORD PTR [SI]
         CALL  L4939H
         JMP   SHORT L4AC3H
L4B40H:  
        POP   SI
         RET

L4B42H:  
        MOV   DI,SI
L4B44H:  
        MOV   WORD PTR [DI],AX
         INC   DI
         INC   DI
         MOV   AX,WORD PTR [DI]
         XOR   AH,80H
         JNS   L4B5FH
         CMP   AL,THO_THAN
         JC    L4B5FH
         CMP   AL,THO_PHUTHAO
         JBE   L4B44H
         CMP   AL,0DBH
         JC    L4B5FH
         CMP   AL,BAHT
         JBE   L4B44H
L4B5FH:  
        MOV   DI,SI
L4B61H:  
        DEC   DI
         DEC   DI
         MOV   AX,WORD PTR [DI]
         XOR   AH,80H
         JNS   L4B7EH
         CMP   AL,THO_THAN
         JC    L4B7EH
         CMP   AL,THO_PHUTHAO
         JBE   L4B7AH
         CMP   AL,0DBH
         JC    L4B7EH
         CMP   AL,BAHT
         JG    L4B7EH
L4B7AH:  
        MOV   WORD PTR [DI],AX
         JMP   SHORT L4B61H
L4B7EH:  
        RET
P_0024   ENDP


;------------------------------------------------------------
P_0025   PROC  NEAR
;------------------------------------------------------------
L4B7FH:  
        MOV   AX,WORD PTR [SI]
         OR    AH,AH
         JS    L4BBEH
         SUB   AL,0B0H
         JS    L4BBEH
         CMP   AL,'0'
         JNC   L4BBEH
         XOR   AH,AH
         MOV   BX,AX
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         SUB   BX,AX
         MOV   AL,BYTE PTR CS:[BX]+L45E1H
         JMP   WORD PTR CS:[BX]+L45E2H
P_0025   ENDP


;------------------------------------------------------------
P_0026   PROC  NEAR
;------------------------------------------------------------
L4BA3H:  
        CMP   BYTE PTR [SI]+8,AL
         JNZ   L4BBEH

L4BA8H:  
        CMP   BYTE PTR [SI]+6,AL
         JNZ   L4BBEH

L4BADH:  
        CMP   BYTE PTR [SI]+4,AL
         JNZ   L4BBEH
         CMP   BYTE PTR [SI]+2,AL
         JNZ   L4BBEH
L4BB7H:  
        OR    CS:[CURRENT_MODE],1            ;Set low order bit
         RET

L4BBEH:  
        XOR   AL,AL
         RET
P_0026   ENDP

;------------------------------------------------------------
P_0028   PROC  NEAR
;------------------------------------------------------------
L4BC1H:  
        CMP   BYTE PTR [SI]+0A0H,AL
         JNZ   L4BBEH
         CMP   BYTE PTR [SI]+140H,AL
         JNZ   L4BBEH
         MOV   AX,WORD PTR [SI]-2
         OR    AH,AH
         JS    L4BB7H
         CMP   AL,THAI_SPACE
         JNC   L4BBEH
         MOV   AX,WORD PTR [SI]+2
         OR    AH,AH
         JS    L4BB7H
         CMP   AL,' '
         JBE   L4BB7H
         AND   AL,0DFH
         CMP   AL,'['
         JNC   L4BBEH
         CMP   AL,'@'
         JNC   L4BB7H
         JMP   SHORT L4BBEH
P_0028   ENDP

;------------------------------------------------------------
;
;------------------------------------------------------------
L4BEFH PROC  NEAR
        CMP   BYTE PTR [SI]-2,AL
         JC    L4BB7H
         CMP   BYTE PTR [SI]-4,AL
         JNC   L4BBEH
         CMP   BYTE PTR [SI]-2,RU
         JNZ   L4BBEH
         JMP   SHORT L4BB7H
L4BEFH ENDP

;------------------------------------------------------------
;
;------------------------------------------------------------
L4C01H PROC  NEAR
        TEST  CS:[CURRENT_MODE],1            ;Low bit set?
         JZ    L4C2EH
         XOR   SI,SI
         MOV   CX,SCREEN_SIZE
L4C0EH:  
         CALL  L4B7FH
         JZ    L4C24H
         MOV   AX,WORD PTR [SI]
         OR    AH,80H
         CALL  WORD PTR CS:[BX]+L45E4H
         MOV   AX,WORD PTR [SI]
         CALL  WORD PTR CS:[BX]+L45E6H

L4C24H:  
        INC   SI
         INC   SI
         LOOP  L4C0EH            ;Dec CX, loop if CX<>0.
         AND   CS:[CURRENT_MODE],0FEH  ;Clear low order bit

L4C2EH:  
        RET
L4C01H ENDP

;======================================================================
; Video Services - Interrupt 10H handler
;----------------------------------------------------------------------
VIDINT10 PROC NEAR
         CMP   AH,80H            ;Custom command (High bit set)?
         JNC CSTM_VID

VNOTCSTM:
         OR    AH,AH             ;Func 0? Set video mode
         JZ SETVMODE

VNOT_00H:
        CMP   BYTE PTR CS:[DISPMODE],ENGLISH  ;Are we controlling video?
         JZ    ORIG_VID
;         PUSH  DS
;         MOV   DS,CS:[VID_SEG]
;         CMP   BYTE PTR DS:[7FFFH],3
;         POP   DS
         CMP CS:VMODEFLAG, 3  ;//TEST//
         JNZ   ORIG_VID
         CMP   AH,6              ;Func 6 - Scroll Up?
         JNZ   VNOT_06H
         CMP   AL,1              ;Just 1 line?
         JNZ   ORIG_VID
         OR    CX,CX             ;0,0?
         JNZ   ORIG_VID          ;No
         CMP   DX,OFFSET 184FH   ;24,79?
         JNZ   ORIG_VID          ;No
         CALL  SCRL_UP1
         IRET                    ;Return from interrupt.

VNOT_06H:
        CMP   AH,0EH            ;Func 0E - Write char TTY?
         JZ WRIT_TTY

VNOT_TTY:
        CMP   AH,10H            ;Restrict Funcs 10h - 12h
         JC    ORIG_VID          ;Less than 10h, let it pass
         CMP   AH,12H
         JG    VID_GT12          ;Greater than 12h, skip
         CMP   AL,30             ;RETURN FONT INFO?
         JZ    ORIG_VID          ;Ok, let is pass
         CMP   BL,10H            ;RETURN EGA INFO?
         JZ    ORIG_VID          ;Ok, let it pass, else ignore.
VID_EXIT:
        IRET                    ;Return from interrupt.

VID_GT12:
        CMP   AH,1CH
         JC    VID_EXIT
         JNZ   ORIG_VID
         CMP   AL,2
         JNZ   ORIG_VID
         XOR   CX,CX
ORIG_VID:
        JMP   DWORD PTR CS:[OLDINT10]
VIDINT10 ENDP

TRANSLATE_FONT_CHAR PROC NEAR
LOAD_AND_TRANSLATE:
         MOV   AL,BYTE PTR [SI]
TRANSLATE_ALREADY_LOADED:
         XOR   BH,BH
         TEST  CS:[DISPXLAT],1
         JZ    @@1
         MOV   BL,AL
         MOV   AL,BYTE PTR CS:[BX]+XLAT_TBL
@@1:
         RET
TRANSLATE_FONT_CHAR ENDP

;======================================================================
; Update screen display and chain to old timer interrupt
; Thai 25 line mode
;----------------------------------------------------------------------
UPDATE_SCREEN_THAI_25 PROC NEAR
         CLD                     ;Set forward direction flag.
L4CA3H:  
        MOV   DX,MODE_CONTROL_REG_MONO
         MOV   AL,0AAH
         OUT   DX,AL
         MOV   DS,CS:[VID_SEG]
         CALL  L4C01H

         MOV   AX,CS
         MOV   ES,AX
         MOV   DI,OFFSET VID_SAVE
         XOR   SI,SI
         MOV   CX,SCREEN_SIZE
         REPZ CMPSW                       ;Has video memory changed?
         JNZ   VMEM_CHANGED_25            ;Yes, update video

         MOV   BP,WORD PTR CS:[VID_OFFSET]
         CALL  L4FDDH                     ;Check cursor position
         CMP   BP,DI                      ;Has it changed?
         JZ UPD_25_EXIT                   ;No, we're done

         XCHG  DI,BP                      ;Load old cursor position
         CALL  CS:[DRAW_CURSOR]           ;Turn it off
         MOV   DI,BP                      ;Load new position
         CALL  CS:[DRAW_CURSOR]           ;Turn it on
         JMP   UPD_25_EXIT

VMEM_CHANGED_25:  
        MOV   DI,WORD PTR CS:[VID_OFFSET]
         CALL  CS:[DRAW_CURSOR]
         DEC   SI
         DEC   SI
         MOV   CX,160
         XOR   DX,DX
         MOV   AX,SI
         DIV   CX
         MOV   BX,AX
         SUB   SI,DX
L4CFAH:  
        _PUSH BX,SI
         MOV   ES,WORD PTR CS:[VIDBUF]
         SHL   BX,1
         MOV   DI,WORD PTR CS:[BX]+L0506H
         MOV   CL,80
L4D0AH:  
        MOV   AL,BYTE PTR [SI]
         CMP   AL,' '
         JNZ   L4D4EH
         MOV   BX,SI
L4D12H:  
        INC   BX
         INC   BX
         CMP   BYTE PTR [BX],AL
         LOOPZ L4D12H            ;Dec CX, loop if Z and CX<>0.
         SUB   BX,SI
         SHR   BX,1
         CMP   CS:[DISPLAY_COLUMN_ADJUST],CH
         JZ    L4D3DH
         CMP   BL,CS:[DISPLAY_COLUMN_ADJUST]
         JC    L4D3DH
         MOV   AH,BYTE PTR [SI]-1
         OR    DH,DH
         JZ    L4D3DH
L4D31H:  
        PUSH  AX
         CALL  CS:[L04FAH]
         POP   AX
         INC   DI
         DEC   DH
         JNZ   L4D31H
L4D3DH:  
        LODSW                   ;Load AX with wrd at DS:SI ++.
         CALL  CS:[L04FAH]
         INC   DI
         DEC   BX
         JNZ   L4D3DH
         OR    CX,CX
         JZ L4EB0H

L4D4EH:  
        CALL  L4B7FH
         JZ    L4D58H
         _POP  SI,BX
         JMP   L4EE5H

L4D58H:  
        MOV   AX,WORD PTR [SI]
         OR    AL,AL
         JNS   L4D8BH
         OR    AH,AH
         JNS   L4D8BH
         MOV   AH,BYTE PTR [SI]-1
         OR    DH,DH
         JZ    L4D75H
L4D69H:  
        PUSH  AX
         CALL  CS:[L04FAH]
         POP   AX
         INC   DI
         DEC   DH
         JNZ   L4D69H
L4D75H:  
        LODSW                   ;Load AX with wrd at DS:SI ++.
         AND   AX,7F7FH
         MOV   BP,OFFSET FONT_1
L4D7CH:  
        XCHG  SI,BP
         CALL  CS:[L04FCH]
         MOV   SI,BP
         INC   DI
         LOOP  L4D0AH            ;Dec CX, loop if CX<>0.
         JMP   L4EB0H

L4D8BH:  
        MOV   BP,OFFSET FONT_2
         INC   SI
         INC   SI
         CALL TRANSLATE_ALREADY_LOADED
        MOV   BL,AL
         CMP   BYTE PTR CS:[BX]+L152FH,END_OF_STRING
         JNZ   L4D7CH
         MOV   DL,CL
         PUSH  AX
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         ADD   BX,BP
         MOV   BP,OFFSET L14FBH
         MOV   CX,7
L4DBEH:  
        MOV   AX,WORD PTR CS:[BX]
         MOV   WORD PTR CS:[BP]+0,AX
         INC   BX
         INC   BX
         INC   BP
         INC   BP
         LOOP  L4DBEH            ;Dec CX, loop if CX<>0.
         MOV   BP,OFFSET L14FBH
         DEC   DL
         JZ L4EA7H

L4DD5H:  
        CALL LOAD_AND_TRANSLATE
        MOV   BL,AL
         MOV   AH,BYTE PTR CS:[BX]+L152FH
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         ADD   BX,OFFSET FONT_2
         MOV   CX,7
         CMP   AH,7
         JNZ   L4E47H
L4E03H:  
        MOV   AX,WORD PTR CS:[BX]
         OR    WORD PTR CS:[BP]+0,AX
         INC   BX
         INC   BX
         INC   BP
         INC   BP
         LOOP  L4E03H            ;Dec CX, loop if CX<>0.
         MOV   BP,OFFSET L14FBH
         INC   SI
         INC   SI
         INC   DH
         DEC   DL
         JZ L4EA7H

L4E1EH:
        CALL LOAD_AND_TRANSLATE
        MOV   BL,AL
         MOV   AH,BYTE PTR CS:[BX]+L152FH
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         ADD   BX,OFFSET FONT_2
         MOV   CX,7
L4E47H:
        CMP   AH,8
         JNZ   L4E8DH
L4E4CH:
        MOV   AX,WORD PTR CS:[BX]
         OR    WORD PTR CS:[BP]+0,AX
         INC   BX
         INC   BX
         INC   BP
         INC   BP
         LOOP  L4E4CH            ;Dec CX, loop if CX<>0.
         MOV   BP,OFFSET L14FBH
         INC   SI
         INC   SI
         INC   DH
         DEC   DL
         JZ    L4EA7H
        CALL LOAD_AND_TRANSLATE
        MOV   BL,AL
         MOV   AH,BYTE PTR CS:[BX]+L152FH
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         SHL   BX,1
         ADD   BX,OFFSET FONT_2+2
         MOV   CX,6
L4E8DH:  
        CMP   AH,HT
         JNZ   L4EA7H
L4E92H:  
        MOV   AX,WORD PTR CS:[BX]
         OR    WORD PTR CS:[BP]+0,AX
         INC   BX
         INC   BX
         INC   BP
         INC   BP
         LOOP  L4E92H            ;Dec CX, loop if CX<>0.
         MOV   BP,OFFSET L14FBH
         INC   SI
L4EA3H:  
        INC   SI
         INC   DH
         DEC   DX

L4EA7H:  
        POP   AX
         MOV   AL,CH
         MOV   CL,DL
         INC   CX
         JMP   L4D7CH

L4EB0H:  
        MOV   AH,BYTE PTR [SI]-1
         OR    DH,DH
         JZ    L4EC3H
L4EB7H:  
        PUSH  AX
         CALL  CS:[L04FAH]
         POP   AX
         INC   DI
         DEC   DH
         JNZ   L4EB7H
L4EC3H:  
        _POP  SI,BX
         MOV   AX,CS
         MOV   ES,AX
         MOV   CL,50H
         MOV   DI,OFFSET VID_SAVE
         ADD   DI,SI
         REPZ MOVSW              ;Move wrd, DS:SI to ES:DI ++.
L4ED2H:  
        INC   BX
         CMP   BX,19H
         JZ    L4EE5H
         MOV   CL,50H
         MOV   AX,SI
         REPZ CMPSW              ;Compare strings.
         JZ    L4ED2H
         MOV   SI,AX
         JMP   L4CFAH

L4EE5H:  
        CALL  L4FDDH
         CALL  CS:[DRAW_CURSOR]

UPD_25_EXIT:  
        RET
UPDATE_SCREEN_THAI_25 ENDP


UPDATE_SCREEN_THAI_8 PROC NEAR
         CLD                     ;Set forward direction flag.
         MOV   DX,MODE_CONTROL_REG_MONO
         MOV   AL,0AAH
         OUT   DX,AL
         MOV   DS,CS:[VID_SEG]
         CALL  L4C01H
         MOV   AX,CS
         MOV   ES,AX
         MOV   DI,OFFSET VID_SAVE
         XOR   SI,SI
         MOV   CX,SCREEN_SIZE           ;80 cols x 25 lines = 2000
         REPZ CMPSW              ;Compare strings.
         JNZ   L4F43H
         MOV   BP,WORD PTR CS:[VID_OFFSET]
         CALL  L4FDDH
         CMP   BP,DI
         JZ L4FCFH

L4F32H:  
        XCHG  DI,BP
         CALL  CS:[DRAW_CURSOR]
         MOV   DI,BP
         CALL  CS:[DRAW_CURSOR]
         RET                ;SAVE 2 BYTES

L4F43H:  
        MOV   BP,CX
         MOV   DI,WORD PTR CS:[VID_OFFSET]
         CALL  CS:[DRAW_CURSOR]
         MOV   CX,BP
L4F51H:  
        MOV   BP,SI
         DEC   SI
         DEC   SI
         CALL  L4B7FH
         JNZ   L4FC7H
         PUSH  CX
         MOV   CX,80
         MOV   AX,SI
         SHR   AX,1
         XOR   DX,DX
         DIV   CX
         SHL   AX,1
         MOV   DI,AX
         MOV   DI,WORD PTR CS:[DI]+L0506H
         ADD   DI,DX
         MOV   ES,WORD PTR CS:[VIDBUF]
         MOV   AX,WORD PTR [SI]
         SegCS
         MOV   WORD PTR CS:[SI]+OFFSET VID_SAVE,AX
         MOV   SI,OFFSET FONT_1
         OR    AL,AL
         JNS   L4F8DH
         OR    AH,AH
         JNS   L4F8DH
         AND   AX,7F7FH
         JMP   SHORT L4FB0H
L4F8DH:  
        CALL TRANSLATE_ALREADY_LOADED
        CMP   AL,' '
         JNZ   L4FA9H
         CALL  CS:[L04FAH]
         JMP   SHORT L4FB5H
L4FA9H:  
        OR    AL,AL
         JS    L4FB0H
         MOV   SI,OFFSET FONT_2
L4FB0H:  
        CALL  CS:[L04FCH]

L4FB5H:  
        MOV   SI,BP
         POP   CX
         JCXZ  L4FC7H            ;Jump if CX=0.
         MOV   AX,CS
         MOV   ES,AX
         MOV   DI,OFFSET VID_SAVE
         ADD   DI,SI
         REPZ CMPSW              ;Compare strings.
         JNZ   L4F51H
L4FC7H:  
        CALL  L4FDDH
         CALL  CS:[DRAW_CURSOR]

L4FCFH:  
        RET
UPDATE_SCREEN_THAI_8 ENDP

;------------------------------------------------------------
P_002C   PROC  NEAR
;------------------------------------------------------------
L4FDDH:  
        MOV   DX,CS:[CRTBASE]
         MOV   AX,0F0EH
         OUT   DX,AL
         INC   DX
         IN    AL,DX
         XCHG  AL,AH
         DEC   DX
         OUT   DX,AL
         INC   DX
         IN    AL,DX
         MOV   SI,AX
         XOR   DX,DX
         MOV   CX,80
         DIV   CX
         CMP   AL,19H
         JC    L5002H
         MOV   DI,CS:[L0538H]
         JMP   SHORT L505BH
L5002H:  
        SHL   AX,1
         SHL   SI,1
         MOV   DI,AX
         MOV   DI,WORD PTR CS:[DI]+L0506H
         ADD   DI,DX
         CMP   BYTE PTR CS:[DISPMODE],THAI_25
         JNZ   L505BH
         MOV   CX,DX
         JCXZ  L505BH            ;Jump if CX=0.
         SHL   DX,1
         MOV   DS,CS:[VID_SEG]
         SUB   SI,DX
         XOR   DX,DX
L5026H:  
        MOV   AX,WORD PTR [SI]
         CMP   AL,' '
         JNZ   L504BH
         XOR   BX,BX
L502EH:  
        INC   BX
         INC   SI
         INC   SI
         CMP   BYTE PTR [SI],AL
         LOOPZ L502EH            ;Dec CX, loop if Z and CX<>0.
         CMP   CS:[DISPLAY_COLUMN_ADJUST],DH
         JZ    L5047H
         CMP   BL,CS:[DISPLAY_COLUMN_ADJUST]
         JC    L5047H
         ADD   DI,DX
         XOR   DX,DX
L5047H:  
        JCXZ  L505BH            ;Jump if CX=0.
         MOV   AL,BYTE PTR [SI]
L504BH:  
        INC   SI
         INC   SI
         OR    AL,AL
         JNS   L5066H
         OR    AH,AH
         JNS   L5066H
         ADD   DI,DX
         XOR   DX,DX
L5059H:  
        LOOP  L5026H            ;Dec CX, loop if CX<>0.
L505BH:  
        MOV   WORD PTR CS:[CURSOR_SAVE],SI
         MOV   WORD PTR CS:[VID_OFFSET],DI
         RET

L5066H:  
        CALL TRANSLATE_ALREADY_LOADED
        MOV   BL,AL
         CMP   BYTE PTR CS:[BX]+L152FH,END_OF_STRING
         JNZ   L5059H
         DEC   CX
         JZ    L505BH
        CALL LOAD_AND_TRANSLATE
        MOV   BL,AL
         MOV   AH,BYTE PTR CS:[BX]+L152FH
         CMP   AH,7
         JNZ   L50C4H
L50A3H:  
        INC   SI
         INC   SI
         DEC   DI
         INC   DX
         DEC   CX
         JZ    L505BH
        CALL LOAD_AND_TRANSLATE
        MOV   BL,AL
         MOV   AH,BYTE PTR CS:[BX]+L152FH
L50C4H:  
        CMP   AH,8
         JNZ   L50EAH
         INC   SI
         INC   SI
         DEC   DI
         INC   DX
         DEC   CX
         JZ    L505BH
        CALL LOAD_AND_TRANSLATE
        MOV   BL,AL
         MOV   AH,BYTE PTR CS:[BX]+L152FH
L50EAH:  
        CMP   AH,HT                    ;TAB char?
         JNZ L5026H

L50F2H:  
        INC   SI
         INC   SI
         DEC   DI
         INC   DX
         JMP   L5059H
P_002C   ENDP

;------------------------------------------------------------
P_002D   PROC  NEAR
;------------------------------------------------------------
BEEP:    
        _PUSH AX,CX
         MOV   AL,0B6H           ;SET UP SQUARE WAVE
         OUT   43H,AL
         MOV   AX,0533H          ;TONE
         OUT   42H,AL
         MOV   AL,AH
         OUT   42H,AL            ;TONE
         IN    AL,61H
         MOV   AH,AL
         OR    AL,3
         OUT   61H,AL            ;Turn speaker on
         XOR   CX,CX            ;Start at 0, dec to 0FFFFH, count to zero
BEEP_1:  
        LOOP  BEEP_1            ;Dec CX, loop if CX<>0.
         MOV   AL,AH
         OUT   61H,AL            ;Turn speaker off
         _POP  CX,AX
         RET
P_002D   ENDP

;------------------------------------------------------------
P_002E   PROC  NEAR
;------------------------------------------------------------
SETVMODE:
        CLD                     ;Set forward direction flag.
         _PUSH BX,CX,DX,DI,SI,DS,ES
         CALL  CS:[L04EAH]
;         MOV   DS,CS:[VID_SEG]
;         MOV   BYTE PTR DS:[7FFFH],AL
         MOV  CS:VMODEFLAG, AL  ;//TEST//
         MOV   ES,CS:[VID_SEG]
         XOR   DI,DI
         MOV   CX,SCREEN_SIZE
         MOV   AX,0720H
         REPZ STOSW              ;Store wrd in AX in ES:DI ++.
         MOV   AX,CS
         MOV   ES,AX
         MOV   DI,OFFSET VID_SAVE
         MOV   CX,SCREEN_SIZE
         REPZ STOSW              ;Store wrd in AX in ES:DI ++.
         _POP  ES,DS,SI,DI,DX,CX,BX
         IRET                    ;Return from interrupt.
P_002E   ENDP

;------------------------------------------------------------
P_002F   PROC  NEAR
;------------------------------------------------------------
SCRL_UP1:
        CLI                     ;Disable interrupts.
         CLD                     ;Set forward direction flag.
          _PUSH BX,CX,DX,DI,SI,DS,ES
         MOV   DI,WORD PTR CS:[VID_OFFSET]
         CALL  CS:[DRAW_CURSOR]
         MOV   AX,CS:[VID_SEG]   ;Point ES and DS to VID_SEG
         MOV   ES,AX
         MOV   DS,AX
         XOR   DI,DI             ;Destination is Line1 (offset 0)
         MOV   SI,160            ;Source is Line2 (offset 160)
         MOV   CX,1920           ;Length is 24 lines
         REPZ MOVSW              ;Move screen up one line
         MOV   AH,BH             ;Default attribute in AH
         MOV   AL,' '            ;SPACE char
         MOV   CL,80             ;Line size
         REPZ STOSW              ;Fill bottom line with spaces
         MOV   AX,CS                    ;Set ES & DS to Code Seg
         MOV   ES,AX
         MOV   DS,AX
         MOV   DI,OFFSET VID_SAVE       ;Beginning of screen save area
         MOV   SI,OFFSET VIDLINE2       ;Line 2
         MOV   CX,1920                  ;24 lines
         REPZ MOVSW                     ;Scroll Save buffer one line
         CALL  [L04F2H]
         MOV   DI,WORD PTR CS:[VID_OFFSET]
         CALL  CS:[DRAW_CURSOR]
          _POP  ES,DS,SI,DI,DX,CX,BX
         RET
P_002F   ENDP

;------------------------------------------------------------
WRIT_TTY PROC  NEAR
;------------------------------------------------------------
          _PUSH BX,DX,DS
         MOV   BX,BIOS_SEG                   ;Point DS to BIOS segment
         MOV   DS,BX                    ; Calculate offset into video
                                        ; (Row * 80) + column
         MOV   BL,BYTE PTR DS:[BIOS_CURSOR_ROW_PG0]     ;Get cursor row
         SHL   BX,1                     ; * 2
         SHL   BX,1                     ; * 4
         SHL   BX,1                     ; * 8
         SHL   BX,1                     ; * 16
         MOV   DX,BX                    ;DX = row * 16
         SHL   BX,1                     ; * 32
         SHL   BX,1                     ; * 64
         ADD   BX,DX                    ;BX = row * 80
         MOV   DX,WORD PTR DS:[BIOS_CURSOR_COL_PG0]     ;Get cursor column
         ADD   BL,DL                    ;Add column
         ADC   BH,0                     ;Add in carry flag
         SHL   BX,1                     ;Double it for attribute
         MOV   DS,CS:[VID_SEG]          ;Point DS to video
         CMP   AL,BELL                  ;Ring the bell?
         JNZ   NOT_BELL
         CALL  BEEP                     ;Ring it!
         JMP   SHORT TTY_EXIT
NOT_BELL:  
        CMP   AL,BACKSPC             ;BACKSPACE?
         JNZ   NOT_BS
         OR    DL,DL                    ;Are we already at beginning of line?
         JZ    TTY_EXIT                 ;Yes, get out
         DEC   DX                       ;Decrement column number
         JMP   SHORT SETCRSR
NOT_BS:  
        CMP   AL,CR                    ;CARRIAGE RETURN?
         JNZ   NOT_CR                   ;No
         XOR   DL,DL                    ;Set column to 0
         JMP   SHORT SETCRSR
NOT_CR:  
        CMP   AL,LF                    ;LINEFEED?
         JZ    DO_LF                    ;Yes
         MOV   BYTE PTR [BX],AL         ;Put character on screen
         INC   DX                       ;Bump column pointer
         CMP   DL,80                    ;Past end of line?
         JC    SETCRSR                  ;No, set cursor and exit
         XOR   DL,DL                    ;Yes, set column to 0 and Linefeed
DO_LF:  
        INC   DH                        ;Next line
         CMP   DH,25                    ;Past line 25?
         JC    SETCRSR                  ;No, set cursor and exit
         MOV   BH,BYTE PTR [BX]+1       ;Get attribute of current line
         CALL  SCRL_UP1                 ;Scroll screen
         MOV   DX,1800H                 ;Set cursor to line 25 column 1 (24,0)

SETCRSR:  
        XOR   BH,BH
         MOV   AH,2
         PUSHF                   ;Push flag register.
         CALL  DWORD PTR CS:[OLDINT10]  ;Let old interrupt do display
TTY_EXIT:  
         _POP  DS,DX,BX
         IRET                    ;Return from interrupt.
WRIT_TTY ENDP

;======================================================================
; Table of hot keys and routines to handle them
;----------------------------------------------------------------------
KEYTBL   DB   SHIFT_STAT_ALT,SCAN_TILDE         ;ALT-<`> Unload TSR
         DW    UNLOAD
         DB   SHIFT_STAT_CTRL,SCAN_TILDE        ;CTRL-<`> Control panel
         DW    PANEL
         DB   SHIFT_STAT_NOSHIFT,SCAN_TILDE     ;<`> - Switch Thai/English
         DW    THAI_SW
         DB   0,0
         DW    NORMKEY

;======================================================================
; Translate table
;----------------------------------------------------------------------
L522BH   DB   95H,96H,97H,9EH,98H,9FH
         DB   9AH,99H,9BH,9CH,9DH,85H
         DB   86H,87H,8EH,88H,8FH,8AH
         DB   89H,8BH,8CH,8DH,83H,94H
         DB   84H,2DH,92H,90H,93H,2BH
         DB   81H,91H,82H

;======================================================================
; Translate table
;----------------------------------------------------------------------
L524CH   DB   20H,2CH,2EH,0F2H,0F3H,0F4H
         DB   0A3H,0A7H,0F6H,0F7H,0F5H,0F9H
         DB   0C1H,0A2H,0E3H,0BDH,0A8H,0C5H
         DB   2FH,2DH,0C0H,0B6H,0D8H,0D6H
         DB   0A4H,0B5H,0ABH,0C7H,0B2H,0AAH
         DB   0CCH,0C6H,0F1H,0C4H,0DAH,0A9H
         DB   0AFH,0AEH,0E2H,0ACH,0E7H,0B3H
         DB   0EBH,0C9H,0C8H,3FH,0ECH,0CFH
         DB   0ADH,0F0H,0B1H,0A6H,0B8H,0EAH
         DB   0CEH,22H,29H,0EDH,28H,0BAH
         DB   60H,0C5H,0D9H,0F8H,0DFH,0BFH
         DB   0D4H,0E1H,0A1H,0D3H,0B4H,0E0H
         DB   0E9H,0C3H,0E8H,0D2H,0CAH,0B7H
         DB   0D7H,0B9H,0C2H,0E6H,0BEH,0CBH
         DB   0D0H,0D5H,0CDH
L52A3H   DB   0E4H,0BBH,0D1H,0BCH,0B0H,0E5H
         DB   2CH,0A5H,7FH

;======================================================================
; Keyboard interrupt handler
;----------------------------------------------------------------------
KBDINT9 PROC NEAR
;         PUSH  DS
;         MOV   DS,CS:[VID_SEG]
;         CMP   BYTE PTR DS:[7FFFH],3
;         POP   DS
         CMP CS:VMODEFLAG, 3  ;//TEST//
         JZ    THAIKBD
         JMP   DWORD PTR CS:[OLDINT9]

THAIKBD: 
        CLD                     ;Set forward direction flag.
         _PUSH AX,BX,CX,DX,SI,DI,DS,ES
         MOV   AX,BIOS_SEG     ;BIOS data segment
         MOV   DS,AX
         MOV   AH,BYTE PTR DS:[BIOS_SHIFT_STATUS] ;Shift status flags
         AND   AH,0FH            ;Mask of 'LOCK STATE' flags
         MOV   SI,OFFSET KEYTBL
         IN    AL,60H            ;Get scan code
         XCHG  AL,AH             ;Swap scan code and flags
HOTKEYLP:
        CMP   WORD PTR CS:[SI],0;End of HOTKEY list?
         JZ    KB_EXIT           ;Yes, get out
         CMP   WORD PTR CS:[SI],AX;Is this one of our hotkeys?
         JZ    ITS_OURS          ;Yes, handle it.
         ADD   SI,4H             ;Else bump to next entry
         JMP   SHORT HOTKEYLP    ;Keep looking
ITS_OURS:
        IN    AL,61H            ;Get control port status
         MOV   AH,AL             ;Save it
         OR    AL,80H            ;Reset keyboard
         OUT   61H,AL
         MOV   AL,AH             ;Restore status
         OUT   61H,AL            ;Keyboard has been reset
         CLI                     ;Disable interrupts.
         MOV   AL,20H
         OUT   20H,AL            ;End of interrupt to 8259
KB_EXIT: 
        CALL  WORD PTR CS:[SI]+2;Call function for key
         _POP  ES,DS,DI,SI,DX,CX,BX,AX
         IRET                    ;Return from interrupt.
KBDINT9 ENDP

;======================================================================
; Pop up window and ask the user if the TSR should be unloaded.
; If other programs have hooked the interrupts, tell the user
; that we can't unload.
;------------------------------------------------------------
UNLOAD PROC  NEAR
         CALL  SAVE_SCREEN
         MOV   [MENU_LEFT_COLUMN],UNLOAD_LEFT_COLUMN 
         MOV   [MENU_TOP_ROW],UNLOAD_TOP_ROW
         MOV   [MENU_WIDTH],UNLOAD_WIDTH
         MOV   [MENU_HEIGHT],UNLOAD_HEIGHT
         MOV   [MENU_FRAME_WIDTH],UNLOAD_FRAME_WIDTH
         MOV   [MENU_EDGE_WIDTH],UNLOAD_EDGE_WIDTH
         MOV   [MENU_FRAME_COLOR],UNLOAD_FRAME_COLOR
         MOV   [MENU_BACKGROUND_COLOR],UNLOAD_BG_COLOR
         MOV   [MENU_EDGE_COLOR],UNLOAD_EDGE_COLOR
         MOV   [MENU_SHADOW_COLOR],UNLOAD_SHADOW_COLOR
         MOV   [MENU_TITLE_MSG],OFFSET UNLOAD_TITLE
         CALL  DO_MENU
         JMP   SHORT U_SKIP1

UNLOAD_TITLE    DB _SPACE,_KHO_KHAI,_MAI_THO,_O_ANG,_KHO_KHWAI,_WO_WAEN,_SARA_AA,_MO_MA,_SPACE,END_OF_STRING

;======================================================================
; See if all hooked int vectors still have our Code_segment
;======================================================================
U_SKIP1:  
        MOV   [TEXT_COLOR],(BRIGHT_WHITE_BG+BLACK)
         XOR   AX,AX
         MOV   DS,AX
         MOV   AX,CS
         CMP   AX,WORD PTR DS:[INT_TBL_SEG_TIMER]     ;TIMER
         JNZ   CANT_UNLOAD
         CMP   AX,WORD PTR DS:[INT_TBL_SEG_KBD]     ;KEYBOARD
         JNZ   CANT_UNLOAD
         CMP   AX,WORD PTR DS:[INT_TBL_SEG_VIDEO]     ;VIDEO
         JNZ   CANT_UNLOAD
         CMP   AX,WORD PTR DS:[INT_TBL_SEG_PRINTER]     ;PRINTER
         JZ OK_TO_UNLOAD

CANT_UNLOAD:  
         MOV   DS,AX
         MOV   CX,10
         MOV   DX,20
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET CANT_UNLOAD_MSG1
         CALL  DO_MSG
         JMP   SHORT CANT_UNLOAD_SKIP1

CANT_UNLOAD_MSG1 LABEL BYTE
         DB   _SARA_MAI_MALAI,_MO_MA,_MAI_EK,_SO_SUA,_SARA_AA,_MO_MA
         DB   _SARA_AA,_RO_RUA,_THO_THUNG,_YO_YAK,_KO_KAI,_SARA_E
         DB   _LO_LING,_SARA_I,_KO_KAI,_KO_KAI,_SARA_AA,_RO_RUA
         DB   _SARA_MAI_MUAN,_CHO_CHANG,_MAI_THO,_NGO_NGU,_SARA_AA,_NO_NU
         DB   _SARA_MAI_MALAI,_DO_DEK,_MAI_THO,END_OF_STRING

CANT_UNLOAD_SKIP1:  
         MOV   CX,10
         MOV   DX,34
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET CANT_UNLOAD_MSG2
         CALL  DO_MSG
         JMP   SHORT CANT_UNLOAD_SKIP2

CANT_UNLOAD_MSG2 LABEL BYTE
         DB   _SARA_E,_NO_NU,_SARA_UEE,_MAI_EK,_O_ANG,_NGO_NGU
         DB   _CHO_CHAN,_SARA_AA,_KO_KAI,_MO_MA,_SARA_II,_SPACE
         DB   _SARA_O,_PO_PLA,_RO_RUA,_SARA_EE,_KO_KAI,_RO_RUA
         DB   _MO_MA,_O_ANG,_SARA_UEE,_MAI_EK,_NO_NU,_THO_THAHAN
         DB   _SARA_AM,_NGO_NGU,_SARA_AA,_NO_NU,END_OF_STRING

CANT_UNLOAD_SKIP2:  
         MOV   CX,10
         MOV   DX,48
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET CANT_UNLOAD_MSG3
         CALL  DO_MSG
         JMP   SHORT CANT_UNLOAD_SKIP3
; "???? resident program"
CANT_UNLOAD_MSG3 LABEL BYTE
         DB   _SARA_E,_PO_PLA,_MAI_TAI_KHU,_NO_NU,_SARA_EE,_BO_BAIMAI
         DB   _BO_BAIMAI
         DB   _SPACE,r_,e_,s_,i_,d_,e_,n_,t_,_SPACE
         DB   p_,r_,o_,g_,r_,a_,m_
         DB   END_OF_STRING

CANT_UNLOAD_SKIP3:  
         MOV   AX,UNLOAD_SHADOW_COLOR     ;BLACK
         CALL  [SET_SHADOW_COLOR]
         MOV   AX,UNLOAD_EDGE_COLOR       ;BRIGHT_CYAN
         CALL  [SET_EDGE_COLOR]
         MOV   CX,71
         MOV   DX,69
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,50
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,15
         CALL  DRAW_LINE
         MOV   AX,UNLOAD_SHADOW_COLOR     ;BLACK
         CALL  [SET_EDGE_COLOR]
         MOV   CX,120
         MOV   DX,84
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,-49
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,-15
         CALL  DRAW_LINE
         MOV   [TEXT_COLOR],UNLOAD_FRAME_COLOR SHL 4 +BLACK
         MOV   CX,75
         MOV   DX,70
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET CANT_UNLOAD_MSG4
         CALL  DO_MSG
         JMP   SHORT CANT_UNLOAD_SKIP4

CANT_UNLOAD_MSG4 LABEL BYTE
         DB   _SPACE,_TO_TAO,_KO_KAI,_LO_LING,_NGO_NGU,_SPACE,END_OF_STRING

CANT_UNLOAD_SKIP4:  
         XOR   AH,AH    ;KBD_READ
         INT   16H
         JMP   RESTORE_SCREEN
;------------------------------------------------------------
OK_TO_UNLOAD:
         MOV   DS,AX
         MOV   CX,20
         MOV   DX,20
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET OK_MSG1
         CALL  DO_MSG
         JMP   SHORT OK_SKIP1

OK_MSG1 LABEL BYTE
         DB   _SPACE,_TO_TAO,_MAI_THO,_O_ANG,_NGO_NGU,_KO_KAI
         DB   _SARA_AA,_RO_RUA,_YO_YAK,_KO_KAI,_SARA_E,_LO_LING
         DB   _SARA_I,_KO_KAI,_KO_KAI,_SARA_AA,_RO_RUA,_SARA_MAI_MUAN
         DB   _CHO_CHANG,_MAI_THO,_NGO_NGU,_SARA_AA,_NO_NU,_SPACE
         DB   END_OF_STRING

OK_SKIP1:
         MOV   CX,20
         MOV   DX,34
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET OK_MSG2
         CALL  DO_MSG
         JMP   SHORT OK_SKIP2

OK_MSG2 LABEL BYTE
         DB   _SPACE,_SPACE,_SPACE,_SPACE,_RO_RUA,_SARA_A
         DB   _BO_BAIMAI,_BO_BAIMAI,_PHO_SAMPHAO,_SARA_AA,_SO_RUSI,_SARA_AA
         DB   _SARA_MAI_MALAI,_THO_THAHAN,_YO_YAK,_QUESTION,_SPACE,_SPACE
         DB   _SPACE,_SPACE,_SPACE,END_OF_STRING

OK_SKIP2:
         MOV   AX,UNLOAD_SHADOW_COLOR    ;BLACK
         CALL  [SET_SHADOW_COLOR]
         MOV   AX,UNLOAD_EDGE_COLOR      ;BRIGHT_CYAN
         CALL  [SET_EDGE_COLOR]
         MOV   CX,23
         MOV   DX,69
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,50
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,15
         CALL  DRAW_LINE
         MOV   AX,UNLOAD_SHADOW_COLOR   ;BLACK
         CALL  [SET_EDGE_COLOR]
         MOV   CX,72
         MOV   DX,84
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,-49
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,-15
         CALL  DRAW_LINE
         MOV   [TEXT_COLOR],UNLOAD_FRAME_COLOR SHL 4 + BLACK
         MOV   CX,24
         MOV   DX,70
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET OK_MSG3
         CALL  DO_MSG
         JMP   SHORT OK_SKIP3

OK_MSG3 LABEL BYTE
         DB   _SPACE,_TO_TAO,_KO_KAI,_LO_LING,_NGO_NGU,_SPACE
         DB   END_OF_STRING

OK_SKIP3:
         MOV   AX,UNLOAD_SHADOW_COLOR ;BLACK
         CALL  [SET_SHADOW_COLOR]
         MOV   AX,UNLOAD_EDGE_COLOR   ;BRIGHT_CYAN
         CALL  [SET_EDGE_COLOR]
         MOV   CX,119
         MOV   DX,69
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX,58
         MOV   DX,0
         CALL  DRAW_LINE
         MOV   CX,0
         MOV   DX,15
         CALL  DRAW_LINE
         MOV   AX,UNLOAD_SHADOW_COLOR   ;BLACK
         CALL  [SET_EDGE_COLOR]
         MOV   CX,176
         MOV   DX,84
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   CX, -57
         MOV   DX, 0
         CALL  DRAW_LINE
         MOV   CX, 0
         MOV   DX, -15
         CALL  DRAW_LINE
         MOV   [TEXT_COLOR],UNLOAD_FRAME_COLOR SHL 4 + BLACK
         MOV   CX, 120
         MOV   DX, 70
         ADD   CX,[MENU_LEFT_COLUMN]
         ADD   DX,[MENU_TOP_ROW]
         CALL  [CURSOR_CALC]
         MOV   SI,OFFSET OK_MSG4
         CALL  DO_MSG
         JMP   SHORT OK_SKIP4

OK_MSG4 LABEL BYTE
         DB   _SPACE,_YO_YAK,_KO_KAI,_SARA_E,_LO_LING,_SARA_I,_KO_KAI,_SPACE,END_OF_STRING

OK_SKIP4:
         XOR   AH,AH            ;KBD_READ
         INT   16H
         CMP   AX,1C0DH          ;RETURN Key?
         JNZ RESTORE_SCREEN             ;No, restore video and RFT
                                 ;Yes, drop thru, Unload TSR and exit
KILL_TSR:
         mov  ah,25h
         mov  al,8  ;timer
         lds dx,dword ptr CS:[OLDINT8]
         int 21h

         mov  ah,25h
         mov  al,9  ;keyboard
         lds dx,dword ptr CS:[OLDINT9]
         int 21h

         mov  ah,25h
         mov  al,10h  ;video
         lds dx,dword ptr CS:[OLDINT10]
         int 21h

         mov  ah,25h
         mov  al,17h  ;printer
         lds dx,dword ptr CS:[OLDINT17]
         int 21h

         mov  ah,25h
         mov  al,1dh  ;video parms
         lds dx,dword ptr CS:[OLDINT1D]
         int 21h

         MOV   AX, 3H
         int 10h

         MOV   DX,WORD PTR CS:[CURSOR_SAVE]
         XOR   BH,BH
         MOV   AH,2
         int 10h

         PUSH  CS
         POP   DS
         MOV   ES,[VID_SEG]
         MOV   SI,OFFSET VID_SAVE
         XOR   DI,DI
         MOV   CX,SCREEN_SIZE
         MOV   BL,7FH

UNLOAD_RESTORE_LOOP:  
         LODSW                   ;Load AX with wrd at DS:SI ++.
         AND   AH,BL
         STOSW                   ;Store wrd in AX in ES:DI ++.
         LOOP  UNLOAD_RESTORE_LOOP            ;Dec CX, loop if CX<>0.
         PUSH   CS
         POP    ES
         MOV   AH,DOS_FREE_MEMORY           ;Release memory
         INT   21H
         MOV   ES,CS:[FNAMESEG]
         MOV   AH,DOS_FREE_MEMORY           ;Release memory
         INT   21H
         RET                    ;Return to DOS
UNLOAD ENDP

;======================================================================
THAI_SW PROC NEAR
;----------------------------------------------------------------------
         CMP   CS:[THAIMODE],0   ;THAI MODE ACTIVE?
         JZ    NOT_ACTV
         MOV   DI,WORD PTR CS:[VID_OFFSET]
         CALL  CS:[DRAW_CURSOR]
         XOR   CS:[CURRENT_MODE],4            ;Toggle bit 2
         MOV   DI,WORD PTR CS:[VID_OFFSET]
         JMP   CS:[DRAW_CURSOR]             ;RFT
NOT_ACTV:
         RET
THAI_SW ENDP

;======================================================================
NORMKEY PROC NEAR  ;NORMAL KEY HANDLER
;----------------------------------------------------------------------
         STI                     
         PUSHF                   ;Push flag register.
         CALL  DWORD PTR CS:[OLDINT9]
         MOV   BX,WORD PTR DS:[BIOS_KEYBOARD_HEAD_POINTER] ;Get keyboard HEAD pointer
         MOV   AX,WORD PTR DS:[BX]
         CMP   BX,WORD PTR DS:[BIOS_KEYBOARD_TAIL_POINTER] ;Compare HEAD & TAIL (Empty?)
         JZ    NORMEXIT          ;Empty, bail out
         CMP   CS:[THAIMODE],0   ;Thai mode?
         JZ    NORMEXIT          ;No, bail out
         TEST  CS:[CURRENT_MODE],4     ;Bit 2 on?
         JZ    NORMEXIT
         CMP   AL,' '            ;SPACE char?
         JL    NORMEXIT
         JG    NORMKEY_SKIP1
         CMP   CS:[SPACE_A0],0   ;Replace space with 0A0h?
         JZ    NORMEXIT          ;No, exit
         MOV   AL,THAI_SPACE
         JMP   SHORT L5762H
NORMEXIT:
        RET

NORMKEY_SKIP1:  
         CMP   AX,4737H
         JC    L5739H
         CMP   AX,5133H
         JG    L5768H
         CMP   CS:[PANEL_5],1
         JC    L5768H
         MOV   BH,CS:[PANEL_5]
         MOV   BL,AH
         SUB   BL,71
L5729H:  
        DEC   BH
         JZ    L5732H
         ADD   BL,12
         JNZ   L5729H
L5732H:  
        MOV   AL,BYTE PTR CS:[BX]+L522BH
         JMP   SHORT L574FH
L5739H:  
        MOV   BX,OFFSET L524CH
         CMP   CS:[THAIMODE],1
         JZ    L5747H
         MOV   BX,OFFSET L0414H
L5747H:  
        SUB   AL,20H
         SegCS
         XLAT                    ;Translate AL using table at BX.
         OR    AL,AL
         JNS   L5762H
L574FH:  
        XOR   AH,AH
        CALL TRANSLATE_ALREADY_LOADED
L5762H:  
        MOV   BX,WORD PTR DS:[BIOS_KEYBOARD_HEAD_POINTER]
         MOV   WORD PTR DS:[BX],AX
L5768H:  
        RET
NORMKEY ENDP

;======================================================================
; PRINTER DATA AREA
;======================================================================
PBUF_TOP      DB   PRINT_BUF_MAX DUP(0)
PBUF_MDL      DB   PRINT_BUF_MAX DUP(0)
PBUFMAIN      DB   PRINT_BUF_MAX DUP(0)
PBUF_BTM      DB   PRINT_BUF_MAX DUP(0)

P_MULTI_LINE_FLAG        DB   0
PRT_COLUMN    DW   0000H        ;Current position in print line
P_STACK_COUNT        DB   0
P_SPACE_COUNT        DB   0
LAST_LINEFEED DB   0            ;Linefeed (or not) after last buffer
ESC_SAVE      DB   0            ; Previous character from ESC sequence

;======================================================================
; ESC sequence table (Epson)
;======================================================================
PCMD_TBL DB    19H     ;ESC EM - Control Cut Sheet Feeder
         DB    ' '     ;ESC SP - Set Intercharacter Space
         DB    '!'     ;ESC !  - Master Select
         DB    '%'     ;ESC %  - Select User-defined Set
         DB    '&'     ;ESC &  - Define User-defined Characters
         DB    '('     ;ESC (- - Select Score
         DB    '*'     ;ESC *  - Select Graphics Mode
         DB    '+'     ;ESC +n - Set n/360-inch Line Spacing
         DB    '-'     ;ESC -  - Toggle Underline Mode          ;IBM
         DB    '/'     ;ESC /  - Select Vertical Tab Channel
         DB    '3'     ;ESC 3n - Set n/180-inch Line Spacing    ;X GRAPHICS LPI
         DB    'A'     ;ESC An - Set n/60-inch Line Spacing     ;(n/72)+ESC 2
         DB    'C'     ;ESC Cn - Set Page Length                ;IBM
         DB    'I'     ;ESC I  - ????
         DB    'J'     ;ESC Jn - Perform n/180-inch Line Feed   ;(n/216)
         DB    'M'     ;ESC M  - Select 12 CPI                  ;ESC :
         DB    'N'     ;ESC N  - Set Skip Over Perforation
         DB    'Q'     ;ESC Q  - Set Right Margin
         DB    'R'     ;ESC R  - Select an International Character Set ;SET TAB RACKS
         DB    'S'     ;ESC S  - Set (Sub/Super)script mode
         DB    'U'     ;ESC U  - Toggle Unidirectional Mode
         DB    'W'     ;ESC W  - Toggle Double-width Mode
         DB    'a'     ;ESC a  - Select Justification
         DB    'l'     ;ESC l  - Set Left Margin
         DB    'k'     ;ESC k  - Select Typestyle Family
         DB    'n'     ;ESC n  - ????
         DB    'p'     ;ESC p  - Toggle Proportional Mode
         DB    'q'     ;ESC q  - Select Character Style
         DB    's'     ;ESC s  - ????
         DB    't'     ;ESC t  - Select Character Set
         DB    'w'     ;ESC w  - Toggle Double-height Mode
         DB    'x'     ;ESC x  - Select Letter Quality or Draft
PCMD_LEN = $ - PCMD_TBL

;======================================================================
; Printer (Int 17) Interrupt Service Routine
;
;======================================================================
;PREV_AH DB 0  ;//IBM4722//
PRTINT17 PROC NEAR
         OR    AH,AH                            ;Function>0? (1-Init or 2-Status)
         JNZ   DO_OLDPR                         ;Let old int handle Init or Status
         CMP   AL,BACKSPC           ;//IBM4722//
         JZ    DO_OLDPR        ;//IBM4722//
;         JNZ   PRT_01               ;//IBM4722//
;         CMP   CS:[PREV_AH],0            ;//IBM4722//
;         JZ    PRT_01               ;//IBM4722//
;         JMP   DO_OLDPR        ;//IBM4722//
PRT_01:
         CMP   CS:[PCOMPOSE],AH                 ;English mode?
         JZ    DO_OLDPR                         ;Pass it thru

         PUSH  BX
        CALL TRANSLATE_ALREADY_LOADED
         CMP   CS:[PCOMPOSE],THAIPRT1           ;1 line Thai mode?
         JNZ   NOT_1LINE
         XOR   BH,BH                            ;Clear BH for lookup
         TEST  CS:[PRT_XLAT],1                  ;Translate again for print?
         JZ    NO_PRT_XLAT
         MOV   BL,AL
         MOV   AL,BYTE PTR CS:[BX]+PRTXLTBL     ;Translate char
NO_PRT_XLAT:  
         POP   BX
DO_OLDPR:
;        MOV   CS:[PREV_AH],AH       ;//IBM4722//
        JMP   DWORD PTR CS:[OLDINT17]  ;Chain to old interrupt

NOT_1LINE:  
         PUSH  DS

         PUSH  CS
         POP   DS
         MOV   BX,AX                            ;Save print_char, AH=0
         MOV   AH,BYTE PTR DS:[BX]+L152FH       ;
         MOV   BX,WORD PTR DS:[PRT_COLUMN]
         MOV   BYTE PTR DS:[BX]+PBUF_TOP, 20H
         MOV   BYTE PTR [BX]+PBUF_MDL, 20H
         MOV   BYTE PTR [BX]+PBUFMAIN,AL
         MOV   BYTE PTR [BX]+PBUF_BTM, 20H
         CMP   [ESC_SAVE],0      ;Are we processing a command?
         JZ    PNOT_ESC          ;No, go around
         CALL  FILTER
         MOV   AH,1
         JMP   BUMP_POS

PNOT_ESC:
         CMP   AL,' '
         JNZ   P_NOT_SPACE
         INC   [P_SPACE_COUNT]
         MOV   AH,[P_SPACE_COUNT]
         CMP   AH,[DISPLAY_COLUMN_ADJUST]
         JNZ   P_NO_ADJUST
         CMP   [P_STACK_COUNT],0
         JZ    P_NO_ADJUST

P_SPACE_ADJUST_LOOP:  
         INC   BX
         MOV   BYTE PTR [BX]+PBUF_TOP,AL
         MOV   BYTE PTR [BX]+PBUF_MDL,AL
         MOV   BYTE PTR [BX]+PBUFMAIN,AL
         MOV   BYTE PTR [BX]+PBUF_BTM,AL
         DEC   [P_STACK_COUNT]
         JNZ   P_SPACE_ADJUST_LOOP
         MOV   WORD PTR [PRT_COLUMN],BX

P_NO_ADJUST:  
         MOV   AH,4                     ;INDICATE 4 ROW PRINTING
         JMP   BUMP_POS

P_NOT_SPACE:
         MOV   [P_SPACE_COUNT], 0
         CMP   AH,1                     ; 1 ROW PRINTING?
         JNZ   L5D19H
         MOV   BYTE PTR [BX]+PBUF_TOP,AL
         MOV   BYTE PTR [BX]+PBUF_MDL,AL
         MOV   BYTE PTR [BX]+PBUF_BTM,AL
         CMP   AL,ESCAPE            ;ESC char?
         JNZ   NOT_ESC
         MOV   [ESC_SAVE],AL     ;Yes, save it for next char
         JMP   BUMP_POS

NOT_ESC: 
         CMP   AL,LF             ;LINEFEED?
         JZ SHIPIT

         CMP   AL,FormFeed       ;FORMFEED?
         JNZ BUMP_POS

         JMP   SHIPIT

L5D19H:  
         CMP   AH,2
         JNZ   L5D6EH
         CMP   AL,95H
         JC BUMP_POS

L5D25H:  
         CMP   AL,97H
         JG    L5D36H
         MOV   BYTE PTR [BX]+PBUF_BTM, 9FH
         OR    [P_MULTI_LINE_FLAG],1
         JMP   BUMP_POS

L5D36H:  
         CMP   AL,9AH
         JBE   L5D3EH
         CMP   AL,9FH
         JNZ   L5D55H
L5D3EH:  
         MOV   BYTE PTR [BX]+PBUF_TOP, 9FH
         MOV   BYTE PTR [BX]+PBUF_MDL, 9FH
         MOV   BYTE PTR [BX]+PBUF_BTM, 9FH
         OR    [P_MULTI_LINE_FLAG],7
         JMP   BUMP_POS

L5D55H:  
         CMP   AL,9DH
         JLE   L5D5CH
         JMP   BUMP_POS

L5D5CH:  
         MOV   BYTE PTR [BX]+PBUF_TOP, 9FH
         MOV   BYTE PTR [BX]+PBUF_MDL, 9FH
         OR    [P_MULTI_LINE_FLAG],6
         JMP   BUMP_POS

L5D6EH:  
         CMP   AH,7
         JNZ   L5D8AH
         CMP   [LAST_LINEFEED],5
         JNZ   L5DD6H
         MOV   BYTE PTR [BX]+PBUF_BTM-1,AL
         INC   [P_STACK_COUNT]
         OR    [P_MULTI_LINE_FLAG],1
         JMP   PRT_EXIT

L5D8AH:  
         CMP   AH,8
         JNZ   L5DADH
         CMP   [LAST_LINEFEED],5
         JZ    L5D9DH
         CMP   [LAST_LINEFEED],7
         JNZ   L5DD6H
L5D9DH:  
         MOV   BYTE PTR [BX]+PBUF_MDL-1,AL
         INC   [P_STACK_COUNT]
         OR    [P_MULTI_LINE_FLAG],2
         JMP   PRT_EXIT

L5DADH:  
         CMP   AH,HT
         JNZ   L5DDAH
         CMP   [LAST_LINEFEED],8
         JNZ   L5DC8H
         MOV   BYTE PTR [BX]+PBUF_TOP-1,AL
         INC   [P_STACK_COUNT]
         OR    [P_MULTI_LINE_FLAG],4
         JMP   PRT_EXIT
L5DC8H:  
         CMP   [LAST_LINEFEED],5
         JZ    L5D9DH
         CMP   [LAST_LINEFEED],7
         JZ    L5D9DH
L5DD6H:  
         MOV   AH,4
         JMP   SHORT BUMP_POS
L5DDAH:  
         TEST  [PRT_XLAT],2
;//gb051694//         JZ    BUMP_POS
        jz @@TestEpsonVowels
         CMP   AH,6
         JNZ   BUMP_POS
         CMP   AL,SARA_O
         JNZ   L5DFBH
         MOV   BYTE PTR [BX]+PBUFMAIN, 0DBH
         MOV   BYTE PTR [BX]+PBUF_MDL, 0DCH
         OR    [P_MULTI_LINE_FLAG],2
         JMP   SHORT BUMP_POS
L5DFBH:  
         CMP   AL,SARA_MAI_MUAN
         JNZ   L5E10H
         MOV   BYTE PTR [BX]+PBUFMAIN, 0DBH
         MOV   BYTE PTR [BX]+PBUF_MDL, 0DDH
         OR    [P_MULTI_LINE_FLAG],2
         JMP   SHORT BUMP_POS
L5E10H:  
         CMP   AL,SARA_MAI_MALAI
         JNZ   BUMP_POS
         MOV   BYTE PTR [BX]+PBUFMAIN, 0DBH
         MOV   BYTE PTR [BX]+PBUF_MDL, 0DEH
         OR    [P_MULTI_LINE_FLAG],2
         JMP   BUMP_POS
;======================================================================
; Epson printer font does not match IBM for
; SARA_O, SARA_MAI_MUAN, and SARA_MAI_MALAI
;======================================================================
@@TestEpsonVowels:
        CMP [WHICHPTR],IBMPRO
        JZ  BUMP_POS          ;Skip this section if IBM
        CMP AL,SARA_O
        JNZ @@EpSaraMaiMuan
         MOV   BYTE PTR [BX]+PBUFMAIN,90H
@@EpSaraMaiMuan:
        CMP AL,SARA_MAI_MUAN
        JNZ @@EpSaraMaiMalai
         MOV   BYTE PTR [BX]+PBUFMAIN,91H
@@EpSaraMaiMalai:
        CMP AL,SARA_MAI_MALAI
        JNZ BUMP_POS
         MOV   BYTE PTR [BX]+PBUFMAIN,0EEH
;======================================================================
BUMP_POS:

         INC   WORD PTR [PRT_COLUMN]            ;Bump current position
         CMP   WORD PTR [PRT_COLUMN], PRINT_BUF_MAX       ;Buffer full?
         JC    PRT_EXIT                         ;No, get out
         MOV   AL,LF                            ;Terminate line with lf

SHIPIT:  
         CALL  PRINTIT

PRT_EXIT:
         MOV   [LAST_LINEFEED],AH
         _POP  DS,BX
         MOV   AH,2                       ;RETURN PRINTER STATUS
         JMP   DWORD PTR CS:[OLDINT17]
PRTINT17 ENDP

;======================================================================
; Filter ESCAPE sequences
;------------------------------------------------------------
FILTER  PROC  NEAR
        MOV   BYTE PTR [BX]+PBUF_TOP,AL        ;Put character into 
        MOV   BYTE PTR [BX]+PBUF_MDL,AL        ; all three
        MOV   BYTE PTR [BX]+PBUF_BTM,AL        ;  buffers
        CMP   [ESC_SAVE],ESCAPE    ;Was last char ESC?
        JNZ   NO_ESC
        CMP   AL,'@'            ;Initialize printer?
        JNZ   NOT_INIT

;Set line space values back to defaults

        MOV   [LPI_TOP], DFLT_TOP_LPI
        MOV   [LPI_MIDDLE], DFLT_MDL_LPI
        MOV   [LPI_MAIN], DFLT_MAIN_LPI
        MOV   [LPI_FINAL], DFLT_BTM_LPI
        JMP   FLT_EXIT

NOT_INIT:
        CMP   AL,'0'            ;8 LPI?
        JC    NOT_LPI           ;Command is less than 30h
        JNZ   NOT_8LPI          ;Not ESC 0
        MOV   AL,(180/8)        ; 8 LPI @ 180 steps/line
        JMP   SHORT LPI_DONE

NOT_8LPI:
        CMP   AL,'2'            ;6 LPI?
        JC    ESC1
        JNZ   NOT_LPI
        CMP   [WHICHPTR],IBMPRO ;IBM uses ESC2 to activate n/72 setting
        JE    IBM_ESC2
        MOV   AL,(180/6)        ; 6 LPI @ 180 steps/line
        JMP   SHORT LPI_DONE

;----------------------------------------------------------------------
; ESC 1 - 10 lpi
;----------------------------------------------------------------------
ESC1:
        MOV   AL,(180/10)         ;10 LPI @ 180 steps/line

LPI_DONE:
         SUB   WORD PTR [PRT_COLUMN],2H
         JMP  SHORT CALC_180THS

IBM_ESC2:
         SUB   WORD PTR [PRT_COLUMN],2H
         JMP   FLT_EXIT

NOT_LPI:
         MOV   BX,OFFSET PCMD_TBL
         CMP   AL,BYTE PTR [BX]+PCMD_LEN-1        ;31;Is this char valid?
         JG    INV_CMD           ;If greater than last char in table, error
PCMDLOOP:
         CMP   AL,BYTE PTR [BX]  ;Check first char
         JC    INV_CMD           ;This char < 1st table char, error
         JZ    GOOD_CMD
         INC   BX
         JMP   SHORT PCMDLOOP
INV_CMD: 
         XOR   AL,AL             ;Zero out ESC_SAVE
GOOD_CMD:
         MOV   [ESC_SAVE],AL     ;Save it for next time
         RET

NO_ESC:  
         CMP   [ESC_SAVE],'&'    ;User Defined Chars?
         JZ    P_IGNORE
         CMP   [ESC_SAVE],'('    ;Select line?
         JZ    P_IGNORE
         CMP   [ESC_SAVE],'/'    ;Select vert tab channel?
         JZ    P_IGNORE
         CMP   [ESC_SAVE],'*'    ;Select Graphics mode?
         JNZ   FILT_CONTINUE
P_IGNORE:
         CMP   AL,'@'
         JC    BAILOUT           ;Less than '@'?
         CMP   AL,'Z'
         JA    BAILOUT           ;Greater than 'Z'?
         JMP   FLT_EXIT

BAILOUT: 
        RET

FILT_CONTINUE:  
         CMP   [ESC_SAVE],'3'    ;n/180 Line Spacing?
         JZ    PSET_180
         CMP   [ESC_SAVE],'A'    ;n/60 Line Spacing?
         JNZ   NOT_60TH          ;No, go around
         CMP   [WHICHPTR],IBMPRO
         JNE    LPI_60THS        ;Not IBM, go do Epson stuf
         MOV    BL,AL            ;It is IBM, so convert to n/180s (n * 2.5)
         SHL    AL,1
         SHR    BL,1
         ADD    AL,BL
         JMP    SHORT PSET_180
LPI_60THS:
         MOV   BL,AL
         SHL   AL,1
         ADD   AL,BL             ;Multiply value * 3 (n/60 = 3n/180)
         JMP   SHORT PSET_180
NOT_60TH:
         CMP   [ESC_SAVE],'+'    ;n/360 ?
         JNZ   NOT_360TH            ;No, go around
         SHR   AL,1              ;Divide by 2   (n/360 = (n/2)/180)
PSET_180:
         SUB   WORD PTR [PRT_COLUMN],3H;Discard last 3 chars
CALC_180THS:
         MOV   BL,AL
         SUB   BL,(180/4)        ;Less than 4 LPI?
         JLE   NO_BOTTOM
         MOV   LPI_FINAL,BL      ;Give any extra to last line
         MOV   AL,(180/4)        ;Default remaining lines to 4 LPI
         JMP SHORT LPI_CALC
NO_BOTTOM:
         MOV   LPI_FINAL,0       ;Otherwise, no final linefeed
LPI_CALC:
         MOV   BL,AL             ;Copy lpi value to bl
         SUB   AH,AH             ;Clear AH for divide
         PUSH  CX
         MOV   CL,6              ;Set up for divide
         DIV   CL                ;Divide by 6 to get LPI_TOP
         POP   CX
         MOV   [LPI_TOP],AL
         SUB   BL,AL             ;Subtract LPI_TOP from total
         SHR   BL,1              ;Divide remainder by 2
         MOV   [LPI_MIDDLE],BL   ;Give half of it to LPI_MIDDLE
         MOV   [LPI_MAIN],BL     ;Give half of it to LPI_MAIN
         JMP   SHORT FLT_EXIT

NOT_360TH:  
         CMP   [ESC_SAVE],'-'    ;Toggle underlining?
         JNZ   NOT_UNDL
         AND   AL,0FEH           ;Yes, clear low bit.
         JMP   SHORT FLT_STOR    ;Store char and exit
NOT_UNDL:
         CMP   [ESC_SAVE],'!'    ;Master select?
         JNZ   FLT_EXIT
         AND   AL,7FH            ;Clear high bit.
FLT_STOR:
         MOV   BYTE PTR [BX]+PBUF_TOP,AL
         MOV   BYTE PTR [BX]+PBUF_MDL,AL
         MOV   BYTE PTR [BX]+PBUF_BTM,AL
FLT_EXIT:
         MOV   [ESC_SAVE], 0;Clear flag.
         RET
FILTER ENDP

;======================================================================
; Process line feeds
; Input:AH= LF or 0 (0 for no LF)  
;       AL= steps (n/180)
;       If WHICHPTR=IBM, change to n/72 (AL * 0.4)
;======================================================================
; Data area
;----------------------------------------------------------------------
IBM_SEQ        DB ESCAPE,'A'
IBM_FEED       DB 0
               DB ESCAPE,'2'
               DB CR
IBM_LF         DB 0     ;Linefeed character (if any)

IBM_SEQ_LEN = $-IBM_SEQ
;----------------------------------------------------------------------
EPSON_SEQ      DB ESCAPE,'3'
EPSON_FEED     DB 0
               DB CR
EPSON_LF       DB 0     ;Linefeed character (if any)

EPSON_SEQ_LEN = $-EPSON_SEQ
;----------------------------------------------------------------------
; Code area
;----------------------------------------------------------------------
FEED_PAPER PROC NEAR
        PUSH    SI      ;SAVE REGS
        PUSH    CX
        PUSH    DS

        PUSH    CS      ;SET DS=CS
        POP     DS

        CMP     [WHICHPTR],IBMPRO
        JNE     FEED_EPSON

;======================================================================
; Store number of linefeeds in IBM escape sequence string
;======================================================================
        MOV     [IBM_LF],AH     ;Store LF or 0
;----------------------------------------------------------------------
; Calculate lines/inch for IBM - convert n/180 to n/72
;----------------------------------------------------------------------
        OR      AL,AL
        JZ      ZEROFEED        ;IF ZERO, Send CR only

;----------------------------------------------------------------------
; Multiply Epson feed value * 0.4
;----------------------------------------------------------------------
        MOV     CH,4
        MOV     CL,10
        MUL     CH
        ADD     AL,5   ;Add 5 so divide by 10 will round up   //3.01(G)//
        DIV     CL

        MOV     [IBM_FEED],AL   ;STORE VALUE
        LEA     SI,IBM_SEQ
        MOV     CX,IBM_SEQ_LEN
        JMP     SHORT DO_FEED
;----------------------------------------------------------------------
; If feed value is zero, IBM printer retains old value.
; Just send CR and get out.
;----------------------------------------------------------------------
ZEROFEED:
        MOV     AL,CR
        CMP     AH,FORMFEED
        JNE     NOT_FORMFEED
        MOV     AL,AH                   ;MOVE FORMFEED TO AL
NOT_FORMFEED:
        XOR     AH,AH
        PUSHF                           ;Push flag register.
        CALL    DWORD PTR CS:[OLDINT17] ;RFT
        JMP     SHORT FEED_EXIT

;======================================================================
;       LOAD EPSON SEQUENCE AND FALL THRU
;======================================================================
FEED_EPSON:
        MOV     [EPSON_LF],AH
        MOV     [EPSON_FEED],AL
        LEA     SI,EPSON_SEQ
        MOV     CX,EPSON_SEQ_LEN
        ;FALL THRU TO DO_FEED

;======================================================================
; DO LINE FEED
;======================================================================
DO_FEED:
        LODSB                   ;Get character to send to printer
        XOR     AH,AH
        PUSHF                   ;Push flag register.
        CALL    DWORD PTR CS:[OLDINT17]
        LOOP    DO_FEED

FEED_EXIT:
        POP     DS      ; RESTORE REGS
        POP     CX
        POP     SI
        RET
FEED_PAPER ENDP

;======================================================================
; Tables of values to subtract from upper vowels to reach combined
; vowel in printer font
;======================================================================
IBM_COMBINED_VOWEL_OFFSETS:
        DB  67H         ;MAI_HAN_AKAT (0D1H)
        DB  0
        DB  0
        DB  5DH         ;SARA_I (0D4H)
        DB  58H         ;SARA_II (0D5H)
        DB  53H         ;SARA_UE (0D6H)
        DB  4EH         ;SARA_UEE (0D7H)

EPSON_COMBINED_VOWEL_OFFSETS:
        DB  56H         ;MAI_HAN_AKAT (0D1H)      ;//gbtest//
        DB  0
        DB  0
        DB  52H         ;SARA_I (0D4H)            ;//gbtest//
        DB  4DH         ;SARA_II (0D5H)           ;//gbtest//
        DB  0DH         ;SARA_UE (0D6H)          ;//gbtest//
        DB  0EDH         ;SARA_UEE (0D7H)         ;//gbtest//
        
;======================================================================
; Print all component line buffers
;------------------------------------------------------------
PRINTIT PROC  NEAR
        _PUSH  BX,CX,SI
;------------------------------------------------------------
; If printing to IBM, send ESC 6 to select Character Set 2
; This is needed to print 080h - 09fh (Combined vowels)
;------------------------------------------------------------
        CMP [WHICHPTR],IBMPRO
        JNE NOT_IBMPRO
        PUSH  AX
        XOR     AH,AH
        MOV     AL,ESCAPE
        PUSHF                   ;Push flag register.
        CALL    DWORD PTR CS:[OLDINT17]
        XOR     AH,AH
        MOV     AL,'6'
        PUSHF                   ;Push flag register.
        CALL    DWORD PTR CS:[OLDINT17]
        POP   AX
NOT_IBMPRO:
;------------------------------------------------------------
         MOV   [LAST_LINEFEED],AL
         TEST  [P_MULTI_LINE_FLAG],4  ;ANYTHING IN TOP LINE?
         JZ    FEED_TOP_LINE
         CMP   [PCOMPOSE],THAIPRT4    ;4 LINE THAI MODE?
         JZ    PMODE_THAIPRT4
         MOV   SI,OFFSET PBUF_TOP
         MOV   CX,WORD PTR [PRT_COLUMN]

;------------------------------------------------------------
; Here if PMODE_THAIPRT3
; Print combined vowels
;------------------------------------------------------------
PRTLOOP: 
         LODSB                   ;Load AL with byt at DS:SI ++.
         CMP   AL,MAI_EK        ;Is this < MAI_EK ? (0E8H)
         JC    END_PRTLOOP      ;Yes, so not a vowel, next char
         CMP   AL,NIKKHAHIT     ;Is this > NIKKHAHIT ? (0EDH)
         JNC   END_PRTLOOP      ;No, not a vowel, next char
         MOV   AH,BYTE PTR [SI]+(PRINT_BUF_MAX-1) ;Get middle line char
         CMP   AH,NIKKHAHIT     ;Is middle char NIKKHAHIT (0edh)?
         JNZ   PTOP_NOT_NIKKHAHIT ;No...
         ADD   AL,14H           ;This may do weird things on IBM (?)
         JMP   SHORT PUT_IN_MDL_LINE
PTOP_NOT_NIKKHAHIT:  
         CMP  AH,SARA_UEE+1     ;Is middle char > SARA_UEE?
         JNC  END_PRTLOOP       ;Yes, it shouldn't be here, don't xlate
         MOV  BX,OFFSET EPSON_COMBINED_VOWEL_OFFSETS
         CMP  [WHICHPTR],IBMPRO
         JNZ  SUBTRACT_OFFSET
         MOV  BX,OFFSET IBM_COMBINED_VOWEL_OFFSETS
SUBTRACT_OFFSET:
         SUB  BX,MAI_HAN_AKAT   ;INDEX INTO OFFSET TABLE
         PUSH AX
         XCHG AH,AL
         XOR  AH,AH
         ADD  BX,AX             ;BX = TABLE + (AH - 0D1H)
         POP  AX
         SUB  AL,BYTE PTR CS:[BX] ;OFFSET TO COMBINED VOWEL FONT

PUT_IN_MDL_LINE:  
         MOV   BYTE PTR [SI]+(PRINT_BUF_MAX-1),AL
END_PRTLOOP:  
         LOOP  PRTLOOP           ;Dec CX, loop if CX<>0.
         JMP   SHORT FEED_TOP_LINE
PMODE_THAIPRT4: 
         MOV   CX,WORD PTR [PRT_COLUMN]
         MOV   SI,OFFSET PBUF_TOP
PRTLOOP2:
         LODSB                   ;Load AL with byt at DS:SI ++.
         XOR   BH,BH
         TEST  CS:[PRT_XLAT],1
         JZ    L5FE5H
         MOV   BL,AL
         MOV   AL,BYTE PTR CS:[BX]+PRTXLTBL
L5FE5H:  
         XOR   AH,AH
         PUSHF                   ;Push flag register.
         CALL  DWORD PTR CS:[OLDINT17]
         LOOP  PRTLOOP2          ;Dec CX, loop if CX<>0.

FEED_TOP_LINE:  
         MOV   AL,[LPI_TOP]
         MOV   AH,LF
         CALL  FEED_PAPER

         TEST  [P_MULTI_LINE_FLAG],2  ;ANYTHING IN MIDDLE LINE?
         JZ    FEED_MIDDLE_LINE
         MOV   CX,WORD PTR [PRT_COLUMN]
         MOV   SI,OFFSET PBUF_MDL
PTOPLOOP:
         LODSB                   ;Load AL with byt at DS:SI ++.
         XOR   BH,BH
         TEST  CS:[PRT_XLAT],1
         JZ    PTOP_1
         MOV   BL,AL
         MOV   AL,BYTE PTR CS:[BX]+PRTXLTBL
PTOP_1:  
         XOR   AH,AH
         PUSHF                   ;Push flag register.
         CALL  DWORD PTR CS:[OLDINT17]
         LOOP  PTOPLOOP          ;Dec CX, loop if CX<>0.
FEED_MIDDLE_LINE:  
         MOV   AL,[LPI_MIDDLE]     ;ESC 3 [LPI_MIDDLE]
         MOV   AH,LF
         CALL  FEED_PAPER

         MOV   CX,WORD PTR [PRT_COLUMN]
         JCXZ  FEED_MAIN_LINE            ;Jump if CX=0.
         MOV   SI,OFFSET PBUFMAIN;Point to MAIN print line
PMAINLP: 
         LODSB                   ;Load AL with byt at DS:SI ++.
         XOR   BH,BH
         TEST  CS:[PRT_XLAT],1
         JZ    PMAIN_1
         MOV   BL,AL
         MOV   AL,BYTE PTR CS:[BX]+PRTXLTBL
PMAIN_1: 
         XOR   AH,AH
         PUSHF                   ;Push flag register.
         CALL  DWORD PTR CS:[OLDINT17]
         LOOP  PMAINLP           ;Dec CX, loop if CX<>0.

FEED_MAIN_LINE:  
         MOV   AL,[LPI_MAIN]     ;ESC 3 [LPI_MAIN]
         MOV    AH,LF
         CALL  FEED_PAPER

         TEST  [P_MULTI_LINE_FLAG],1
         JZ    FEED_BOTTOM_LINE
         MOV   CX,WORD PTR [PRT_COLUMN]
         MOV   SI,OFFSET PBUF_BTM
PBTM_LOOP:  
         LODSB                   ;Load AL with byt at DS:SI ++.
         XOR   BH,BH
         TEST  CS:[PRT_XLAT],1
         JZ    PBTM_NO_XLATE
         MOV   BL,AL
         MOV   AL,BYTE PTR CS:[BX]+PRTXLTBL
PBTM_NO_XLATE:  
         XOR   AH,AH
         PUSHF                   ;Push flag register.
         CALL  DWORD PTR CS:[OLDINT17]
         LOOP  PBTM_LOOP            ;Dec CX, loop if CX<>0.
FEED_BOTTOM_LINE:  
         MOV   AL,[LPI_FINAL]
         MOV   AH,[LAST_LINEFEED]      ;LAST LINEFEED
         CALL  FEED_PAPER

         XOR   AX,AX
         MOV   WORD PTR [PRT_COLUMN],AX ;Set print pointer back to zero
         MOV   [P_SPACE_COUNT],AL
         MOV   [P_STACK_COUNT],AL
         MOV   [ESC_SAVE],AL            ;Clear ESC_SAVE
         MOV   [P_MULTI_LINE_FLAG],AL
         _POP  SI,CX,BX
         RET
PRINTIT ENDP

;----------------------------------------------------------------------
INIT_EGA PROC NEAR
;----------------------------------------------------------------------
         MOV   [L04EAH],OFFSET EGA_SET_VIDEO_MODE
         MOV   [SET_EDGE_COLOR],OFFSET EGA_SET_EDGE_COLOR
         MOV   [SET_SHADOW_COLOR],OFFSET EGA_SET_SHADOW_COLOR
         MOV   [CURSOR_CALC],OFFSET EGA_CURSOR_CALC
         MOV   [L04F2H],OFFSET L6314H
         MOV   [NEXT_LINE],OFFSET EGA_NEXT_LINE
         MOV   [PREV_LINE],OFFSET EGA_PREV_LINE
         MOV   [L04FEH],OFFSET L6251H
         MOV   [DRAW_CURSOR],OFFSET DRAW_CURSOR_EGA
         MOV   [L04FAH],OFFSET L6289H
         MOV   [L04FCH],OFFSET L62B3H
         MOV   [VID_SEG], 0B800H
         MOV   WORD PTR [VIDBUF], 0A000H
         MOV   BYTE PTR [L0106H], 2
         MOV   [MSGVECT],OFFSET VID_PARM_TABLE
         RET
INIT_EGA ENDP

;------------------------------------------------------------
P_0035   PROC  NEAR
;------------------------------------------------------------
EGA_SET_VIDEO_MODE:  
         MOV   AH,AL
         AND   AH,7FH
         CMP   AH,2
         JZ    EGA_SET_TEXT_MODE
         CMP   AH,3
         JZ    EGA_SET_TEXT_MODE
         CMP   AH,7
         JZ    EGA_SET_TEXT_MODE
         XOR   AH,AH
         PUSHF                   ;Push flag register.
         CALL  DWORD PTR CS:[OLDINT10]
         XOR   AX,AX
         RET

EGA_SET_TEXT_MODE:  
         CMP   BYTE PTR CS:[DISPMODE],ENGLISH
         JZ    EGA_SET_TEXT_MODE_BIOS
         MOV   AX, 10H      ;Set Video Mode
         PUSHF                   ;Push flag register.
         CALL  DWORD PTR CS:[OLDINT10]
         MOV   DX,GRAPHICS_ADDRESS_REG
         MOV   AX,0106H
         OUT   DX,AX
         MOV   AX, BIOS_SEG
         MOV   DS,AX
         MOV   AL,3
         MOV   BYTE PTR DS:[BIOS_DISPLAY_MODE],AL
         RET

EGA_SET_TEXT_MODE_BIOS:  
         XOR   AH,AH
         PUSHF                   ;Push flag register.
         CALL  DWORD PTR CS:[OLDINT10]
         MOV   AL,3
         RET

EGA_SET_EDGE_COLOR:  
         MOV   CS:[L1514H],AL
         MOV   DX,GRAPHICS_ADDRESS_REG
         MOV   AH,AL
         XOR   AL,AL
         OUT   DX,AX
         MOV   AX,0F01H
         OUT   DX,AX
         MOV   AX,0FF08H
         OUT   DX,AX
         INC   DX
         RET

EGA_SET_SHADOW_COLOR:  
         MOV   DX,GRAPHICS_ADDRESS_REG
         SHL   AL,1
         SHL   AL,1
         SHL   AL,1
         MOV   AH,AL
         MOV   AL,3
         OUT   DX,AX
         MOV   AX,0FF08H
         OUT   DX,AX
         INC   DX
         RET

EGA_CURSOR_CALC:  
         PUSH  CX
         MOV   AX,DX
         SHL   AX,1
         SHL   AX,1
         SHL   AX,1
         SHL   AX,1
         MOV   DI,AX
         SHL   AX,1
         SHL   AX,1
         ADD   DI,AX            ;Row * 20
         MOV   AX,CX
         SHR   AX,1
         SHR   AX,1
         SHR   AX,1
         ADD   DI,AX            ;Row*20 + Col/8
         MOV   AL,80H
         AND   CX,7H
         SHR   AL,CL
         POP   CX
         MOV   WORD PTR CS:[VID_OFFSET],DI
         MOV   CS:[L1513H],AL
         RET

EGA_NEXT_LINE:  
         ADD   DI,80
         RET

EGA_PREV_LINE:  
         SUB   DI,80
         RET

L6251H:  
         OUT   DX,AL
         OR    BYTE PTR ES:[DI],AL
         RET

DRAW_CURSOR_EGA: 
         MOV   ES,WORD PTR CS:[VIDBUF]
         ADD   DI,3C0H
         MOV   DX,GRAPHICS_ADDRESS_REG
         MOV   AX,1803H
         OUT   DX,AX
         MOV   AL,0FFH
         TEST  CS:[CURRENT_MODE],4    ;Bit 2 on?
         JNZ   EGA_THAI_CURSOR
         OR    BYTE PTR ES:[DI],AL
         OR    BYTE PTR ES:[DI]+80,AL
         JMP   SHORT EGA_CURSOR_EXIT
EGA_THAI_CURSOR:  
         MOV   CX, 10
EGA_CURSOR_LOOP:  
         OR    BYTE PTR ES:[DI],AL
         SUB   DI,80             ;BACK UP ONE LINE
         LOOP  EGA_CURSOR_LOOP            ;Dec CX, loop if CX<>0.
EGA_CURSOR_EXIT:  
         MOV   AX, 3H
         OUT   DX,AX
         RET

L6289H:  
         _PUSH CX,DX,DI
         SHR   AX,1
         SHR   AX,1
         SHR   AX,1
         SHR   AX,1
         MOV   DX,GRAPHICS_ADDRESS_REG
         XOR   AL,AL
         OUT   DX,AX
         MOV   AX,0F01H
         OUT   DX,AX
         XOR   AL,AL
         MOV   CX, 14
L62A3H:  
         MOV   BYTE PTR ES:[DI],AL
         ADD   DI,50H
         LOOP  L62A3H            ;Dec CX, loop if CX<>0.
         MOV   AX,1
         OUT   DX,AX
         _POP  DI,DX,CX
         RET

L62B3H:  
         _PUSH CX,DX
         MOV   BX,AX
         XOR   AH,AH
         SHL   AX,1
         SHL   AX,1
         SHL   AX,1
         SHL   AX,1
         ADD   SI,AX
         MOV   AX,BX
         AND   AH,0FH
         MOV   DX,GRAPHICS_ADDRESS_REG
         XOR   AL,AL
         OUT   DX,AX
         MOV   AX,0F01H
         OUT   DX,AX
         MOV   CX,14
         MOV   AL,8
         OUT   DX,AL
         INC   DX
L62D9H:  
         SegCS
         LODSB                   ;Load AL with byt at DS:SI ++.
         OUT   DX,AL
         OR    BYTE PTR ES:[DI],AL
         ADD   DI,50H
         LOOP  L62D9H            ;Dec CX, loop if CX<>0.
         DEC   SI
         DEC   DX
         SHR   BX,1
         SHR   BX,1
         SHR   BX,1
         SHR   BX,1
         XOR   AL,AL
         MOV   AH,BH
         OUT   DX,AX
         MOV   CL,0EH
         MOV   AL,8
         OUT   DX,AL
         INC   DX
         STD                     ;Set backward direction flag.
L62FAH:  
         SUB   DI,50H
         SegCS
         LODSB                   ;Load AL with byt at DS:SI --.
         NOT   AL
         OUT   DX,AL
         OR    BYTE PTR ES:[DI],AL
         LOOP  L62FAH            ;Dec CX, loop if CX<>0.
         CLD                     ;Set forward direction flag.
         DEC   DX
         MOV   AX,1
         OUT   DX,AX
         MOV   AX,0FF08H
         OUT   DX,AX
         _POP  DX,CX
         RET

L6314H:  
         MOV   DX,GRAPHICS_ADDRESS_REG
         MOV   AX,0105H
         OUT   DX,AX
         MOV   AX,WORD PTR CS:[VIDBUF]
         MOV   DS,AX
         MOV   ES,AX
         MOV   CX, 6900H
         MOV   DI,WORD PTR CS:[L0506H]
         MOV   SI,WORD PTR CS:[L0508H]
         REPZ MOVSB              ;Move byt, DS:SI to ES:DI ++.
         MOV   AX,5
         OUT   DX,AX
         RET

VID_PARM_TABLE LABEL BYTE
VID_PARM_40X25 LABEL BYTE
         DB   61H,50H,52H,0FH,19H,6,19H ;Init string for 40 x 25
         DB   19H,2,0DH,0BH,0CH
         DB   0,0,0,0

VID_PARM_80X25_COLOR LABEL BYTE
         DB   35H,2DH,2EH,7,5CH,2,58H   ;Init string for 80 x 25 color
         DB   58H,2,0,0,0
         DB   0,0,0,0

VID_PARM_GRAPHICS LABEL BYTE
         DB   37H,28H,2DH,7,7FH,6,64H   ;Init string for Graphics
         DB   70H,2,1,0,0
         DB   0,0,0,0

VID_PARM_80X25_MONO LABEL BYTE
         DB   35H,2DH,2EH,7,5CH,2,58H   ;Init string for 80x25 mono
         DB   58H,2,3,0,0
         DB   0,0,0,0
P_0035   ENDP

;------------------------------------------------------------
INIT_MONO PROC  NEAR
         PUSH  CS
         POP   DS
         MOV   DX,PORT_3BFH
         MOV   AL,3
         OUT   DX,AL
         RET
INIT_MONO ENDP

;----------------------------------------------------------------------
L6382H PROC NEAR
         MOV   DX,AX
         MOV   SI,OFFSET VID_PARM_GRAPHICS
         CMP   AL,3
         JBE   L638FH
         CMP   AL,7
         JC    L63B9H
L638FH:  
         CMP   BYTE PTR CS:[DISPMODE],ENGLISH
         JNZ   L63B4H
         XOR   AX,AX
         MOV   DS,AX
         MOV   AX,CS:[OLDINT1D]
         MOV   WORD PTR DS:[74H],AX
         MOV   AX,CS:[OLDSEG1D]
         MOV   WORD PTR DS:[76H],AX
         MOV   AX,DX
         PUSHF                   ;Push flag register.
         CALL  DWORD PTR CS:[OLDINT10]
         MOV   AL,3
         RET
L6382H ENDP

;----------------------------------------------------------------------
L63B4H PROC NEAR
         MOV   DL,7
         MOV   SI,OFFSET VID_PARM_80X25_MONO
L63B9H:  
         XOR   AX,AX
         MOV   DS,AX
         MOV   WORD PTR DS:[INT_TBL_OFF_VID_PARMS],OFFSET VID_PARM_TABLE
         MOV   WORD PTR DS:[INT_TBL_SEG_VID_PARMS],CS
         MOV   AX, BIOS_SEG
         MOV   DS,AX
         MOV   BYTE PTR DS:[BIOS_DISPLAY_MODE],DL
         MOV   BYTE PTR DS:[BIOS_MODE_CONTROL_REG], 29H
         OR    BYTE PTR DS:[BIOS_EQUIPMENT_LIST],30H
         MOV   AL,0A2H
         MOV   DX,MODE_CONTROL_REG_MONO
         OUT   DX,AL
         MOV   CX, 0CH
         MOV   DX,CRTC_PORT
         XOR   AH,AH
L63E9H:  
         SegCS
         LODSB                   ;Load AL with byt at DS:SI ++.
         XCHG  AL,AH
         OUT   DX,AX
         XCHG  AL,AH
         INC   AH
         LOOP  L63E9H            ;Dec CX, loop if CX<>0.
         MOV   ES,WORD PTR CS:[VIDBUF]
         XOR   AX,AX
         MOV   DI,AX
         MOV   CX,4000H          ;16K
         REPZ STOSW              ;Store wrd in AX in ES:DI ++.
         MOV   DX,MODE_CONTROL_REG_MONO
         MOV   AL,0AAH
         OUT   DX,AL
         XOR   DX,DX
         MOV   AH,2
         PUSHF                   ;Push flag register.
         CALL  DWORD PTR CS:[OLDINT10]
         MOV   AX,DX
         CMP   BYTE PTR DS:[49H],7
         JNZ   L641DH
         MOV   AL,3
L641DH:  
         RET
L63B4H ENDP

MONO_SET_EDGE_COLOR PROC NEAR
         MOV   CS:[L1514H],AL
         MOV   WORD PTR CS:[PATTERN_POINTER],OFFSET PATTERN_FF
         CMP   AL,0
         JNZ   L6446H
         MOV   WORD PTR CS:[PATTERN_POINTER],OFFSET PATTERN_00
         CMP   CS:[L04FEH],OFFSET L64FAH
         JNZ   L6461H
         MOV   CS:[L04FEH],OFFSET L6502H
         JMP   SHORT L6461H
L6446H:  
         CMP   CS:[L04FEH],OFFSET L6502H
         JNZ   L6456H
         MOV   CS:[L04FEH],OFFSET L64FAH
L6456H:  
         CMP   AL,0FH
         JZ    L6461H
         MOV   WORD PTR CS:[PATTERN_POINTER],OFFSET PATTERN_AA55
L6461H:  
         RET
MONO_SET_EDGE_COLOR ENDP

;----------------------------------------------------------------------
MONO_SET_SHADOW_COLOR PROC NEAR
         CMP   AL,0
         JZ    L646AH
         CMP   AL,2
         JNZ   L648FH
L646AH:  
         MOV   CS:[L04FEH],OFFSET L64FAH
         CMP   CS:[L1514H],0
         JNZ   L649AH
         MOV   CS:[L04FEH],OFFSET L6502H
         JMP   SHORT L649AH
         CMP   AL,1
         JNZ   L648FH
         MOV   CS:[L04FEH],OFFSET L64FDH
         JMP   SHORT L649AH
L648FH:  
         CMP   AL,3
         JNZ   L649AH
         MOV   CS:[L04FEH],OFFSET L64FEH
L649AH:  
         RET
MONO_SET_SHADOW_COLOR ENDP

;-----------------------------------------------------------------------
; Calculate cursor position for pop up window
; Inputs:
;       CX = Column
;       DX = Row
;-----------------------------------------------------------------------
MONO_CALC_CURSOR PROC NEAR
         _PUSH BX,CX,DX
         ADD   CX,40            ;Add 40 to column
         MOV   DI,DX            ;Copy ROW value to DI
         AND   DI,3H            ;Isolate 2 LSBs
         ROR   DI,1             ;
         ROR   DI,1             ;Rotate 2 LSBs to High End
         ROR   DI,1             ;
         SHR   DX,1             ;Divide original by 4
         SHR   DX,1             ;
         SHL   DX,1             ;ROW/4*2
         MOV   BX,DX            ;Copy to BX
         SHL   DX,1             ;
         SHL   DX,1             ;((int)ROW/4)*8
         ADD   DX,BX            ;ROW * 10
         MOV   BX,DX            ;Copy to BX
         SHL   DX,1             ;
         SHL   DX,1             ;
         SHL   DX,1             ;(ROW*10)/8
         ADD   DX,BX            ;
         ADD   DI,DX            ;
         MOV   AX,CX            ;Column value to AX
         SHR   AX,1             ;/2
         SHR   AX,1             ;/4
         SHR   AX,1             ;/8
         ADD   DI,AX            ;Add column value to DI to get offset into buffer
         MOV   AL,80H           ;Set High bit
         AND   CX,7H            ;Isolate 3 LSBs
         SHR   AL,CL            ;Move Set bit right by what's left of column value
         _POP  DX,CX,BX
         MOV   WORD PTR CS:[VID_OFFSET],DI
         MOV   CS:[L1513H],AL
         RET
MONO_CALC_CURSOR ENDP
;----------------------------------------------------------------------
MONO_NEXT_LINE PROC NEAR
        ADD   DI, 2000H
        JNS   L64EEH
        ADD   DI, 805AH
L64EEH: 
        RET
MONO_NEXT_LINE ENDP

;----------------------------------------------------------------------
MONO_PREV_LINE PROC NEAR
        SUB   DI, 2000H
        JNS   L64F9H
        SUB   DI, 805AH
L64F9H: 
        RET
MONO_PREV_LINE ENDP

;----------------------------------------------------------------------

L64FAH PROC NEAR
         OR    BYTE PTR ES:[DI],AL
L64FDH: 
         RET
L64FAH ENDP

;----------------------------------------------------------------------
L64FEH PROC NEAR
         XOR   BYTE PTR ES:[DI],AL
         RET
L64FEH ENDP

;----------------------------------------------------------------------
L6502H PROC NEAR
         MOV   AH,AL
         NOT   AH
         AND   BYTE PTR ES:[DI],AH
         RET
L6502H ENDP

;----------------------------------------------------------------------
DRAW_CURSOR_MONO PROC NEAR
         MOV   ES,WORD PTR CS:[VIDBUF]
         ADD   DI, 270
         MOV   AL,0FFH                  ;All bits on
         TEST  CS:[CURRENT_MODE],4            ;Bit 2 on?
         JNZ   REV_FIELD
         XOR   BYTE PTR ES:[DI],AL      ;Invert all bits
         ADD   DI, 2000H                ;+8K
         JNS   DIDNT_WRAP                   ;If that didn't go negative...
         ADD   DI, 805AH                ;Else add 32K
DIDNT_WRAP:  
         XOR   BYTE PTR ES:[DI],AL      ;Invert all bits
         RET

REV_FIELD:  
         MOV   CX, 10
REV_LOOP:  
         XOR   BYTE PTR ES:[DI],AL
         SUB   DI, 2000H
         JNS   FLD_NOWRAP
         SUB   DI, 805AH
FLD_NOWRAP:
         LOOP  REV_LOOP            ;Dec CX, loop if CX<>0.
         RET
DRAW_CURSOR_MONO ENDP

;----------------------------------------------------------------------
L6541H PROC NEAR
         _PUSH CX,DI
         XOR   CX,CX
         AND   AH,77H
         CMP   AH,70H
         JNZ   L6550H
         DEC   CX
         JMP   SHORT L6557H
L6550H:  
         CMP   AH,1
         JNZ   L6557H
         DEC   CH
L6557H:  
         MOV   AX,CX
         MOV   CX, 13
L655CH:  
         MOV   BYTE PTR ES:[DI],AL
         ADD   DI, 2000H
         JNS   L6569H
         ADD   DI, 805AH         ;-32678 or +32858
L6569H:  
         LOOP  L655CH            ;Dec CX, loop if CX<>0.
         MOV   BYTE PTR ES:[DI],AH
         _POP  DI,CX
         RET
L6541H ENDP

;----------------------------------------------------------------------
L6571H PROC NEAR
         _PUSH CX,DI
         MOV   CL,AL
         XOR   CH,CH
         SHL   CX,1
         SHL   CX,1
         SHL   CX,1
         SHL   CX,1
         ADD   SI,CX
         XOR   CX,CX
         MOV   AL,AH
         AND   AL,77H
         JZ    L6557H
         CMP   AL,70H
         JZ    L65E3H
         CMP   AL,1
         JNZ   L6592H
         DEC   CX
L6592H:  
         TEST  AH,8
         JNZ   L65B7H
         MOV   BX,CX
         MOV   CX, 13
L659CH:  
         SegCS
         LODSB                   ;Load AL with byt at DS:SI ++.
         MOV   BYTE PTR ES:[DI],AL
         ADD   DI, 2000H
         JNS   L65ABH
         ADD   DI, 805AH
L65ABH:  
         LOOP  L659CH            ;Dec CX, loop if CX<>0.
         SegCS
         LODSB                   ;Load AL with byt at DS:SI ++.
         OR    AL,BL
         MOV   BYTE PTR ES:[DI],AL
         _POP  DI,CX
         RET
L6571H ENDP

;----------------------------------------------------------------------
L65B7H PROC NEAR
         MOV   BX,CX
         MOV   CX, 13
L65BCH:  
         SegCS
         LODSB                   ;Load AL with byt at DS:SI ++.
         MOV   AH,AL
         SHR   AL,1
         OR    AL,AH
         MOV   BYTE PTR ES:[DI],AL
         ADD   DI, 2000H
         JNS   L65D1H
         ADD   DI, 805AH
L65D1H:  
         LOOP  L65BCH            ;Dec CX, loop if CX<>0.
         SegCS
         LODSB                   ;Load AL with byt at DS:SI ++.
         MOV   AH,AL
         SHR   AL,1
         OR    AL,AH
         OR    AL,BL
         MOV   BYTE PTR ES:[DI],AL
         _POP  DI,CX
         RET
L65B7H ENDP
;----------------------------------------------------------------------
L65E3H PROC NEAR
         MOV   CX, 14
L65E6H:  
         SegCS
         LODSB                   ;Load AL with byt at DS:SI ++.
         NOT   AL
         MOV   BYTE PTR ES:[DI],AL
         ADD   DI, 2000H
         JNS   L65F7H
         ADD   DI, 805AH
L65F7H:  
         LOOP  L65E6H            ;Dec CX, loop if CX<>0.
         _POP  DI,CX
         RET
L65E3H ENDP
;----------------------------------------------------------------------
L65FCH PROC NEAR
         MOV   AX,WORD PTR CS:[VIDBUF]
         MOV   DS,AX
         MOV   ES,AX
         MOV   SI,WORD PTR CS:[L0508H]
         MOV   DI,WORD PTR CS:[L0506H]
         MOV   AX, 28H
         MOV   DX,0150H
L6614H:  
         MOV   CX,AX
         REPZ MOVSW              ;Move wrd, DS:SI to ES:DI ++.
         ADD   SI, 1FB0H
         JNS   L6622H
         ADD   SI, 805AH
L6622H:  
         ADD   DI, 1FB0H
         JNS   L662CH
         ADD   DI, 805AH
L662CH:  
         DEC   DX
         JNZ   L6614H
         RET
L65FCH ENDP

;======================================================================

UPDATE_VIDEO  PROC NEAR
         _PUSH AX,BX,CX,DX,SI,DI,BP,DS,ES

         CMP   BYTE PTR CS:[DISPMODE],THAI_8
         JNZ  UPDATE_25

         CALL UPDATE_SCREEN_THAI_8
         JMP SHORT UPD_VID_EXIT

UPDATE_25:
         CALL UPDATE_SCREEN_THAI_25

UPD_VID_EXIT:
        _POP  ES,DS,BP,DI,SI,DX,CX,BX,AX
        RET
UPDATE_VIDEO  ENDP

;======================================================================
;       TIMER (Int 8) Interrupt Service Routine
;======================================================================
TIMER_BUSY  DB 0
NEW_TIMER PROC NEAR

        STI     ; REENABLE INTERRUPTS
        PUSHF
         CALL  DWORD PTR CS:[OLDINT8]

;         PUSH  DS
;         MOV   DS,CS:[VID_SEG]
;         CMP   BYTE PTR DS:[7FFFH],3
;         POP   DS
         CMP CS:VMODEFLAG, 3  ;//TEST//
         JNZ   TIMER_EXIT
         CMP   BYTE PTR CS:[DISPMODE],ENGLISH
         JZ    TIMER_EXIT
         CMP  BYTE PTR CS:[TIMER_BUSY],1
         JZ   TIMER_EXIT
         MOV  BYTE PTR CS:[TIMER_BUSY],1
         CALL  UPDATE_VIDEO
         MOV  BYTE PTR CS:[TIMER_BUSY],0

TIMER_EXIT: 
         IRET
NEW_TIMER ENDP

;======================================================================
; Do initialization and go Resident
;======================================================================
INIT PROC NEAR

         CLD                     ;Set forward direction flag.
         MOV   SI,5DH   ;Point to argv[1][0]
         LODSB
         CMP AL,'U'               ;UNLOAD COMMAND?
         JZ  COMMAND_LINE_UNLOAD  
         MOV   AX, 80FFH         ;Are we already installed?
         XOR   BX,BX
         INT   10H               ;Display control interrupt.
         CMP   AL,0FFH           ;Original Video Int will not change AL
         JZ    NOT_INSTALLED     ;...Ours will clear AL
         JMP   ALREADY_TSR

NOT_INSTALLED:  
         MOV   AX,WORD PTR DS:[2CH]
         MOV   CS:[FNAMESEG],AX           ;FILENAME (GTHAI.COM) SEGMENT
         MOV   ES,AX
         XOR   DI,DI
         MOV   CX, 1000
         MOV   AL,1
         REPNZ SCASB             ;Scan ES:DI ++ for byt in AL.
         INC   DI
         MOV   [FNAMEOFF],DI      ;FILENAME OFFSET
         MOV   AX, BIOS_SEG
         MOV   ES,AX
         MOV   AX,WORD PTR ES:[63H]
         MOV   [CRTBASE],AX
         MOV   AL,BYTE PTR ES:[10H]
         AND   AL,30H
         CMP   AL,30H
         JNZ   NOT_MONO
         CALL  INIT_MONO           ;Display string at (DS:DX).
         JMP   SHORT CONTINUE_INIT
NOT_MONO:  
         CALL  INIT_EGA

CONTINUE_INIT:  
         MOV   SI,OFFSET L0506H
         MOV   BX, 26
         XOR   CX,CX
         MOV   DX,CX
INIT_CRT_LINE_OFFSETS:  
         CALL  [CURSOR_CALC]            ;CALC OFFSET OF EACH LINE
         MOV   WORD PTR [SI],DI         ;SAVE OFFSET
         INC   SI                       ;BUMP POINTER
         INC   SI                       ;
         ADD   DX,14                    ;14 SCAN LINES PER TEXT LINE
         DEC   BX
         JNZ   INIT_CRT_LINE_OFFSETS    ;LOOP THROUGH ALL LINES ON SCREEN

         MOV   AX,CS
         MOV   ES,AX
         MOV   SI,OFFSET MSG31
         MOV   DI,OFFSET FLD1_MSG1
         MOV   CX, 7
         REPZ MOVSW              ;Move wrd, DS:SI to ES:DI ++.
         MOV   SI,OFFSET MSG32
         MOV   DI,OFFSET FLD3_MSG2
         MOV   CX, 7
         REPZ MOVSW              ;Move wrd, DS:SI to ES:DI ++.
         MOV   SI,OFFSET MSG33
         MOV   DI,OFFSET FLD7_MSG1
         MOV   CX, 7
         REPZ MOVSW              ;Move wrd, DS:SI to ES:DI ++.
         MOV   SI,OFFSET MSG34
         MOV   DI,OFFSET FLD7_MSG3
         MOV   CX, 7
         REPZ MOVSW              ;Move wrd, DS:SI to ES:DI ++.
         MOV   SI,OFFSET MSG33
         MOV   DI,OFFSET FLD7_MSG3
         MOV   CX, 3
         REPZ MOVSW              ;Move wrd, DS:SI to ES:DI ++.

;----------------------------------------------------------------------
; Calculate starting position for BBS message
;----------------------------------------------------------------------
         MOV   SI,OFFSET MSG_BBS
         XOR   CX,CX
BBSCOUNT_LOOP:  
         LODSB                          ;Get a character
         XOR   AL,END_OF_STRING         ;Decode character
         JZ    CALC_BBSMSG_POSITION     ;If END_OF_MESSAGE, we're done
         CMP   AL,MAI_HAN_AKAT          ;Thai vowel, don't count it
         JZ    BBSCOUNT_LOOP
         CMP   AL,SARA_I                ;Check range SARA_I to PHINTHU
         JC    INCR_BBSMSG_COUNT        ;If below range, count it
         CMP   AL,PHINTHU
         JBE   BBSCOUNT_LOOP            ;If in range, don't count it
         CMP   AL,MAI_TAI_KHU           ;Check range MAI_TAI_KHU to NIKKHAHIT
         JC    INCR_BBSMSG_COUNT        ;If below range, count it
         CMP   AL,NIKKHAHIT
         JBE   BBSCOUNT_LOOP            ;If in range, don't count it, 
                                        ;else, drop through and bump count
INCR_BBSMSG_COUNT:  
         INC   CX               ;INCREMENT LENGTH
         JMP   SHORT BBSCOUNT_LOOP
CALC_BBSMSG_POSITION:
         MOV   AX,PANEL_WIDTH/2 ;WIDTH OF CONTROL PANEL
         SHL   CX,1             ;MULTIPLY * 2
         SHL   CX,1             ;MULTIPLY * 4
         SUB   AX,CX            ;SUBTRACT MESSAGE LENGTH FROM WIDTH
         MOV   WORD PTR [BBSMSG_COLUMN],AX      ;STORE START COLUMN

;======================================================================
;
;======================================================================
         mov ah,35h     ;get vector
         mov al,8       ;timer
         int 21h
         mov  cs:[oldint8],bx
         mov  cs:[oldseg8],es

         mov ah,35h     ;get vector
         mov al,9       ;keyboard
         int 21h
         mov  cs:[oldint9],bx
         mov  cs:[oldseg9],es

         mov ah,35h     ;get vector
         mov al,10h     ;video
         int 21h
         mov  cs:[oldint10],bx
         mov  cs:[oldseg10],es

         mov ah,35h     ;get vector
         mov al,17h     ;printer
         int 21h
         mov  cs:[oldint17],bx
         mov  cs:[oldseg17],es

         mov ah,35h     ;get vector
         mov al,1dh
         int 21h
         mov  cs:[oldint1d],bx
         mov  cs:[oldseg1d],es

         mov ah,35h     ;get vector
         mov al,24h
         int 21h
         mov  cs:[oldint24],bx
         mov  cs:[oldseg24],es

;======================================================================
; Plug our interrupt handlers 
;======================================================================
         push cs
         pop  ds

         mov  ah,25h
         mov  al,9
         mov  dx,offset KBDINT9
         int  21h

         mov  ah,25h
         mov  al,10h
         mov  dx,offset VIDINT10
         int  21h

         mov  ah,25h
         mov  al,17h
         mov  dx,offset PRTINT17
         int  21h

         MOV   AX,(VID_SETMODE SHL 8 + TEXT_80X25)
         INT   10H                              ;Set the display mode to (03).

         mov  ah,25h
         mov  al,8
         mov  dx,offset NEW_TIMER
         int  21h

         LEA   DX,TITLE_MSG
         MOV   AH,DOS_PRINT_STRING
         INT   21H

         LEA   DX,INSTALL_MSG                   ;Show install message
         MOV   AH,DOS_PRINT_STRING
         INT   21H

         LEA   DX,INIT                      ;Discard all after INIT
         INT   27H                                 ;Terminate and stay resident.

COMMAND_LINE_UNLOAD:
         MOV   AX, 80FFH         ;Are we already installed?
         XOR   BX,BX
         INT   10H               ;Display control interrupt.
         CMP   AL,0FFH           ;Original Video Int will not change AL
         JNZ  REMOVE_IT
         LEA  DX,IT_AINT_HERE_MSG
         JMP  SHORT SHOW_AND_QUIT
REMOVE_IT:
         MOV  AH,93H
         INT  10H
         OR   AL,AL
         JZ   TSR_UNLOADED
         LEA  DX,CANT_REMOVE_MSG
         JMP  SHORT SHOW_AND_QUIT
TSR_UNLOADED:
         MOV  AX,2
         INT 10H
         MOV  AX,3
         INT 10H
         LEA  DX,TSR_REMOVED_MSG
         JMP  SHORT SHOW_AND_QUIT

ALREADY_TSR:  
         LEA   DX,TITLE_MSG
         MOV   AH,DOS_PRINT_STRING
         INT   21H

         LEA   DX,ALREADY_TSR_MSG
SHOW_AND_QUIT:
         MOV   AH,DOS_PRINT_STRING
         INT   21H                      ;Display message
         MOV   AH,DOS_TERMINATE
         INT   21H                      ;Normal DOS exit

VREFRESHFLAG DB 0ffh

;======================================================================
;======================================================================
MSG31   DB    _SARA_E,_KO_KAI,_SO_RUSI,_TO_TAO,_RO_RUA,_PAI_YAN_NOI,END_OF_STRING
        DB    _SPACE,_PHO_PHUNG,_SARA_UU,_MAI_THO,_SARA_MAI_MUAN,_CHO_CHANG,_MAI_THO

MSG32   DB    _SARA_MAI_MALAI,_THO_THAHAN,_YO_YAK,_PO_PLA,_MAI_HAN_AKAT
        DB    _TO_TAO,_TO_TAO,_SARA_O,_CHO_CHANG,_TO_TAO,_SARA_I,END_OF_STRING
        DB    _CHO_CHANG,_MAI_THO

MSG33   DB    _SARA_E,_KO_KAI,_SO_RUSI,_TO_TAO,_RO_RUA,_PAI_YAN_NOI,END_OF_STRING
        DB    _SPACE,_PHO_PHUNG,_SARA_UU,_MAI_THO,_SARA_MAI_MUAN,_CHO_CHANG,_MAI_THO

MSG34   DB    _SARA_E,_KO_KAI,_SO_RUSI,_TO_TAO,_RO_RUA,_PAI_YAN_NOI
         DB    _SPACE,_TO_TAO,_MAI_EK,_O_ANG,_HO_HIP,_MAI_HAN_AKAT
         DB    _WO_WAEN,END_OF_STRING

;======================================================================
TITLE_MSG       DB 'GThai 25 line driver Version '
                VERSION_STRING
                DB CR,LF,'$'

INSTALL_MSG     DB 'Customized by Gary Butler',CR,LF
                DB 'Press      ` to toggle Thai/English mode',CR,LF
                DB 'Press Ctrl+` for control panel',CR,LF
                DB 'Press  Alt+` to unload TSR',CR,LF
                DB CR,LF,'To unload from command line, type GTHAI U',CR,LF
                DB '$'  ;DOS End of string

;======================================================================
; Tell them that we're already loaded.
;======================================================================
ALREADY_TSR_MSG   DB 'Already active. Press Ctrl+` for MENU',CR,LF,BELL,' $'
CANT_REMOVE_MSG   DB CR,LF,'Cannot uninstall GThai. Interrupts hooked.',CR,LF,BELL,'$'
TSR_REMOVED_MSG   DB CR,LF,'GThai removed from memory.',CR,LF,'$'
IT_AINT_HERE_MSG  DB CR,LF,'GThai is not installed.',CR,LF,'$'
INIT    ENDP
Code_Seg ENDS
         END   GTHAI   

