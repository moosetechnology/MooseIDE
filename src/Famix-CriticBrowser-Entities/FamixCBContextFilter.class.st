Class {
	#name : 'FamixCBContextFilter',
	#superclass : 'Object',
	#category : 'Famix-CriticBrowser-Entities',
	#package : 'Famix-CriticBrowser-Entities'
}

{ #category : 'converting' }
FamixCBContextFilter >> asCBContextFilterIn: aFamixCBContext [

	aFamixCBContext customContextFilter: self
]

{ #category : 'evaluating' }
FamixCBContextFilter >> value: aCollection [

	self subclassResponsibility
]
