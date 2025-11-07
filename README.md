MIPS Pipeline

Descriere

Acest proiect reprezintă implementarea arhitecturii procesorului MIPS cu pipeline, realizată în limbaj de descriere hardware (HDL). Procesorul este structurat pe cinci etape clasice: IF, ID, EX, MEM și WB, oferind o execuție paralelă eficientă a instrucțiunilor.

Componente principale

Registre de pipeline între fiecare etapă (IF/ID, ID/EX, EX/MEM, MEM/WB)

Module pentru ALU, unitatea de control, registrul de instrucțiuni, memoria de date și banca de registre

Mecanisme de detecție a hazardelor și forwarding pentru corectarea conflictelor de date și control

Fișiere testbench pentru simularea etapelor și verificarea procesorului complet

Scop și utilizare

Proiectul are un scop educațional, vizând aprofundarea conceptelor de arhitectură a calculatoarelor și proiectarea unui procesor MIPS cu execuție în pipeline. Codul poate fi simulat pentru verificare funcțională sau sintetizat pe un FPGA pentru demonstrații practice.
