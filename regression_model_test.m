function [mean_, rsquared, standard_deviation, model, y_test, y_pred] = regression_model_test(BSM_dir, EGM_LEFT_dir, EGM_RIGHT_dir, bsm_node_1, bsm_node_2, verbose, draw_graph, play_sound)
    
    % Load your data
    [EGML, EGMR, ~, ECG_finder] = load_data(BSM_dir, EGM_LEFT_dir, EGM_RIGHT_dir, bsm_node_1, bsm_node_2);
    
    % Split the data into predictors (X) and response (y)
    x = [EGML EGMR];
    y = ECG_finder;
    
    % Set the proportion of the data to use for testing
    test_proportion = 0.2;
    
    % Create a cross-validation partition with random splitting
    cv = cvpartition(size(x,1),'HoldOut',test_proportion);
    
    % Split the data into training and testing sets
    x_train = x(cv.training,:);
    y_train = y(cv.training,:);
    x_test = x(cv.test,:);
    y_test = y(cv.test,:);
    
    % Train the ensemble model
    t = templateTree('MaxNumSplits',5);
    model = fitrensemble(x_train, y_train,'Method','LSBoost',...
        'NumLearningCycles',100,'Learners',t);
    
    % Predict on the test data
    y_pred = predict(model,x_test);
    
    % Evaluate the performance of the model
    mean_ = mean(abs(y_test-y_pred));
    rsquared = corr(y_test,y_pred).^2;
    standard_deviation = std(y_test-y_pred);

    if verbose >= 1
        % Plot graph
        fprintf('Mean: %.3f\n', mean_);
        fprintf('STD: %.3f\n', standard_deviation);
        fprintf('R-squared: %.3f\n', rsquared);
    end
    
    if draw_graph >= 1
        % Plot the predictions compared to the real values
        plot(y_test, 'DisplayName', 'Real ECG')
        hold on
        plot(y_pred, 'DisplayName', 'Predicted ECG')
        hold off
        legend
    end

    if play_sound >= 1
        fs = 44100;  % Sampling frequency
        duration = 2;  % Duration of the sound in seconds
        f0 = 440;  % Frequency of the sine wave in Hz
        
        % Generate a sine wave
        t = 0:1/fs:duration-1/fs;
        y = sin(2*pi*f0*t);
        
        % Play the sound through the default audio device
        sound(y, fs);
    end
end
