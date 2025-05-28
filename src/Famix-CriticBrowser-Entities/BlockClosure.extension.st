Extension { #name : #BlockClosure }

{ #category : #'*Famix-CriticBrowser-Entities' }
BlockClosure >> asCBContextFilterIn: aFamixCBContext [

	aFamixCBContext contextFilterBlock: self
]
