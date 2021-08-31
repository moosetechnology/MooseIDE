Extension { #name : #MiNewQueryCreationPresenter }

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiNewQueryCreationPresenter >> parentPresenter [

	self flag: 'Do not use this accessor. This is only for the tests'.
	^ parentPresenter
]

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiNewQueryCreationPresenter >> parentQuery: aQuery [

	self flag: 'Do not use this accessor. This is only for the tests'.
	parentQuery := aQuery
]

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiNewQueryCreationPresenter >> queryConfigurationPresenter [

	self flag: 'Do not use this accessor. This is only for the tests'.
	^ queryConfigurationPresenter
]
