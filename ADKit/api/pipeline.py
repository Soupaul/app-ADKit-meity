import pickle as pkl

class ML_Model:

    def __init__(self):
        self.load_pickle()
        self.bay()
        self.clf()
        self.elc()
        self.gbr()
        self.lgb()
        self.palmbay()
        self.palmclf()
        self.palmelc()
        self.palmgbr()
        self.palmlgb()
    
    def load_pickle(self):
        self.model = pkl.load(open("api/ml_assets/trained_model.pkl","rb"))
    
    def bay(self):
        self.baymodel = pkl.load(open("api/ml_assets/bay.pkl","rb"))

    def clf(self):
        self.clfmodel = pkl.load(open("api/ml_assets/clf.pkl","rb"))

    def elc(self):
        self.elcmodel = pkl.load(open("api/ml_assets/elc.pkl","rb"))

    def gbr(self):
        self.gbrmodel = pkl.load(open("api/ml_assets/gbr.pkl","rb"))

    def lgb(self):
        self.lgbmodel = pkl.load(open("api/ml_assets/lgb.pkl","rb"))

    def predict(self,feature_list):
        rObj = self.model.predict(feature_list)
        return rObj

    def predictbay(self,feature_list):
        rObj = self.baymodel.predict(feature_list)
        return rObj

    def predictclf(self,feature_list):
        rObj = self.clfmodel.predict(feature_list)
        return rObj

    def predictelc(self,feature_list):
        rObj = self.elcmodel.predict(feature_list)
        return rObj

    def predictgbr(self,feature_list):
        rObj = self.gbrmodel.predict(feature_list)
        return rObj
    
    def predictlgb(self,feature_list):
        rObj = self.lgbmodel.predict(feature_list)
        return rObj

    def palmbay(self):
        self.palmbaymodel = pkl.load(open("api/ml_assets/palm/bay.pkl","rb"))

    def palmclf(self):
        self.palmclfmodel = pkl.load(open("api/ml_assets/palm/clf.pkl","rb"))

    def palmelc(self):
        self.palmelcmodel = pkl.load(open("api/ml_assets/palm/elc.pkl","rb"))

    def palmgbr(self):
        self.palmgbrmodel = pkl.load(open("api/ml_assets/palm/gbr.pkl","rb"))

    def palmlgb(self):
        self.palmlgbmodel = pkl.load(open("api/ml_assets/palm/lgb.pkl","rb"))

    def predictpalmbay(self,feature_list):
        rObj = self.palmbaymodel.predict(feature_list)
        return rObj

    def predictpalmclf(self,feature_list):
        rObj = self.palmclfmodel.predict(feature_list)
        return rObj

    def predictpalmelc(self,feature_list):
        rObj = self.palmelcmodel.predict(feature_list)
        return rObj

    def predictpalmgbr(self,feature_list):
        rObj = self.palmgbrmodel.predict(feature_list)
        return rObj
    
    def predictpalmlgb(self,feature_list):
        rObj = self.palmlgbmodel.predict(feature_list)
        return rObj
