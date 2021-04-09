data segment                      
    a8 db 0
    b8 db 0
    a16 dw 0
    c16 dw 0
    c db 0
    d db 0
    e db 0
    f db 0
    in1 db "Enter First Number: $"
    in2 db "Enter Second Number: $"
    str0 db ".$"
    str db "Enter the Serial Number Corresponding to desired Operation$"
    str1 db "1. Addition$"
    str2 db "2. Subtraction$"
    str3 db "3. Multiplication$"
    str4 db "4. Division$"
    str5 db "5. Modulus(remainder)$"
    str6 db "6. Power$"
    str7 db "7. Factorial$"
    str8 db "8. Division with Fraction Answer$"
    str9 db "9. Permutation(nPr)$"
    str10 db "10. Combination(nCr)$"
data ends

code segment
assume cd:code, ds:data
start:

    
fractional_div macro a,b
    pusha
    mov al, a
    div b
    mov bh,al
    mov al,ah
    mov dl,0ah
    mul dl
    div b
    mul dl
    mov bl,al
    mov al,ah
    mul dl 
    mul dl
    xor dx,dx
    div b
    add bl,ah
    mov c,bh
    mov d,bl
    popa
fractional_div endm
    
    mov ax,data
    mov ds,ax
    lea dx,str
    call print_str
    lea dx,str1
    call print_str
    lea dx,str2
    call print_str
    lea dx,str3
    call print_str
    lea dx,str4
    call print_str
    lea dx,str5
    call print_str
    lea dx,str6
    call print_str
    lea dx,str7
    call print_str
    lea dx,str8
    call print_str 
    lea dx,str9
    call print_str
    lea dx,str10
    call print_str 
    mov al,0
    mov c,0
    next4:
        mov ah,01h
        int 21h        
        cmp al,0dh
        jz next5
        mov d,al
        sub d,30h
        mov al,c
        mov dh,0ah
        mul dh
        add d,al
        mov cl,d
        mov c,cl
        jmp next4
        
    next5:
    mov ah,0
    mov al,c
    cmp al,1
    jz add_num
    
    
    cmp al,2
    jz sub_num
    
    cmp al,3
    jz mul_num
    
    cmp al,4
    jz div_num
    
    cmp al,5
    jz modulo
    
    cmp al,6
    jz power
    
    cmp al,7
    jz fact
    
    cmp al,8
    jz frac_div
    
    cmp al,9
    jz npr
    
    cmp al,10
    jz ncr
    
    cmp al,0ah
    jz area_master
    
    
add_num:
    call two_input
    add al,bl         
    jmp outp
sub_num:
    call two_input
    sub al,bl
    jmp outp

mul_num:
    call two_input
    mul bl       
    jmp outp

div_num:
    call two_input
    div bl       
    jmp outp

modulo:
    call two_input
    div bl
    mov al,ah
    jmp outp

frac_div:
    call two_input
    fractional_div al,bl
    call print_frac
    mov al,c
    jmp done    
power:
    call two_input
    mov a8,al
    mov b8,bl
    call power_macro
    mov al,c
    jmp outp    
    
fact:
    call one_input
    mov a16,ax
    call factorial
    mov ax,c16
    call print_ax
    jmp done
    
;log:
;    call two_input      
;    mov cl,al
;    sub cl,1
;    mov al,cl
;    mov f,cl
;    mov cl,0
;    mov e16,cl
;    mov cl,1
;    mov ch,1
;    loop1:
;        cmp cl,3
;        jz exit_loop1
;        fractional_div16 al,cl
;        mov bx,c16
;        cmp ch,1
;        jz set
;        sub e,bx    
;        mov ch,1
;        jmp set_done
;        set:
;        add e,bl 
;        mov ch,2
;        set_done:
;       mul f
;       inc cl
;       jmp loop1
;   exit_loop1:
;    mov al,e
;    call print_al
;    jmp done       
           
            
npr:
    call two_input
    mov a16,ax
    call factorial
    sub ax,bx
    mov bx,c16
    mov a16,ax
    call factorial
    mov ax,bx
    mov cx,c16
    mov dx,0
    div cx 
    call print_ax
    jmp done           
           
ncr:
    call two_input
    mov a16,ax
    call factorial
    sub ax,bx
    mov dx,c16
    mov a16,ax
    call factorial
    mov cx,c16
    mov a16,bx
    call factorial
    mov ax,cx
    mov cx,dx
    mul c16
    mov bx,ax
    mov ax,cx
    xor dx,dx
    div bx   
    call print_ax
    jmp done           
           
           
           
area_master:
    call new_line
    
outp:
    call print_al
    
done:    
    hlt
    
print_str proc
    mov ah,09
    int 21h
    call new_line   
    ret
print_str endp
power_macro proc
    pusha
    mov cl,a8    
    rpt1:
        cmp b8,1
        jz power_macro_store
        mul cl
        sub b8,1
        jmp rpt1
    power_macro_store:
        mov c,al                
    popa
    ret
power_macro endp    


new_line proc
    MOV AH, 2                 ; set output function
    MOV DL, 0DH               ; carriage return
    INT 21H                   

    MOV DL, 0AH               ; line feed
    INT 21H
    ret
new_line endp


print_al proc
    mov ah,0
    call print_ax
    ret
print_al endp

one_input proc
    call new_line
    lea dx,in1
    call print_str
    mov al,0
    mov c,0
    next01:
        mov ah,01h
        int 21h        
        cmp al,0dh
        jz next02
        mov d,al
        sub d,30h
        mov al,c
        mov dh,0ah
        mul dh
        add d,al
        mov cl,d
        mov c,cl
        jmp next01
        
    next02:
    mov ah,0
    mov al,c    
    push ax
    call new_line
    pop ax
    ret
one_input endp

two_input proc
    call new_line
    lea dx,in1
    call print_str
    mov al,0
    mov c,0
    next0:
        mov ah,01h
        int 21h        
        cmp al,0dh
        jz next1
        mov d,al
        sub d,30h
        mov al,c
        mov dh,0ah
        mul dh
        add d,al
        mov cl,d
        mov c,cl
        jmp next0
        
    next1:
    mov ah,0
    mov al,c    
    push ax
    call new_line
    lea dx,in2
    call print_str
    mov al,0
    mov c,0
    next2:
        mov ah,01h
        int 21h        
        cmp al,0dh
        jz next3
        mov d,al
        sub d,30h
        mov al,c
        mov dh,0ah
        mul dh
        add d,al
        mov cl,d
        mov c,cl
        jmp next2
        
    next3:
    mov ah,0
    mov al,c    
    push ax
    call new_line
    pop bx
    pop ax       
    ret
two_input endp
      
print_frac proc
    mov al,c
    call print_al
    lea dx,str0
    mov ah,09
    int 21h
    mov al,d
    call print_al
    call new_line
    ret
print_frac endp

PRINT_AX PROC            
    mov cx,0 
    mov dx,0 
    label1: 
        cmp ax,0 
        je print1       
        mov bx,10         
        div bx                   
        push dx               
        inc cx               
        mov dx,0    
        jmp label1 
    print1: 
        cmp cx,0 
        je exit
        pop dx 
        add dx,48 
        mov ah,02h 
        int 21h 
        dec cx 
        jmp print1 
    exit: 
        ret 
PRINT_AX ENDP
factorial proc
    pusha
    mov cx,a16
    mov ax,1
    loop4:
        cmp cx,0
        jz fact_end
        mul cx
        dec cx
        jmp loop4
    fact_end:
        mov c16,ax
        popa
    ret
factorial endp

code ends

end start
