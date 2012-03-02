signal = ;
srround = 256;
Ntot=length(signal);
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
   
% for kk=1:1:floor(f2/60)
freq_for_notch = 70;
kk = 1;
wo = freq_for_notch*kk/(srround/2);  bw = wo/144; %bw = wo/35;
[bnotch,anotch] = iirnotch(wo,bw);
signal_filt=filtfilt(bnotch,anotch,signal);
% end

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