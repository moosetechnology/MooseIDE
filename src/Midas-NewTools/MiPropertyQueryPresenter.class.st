"
Abstract superclass for Query presenters on some properties of the entities

have:
- query: from superclass, contains an FQAbstractQuery
- propertyDropList: list of entities properties on which the query can be applied.
  For example for a FQStringQuery, possible properties will include `#name`.
  The list is obtained from the `query`
- comparatorDropList: list of comparator methods applicable on a property for this query.
  For example for a FQNumericQuery, possible properties will include `#<`, or `#=`.
  The list is obtained from the `query`
- valueInputField: a field to enter a value with which to compare
"
Class {
	#name : #MiPropertyQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'propertyDropList',
		'valueInputField',
		'comparatorDropList'
	],
	#category : #'Midas-NewTools-Queries Browser configuration'
}

{ #category : #layout }
MiPropertyQueryPresenter >> buildLayout [

	self layout: self class layout
]

{ #category : #'as yet unclassified' }
MiPropertyQueryPresenter >> comparatorDropList [
	^ comparatorDropList
]

{ #category : #initialization }
MiPropertyQueryPresenter >> initializePresenters [

	super initializePresenters.

	query availableProperties
		ifNotEmpty: [
			propertyDropList := self newPropertyDropList.
			comparatorDropList := self newComparatorDropList.
			valueInputField := self newValueInputField ]
		ifEmpty: [ 
			propertyDropList := self noParameterMessage: 'property'.
			comparatorDropList := self newNullPresenter.
			valueInputField := self newNullPresenter ]
]

{ #category : #initialization }
MiPropertyQueryPresenter >> newComparatorDropList [

	^ self newDropList
		  items: self query class comparators;
		  display: [ :prop | prop asString ];
		  whenSelectedItemChangedDo: [ :prop | 
			  self query comparator: prop.
			  self notifyQueryChanged ];
		  yourself
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

{ #category : #initialization }
MiPropertyQueryPresenter >> newValueInputField [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
MiPropertyQueryPresenter >> propertyDropList [
	^ propertyDropList
]

{ #category : #'as yet unclassified' }
MiPropertyQueryPresenter >> valueInputField [
	^ valueInputField
]
