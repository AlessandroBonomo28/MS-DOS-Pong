# MS-DOS Pong
Pong written in assembly language for processor architecture 8086 <br>
- Click [here](https://www.youtube.com/watch?v=Rijj1_BilIo&t=119s&ab_channel=Idostuff) to see the demo on YouTube.

I have developed the well-known video game Pong using assembly language and played it on MS-DOS in a virtual machine. To develop the game, I utilized emu8086 as the development environment. After extensively testing the code, I compiled it and produced an executable file, which I saved onto a virtual floppy disk. To run the game, I started MS-DOS in VMware and mounted the floppy disk. Finally, I was able to successfully run Pong.
                Pong is a classic arcade game that was first released in 1972 by Atari. It involves two paddles moving up and down on opposite sides of the screen, with the objective being to hit a ball back and forth between them without missing. The game has been remade countless times since its original release and is still enjoyed by gamers today.
                Developing Pong using assembly language was a challenging but rewarding experience. Assembly language is a low-level programming language that requires a deep understanding of the computer's hardware and memory management. By using emu8086 as the development environment, I was able to simulate the hardware and test my code efficiently.
                Compiling the code and producing an executable file was a crucial step in the development process. The executable file contained the compiled code that the computer could run, allowing me to play the game without having to type out the code each time.
                Overall, developing and playing Pong on MS-DOS in a virtual machine was a fun and educational experience. It allowed me to gain a deeper understanding of assembly language programming, hardware simulation, and operating systems.

# How to play
1) Clone git repository
2) Setup MS-DOS https://github.com/AlessandroBonomo28/MS-DOS-setup
3) Load floppy1 into the MS-DOS virtual machine.
4) Enter 'A:' to mount the floppy
5) Enter 'pong' to execute the .com file
# How to compile your own assembly programs and run them on MS-DOS
1) Clone git repository
2) Setup MS-DOS https://github.com/AlessandroBonomo28/MS-DOS-setup
3) Install emu8086 to compile your assembly program into a .com executable https://github.com/AlessandroBonomo28/emu8086
4) Install https://winimage.com/ to transfer your .com executable into a virtual floppy disk
4) Write your program in emu8086
5) Compile your program and you will get a .com file
6) I have provided you a 'floppy1' virtual floppy disk. You can use winimage to inject the .com file into the floppy.
7) Once your .com is in the floppy you can enter the floppy into the virtual msdos machine
8) Mount the floppy with 'A:'
9) Enter 'dir' to check the content of the floppy
10) Enter the name of your .com file and MS-DOS will execute it

## Screenshots
![pong2](https://user-images.githubusercontent.com/75626033/217205357-4bc75dba-ef0b-437b-a428-29d2d7d8b4aa.PNG)
![pong3](https://user-images.githubusercontent.com/75626033/217205361-45b61e5e-bd35-4520-b32a-82e36ba539a9.PNG)
![pong4](https://user-images.githubusercontent.com/75626033/217205365-3040fbf4-1eaf-4c03-a421-c2d2e038e78c.PNG)
