# ImageDefog
This project is an implementation of haze removal algorithm based on dark channel prior.


# Instruction
In the directory 'codes' is the source code and test images of this project, and I generated an executable file in the 'executor' file.

Run the 'Defog.exe' (some time may be needed for initialization). 

Click 'Open File' to load an fog image. 

By sliding the bar to change two key parameters to modify the result of defog.

Click 'Save File' to save the result image into folder '\Test Images\Defogs' by default.

# Example
![fog](https://github.com/xiaokeliu666/ImageDefog/blob/master/defog/executor/Test%20Images/Fogs/07.jpg?raw=true)
![defog](https://github.com/xiaokeliu666/ImageDefog/blob/master/defog/executor/Test%20Images/Defogs/07.jpg?raw=true)


# Reference
He K, Sun J, Tang X. Single image haze removal using dark channel prior. IEEE transactions on pattern analysis and machine intelligence. 2011 Dec;33(12):2341-53.

# Conclusion
This implementation is a simple implementation of the paper. Although there are some details in the paper is omitted but the result is relative acceptable.
