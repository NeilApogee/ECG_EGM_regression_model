% load BSPM, LA and RA data
dir = 'bspm and egm data\';
BSM = ['BSM_D_001_PRE_alligned.mat'; 'BSM_D_002_PRE_alligned.mat';...
    'BSM_D_003_PRE_alligned.mat'; 'BSM_D_004_PRE_alligned.mat';...
    'BSM_D_005_PRE_alligned.mat'; 'BSM_D_006_PRE_alligned.mat';...
    'BSM_D_007_PRE_alligned.mat'; 'BSM_D_008_PRE_alligned.mat';...
    'BSM_D_009_PRE_alligned.mat'; 'BSM_D_010_PRE_alligned.mat'];
LA = ['LA_D_001_PRE_alligned_VIR.mat'; 'LA_D_002_PRE_alligned_VIR.mat';...
    'LA_D_003_PRE_alligned_VIR.mat'; 'LA_D_004_PRE_alligned_VIR.mat';...
    'LA_D_005_PRE_alligned_VIR.mat'; 'LA_D_006_PRE_alligned_VIR.mat';...
    'LA_D_007_PRE_alligned_VIR.mat'; 'LA_D_008_PRE_alligned_VIR.mat';...
    'LA_D_009_PRE_alligned_VIR.mat'; 'LA_D_010_PRE_alligned_VIR.mat'];
RA = ['RA_D_001_PRE_alligned_VIR.mat'; 'RA_D_002_PRE_alligned_VIR.mat';...
    'RA_D_003_PRE_alligned_VIR.mat'; 'RA_D_004_PRE_alligned_VIR.mat';...
    'RA_D_005_PRE_alligned_VIR.mat'; 'RA_D_006_PRE_alligned_VIR.mat';...
    'RA_D_007_PRE_alligned_VIR.mat'; 'RA_D_008_PRE_alligned_VIR.mat';...
    'RA_D_009_PRE_alligned_VIR.mat'; 'RA_D_010_PRE_alligned_VIR.mat'];
bsm_node_1 = [53; 30; 53; 53; 53; 53; 53; 53; 53; 53];
bsm_node_2 = [1; 33; 1; 1; 1; 1; 1; 1; 1; 1];
patients = table(BSM, LA, RA, bsm_node_1, bsm_node_2);

Mean = [];
Rsquared = [];
Standard_deviation = [];
results = table(Mean, Rsquared, Standard_deviation);
for num = 1:10
    disp(num);
    [m, rs, std, model, y_test, y_pred] = regression_model_test(...
        strcat(dir, patients.BSM(num, 1:26)), strcat(dir, patients.LA(num, 1:29)),...
        strcat(dir, patients.RA(num, 1:29)), patients.bsm_node_1(num),...
        patients.bsm_node_2(num), 0, 0, 0);
    results.Mean(num) = m;
    results.Rsquared(num) = rs;
    results.Standard_deviation = std;
    models(num).model = model;
    models(num).value_compare = [y_test, y_pred];
    models(num).results = results(num,:);
    models(num).patient_data =  patients(num,:);
end

% Play sound
fs = 44100;  % Sampling frequency
duration = 2;  % Duration of the sound in seconds
f0 = 440;  % Frequency of the sine wave in Hz

% Generate a sine wave
t = 0:1/fs:duration-1/fs;
y = sin(2*pi*f0*t);

% Play the sound through the default audio device
sound(y, fs);