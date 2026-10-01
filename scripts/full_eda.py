import pandas as pd

FILE_PATH = "data/raw/2019-Oct.csv"
CHUNK_SIZE = 500_000

total_rows = 0
unique_users = set()
unique_sessions = set()

event_counts = {}
category_missing = 0
brand_missing = 0

min_time = None
max_time = None

price_sum = 0
price_min = None
price_max = None
price_count = 0


for chunk in pd.read_csv(
    FILE_PATH,
    chunksize=CHUNK_SIZE
):
    total_rows += len(chunk)

    # Unique users and sessions
    unique_users.update(chunk["user_id"].unique())
    unique_sessions.update(chunk["user_session"].dropna().unique())

    # Event counts
    counts = chunk["event_type"].value_counts()

    for event_type, count in counts.items():
        event_counts[event_type] = (
            event_counts.get(event_type, 0) + count
        )

    # Missing values
    category_missing += chunk["category_code"].isna().sum()
    brand_missing += chunk["brand"].isna().sum()

    # Convert timestamps
    chunk["event_time"] = pd.to_datetime(
        chunk["event_time"],
        utc=True
    )

    chunk_min = chunk["event_time"].min()
    chunk_max = chunk["event_time"].max()

    if min_time is None or chunk_min < min_time:
        min_time = chunk_min

    if max_time is None or chunk_max > max_time:
        max_time = chunk_max

    # Price statistics
    price_sum += chunk["price"].sum()
    price_count += chunk["price"].count()

    chunk_price_min = chunk["price"].min()
    chunk_price_max = chunk["price"].max()

    if price_min is None or chunk_price_min < price_min:
        price_min = chunk_price_min

    if price_max is None or chunk_price_max > price_max:
        price_max = chunk_price_max


print("\n==============================")
print("FULL DATASET EDA")
print("==============================")

print(f"\nTotal Rows: {total_rows:,}")

print(f"\nUnique Users: {len(unique_users):,}")

print(f"\nUnique Sessions: {len(unique_sessions):,}")

print("\nEvent Counts:")
for event_type, count in sorted(event_counts.items()):
    print(f"  {event_type}: {count:,}")

print("\nMissing Values:")
print(f"  category_code: {category_missing:,}")
print(f"  brand: {brand_missing:,}")

print("\nDate Range:")
print(f"  Start: {min_time}")
print(f"  End:   {max_time}")

print("\nPrice:")
print(f"  Minimum: {price_min}")
print(f"  Maximum: {price_max}")
print(f"  Average: {price_sum / price_count:.2f}")

print("\n==============================")
print("EDA COMPLETE")
print("==============================")