Extension { #name : #FQResultSizeQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQResultSizeQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ numberOfQueriesInPresenter > 0
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQResultSizeQuery class >> miPresenterClass [

	^ MiResultSizeQueryPresenter
]
