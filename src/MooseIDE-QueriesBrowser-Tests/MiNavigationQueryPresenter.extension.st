Extension { #name : #MiNavigationQueryPresenter }

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiNavigationQueryPresenter >> associationsButton [

	self flag: 'Do not use this accessor. This is only for the tests'.
	^ associationsButton
]

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiNavigationQueryPresenter >> associationsList [

	^ associationsList
]

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiNavigationQueryPresenter >> directionDropList [

	self flag: 'Do not use this accessor. This is only for the tests'.
	^ directionDropList
]
