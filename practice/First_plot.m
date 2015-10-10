function First_plot(fpath, fname, savename)

%Basic function for plotting size distribution surface plot
%fclose all
%if nargin<2 | ~ischar(path) | ~ischar(fname) | ~ischar(fname)
%error('Need input of filename & filepath')
%end

%clear all;
%close all;

fclose all;


fid=fopen(fname, 'r');

station=fgetl(fid); %gets station name
startdate=fgetl(fid); %gets startdate as string
enddate=fgetl(fid); %gets enddate as string
dummy=strtrim(fgetl(fid)); %just dummy to read until specifier for "bof"

if dummy~='bof'
dummy=fgetl(fid);
end
head=strsplit(fgetl(fid)); %split header into substrings

pos1=find(strcmp(head, 'Dp1')==1); %location of first bin
flagpos=find(strcmp(head, 'Flag')==1); %location of flag==last column

size_vec=str2num(fgetl(fid)); % reads first row of data
sizes=size_vec(pos1:flagpos-1);
data_matrix=fscanf(fid, '%f', [flagpos, inf])'; % reads in data until EOF with no_col columns
dates=data_matrix(:, 1:pos1-1); %matrix with datestamps
datan=data_matrix(:, pos1:flagpos-1); %extract full datamatrix from file
flags=data_matrix(:, flagpos); % extract the flags

datan(flags>0, :)=NaN; %set invalidate values to NaN prior plotting

date=datenum(dates(:, 1), dates(:, 2), dates(:, 3), dates(:, 4), 0,0)-...
    datenum(dates(:, 1)-1, 12, 31, 24, 0,0); %create decimal_day. Un-necessary if input file already, contains decimal day but I think we should allow for full dates as : YYYY, MM, DD, HH


% creating the plot
figure(1);
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

%print(savename,'-dtif');

saveas(1, savename, 'tif')

end


