Project Overview

This project implements SECDED (Single Error Correction, Double Error Detection) using extended Hamming code in Verilog HDL.
The design protects 8-bit data by encoding it into a 13-bit codeword, enabling:

✔️ Automatic correction of single-bit errors

✔️ Reliable detection of double-bit errors

✔️ Detection and correction of overall parity bit errors

The project was developed as a final-semester RTL design project and verified using simulation waveforms.

🧮 Codeword Structure
Component	Bits
Data bits	8
Hamming parity bits	4
Overall parity bit	1
Total	13 bits

Parity bit positions (1-indexed):
1, 2, 4, 8
Overall parity bit:
13

⚙️ Functional Description
✍️ Write Operation

Input data (inputData[7:0]) is placed into non-parity positions

Hamming parity bits are computed using positional masking

Overall parity is computed by XORing all 12 bits

Encoded 13-bit codeword is stored in memory

📖 Read Operation

Stored codeword is read

Optional error injection (single-bit or double-bit) can be applied

Parity bits are recomputed

Syndrome and overall parity are evaluated

Error type is classified and handled accordingly

🚨 Error Classification Logic
Syndrome	Overall Parity	Condition
0	0	No Error
≠ 0	1	Single-bit error (correctable)
0	1	Overall parity bit error
≠ 0	0	Double-bit error (detected, not correctable)
🧪 Error Injection Support

The design supports controlled fault injection for verification:

Single-bit error injection

Double-bit error injection

User-selectable error locations

This allows validation of all SECDED cases through simulation.

📊 Outputs & Status Flags

noError – No fault detected

oneBitError – Single-bit error corrected

parityError – Overall parity bit error

twoBitError – Double-bit error detected

outputSyndrome – Error location (if applicable)

outputCorrectData – Corrected data output

outputCorruptedData – Data when correction is not possible

🔍 Key Technical Highlights

Extended Hamming Code (SECDED)

Bit-position–based parity computation

Syndrome decoding for error localization

Clean separation of:

Encoding logic

Memory write

Read & error analysis

Fully synthesizable RTL design

🛠 Tools & Technologies

Language: Verilog HDL

Simulation: ModelSim / Vivado (or equivalent)

Design Style: RTL, synthesizable

📈 Verification

All SECDED cases verified using simulation waveforms:

No error

Single-bit correction

Parity-only error

Double-bit detection

Screenshots of waveforms are included in the repository.

🚀 Future Improvements

Parameterized data width

Multi-word memory support

FPGA synthesis & on-board testing

Testbench automation

📬 Contact

If you’re interested in the design, theory, or verification approach, feel free to reach out or open an issue.
