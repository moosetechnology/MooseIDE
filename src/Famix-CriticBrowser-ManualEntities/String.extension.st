Extension { #name : 'String' }

{ #category : '*Famix-CriticBrowser-ManualEntities' }
String >> asValuable [

	^ (Smalltalk compiler evaluate: self) ifNil: [ self asValidSelector ]
]
