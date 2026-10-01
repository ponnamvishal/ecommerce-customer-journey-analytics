import pandas as pd

FILE_PATH = "data/raw/2019-Oct.csv"
CHUNK_SIZE = 500_000

total_rows = 0
zero_price_rows = 0
negative_price_rows = 0

missing_users = 0
missing_sessions = 0

duplicate_rows = 0

event_counts = {}
zero_price_events = {}

daily_events = {}

for chunk in pd.read_csv(
    FILE_PATH,
    chunksize=CHUNK_SIZE
):

    total_rows += len(chunk)

    # Price checks
    zero_prices = chunk["price"] == 0
    negative_prices = chunk["price"] < 0

    zero_price_rows += zero_prices.sum()
    negative_price_rows += negative_prices.sum()

    # Event types among zero-price records
    zero_events = chunk.loc[zero_prices, "event_type"].value_counts()

    for event_type, count in zero_events.items():
        zero_price_events[event_type] = (
            zero_price_events.get(event_type, 0) + count
        )

    # Missing identifiers
    missing_users += chunk["user_id"].isna().sum()
    missing_sessions += chunk["user_session"].isna().sum()

    # Duplicate rows within each chunk
    duplicate_rows += chunk.duplicated().sum()

    # Daily event count
    chunk["event_time"] = pd.to_datetime(
        chunk["event_time"],
        utc=True
    )

    daily = chunk["event_time"].dt.date.value_counts()

    for day, count in daily.items():
        daily_events[day] = (
            daily_events.get(day, 0) + count
        )

print("\n==============================")
print("DATA QUALITY REPORT")
print("==============================")

print(f"\nTotal Rows: {total_rows:,}")

print(f"\nZero Price Rows: {zero_price_rows:,}")
print(f"Negative Price Rows: {negative_price_rows:,}")

print("\nZero Price Events:")
for event_type, count in zero_price_events.items():
    print(f"  {event_type}: {count:,}")

print(f"\nMissing User IDs: {missing_users:,}")
print(f"Missing Session IDs: {missing_sessions:,}")

print(f"\nDuplicate Rows Detected Within Chunks: {duplicate_rows:,}")

print("\nDaily Event Counts:")
for day, count in sorted(daily_events.items()):
    print(f"  {day}: {count:,}")

print("\n==============================")
print("DATA QUALITY CHECK COMPLETE")
print("==============================")