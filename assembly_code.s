binary_search:
  addi $sp, $sp, -4 #δημιουργία χώρου στο stack για να αποθηκεύσω το ra
  sw $ra, 0($sp) #αποθηκεύω το ra γιατί αργότερα θα γίνει overwritten
  
  #προετοιμασία των ορισμάτων της binary_search_rec (το 1ο όρισμα -> έτοιμο)
  add $a3, $a2, $zero #περασμα 4ου ορίσματος (key)
  addi $a2, $a1, -1 #περασμα 3ου ορίσματος (Ν-1)
  add $a1, $zero, $zero #περασμα 2ου ορίσματος (0)
  jal binary_search_rec #κλήση συνάρτησης
  
  lw $ra, 0($sp) #επαναφέρουμε return address
  addi $sp, $sp, 4
  jr $ra #γυρίζουμε στον caller

binary_search_rec:
  addi $sp, $sp, -4 #δημιουργία χώρου για το ra
  sw $ra, 0($sp) #αποθήκευση του ra γιατί θα γίνει overwrite από αναδρομές
  
  slt $t0, $a2, $a1 #ορίζω t0 1 αν right<left
  beq $t0, $0, continue_binary_rec #Αν TRUE->continue_1. Αν FALSE->παρακάτω
  addi $v0, $zero, -1 #αν t0 1 τότε v0=-1 (δεν βρέθηκε το στοιχείο)
  j exit #jump στον επίλογο

continue_binary_rec:
  sub $t1, $a2, $a1 #t1=right-left
  srl $t1, $t1, 1 #t1=(right_left)/2
  add $t1, $t1, $a1 #t1 = mid = ((right_left)/2+left)
  sll $t2, $t1, 2 #t2=t1*4 (index στον πίνακα A)

  add $t2, $t2, $a0 #t2=t2+a0(A[0])=&A[mid]
  lw $t2, 0($t2) #βάζουμε στο register t2 την τιμή στην οποία δείχνει
  bne $t2, $a3, else_1_binary_rec #αν $t2(=A[mid])=/=$a3(=key) -> else_1_binary_rec
  add $v0, $0, $t1 #αν t2=a3 => a[t1]=key => return t1
  j exit #jump to epilogue

else_1_binary_rec:
  slt $t3, $a3, $t2 #t3=1 αν key<Α[mid]
  beq $t3, $zero, else_2_binary_rec #αν από πάνω ψευδής -> else

  #αν αληθής τότε αλλάζουμε τα απαραίτητα ορίσματα για αναδρομή (3ο μόνο)
  addi $a2, $t1, -1 #αλλαγη 3ου ορισματος
  
  jal binary_search_rec #καλούμε αναδρομή
  j exit #όταν τελειώσουν οι αναδρομές πήγαινε στον επίλογο

else_2_binary_rec:
  addi $a1, $t1, 1 #αλλαγή 2ου ορίσματος για αναδρομή
  jal binary_search_rec #καλούμε αναδρομή
  j exit #όταν τελειώσουν οι αναδρομές πήγαινε στον επίλογο

exit:
  lw $ra, 0($sp) #επαναφορά της διεύθηνσης επιστροφής
  addi $sp, 4
  jr $ra #γυρίζουμε στην συνάρτηση caller

exponential_search:
  addi $sp, $sp, -4 #δημιουργία χώρου στην στοίβα
  sw $ra, 0($sp) #αποθηκεύω το return address
  addi $t7, $zero, 1 # t7=bound=1

LOOP_EXP:
  slt $t0, $t7, $a1 # t0=1 αν bound<N
  sll $t8, $t7 ,2 #το index του bound t8=t7*4
  add $t1, $a0, $t8 # t1=&A[1]
  lw $t1, 0($t1) # t1=A[1]
  slt $t2, $t1, $a2 # t2=1 αν Α[bound]<key
  and $t0, $t0, $t2 # $t0 = bound<N (=$t0) AND A[bound]<key (=$t2)
  beq $t0, $zero, LOOP_EXP_EXIT #όταν μία από τις δύο συνθήκες σταματήσει να ισχύει τότε βγες από το LOOP
  sll $t7, $t7, 1 #bound=bound*2
  j LOOP_EXP #πίσω στο LOOP

LOOP_EXP_EXIT:
  addi $t3, $a1, -1 #t3=N-1
  slt $t4, $t7, $t3 # $t4=1 αν bound<N-1
  beq $t4, $zero, else_exp # αν ψευδής η συνθήκη πάμε στο else
  #δεν πήγαμε στο else άρα αλλάζουμε τα ορίσματα για αναδρομή
  add $a3, $a2, $zero #4ο όρισμα
  srl $a1, $t9, 1 #2ο όρισμα
  add $a2, $t9, $zero # 3ο όρισμα
  jal binary_search_rec #καλούμε την binary_search_rec
  j exit #όταν γυρίσει πάμε στον επίλογο

else_exp:
  #φτιάχνουμε τα ορίσματα για να καλέσουμε την binary_search_rec
  add $a3, $a2, $zero #4ο όρισμα
  addi $a2, $a1, -1 # 3ο όρισμα
  srl $a1, $t7, 1 #περνάμε ως 2ο όρισμα το bound/2
  jal binary_search_rec #καλούμε την binary_search_rec
  j exit #όταν γυρίσει πάμε στον επίλογο

interpolation_search:
  addi $sp, $sp, 4 #αποθήκευση του ra
  sw $ra, 0($sp)
  addi $t0, $zero, $zero # $t0=low=0
  addi $t1, $a1, -1 # $t1=N-1=up

LOOP_INTER:
  slt $t2, $t1, $t0 # $t2 1 αν low>up
  bne $t2, $zero, inter_exit # αν $t2==0 (δηλαδή αν !(low<up)=>low>=up
  sll $t3, $t0, 2 # $t3=low*4 για προσπελασουμε Α
  add $t3, $t3, $a0 # ο $t3=&Α[low]
  lw $t3, 0($t3) # o $t3=Α[low]
  slt $t4, $a2, $t3 # $t4=1 αν key<A[low]
  sll $t5, $t1, 2 # $t5=up*4 για να προσπελάσουμε τον Α
  add $t5, $t5, $a0 # $t5=&Α[up]
  lw $t5, 0($t5) # $t5=Α[up]
  slt $t6, $t5, $a2 # $t6=1 αν Α[up]<key
  or $t4, $t4, $t6
  beq $t4, $zero, LOOP_INTER _EXIT
  addi $v0, $zero, -1 # return -1
  j exit #πάμε επίλογο

LOOP_INTER _EXIT:
  sub $t7, $t5, $t3 # $t7=A[up]-A[low]
  sub $t4, $a2, $t3 # $t4=key-A[low]
  div $t4, $t7 # το lo είναι το πηλίκο του $t4/$t7
  mflo $t7 # το $t7 είναι το πηλίκο του key-A[low]/=A[up]-A[low]
  sub $t1, $t1, $t0 # $t1 = up-low
  mult $t7, $t1, $t7 # $t7=(up-low)*(key-A[low]/=A[up]-A[low])
  add $t7, $t7, $t0 # $t7=low+(up-low)*(key-A[low]/=A[up]-A[low])=pos
  sll $t8, $t7, 2 # $t8=pos*4 για να προσπελάσουμε τον Α
  add $t8, $t8, $a0 #ο $t8=&Α[pos]
  lw $t8, 0($t8) # ο $t8=Α[pos]
  bne $t8, $a2, else_1_inter #αν Α[pos]!=key => else if
  add $v0, $zero, $t7 # return pos
  j exit

else_1_inter:
  slt $t8, $a2, $t8 # $t8=1 αν key<A[pos]
  beq $t8, $zero, else_2_inter #αν η πάνω συνθήκη ψευδής πάμε στο else μας
  addi $t1, $t7, -1 # βάζουμε στο up το pos-1
  j LOOP_INTER #back to loop

else_2_inter:
  add $t0, $t7, 1 #βάζουμε στο low το pos+1
  j LOOP_INTER #back to loop

inter_exit:
  add $v0, $zero, -1 # return -1
  j exit
