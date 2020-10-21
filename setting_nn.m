      % two inputs neurons as average humidity and water demand of previous day and one neuron in output layer as weekly water demand.
    % t=forecasted water demand
    % s=actual water demand
data=xlsread('Book1.xlsx');
%Traing data-7years
%Input
%humidity
[m n]=size(data)
P=data(114,2:11);
disp(P);
T=data(116,2:11);
disp(T);

a=data(113,2:11);
disp(a);
s=data(115,2:11);
disp(s);


%Input data preprocessing
[pn,minp,maxp,tn,mint,maxt]=premnmx('P','T');
[an,mina,maxa,sn,mins,maxs]=premnmx('a','s');
%Create neural network
net=newff(minmax(pn),[10 1],{'tansig','purelin'},'trainlm');
net.trainParam.epochs=3000;
net.trainParam.lr=0.3;
net.trainParam.mc=0.6;
%Train neural network
net=train(net,pn,tn);
%Simulate neural network with test samples
y=sim(net,an);
%Post Processing
t=postmnmx(y',mins,maxs);
%Plot between Actual and predicted values
figure;
plot(t,'red');
hold on; 
% Current plot held
plot(s,'blue');
xlabel('Samples');
ylabel('Water Demand(MLD)');
title('Comparison between neural network output and actual water demand')
legend('forecasted water demand','Actual water Demand');
hold off;
%Plot Regression
figure;
plotregression(t,s);