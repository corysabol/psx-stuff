alias b := build
alias c := clean

build target: (asm target) (exe target)

asm target:
    @echo 'Assembling {{target}}.s'
    armips {{target}}.s

exe target:
    @echo 'Converting {{target}}.bin to PS-EXE format outfile: {{target}}.ps-exe'
    python3 bin2exe.py {{target}}.bin {{target}}.ps-exe

clean target:
    rm {{target}}.bin {{target}}.ps-exe
