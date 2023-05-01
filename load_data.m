function [EGML, EGMR, BSM, ECG_finder] = load_data(BSM_dir, EGM_LEFT_dir, EGM_RIGHT_dir, bsm_node_1, bsm_node_2)

    % load BSPM, LA and RA data
    bsm = loadmat(BSM_dir);
    EGML = loadmat(EGM_LEFT_dir);
    EGMR = loadmat(EGM_RIGHT_dir);
    WCG = (bsm(:, 129) + bsm(:, 130) + bsm(:, 131))/3;  % Wilson-Central-Ground
    BSM = bsm(:, 1:128) - WCG(:,1); % Subtracting the Ground value from the 128 Body Surface Data
    clear bsm;
    
    % II Channel
    ECG_finder = BSM(:, bsm_node_1) - BSM(:, bsm_node_2);

end
