# Import dependencies
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score
from collections import defaultdict


# Load the dataset in a dataframe object and include only four features as mentioned
dataset=pd.read_csv("fraud_final.csv")
dataset= dataset.drop(['zipcodeOri','zipMerchant','step'] , axis=1)

# Data Preprocessing
sc = StandardScaler()
encoder_dict = defaultdict(LabelEncoder)

Y=dataset.iloc[:,-1].values
dataset.iloc[:,0:5].apply(lambda x: encoder_dict[x.name].fit(x))
labeled = dataset.iloc[:,0:5].apply(lambda x: encoder_dict[x.name].transform(x))
labeled['amount'] = dataset.iloc[:,5]
X = labeled.values
sc.fit(X[:,[5]])
X[:,[5]] = sc.transform(X[:,[5]])


dataset= dataset.drop(['fraud'] , axis=1)
print(dataset.head())


#Train and Test Data
X_train, X_test, y_train, y_test = train_test_split(X,Y,test_size=0.3,random_state=42)

# LIGHTGBM classifier
import lightgbm as lgb
train_data=lgb.Dataset(X_train,label=y_train)
param = {'num_leaves':100, 'objective':'binary','max_depth':7,'learning_rate':.05,'max_bin':500}
param['metric'] = ['auc', 'binary_logloss']
num_round=500
lgbm=lgb.train(param,train_data,num_round)
y_pred=lgbm.predict(X_test)
#rounding the values
y_pred=y_pred.round(0)
#converting from float to integer
y_pred=y_pred.astype(int)

accuracy_lgbm = accuracy_score(y_test,y_pred.round())
print(accuracy_lgbm)

accuracy = accuracy_score(y_test,y_pred.round())
print("Accuracy = "+str(accuracy))

# Save your model
import joblib
joblib.dump(lgbm, 'model.pkl')
print("Model dumped!")

def encoder_dictonary():
    return encoder_dict

def standard_scaler():
    return sc

from joblib import dump, load
dump(sc, 'std_scaler.bin', compress=True)



# Load the model that you just saved
classifier = joblib.load('model.pkl')

# Saving the data columns from training

model_columns = dataset.columns
print("Columns = "+ str(model_columns))
joblib.dump(model_columns, 'model_columns.pkl')
print("Models columns dumped!")