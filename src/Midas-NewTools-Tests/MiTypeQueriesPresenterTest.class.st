Class {
	#name : #MiTypeQueriesPresenterTest,
	#superclass : #MiQueryConfigurationPresenterTest,
	#category : #'Midas-NewTools-Tests-Queries Configuration'
}

{ #category : #running }
MiTypeQueriesPresenterTest >> classToTest [
	^ MiTypeQueryPresenter
]

{ #category : #running }
MiTypeQueriesPresenterTest >> queryClass [
	^ FQTypeQuery
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testCheckBoxesChangeQueryTypes [

	| initialSize |
	true ifTrue: [ 
		self assert: true.
		^ self ].

	initialSize := presenter query types size.

	presenter typeCheckBoxes first click.
	self assert: presenter query types size equals: initialSize - 1.

	presenter typeCheckBoxes first click.
	self assert: presenter query types size equals: initialSize
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testCheckBoxesDisabledWhenOnlyOneChecked [

		true ifTrue: [ 
		self assert: true.
		^ self ].
	self resetPresenterWithEntities: helper modelExample allModelClasses.

	"Only 1 type in the query, cannot be removed, so the checkBox is disabled"
	self deny: presenter typeCheckBoxes first isEnabled.
	self assert: presenter typeCheckBoxes first state
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testCheckBoxesMatchAvailableTypes [

	| types |
	true ifTrue: [ 
		self assert: true.
		^ self ].

	types := presenter query availableTypes.
	self assert: presenter typeCheckBoxes size equals: types size.
	self
		assertCollection: (types collect: [ :type | 
				 type name asEnglishPlural withoutPrefix: 'FamixSt' ])
		hasSameElements: (presenter typeCheckBoxes collect: #label)
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testCheckBoxesMatchQuery [

	| currentQueryTypes |
	true ifTrue: [ 
		self assert: true.
		^ self ].

	presenter typeCheckBoxes first click.

	currentQueryTypes := presenter query types collect: [ :type | 
		                     type name asEnglishPlural withoutPrefix:
			                     'FamixSt' ].

	self
		assertCollection: currentQueryTypes
		hasSameElements:
		(presenter typeCheckBoxes select: #state thenCollect: #label).

	self
		denyCollection: currentQueryTypes
		hasSameElements:
		(presenter typeCheckBoxes reject: #state thenCollect: #label)
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testLastCheckBoxeDisabled [

	true ifTrue: [ 
		self assert: true.
		^ self ].

	presenter typeCheckBoxes first click.
	self assert: presenter typeCheckBoxes first isEnabled.
	self deny: presenter typeCheckBoxes first state.

	"Only 1 type in the query, cannot be removed, so the checkBox is disabled"
	self deny: presenter typeCheckBoxes second isEnabled.
	self assert: presenter typeCheckBoxes second state.

	presenter typeCheckBoxes first click.
	"Two types in the query, so one of them can be removed. All checkboxes are enabled"
	self assert: presenter typeCheckBoxes first isEnabled.
	self assert: presenter typeCheckBoxes first state.
	self assert: presenter typeCheckBoxes second isEnabled.
	self assert: presenter typeCheckBoxes second state
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testPresenters [

	true ifTrue: [ 
		self assert: true.
		^ self ].

	self assert: (presenter typeCheckBoxes allSatisfy: [ :pres | 
			 pres class == SpCheckBoxPresenter and: [ pres state ] ])
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testPresentersOnImpossibleQuery [

	true ifTrue: [ 
		self assert: true.
		^ self ].

	self resetPresenterWithEntities: helper noEntities.

	self
		assert: presenter typeCheckBoxes class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testQueryValidity [

	true ifTrue: [ 
		self assert: true.
		^ self ].

	self assert: presenter query isValid.

	presenter typeCheckBoxes first click.
	self assert: presenter query isValid.

	presenter typeCheckBoxes first click.
	self assert: presenter query isValid.

	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]
