Extension { #name : #MiQueryListItemPresenter }

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiQueryListItemPresenter >> parentQuery [

	^ parentQuery
]

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiQueryListItemPresenter >> parentQuery: aQuery [

	self flag: 'Do not use this accessor. This is only for the tests'.
	parentQuery := aQuery
]

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiQueryListItemPresenter >> queryTypesDropList [

	self flag: 'Do not use this accessor. This is only for the tests'.
	^ queryTypesDropListPresenter
]
