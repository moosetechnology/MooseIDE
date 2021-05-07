Class {
	#name : #QueryConfigurationPresenterFactory,
	#superclass : #Object,
	#category : #'Midas-NewQueriesBrowser-Factories'
}

{ #category : #'instance creation' }
QueryConfigurationPresenterFactory class >> configureQuery: aQuery forOwnerPresenter: anOwnerPresenter [

	^ (self presenterClassForQuery: aQuery class)
		  owner: anOwnerPresenter
		  on: aQuery
]

{ #category : #'instance creation' }
QueryConfigurationPresenterFactory class >> presenterClassForQuery: aQuery [

	| presenterClass |
	aQuery = FQNavigationQuery ifTrue: [ 
		presenterClass := MiNavigationQueryPresenter ].
	aQuery = FQBooleanQuery ifTrue: [ 
		presenterClass := MiBooleanQueryPresenter ].
	aQuery = FQNumericQuery ifTrue: [ 
		presenterClass := MiNumericQueryPresenter ].
	aQuery = FQStringQuery ifTrue: [ 
		presenterClass := MiStringQueryPresenter ].
	aQuery = FQScopeQuery ifTrue: [ 
		presenterClass := MiScopeQueryPresenter ].
	aQuery = FQTypeQuery ifTrue: [ 
		presenterClass := MiTypeQueryPresenter ].
	presenterClass ifNil: [ 
		self error:
			'You should aQuery has to be an instance of a valid query class. See the query classes of this method to see which query classes are valid.' ].
	^ presenterClass
]
