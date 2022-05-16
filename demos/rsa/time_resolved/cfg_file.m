%% Advacned configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'RSA';
cfg.location = pwd;

% Condition indentifiers:
cfg.study.conditionIdentifier{1,1} = 'val_name_exp';
cfg.study.conditionIdentifier{1,2} = 'val_name_att';
cfg.study.conditionIdentifier{1,3} = 'val_face_exp';
cfg.study.conditionIdentifier{1,4} = 'val_face_att';
cfg.study.conditionIdentifier{1,5} = 'inv_name_exp';
cfg.study.conditionIdentifier{1,6} = 'inv_name_att';
cfg.study.conditionIdentifier{1,7} = 'inv_face_exp';
cfg.study.conditionIdentifier{1,8} = 'inv_face_att';

% Data paths:
cfg.study.dataPaths{1,1} = '/Users/David/Desktop/att_exp_eeg/conditions/target_val_name_exp/';
cfg.study.dataPaths{1,2} = '/Users/David/Desktop/att_exp_eeg/conditions/target_val_name_att/';
cfg.study.dataPaths{1,3} = '/Users/David/Desktop/att_exp_eeg/conditions/target_val_face_exp/';
cfg.study.dataPaths{1,4} = '/Users/David/Desktop/att_exp_eeg/conditions/target_val_face_att/';
cfg.study.dataPaths{1,5} = '/Users/David/Desktop/att_exp_eeg/conditions/target_inv_name_exp/';
cfg.study.dataPaths{1,6} = '/Users/David/Desktop/att_exp_eeg/conditions/target_inv_name_att/';
cfg.study.dataPaths{1,7} = '/Users/David/Desktop/att_exp_eeg/conditions/target_inv_face_exp/';
cfg.study.dataPaths{1,8} = '/Users/David/Desktop/att_exp_eeg/conditions/target_inv_face_att/';

% Data files:
cfg.study.dataFiles{1,1} = {'1.mat','2.mat','3.mat','4.mat','5.mat','6.mat','7.mat','8.mat','9.mat','10.mat','11.mat','12.mat','13.mat','14.mat','15.mat','16.mat','17.mat','18.mat','19.mat','20.mat','21.mat','22.mat','23.mat','24.mat','25.mat','26.mat','27.mat','28.mat','29.mat','30.mat','31.mat','32.mat','33.mat','34.mat','35.mat','36.mat','37.mat','38.mat','39.mat','40.mat','41.mat','42.mat','43.mat','44.mat','45.mat','46.mat','47.mat','48.mat'};
cfg.study.dataFiles{1,2} = {'1.mat','2.mat','3.mat','4.mat','5.mat','6.mat','7.mat','8.mat','9.mat','10.mat','11.mat','12.mat','13.mat','14.mat','15.mat','16.mat','17.mat','18.mat','19.mat','20.mat','21.mat','22.mat','23.mat','24.mat','25.mat','26.mat','27.mat','28.mat','29.mat','30.mat','31.mat','32.mat','33.mat','34.mat','35.mat','36.mat','37.mat','38.mat','39.mat','40.mat','41.mat','42.mat','43.mat','44.mat','45.mat','46.mat','47.mat','48.mat'};
cfg.study.dataFiles{1,3} = {'1.mat','2.mat','3.mat','4.mat','5.mat','6.mat','7.mat','8.mat','9.mat','10.mat','11.mat','12.mat','13.mat','14.mat','15.mat','16.mat','17.mat','18.mat','19.mat','20.mat','21.mat','22.mat','23.mat','24.mat','25.mat','26.mat','27.mat','28.mat','29.mat','30.mat','31.mat','32.mat','33.mat','34.mat','35.mat','36.mat','37.mat','38.mat','39.mat','40.mat','41.mat','42.mat','43.mat','44.mat','45.mat','46.mat','47.mat','48.mat'};
cfg.study.dataFiles{1,4} = {'1.mat','2.mat','3.mat','4.mat','5.mat','6.mat','7.mat','8.mat','9.mat','10.mat','11.mat','12.mat','13.mat','14.mat','15.mat','16.mat','17.mat','18.mat','19.mat','20.mat','21.mat','22.mat','23.mat','24.mat','25.mat','26.mat','27.mat','28.mat','29.mat','30.mat','31.mat','32.mat','33.mat','34.mat','35.mat','36.mat','37.mat','38.mat','39.mat','40.mat','41.mat','42.mat','43.mat','44.mat','45.mat','46.mat','47.mat','48.mat'};
cfg.study.dataFiles{1,5} = {'1.mat','2.mat','3.mat','4.mat','5.mat','6.mat','7.mat','8.mat','9.mat','10.mat','11.mat','12.mat','13.mat','14.mat','15.mat','16.mat','17.mat','18.mat','19.mat','20.mat','21.mat','22.mat','23.mat','24.mat','25.mat','26.mat','27.mat','28.mat','29.mat','30.mat','31.mat','32.mat','33.mat','34.mat','35.mat','36.mat','37.mat','38.mat','39.mat','40.mat','41.mat','42.mat','43.mat','44.mat','45.mat','46.mat','47.mat','48.mat'};
cfg.study.dataFiles{1,6} = {'1.mat','2.mat','3.mat','4.mat','5.mat','6.mat','7.mat','8.mat','9.mat','10.mat','11.mat','12.mat','13.mat','14.mat','15.mat','16.mat','17.mat','18.mat','19.mat','20.mat','21.mat','22.mat','23.mat','24.mat','25.mat','26.mat','27.mat','28.mat','29.mat','30.mat','31.mat','32.mat','33.mat','34.mat','35.mat','36.mat','37.mat','38.mat','39.mat','40.mat','41.mat','42.mat','43.mat','44.mat','45.mat','46.mat','47.mat','48.mat'};
cfg.study.dataFiles{1,7} = {'1.mat','2.mat','3.mat','4.mat','5.mat','6.mat','7.mat','8.mat','9.mat','10.mat','11.mat','12.mat','13.mat','14.mat','15.mat','16.mat','17.mat','18.mat','19.mat','20.mat','21.mat','22.mat','23.mat','24.mat','25.mat','26.mat','27.mat','28.mat','29.mat','30.mat','31.mat','32.mat','33.mat','34.mat','35.mat','36.mat','37.mat','38.mat','39.mat','40.mat','41.mat','42.mat','43.mat','44.mat','45.mat','46.mat','47.mat','48.mat'};
cfg.study.dataFiles{1,8} = {'1.mat','2.mat','3.mat','4.mat','5.mat','6.mat','7.mat','8.mat','9.mat','10.mat','11.mat','12.mat','13.mat','14.mat','15.mat','16.mat','17.mat','18.mat','19.mat','20.mat','21.mat','22.mat','23.mat','24.mat','25.mat','26.mat','27.mat','28.mat','29.mat','30.mat','31.mat','32.mat','33.mat','34.mat','35.mat','36.mat','37.mat','38.mat','39.mat','40.mat','41.mat','42.mat','43.mat','44.mat','45.mat','46.mat','47.mat','48.mat'};

%% REPRESENTATIONAL SIMILARITY ANALYSIS:

cfg.rsa.distance = 'pearson';
cfg.rsa.analysis = 'corr';
cfg.rsa.trialwise = false;


%% VECTORIZED THEORETHICAL MODELS:

                     %|          %|        %|      %|    %|  %| %| 
stimu = [ 0 1 1 0 0 1 1 1 1 0 0 1 1 0 1 1 0 0 1 1 0 0 0 1 1 1 1 0];
block = [ 1 0 1 0 1 0 1 1 0 1 0 1 0 1 0 1 0 1 1 0 1 0 1 0 1 1 0 1];
valid = [ 0 0 0 1 1 1 1 0 0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0];

cfg.rsa.tmodels{1}.id  = 'stimuli_model';
cfg.rsa.tmodels{1}.mdl = squareform(stimu);

cfg.rsa.tmodels{2}.id  = 'block_model';
cfg.rsa.tmodels{2}.mdl = squareform(block);

cfg.rsa.tmodels{3}.id  = 'validity_model';
cfg.rsa.tmodels{3}.mdl = squareform(valid);


%% FEATURE EXTRACTION:

cfg.feature = 'voltage';

% cfg.feature = 'voltage'  - Raw voltage as feature.
% cfg.feature = 'envelope' - Power evelope as feature.

cfg.powenv.method = 'analytic';
cfg.powenv.uplow  = 'upper';
cfg.powenv.length = 5;

% cfg.powenv.method = 'analytic' - Envelope using the analytic signal.
% cfg.powenv.method = 'peak'     - Peak envelopes.

% cfg.powenv.uplow = 'upper' - Select upper envelope.
% cfg.powenv.uplow = 'lower' - Select lower envelope.

%% TRIAL AVERAGE:

cfg.trialaver.flag     = true;
cfg.trialaver.ntrials  = 5;
cfg.trialaver.order    = 'rand';

% cfg.trialaver.order = 'rand' - Random order.
% cfg.trialaver.order = 'seq'  - Secuential order.

%% BALANCED DATASETS:

cfg.classsize.match = false;

%% DATA NORMALIZATION:

% cfg.normdata = 0 - raw data
% cfg.normdata = 1 - z-score (across features)
% cfg.normdata = 2 - z-score (across time)
% cfg.normdata = 3 - z-score (across trials)
% cfg.normdata = 4 - std_nor (across trials)

cfg.normdata = 0; 

%% DATA SMOOTHING:

% cfg.smoothdata.method = 'none'   - Data smooth disabled.
% cfg.smoothdata.method = 'moving' - Moving average method.

cfg.smoothdata.method   = 'moving';
cfg.smoothdata.window   = 5;

%% ANALYSIS TIMING:

cfg.tm.tpstart   = -500;
cfg.tm.tpend     = 2000;
cfg.tm.tpsteps   = 1;

%% EXTRA CONFIGURATION:

cfg.classmodel.tempgen = false;
cfg.classmodel.parcomp = true;

%% PERMUTATION TEST

cfg.stats.flag   = 0;
cfg.stats.nper   = 10;
cfg.stats.nperg  = 1e4;
cfg.stats.pgroup = 99.9;
cfg.stats.pclust = 99.9;
cfg.stats.tails  = 2;
cfg.stats.shownulldis = 1;
