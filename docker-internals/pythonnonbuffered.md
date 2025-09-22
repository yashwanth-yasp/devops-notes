---
date: 2025-09-17
tags:
  - ust
  - devops
  - docker
  - python
---
Setting the environment variable `PYTHONUNBUFFERED=1` forces the Python interpreter to write data directly to the standard output (`stdout`) and standard error (`stderr`) streams without buffering it first.

---

## The Problem: I/O Buffering

By default, to improve performance, Python uses **I/O buffering**. Instead of sending every single character or line to the output stream the moment it's generated, Python collects it in a temporary storage area called a buffer. It only "flushes" (sends) this buffer to the final destination (like your terminal or a log file) when:

- The buffer is full.
    
- A specific command to flush is issued (e.g., `file.flush()`).
    
- The program exits.
    

Think of it like writing a letter. Instead of running to the mailbox after every sentence (unbuffered), you write the whole letter first and then take it to the mailbox all at once (buffered). It's much more efficient. 📝

---

## Why This Is an Issue in Containers

This efficiency becomes a problem when running Python applications inside containers (like with Docker). Container logging systems work by capturing the `stdout` and `stderr` streams from the running application.

If Python is buffering its output, crucial information like `print()` statements, progress updates, or error messages will get stuck in the buffer inside the container. You won't see them in your `docker logs` until the buffer is flushed, which might not happen until the application crashes or finishes. This makes real-time monitoring and debugging nearly impossible.

---

## The Solution: `PYTHONUNBUFFERED=1`

By setting `ENV PYTHONUNBUFFERED=1` in a Dockerfile, you tell the Python interpreter to switch to an unbuffered mode.

In this mode, any output sent to `stdout` or `stderr` is written **immediately**.

This ensures that when your application prints a log or an error, it shows up instantly in the container's logs, allowing you to see exactly what's happening, when it's happening.