Extension { #name : #FQRelationQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQRelationQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQRelationQuery class >> miPresenterClass [

	^ MiRelationQueryPresenter
]
