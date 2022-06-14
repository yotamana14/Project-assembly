jumps
IDEAL
MODEL small
STACK 100h
white = 7  ;| the color of the obstacle    
BLACK = 0     ;| the color to rease the obstacle
INITIAL_RIGHT_LOWER_X = 319  ;| RIGHT LOWER x cornor for the obstacle         
INITIAL_RIGHT_LOWER_Y = 167;| RIGHT LOWER y cornor for the obstacle   
RECTANGLE_WIDTH = 10  ;|  the WIDTH of the obstacle
RECTANGLE_HEIGHT = 10 ;|  the HEIGHT of the obstacle
STEP=1
DATASEG
;|The variables for the code  to set height / length \ size \ color \ counters \ and more 
y_for_scroll dw 167      ;| the y position for the scroll


x_for_animation_1 dw 160;|  The position of the  runninig\jumping character in the x
y_for_animation_1 dw 161;|The position of the  running character in the x
y_for_animation_1_body dw 159;| the y position for the body
y_for_animation_2 dw 141;|the The position of the jumping character in the x
color_for_animtion db 7;| the color to the characters
color_for_animtion_Erase db 0;|the color to erase the characters
color_for_comparing db 8 ;| color for comparing the animation (for scroll and obstacle)
saved_time db 0;| the time i want to delay

counter db 0 ;| counter for the time  

counter_for_time_1 dw 0  ;|counter for the delay
counter_for_time_2 dw 0  ;|counter for the delay


The_pace_of_the_game_to_jumping_animation dw 470;\ the variables who dicede the pase of the game while jumping
The_pace_of_the_game_to_running_animation dw 410;\ the variables who dicede the pase of the game while running

msg db 'you reached to level:',10,13,'$'   ;| the text that shows you how much points you reached
 msg_failed db 'you failed :( press space to try agian or pressed esc to exit',10,13,'$';| the text that show when you fail
 msg_for_start db 'hey :) to start press space',10,13,'$' ;| the text that show you when you start
 msg_for_start_ruls db 'for jumping press space and your goal is to keep running without enconter in the obstacle, enter space',10,13,'$' ;|the text that telling the ruls&goals of the game
 msg_for_good_luck db 'good luck ;)',10,13,'$' ;| msg for good luck
      
Corner1_X dw ?             ;|    
Corner1_Y dw ?             ;|
Corner2_X dw  ?            ;| the variables for rhe obstacle
Corner2_Y dw  ?            ;|
erase_Corner1_X dw ?       ;|
erase_Corner2_X dw ?       ;|


CODESEG
;|FONC FOT THE LEG can be use to paint&erase
PROC LEG
push bp               ;| Set variables to determine location and size and color
mov bp,sp             ;|
LONG_LEG equ [bp+4] ;| the position where the leg stop being
color_LEG equ [bp+6];| the color of the leg   
loopLEG:           ;|    
mov al, color_LEG  ;|
mov ah,0ch         ;|
int 10h            ;| the  loop that print the leg
inc dx             ;|
cmp dx,LONG_LEG    ;|
jne loopLEG        ;|
pop bp             ;|
RET 4              ;|
ENDP LEG   


        
;FONC FOT THE BODY           
PROC BODY
push bp               ;|Set variables to determine location and size and color
mov bp,sp             ;|
LONG_BODY equ [bp+4] ;|the position where the leg start being
color_BODY equ [bp+6] ;| the color of the BODY
loopBODY:                     
mov al,color_BODY;|
mov ah,0ch                 ;|
int 10h                    ;|
dec dx                     ;|
cmp dx,LONG_BODY           ;| the  loop that print the body
jne loopBODY               ;|
pop bp                     ;|
RET 4                      ;|
ENDP BODY         


        
; fonc for the head
PROC HEAD     
push bp    ;|Set variables to determine location and size and color
mov bp,sp  ;|
head_HEIGT equ [bp+4] ;| the locition where the head started being print from x line
head_WIDTH EQU [bp+6] ;| the locition where the head started being print from y line
HEAD_COLOR EQU [BP+8] ;| he color of the HEAD
loop6:                      ;|
mov cx,[x_for_animation_1]  ;|
inc dx                      ;|
loop5:                      ;|
mov al,HEAD_COLOR ;|
mov ah,0ch                  ;|
int 10h                     ;|
inc cx                      ;|the  loop that print the head
cmp cx,head_HEIGT           ;|
jne loop5                   ;|
cmp dx,head_WIDTH           ;|
jne loop6                   ;|
pop bp                      ;|
RET 6                       ;|
ENDP head           
            


; fonc for the left hand
proc left_hand
push bp      ;|Set variables to determine location and size and color
mov bp,sp    ;|
left_hand_long equ [bp+4] ;|the locition where the left hand stop being print 
LEFT_HAND_COLOR EQU [BP+6] ;| the color of the left hand
loop_left_hand:            ;|
mov al,LEFT_HAND_COLOR;|
mov ah,0ch                 ;|
int 10h                    ;|
dec cx                     ;| the loop that print the  left hand
inc dx                     ;|
cmp cx,left_hand_long      ;|
jne loop_left_hand         ;|
pop bp                     ;|
RET 4                      ;|
ENDP left_hand             
    


;fonc for the right hand
proc right_hand
push bp    ;|Set variables to determine location and size and color
mov bp,sp  ;|
right_hand_long equ [bp+4] ;|the locition where the right hand start being print 
right_hand_color equ [bp+6];|the color of the right hand

loop_right_hand:           ;|
mov al,right_hand_color    ;|
mov ah,0ch                 ;|
int 10h                    ;|
inc cx                     ;|the loop that print the right hand
inc dx                     ;|
cmp cx,right_hand_long     ;|
jne loop_right_hand        ;|
pop bp                     ;|
RET 4                      ;|
ENDP right_hand



;fonc for the bottom body
proc bottom_body
push bp   ;| Set variables to determine location and size and color
mov bp,sp ;| 
bottom_body_x equ [bp+4] ;| the locition where the body start being print
bottom_body_color equ [bp+6]
loop_bottom_body:           ;|
mov al,bottom_body_color    ;|
mov ah,0ch                  ;|
int 10h                     ;|
inc cx                      ;|the loop that print the body
cmp cx,bottom_body_x        ;|
jne loop_bottom_body        ;|
pop bp                      ;|
RET 4                       ;|
ENDP bottom_body



;double loop to delay movement, can play with cx,dx to make it faster/slower
; FONC FOR DELAY
proc Delay    
push bp   ;| Set variables to determine location and size and color
mov bp,sp ;| 
time_i_want_to_wait equ [bp+4] ;| Set variables to determine time i want this to to wait      
mov bx , time_i_want_to_wait                             
mov [counter_for_time_1], 500                     ;|     
DelayLoopOut:                                     ;|
mov [counter_for_time_2],1000                     ;|
DelayLoopIn:                                      ;|                          ;|double loop to delay movement, can play with cx,dx to make it faster/slower
DEC [counter_for_time_2]
cmp  [counter_for_time_2],0      ;| 
jne DelayLoopIn                                    ;|                    
dec [counter_for_time_1]
cmp [counter_for_time_1],bx
ja DelayLoopOut                                   ;|
 POP BP
 ret 2            
   endp delay




;FONC FOR THE LEG ANIMATION(THE RUNNUNG ANIMATION)
PROC ERASE_LEG_FOR_ANITMATION
push bp                      ;| 
mov bp,sp                    ;| 
LEG_COLOR_1 EQU [BP+4]       ;|
LEG_COLOR_2 EQU [BP+6]       ;| Set variables to determine location and size and color
 PUSH LEG_COLOR_2            ;| 
push 167                     ;|Set variables to determine location and size and color
mov cx,158                   ;|
mov dx,[y_for_animation_1]   ;|
CALL LEG  ;| call to the fonc that erase the leg
call obstacle_step
push [The_pace_of_the_game_to_running_animation] 
                  
 call delay ;| call the delay for more ralistic animation
 call obstacle_step 
 PUSH LEG_COLOR_1          ;|
push 167                     ;|Set variables to determine location and size and color
mov cx,158                   ;|
mov dx,[y_for_animation_1]   ;|
CALL LEG                     ;| call to the fonc that print the leg
PUSH LEG_COLOR_2           ;|
push 167                     ;|Set variables to determine location and size and color
mov cx,162                   ;|
mov dx,[y_for_animation_1]   ;|
 CALL LEG  ;|call to the fonc that erase the leg
 call obstacle_step
 push [The_pace_of_the_game_to_running_animation]
 call delay 
 call obstacle_step ;|call the delay for more ralistic animation 
 PUSH LEG_COLOR_1          ;|
push 167                     ;|
mov cx,162                   ;|Set variables to determine location and size and color
mov dx,[y_for_animation_1]   ;|
 CALL LEG ;| call to the fonc that print the leg
 POP BP
 ret 4
endp ERASE_LEG_FOR_ANITMATION




;grahfic for the run animation
proc man_run_animation
push bp                                ;| Set variables to determine location and size and color
mov bp,sp                              ;| 
color_for_animtion_printing equ [bp+4] ;|Set variables to determine color
 color_for_animtion_running1 equ [bp+6] ;|Set variables to determine color
 color_for_animtion_running2 equ [bp+8] ;|Set variables to determine color

; body
mov dx,[y_for_animation_1_body]  ;|  
mov cx,[x_for_animation_1]       ;| Set variables to determine location size color and calling to the fonc for printing the body
push color_for_animtion_printing ;|
PUSH 150                         ;| 
CALL BODY                        ;|


;head
mov dx,145                         ;| 
push color_for_animtion_printing;color_for_animtion_printing ;|
PUSH 150                           ;|
PUSH 163                           ;|Set variables to determine location size color and calling to the fonc for printing the head
call head                          ;|
 

;left hand      
mov cx,[x_for_animation_1]         ;|
mov dx,153                         ;|
push color_for_animtion_printing ;|Set variables to determine location size color and calling to the fonc for printing the left hand
push 155                           ;|
call left_hand                     ;|


                 
; right hand                         ;|
mov cx,[x_for_animation_1]           ;|
mov dx,153                           ;|Set variables to determine location size color and calling to the fonc for printing the right hand
push color_for_animtion_printing   ;|
push 165                             ;|
call right_hand                      ;|



;bottom body                        ;|
mov dx,160                          ;|
mov cx,158                          ;|
push color_for_animtion_printing    ;|Set variables to determine location size color and calling to the fonc for printing the bottom body
push 163                            ;|
call bottom_body    

push  color_for_animtion_running1
push  color_for_animtion_running2
call ERASE_LEG_FOR_ANITMATION


pop bp                 ;|
ret 6                  ;| the end of the printing  running man fonc
endp man_run_animation ;|





;grahfic for the jump animation
proc man_jump_animation
push bp                                ;| Set variables to determine location and size and color
mov bp,sp                              ;| 
color_for_animtion_printing equ [bp+4] ;|
;left_leg                          ;|     
PUSH color_for_animtion_printing   ;|         
 push 145                          ;|Set variables to determine location size color and calling to the fonc for printing the left leg
 mov cx,158                        ;|
mov dx,[y_for_animation_2]         ;|
CALL LEG  
     
                     
;right_LEG                            ;|
PUSH color_for_animtion_printing      ;|
 push 145                             ;|
mov cx,162                            ;|
mov dx,[y_for_animation_2]            ;|Set variables to determine location size color and calling to the fonc for printing the right leg
CALL LEG     
                         

;body                              ;|
mov dx,140                         ;|  
mov cx,[x_for_animation_1]         ;|  
; body                             ;|Set variables to determine location size color and calling to the fonc for printing the body
PUSH color_for_animtion_printing   ;|
PUSH 130                           ;|
CALL BODY                          ;|



;head                              ;|
mov dx,125                         ;|
PUSH color_for_animtion_printing   ;|Set variables to determine location size color and calling to the fonc for printing the head
PUSH 130                           ;|
PUSH 163                           ;|
call head                          ;|



;left hand                          ;|
mov cx,[x_for_animation_1]          ;|
mov dx,133                          ;|Set variables to determine location size color and calling to the fonc for printing the left hand 
PUSH color_for_animtion_printing    ;|
push 155                            ;|
call left_hand                      ;|




;right hand                         ;| 
mov cx,[x_for_animation_1]          ;|
mov dx,133                          ;|Set variables to determine location size color and calling to the fonc for printing the right hand
PUSH color_for_animtion_printing    ;|
push 165                            ;|
call right_hand                     ;|




;bottom body                             ;|
mov dx,140                               ;|
mov cx,158                               ;|Set variab to determine location size color and calling to the fonc for printing the bottom body
PUSH color_for_animtion_printing         ;|
push 163                                 ;|
call bottom_body
POP BP                     ;|
ret 2                      ;| the end of the jumping animation fonc
endp man_jump_animation    ;|



proc scroll                    ;| the fonc for the sroll
mov dx,[y_for_scroll]   ;| the loctions in axis w,y
mov cx,0                ;| 
loopscroll:                    ;|
mov al,[color_for_comparing]   ;|
mov ah,0ch                     ;|
int 10h                        ;| the loop   that print the scroll
inc cx                         ;|
cmp cx,320                     ;|
jne loopscroll                 ;|
ret          ;| the end of the scroll fonc
endp scroll  ;|




;drawing a rectange accrding to corner 1 (x,y) (right lower corner) and corner 2 (x,y) (left upper corner)
; color is BLACK
proc eraseobstacle 
push cx                     ;|    
push dx                     ;| set variab to determine location size color and calling to the fonc for printing the obstacle
push bx                     ;|
mov al,0                    ;|
mov cx,[erase_Corner1_X]
    
erase_x_loop:            ;| 
mov dx,[Corner1_Y]       ;|
erase_y_loop:            ;|
mov bh,0                 ;|
mov ah,0ch               ;|
int 10h                  ;|
dec dx                   ;|the loop for printing the obstacle
cmp dx,[Corner2_Y]       ;|
jne erase_y_loop         ;|
dec cx                   ;|
cmp cx,[erase_Corner2_X] ;|
jne erase_x_loop         ;|
pop bx
pop dx
pop cx
ret           
endp eraseobstacle    


;Erasing  a rectange accrding to corner 1 (erase_CornerX_1,erase_CornerY_1)  - lower right corner,
; and corner 2 (erase_CornerX_2,erase_CornerY_2)  - upper  left corner
; (Done by drawing a BLACK rectangle)
proc drawobstacle
push cx                     ;|    
push dx                     ;| set variab to determine location size color and calling to the fonc for erasing the obstacle
push bx                     ;|
mov al,[color_for_comparing]                   ;|
mov cx,[Corner1_X]
    
drow_x_loop:            ;| 
mov dx,[Corner1_Y]       ;|
drow_y_loop:            ;|
mov bh,0                 ;|
mov ah,0ch               ;|
int 10h                  ;|
dec dx                   ;|the loop for erasing the obstacle
cmp dx,[Corner2_Y]       ;|
jne drow_y_loop         ;|
dec cx                   ;|
cmp cx,[Corner2_X] ;|
jne drow_x_loop         ;|
pop bx
pop dx
pop cx
ret           
endp drawobstacle  

                                                                 
  
       




;fonc for 1 obstacle step
proc obstacle_step
 sub [erase_Corner1_X], STEP
  sub [erase_Corner2_X], STEP

  call Eraseobstacle
  
   ;update rectangle coordiantes
  sub [Corner1_X], STEP
  sub [Corner2_X],STEP
  call Drawobstacle 
  cmp [Corner1_X],1     ;|
  je repear             ;| checking if you reched to the end and its need to repear the bag   
  ret
  endp obstacle_step
  
  

  

  
  
  proc the_first_obstacle_move_and_set_variables
  ; prepare first rectange to draw: RECTANGE_WIDTH x RECTANGLE_HEIGHT pixels

;corner1 x and y                        ;|
 mov [Corner1_X],INITIAL_RIGHT_LOWER_X  ;|
 mov [Corner1_Y], INITIAL_RIGHT_LOWER_Y ;|
 
;corner2 y                              ;|
 mov bx, [Corner1_Y]                    ;|         Set variables to determine location size color and calling to the fonc for printing the obstacle
 mov [Corner2_Y],bx                     ;|
 sub [Corner2_Y],RECTANGLE_HEIGHT       ;| 
 
; corner2 x                             ;|
 mov bx,[Corner1_X]                     ;|
 mov [Corner2_X], bx                    ;|
 sub [Corner2_X],RECTANGLE_WIDTH        ;|       
 
 call Drawobstacle ; for first time drawing 

 ; set erase x (corner 1 )
 mov bx,[Corner1_X]                                           ;|
 mov[erase_Corner1_X], bx ; prepare 2X50 rectange to erase    ;|  Set variables to determine location size color and calling to the fonc for erasing the obstacle
 ; set erase x (corner 2 )                                    ;|
 add [erase_Corner1_X],STEP                                   ;|
 mov [erase_Corner2_X],bx                                     ;|   
 
 ; next rectange width is STEP
 sub  [Corner1_X],RECTANGLE_WIDTH
 add [Corner1_X],STEP
 ret
 endp the_first_obstacle_move_and_set_variables
 
 
 
 
 
 
 
 
 
 ;| FONC FOR DELAYing while printing the obstacle
 proc delay_while_printing_obstacle
 push bp                                        ;| Set variables to determine location and size and color
mov bp,sp                                       ;|
long_wait_while_printing_obstacle equ [bp+4]    ;|
mov cx,long_wait_while_printing_obstacle
waiting_loop:                     ;|
call obstacle_step                ;|
push [The_pace_of_the_game_to_jumping_animation]                            ;|
call delay                        ;| the loop that delay and print the obstacle
loop waiting_loop                 ;|
 POP BP                           ;|
 ret 2                            ;|                 
endp delay_while_printing_obstacle;|




 ;|fonc for failed checking
PROC failed_checking
check_loop:
  mov ah,0Dh         ;|
  mov dx, 157        ;|
  mov cx,[Corner2_X] ;|
int 10H              ;| code for checking if you failed
cmp al, 7            ;|
je failed           ;|         
  mov cx,[Corner1_X] ;|
int 10H              ;| code for checking if you failed
cmp al, 7            ;|
je failed           ;|              
ret                  ;|
endp failed_checking ;|




;| starting the main 
start:
mov ax, @data
mov ds, ax
mov ax, 13h
int 10h
keep_wait:
;| the text that show you when yo start
  mov  dl, 0   ;Column x
  mov  dh, 0   ;Row y
mov bh,0
mov  ah, 02h  ;SetCursorPosition
int  10h
mov dx,offset msg_for_start
mov ah,09h
int 21h
 mov ah,0 ;|Get keyboard data
   int 16h  ;|   
   cmp ah, 39h ; Is it  space key ? |
   ;|if its space the game will restart
   jne keep_wait  ;|i not iwill be keep going
  MOV AX,0600H    ;06 TO SCROLL & 00 FOR FULLJ SCREEN            |  
    MOV BH,0H    ;ATTRIBUTE 7 FOR BACKGROUND AND 1 FOR FOREGROUND  |
    MOV CX,0000H    ;STARTING COORDINATES                          |clear the screen for the texts and the game
    MOV DX,184FH    ;ENDING COORDINATES                            |
    INT 10H        ;FOR VIDEO DISPLAY                              |
    MOV AH,4CH    ;RETURN TO DOS MODE                              |
   
;| the text that show you the ruks of the game
  mov  dl, 0   ;Column x
  mov  dh, 0  ;Row y
mov bh,0
mov  ah, 02h  ;SetCursorPosition
int  10h
mov dx,offset msg_for_start_ruls
mov ah,09h
int 21h
;| the text that say good luck
  mov  dl, 0   ;Column x
  mov  dh, 7  ;Row y
  mov bh,0
mov  ah,02H  ;SetCursorPosition
int  10h
mov dx,offset msg_for_good_luck
mov ah,09h
int 21h
start_loop:
mov ah,1;|Read keyboard status port
int 16h ;|
je start_loop; No new key press
 

   mov ah,0 ;|Get keyboard data
   int 16h  ;|
   
   cmp ah, 39h ; Is it  space key ?
   jne start_loop
   
   
   
   
   
   return_to_the_game:
    MOV AX,0600H    ;06 TO SCROLL & 00 FOR FULLJ SCREEN            |  
    MOV BH,0H    ;ATTRIBUTE 7 FOR BACKGROUND AND 1 FOR FOREGROUND  |
    MOV CX,0000H    ;STARTING COORDINATES                          |clear the screen for the texts and the game
    MOV DX,184FH    ;ENDING COORDINATES                            |
    INT 10H        ;FOR VIDEO DISPLAY                              |
    MOV AH,4CH    ;RETURN TO DOS MODE                              |
   
    
    
call scroll    ;| call the scroll fonc to print the scroll  

;| the text that show you what level you reached
  mov  dl, 0   ;Column x
  mov  dh, 0   ;Row y
mov bh,0
mov  ah, 02h  ;SetCursorPosition
int  10h
mov dx,offset msg
mov ah,09h
int 21h




repear:                                              
 call the_first_obstacle_move_and_set_variables ;| call to  this fonc to restart the obstacl's move
 
mov [erase_Corner1_X], 21   ;|
mov [erase_Corner2_X], 1    ;| calling to the fonc to erase the last obstacle
  call Eraseobstacle        ;|

  
  
  
  inc [The_pace_of_the_game_to_jumping_animation]  ;|  make the game gofaster  
 add [The_pace_of_the_game_to_running_animation],2 ;|
  
  mov  dl, 60   ;Column x
mov bh,0
mov  ah, 02h  ;SetCursorPosition    
int 21h

 
thewholeloop:   ;|the loop of the game
call failed_checking ;| cheak if you failed
  mov dx,167   ;| the loctions in axis w,y
  mov cx,0                ;| 
looprepear:                    ;|
mov al,[color_for_comparing]    ;|
mov ah,0ch                     ;|
int 10h                        ;| the loop to repear the bag of increasing the y
inc cx                         ;|
cmp cx,22                      ;|
jne looprepear
 


push 7        ;|
push 0        ;|
 push 7    ;|the colors for the running man animation              
call man_run_animation ;| calling the run man animation to print  run man animation 
push 0
push 7
 call ERASE_LEG_FOR_ANITMATION
;call failed_checking ;| cheak if you failed
    call  obstacle_step ;|for making the obstacle move
    ;call  failed_checking 
    ;call  failed_checking  
mov ah,1;|Read keyboard status port
int 16h ;|
je thewholeloop; No new key press
 



   mov ah,0 ;|Get keyboard data
   int 16h  ;|
   
   cmp ah, 39h ; Is it  space key ?
   jne thewholeloop ; keep printing the run animation cuze the player didnt press in enter
   jumping:   ;| the player pressed on enter and the running man animation wiil be erased and the jummping man animation wiil be showen   
  
push 0
push  0   
 push 0               ;| erase the running man animation by printing black on the running man animation           ;|
call man_run_animation

 call obstacle_step
PUSH 7                     ;| printing  the jumpimg man animation
 call man_jump_animation
 push 18                          ;| HOW MUCH TIME YOU WANT THE CHARCTER STAY JUMPING
 call delay_while_printing_obstacle
 call  failed_checking 
 push 0
call man_jump_animation     ;| erase the jumping man animation by printing black on the jumping man animation

call failed_checking ;| cheak if you failed
jmp thewholeloop ;| return to the start and  do all the things agian

;|if you failed this loop will be run
failed:
;| the text that show you when you failed
  mov  dl, 0   ;Column x
  mov  dh,0  ;Row y
mov bh,0
mov  ah, 02h  ;SetCursorPosition
int  10h
mov dx,offset msg_failed
mov ah,09h
int 21h
mov ah,1;|Read keyboard status port
int 16h ;|
je failed; No new key press
   mov ah,0 ;|Get keyboard data
   int 16h  ;|   
   cmp ah, 39h ; Is it  space key ? |
   ;|if its space the game will restart
 jne keep_going  ;|i not iwill be keep going
 jmp return_to_the_game   
  keep_going:
  cmp ah, 1h ; Is it  esc key ? \ if this is a esc key that preesed the gmae will end
   je exit
   jmp failed ;|if no key preesed its return until smone prees on esc|space
   
    exit: ;| end the game
   mov ax, 4c00h
   int 21h 
END start