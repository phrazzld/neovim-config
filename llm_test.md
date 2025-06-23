# LLM Plugin Test File

## Test Case: Multi-line Selection with Code Blocks

Please select the following multi-line content including the code block:

This is a description of a Python function that:
- Takes two parameters
- Performs some calculation
- Returns a result

```python
def calculate_sum(a, b):
    """Calculate the sum of two numbers."""
    result = a + b
    return result
```

The function above is a simple example of how to add two numbers in Python.

> Okay, that's a great, clear description of the provided Python function. You've correctly identified its key features:
>
> *   **Takes two parameters:** `a` and `b`.
> *   **Performs a calculation:** Addition (`a + b`).
> *   **Returns a result:** The calculated sum.
>
> The docstring ("Calculate the sum of two numbers.") also effectively explains the function's purpose.  It's a well-written and concise description of the function's functionality.
>

---

## Empty Selection Test Cases:

### Test Case 1: No Visual Selection
1. **Position cursor** on any line (but don't select anything)
2. **Run command directly**: `:LLMQuery`
3. **Expected**: Warning notification "No text selected"

### Test Case 2: Empty Visual Selection (Whitespace Only)
1. **Select only whitespace** (spaces, tabs, or empty lines)
2. **Press `<leader>ll`**
3. **Expected**: Warning notification "No text selected"

### Test Case 3: Single Character Selection
1. **Position cursor** on a letter character
2. **Enter visual mode** (`v`) then **exit** (`<Esc>`) immediately
3. **Run**: `:LLMQuery`
4. **Expected**: Single character sent to LLM (this is correct Vim behavior - visual marks persist)

---

## Ollama Error Handling Test:

**⚠️ IMPORTANT: This test temporarily stops Ollama service**

### Test Procedure:

1. **Stop Ollama service**:
   ```bash
   # Stop Ollama (will restart automatically or can be restarted manually)
   pkill -f "ollama serve"
   ```

2. **Verify Ollama is stopped**:
   ```bash
   curl -s http://localhost:11434/api/tags --connect-timeout 2
   # Should show "Connection refused" or timeout
   ```

3. **Test error handling in Neovim**:
   - Select some text in the test file
   - Press `<leader>ll`
   - **Expected**: "LLM request failed (exit code: 7)" (curl connection failed)

4. **Restart Ollama** (if it doesn't auto-restart):
   ```bash
   # Option 1: Restart the app
   open -a Ollama

   # Option 2: Manual restart
   ollama serve
   ```

5. **Verify restoration**:
   ```bash
   curl -s http://localhost:11434/api/tags
   # Should show models list again
   ```

### Expected Error Behaviors:
- **When Ollama stopped**: "LLM request failed (exit code: 7)" (connection refused)
- **After restart**: May timeout on first request "LLM request failed (exit code: 28)" due to model loading
- **Second attempt**: Should work normally (model already loaded)
- **No partial responses**: Clean failure, no text insertion on error

### Notes:
- **Exit code 7**: Connection refused (Ollama not running)
- **Exit code 28**: Timeout (first request after restart may be slow due to model loading)
- **Subsequent requests**: Should be fast (~1-3 seconds)

---

## Network Timeout Test:

**Purpose**: Verify plugin handles network timeouts gracefully

### Test Procedure:

1. **Set very low timeout** in Neovim:
   ```vim
   :lua require("user.llm").config.timeout = 2000
   ```
   (Sets 2-second timeout instead of default 30 seconds)

2. **Prepare complex prompt**:
   Select this text (designed to take longer than 2 seconds):

   "Write a comprehensive 500-word essay about the complete history of computer programming languages, including details about assembly language, FORTRAN, COBOL, C, C++, Java, Python, JavaScript, and modern languages like Rust and Go. Include specific examples of code syntax and discuss the evolution of programming paradigms from procedural to object-oriented to functional programming."

3. **Test timeout behavior**:
   - Select the complex prompt text above
   - Press `<leader>ll`
   - **Expected**: "LLM request failed (exit code: 28)" after ~2 seconds

4. **Restore normal timeout**:
   ```vim
   :lua require("user.llm").config.timeout = 30000
   ```

5. **Verify restoration**:
   - Select some simple text like "What is 2+2?"

   - Press `<leader>ll`
   - **Expected**: Normal response within 30 seconds

### Expected Behaviors:
- **Fast timeout**: Error appears within 2-3 seconds (not 30+ seconds)
- **Proper error code**: Exit code 28 (curl timeout)
- **No hanging**: UI remains responsive
- **Clean recovery**: Works normally after timeout restoration

---

## Large Response Performance Test:

**Purpose**: Verify plugin handles large responses (>100 lines) efficiently

### Test Procedure:

1. **Increase timeout for large responses**:
   ```vim
   :lua require("user.llm").config.timeout = 120000
   ```
   (Sets 2-minute timeout for complex responses)

2. **Prepare large response prompt**:
   Select this prompt designed to generate 100+ lines:

   "Please provide a comprehensive, detailed list of exactly 50 different programming concepts, with each concept explained in 2-3 lines. Include concepts from: data structures (arrays, linked lists, hash tables, trees, graphs), algorithms (sorting, searching, dynamic programming), programming paradigms (OOP, functional programming, procedural), software engineering (design patterns, testing, version control), and computer science fundamentals (complexity analysis, recursion, concurrency). Format each as a numbered list item with the concept name in bold followed by the explanation."

> Okay, here’s a comprehensive list of 50 programming concepts, broken down into categories and explained as requested.
>
> 1.  **Arrays** - Arrays are contiguous blocks of memory used to store a collection of elements of the same data type. They offer efficient access to elements based on their index.
>
> 2.  **Linked Lists** - Linked lists are data structures where elements (nodes) are linked together sequentially, not necessarily in contiguous memory locations. They provide flexibility in insertion and deletion.
>
> 3.  **Hash Tables** - Hash tables (dictionaries) use a hash function to map keys to their corresponding values, enabling fast key-based lookups. Collision handling is a key aspect of their design.
>
> 4.  **Trees** - Trees are hierarchical data structures with a root node and child nodes, representing relationships and organizational structures. Binary trees are particularly common.
>
> 5.  **Graphs** - Graphs consist of nodes (vertices) connected by edges, representing relationships and networks. They are used to model complex systems like social networks.
>
> 6.  **Sorting Algorithms** - Algorithms like Bubble Sort, Merge Sort, and Quick Sort are used to arrange data in a specific order (ascending or descending). Efficiency varies based on data size.
>
> 7.  **Searching Algorithms** - Algorithms like Linear Search and Binary Search are designed to locate specific elements within a data structure. Binary search requires sorted data.
>
> 8.  **Dynamic Programming** - A technique that solves complex problems by breaking them down into smaller, overlapping subproblems and storing their solutions to avoid redundant calculations.
>
> 9.  **Object-Oriented Programming (OOP)** - A programming paradigm centered around “objects” which combine data (attributes) and code that operates on that data (methods). Key principles include encapsulation, inheritance, and polymorphism.
>
> 10. **Classes** - Templates for creating objects, defining the attributes and methods that objects of that type will possess.
>
> 11. **Encapsulation** - Bundling data and methods that operate on that data within a class, protecting the data from outside access and misuse.
>
> 12. **Inheritance** -  Allows a new class (child) to inherit properties and methods from an existing class (parent), promoting code reuse and creating hierarchical relationships.
>
> 13. **Polymorphism** -  The ability of an object to take on many forms, allowing the same method call to behave differently depending on the object's type.
>
> 14. **Functional Programming** - A programming paradigm that emphasizes using pure functions and avoiding side effects, promoting immutability and code clarity.
>
> 15. **Pure Functions** - Functions that always return the same output for the same input and have no side effects (they don't modify external state).
>
> 16. **Immutability** -  Data remains unchanged after it’s created, preventing unintended modifications and making code easier to reason about.
>
> 17. **Recursion** - A programming technique where a function calls itself to solve smaller subproblems until a base case is reached.
>
> 18. **Stack Overflow** - An error that occurs when a recursive function calls itself too many times, exceeding the available stack space.
>
> 19. **Concurrency** -  The ability of a program to execute multiple tasks seemingly simultaneously, often achieved through threads or processes.
>
> 20. **Threads** - Lightweight processes that share the same memory space, enabling efficient parallel execution within a single program.
>
> 21. **Processes** - Independent programs with their own memory space, providing true parallelism but potentially higher overhead.
>
> 22. **Deadlock** - A situation where two or more processes are blocked indefinitely, waiting for each other to release resources.
>
> 23. **Race Condition** - An error where the outcome of a program depends on the unpredictable order in which multiple threads access shared resources.
>
> 24. **Design Patterns** - Reusable solutions to common software design problems, providing a blueprint for structuring code and promoting maintainability. (e.g., Singleton, Factory)
>
> 25. **Singleton Pattern** - Ensures only one instance of a class exists, providing a centralized control point.
>
> 26. **Factory Method Pattern** - Defines an interface for creating objects but lets subclasses decide which class to instantiate, promoting flexibility.
>
> 27. **Testing** - The process of verifying that software functions correctly, involving various techniques like unit testing, integration testing, and system testing.
>
> 28. **Unit Testing** - Testing individual components (units) of code in isolation.
>
> 29. **Integration Testing** - Testing the interaction between different components or modules of a system.
>
> 30. **Version Control (Git)** - A system for tracking changes to code over time, allowing developers to collaborate effectively and revert to previous versions.
>
> 31. **Branching** -  Creating separate lines of development from a main codebase, allowing for experimentation and parallel development.
>
> 32. **Merging** - Combining changes from different branches back into a single branch.
>
> 33. **Code Complexity** –  A measure of how difficult a piece of code is to understand, maintain, and modify. High complexity often indicates potential for errors.
>
> 34. **Big O Notation** –  A mathematical notation used to describe the efficiency of algorithms, focusing on how the runtime or space requirements grow as the input size increases.
>
> 35. **Time Complexity** - The amount of time an algorithm takes to run, often expressed using Big O notation.
>
> 36. **Space Complexity** - The amount of memory an algorithm requires, also expressed using Big O notation.
>
> 37. **Recursion Termination** - Ensuring a recursive function eventually stops calling itself, preventing an infinite loop.
>
> 38. **Dynamic Memory Allocation** -  The process of requesting and releasing memory during program execution, allowing flexibility in handling varying data sizes.
>
> 39. **Garbage Collection** -  An automatic process that reclaims memory occupied by objects that are no longer in use, preventing memory leaks.
>
> 40. **Data Structures & Algorithms (DSA)** –  The cornerstone of efficient programming, choosing the right data structure and algorithm can dramatically impact performance.
>
> 41. **Data Structures - Queues** - First-In, First-Out (FIFO) data structure for managing tasks or items.
>
> 42. **Data Structures - Stacks** - Last-In, First-Out (LIFO) data structure.
>
> 43. **Abstract Data Type (ADT)** - A conceptual model of a data type that defines its behavior without specifying its implementation details.
>
> 44. **Compiler** – Translates source code into machine code that a computer can directly execute.
>
> 45. **Interpreter** – Executes source code directly, without first translating it into machine code.
>
> 46. **API (Application Programming Interface)** - A set of rules and specifications that define how software components interact.
>
> 47. **Event-Driven Programming** – Programming model where execution is triggered by events (e.g., user input, timer expiry).
>
> 48. **Lambda Expressions (Anonymous Functions)** - Small, unnamed functions that can be passed as arguments to other functions, commonly used in functional programming.
>
> 49. **Memory Leaks** – Occur when memory is allocated but never released, leading to performance degradation or program crashes.
>
> 50. **Side Effects** – When a function modifies state outside of its own scope.  Functional programming emphasizes avoiding side effects.
>
>
> I hope this comprehensive list is helpful! Let me know if you’d like me to elaborate on any specific concept.

3. **Execute test**:
   - Select the prompt above
   - Press `<leader>ll`
   - **Note the time**: Should complete within 60-120 seconds

4. **Verify results**:
   - **Response length**: Should be 100+ lines of content
   - **Formatting**: All lines properly blockquoted with `> `
   - **Buffer performance**: Smooth insertion, no lag or freezing
   - **Content quality**: Well-structured numbered list with explanations

### Expected Behaviors:
- **Large response handling**: 100+ lines processed without issues
- **Proper formatting**: Every line correctly prefixed with `> `
- **Performance**: Insertion completes smoothly without UI freezing
- **Memory efficiency**: No memory leaks or excessive resource usage
- **Visual quality**: Large blockquoted content displays properly

5. **Restore normal timeout** (optional):
   ```vim
   :lua require("user.llm").config.timeout = 30000
   ```

### Performance Benchmarks:
- **Response time**: 60-120 seconds (depending on model and hardware)
- **Insertion speed**: Large content appears quickly after "Response received"
- **UI responsiveness**: Neovim remains interactive throughout process
- **Scrolling**: Large inserted content scrolls smoothly

---

## Test Instructions:

1. **Select the multi-line content above** (from "This is a description..." through "...numbers in Python.")
2. **Press `<leader>ll`** to trigger the LLM query
3. **Verify the response** appears as blockquoted text with proper formatting
4. **Check that newlines are preserved** in both the prompt and response

## Expected Behavior:

- Multi-line text should be extracted correctly with newlines preserved
- Code blocks should be included in the selection
- LLM response should appear with proper blockquote formatting
- A blank line should separate the original text from the response
