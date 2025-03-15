`timescale 1ns / 1ps

module prime_no_det(
        input [2:0]a,
        output prime
    );
    //using kmap method or brute force method to detect all
    assign prime = (!a[2]&&a[1])|| (a[2]&&a[0]) || (a[1]&&a[0]); //the third expression can help avoid the static hazard 
endmodule
