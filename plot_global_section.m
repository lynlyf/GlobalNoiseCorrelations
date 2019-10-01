%% A sample code to plot an image of global noise correlations
% variables in datafile:
%   CF: correlation functions
%   dd: separation distance spacing in deg
%   dt: time interval in sec
%   ml: maxlag of CF
%%
datafile = 'ZZ.mat';
periods = [3,10]; % period band to bandpass
load(datafile); % read `CF, dd, dt, ml`
dis = 0:dd:180; % distance axis in deg
t = (0:ml)*dt/60; % time axis in min
hfig = figure('name',sprintf('%s, T=[%g,%g]s',datafile,periods),'color','w');
np = size(CF,1);
if 1+ml==np % mirror causal to acausal   
    CF = CF([np:-1:2,1:np],:);
end
[b,a] = butter(3,2*dt*[1/periods(2),1/periods(1)]);
C = filtfilt(b,a,double(CF)); % bandpass
E = abs(hilbert(C)); % envelope
E = (E(1+ml:-1:1,:)+E(1+ml:end,:))/2; % average of acausal and causal CF envelopes
ax = axes(hfig,'position',[0.1,0.1,0.8,0.8],'box','on');
imagesc(ax,dis,t,E); 
colormap(gca,flipud(gray));
caxis(gca,[0,1]*3e-5);
set(ax,'xlim',[0,180],'xtick',0:30:180,'ylim',[0,60],'ytick',0:5:t(end),'ydir','normal');
xlabel(ax,'Distance (deg)');
ylabel(ax,'Time (min)'); 
%% EOF