Below is a **clean, professional, GitHub-ready `README.md`** formatted in proper Markdown. You can copy-paste this directly into your repository.

---

# 🧠 SECDED Implementation Using Extended Hamming Code (Verilog HDL)

This project implements **SECDED (Single Error Correction, Double Error Detection)** using an **Extended Hamming Code** in **Verilog HDL**.
The design protects **8-bit data** by encoding it into a **13-bit codeword**, enabling robust fault tolerance in digital systems.

This project was developed as a **final-semester RTL design project** and verified through **simulation waveforms**.

---

## ✨ Features

✔️ Automatic **single-bit error correction**
✔️ Reliable **double-bit error detection**
✔️ Detection and correction of **overall parity bit errors**
✔️ Built-in **error injection** for verification
✔️ Fully **synthesizable RTL design**

---

## 🧮 Codeword Structure

| Component           | Bits   |
| ------------------- | ------ |
| Data bits           | 8      |
| Hamming parity bits | 4      |
| Overall parity bit  | 1      |
| **Total**           | **13** |

### Parity Bit Positions (1-indexed)

* **Hamming parity bits:** `1, 2, 4, 8`
* **Overall parity bit:** `13`

---

## ⚙️ Functional Description

### ✍️ Write Operation

* Input data `inputData[7:0]` is placed into non-parity positions
* Hamming parity bits are computed using **positional masking**
* Overall parity is computed by XORing all **12 bits**
* The encoded **13-bit codeword** is stored in memory

---

### 📖 Read Operation

* Stored codeword is read from memory
* Optional **error injection** (single-bit or double-bit) may be applied
* Parity bits are recomputed
* **Syndrome** and **overall parity** are evaluated
* Error type is classified and handled accordingly

---

## 🚨 Error Classification Logic

| Syndrome | Overall Parity | Condition                              |
| -------: | :------------: | -------------------------------------- |
|        0 |        0       | No error                               |
|      ≠ 0 |        1       | Single-bit error (correctable)         |
|        0 |        1       | Overall parity bit error               |
|      ≠ 0 |        0       | Double-bit error (detected, not fixed) |

---

## 🧪 Error Injection Support

The design includes **controlled fault injection** to validate all SECDED cases during simulation:

* Single-bit error injection
* Double-bit error injection
* User-selectable error locations

This allows complete verification of SECDED behavior.

---

## 📊 Outputs & Status Flags

| Signal Name           | Description                                 |
| --------------------- | ------------------------------------------- |
| `noError`             | No fault detected                           |
| `oneBitError`         | Single-bit error corrected                  |
| `parityError`         | Overall parity bit error                    |
| `twoBitError`         | Double-bit error detected                   |
| `outputSyndrome`      | Error location (if applicable)              |
| `outputCorrectData`   | Corrected data output                       |
| `outputCorruptedData` | Output data when correction is not possible |

---

## 🔍 Key Technical Highlights

* Extended Hamming Code (SECDED)
* Bit-position-based parity computation
* Syndrome decoding for error localization
* Clean separation of:

  * Encoding logic
  * Memory write
  * Read & error analysis
* Fully synthesizable **RTL design**

---

## 🛠 Tools & Technologies

* **Language:** Verilog HDL
* **Simulation:** ModelSim / Vivado (or equivalent)
* **Design Style:** RTL, synthesizable

---

## 📈 Verification

All SECDED scenarios were verified using simulation waveforms:

✔️ No error
✔️ Single-bit error correction
✔️ Parity-only error
✔️ Double-bit error detection

📸 Screenshots of simulation waveforms are included in the repository.

---

## 🚀 Future Improvements

* Parameterized data width
* Multi-word memory support
* FPGA synthesis & on-board testing
* Automated testbench generation

---

## 📬 Contact

If you’re interested in the **design**, **theory**, or **verification approach**, feel free to reach out or open an issue.


Just tell me 👍
