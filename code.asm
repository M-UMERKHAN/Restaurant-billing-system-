INCLUDE Irvine32.inc
.data
    m0 db "         !!!!!!Welcome in our project!!!!!!", 0
    m1 db 10,13,10,13, "Which menu do you want ??please select:", 0
    m2 db 10,13,10,13, "1.Rice 100/- 2.Vegetable 50/- 3.Soup 20/-", 0
    m3 db "Please select an option: ", 0   ; Prompt for option selection
    m8 db 10,13,10,13, "SORRY!!!There is no more than 3 item,if u want,u can add one", 0
    m9 db 10,13,10,13, "Enter Food name:", 0
    m10 db 10,13,10,13, "          Price:", 0
    m4 db 10,13,10,13, "To add press 1 or press 2 to get back menu :", 0
    m5 db 10,13,10,13, "Enter quantity:", 0
    m6 db 10,13,10,13, "Total price: ", 0
    m7 db 10,13,10,13, "      ****THANK YOU", 0
    m11 db "4.", 0  
    m12 db "/-", 0
    m13 db 10,13,10,13, " Re-order : Press <1>", 0
    m14 db 10,13,10,13, " Exit : Press Any key", 0
    q dw 0    
    r dw 0
    v db 0
    s dw 0
    rprice DWORD 100
    vprice DWORD 50
    sprice DWORD 20
    nprice DWORD 0
    var1 db 100 dup(?)    ; Reserved space for a string

.code
main PROC
    ; Display welcome message
    mov edx, OFFSET m0
    call WriteString


start:
    ; Check if v is greater than 0
    cmp v, 0
    jg start1

    ; Display menu selection prompt
    mov edx, OFFSET m1
    call WriteString

menu:
    ; Display menu options
    mov edx, OFFSET m2
    call WriteString

    ; Display prompt to select menu
    mov edx, OFFSET m3
    call WriteString

    ; Read user input
    call ReadInt      ; Input will be stored in EAX
    cmp eax, 1        ; Check if input is '1'
    je rice_
    cmp eax, 2        ; Check if input is '2'
    je veg_
    cmp eax, 3        ; Check if input is '3'
    je soup_
       
       
   menuadd:
    ; Increment v
    inc v

    ; Display "SORRY!!!" message
    mov edx, OFFSET m8
    call WriteString

    ; Display "To add or go back" message
    mov edx, OFFSET m4
    call WriteString

    ; Read user input
    call ReadChar
    mov al, dl ; Store the input in AL

    ; Check if the user wants to go back to the menu
    cmp al, '2'
    je menu

    ; Display "Enter Food Name" prompt
    mov edx, OFFSET m9
    call WriteString

    mov esi,offset var1
    mov ecx,6
    call ReadString
   


print:
    mov edx,offset var1
    call Writestring
    ; Call price procedure
    call price


       
       start1:
    ; Display the menu options
    mov edx, OFFSET m2
    call WriteString

    ; Display the custom food name (4th item) message
    mov edx, OFFSET m11
    call WriteString

    ; Display the custom food name stored in var1
    mov edx, OFFSET var1
    call WriteString

    ; Print a space
    mov dl, ' '
    call WriteChar

; Print the price of the custom food item (nprice)
xor eax, eax            ; Clear EAX
mov eax, nprice         ; Load nprice into EAX
call WriteDec           ; Call WriteDec to print the price

; Display "/-" after the price
mov edx, OFFSET m12     ; Load the address of the string m12 into EDX
call WriteString        ; Call WriteString to print the string "/-"

; Prompt for menu selection
mov edx, OFFSET m3      ; Load the address of the string m3 into EDX
call WriteString        ; Call WriteString to print the prompt


    ; Read the user's menu selection
    call ReadChar
    mov al, dl ; Store the input in AL for comparison

    ; Handle menu selection (1 = Rice, 2 = Vegetable, 3 = Soup)
    cmp al, '1'
    je rice_
    cmp al, '2'
    je veg_
    cmp al, '3'
    je soup_

newmenu_:
    ; Prompt for quantity
    mov edx, OFFSET m5
    call WriteString

    ; Clear AX and read quantity
    xor eax, eax
    call ReadDec

    ; Multiply quantity by the custom price (nprice)
    mov eax, eax
    mul nprice
    mov bx, ax ; Store result in BX

    ; Jump to the total price calculation
    jmp totalprice

       
       veg_:
    ; Prompt for quantity of vegetables
    mov edx, OFFSET m5
    call WriteString

    ; Clear AX and read quantity
    xor eax, eax
    call ReadDec

    ; Multiply quantity by the vegetable price
    mov eax, eax
    mul vprice
    mov bx, ax ; Store the result in BX

    ; Jump to total price calculation
    jmp totalprice

rice_:
    ; Prompt for quantity of rice
    mov edx, OFFSET m5
    call WriteString

    ; Clear AX and read quantity
    xor eax, eax
    call ReadDec

    ; Multiply quantity by the rice price
   ; mov eax, eax
    mul rprice
    mov ebx, eax ; Store the result in BX

    ; Jump to total price calculation
    jmp totalprice

soup_:
    ; Prompt for quantity of soup
    mov edx, OFFSET m5
    call WriteString

    ; Clear AX and read quantity
    xor eax, eax
    call ReadDec

    ; Multiply quantity by the soup price
    mov ebx, eax        ; Store quantity in EBX
    mov eax, sprice     ; Load soup price into EAX
    mul ebx             ; Multiply EAX (soup price) by EBX (quantity)
    mov bx, ax          ; Store result in BX (lower 16 bits)

    ; Jump to total price calculation
    jmp totalprice

price:
    ; Prompt for custom food price input
    mov edx, OFFSET m10
    call WriteString

input:
   call readint

done:
   ; call ReadInt
    ; Store the entered price in nprice


           
    totalprice:
    ; Display "Total price:"
   mov edx, OFFSET m6    ; Load address of "Total price:" message
    call WriteString      ; Call WriteString to display it

    mov nprice,eax
    call writeint

    ; Prompt for re-order or exit options
    mov edx, OFFSET m13   ; Load the message "Would you like to reorder?"
    call WriteString      ; Display the prompt
    mov edx, OFFSET m14   ; Load the message "Press 1 to reorder, any other key to exit."
    call WriteString      ; Display the instruction

    ; Wait for user input
    call ReadChar         ; Read user input into AL

    ; Check if the user pressed '1' (ASCII 31h)
    cmp al, '1'           ; Compare AL with '1' (reorder)
    je start              ; If '1', jump back to the start (reorder)

    ; Display "Thank You" message
    mov edx, OFFSET m7    ; Load "Thank You" message address
    call WriteString      ; Display the "Thank You" message

    ; Exit program
    call ExitProcess      ; Call ExitProcess to terminate the program

main endp



END main
