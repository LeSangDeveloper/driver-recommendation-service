from typing import List, Union
import jsonpickle.ext.pandas as jsonpickle_pandas
from jsonpickle.pickler import Pickler
from fastapi import FastAPI
from pydantic import BaseModel
import pandas as pd
from feast import FeatureStore
from datetime import datetime

jsonpickle_pandas.register_handlers()

app = FastAPI()

class OfflineRequestBody(BaseModel):
    driverIds: List[int]
    datetimes: List[Union[str, datetime]]

    def convert_datetimes(self):
        self.datetimes = [datetime.fromisoformat(dt) if isinstance(dt, str) else dt for dt in self.datetimes]

class OnlineRequestBody(BaseModel):
    driverId: int

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.post("/get-offline-features")
def post_offline_store(request_body: OfflineRequestBody):
    request_body.convert_datetimes()  # Convert all datetime strings to datetime objects

    store = FeatureStore(repo_path="./feature_repo")
    entity_df = pd.DataFrame.from_dict(
        {
            "driver_id": request_body.driverIds,
            "datetime": request_body.datetimes,
        }
    )
    training_df = store.get_historical_features(
        entity_df=entity_df, features=["driver_stats:acc_rate", "driver_stats:conv_rate"],
    ).to_df()
    p = Pickler()
    response = p.flatten(training_df)
    return response

@app.post("/get-online-features")
def post_online_store(request_body: OnlineRequestBody):
    store = FeatureStore(repo_path="./feature_repo")
    features = store.get_online_features(
        features=[
            "driver_stats:acc_rate",
            "driver_stats:conv_rate"
        ],
        entity_rows=[
        {
            "driver_id": request_body.driverId,
        }
    ],
    ).to_dict(include_event_timestamps=True)
    return features
