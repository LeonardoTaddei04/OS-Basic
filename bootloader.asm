; bootloader.asm
BITS 16                  ; Modalità reale a 16-bit
ORG 0x7C00               ; BIOS carica il bootloader a 0x7C00

start:
    ; Stampa un messaggio
    mov si, boot_msg      ; Puntatore al messaggio
print_loop:
    lodsb                 ; Carica un carattere da [SI] in AL
    or al, al             ; Controlla se è null terminator
    jz load_kernel        ; Salta se terminatore trovato
    mov ah, 0x0E          ; Funzione BIOS: stampa carattere in AL
    int 0x10              ; Interruzione del BIOS
    jmp print_loop        ; Ripeti il ciclo

load_kernel:
    ; Carica il kernel (settore 2 del disco)
    mov ax, 0x0000        ; Segmento di caricamento: 0x0000
    mov es, ax            ; ES = 0x0000
    mov bx, 0x0600        ; Offset: 0x0600 (dove carichiamo il kernel)
    mov ah, 0x02          ; Funzione BIOS: leggere da disco
    mov al, 1             ; Numero di settori da leggere
    mov ch, 0x00          ; Cilindro
    mov cl, 0x02          ; Settore 2
    mov dh, 0x00          ; Testina
    mov dl, 0x00          ; Disco (0x00 = disco principale)
    int 0x13              ; Interruzione del BIOS
    jc error              ; Salta in caso di errore

    ; Passa il controllo al kernel
    jmp 0x0000:0x0600     ; Salta al kernel caricato in memoria

error:
    ; Stampa un messaggio di errore
    mov si, error_msg
error_loop:
    lodsb
    or al, al
    jz halt
    mov ah, 0x0E
    int 0x10
    jmp error_loop

halt:
    cli                   ; Disabilita interruzioni
    hlt                   ; Arresta la CPU

boot_msg db "Caricamento kernel...", 0
error_msg db "Errore durante il caricamento!", 0

times 510-($-$$) db 0    ; Padding per raggiungere 512 byte
dw 0xAA55                ; Firma di avvio (necessaria)
