// kernel.c
void main() {
    char *video_memory = (char *)0xB8000; // Indirizzo della memoria video in modalità reale
    const char *message = "Benvenuto nel mio OS!";
    int i = 0;

    while (message[i] != '\0') {
        video_memory[i * 2] = message[i];      // Carattere
        video_memory[i * 2 + 1] = 0x07;       // Attributo (colore grigio su nero)
        i++;
    }

    while (1); // Ciclo infinito per bloccare il kernel
}
