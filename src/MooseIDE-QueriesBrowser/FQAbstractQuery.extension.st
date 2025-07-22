Extension { #name : 'FQAbstractQuery' }

{ #category : '*MooseIDE-QueriesBrowser' }
FQAbstractQuery >> allChildren [

	^ self allChildren: OrderedCollection new
]

{ #category : '*MooseIDE-QueriesBrowser' }
FQAbstractQuery >> allChildren: aCollection [

	children do: [ :each | 
		aCollection add: each.
		each allChildren: aCollection ].
	^ aCollection
]

{ #category : '*MooseIDE-QueriesBrowser' }
FQAbstractQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ self isAbstract not and: [
		  numberOfQueriesInPresenter >= self minimumQueriesSize ]
]

{ #category : '*MooseIDE-QueriesBrowser' }
FQAbstractQuery class >> minimumQueriesSize [

	self subclassResponsibility
]

{ #category : '*MooseIDE-QueriesBrowser' }
FQAbstractQuery class >> threeWayCompareTo: anotherQuery [

	self minimumQueriesSize = anotherQuery minimumQueriesSize ifTrue: [
		^ self label threeWayCompareTo: anotherQuery label ].

	^ self minimumQueriesSize threeWayCompareTo:
		  anotherQuery minimumQueriesSize
]
