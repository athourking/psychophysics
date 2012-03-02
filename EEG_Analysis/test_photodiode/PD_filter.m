D=EEG.data;
D65=double(D(65,:));

wn=[8 30]/128;
[a b]=butter(2,wn);
DF=filtfilt(a,b,D65);

% wo = 70/(256/2);  bw = wo/1;
% [a, b] = iirnotch(wo, bw);
% DF=filtfilt(a, b, D65);
% fvtool(b,a);

figure;
plot((1:length(D65)) /256,D65);

% num2idxs = [EEG.event(:).type] == 65282;
num2Latencies = repmat([EEG.event([EEG.event(:).type] == 65282).latency],2,1);

% num4idxs = [EEG.event(:).type] == 65284;
num4Latencies = repmat([EEG.event([EEG.event(:).type] == 65284).latency],2,1);

Y= repmat([min(D65) max(D65)],length(num2Latencies), 1)';
line(num2Latencies / 256, Y, 'Color', [0 1 0])
line(num4Latencies / 256, Y, 'Color', [1 0 0])


% Power spectrum
figure;
Fs = 256;                     % Sampling frequency
T = 1/Fs;                     % Sample time
t = DF;                      % Time vector
L = length(t);              % Length of signal

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(t,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
% title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
signal = D65;
srround = 256;
Ntot = length(signal);
para_largo = ceil(log(srround)/log(2)) + 1;  
N = 2^para_largo;  %resol aprox de 1 hz (con rectangular, resuelve hasta 0.88*sr/N). con wintool, el ancho que aparece es igual a (sr*K/L)/(fs/2), siendo K la constante de proporcionalida que cambia con la ventana
M = floor(Ntot/N);
n=N;
fx=(-n/2: (n-1)/2)*srround/n;
Xbarhan = zeros(1,n);

for jj=1:M
    [Pbarhan] = periodogram(signal((jj-1)*N+1:jj*N),barthannwin(N),'twosided',n,srround); % K aprox 1.375
    Xbarhan = Xbarhan + Pbarhan';
end

signal_filt = signal;
f2 = 128; % max freq, half of sampling rate
freq_for_notch = 35;
for kk=1:1:floor(f2/freq_for_notch)    
%     kk = 1;
    wo = freq_for_notch*kk/(srround/2);  bw = wo/15; %bw = wo/35;
    [bnotch,anotch] = iirnotch(wo,bw);
    signal_filt=filtfilt(bnotch,anotch,signal_filt);
end

kk = 1;
wo = 116*kk/(srround/2);  bw = wo/15; %bw = wo/35;
[bnotch,anotch] = iirnotch(wo,bw);
signal_filt=filtfilt(bnotch,anotch,signal_filt);


Xbarhan_notch = zeros(1,n);
for jj=1:M
    [Pbarhan_notch] = periodogram(signal_filt((jj-1)*N+1:jj*N),barthannwin(N),'twosided',n,srround); % K aprox 1.375
    Xbarhan_notch = Xbarhan_notch + Pbarhan_notch';
end
        
figure(3)
    set(gcf,'Color',[1 1 1])        
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperType', 'A4');
    set(gcf, 'PaperPositionMode', 'auto');    
    plot(fx,10*log10(fftshift(Xbarhan/M)),'k','LineWidth',1)
    hold on
    plot(fx,10*log10(fftshift(Xbarhan_notch/M)),'r','LineWidth',1)
    axis tight
%     xlim([-f2 f2])
    grid on
    legend('bartlett-hanning window','bartlett-hanning window with notch')
%     maximize;
    xlabel('Frequency (Hz)')
    ylabel('Power Spectrum (dB/Hz)')
%     titletext = ['Spectrum of data in channel ' num2str(chnum) ' from session ' resus_folder ', computed by averaging periodograms of length 2^{' num2str(para_largo) '}'];
%     title(titletext,'fontsize',12);


figure;
plot( (1:length(signal_filt)) / 256, signal_filt)


% num2idxs = [EEG.event(:).type] == 65282;
num2Latencies = repmat([EEG.event([EEG.event(:).type] == 65282).latency],2,1);

% num4idxs = [EEG.event(:).type] == 65284;
num4Latencies = repmat([EEG.event([EEG.event(:).type] == 65284).latency],2,1);

Y= repmat([min(signal_filt) max(signal_filt)],length(num2Latencies), 1)';
line(num2Latencies / 256, Y, 'Color', [0 1 0])
line(num4Latencies / 256, Y, 'Color', [1 0 0])
