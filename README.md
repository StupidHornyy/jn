# jn
# jn  Stateless 280-byte x86_64 ASM directory validator for Fedora Linux. Uses raw `sys_stat` and cuts its own ELF Section Header Table to run purely on the stack.  ## Build ```bash make clean &amp;&amp; make -j16 ```  ## Docs See internal blueprints and wrappers (`es`/`rc`/POSIX) inside: 👉 **[READTHIS.pdf](./READTHIS.pdf)**
