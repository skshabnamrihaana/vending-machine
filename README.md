# Vending Machine – Vivado FPGA Project

## 📌 Project Overview

This project implements a **digital vending machine** using **Verilog HDL** and is designed and simulated using **Xilinx Vivado**.

The vending machine accepts coins, keeps track of the inserted amount, and dispenses a selected product when the required amount is reached. If the user inserts more money than the product price, the machine provides the appropriate change.

The design is implemented using a **Finite State Machine (FSM)**.

---

## 🎯 Objectives

* Design a vending machine using Verilog HDL.
* Implement the control logic using a Finite State Machine.
* Accept different coin denominations.
* Track the total inserted amount.
* Dispense the selected product when sufficient money is inserted.
* Generate change when excess money is inserted.
* Simulate and verify the design using Vivado.

---

## 🛠️ Tools Used

| Tool             | Purpose                                              |
| ---------------- | ---------------------------------------------------- |
| Xilinx Vivado    | RTL design, synthesis, implementation and simulation |
| Verilog HDL      | Hardware description                                 |
| FPGA Board       | Hardware implementation                              |
| Vivado Simulator | Functional simulation                                |

---

## ⚙️ Working Principle

The vending machine operates according to the following sequence:

1. The machine starts in the **IDLE** state.
2. The user selects a product.
3. The user inserts coins.
4. The machine adds the value of each inserted coin to the current balance.
5. If the balance is less than the product price, the machine waits for another coin.
6. If the balance is equal to or greater than the product price:

   * The product is dispensed.
   * Any excess amount is returned as change.
7. After dispensing the product and returning change, the machine returns to the **IDLE** state.

### Example

Assume the product price is **₹10**.

| Inserted Amount | Action                       |
| --------------: | ---------------------------- |
|              ₹2 | Wait for more money          |
|              ₹5 | Wait for more money          |
|             ₹10 | Dispense product             |
|             ₹12 | Dispense product + ₹2 change |
|             ₹15 | Dispense product + ₹5 change |

---

## 🔄 Finite State Machine

The vending machine can be designed using the following FSM states:

```text
              +-------+
              | IDLE  |
              +---+---+
                  |
             Coin inserted
                  |
                  v
          +---------------+
          | CHECK_AMOUNT  |
          +-------+-------+
                  |
        +---------+---------+
        |                   |
   Amount < Price      Amount >= Price
        |                   |
        v                   v
 +-------------+      +-------------+
 | WAIT_COINS  |      |   DISPENSE  |
 +------+------+      +------+------+
        |                    |
        | Coin inserted      |
        +--------------------+
                             |
                             v
                       +-------------+
                       | RETURN      |
                       |   CHANGE    |
                       +------+------+
                              |
                              v
                         +---------+
                         |  IDLE   |
                         +---------+
```

---

## 📥 Inputs

The exact inputs depend on the Verilog implementation. A typical implementation may contain:

| Signal    | Description                |
| --------- | -------------------------- |
| `clk`     | System clock               |
| `reset`   | Resets the vending machine |
| `coin_2`  | ₹2 coin input              |
| `coin_5`  | ₹5 coin input              |
| `coin_10` | ₹10 coin input             |
| `select`  | Product selection signal   |

---

## 📤 Outputs

| Signal    | Description                             |
| --------- | --------------------------------------- |
| `product` | Indicates that the product is dispensed |
| `change`  | Indicates returned change               |
| `balance` | Current amount inserted                 |
| `done`    | Indicates completion of the transaction |

---

## 📁 Project Structure

A typical Vivado project can be organized as:

```text
vending_machine/
│
├── README.md
│
├── rtl/
│   └── vending_machine.v
│
├── sim/
│   └── vending_machine_tb.v
│
└── constraints/
    └── vending_machine.xdc
```

---

## 💻 Verilog Design

The main RTL module is:

```verilog
module vending_machine (
    input  wire       clk,
    input  wire       reset,
    input  wire       coin_2,
    input  wire       coin_5,
    input  wire       coin_10,
    output reg        product,
    output reg [4:0]  change,
    output reg [4:0]  balance
);

    parameter PRICE = 10;

    always @(posedge clk) begin
        if (reset) begin
            balance <= 0;
            product <= 0;
            change  <= 0;
        end
        else begin
            product <= 0;
            change  <= 0;

            // Accept coins
            if (coin_2)
                balance <= balance + 2;
            else if (coin_5)
                balance <= balance + 5;
            else if (coin_10)
                balance <= balance + 10;

            // Dispense product
            if (balance >= PRICE) begin
                product <= 1;
                change  <= balance - PRICE;
                balance <= 0;
            end
        end
    end

endmodule
```

> **Note:** The above code is a basic example. For a robust FPGA implementation, coin insertion and dispensing should generally be handled as separate FSM states, especially if physical push buttons are used.

---

## 🧪 Simulation

A Verilog testbench can be used to verify the vending machine before programming the FPGA.

The simulation should test:

### Test Case 1 – Exact Amount

```text
Insert ₹5
Insert ₹5
Expected:
Product = 1
Change  = ₹0
```

### Test Case 2 – Excess Amount

```text
Insert ₹10
Insert ₹5
Expected:
Product = 1
Change  = ₹5
```

### Test Case 3 – Insufficient Amount

```text
Insert ₹5
Expected:
Product = 0
Change  = ₹0
```

---

## ▶️ Running the Project in Vivado

### 1. Create a New Project

Open **Xilinx Vivado** and select:

```text
Create Project
```

Choose the required FPGA board or device.

### 2. Add Design Sources

Add the Verilog source file:

```text
vending_machine.v
```

### 3. Add Simulation Sources

Add the testbench:

```text
vending_machine_tb.v
```

### 4. Add Constraints

Add the appropriate `.xdc` file for your FPGA board.

Example:

```text
vending_machine.xdc
```

The XDC file maps Verilog signals to FPGA pins.

### 5. Run Simulation

Select:

```text
Flow Navigator
    → Simulation
    → Run Simulation
    → Run Behavioral Simulation
```

Check the waveform for:

* Clock
* Reset
* Coin inputs
* Balance
* Product output
* Change output

### 6. Synthesis

Run:

```text
Run Synthesis
```

Check for RTL and synthesis errors.

### 7. Implementation

Run:

```text
Run Implementation
```

### 8. Generate Bitstream

After successful implementation:

```text
Generate Bitstream
```

### 9. Program FPGA

Connect the FPGA board and open:

```text
Hardware Manager
```

Then:

```text
Open Target
    → Auto Connect
    → Program Device
```

Select the generated `.bit` file and program the FPGA.

---

## 📊 Expected Result

After programming the FPGA, the vending machine should:

* Accept the specified coin inputs.
* Maintain the inserted amount.
* Detect when the required amount has been reached.
* Activate the product output.
* Calculate and return the required change.
* Reset the transaction after dispensing.

---

## 🔧 Possible Improvements

The project can be extended with:

* Multiple product selections.
* Different prices for different products.
* LCD/OLED display for balance and product information.
* Seven-segment display for showing inserted amount.
* Additional coin denominations.
* Coin return/cancel button.
* Product availability detection.
* Button debouncing.
* Clock divider for human-operated inputs.
* Automatic transaction timeout.
* Multiple vending slots.
* Change availability checking.

---

## 📚 Concepts Demonstrated

This project demonstrates several important digital-design concepts:

* Verilog HDL
* Finite State Machines
* Sequential logic
* Combinational logic
* Counters/registers
* Clocked circuits
* FPGA synthesis
* RTL simulation
* Testbench development
* Xilinx Vivado workflow
* XDC pin constraints

---

## 👩‍💻 Author

**Vending Machine FPGA Project**

Developed using **Verilog HDL and Xilinx Vivado**.

---

## 📄 License

This project is intended for **educational and academic purposes**.
