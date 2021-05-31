use16


start:

    ; alors là, il s'agit de placer 4Kio de mémoire de disponible dans la pile du programme
   
    mov ax, 07C0h   ; Normalement 07C0h représente l'adresse mémoire à laquelle le boot loader est crée
    add ax, 288     ; la je pense qu'il ajoute la longeur programme divisée en octet par 16 car le les offset
		    ; sont décallées de 4 bits vers la droite
		   
    mov ss, ax	    ; là, il modifie le pointeur de segment de pile, c-a-d, il définit l'offset
		    ; de la base de la pile. A mon avis il utilise ax comme registe intermédiaire
		    ; parce que l'instruction 'ADD' ne permet pas d'utiliser 'ss' comme opérande
   
    mov sp, 4096    ; là, il met les 4Kio de qu'il désire disponible.
		    ; c'est un peu particulier puisque sur les x86, le pointeur de pile 'ss'
		    ; est décrémenté à chaque PUSH et incrémenté à chaque POP
   
    ; alors, ici, il place l'offset de la base du segment de données (ici, le même que celui du programme)
   
    mov ax, 07C0h   ; il doit remettre l'addresse mémoire du programme, parce qu'il a modifié le contenu de
		    ; 'ax' avec l'instruction 'ADD'
   
    mov ds, ax	    ; il fait ça pour les même raisons qu'il l'a fait pour ss
   
    mov si, text_string  ; il place l'addresse de la chaine 'text_string'
   
    call print_string	 ; il appelle la fonction 'print_string'
   
    call my_test ;Mon test qui ne marche pas :(
   
    jmp $	     ; il fait une boucle infinie. '$' est un pointeur sur l'instruction
		     ; courrante défini par l'assembleur.
   
   
    text_string db 'This is my cool new OS!', 0 ; la chaine qui ca être affichée

my_test:

   ; Liste des interruptions: http://www.gladir.com/LEXIQUE/INTR/INDEX.HTM
   
   ; Mode Graphique
   mov ah, 00h
   mov al, 0Dh
   int 10h
   
   ;Variable a incrémenter
   xor ax,ax

   .boucle1:
   
   ;Incrémentation
   inc al
   
   ;Variable a incrémenter
   mov ah, 1
   
   .boucle2:
   
   ;Incrémentation
   inc ah
   
   ;Placement des coordonnées
   xor cx,cx
   xor dx,dx

   mov cl, al
   mov dl, ah
   
   ;Empilage de eax
   push ax
   
   ;Mise en place de l'affichage pixel
   mov ah, 0Ch
   mov al, dl
   mov bh, 1
   
   Int 10h
   
   ;Dépilage de ax
   pop ax
   
   ;Condition
   cmp ah, 40
   jne .boucle2
   
   cmp al, 25
   jne .boucle1

ret

print_string:	       ; la fonction pour afficher la chaine.
		       ; prend en argument
		       ; SI : l'adresse de la chaine à afficher
   
    mov ah, 0Eh        ; ici, on prépare le registe AH, pour sélectionner
		       ; une fonction de l'interruption 10h
		       ; ici 10h/0Eh, qui doit être une interruption du bios pour afficher
		       ; un caractère, à vérifier (voir la liste d'interruptions de ralph
		       ; brown)
   
   .repeat:

    lodsb	     ; C'est une commande qui est spéciale pour les chaines 'LOaD String Byte'
		     ; a chaque appel, elle charge l'octet à l'addresse 'ds:si' dans le registre 'al'
		     ; puis elle incrémente 'si'
		     
    cmp al, 0	      ; Ici, le programme vérifie si on est pas arrivé à la fin de la chaine à afficher
		     ; c'est à dire que le caractère chargé dans 'al' n'est pas le carctère de fin de chaine
		     ; ('\0')
   
    je .done	     ; si al est égal à 0, on saute à l'étiquette '.done' et on quitte la boucle
   
    int 10h	     ; Lance l'interruption pour afficher le caractère
   
    jmp .repeat 	; Boucle pour récupérer le prochain caractère

.done:

    ret 		 ; Quitte la procédure 'print_string'. c'est l'équivalent du 'GOTO:EOF' en batch
   
   
    times 510-($-$$) db 0    ; Ici, il s'agit de remplir le secteur de la disquette pour que le
    dw 0xAA55		      ; 510ième octet contienne '0xAA55'. C'est la marque utilisée par le
			     ; bios pour déterminer si un média est bootable