%-----------------------------------------------------------------
%   MINI PROJECT 2011-12                                         
%   SIXTH SEMESTER INFORMATION TECHNOLOGY                        
%   GOVT.ENGINEERING COLLEGE SREEKRISHNAPURAM, PALAKKAD          
%-----------------------------------------------------------------
%*****************************************************************
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%*****************************************************************
%-----------------------------------------------------------------
%   "ELECTRONIC NOSE USING ARTIFITIAL NEURAL NETWORKS"
%   MAIN CODE FOR NEURAL NETWORK
%   IMPLMENTATION OF THREE INPUT SINGLE LAYER SINGLE PERCEPTRON
%-----------------------------------------------------------------
%*****************************************************************

clear;

%THE NAME ARRAY
name=['xxx'];   
names=cellstr(name);

%THE PROGRAM LIFE CYCLE COUNT IN "EPOCH"
epoch = 0;

%WEIGHT VECTOR
wts=[10 15 20];

%BIAS
b=1;

%THE MAIN PROGRAM
pqrs=1;
while(pqrs == 1)

    %INITIALISING THE ARDUINO BOARD AND THE MICROCONTROLLER
    if exist('a') && isa(a,'arduino') && isvalid(a),
        % nothing to do    
    else
        %DEFINING THE PORT ID TO "COM11"
        a=arduino('COM11');
    end

    %INITIALISING INPUT PINS 2,3 AND 4 RESPECTIVELY FOR MQ3,MQ7 AND MQ 135
    %GAS SENSORS
    
    a.pinMode(2, 'INPUT');  
    a.pinMode(3, 'INPUT'); 
    a.pinMode(4, 'INPUT'); 

    aPin=2;
    bPin=3;
    cpin=4;

    % THE LOOP FOR 2 MINUTES
    
    tic
    while toc/60< 1
    
        %READ ANALOG INPUTS
        
        ain=a.analogRead(aPin);
        v=100*ain/1024;
        
        bin=a.analogRead(bPin);
        w=100*ain/1024;
        
        cin=a.analogRead(cpin);
        x=100*ain/1024;
    end
    
    %LEARNING RATE
    alpha=0.5;
    
    %INPUT VECTOR
    p=[v;w;x;];
    
    dif=0.1;

    % HARDLIMS FUNCTION 
    yin=(wts*p)+b;
    
    %ACTIVATION FUNCTION HERE THE IDENTITY FUNCTION IF USED
    y=yin;

    %IF IT IS THE FIRST EPOCH LEARN THE FIRST ODOUR !
    if(epoch == 0)
        disp(' ');
        disp('THIS IS EPOCH 1');
        disp(' ');
        disp(' ');
        disp('TEACH');
        disp(' ');
        new=input('ENTER THE NAME : ');
        names=[new];
        names=cellstr(names);
        
        t=[y];
        oh=[v];
        co=[w];
        aq=[x];
    
        b=b+(alpha*y/100);
    end
    
    % IF THE EPOCH IS NOT THE FIRST THEN-
    if(epoch ~= 0)

        i=size(t);
        n=1;
        flag=0;
    
        %CHECK WETHER THE 'Y' VALUE IS NEAR ANT OF THE TARGET VALUE SET AT
        %ANY OF THE PREVIOUS EPOCHS
        
        while(n <= i(2))
            if((t(n)-2) < y )
                if(y < (t(n)+2))
                    if((oh(n)-dif) < v)
                        if(v < (oh(n)+dif))
                            if((co(n)-dif)< w)
                                if(w < (co(n)+dif))
                                    if((aq(n)-dif) < x)
                                        if(x < (aq(n)+dif))
                                            
                                            %IF THE 'Y' VALUE IS ANYWHERE
                                            %NEAR THE TARGET VALUE THEN THE
                                            %ODOUR IS KNOWN, SO DISPALY ITS
                                            %NAME !
                                            disp(' ');
                                            disp(' ');
                                            disp('KNOWN ODOUR DETECTED ...!');
                                            disp(names(n));
                                  
                                            %UPDATE THE WEIGHT VECTOR AND
                                            %THE BIAS
                                            u=alpha*(t(n)-y);
                                            wts(1)=wts(1)+(u*oh(n));
                                            wts(2)=wts(2)+(u*co(n));
                                            wts(3)=wts(3)+(u*aq(n));
                                            b=b+u;
                                      
                                            flag=1;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            n=n+1;
        end
        
        %IF THE 'Y' VALUE IS PURELY UNKNOWN THEN LEARN
        if(flag == 0)
            disp(' ');
            disp(' ');
            disp('UNIDENTIFIED ODOUR DETECTED...');
            disp(' ');
            disp('TEACH THE NAME');
            disp(' ');
            new=input('THE NAME IS : ');
            names=[names;new];
            t=[t y];
            oh=[oh v];
            co=[co w];
            aq=[aq x];
    
            b=b+(alpha*y/100);
    
        end
    end
    
    %CHOICE FOR EXITING
    disp('DO YOU WANT TO CONTINUE ?');
    ch=input('Y/N : ');
    if(ch == 'N')
        pqrs=0;
        disp(' ');
        disp('THANKYOU FOR USING E-NOSE !');
    end
    
    %INCREMENT THE EPOCH
    epoch=epoch+1;
end
