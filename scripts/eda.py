import pandas as pd

file_path = "data/raw/2019-Oct.csv"

df = pd.read_csv(file_path, nrows=100_000)

print("\n===== DATASET SAMPLE =====")
print(df.head())

print("\n===== SHAPE =====")
print(df.shape)

print("\n===== COLUMNS =====")
print(df.columns.tolist())

print("\n===== DATA TYPES =====")
print(df.dtypes)

print("\n===== MISSING VALUES =====")
print(df.isnull().sum())

print("\n===== EVENT TYPES =====")
print(df["event_type"].value_counts())

print("\n===== UNIQUE USERS =====")
print(df["user_id"].nunique())

print("\n===== UNIQUE SESSIONS =====")
print(df["user_session"].nunique())

print("\n===== BASIC STATISTICS =====")
print(df.describe(include="all"))