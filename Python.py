## Import Kaggle Libraries 
!pip install kaggle
import kaggle


## Downloading the dataset using kaggle api
!kaggle datasets download ankitbansal06/retail-orders -f orders.csv

## Unzipping the dataset from the zipfile
import zipfile
zip_ref=zipfile.ZipFile('orders.csv.zip')
zip_ref.extractall() # extract file to directory
zip_ref.close() # close file

## Reading the dataset
import pandas as pd
df=pd.read_csv('orders.csv')
df.head(20)

df['Ship Mode'].unique()

#read data from the file and handle null values
df=pd.read_csv('Orders.csv',na_values=['Not Available', 'unknown'])

df['Ship Mode'].unique()

df.describe()

df.columns

#rename columns names ..make them lower case and replace space with underscore
df.rename(columns={'Order Id':'order_id', 'Order Date':'order_date'}) #this is not a best practice to solve one by one

df.columns=df.columns.str.lower()
df.columns

df.columns=df.columns.str.replace(' ','_')
df.columns

df.head(20)

## Derive new columns - discount, sale price and profit 
df['discount']=df['list_price']*(df['discount_percent']/100)
df.columns

df['sale_price']=df['list_price']-df['discount']
df.columns

df.head(20)

df['profit']=df['sale_price']-df['cost_price']
df.head()

## Convert Order date from object-data type to date-time
pd.to_datetime(df['order_date'],format="%Y-%m-%d")
# df['order_date']=pd.to_datetime(df['order_date'])
df

df.dtypes

## Drop Cost price, List price and Discount percent columns
df.drop(columns=['cost_price','list_price','discount_percent'],inplace=True)
df

## Import the preprocessed table into SQL server 
import sqlalchemy as sal
engine = sal.create_engine('mssql://DESKTOP-OJ6GF4H\SQLEXPRESS/master?driver=ODBC+DRIVER+17+FOR+SQL+SERVER')
conn=engine.connect()

df.to_sql('order_detail', con=conn , index=False, if_exists = 'replace')  #This is not a good practice as it takes lot os space, so better create a table and then append all the data into that from this table

df.to_sql('order_detail', con=conn , index=False, if_exists = 'append')
