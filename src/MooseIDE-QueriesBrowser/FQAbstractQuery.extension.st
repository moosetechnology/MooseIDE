Extension { #name : #FQAbstractQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQAbstractQuery >> allChildren [

	^ self allChildren: OrderedCollection new
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQAbstractQuery >> allChildren: aCollection [

	children do: [ :each | 
		aCollection add: each.
		each allChildren: aCollection ].
	^ aCollection
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQAbstractQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ false
]
