%%SVM LIBSVM

load('temp_allemesswerte.mat')

touchit_gui_data.notouch = temp_glasnotouch';
touchit_gui_data.onefinger = temp_glasfingeraussen';
touchit_gui_data.fivefingers = temp_glasdreifingeraussen';
touchit_gui_data.grasp = temp_glasfingereingetaucht';


trainData = [touchit_gui_data.notouch, touchit_gui_data.onefinger, touchit_gui_data.fivefingers , touchit_gui_data.grasp ];
trainData = trainData';

trainLabel =  ones(1,200);
trainLabel(1,:) = 1;
trainLabel(2,:) = 2;
trainLabel(3,:) = 3;
trainLabel(4,:) = 4;


testData = touchit_gui_data.grasp';
testLabel(1) = 5;

%multiclass one vs one
model = svmtrain(trainLabel, trainData, '-s 1 -c 1 -g 0.07 -b 1');

[predict_label, accuracy, prob_values] = svmpredict(testLabel, temp_glasfingeraussen, model, '-b 0'); % run the SVM model on the test data

disp(predict_label);

%multiclass... one vs all
 
NumofClass = 4;

model = cell(NumofClass,1);  % NumofClass = 4 in your case
for k = 1:NumofClass
    model{k} = svmtrain(double(trainLabel==k), trainData, '-c 1 -g 0.2 -b 1');
end

%% calculate the probability of different labels


pr = zeros(1,NumofClass);
for k = 1:NumofClass
    [~,~,p] = svmpredict(double(testLabel==k), testData, model{k}, '-b 1');
    pr(:,k) = p(:,model{k}.Label==1);    %# probability of class==k
end

%% your label prediction will be the one with highest probability:

[~,predctedLabel] = max(pr,[],2);

disp(predctedLabel);

% 1 2 3 4 
% s_data = [touchit_gui_data.notouch; touchit_gui_data.onefinger];
% s_class = ones(40,1);
% s_class(1:20) = 1;
% s_class(21:40) = 2;
% %notouch vs onefinger
% SVMstruct1 = svmtrain(s_data,s_class);

% s_data = [touchit_gui_data.onefinger; touchit_gui_data.notouch];
% SVMstruct2 = svmtrain(s_data,s_class);
%
% s_data = [touchit_gui_data.fivefingers; touchit_gui_data.notouch];
% SVMstruct3 = svmtrain(s_data,s_class);
%
% s_data = [touchit_gui_data.grasp; touchit_gui_data.notouch];
% SVMstruct4 = svmtrain(s_data,s_class);
%
% s_data = [touchit_gui_data.coverears; touchit_gui_data.notouch];
% SVMstruct5 = svmtrain(s_data,s_class);


% touchit_gui_data.model2 = SVMstruct2;
% touchit_gui_data.model3 = SVMstruct3;
% touchit_gui_data.model4 = SVMstruct4;
% touchit_gui_data.model5 = SVMstruct5;

% s_data = [touchit_gui_data.notouch; touchit_gui_data.onefinger; touchit_gui_data.fivefingers; touchit_gui_data.grasp; touchit_gui_data.coverears];
% s_class = ones(40,1);
% s_class(1:20) = 1;
% s_class(21:40) = 2;
% s_class(51:60) = 3;
% s_class(61:80) = 4;
% s_class(81:100) = 5;
%
% % SVMstruct = svmtrain(s_data,s_class,'linear','rbf');
%
% %save('temp.mat','touchit_gui_data');
%
% TrainingSet = s_data;
% GroupTrain = s_class;
% u=unique(GroupTrain);
% numClasses=length(u);
%
% %build models
% for k=1:numClasses
%     %Vectorized statement that binarizes Group
%     %where 1 is the current class and 0 is all other classes
%     G1vAll=(GroupTrain==u(k));
%     models(k) = svmtrain(TrainingSet,G1vAll);
% end
%
% touchit_gui_data.models = models;



% 
% 
% s_data = [touchit_gui_data.notouch; touchit_gui_data.onefinger; touchit_gui_data.fivefingers; touchit_gui_data.grasp];
% s_class = ones((training_samples+1)*5,1);
% s_class(1:training_samples+1) = 1;
% s_class(training_samples+2:(training_samples+1)*5) = 6;
% 
% SVMstruct1 = svmtrain(s_data, s_class);
% 
% touchit_gui_data.model1 = SVMstruct1;
% 
% s_data = [touchit_gui_data.onefinger; touchit_gui_data.notouch; touchit_gui_data.fivefingers; touchit_gui_data.grasp];
% s_class = ones((training_samples+1)*5,1);
% s_class(1:training_samples+1) = 2;
% s_class(training_samples+2:(training_samples+1)*5) = 6;
% 
% SVMstruct2 = svmtrain(s_data, s_class);
% 
% touchit_gui_data.model2 = SVMstruct2;
% 
% s_data = [touchit_gui_data.fivefingers; touchit_gui_data.onefinger; touchit_gui_data.notouch; touchit_gui_data.grasp];
% s_class = ones((training_samples+1)*5,1);
% s_class(1:training_samples+1) = 3;
% s_class(training_samples+2:(training_samples+1)*5) = 6;
% 
% SVMstruct3 = svmtrain(s_data, s_class);
% 
% touchit_gui_data.model3 = SVMstruct3;
% 
% s_data = [touchit_gui_data.grasp; touchit_gui_data.onefinger; touchit_gui_data.fivefingers; touchit_gui_data.notouch];
% s_class = ones((training_samples+1)*5,1);
% s_class(1:training_samples+1) = 4;
% s_class(training_samples+2:(training_samples+1)*5) = 6;
% 
% SVMstruct4 = svmtrain(s_data, s_class);
% 
% touchit_gui_data.model4 = SVMstruct4;
% 
% svmpredict
% 
% 
% 
% k1 = svmclassify(touchit_gui_data.model1,period_volt);
% 
% k2 = svmclassify(touchit_gui_data.model2,period_volt);
% 
% k3 = svmclassify(touchit_gui_data.model3,period_volt);
% 
% k4 = svmclassify(touchit_gui_data.model4,period_volt);





