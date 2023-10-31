# Cairo Basecamp 2: Cairo

Starknet:

- Starknet was built using Cairo
- Instead of having all the participants of the network to verify all user interactions, only one node, called the prover, executes the programs and generates proofs that the computations were done correctly.
- These proofs are then verified by an Ethereum smart contract, requiring significantly less computational power compared to executing the interactions themselves.
- While Cairo's execution by the prover can lead to some performance overhead, it's not the primary optimization area. Verification, designed to be cost-effective and aided by concepts like non-determinism, enables quick and efficient checks, offering unique advantages to improve performance further.

### Scarb:

- scarb is the config file in any cairo project.
- If you started a project that doesn’t use Scarb, as we did with the “Hello, world!” project, you can convert it to a project that does use Scarb. Move the project code into the src directory and create an appropriate `Scarb.toml` file.
- commands
  - **`scarb build` —> compile**
  - **`cairo-run <PATH>` —> run**
    - This should point to the lib (i.e. cairo-run src/lib.cairo)
    - cairo-run --single-file src/lib.cairo
  - **`scarb cairo-test` —> test**
  - **`scarb new <dir_name>`** —> create new directory

### Variables:

- let mut x = 6 —> the mut keyword creates a mutable variable
  - allows x to be changed without let keyword
- Constants: generally declared as a global variable for hard coded values
- shadowing: in cairo you can declare a new variable with the same name as a previous variable as long you use let.
  - Another distinction between `mut` and shadowing is that when we use the `let` keyword again, we are effectively creating a new variable, which allows us to change the type of the value while reusing the same name.
- Variable Types
  - Felt = a field element (can be a number and a string)
  - Integer
    | Length | Unsigned |
    | ------- | -------- |
    | 8-bit | u8 |
    | 16-bit | u16 |
    | 32-bit | u32 |
    | 64-bit | u64 |
    | 128-bit | u128 |
    | 256-bit | u256 |
    | 32-bit | usize |
    > It is highly recommended for programmers to use the integer types instead of the `felt252` type whenever possible, as the `integer` types come with added security features that provide extra protection against potential vulnerabilities in the code, such as overflow checks.
  - Booleans
  - Tuple : array
    - can be destructured
    ```
    let tup = (500, 6, true);
    let (x, y, z) = tup;
    ```
    - `let (x, y): (felt252, felt252) = (2, 3);`

### Syntax:

- to define a variable: let <variableName>: <variableType> = <variableValue>;
  - `let x: felt252 = 3;`
  - `let x = 5_u128` —> also possible. 5 is the integer
- to change a variable type:
  - `var.into()`
  - `let my_u8: u8 = 2
let my_u16: u16 = **my_u8.into();**`

### Statements and expressions:

- Function bodies are made up of a series of statements optionally ending in an expression. So far, the functions we’ve covered haven’t included an ending expression, but you have seen an expression as part of a statement. Because Cairo is an expression-based language, this is an important distinction to understand. Other languages don’t have the same distinctions, so let’s look at what statements and expressions are and how their differences affect the bodies of functions.
  - **Statements** are instructions that perform some action and do not return a value.
  - **Expressions** evaluate to a resultant value. Let’s look at some examples.
- Expressions evaluate to a value and make up most of the rest of the code that you’ll write in Cairo. Consider a math operation, such as `5 + 6`, which is an expression that evaluates to the value `11`. Expressions can be part of statements.

```rust
use debug::PrintTrait;
fn main() {
let y = {  -> statement
		let x = 3; -> expression
		x + 1 -> expression
		};
y.print();  -> statement
}
```

- Expressions do not have a semicolon at the end.

### **Functions with Return Values**

Functions can return values to the code that calls them. We don’t name return values, but we must declare their type after an arrow (`->`). In Cairo, the return value of the function is synonymous with the value of the final expression in the block of the body of a function. You can return early from a function by using the `return` keyword and specifying a value, but most functions return the last expression implicitly. Here’s an example of a function that returns a value:

```rust

use debug::PrintTrait;

fn five() -> u32 {
    5
}

fn main() {
    let x = five();
    x.print();
}
```

### Ifs & Loops

```rust

use debug::PrintTrait;`

fn main() {
	let mut i: usize = 0;
	loop {
		if i > 10 {
		break;
		}
		'again'.print();
		i += 1;
		}
}
```

### Arrays

creating an array:

```rust
use array::ArrayTrait;

fn main() {
let mut a = ArrayTrait::new();
a.append(0);
a.append(1);
a.append(2);
}
```

arrays methods:

- `array.append(value);` → adds value to array
- `array.at(index);` → returns value
- `array.get(index);` → returns value
  In summary, use `at` when you want to panic on out-of-bounds access attempts, and use `get` when you prefer to handle such cases gracefully without panicking.
- `array.pop_front();` → removes the value at the front
- `array.span();` → create a span of an array. `Span` is a struct that represents a snapshot of an `Array`.
