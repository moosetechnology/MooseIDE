Class {
	#name : #MiQueryConfigurationPresenterFactory,
	#superclass : #Object,
	#category : #'Midas-NewQueriesBrowser-Factories'
}

{ #category : #'instance creation' }
MiQueryConfigurationPresenterFactory class >> configureQuery: aQuery forOwnerPresenter: anOwnerPresenter [

	| presenter |
	aQuery class = FQNavigationQuery ifTrue: [ 
		presenter := MiNavigationQueryPresenter
			             owner: anOwnerPresenter
			             on: aQuery ].
	aQuery class = FQBooleanQuery ifTrue: [ 
		presenter := MiBooleanQueryPresenter
			             owner: anOwnerPresenter
			             on: aQuery ].
	aQuery class = FQNumericQuery ifTrue: [ 
		presenter := MiNumericQueryPresenter
			             owner: anOwnerPresenter
			             on: aQuery ].
	aQuery class = FQStringQuery ifTrue: [ 
		presenter := MiStringQueryPresenter
			             owner: anOwnerPresenter
			             on: aQuery ].
	aQuery class = FQScopeQuery ifTrue: [ 
		presenter := MiScopeQueryPresenter
			             owner: anOwnerPresenter
			             on: aQuery ].
	aQuery class = FQTypeQuery ifTrue: [ 
		presenter := MiTypeQueryPresenter owner: anOwnerPresenter on: aQuery ].
	presenter ifNil: [ Halt now ].
	^ presenter
]
