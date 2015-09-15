function First_plot_1_octave(fpath, fname, savename, extension, operator, no_clusts)
chdir('.');

%parpool(6);
%%%%%%%not yet implemented arguments
%close all;
%set(gcf, 'renderer', 'opengl');
moment='Numb';
label=[moment,' ', operator];
%Basic function for plotting size distribution surface plot
fclose all;
%if nargin<3 | ~ischar(path) | ~ischar(fname) | ~ischar(fname)
%error('Need input of filename,filepath & output filename in string-form ')
%end


fid=fopen([fpath, fname], 'r');

station=fgetl(fid); %gets station name
startdate=fgetl(fid); %gets startdate as string
enddate=fgetl(fid); %gets enddate as string
dummy=strtrim(fgetl(fid)); %just dummy to read until specifier for "bof"

if dummy~='bof'
dummy=strtrim(fgetl(fid));
end
head=strsplit(fgetl(fid)); %split header into substrings

pos1=find(strcmp(head, 'Dp1')==1); %location of first bin
flagpos=find(strcmp(head, 'Flag')==1); %location of flag==last column

size_vec=str2num(fgetl(fid)); % reads first row of data
sizes=size_vec(pos1:flagpos-1);
data_matrix=fscanf(fid, '%f', [flagpos, inf])'; % reads in data until EOF with flagpos number of columns
dates=data_matrix(:, 1:pos1-1); %matrix with datestamps
datan=data_matrix(:, pos1:flagpos-1); %extract full datamatrix from file
flags=data_matrix(:, flagpos); % extract the flags

datan(flags>0, :)=NaN; %set invalidate values to NaN prior plotting

date=datenum(dates(:, 1), dates(:, 2), dates(:, 3), dates(:, 4), 0,0)-...
    datenum(dates(:, 1)-1, 12, 31, 24, 0,0); %create decimal_day. ...
    ...Un-necessary if input file already, contains decimal day but I...
    ...think we should allow for full dates as : YYYY, MM, DD, HH


% creating the plots (fig 1 & 2 represent default output, addtional...
...figures are optional based on client input)


%Figure 1: Data coverage based on flagging

%figure(1);
figure (1, 'visible', 'off');
plot(date, flags, '+');
set(gca, 'xlim', [date(1), date(length(date))]);
xlabel(['Days of year'], 'fontsize', 12);
ylabel('NumFlag', 'fontsize', 12);
sumflag=sum(flags==0)/length(flags);
title(['Data coverage (flag=0: ' num2str(100*sumflag) '%)']);
%saveas(1, [savename '_1'], extension);
%print -dpng fig01.png;
filen=strcat(savename, '_1','.png')
saveas (1, filen)

%Figure 2: Size distribution and integral number
figure (2, 'visible', 'off');
%figure(2)
pcolor(date, sizes, log10(abs(datan')));
xlabel('Day of year', 'fontsize', 12);
ylabel('Dp, nm');
colormap(jet(250));
set(gca, 'yscale', 'log');
caxis([0, 4]);
p=colorbar;
shading flat;
ylabel(p, 'dN/dlogD_p, cm^{-3}');
set(p, 'ytick', [0:4], 'yticklabel', {'1', '10', '100', '1000', '10000'});
grid on;

%print -dpng fig02.png;
%print -dtiff fig02.tiff
filen=strcat(savename, '_2')
%print -dpng fig01.png;
print -dtiff filen.tiff

%print -dtiff savename_1.tiff

%saveas(2, [savename '_2'], extension);

%Figur 3: Grand average distribution and prct_range
%figure(3)
figure (3, 'visible', 'off');

switch(operator)
case 'prctile' 
stat=eval([operator, '(datan(flags<0.999, :), [25,50, 75])']);
stat=prctile(datan(flags<0.999, :), [25,50, 75]);
    case 'std'
        stat=[];
        av=mean(datan(flags<0.999, :), 1);
        stat_op=std(datan(flags<0.999, :), 1);
        stat(1:3, 1:size(datan, 2))=[av-stat_op; av; av+stat_op];
        
                
        patch([log10(sizes), log10(sort(sizes, 'descend'))], [stat(1, :), stat(3, length(stat):-1:1)], 0.5*[1,1,1]);
        hold on;
        plot(log10(sizes), stat(2, :), 'k--', 'linewidth', 2);
        ylabel([label], 'fontsize', 12, 'fontweight', 'bold');
        xlabel('D_p, nm' , 'fontsize', 12, 'fontweight', 'bold');
        set(gca, 'yscale', 'lin');
        title([strtrim(station), ' ', moment,' ', startdate, '-' enddate], 'fontsize', 12, 'fontweight', 'bold' );
        
        
        case 'clustering' %for clustering of size_dist_data_of certain
       
        
        if no_clusts<4
            error('Number of clusters should be >=4');
        end
        
        clu_dat=datan(flags<0.999, :);
        clus=kmeans(clu_dat, no_clusts, 'maxiter', 100, 'replicates', 3);
    
        for nos=1:no_clusts
            
            subplot(ceil(no_clusts/2), ceil(no_clusts/(ceil(no_clusts/2))), nos);
            
            stat=prctile(clu_dat(clus==nos, :), [25, 50, 75]);
            
            patch([log10(sizes), log10(sort(sizes, 'descend'))], [stat(1, :), stat(3, length(stat):-1:1)], 0.5*[1,1,1]);
       
               title(['# members: ', num2str(sum(clus==nos))]);    
              set(gca, 'xlim', [min(log10(sizes)), max(log10(sizes))], 'xtick', log10([10:10:100 200:100:1000]), 'xticklabel', [{10,' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',100, ' ', ' ', ' ', ' ', ' ',  ' ',  ' ',  ' ',1000}]);
       
                   xlabel('D_p, nm','fontsize', 10, 'fontweight', 'bold');
             
                   ylabel('dN/dlogDp, cm^{-3}','fontsize', 8, 'fontweight', 'bold');
        
        end
        
            
        
            end
         


endfunction

