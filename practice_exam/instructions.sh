git clone https://github.com/Ghada-Atef/cka-practice-exams-lab.git  
cd cka-practice-exams-lab  
make lab            # build the three-node cluster  make verify         
# confirm it is ready for Exam 1  Before each exam, apply that exam's state. There is one target per exam: 
make seed-exam1     # apply Exam 1's lab state  
make seed-exam2     # apply Exam 2's lab state  
make seed-exam3     # apply Exam 3's lab
make reset          # return to the clean
make verify # before exam 1
