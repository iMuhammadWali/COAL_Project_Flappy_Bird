[org 0x100]           ; DOS .COM program
jmp start

count: db 0
width: db 30
prevCol: db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

%include'pixel_data.asm'
%include'kiki.asm'

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

moveGround:
;Have to save the first column
;Then move eveyrthing to left
;Then Write that col back 

;For now, I will save the first col and print it at any ranodm place on the screen
            push bp
            mov bp, sp
            pushA

            mov ax, 0xA000
            mov es, ax

    mov di, 173*320
    mov si, prevCol
    mov cx, 10
    saveCol:
        mov al, [es:di];
        mov [si], al
        inc si
        add di, 319
        loop saveCol


        Now I have to move everything to the left
            popA
            mov sp, bp
            pop bp
            ret

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

; This has yet to be converted into a subroutine
mov si, barrier
mov di, 24140 - 50*320       ; Calculate this with the x and y coordinates
; I am starting at the 73 row
; The prev image has image had 100 rows
; So the ground starts at 174th row and extends till 200 which means that it has 27 rows 
; This is the starting point, I have to calculate the ending col row out of 200

mov bx, 26                  ; width of the image 
mov dx, 148                 ; height of the image

; This is basically a nested loop
printBackground1:
    mov cx, bx          ; Copy 160 pixels (1 line)
    ; rep movsb         ; Move CX bytes from DS:SI to ES:DI
    ; Print Columns
    ; mov ax, si
    printLine1:  
                mov al, [ds:si]
                cmp al, 0x0F
                je end
                cmp al, 0x10
                je end
                add al, 55
                
                mov byte [es:di], al
                end:
                inc di
                inc si
                loop printLine1
    add di, 294
    dec dx                  ; Decrement line counter
    jnz printBackground1    ; Repeat for all lines

call moveGround

mov si, prevCol

mov di, 0

mov cx, 1000

testHA:
    mov [es:di], si
    inc di
loop testHA

mov ax, 0x4c00
int 0x21