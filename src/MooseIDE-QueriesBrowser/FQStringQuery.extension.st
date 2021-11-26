Extension { #name : #FQStringQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQStringQuery class >> canBeConfigured [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQStringQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQStringQuery class >> miPresenterClass [

	^ MiStringQueryPresenter
]
