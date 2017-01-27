%clear all;
%close all;
vid = videoinput('winvideo',2,'YUY2_320x240');
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'grayscale');
vid.FrameGrabInterval = 20;
cameraman=getsnapshot(vid);
face=imcrop(cameraman);
[rowcameraman, colcameraman]=size(cameraman);
[rowface, colface]=size(face);
initial=0;
prevrow=0;
prevcol=0;
start(vid);
while(vid.FramesAcquired<=200)
%     tic;
cameraman=getsnapshot(vid);
cc=normxcorr2(face,cameraman);
[rowcc, colcc]=size(cc);
sizecc = rowcc * colcc;
element=0;
position=0;

for p=1:1:sizecc
    if cc(p)>element
        element=cc(p);
        position=p;
    end
end

cc(position)=1;
[max_cc, imax]=max(abs(cc(:)));
[ypeak, xpeak]=ind2sub(size(cc),imax(1));
bestrow=ypeak-(rowface-1);
bestcol=xpeak-(colface-1);

if initial ~= 0
    
    if abs(prevrow-bestrow)<40 && abs(prevcol-bestcol)<40
  
    prevrow=bestrow;
    prevcol=bestcol;
    else
    bestrow=prevrow;
    bestcol=prevcol;
    
    end
   
else
    prevrow=bestrow;
    prevcol=bestcol;
    initial = initial+1;

end

imshow(cameraman);
hold on
h=imrect(gca, [bestcol bestrow (colface-1) (rowface-1)]);
hold off
% toc;
end;
stop(vid);
flushdata(vid);
clear all;