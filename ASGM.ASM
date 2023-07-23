.model small
.stack 100h
.386
.data
       return db 10, 'Enter any key to return.$'
       noStock db 10, '--There is no stock available for this item--$'
       dash db 10, '..............................................$'
       rec db 10, '                  RECEIPT                    $'
       total db 10, '                              Total: RM $'
       inv db 10, '             INVENTORY              $'
       invt db 10, '---FOOD ITEM--------------------PRICE----QTY$'
       error db 10, 'Invalid input! Items in cart will be cleared. Please try again.$'

       msg1 db 10, '4: -Checkout-'
          db 10, '5: -Cancel Order'
          db 10, 'Please select an Option: $'

       register db 10, '        APU CASH REGISTER       $'
       cart db 10, '----ITEM HAS BEEN ADDED TO CART-----'
            db 10, '--CONTINUE BROWSING FOOD OR SELECT CHECKOUT TO PRINT RECEIPT--$'
       welcome  db 10, 'Welcome to APU Electornic Cash Register$'
       mainmenu db 10, '1: Proceed to Food Menu'                    
                db 10, '2: Check Food Inventory'
                db 10, '0: Exit the System'
                db 10, 'Please choose an operation: $'
                        
       menu db 10, 'APU Electronic Cash Register'
          db 10, '1: Rice'
          db 10, '2: Noodles'       
          db 10, '3: Beverages$'

       riceMenu db 10, 'Rice Menu$'
       rice1 db 10, '1: Nasi Lemak...................RM 04     $'
       rice2 db 10, '2: Chicken Rice.................RM 06     $'
       rice3 db 10, '3: Fried Rice...................RM 05     $'   
       exit db 10, '0: -Back-'
            db 10, 'Please select an option: $'

       noodlesMenu db 10, 'Noodles Menu$'
       nood1 db 10, '4: Spaghetti....................RM 11     $'  
       nood2 db 10, '5: Wanton Noodles...............RM 05     $'
       nood3 db 10, '6: Char Kuey Teow...............RM 07     $'
                                                                       
       beverageMenu db 10, 'Beverages Menu$'
       bev1 db 10, '7: Soft Drinks..................RM 02     $'
       bev2 db 10, '8: Mineral Water................RM 01     $'
       bev3 db 10, '9: Coffee.......................RM 03     $'                   

       sum dw 0
       i db 9 dup(9) ;array to store stock count. all initial stock count is 9
       a db 9 dup(0) ;array of zeros to temporary store food item selected

.code

ShowMsg Macro Msg  ;macro to display string
        lea dx, Msg
        mov ah, 09h
        int 21h
EndM

ShowChar Macro Char    ;macro to display char
        mov ah, 02h
        mov dl, Char
        add dl, 30h
        int 21h
EndM

ClearScreen Macro     ;macro to clear screen
        mov ax, 0003h
        int 10h
EndM

Line Macro           ;macro to add lines
      mov dl, 10
      mov ah, 02h
      int 21h
EndM

ReadChar Macro      ;macro to read char
      mov ah, 01h
      mov dl, al
      int 21h
EndM

ReadStr Macro Msg   ;macro to read string
      mov ah, 0Ah
      mov dx, offset Msg
      int 21h
EndM

PrintItems Macro   ;macro to list inventory 
        ShowMsg dash
        ShowMsg inv
        ShowMSg invt

        ShowMsg rice1
        ShowChar i[0]
                           
        ShowMsg rice2
        ShowChar i[1]

        ShowMsg rice3
        ShowChar i[2]

        ShowMsg nood1
        ShowChar i[3]

        ShowMsg nood2
        ShowChar i[4]

        ShowMsg nood3
        ShowChar i[5]

        ShowMsg bev1
        ShowChar i[6]

        ShowMsg bev2
        ShowChar i[7]

        ShowMsg bev3
        ShowChar i[8]

        ShowMsg dash
EndM

ClearArray Macro  ;for resetting the food item array           
        mov bx, 0
lp:     mov a[bx], 0   
        inc bx
        cmp bx, 9; if bx is nine we break out of loop
        jne lp
EndM

PrintReceipt Macro  ;for printing receipt
        ShowMsg dash
        ShowMsg rec
        ShowMsg invt
        mov bx, 0    ;first declare index as 0

top:    mov ah, a[bx]   ;move array value to ah
        cmp ah, 0      
        jne print     ;we print if the value is not 0
        jmp incre     ;else we increment without printing
           
incre:  inc bx   
        cmp bx, 9 ;if bx is 9 we break out of loop
        jne top   ;if not 9 we continue loop
        jmp printTotal  ;if 9 we break loop and printTotal

print:  cmp bx, 0  ;check index to see which food item
        je print1  ;if index is 0 then its item 1      
          
        cmp bx, 1
        je print2
                
        cmp bx, 2
        je print3
                
        cmp bx, 3
        je print4
              
        cmp bx, 4
        je print5
              
        cmp bx, 5
        je print6
              
        cmp bx, 6
        je print7
               
        cmp bx, 7
        je print8
               
        cmp bx, 8
        je print9
              
print1: ShowMsg rice1
        ShowChar a[0]  ;print the number of times item is selected   
        jmp incre
print2: ShowMsg rice2
        ShowChar a[1]   
        jmp incre
print3: ShowMsg rice3
        ShowChar a[2]   
        jmp incre
print4: ShowMsg nood1
        ShowChar a[3]    
        jmp incre
print5: ShowMsg nood2
        ShowChar a[4]    
        jmp incre
print6: ShowMsg nood3
        ShowChar a[5]   
        jmp incre
print7: ShowMsg bev1
        ShowChar a[6]   
        jmp incre
print8: ShowMsg bev2
        ShowChar a[7]     
        jmp incre
print9: ShowMsg bev3
        ShowChar a[8]    
        jmp incre

printTotal:
        ShowMsg total
        mov ax, sum  ;mov sum value to ax
        call PrintNumber ;print value in ax
        ShowMsg dash    

EndM

PrintNumber Proc    ;macro to print more than 1 digit numbers -from geeks2geeks
        mov cx, 0 
        mov dx, 0
        label1:
                cmp ax, 0
                je printing
                mov bx, 10     
                div bx         
                push dx      
                inc cx
                xor dx, dx
                jmp label1
         printing:
                cmp cx, 0
                je done
                pop dx
                add dx, 48
                mov ah, 02h
                int 21h
                dec cx
                jmp printing

done:
        ret
PrintNumber Endp

Main proc

        mov ax, @data
        mov ds, ax

        DispMain:
                ClearScreen
                ShowMsg welcome
                ShowMsg mainmenu ;show main menu
                ReadChar
                             
                cmp al, '1'
                je DispMenu
        
                cmp al, '2'
                je DispInv
                       
                cmp al, '0'
                je QuitPrg  

                jmp DispMain  

        DispInv:
                ClearScreen
                PrintItems
                ShowMsg return
                ReadChar
                jmp DispMain  
              
        DispMenu:
                ClearScreen
                mov sum,  0  ;reinitialize sum
                ClearArray ;to clear items in array
                ShowMsg menu; show food  menu and prompt user to choose an option
                ShowMsg exit
                ReadChar
        
                cmp al, '1'
                je Disp1       
        
                cmp al, '2'
                je Disp2      
        
                cmp al, '3'
                je Disp3     
                  
                cmp al, '0'
                je DispMain    

                jmp DispMenu     

        DispMenu2: ;menu with item selected
                ClearScreen
                ShowMsg cart
                ShowMsg menu
                ShowMsg msg1
                ReadChar

                cmp al, '1'
                je Disp1     
        
                cmp al, '2'
                je Disp2    
        
                cmp al, '3'
                je Disp3    
                  
                cmp al, '4'
                je Receipt    

                cmp al, '5'
                je DispMenu   

                jmp DispMenu2  

       Receipt: ClearScreen
                PrintReceipt
                ShowMsg return
                ReadChar
                jmp DispMenu    

        Disp1:  ClearScreen
                ShowMsg riceMenu
                ShowMsg rice1
                ShowMsg rice2
                ShowMsg rice3
                ShowMsg exit  
                                
                ReadChar

                cmp al, '1'
                je menu1      
                                  
                cmp al, '2'
                je menu2         

                cmp al, '3'
                je menu3     

                cmp al, '0'
                je DispMenu 

                ShowMsg error
                ShowMsg return
                ReadChar
                jmp DispMenu    


        menu1:  cmp i[0], 0      ;we ensure that stock is avaible
                je outOfStock    ;if stock not avaible we jump to outOfstock
                mov ax, sum      
                add ax, 4        ;else we add the rpice into sum
                mov sum, ax
                add a[0], 1      ;increment the array for food item
                sub i[0], 1      ;decrement stock value for food item
                jmp DispMenu2
                                
        menu2:  cmp i[1], 0
                je outOfStock
                mov ax, sum
                add ax, 6
                mov sum, ax
                add a[1], 1  
                sub i[1], 1
                jmp DispMenu2

        menu3:  cmp i[2], 0
                je outOfStock
                mov ax, sum
                add ax, 5
                mov sum, ax
                add a[2], 1   
                sub i[2], 1
                jmp DispMenu2
                                 
        Disp2:  ClearScreen
                ShowMsg noodlesMenu
                ShowMsg nood1
                ShowMsg nood2
                ShowMsg nood3
                ShowMsg exit

                ReadChar

                cmp al, '4'
                je menu4   

                cmp al, '5'
                je menu5     

                cmp al, '6'
                je menu6    

                cmp al, '0'
                je DispMenu

                ShowMsg error
                ShowMsg return
                ReadChar
                jmp DispMenu   

       menu4:   cmp i[3], 0
                je outOfStock
                mov ax, sum
                add ax, 11
                mov sum, ax
                add a[3], 1   
                sub i[3], 1
                jmp DispMenu2 

       menu5:   cmp i[4], 0
                je outOfStock
                mov ax, sum
                add ax, 5
                mov sum, ax
                add a[4], 1   
                sub i[4], 1
                jmp DispMenu2

       menu6:   cmp i[5], 0
                je outOfStock
                mov ax, sum
                add ax, 9
                mov sum, ax
                add a[5], 1     
                sub i[5], 1
                jmp DispMenu2

        Disp3:  ClearScreen
                ShowMsg beverageMenu
                ShowMsg bev1
                ShowMsg bev2
                ShowMsg bev3
                ShowMSg exit

                ReadChar

                cmp al, '7'
                je menu7     

                cmp al, '8'
                je menu8    

                cmp al, '9'
                je menu9     

                cmp al, '0'
                je DispMenu  
                    
                ShowMsg error
                ShowMsg return
                ReadChar
                jmp DispMenu 

        menu7:  cmp i[6], 0
                je outOfStock
                mov ax, sum
                add ax, 2
                mov sum, ax
                add a[6], 1  
                sub i[6], 1
                jmp DispMenu2 

        menu8:  cmp i[7], 0
                je outOfStock
                mov ax, sum
                add ax, 1
                mov sum, ax
                add a[7], 1  
                sub i[7], 1
                jmp DispMenu2  

        menu9:  cmp i[8], 0
                je outOfStock
                mov ax, sum
                add ax, 3
                mov sum, ax
                add a[8], 1   
                sub i[8], 1
                jmp DispMenu2

        outOfStock:
                ClearScreen
                ShowMsg noStock
                ShowMsg return
                ReadChar
                jmp DispMenu2

        QuitPrg:
                mov ah, 4ch
                int 21h

Main endp
End main
