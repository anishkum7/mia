import numpy as np
import scipy.linalg as lin
import random

if __name__=="__main__":
     matrix_size = int(input("what is the matrix size?"))
     am_i_done=0
     while(am_i_done==0):
         my_matrix=np.zeros((matrix_size,matrix_size),dtype=complex)
         for r in range(0,matrix_size):
            for c in range(0,matrix_size):
                matrix_real_part= random.uniform(0,2e32)
                matrix_complex_part = random.uniform(0,2e32)
                complexN = complex(matrix_real_part,matrix_complex_part)
                my_matrix[r,c]=complexN
         try:
             my_matrix_inv = lin.inv(my_matrix)

             # What is the desired format to save the output?
             # element wise?
             # np.savetxt("origMatrixA.csv",my_matrix,fmt="%s", delimiter=",")
             # np.savetxt("invMatrixOfA.csv",my_matrix_inv,  fmt="%s",delimiter=",")

             # or real and imaginary separated?
             # np.savetxt("origMatrixA.csv", np.column_stack([my_matrix.real, my_matrix.imag]), delimiter=",")
             # np.savetxt("invMatrixofA.csv", np.column_stack([my_matrix_inv.real, my_matrix_inv.imag]), delimiter=",")
             input = np.append(my_matrix.real.ravel(),my_matrix.imag.ravel()).reshape((2*matrix_size*matrix_size,1))
             input_inv = np.append(my_matrix_inv.real.ravel(),my_matrix_inv.imag.ravel()).reshape((2*matrix_size*matrix_size,1))
             np.savetxt("origMatrixA.csv", input, delimiter=",")
             np.savetxt("invMatrixofA.csv", input_inv, delimiter=",")

             print("matrix creation, inversion successfull... exiting application\n")
             am_i_done=1
         except np.linalg.LinAlgError as ex:
             if ex.args[0] == "singular matrix":
                 print("non invertible matrix encountered... retrying matrix creation\n")
                 print(ex)
             else:
                 print("unknown error encountered... report bug\n")
                 print(ex)
                 am_i_done = 1
         except Exception as ex:
             print("unknown error encountered... report bug\n")
             print(ex)
             am_i_done = 1



