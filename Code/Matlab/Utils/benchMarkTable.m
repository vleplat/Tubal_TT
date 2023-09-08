function benchMarkTable(runtime,PSNR,RMSE,ERGAS,SAM,UIQI)

% Mean and std computation 
tablecpu_mean=mean(runtime,2);
tablecpu_std=std(runtime,0,2);
tablepsnr_mean=mean(PSNR,2);
tablepsnr_std=std(PSNR,0,2);
tablermse_mean=mean(RMSE,2);
tableprmse_std=std(RMSE,0,2);
tableergas_mean=mean(ERGAS,2);
tablepergas_std=std(ERGAS,0,2);
tablesam_mean=mean(SAM,2);
tablesam_std=std(SAM,0,2);
tableuiqi_mean=mean(UIQI,2);
tableuiqi_std=std(UIQI,0,2);

%% Table : Average performance of the algorithms 



% Display table
columnHeaders = {'Time (sec.)','PSNR','RMSE','ERGAS','SAM','UIQUI'};
algo={'Tubal TT','TT'};
[nb_algo,~]=size(PSNR);
i=1;
rowHeaders{i} = sprintf('Ideal value');
tableData{i,1} = sprintf('0');
tableData{i,2} = sprintf('Inf');
tableData{i,3} = sprintf('0');
tableData{i,4} = sprintf('0');
tableData{i,5} = sprintf('0');
tableData{i,6} = sprintf('1');

for i=1:nb_algo
    rowHeaders{i+1} = sprintf(algo{i});
    tableData{i+1,1} = sprintf('%.2f %s %.2f', tablecpu_mean(i), 177, tablecpu_std(i));
    tableData{i+1,2} = sprintf('%.2f %s %.2f', tablepsnr_mean(i), 177, tablepsnr_std(i));
    tableData{i+1,3} = sprintf('%.2f %s %.2f', tablermse_mean(i), 177, tableprmse_std(i));
    tableData{i+1,4} = sprintf('%.2f %s %.2f', tableergas_mean(i), 177, tablepergas_std(i));
    tableData{i+1,5} = sprintf('%.2f %s %.2f', tablesam_mean(i), 177, tablesam_std(i));
    tableData{i+1,6} = sprintf('%.2f %s %.2f', tableuiqi_mean(i), 177, tableuiqi_std(i));

end

% Create the table and display it.
hTable = uitable();
% Apply the row and column headers.
set(hTable, 'RowName', rowHeaders);
set(hTable, 'ColumnName', columnHeaders);
% Display the table of values.
set(hTable, 'data', tableData);
% Size the table.
set(hTable, 'units', 'normalized');
set(hTable, 'Position', [.1 .1 .8 .8]);
set(hTable, 'ColumnWidth', {110, 110, 110, 110, 110, 110});
set(gcf,'name','Average Performance of the algorithms','numbertitle','off')
end%EOF
