Class {
	#name : #MiPropertyQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'propertyDropList',
		'valueInputField',
		'comparatorDropList'
	],
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #layout }
MiPropertyQueryPresenter >> buildLayout [

	self layout: self class layout
]

{ #category : #initialization }
MiPropertyQueryPresenter >> initializePresenters [

	propertyDropList := query availableProperties
		                    ifEmpty: [ self noParameterMessage: 'property' ]
		                    ifNotEmpty: [ self newPropertyDropList ]
]

{ #category : #initialization }
MiPropertyQueryPresenter >> newPropertyDropList [
	^ self newDropList
		items: self query availableProperties;
		display: [ :prop | prop asString ];
		whenSelectedItemChangedDo: [ :prop | 
			self query property: prop.
			self notifyQueryChanged ];
		yourself
]
