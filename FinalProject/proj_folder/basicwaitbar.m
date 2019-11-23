function basicwaitbar
f = waitbar(0,'Please wait...');
pause(1)

waitbar(.25,f,'Loading your data');
pause(1)

waitbar(.5,f,'Loading your data');
pause(1)

waitbar(.75,f,'Processing your data');
pause(1)

waitbar(1,f,'Finishing');
pause(1)

close(f)
end