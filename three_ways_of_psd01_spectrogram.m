clear,
close all
L=2^16;
bins=256;
n0=16;
sr=500000;
pow=n0/2*sr;
tonefreq=15000;
n=randn(L,1)*sqrt(pow)...
    +cos(2*pi*[0:L-1]'/sr*tonefreq)*1000;
%plot(n)
stps=L/bins;
N=abs(fft(n)).^2/L/sr;
f=[0:bins-1]/bins*sr;

win=hamming(bins);

bias=sum((win.*cos(2*pi*sr*[0:length(win)-1]'/sr*200000)).^2) ...
         / sum(cos(2*pi*sr*[0:length(win)-1]'/sr*200000).^2);

bf=[0:L-1]/L*sr;

for j=1:bins
    MN(j)=mean(N((j-1)*stps+1:j*stps))*2;
    nf(j)=mean(bf((j-1)*stps+1:j*stps));
end;
figure(1)
h=axes;
plot(nf(1:bins/2),10*log10(MN(1:bins/2)))

for j=1:stps
    SN(:,j)=abs(fft(win.*n((j-1)*bins+1:j*bins))).^2/bins/sr*2;
end;

hold on
plot(f(1:bins/2),10*log10(mean(SN(1:bins/2,:),2)/bias),'r')
hold on
ylabel('PSD, µPa^2/Hz')
xlabel('Frequency, Hz')
figure(3)
spectrogram(n,win,0,bins,sr,'yaxis')
MG=get(get(gca,'children'),'CData');
M=abs(spectrogram(n,win,0,bins,sr)).^2/bins/sr*2/bias;
    %notice subtraction of bias here.
fn=[0:size(M,1)-1]/(size(M,1)-1)*sr/2;
figure(1)
axes(h)
ylim
plot(fn,10*log10(mean(M(1:length(fn),:),2)),'g--')
line(xlim,10*log10(n0)*[1 1],'color','k')
pos=get(h,'position');
annotation('arrow',[pos(1)/2 pos(1)],pos(2)+(10*log10(n0)-min(ylim))/(diff(ylim))*pos(4)*[1 1])
annotation('arrow',pos(1)+(tonefreq-min(xlim))/(diff(xlim))*pos(3)*[1 1],[pos(2)/2 pos(2)])