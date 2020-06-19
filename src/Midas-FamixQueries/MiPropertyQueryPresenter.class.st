Class {
	#name : #MiPropertyQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'properties',
		'comparators',
		'valueInput'
	],
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiPropertyQueryPresenter class >> addFirstParameterToLayout: defaultLayout [
	defaultLayout add: #firstParameter width: 0
]

{ #category : #'as yet unclassified' }
MiPropertyQueryPresenter >> comparators [
	^ secondParameter presenterAt: #comparators
]

{ #category : #initialization }
MiPropertyQueryPresenter >> initializePresenters [
	firstParameter := self newNullPresenter hide.
	self initializeSecondParameter
]

{ #category : #initialization }
MiPropertyQueryPresenter >> initializeSecondParameter [
	secondParameter := query availableProperties
		ifEmpty: [ self noParameterMessage: 'property' ]
		ifNotEmpty: [ (self instantiate: SpDynamicPresenter)
				layout: self class layout;
				presenterAt: #properties put: self propertiesDropList;
				yourself ]
]

{ #category : #'as yet unclassified' }
MiPropertyQueryPresenter >> properties [
	^ secondParameter presenterAt: #properties
]

{ #category : #initialization }
MiPropertyQueryPresenter >> propertiesDropList [
	^ self newDropList
		items: self query availableProperties;
		display: [ :prop | prop asString ];
		whenSelectedItemChangedDo: [ :prop | 
			self query property: prop.
			self notifyQueryChanged ];
		yourself
]

{ #category : #'as yet unclassified' }
MiPropertyQueryPresenter >> valueInput [
	^ secondParameter presenterAt: #valueInput
]
