[org 0x100]           ; DOS .COM program
jmp start

%include'pixel_data.asm'
%include'barrier.asm'

; This is basically a nested loop
drawRect:   push bp
            mov bp, sp
            pushA

            mov ax, 0xA000
            mov es, ax

mov si, pixel_data
mov di, [bp + 4]        ; Calculate this with the x and y coordinates
mov bx, 160             ; width of the image 
mov dx, 200             ; height of the image

.printBackground:
    
    mov cx, bx          ; Copy 160 pixels (1 line)
    ; rep movsb         ; Move CX bytes from DS:SI to ES:DI
    ; Print Columns
    .printLine:  
                mov al, [ds:si]
                mov byte [es:di], al
                inc di
                inc si
                loop .printLine
    add di, 160
    dec dx              ; Decrement line counter
    jnz .printBackground ; Repeat for all lines

    popA
    mov sp, bp
    pop bp
    ret 4

start:
mov ax, 13h
int 10h
mov ax, 0xA000
mov es, ax

mov dx, 03c8h; DAC write index register
mov al, 0 ; Start at color index 0
out dx, al
mov dx, 03c9h; DAC data register
mov cx, 768 ; 256 colors 3 (RGB)
mov si, palette_data

palette_loop:
	lodsb
	out dx, al
	loop palette_loop

; This subroutine will have 6 parameters
; It will an offset of palette index as well

; This will draw the background
push 0
call drawRect

push 159
call drawRect

mov si, barrier
mov di, 24140 - 2*320             ; Calculate this with the x and y coordinates
mov bx, 30             ; width of the image 
mov dx, 100             ; height of the image

; This is basically a nested loop
printBackground1:
    mov cx, bx          ; Copy 160 pixels (1 line)
    ; rep movsb         ; Move CX bytes from DS:SI to ES:DI
    ; Print Columns
    printLine1:  
                mov al, [ds:si]
                add al, 55
                mov byte [es:di], al
                inc di
                inc si
                loop printLine1
    add di, 290
    dec dx              ; Decrement line counter
    jnz printBackground1 ; Repeat for all lines

mov ax, 0x4c00
int 0x21