       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    HELLOTSO.
       AUTHOR.        STUDENT.

       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
       01 MYNAMEIS PIC X(10).

       PROCEDURE DIVISION.
      *
           DISPLAY "Hello from TSO! I am a COBOL program, who are you?"
           ACCEPT MYNAMEIS
           DISPLAY "Hello, " MYNAMEIS ", and goodbye."
           STOP RUN.

