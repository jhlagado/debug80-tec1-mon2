; TEC-1 8x8 LED Matrix Test (MON-2)
; Target: TEC-1 MON-2 (user RAM at 0x0900)
; Ports: 0x06 = data latch, 0x05 = row select
;
; Run by setting the address to 0x0900 and pressing GO.

        .org 0x0900

PORT_ROW        EQU   0x05
PORT_DATA       EQU   0x06

; START
; Purpose : Entry point for the 8x8 LED matrix scan loop.
; Inputs  : None.
; Clobbers: AF, BC, DE, HL.
; Flags   : Undefined.
; Returns : Never.
START:  LD   HL,PATTERN
        LD   DE,ROWMASKS

FRAME:  LD   B,8
ROWLP:  LD   A,(HL)
        OUT  (PORT_DATA),A
        LD   A,(DE)
        OUT  (PORT_ROW),A
        CALL DELAY
        INC  HL
        INC  DE
        DJNZ ROWLP
        LD   HL,PATTERN
        LD   DE,ROWMASKS
        JR   FRAME

; DELAY
; Purpose : Short row-hold delay to stabilize LED persistence.
; Inputs  : None.
; Preserves: BC, DE, HL, A.
; Flags   : Modified (Z/N/etc) by loop counters.
DELAY:  PUSH  BC
        LD   B,0x10
D1:     LD   C,0xFF
D2:     DEC  C
        JR   NZ,D2
        DJNZ D1
        POP   BC
        RET

; Simple X pattern.
PATTERN:
        DB   0x81,0x42,0x24,0x18,0x18,0x24,0x42,0x81

ROWMASKS:
        DB   0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80
