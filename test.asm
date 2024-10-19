org 100h                  ; DOS .COM program
jmp start
%include 'flappy.asm'
%include 'barrier.asm'
start:
mov ax, 13h
int 10h
mov ax, 0xA000
mov es, ax

mov dx, 03c8h; DAC write index register
mov al, 0 ; Start at color index 0
out dx, al
mov dx, 03C9h; DAC data register
mov cx, 768 ; 256 colors 3 (RGB)
mov si, palette_data

palette_loop:
	lodsb
	out dx, al
	loop palette_loop

mov bx, 0 
mov cx, 32000 ;Number of pixels (320x200)
mov si, background ;Index for pixel data
xor di, di ;Start at the beginning of video memory
jmp printBackground
resetCounter:
	mov bx, 0
	add di, 160
	
printBackground:
;rep movsb
mov al, [ds: si]
mov [es:di], al
inc si
inc di
inc bx

cmp bx, 160
je resetCounter
loop printBackground

mov bx, 0 ; coun
mov cx, 32000 ;Number of pixels (320x200)
mov si, background ;Index for pixel data
xor di, di ;Start at the beginning of video memory
mov di, 160
jmp printBackground1
resetCounter1:
	mov bx, 0
	add di, 160
	
printBackground1:
;rep movsb
mov al, [ds: si]
mov [es:di], al
inc si
inc di
inc bx

cmp bx, 160
je resetCounter1
loop printBackground1

mov bx, 0 
mov cx, 3600 ;Number of pixels (320x200)
mov si, barrier ;Index for pixel data
xor di, di ;Start at the beginning of video memory
mov di, 140
jmp printBackground2
resetCounter2:
	mov bx, 0
	add di, 290
	
printBackground2:
;rep movsb
mov al, [ds: si]
mov [es:di], al
inc si
inc di
inc bx

cmp bx, 30
je resetCounter2
loop printBackground2

ter:
mov ax, 0x4c00
int 0x21