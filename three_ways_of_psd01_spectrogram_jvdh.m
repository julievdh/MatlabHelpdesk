clear,
close all
L=2^16; % signal of considerable length 
bins=256;
n0=16; % 
sr=500000;
pow=n0/2*sr;
tonefreq=15000; % tone with a known frequency 
n=randn(L,1)*sqrt(pow)... 
    +cos(2*pi*[0:L-1]'/sr*tonefreq)*1000;
%plot(n)
stps=L/bins; 

% one way to do this is a very long fft of whole signal
N=abs(fft(n)).^2/L/sr; % divide by sampling rate to get /Hz 
f=[0:bins-1]/bins*sr; % generate frequency vector for binned data

win=hamming(bins);

% based on the window that we choose, we are introducing a certain amount
% of bias. 
% What is the ratio of powers if we have used window on signal and if we
% haven't used window on the signal? We can calculate the bias from a known
% signal.
bias=sum((win.*cos(2*pi*sr*[0:length(win)-1]'/sr*200000)).^2) ...
         / sum(cos(2*pi*sr*[0:length(win)-1]'/sr*200000).^2);

bf=[0:L-1]/L*sr; % frequency vector for entire long signal

for j=1:bins
    MN(j)=mean(N((j-1)*stps+1:j*stps))*2; % mean of big spectrum - average many bins together 
    nf(j)=mean(bf((j-1)*stps+1:j*stps));
end;
figure(1)
h=axes;
plot(nf(1:bins/2),10*log10(MN(1:bins/2)))

for j=1:stps % cut signal into bins
    SN(:,j)=abs(fft(win.*n((j-1)*bins+1:j*bins))).^2/bins/sr*2; % spectrogram, effectively
end;

hold on
plot(f(1:bins/2),10*log10(mean(SN(1:bins/2,:),2)/bias),'r')
hold on
ylabel('PSD, µPa^2/Hz')
xlabel('Frequency, Hz')
figure(3)
spectrogram(n,win,0,bins,sr,'yaxis') 
% the color bar label on this is wrong
% dB re: Pa squared per second 
MG=get(get(gca,'children'),'CData');

% shortcut way: use built-in spectrogram
M=abs(spectrogram(n,win,0,bins,sr)).^2/bins/sr*2/bias; 
    % still have to square (not powers yet), divide by bins, divide by SR to get per Hz
    % divide by two because
    % divide by bias 
fn=[0:size(M,1)-1]/(size(M,1)-1)*sr/2;
figure(1)
axes(h)
ylim
plot(fn,10*log10(mean(M(1:length(fn),:),2)),'g--')
line(xlim,10*log10(n0)*[1 1],'color','k')
pos=get(h,'position');
annotation('arrow',[pos(1)/2 pos(1)],pos(2)+(10*log10(n0)-min(ylim))/(diff(ylim))*pos(4)*[1 1])
annotation('arrow',pos(1)+(tonefreq-min(xlim))/(diff(xlim))*pos(3)*[1 1],[pos(2)/2 pos(2)])

% better frequency and temporal resolution using the full signal that is then chopped up
% chopping up the signal before assessing frequency resolution is slightly
% lower 
% the frequency bins don't end up in the same place. The full fft gives
% better time resolution and also knows limits of inference (can't get
% frequency at 0 Hz)

%% testing git from within matlab
plot([0 1],[1 0])