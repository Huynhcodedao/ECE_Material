/*  ECE231

 driver.cpp
 
*/

#include "convolution.h"
//#include "convolution.cpp"

int main(int argc, char *argv[])
{
    double *insequence, *respsequence, *outsignal;  // Declares a pointer of type double for the array
    vector<double> input1, input2;
    double dTemp;
    int arrayLength1 = 0, arrayLength2 = 0;
    ifstream inFile1;    // Declaring input stream for input file
    ifstream inFile2;
    ofstream outFile;  // Declaring output stream for convolution
    CONV func;

    if (argv[1])  { //  Checks if there is a filename on the command line
        inFile1.open(argv[1], ios::in);
        if (!inFile1) {
            cout << "Can't open file " << argv[1] << endl;
            return 1; // Exits program
        } else
        cout << argv[1] << " Opened Successfully" << endl;
    }
    else{
        cout << "No First File Input" << endl;
        return 1;
    }
    if (argv[2])  { //  Checks if there is a second filename on the command line
        inFile2.open(argv[2], ios::in);
        if (!inFile2) {
            cout << "Can't open file " << argv[2] << endl;
            return 1; // Exits program
        } else
        cout << argv[2] <<" Opened Successfully" << endl;
    }
     else{
        cout << "No Second File Input" << endl;
        return 1;
    }
    if (argv[3])  { //  Checks if there is a second filename on the command line
        outFile.open(argv[3]);
        if (!outFile) {
            cout << "Couldn't Create Output " << endl;
            return 1; // Exits program
        } else
        cout << argv[3] <<" Created Successfully" << endl;
    }
     else{
        cout << "No Output File Declared" << endl;
        return 1;
    }

    while (inFile1 >> dTemp)  { // Counts the numbers in the input file
        input1.push_back(dTemp);
        arrayLength1++; // Counter to track the total numbers in the input
    }
    inFile1.close(); // Closes input file


    while (inFile2 >> dTemp)  { // Counts the numbers in the input file
        input2.push_back(dTemp);
        arrayLength2++; // Counter to track the total numbers in the input
    }
    inFile2.close(); // Closes input file
    
    int outsize = (arrayLength1 + arrayLength2 - 1);    
    
    inFile1.open(argv[1], ios::in);  // Reopens input file for reading
    insequence = new double[outsize];  // Dynamically allocates and array to hold the numbers
    for (int i = 0; i < arrayLength1; i++)    {
        inFile1 >> insequence[i];
    }    
    
    inFile2.open(argv[2], ios::in);  // Reopens input file for reading
    respsequence = new double[outsize];  // Dynamically allocates and array to hold the numbers
    for (int i = 0;i < arrayLength2; i++)    {
        inFile2 >> respsequence[i];
    }

    outsignal = new double[outsize];
    
    cout << "\n\narrayLength1 = " << arrayLength1 << "\n\n";
    cout << "arrayLength2 = " << arrayLength2 << "\n\n";
    cout << "outsize = " << outsize << "\n\n";
    
    //Performs convolution and stores in outsignal array
    func.convolutionflip(insequence, arrayLength1, respsequence, arrayLength2, outsignal, outsize);
    // Outputs sorted array to file
    for (int i = 0; i < outsize; i++)    {
        outFile << setiosflags(ios::fixed) << setprecision(5) << outsignal[i] << endl;
    }
    inFile1.close();
    inFile2.close();
    outFile.close();
    delete insequence, respsequence, outsignal;
    return (0);
} // end of driver
