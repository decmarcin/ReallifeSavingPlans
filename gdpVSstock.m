%% Some real life savings plans compared to "GDP" investing
% Marcin Dec (m.dec@grape.org.pl) 2020

close all
clear all
global fredDATAannS1
fileff=load('database.mat');
fredDATAannS1=fileff.fredDATAannS1;


%%
cpirate=fredDATAannS1.CPIRATE;
gdpnomrate=fredDATAannS1.GDPNOMRATE;
stockrate=fredDATAannS1.WIL5000rate;
avgcpirate=mean(cpirate-1);
avggdpnomrate=mean(gdpnomrate-1);
avgstockrate=mean(stockrate-1);
stdcpirate=std(cpirate-1);
stdgdpnomrate=std(gdpnomrate-1);
stdstockrate=std(stockrate-1);

[f,xi] =   ksdensity(stockrate-1); 
[f2,xi2] = ksdensity(gdpnomrate-1); 
[f3,xi3] = ksdensity(cpirate-1); 

fig=figure('Renderer', 'painters', 'Position',[10 10 1200 500]);
area(xi,f,'LineStyle', 'none', 'FaceColor', 'r', 'FaceAlpha', 0.3)

hold on
area(xi2,f2,'LineStyle', 'none', 'FaceColor', 'b', 'FaceAlpha', 0.3)

grid
xline(avgstockrate,'r', 'LineWidth', 2, 'LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Label', strcat('\mu_{wil}=',num2str(round(avgstockrate,3))))
xline(avgstockrate+stdstockrate,':r',  'LineWidth', 1.5, 'LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Label', strcat('\mu+\sigma=',num2str(round(avgstockrate+stdstockrate,3))))
xline(avgstockrate+2*stdstockrate,':r', 'LineWidth', 1, 'LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Label', strcat('\mu+2\sigma=',num2str(round(avgstockrate+2*stdstockrate,3))))
xline(avgstockrate+3*stdstockrate,':r', 'LineWidth', 0.5,'LabelVerticalAlignment','middle', 'LabelHorizontalAlignment','center','Label', strcat('\mu+3\sigma=',num2str(round(avgstockrate+3*stdstockrate,3))))
xline(avgstockrate-stdstockrate,':r',  'LineWidth', 1.5,'LabelVerticalAlignment','middle', 'LabelHorizontalAlignment','center','Label', strcat('\mu-\sigma=',num2str(round(avgstockrate-stdstockrate,3))))
xline(avgstockrate-2*stdstockrate,':r', 'LineWidth', 1, 'LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Label', strcat('\mu-2\sigma=',num2str(round(avgstockrate-2*stdstockrate,3))))
xline(avgstockrate-3*stdstockrate,':r', 'LineWidth', 0.5,'LabelVerticalAlignment','middle', 'LabelHorizontalAlignment','center','Label', strcat('\mu-3\sigma=',num2str(round(avgstockrate-3*stdstockrate,3))))

xline(avggdpnomrate, 'b', 'LineWidth', 2, 'LabelVerticalAlignment','top', 'LabelHorizontalAlignment','center','Label', strcat('\mu_{gdp}=',num2str(round(avggdpnomrate,3))))
xline(avggdpnomrate+stdgdpnomrate,':b',  'LineWidth', 1.5, 'LabelVerticalAlignment','top', 'LabelHorizontalAlignment','center','Label', strcat('\mu+\sigma=',num2str(round(avggdpnomrate+stdgdpnomrate,3))))
xline(avggdpnomrate+2*stdgdpnomrate,':b', 'LineWidth', 1, 'LabelVerticalAlignment','top', 'LabelHorizontalAlignment','center','Label', strcat('\mu+2\sigma=',num2str(round(avggdpnomrate+2*stdgdpnomrate,3))))
xline(avggdpnomrate+3*stdgdpnomrate,':b', 'LineWidth', 0.5, 'LabelVerticalAlignment','top', 'LabelHorizontalAlignment','center','Label', strcat('\mu+3\sigma=',num2str(round(avggdpnomrate+3*stdgdpnomrate,3))))
xline(avggdpnomrate-stdgdpnomrate,':b',  'LineWidth', 1.5, 'LabelVerticalAlignment','top', 'LabelHorizontalAlignment','center','Label', strcat('\mu-\sigma=',num2str(round(avggdpnomrate-stdgdpnomrate,3))))
xline(avggdpnomrate-2*stdgdpnomrate,':b', 'LineWidth', 1, 'LabelVerticalAlignment','top', 'LabelHorizontalAlignment','center','Label', strcat('\mu-2\sigma=',num2str(round(avggdpnomrate-2*stdgdpnomrate,3))))
xline(avggdpnomrate-3*stdgdpnomrate,':b', 'LineWidth', 0.5, 'LabelVerticalAlignment','top', 'LabelHorizontalAlignment','center','Label', strcat('\mu-3\sigma=',num2str(round(avggdpnomrate-3*stdgdpnomrate,3))))

set(gca,'YTickLabel',[]);
ylim([0, 17])
xlim([-0.65, 0.65])
legend('Wilshire5000 annual total return','nominal GDP growth')%, 'CPI QoQ SA')


%% Simple savings plans matrix (no costs, no annuity problem, various investment horizons)

close all
list_of_years=fredDATAannS1.observation_date;

% sim params
max_yr_start_nbr=1;
share_income=0.15;


total_sav_matrix=NaN(49-max_yr_start_nbr,49-max_yr_start_nbr);
total_sav_matrix_gdp=NaN(49-max_yr_start_nbr,49-max_yr_start_nbr);


for y=max_yr_start_nbr:48
    
    for h=1:(48-y)

        total_sav=0;
        base_index=fredDATAannS1.CPIAUCSL(y+h);
        %disp([y,h])
        for i=y:y+h
            inv_value=share_income*fredDATAannS1.CPIAUCSL(i)/base_index;
            for j=i:y+h
                inv_value=inv_value*fredDATAannS1.WIL5000rate(j);
            end
            total_sav=total_sav+inv_value;
        end
        total_sav_matrix(y-max_yr_start_nbr+1, h+y-max_yr_start_nbr+1) = total_sav;
    end
end



fig2=figure('Renderer', 'painters', 'Position',[10 10 800 800]);
heatmap(list_of_years(max_yr_start_nbr: 48), list_of_years(max_yr_start_nbr: 48), total_sav_matrix, 'MissingDataLabel','', 'MissingDataColor', 'w', 'GridVisible','off', 'Colormap',jet)
xlabel('END year of regular savings')
ylabel('START year of regular savings')
title({'Saving regularly of 0.15 of annual income indexed to CPI.', ' Total compounded value of the saving account in terms of money at the end of savings period', 'Investing at Wilshire5000 Total return'})



for y=max_yr_start_nbr:48
    
    for h=1:(48-y)

        total_sav=0;

        base_index=fredDATAannS1.CPIAUCSL(y+h);
        
        for i=y:y+h
            inv_value=share_income*fredDATAannS1.CPIAUCSL(i)/base_index;
            for j=i:y+h
                inv_value=inv_value*fredDATAannS1.GDPNOMRATE(j);
            end
            total_sav=total_sav+inv_value;
        end
        total_sav_matrix_gdp(y-max_yr_start_nbr+1, h+y-max_yr_start_nbr+1) = total_sav;
        %total_sav_matrix_gdp(h+1, y-max_yr_start_nbr+1) = total_sav;
    end
end


fig3=figure('Renderer', 'painters', 'Position',[10 10 800 800]);
heatmap(list_of_years(max_yr_start_nbr: 48), list_of_years(max_yr_start_nbr: 48), total_sav_matrix_gdp, 'MissingDataLabel','', 'MissingDataColor', 'w', 'GridVisible','off', 'Colormap',jet)
xlabel('END year of regular savings')
ylabel('START year of regular savings')
title({'Saving regularly of 0.15 of annual income indexed to CPI.', ' Total compounded value of the saving account in terms of money at the end of savings period', 'Investing at Nominal GDP rate'})


fig4=figure('Renderer', 'painters', 'Position',[10 10 800 800]);
heatmap(list_of_years(max_yr_start_nbr: 48), list_of_years(max_yr_start_nbr: 48), total_sav_matrix-total_sav_matrix_gdp, 'MissingDataLabel','', 'MissingDataColor', 'w', 'GridVisible','off', 'Colormap',jet)
xlabel('END year of regular savings')
ylabel('START year of regular savings')
title({'Saving regularly of 0.15 of annual income indexed to CPI.', ' The difference of total compounded value of the saving accounts in terms of money at the end of savings period', 'Investing at Wilshire5000 Total return vs Nominal GDP rate'})

%% Estimation of annuity to be received every year for life_exp_scaling*life_exp_at65 years

close all

sav_rate=0.10;
am_fee=0.02;
load_fee=0.04;
change_over_fee=0.1;
change_over_fee_gdp=0;
rr_override=0.05;     % if ==0 then real rate from the period is taken
intra_gen_diff=3;

table_annu=zeros(17,6);

disp('replacement rates female - male  - on Wilshire500')
for t=1:17
    table_annu(t,1)=replacement(t, sav_rate, load_fee, am_fee, change_over_fee, 1, 1.5, 1, 0, intra_gen_diff);
    table_annu(t,2)=replacement(t, sav_rate, load_fee, am_fee, change_over_fee, 0, 1.5, 1, 0, intra_gen_diff);
end

disp('replacement rates female - male  - on GDP rates')
for t=1:17
    table_annu(t,3)=replacement(t, sav_rate, 0.00, 0.00, change_over_fee_gdp, 1, 1.5, 0, rr_override, intra_gen_diff);
    table_annu(t,4)=replacement(t, sav_rate, 0.00, 0.00, change_over_fee_gdp, 0, 1.5, 0, rr_override, intra_gen_diff);
end

disp('replacement rates female - male  - on Wilshire500, no costs')
for t=1:17
    table_annu(t,5)=replacement(t, sav_rate, 0, 0, 0, 1, 1.5, 1, 0, intra_gen_diff);
    table_annu(t,6)=replacement(t, sav_rate, 0, 0, 0, 0, 1.5, 1, 0, intra_gen_diff);
end



fig4=figure('Renderer', 'painters', 'Position',[10 10 800 500]);
plot(list_of_years(32:48), table_annu(:,1), 'k')
hold on
plot(list_of_years(32:48), table_annu(:,2), '--k')
plot(list_of_years(32:48), table_annu(:,3), 'r')
plot(list_of_years(32:48), table_annu(:,4), '--r')
plot(list_of_years(32:48), table_annu(:,5), 'b')
plot(list_of_years(32:48), table_annu(:,6), '--b')
grid
legend('A_{female}(Wilshire5000)','A_{male}(Wilshire5000)','A_{female}(GDP)','A_{male}(GDP)', 'A_{female}(Wilshire5000), no costs','A_{male}(Wilshire5000), no costs')
xlabel('retirement year')
title('Annuity estimation for different retirement vintages after 30(male) or 27(female) years of saving 10% of income')



%%
% =========================================================================
% =======================    functions used   =============================
% =========================================================================

function [rep]=replacement(yr_start, share_income, init_fee, am_fee, change_over_fee, woman_true, life_exp_scaling, wil500_true, rr, intra_gen_diff)

global fredDATAannS1

yr_end=yr_start+30;
base_index=fredDATAannS1.CPIAUCSL(yr_end);
life_exp_women=fredDATAannS1.life_exp_65_women(yr_end);
life_exp_men=fredDATAannS1.life_exp_65_men(yr_end);

if woman_true==1
    life_exp=life_exp_women*life_exp_scaling;
else
    life_exp=life_exp_men*life_exp_scaling;
end

if rr~=0
    rr10y=rr;
else
    rr10y=fredDATAannS1.RealRate10year(yr_end);
end

if intra_gen_diff~=0 && woman_true==1
    yr_start=yr_start+intra_gen_diff;
end


total_sav=0;
for i=yr_start:yr_end
    
    inv_value=share_income*(1-init_fee)*fredDATAannS1.CPIAUCSL(i)/base_index;
    
    for j=i:yr_end
        if wil500_true==1
            inv_value=inv_value*(1-am_fee)*fredDATAannS1.WIL5000rate(j);
        else
           inv_value=inv_value*(1-am_fee)*fredDATAannS1.GDPNOMRATE(j); 
        end
    end
    
    total_sav=total_sav+inv_value;
end

rep = pmt_from_sav(total_sav*(1-change_over_fee), life_exp, rr10y);

end





function [pmt]=pmt_from_sav(S_65, life_exp, rrate)
T=ceil(life_exp);
df_sums=0;
for t=1:T
    df_sums=df_sums+1/(1+rrate)^t;
end
pmt=S_65/df_sums;
end







