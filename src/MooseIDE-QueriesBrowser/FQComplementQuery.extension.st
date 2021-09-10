Extension { #name : #FQComplementQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQComplementQuery class >> isComplementQuery [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQComplementQuery class >> miPresenterClass [

	^ MiNegationQueryPresenter
]
