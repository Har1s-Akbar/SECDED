module secded(
input clk,
input writeSignal,
input readSignal,
input singleInject,
input doubleInject,

input [3:0] injectIndex1,
input [3:0] injectIndex2, 
input [7:0] inputData,


output reg noError,
output reg oneBitError,
output reg parityError,
output reg twoBitError,
output reg [12:0] outputCodeWord,
output reg [7:0] outputCorrectData,
output reg [7:0] outputCorruptedData,
output reg [3:0] outputSyndrome,
output reg outputOverallParity
);

reg [3:0] parityBits;
reg [12:0] codeWord;
reg overallParity;

reg [12:0] readCodeWord;
reg[3:0] recomputeParity;
reg [3:0] syndrome;
reg recallParity;

integer i;
integer j;
integer weight;

always @(*) begin
	codeWord = 13'b0;
	parityBits = 4'b0;
	overallParity = 1'b0;
	i = 0;
	j = 0;
	for(i=0;i<13;i=i+1)begin
		if(!(i==0 || i==1 || i==3 || i==7 || i==12)) begin
			codeWord[i] = inputData[j];
			j = j+1;
		end
	end
	
	for(i=0 ; i<4;i=i+1)begin
		parityBits[i] = 1'b0;
		for(j=0; j<12 ; j= j+1)begin
			if(((j+1) & (1<<i)) && j!=((1<<i)-1))begin
				parityBits[i] = parityBits[i] ^ codeWord[j];
			end
		end
		codeWord[(1<<i)-1] = parityBits[i];
	end
	
	for(i=0; i<13; i=i+1)begin
		if(!(i==12))begin
			overallParity = overallParity^codeWord[i];
		end
	end
	codeWord[12] = overallParity;
end

always @(posedge clk) begin
	if(writeSignal)begin
		outputCodeWord[12:0] <= codeWord[12:0];
	end

end

always @(*) begin
	i = 0;
	j = 0;
	readCodeWord = 13'b0;
	recallParity = 1'b0;
	noError = 1'b0;
	oneBitError = 1'b0;
	parityError=1'b0;
	twoBitError = 1'b0;
	outputSyndrome = 4'b0;
	outputOverallParity = 1'b0;
	readCodeWord[12:0] = outputCodeWord[12:0];
	outputCorrectData   = 8'b0;
	outputCorruptedData = 8'b0;

	
	if(readSignal)begin
		if(singleInject) begin
			readCodeWord[injectIndex1] = ~ readCodeWord[injectIndex1];
		end
		else if(doubleInject)begin
			readCodeWord[injectIndex1] = ~ readCodeWord[injectIndex1];
			readCodeWord[injectIndex2] = ~ readCodeWord[injectIndex2];
		end
		for(i=0; i<4 ; i = i+1)begin
			recomputeParity[i] = 1'b0;
			for(j=0;j<12;j=j+1)begin
				if(((j+1)& (1<<i))&& j!=((1<<i)-1)) begin
					recomputeParity[i] = recomputeParity[i]^ readCodeWord[j];
				end
			end
			syndrome[i] = recomputeParity[i] ^ readCodeWord[((1<<i)-1)];
		end
		recallParity = 1'b0;
		for(i=0;i<13;i=i+1)begin
			recallParity = recallParity ^ readCodeWord[i];
		end
		if(syndrome != 4'b0) begin
			weight = 0;
			for(i=0;i<4;i=i+1)begin
				if(syndrome[i]) begin
					weight = weight + (1<<i);
				end
			end
		end
		if( syndrome== 4'b0 && recallParity == 1'b0 )begin
			noError = 1'b1;
			oneBitError = 1'b0;
			parityError=1'b0;
			twoBitError = 1'b0;
			i = 0;
			j =0;
			outputOverallParity = recallParity;
			outputSyndrome = syndrome;
			for(i=0;i<13;i=i+1)begin
				if(!(i==0 || i==1 || i==3 || i==7 || i==12)) begin
				outputCorrectData[j] = readCodeWord[i];
				j=j+1;
				end
			end
		end
		else if ( syndrome != 4'b0 && recallParity) begin
			noError = 1'b0;
			oneBitError = 1'b1;
			parityError=1'b0;
			twoBitError = 1'b0;
			outputOverallParity = recallParity;
			outputSyndrome = syndrome;
			readCodeWord[weight -1] = ~readCodeWord[weight-1];
			i = 0;
			j =0;
			for(i=0;i<13;i=i+1)begin
				if(!(i==0 || i==1 || i==3 || i==7 || i==12)) begin
				outputCorrectData[j] = readCodeWord[i];
				j=j+1;
				end
			end
			
		end
		else if(syndrome == 4'b0 && recallParity)begin
			noError = 1'b0;
			oneBitError = 1'b0;
			parityError=1'b1;
			twoBitError = 1'b0;
			readCodeWord[12] = ~readCodeWord[12];
			outputOverallParity = recallParity;
			outputSyndrome = syndrome;
			i = 0;
			j =0;
			for(i=0;i<13;i=i+1)begin
				if(!(i==0 || i==1 || i==3 || i==7 || i==12)) begin
				outputCorrectData[j] = readCodeWord[i];
				j=j+1;
				end
			end
			
		end
		else if(syndrome !=4'b0 && recallParity == 1'b0) begin
			noError = 1'b0;
			oneBitError = 1'b0;
			parityError=1'b0;
			twoBitError = 1'b1;
			outputOverallParity = recallParity;
			outputSyndrome = syndrome;
			i = 0;
			j =0;
			for(i=0;i<13;i=i+1)begin
				if(!(i==0 || i==1 || i==3 || i==7 || i==12)) begin
				outputCorruptedData[j] = readCodeWord[i];
				j=j+1;
				end
			end
		end
	end
end

endmodule
