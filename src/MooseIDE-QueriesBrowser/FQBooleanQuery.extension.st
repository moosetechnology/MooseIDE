Extension { #name : #FQBooleanQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQBooleanQuery class >> canBeConfigured [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQBooleanQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQBooleanQuery class >> miPresenterClass [

	^ MiBooleanQueryPresenter
]
