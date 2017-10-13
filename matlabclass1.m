clear; clc
% animal 1
bw = randn(50,1)*5+30; % bandwidth
cf = randn(50,1)*10+90; % central frequency

figure(1); clf; plot(cf,bw,'*')

% animal 2
bw2 = randn(50,1)*5+33; % bandwidth
cf2 = randn(50,1)*10+95; % central frequency

hold on
plot(cf2,bw2,'r*')

% this is inefficent way if you have many animals or many files. 
% make a script to automate this process, isolate in functions. 
% separate processes: analysis and fetching of data
%% instead: 
clear
dataload
clf; hold on

for j = 1:length(anim)
    plot(anim(j).clickparams(:,1),anim(j).clickparams(:,2),[anim(j).color '*']) % can use color in structure
end
xlabel(anim(j).whatisit(1))
ylabel(anim(j).whatisit(2))

%% how would you structure these data to analyze statistically (e.g. with ANOVA)
% anovan(data,groupingdata)

data = [];
here = 1; % indexing variable to count
for j = 1:length(anim)
    data = [data;anim(j).clickparams(:)];
    for k = 1:size(anim(j).clickparams,2)
        for h = 1:size(anim(j).clickparams,1)
    grp1{here} = anim(j).whatisit(k);
    grp2(here) = j; 
    here = here+1;
        end
    end
end

% anova
tbl = anovan(data,{grp1,grp2});

%  plot
figure(2)
boxplot(data,{grp1,grp2})