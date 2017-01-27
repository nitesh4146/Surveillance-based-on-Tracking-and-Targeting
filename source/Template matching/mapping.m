

global x;
global y;
global s;

while(1)
    pause on;
    pause(0.1);
    a1 = x/16;
    a1 = round(a1) + 1;
    pulse1 = 1640 + 100 - a1*10;
    pulstr1 = num2str(pulse1);
    fwrite(s,strcat(pulstr1,'b'));
    pause on;
    pause(0.1);    
    a2 = y/16;
    a2 = round(a2) + 1;
    pulse2 = 1640 + 200 - a2*10;
    pulstr2 = num2str(pulse2);

    fwrite(s,strcat(pulstr2,'s'));
   
end;