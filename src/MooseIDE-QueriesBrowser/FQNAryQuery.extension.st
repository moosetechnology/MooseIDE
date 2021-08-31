Extension { #name : #FQNAryQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQNAryQuery class >> isNAryQuery [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQNAryQuery class >> miPresenterClass [ 

	^ MiNAryQueryPresenter
]
