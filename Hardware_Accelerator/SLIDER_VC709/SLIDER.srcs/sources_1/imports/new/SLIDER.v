`timescale 1ns / 1ps

module SLIDER	#(parameter LENGTH = 200) (
//	clk,
DNA_read,
DNA_ref,    
DNA_MinErrors
//    ,
//    DNA_out,
//    DNA_nsh,
//    DNA_shl_one,
//    DNA_shl_two,
//    DNA_shr_one,
//    DNA_shr_two
);

//localparam LENGTH = 200;   // width of encoded input and output data

localparam GridSize =4;
//input clk;
input [0:LENGTH-1] DNA_read, DNA_ref;
 reg [0:(LENGTH/2)-1] DNA_shl_three, DNA_shl_four, DNA_shl_five, DNA_shr_three, DNA_shr_four, DNA_shr_five;
 reg [0:(LENGTH/2)-1] DNA_nsh, DNA_shl_one, DNA_shl_two, DNA_shr_one, DNA_shr_two;

reg [0:(LENGTH/2)-1] SliderMask;                
output reg [6:0] DNA_MinErrors;

reg [0:LENGTH-1] DNA_1, DNA_2, DNA_3, DNA_4, DNA_5, DNA_6, DNA_7, DNA_8, DNA_9, DNA_10, DNA_11;
integer index, i,GridIndex;

integer ErrorThreshold = 5;
reg [0:2] count, MaxZeros;
reg [0:6] MinEdits;
//////////////////////////////////////////////////////////
//
//                Shifted Hamming Mask (SHM) Calculation
//
//////////////////////////////////////////////////////////

always@(DNA_read or DNA_ref)
begin
    ////////////////////////////////////////////////////////
    //
    //                Hamming Mask for Read & Reference
    //
    ////////////////////////////////////////////////////////
    DNA_1= DNA_ref ^ DNA_read;
    index=0;
    for (i = 0; i < LENGTH; i = i + 2)
    begin
        if(DNA_1[i] || DNA_1[i+1])
            DNA_nsh[index] = 1'b1;            //Bp mismatch
        else
            DNA_nsh[index] = 1'b0;            //Bp match
        index=index+1;
    end   
    
    
    ////////////////////////////////////////////////////////
    //
    //                Hamming Mask for Read<<1 & Reference
    //
    ////////////////////////////////////////////////////////
    DNA_2= DNA_ref ^ (DNA_read<<2);            //shift for 2bits coz each SNP is encoded by two bits
    index=0;
    for (i = 0; i < LENGTH; i = i + 2)
    begin
        if(DNA_2[i] || DNA_2[i+1])
            DNA_shl_one[index] = 1'b1;            //Bp mismatch
        else
            DNA_shl_one[index] = 1'b0;            //Bp match
        index=index+1;
    end
    DNA_shl_one[(LENGTH/2)-1]=1'b1;        //referencce bp mapped to empty bp due to shifting 
    
    ////////////////////////////////////////////////////////
    //
    //                Hamming Mask for Read<<2 & Reference
    //
    ////////////////////////////////////////////////////////
    DNA_3= DNA_ref ^ (DNA_read<<4);            //shift for 4bits coz each SNP is encoded by two bits
    index=0;
    for (i = 0; i < LENGTH; i = i + 2)
    begin
        if(DNA_3[i] || DNA_3[i+1])
            DNA_shl_two[index] = 1'b1;            //Bp mismatch
        else
            DNA_shl_two[index] = 1'b0;            //Bp match
        index=index+1;
    end
    DNA_shl_two[(LENGTH/2)-1]=1'b1;        //referencce bp mapped to empty bp due to shifting 
    DNA_shl_two[(LENGTH/2)-2]=1'b1;        //referencce bp mapped to empty bp due to shifting 
    
    ////////////////////////////////////////////////////////
    //
    //                Hamming Mask for Read<<3 & Reference
    //
    ////////////////////////////////////////////////////////
    DNA_6= DNA_ref ^ (DNA_read<<6);            //shift for 4bits coz each SNP is encoded by two bits
    index=0;
    for (i = 0; i < LENGTH; i = i + 2)
    begin
      if(DNA_6[i] || DNA_6[i+1])
          DNA_shl_three[index] = 1'b1;            //Bp mismatch
      else
          DNA_shl_three[index] = 1'b0;            //Bp match
      index=index+1;
    end
    DNA_shl_three[(LENGTH/2)-1]=1'b1;        //referencce bp mapped to empty bp due to shifting 
    DNA_shl_three[(LENGTH/2)-2]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shl_three[(LENGTH/2)-3]=1'b1;        //referencce bp mapped to empty bp due to shifting				
    
    ////////////////////////////////////////////////////////
    //
    //                Hamming Mask for Read<<4 & Reference
    //
    ////////////////////////////////////////////////////////
    DNA_7= DNA_ref ^ (DNA_read<<8);            //shift for 4bits coz each SNP is encoded by two bits
    index=0;
    for (i = 0; i < LENGTH; i = i + 2)
    begin
      if(DNA_7[i] || DNA_7[i+1])
          DNA_shl_four[index] = 1'b1;            //Bp mismatch
      else
          DNA_shl_four[index] = 1'b0;            //Bp match
      index=index+1;
    end
    DNA_shl_four[(LENGTH/2)-1]=1'b1;        //referencce bp mapped to empty bp due to shifting 
    DNA_shl_four[(LENGTH/2)-2]=1'b1;        //referencce bp mapped to empty bp due to shifting 
    DNA_shl_four[(LENGTH/2)-3]=1'b1;        //referencce bp mapped to empty bp due to shifting 
    DNA_shl_four[(LENGTH/2)-4]=1'b1;        //referencce bp mapped to empty bp due to shifting 
    
    ////////////////////////////////////////////////////////
    //
    //                Hamming Mask for Read<<5 & Reference
    //
    ////////////////////////////////////////////////////////
    DNA_8= DNA_ref ^ (DNA_read<<10);            //shift for 4bits coz each SNP is encoded by two bits
    index=0;
    for (i = 0; i < LENGTH; i = i + 2)
    begin
      if(DNA_8[i] || DNA_8[i+1])
          DNA_shl_five[index] = 1'b1;            //Bp mismatch
      else
          DNA_shl_five[index] = 1'b0;            //Bp match
      index=index+1;
    end
    DNA_shl_five[(LENGTH/2)-1]=1'b1;        //referencce bp mapped to empty bp due to shifting 
    DNA_shl_five[(LENGTH/2)-2]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shl_five[(LENGTH/2)-3]=1'b1;        //referencce bp mapped to empty bp due to shifting 
    DNA_shl_five[(LENGTH/2)-4]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shl_five[(LENGTH/2)-5]=1'b1;        //referencce bp mapped to empty bp due to shifting 			
    
    ////////////////////////////////////////////////////////
    //
    //                Hamming Mask for Read>>1 & Reference
    //
    ////////////////////////////////////////////////////////
    DNA_4= DNA_ref ^ (DNA_read>>2);            //shift for 2bits coz each SNP is encoded by two bits
    index=0;
    for (i = 0; i < LENGTH; i = i + 2)
    begin
        if(DNA_4[i] || DNA_4[i+1])
            DNA_shr_one[index] = 1'b1;            //Bp mismatch
        else
            DNA_shr_one[index] = 1'b0;            //Bp match
        index=index+1;
    end
    DNA_shr_one[0]=1'b1;        //referencce bp mapped to empty bp due to shifting  
    
    ////////////////////////////////////////////////////////
    //
    //                Hamming Mask for Read>>2 & Reference
    //
    ////////////////////////////////////////////////////////
    DNA_5= DNA_ref ^ (DNA_read>>4);            //shift for 4bits coz each SNP is encoded by two bits
    index=0;
    for (i = 0; i < LENGTH; i = i + 2)
    begin
        if(DNA_5[i] || DNA_5[i+1])
            DNA_shr_two[index] = 1'b1;            //Bp mismatch
        else
            DNA_shr_two[index] = 1'b0;            //Bp match
        index=index+1;
    end
    DNA_shr_two[0]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shr_two[1]=1'b1;        //referencce bp mapped to empty bp due to shifting
        
    ////////////////////////////////////////////////////////
    //
    //                Hamming Mask for Read>>3 & Reference
    //
    ////////////////////////////////////////////////////////
    DNA_9= DNA_ref ^ (DNA_read>>6);            //shift for 4bits coz each SNP is encoded by two bits
    index=0;
    for (i = 0; i < LENGTH; i = i + 2)
    begin
        if(DNA_9[i] || DNA_9[i+1])
            DNA_shr_three[index] = 1'b1;            //Bp mismatch
        else
            DNA_shr_three[index] = 1'b0;            //Bp match
        index=index+1;
    end
    DNA_shr_three[0]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shr_three[1]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shr_three[2]=1'b1;        //referencce bp mapped to empty bp due to shifting
    
    ////////////////////////////////////////////////////////
    //
    //                Hamming Mask for Read>>4 & Reference
    //
    ////////////////////////////////////////////////////////
    DNA_10= DNA_ref ^ (DNA_read>>8);            //shift for 4bits coz each SNP is encoded by two bits
    index=0;
    for (i = 0; i < LENGTH; i = i + 2)
    begin
        if(DNA_10[i] || DNA_10[i+1])
            DNA_shr_four[index] = 1'b1;            //Bp mismatch
        else
            DNA_shr_four[index] = 1'b0;            //Bp match
        index=index+1;
    end
    DNA_shr_four[0]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shr_four[1]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shr_four[2]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shr_four[3]=1'b1;        //referencce bp mapped to empty bp due to shifting
    
    ////////////////////////////////////////////////////////
    //
    //                Hamming Mask for Read>>5 & Reference
    //
    ////////////////////////////////////////////////////////
    DNA_11= DNA_ref ^ (DNA_read>>10);            //shift for 4bits coz each SNP is encoded by two bits
    index=0;
    for (i = 0; i < LENGTH; i = i + 2)
    begin
        if(DNA_11[i] || DNA_11[i+1])
            DNA_shr_five[index] = 1'b1;            //Bp mismatch
        else
            DNA_shr_five[index] = 1'b0;            //Bp match
        index=index+1;
    end
    DNA_shr_five[0]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shr_five[1]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shr_five[2]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shr_five[3]=1'b1;        //referencce bp mapped to empty bp due to shifting
    DNA_shr_five[4]=1'b1;        //referencce bp mapped to empty bp due to shifting
        
    ////////////////////////////////////////////////////////
    //
    //  Search for Longest Zeros in a sliding window fashion
    //
    ////////////////////////////////////////////////////////
    for (i = 0; i < (LENGTH/2); i = i + 1)
    begin
        SliderMask[i]=0;
    end
    
    for (GridIndex = 0; GridIndex <= ((LENGTH/2)-GridSize); GridIndex=GridIndex+1)
    begin
        /*case ({SliderMask[GridIndex],SliderMask[GridIndex+1],SliderMask[GridIndex+2],SliderMask[GridIndex+3]})
            4'b0000 : count=4;
            4'b0001,4'b0010,4'b0100,4'b1000 : count=3;
            4'b0101,4'b0110,4'b1001,4'b1010,4'b1100,4'b0011 : count=2;
            4'b1011,4'b1101,4'b0111,4'b1110 :  count=1;
            default: count=0;
        endcase*/
        MaxZeros=0;
        case ({DNA_nsh[GridIndex],DNA_nsh[GridIndex+1],DNA_nsh[GridIndex+2],DNA_nsh[GridIndex+3]})
            4'b0000 : count=4;
            4'b0001,4'b0010,4'b0100,4'b1000 : count=3;
            4'b0101,4'b0110,4'b1001,4'b1010,4'b1100,4'b0011 : count=2;
            4'b1011,4'b1101,4'b0111,4'b1110 :  count=1;
            default: count=0;
        endcase
        if (count>MaxZeros)
        begin
            MaxZeros=count;
            SliderMask[GridIndex+:GridSize]=DNA_nsh[GridIndex+:GridSize];
        end
        else if (count==MaxZeros)
        begin
            MaxZeros=count;
            if(DNA_nsh[GridIndex]==0)
                SliderMask[GridIndex+:GridSize]=DNA_nsh[GridIndex+:GridSize];
        end
        //////////////
        //////////////
        case ({DNA_shl_one[GridIndex],DNA_shl_one[GridIndex+1],DNA_shl_one[GridIndex+2],DNA_shl_one[GridIndex+3]})
            4'b0000 : count=4;
            4'b0001,4'b0010,4'b0100,4'b1000 : count=3;
            4'b0101,4'b0110,4'b1001,4'b1010,4'b1100,4'b0011 : count=2;
            4'b1011,4'b1101,4'b0111,4'b1110 :  count=1;
            default: count=0;
        endcase
        if (count>MaxZeros)
        begin
            MaxZeros=count;
            SliderMask[GridIndex+:GridSize]=DNA_shl_one[GridIndex+:GridSize];
        end
        else if (count==MaxZeros)
        begin
            MaxZeros=count;
            if(DNA_shl_one[GridIndex]==0)
                SliderMask[GridIndex+:GridSize]=DNA_shl_one[GridIndex+:GridSize];
            else
                SliderMask[GridIndex+:GridSize]=DNA_nsh[GridIndex+:GridSize];
        end          
        //////////////
        //////////////
        case ({DNA_shl_two[GridIndex],DNA_shl_two[GridIndex+1],DNA_shl_two[GridIndex+2],DNA_shl_two[GridIndex+3]})
            4'b0000 : count=4;
            4'b0001,4'b0010,4'b0100,4'b1000 : count=3;
            4'b0101,4'b0110,4'b1001,4'b1010,4'b1100,4'b0011 : count=2;
            4'b1011,4'b1101,4'b0111,4'b1110 :  count=1;
            default: count=0;
        endcase
        if (count>MaxZeros)
        begin
            MaxZeros=count;
            SliderMask[GridIndex+:GridSize]=DNA_shl_two[GridIndex+:GridSize];
        end
        else if (count==MaxZeros)
        begin
            MaxZeros=count;
            if(DNA_shl_two[GridIndex]==0)
                SliderMask[GridIndex+:GridSize]=DNA_shl_two[GridIndex+:GridSize];
            else
                SliderMask[GridIndex+:GridSize]=DNA_shl_one[GridIndex+:GridSize];
        end 
        //////////////
        //////////////
        case ({DNA_shl_three[GridIndex],DNA_shl_three[GridIndex+1],DNA_shl_three[GridIndex+2],DNA_shl_three[GridIndex+3]})
            4'b0000 : count=4;
            4'b0001,4'b0010,4'b0100,4'b1000 : count=3;
            4'b0101,4'b0110,4'b1001,4'b1010,4'b1100,4'b0011 : count=2;
            4'b1011,4'b1101,4'b0111,4'b1110 :  count=1;
            default: count=0;
        endcase
        if (count>MaxZeros)
        begin
            MaxZeros=count;
            SliderMask[GridIndex+:GridSize]=DNA_shl_three[GridIndex+:GridSize];
        end
        else if (count==MaxZeros)
        begin
            MaxZeros=count;
            if(DNA_shl_two[GridIndex]==0)
                SliderMask[GridIndex+:GridSize]=DNA_shl_two[GridIndex+:GridSize];
            else
                SliderMask[GridIndex+:GridSize]=DNA_shl_three[GridIndex+:GridSize];
        end 
        //////////////
        //////////////
        case ({DNA_shl_four[GridIndex],DNA_shl_four[GridIndex+1],DNA_shl_four[GridIndex+2],DNA_shl_four[GridIndex+3]})
            4'b0000 : count=4;
            4'b0001,4'b0010,4'b0100,4'b1000 : count=3;
            4'b0101,4'b0110,4'b1001,4'b1010,4'b1100,4'b0011 : count=2;
            4'b1011,4'b1101,4'b0111,4'b1110 :  count=1;
            default: count=0;
        endcase
        if (count>MaxZeros)
        begin
            MaxZeros=count;
            SliderMask[GridIndex+:GridSize]=DNA_shl_four[GridIndex+:GridSize];
        end
        else if (count==MaxZeros)
        begin
            MaxZeros=count;
            if(DNA_shl_three[GridIndex]==0)
                SliderMask[GridIndex+:GridSize]=DNA_shl_three[GridIndex+:GridSize];
            else
                SliderMask[GridIndex+:GridSize]=DNA_shl_four[GridIndex+:GridSize];
        end 
        //////////////
        //////////////
        case ({DNA_shl_five[GridIndex],DNA_shl_five[GridIndex+1],DNA_shl_five[GridIndex+2],DNA_shl_five[GridIndex+3]})
            4'b0000 : count=4;
            4'b0001,4'b0010,4'b0100,4'b1000 : count=3;
            4'b0101,4'b0110,4'b1001,4'b1010,4'b1100,4'b0011 : count=2;
            4'b1011,4'b1101,4'b0111,4'b1110 :  count=1;
            default: count=0;
        endcase
        if (count>MaxZeros)
        begin
            MaxZeros=count;
            SliderMask[GridIndex+:GridSize]=DNA_shl_five[GridIndex+:GridSize];
        end
        else if (count==MaxZeros)
        begin
            MaxZeros=count;
            if(DNA_shl_four[GridIndex]==0)
                SliderMask[GridIndex+:GridSize]=DNA_shl_four[GridIndex+:GridSize];
            else
                SliderMask[GridIndex+:GridSize]=DNA_shl_five[GridIndex+:GridSize];
        end 
        //////////////
        //////////////
        case ({DNA_shr_one[GridIndex],DNA_shr_one[GridIndex+1],DNA_shr_one[GridIndex+2],DNA_shr_one[GridIndex+3]})
            4'b0000 : count=4;
            4'b0001,4'b0010,4'b0100,4'b1000 : count=3;
            4'b0101,4'b0110,4'b1001,4'b1010,4'b1100,4'b0011 : count=2;
            4'b1011,4'b1101,4'b0111,4'b1110 :  count=1;
            default: count=0;
        endcase
        if (count>MaxZeros)
        begin
            MaxZeros=count;
            SliderMask[GridIndex+:GridSize]=DNA_shr_one[GridIndex+:GridSize];
        end
        else if (count==MaxZeros)
        begin
            MaxZeros=count;
            if(DNA_shl_five[GridIndex]==0)
                SliderMask[GridIndex+:GridSize]=DNA_shl_five[GridIndex+:GridSize];
            else
                SliderMask[GridIndex+:GridSize]=DNA_shr_one[GridIndex+:GridSize];
        end 
        //////////////
        //////////////
        case ({DNA_shr_two[GridIndex],DNA_shr_two[GridIndex+1],DNA_shr_two[GridIndex+2],DNA_shr_two[GridIndex+3]})
            4'b0000 : count=4;
            4'b0001,4'b0010,4'b0100,4'b1000 : count=3;
            4'b0101,4'b0110,4'b1001,4'b1010,4'b1100,4'b0011 : count=2;
            4'b1011,4'b1101,4'b0111,4'b1110 :  count=1;
            default: count=0;
        endcase
        if (count>MaxZeros)
        begin
            MaxZeros=count;
            SliderMask[GridIndex+:GridSize]=DNA_shr_two[GridIndex+:GridSize];
        end
        else if (count==MaxZeros)
        begin
            MaxZeros=count;
            if(DNA_shr_one[GridIndex]==0)
                SliderMask[GridIndex+:GridSize]=DNA_shr_one[GridIndex+:GridSize];
            else
                SliderMask[GridIndex+:GridSize]=DNA_shr_two[GridIndex+:GridSize];
        end           
        //////////////
        //////////////
        case ({DNA_shr_three[GridIndex],DNA_shr_three[GridIndex+1],DNA_shr_three[GridIndex+2],DNA_shr_three[GridIndex+3]})
            4'b0000 : count=4;
            4'b0001,4'b0010,4'b0100,4'b1000 : count=3;
            4'b0101,4'b0110,4'b1001,4'b1010,4'b1100,4'b0011 : count=2;
            4'b1011,4'b1101,4'b0111,4'b1110 :  count=1;
            default: count=0;
        endcase
        if (count>MaxZeros)
        begin
            MaxZeros=count;
            SliderMask[GridIndex+:GridSize]=DNA_shr_three[GridIndex+:GridSize];
        end
        else if (count==MaxZeros)
        begin
            MaxZeros=count;
            if(DNA_shr_two[GridIndex]==0)
                SliderMask[GridIndex+:GridSize]=DNA_shr_two[GridIndex+:GridSize];
            else
                SliderMask[GridIndex+:GridSize]=DNA_shr_three[GridIndex+:GridSize];
        end         
        //////////////
        //////////////
        case ({DNA_shr_four[GridIndex],DNA_shr_four[GridIndex+1],DNA_shr_four[GridIndex+2],DNA_shr_four[GridIndex+3]})
            4'b0000 : count=4;
            4'b0001,4'b0010,4'b0100,4'b1000 : count=3;
            4'b0101,4'b0110,4'b1001,4'b1010,4'b1100,4'b0011 : count=2;
            4'b1011,4'b1101,4'b0111,4'b1110 :  count=1;
            default: count=0;
        endcase
        if (count>MaxZeros)
        begin
            MaxZeros=count;
            SliderMask[GridIndex+:GridSize]=DNA_shr_four[GridIndex+:GridSize];
        end
        else if (count==MaxZeros)
        begin
            MaxZeros=count;
            if(DNA_shr_three[GridIndex]==0)
                SliderMask[GridIndex+:GridSize]=DNA_shr_three[GridIndex+:GridSize];
            else
                SliderMask[GridIndex+:GridSize]=DNA_shr_four[GridIndex+:GridSize];
        end         
        //////////////
        //////////////
        case ({DNA_shr_five[GridIndex],DNA_shr_five[GridIndex+1],DNA_shr_five[GridIndex+2],DNA_shr_five[GridIndex+3]})
            4'b0000 : count=4;
            4'b0001,4'b0010,4'b0100,4'b1000 : count=3;
            4'b0101,4'b0110,4'b1001,4'b1010,4'b1100,4'b0011 : count=2;
            4'b1011,4'b1101,4'b0111,4'b1110 :  count=1;
            default: count=0;
        endcase
        if (count>MaxZeros)
        begin
            MaxZeros=count;
            SliderMask[GridIndex+:GridSize]=DNA_shr_five[GridIndex+:GridSize];
        end
        else if (count==MaxZeros)
        begin
            MaxZeros=count;
            if(DNA_shr_four[GridIndex]==0)
                SliderMask[GridIndex+:GridSize]=DNA_shr_four[GridIndex+:GridSize];
            else
                SliderMask[GridIndex+:GridSize]=DNA_shr_five[GridIndex+:GridSize];
        end         
        //////////////
    end
    //  END of Search for Longest Consecutive Zeros 
    ////////////////////
    ////////////////////////////////////////////////////////
    //
    //                Counting the number of errors (ones) in the Magnet Mask
    //
    ////////////////////////////////////////////////////////
    MinEdits=0;
    for (i=0; i<(LENGTH/2); i=i+1)
    begin
        if (SliderMask[i]== 1'b1)
            MinEdits = MinEdits+1;
    end
    if (MinEdits <= ErrorThreshold)
        DNA_MinErrors = 7'b1111111;
    else
        DNA_MinErrors = 7'b0000000;
        
     
end 

endmodule
