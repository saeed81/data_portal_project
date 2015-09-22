function analysis(fpath, fname, savename, extension, operator, no_clusts, iresolu) 

itraj=0;
idiurnal = 0;
imonthly= 0;
ihourly
fclose all;

if ( iresolu == 1) 
  
  
%!DMPS_AUTO_CRUNCH.exe

%!/home/saeed/DB_ITM/EBAS_routine/matlab_web/DMPS_AUTO_CRUNCH.exe

%savename = 'fig';

fid1=fopen('Full_TEMP.dat');

operator='prctile';
station=fgets(fid1);
startdate=fgets(fid1);
enddate=fgets(fid1);

datestart=datenum(str2num(startdate(1:4)),str2num(startdate(5:6)),str2num(startdate(7:8)),0,0,0)-datenum(str2num(startdate(1:4))-1,12,31,0,0, 0);
dateend=datenum(str2num(enddate(1:4)),str2num(enddate(5:6)),str2num(enddate(7:8)),0,0,0)-datenum(str2num(startdate(1:4))-1,12,31,0,0, 0);

[paramtype,count]=fscanf(fid1, '%10c/n');
sizerange=str2num(fgets(fid1));
resolution=str2num(fgets(fid1));
moment=strtrim(fgets(fid1));
nobins=str2num(fgets(fid1));
fclose all;


bigmat=dlmread('Full_TEMP.dat', '', 7, 0);

tn=0; ts=0; tv=0;
tn=strcmp(moment,'Numb');
ts=strcmp(moment,'Surf');
tv=strcmp(moment,'Volum');

if (tn == 1) 
  label='dN/dlogD_p, cm^{-3}';
elseif (ts == 1)
  label='dS/dlogD_p, cm^{-3}';
elseif (tv == 1)
  label='dV/dlogD_p, cm^{-3}';
end 


sizes=bigmat(1, 5:size(bigmat, 2)-1);
flags=bigmat(2:size(bigmat, 1), size(bigmat, 2));
datestamp=bigmat(2:size(bigmat, 1), 1:4);

datan=bigmat(2:size(bigmat, 1), 5:size(bigmat, 2)-1);
datan(datan>9999)=0;

dates=datenum(bigmat(2:size(bigmat, 1), 1), bigmat(2:size(bigmat, 1), 2), bigmat(2:size(bigmat, 1), 3), bigmat(2:size(bigmat, 1), 4), 0,0)-datenum(bigmat(2, 1)-1, 12, 31, 0,0,0);

momstat=dlmread('Full_INTEGRAL_TEMP.dat', '', 7,0);
momstat(momstat(:, 5)>1e5, 5:8)=NaN;

Size_range_min_data=min(sizes);
Size_range_max_data=max(sizes);

%hold off;
figure(1);
plot(dates, flags, '+');
set(gca, 'xlim', [datestart, dateend]);
xlabel(['Days from ', startdate], 'fontsize', 12);
ylabel('NumFlag', 'fontsize', 12);
sumflag=sum(flags==0)/length(flags);
set(gca, 'ylim', [-1, 1]);
title(['Data coverage (flag=0: ' num2str(round(100*sumflag)) '%)']);
%saveas(1, [savename '_1'], 'tif');

saveas(1, [savename '_01'], extension);


%figure(2)
%pcolor(date, sizes, log10(abs(datan')));
%xlabel('Day of year', 'fontsize', 12);
%ylabel('Dp, nm');
%colormap(jet(250));
%set(gca, 'yscale', 'log');
%caxis([0, 4]);
%p=colorbar;
%shading flat;
%ylabel(p, 'dN/dlogD_p, cm^{-3}');
%set(p, 'ytick', [0:4], 'yticklabel', {'1', '10', '100', '1000', '10000'});
%grid on;

%saveas(2, [savename '_2'], extension);





%grand average of distribution properties
%axes(handles.plotax2);
%hold off
figure(2);
stat=eval([operator, '(datan(flags<0.999, :), [25,50, 75])']);
patch([log10(sizes), log10(sort(sizes, 'descend'))], [stat(1, :), stat(3, length(stat):-1:1)], 0.5*[1,1,1]);
%hold on;
plot(log10(sizes), stat(2, :), 'k--', 'linewidth', 2);
ylabel([label], 'fontsize', 12, 'fontweight', 'bold');
xlabel('D_p, nm' , 'fontsize', 12, 'fontweight', 'bold');
set(gca, 'yscale', 'log');
title([strtrim(station), ' ', moment,' ', startdate, '-' enddate], 'fontsize', 12, 'fontweight', 'bold' );
%saveas(2, [savename '_2'], 'tif');

saveas(2, [savename '_02'], extension);



figure(3);

%axes(handles.plotax3);
%hold off
datan(flags==0.999, :)=NaN;
colormap jet(250);
pcolor(dates, sizes, log10(abs(datan))');
shading interp;
xlabel(['Days from ', startdate], 'fontsize', 12);
ylabel('D_p, nm' , 'fontsize', 12);
set(gca, 'yscale', 'log');
cb=colorbar();
caxis([0, 4]);
set(cb, 'ytick', [0:1:4], 'yticklabel', {'1', '10', '100', '1000', '10000'});
ylabel(cb, 'dN/dlogD_p, cm^{-3}', 'fontsize', 12)
%saveas(3, [savename '_3'], 'tif');
saveas(3, [savename '_03'], extension);

end

% --- Executes on button press in monthly_butt.
if ( iresolu == 3 )
monthly_average();
end

if ( iresolu == 4 )
diurnal_average();
end


% --- Executes on button press in Source_butt.

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (itraj == 1)
%  !Source_history.exe
  !/home/saeed/DB_ITM/EBAS_routine/matlab_web/source_history.exe 'integrated';

  SOURCE_GUI;

  fid1=fopen('/home/saeed/DB_ITM/EBAS_routine/matlab_web/Full_INTEGRAL_TEMP.dat');

  station=fgets(fid1);
  startdate=fgets(fid1);
  enddate=fgets(fid1);


  [paramtype,count]=fscanf(fid1, '%10c/n');
  sizerange=str2num(fgets(fid1));
  resolution=str2num(fgets(fid1));
  moment=strtrim(fgets(fid1));
  nobins=str2num(fgets(fid1));
  fclose all;



  momstat=dlmread('/home/saeed/DB_ITM/EBAS_routine/matlab_web/Full_INTEGRAL_TEMP.dat', '', 7,0);
  momstat(momstat(:, 5)>1e5, 5:8)=NaN;
  dates=datenum(momstat(1:size(momstat, 1), 1), momstat(1:size(momstat, 1), 2), momstat(1:size(momstat, 1), 3), momstat(1:size(momstat, 1), 4), 0,0)-datenum(momstat(1, 1)-1, 12, 31, 0,0,0);

  integral_parameters( momstat, sizerange, dates, startdate );

end
end