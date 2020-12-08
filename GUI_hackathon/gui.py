import tkinter as tk
from tkinter import ttk
import joblib
import pandas as pd
import model_ML
from joblib import dump, load

# Importing Objects used to encode models in main model
encoder_dict = model_ML.encoder_dictonary()
sc=load('std_scaler.bin')

# Importing ML Model
model = joblib.load("model.pkl")



global DF
global output
output=0
win = tk.Tk()
# background_image=tk.PhotoImage(file = "bravura.gif")
# background_label = tk.Label(win, image=background_image)
# background_label.place(x=0, y=0, relwidth=1, relheight=1)
win.title('Frud Predictions') 
win.geometry("500x300")

#Column 1 
customer=ttk.Label(win,text="CUSTOMER")
customer.grid(row=2,column=3,sticky=tk.W)
customer_var=tk.StringVar()
customer_entrybox=ttk.Entry(win,width=16,textvariable=customer_var)
customer_entrybox.grid(row=2,column=6)
#Column 2
age=ttk.Label(win,text="AGE")
age.grid(row=4,column=3,sticky=tk.W)
age_var=tk.StringVar()
age_entrybox=ttk.Entry(win,width=16,textvariable=age_var)
age_entrybox.grid(row=4,column=6)
#Column 3
gender=ttk.Label(win,text="GENDER")
gender.grid(row=6,column=3,sticky=tk.W)
gender_var=tk.StringVar()
gender_entrybox=ttk.Entry(win,width=16,textvariable=gender_var)
gender_entrybox.grid(row=6,column=6)
#Column 4
merchant=ttk.Label(win,text="MERCHANT")
merchant.grid(row=8,column=3,sticky=tk.W)
merchant_var=tk.StringVar()
merchant_entrybox=ttk.Entry(win,width=16,textvariable=merchant_var)
merchant_entrybox.grid(row=8,column=6)
#Column 5
category=ttk.Label(win,text="CATEGORY")
category.grid(row=10,column=3,sticky=tk.W)
category_var=tk.StringVar()
category_entrybox=ttk.Entry(win,width=16,textvariable=category_var)
category_entrybox.grid(row=10,column=6)
#Column 6
amount=ttk.Label(win,text="AMOUNT")
amount.grid(row=12,column=3,sticky=tk.W)
amount_var=tk.StringVar()
amount_entrybox=ttk.Entry(win,width=16,textvariable=amount_var)
amount_entrybox.grid(row=12,column=6)

import pandas as pd
DF = pd.DataFrame()
print(DF.shape)



def Output():
    DF = pd.DataFrame(columns=['customer', 'age', 'gender', 'merchant', 'category', 'amount'])
   
    CUSTOMER=customer_var.get()
    DF.loc[0,'customer']=CUSTOMER
    
    AGE=age_var.get()
    DF.loc[0,'age']=AGE
    
    GENDER=gender_var.get()
    DF.loc[0,'gender']=GENDER
    
    MERCHANT=merchant_var.get()
    DF.loc[0,'merchant']=MERCHANT
    
    CATEGORY=category_var.get()
    DF.loc[0,'category']=CATEGORY
   
    AMOUNT=amount_var.get()
    DF.loc[0,'amount']=AMOUNT
    print(DF.shape)

    print(DF)
    DB=DF
    #model_columns = joblib.load("model_columns.pkl") # Load "model_columns.pkl"
    #print ('Model columns loaded')
    print(DB)
    #query = pd.get_dummies(pd.DataFrame(DB))
    #print(query)
    label = DB.iloc[:,0:5].apply(lambda x: encoder_dict[x.name].transform(x))
    print(encoder_dict)
    print(label)
    print(sc)
    label['amount'] = DB.iloc[:,5]
    X = label.values
    print(X)
    X[:,[5]] = sc.transform(X[:,[5]])
    print(X)
    output = model.predict(X).round(0)
    print(output)
    if output==1:
        result='FRAUD!'
    elif output==0:
        result='NOT FRAUD!'
    print(output)
    #Predict_entrybox.delete(0, 'END')
    Predict_entrybox.insert(1, "                   ")
    Predict_entrybox.insert(1,str(result))


Predict_entrybox=ttk.Entry(win,width=16)
Predict_entrybox.grid(row=20,column=6)
Predict_button=ttk.Button(win,text="Predict",command=Output)
Predict_button.grid(row=20,column=3)
win.mainloop()