clear,
close all
figure(1)
L=2^16;
bins=64;
n0=16;
sr=500000;
pow=n0/2*sr;
n=randn(L,1)*sqrt(pow)...
    +cos(2*pi*[0:L-1]'/sr*15000)*1000;
%plot(n)
stps=L/bins;
N=abs(fft(n)).^2/L/sr;
f=[0:bins-1]/bins*sr;

win=boxcar(bins);

bias=sum((win.*cos(2*pi*sr*[0:length(win)-1]'/sr*200000)).^2) ...
         / sum(cos(2*pi*sr*[0:length(win)-1]'/sr*200000).^2);

bf=[0:L-1]/L*sr;

for j=1:bins
    MN(j)=mean(N((j-1)*stps+1:j*stps))*2;
    nf(j)=mean(bf((j-1)*stps+1:j*stps));
end;
plot(nf(1:bins/2),MN(1:bins/2))

for j=1:stps
    SN(:,j)=abs(fft(win.*n((j-1)*bins+1:j*bins))).^2/bins/sr*2;
end;

hold on
plot(f(1:bins/2),mean(SN(1:bins/2,:),2)/bias,'r')
ylabel('PSD, dB re. 1 µPa^2/Hz')
xlabel('Frequency, Hz')
figure(3)
specgram(n,bins,sr,win,0)

M=abs(specgram(n,bins,sr,win,0)).^2/bins/sr*2;
fn=[0:size(M,1)-1]/(size(M,1)-1)*sr/2;
figure(1)
plot(fn,mean(M,2)/bias,'g')