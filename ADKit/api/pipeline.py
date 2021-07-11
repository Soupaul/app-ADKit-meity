import pickle as pkl

class ML_Model:

    def __init__(self):
        self.load_pickle()
    
    def load_pickle(self):
        self.model = pkl.load(open("api/ml_assets/trained_model.pkl","rb"))

    def predict(self,feature_list):
        rObj = self.model.predict(feature_list)
        return rObj
