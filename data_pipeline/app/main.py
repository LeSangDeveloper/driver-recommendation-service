from typing import Union
import jsonpickle.ext.pandas as jsonpickle_pandas
from jsonpickle.pickler import Pickler
from fastapi import FastAPI
import pandas as pd
from feast import FeatureStore 
from datetime import datetime

jsonpickle_pandas.register_handlers()

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.post("/offline-store")
def post_offline_store():
    store = FeatureStore(repo_path="./feature_repo")
    entity_df = pd.DataFrame.from_dict(
        {
            "driver_id":     [1001, 1002, 1003],
            "datetime": [    
                datetime(2022, 5, 11, 11, 59, 59),
                datetime(2022, 6, 12, 1, 15, 10),
                datetime.now(),
            ],
        }
    )
    training_df = store.get_historical_features(
        entity_df=entity_df, features=["driver_stats:acc_rate", "driver_stats:conv_rate"],
    ).to_df()
    p = Pickler()
    # convert the dataframe to a json-compatible dictionary
    response = p.flatten(entity_df)
    # let FastAPI do the json conversion
    return response
