# Elevator project at SDU
The project was realized by a team of 5 forth semester students at University of Sauthern Denmark (SDU), who study electronics engineering. At the beginning of the semester, we had a meeting, where we distributed the tasks, so each of us had been working on a different part of the project, from enclosure design to PCB design and programming. The final report was a compilation of parts written by each of us about what we worked on. In addition, we had to write the introduction and end.

The Gantt diagram was used to showcase the project timeline and to make sure we as a team are in time to finalize the project within the given timeframe. It can be seen in the following picture:

<img width="2425" height="510" alt="Gantt chart" src="https://github.com/user-attachments/assets/0eb8e202-9cd0-467d-869a-3a44b248a342" />

Regarding components, we had a fixed budget from the university of 1k DKK to order components necessary for the PCB and enclosure. As it can be seen in the following pictures, there were 2 rounds of ordering, and we used approximately 800 DKK out of the total budget of 1000 DKK.

<img width="1105" height="183" alt="components list 1" src="https://github.com/user-attachments/assets/2cda000a-711e-4620-af0a-d4333d90952f" />
<img width="848" height="101" alt="components list 2" src="https://github.com/user-attachments/assets/b6dbaf7a-da82-4e6c-9b18-4ac912f4b70a" />

For designing the PCB, KiCad was used and we generated a schematic and a PCB layout:

<img width="1820" height="1252" alt="PCB schematic" src="https://github.com/user-attachments/assets/8685328c-fad8-4ee5-80a8-a391c308e722" />
<img width="1855" height="1279" alt="PCB layout" src="https://github.com/user-attachments/assets/c81b54ec-c1f8-4729-b871-97caff80ccd1" />

One requirement for the project was to use an FPGA board, with the help of Vivado, using VHDL. Therefore, the code can be analysed in the "VHDL" folder in this repository. In addition, because of the complexity of the VHDL code, we wanted to have a backup solution, and for this, we decided to use an ESP32, which was programmed in Arduino IDE, and the code can be seen in this repository. In addition, the schematic of the compiled and synthesised VHDL code is:

<img width="1706" height="703" alt="VHDL schematic" src="https://github.com/user-attachments/assets/adeeb31e-d74a-417d-a9f2-cad49994f6bf" />
