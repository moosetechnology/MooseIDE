Class {
	#name : 'MiQueriesModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'entities',
		'rootQuery',
		'selectedQuery'
	],
	#category : 'MooseIDE-QueriesBrowser-Model',
	#package : 'MooseIDE-QueriesBrowser',
	#tag : 'Model'
}

{ #category : 'actions' }
MiQueriesModel >> clearQueries [

	self rootQuery children removeAll.
	self selectedQuery: self rootQuery
]

{ #category : 'accessing' }
MiQueriesModel >> entities [

	^ entities ifNil: [ #(  ) ]
]

{ #category : 'accessing' }
MiQueriesModel >> entities: anObject [

	entities := anObject
]

{ #category : 'testing' }
MiQueriesModel >> hasSettings [

	^ false
]

{ #category : 'initialization' }
MiQueriesModel >> initialize [

	rootQuery := FQRootQuery new.
	selectedQuery := rootQuery
]

{ #category : 'accessing' }
MiQueriesModel >> miSelectedItem [

	entities ifNotNil: [ ^ entities ].
	^ self selectedQueryResult
]

{ #category : 'as yet unclassified' }
MiQueriesModel >> queriesOfType: aFamixQueryClass [

	^ self rootQuery allChildren select: [ :query |
		  query isKindOf: aFamixQueryClass ]
]

{ #category : 'removing' }
MiQueriesModel >> removeChild: childToRemove fromParent: aParent [

	(aParent children includes: childToRemove) ifTrue: [ 
		aParent removeChild: childToRemove.
		^ self ].
	aParent children do: [ :aChild | 
		self removeChild: childToRemove fromParent: aChild ]
]

{ #category : 'removing' }
MiQueriesModel >> removeQuery: aQuery [

	self removeChild: aQuery fromParent: self rootQuery
]

{ #category : 'initialization' }
MiQueriesModel >> resetEntities [

	entities := nil
]

{ #category : 'initialization' }
MiQueriesModel >> resetRootQueryForEntities: receivedEntities [

	self rootQuery
		resetResult;
		input: receivedEntities;
		name: receivedEntities first mooseModel name.
	self selectedQuery: self rootQuery
]

{ #category : 'accessing' }
MiQueriesModel >> rootQuery [

	^ rootQuery
]

{ #category : 'accessing' }
MiQueriesModel >> selectEntities: aMooseObject [

	aMooseObject isMooseEntity ifTrue: [ entities := aMooseObject ].
	aMooseObject isEmpty ifFalse: [ entities := aMooseObject ]
]

{ #category : 'accessing' }
MiQueriesModel >> selectedQuery [

	^ selectedQuery ifNil: [ selectedQuery := rootQuery ]
]

{ #category : 'accessing' }
MiQueriesModel >> selectedQuery: anObject [

	selectedQuery := anObject
]

{ #category : 'as yet unclassified' }
MiQueriesModel >> selectedQueryResult [

	^ selectedQuery result
]
