# Elevator

Elevators are complex electromechanical systems that operate under strict timing, reliability, and safety requirements. In real-world applications, they must be able to handle concurrent input signals, make rapid control decisions, and manage user requests based on predefined priority schemes. This makes them ideal candidates for learning about embedded control systems.

This project centers on the development and implementation of a simplified elevator control system using the Zynq-7000-based ZedBoard. The primary goal is to leverage the capabilities of FPGA technology to simulate and realize real-time embedded control systems. Through the application of finite state machines (FSMs), VHDL, and digital interfacing, the project aims to build a functional prototype that represents a three-floor elevator system.

This project also served as a testbed for learning how to transition from theoretical digital design to practical deployment on physical FPGA hardware. Pin assignments, clock management, debouncing of mechanical switches, and synchronization of logic blocks have been considered. These real-world challenges provided deep insights into the workflows of embedded systems engineering. The aim was to not just make an elevator, but to make a deterministic, modular, and extensible design platform that could form the basis for more complex automation systems in the future.

To ensure high reliability and precision, the control logic was designed and tested extensively using Xilinx Vivado, a modern toolset for FPGA development. The synthesized circuit underwent rigorous simulation to meet timing and logic criteria before actual hardware implementation. The system incorporates debounce mechanisms to account for mechanical inconsistencies in button presses and is structured with a modular architecture that promotes scalability, easier debugging, and potential future extensions.

The result is a fully functional, responsive, and efficient elevator prototype that validates the practical applicability of FPGA-based control logic in real-world-inspired embedded system design.

The Gantt chart was used to showcase the project timeline and to make sure that the team is in time to finalize the project within the given timeframe. It can be seen in the following picture:

<img width="2425" height="510" alt="Gantt chart" src="https://github.com/user-attachments/assets/0eb8e202-9cd0-467d-869a-3a44b248a342" />

There was a fixed budget from the university of 1k DKK to order components necessary for the PCB and enclosure. As it can be seen in the following pictures, there were two rounds of ordering, and we used approximately 800 DKK.

<img width="1105" height="183" alt="components list 1" src="https://github.com/user-attachments/assets/2cda000a-711e-4620-af0a-d4333d90952f" />
<img width="848" height="101" alt="components list 2" src="https://github.com/user-attachments/assets/b6dbaf7a-da82-4e6c-9b18-4ac912f4b70a" />

For designing the PCB, KiCad was used and we generated a schematic and a PCB layout:

<img width="1820" height="1252" alt="PCB schematic" src="https://github.com/user-attachments/assets/8685328c-fad8-4ee5-80a8-a391c308e722" />
<img width="1855" height="1279" alt="PCB layout" src="https://github.com/user-attachments/assets/c81b54ec-c1f8-4729-b871-97caff80ccd1" />

One requirement for the project was to use an FPGA board, with the help of Vivado, using VHDL. Therefore, the code can be analysed in the "VHDL" folder in this repository. In addition, because of the complexity of the VHDL code, we wanted to have a backup solution, and for this, we decided to use an ESP32, which was programmed in Arduino IDE, and the code can be seen in this repository. Furthermore, the schematic of the compiled and synthesised VHDL code is:

<img width="1706" height="703" alt="VHDL schematic" src="https://github.com/user-attachments/assets/adeeb31e-d74a-417d-a9f2-cad49994f6bf" />
