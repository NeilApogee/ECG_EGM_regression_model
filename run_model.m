% load BSPM, LA and RA data
dir = 'Put in the directory where the files are saved';
BSM = 'Put in the name of the body surface file in .mat format';
LA = 'Put in the name of the left atrium file in .mat format';
RA = 'Put in the name of the right atrium file in .mat format';
bsm_node_1 = 53; % change this to the integer for the first node
bsm_node_2 = 1; % change this to the integer for the first node
patients = table(BSM, LA, RA, bsm_node_1, bsm_node_2);

Mean = [];
Rsquared = [];
Standard_deviation = [];
results = table(Mean, Rsquared, Standard_deviation);
num = 1;

% Train model and predict
[m, rs, std, model, y_test, y_pred] = regression_model_test(...
    strcat(dir, patients.BSM(num, 1:26)), strcat(dir, patients.LA(num, 1:29)),...
    strcat(dir, patients.RA(num, 1:29)), patients.bsm_node_1(num),...
    patients.bsm_node_2(num), 0, 0, 0);
results.Mean(num) = m;
results.Rsquared(num) = rs;
results.Standard_deviation = std;

% Save model and result to a structure
models(num).model = model;
models(num).value_compare = [y_test, y_pred];
models(num).results = results(num,:);
models(num).patient_data =  patients(num,:);
