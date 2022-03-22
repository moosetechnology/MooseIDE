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
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'propertyDropList',
		'valueInputField',
		'comparatorDropList',
		'process',
		'delayer'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #initialization }
MiPropertyQueryPresenter >> initializePresenters [

	delayer := InputProcessingWaiter new.

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
		  startWithoutSelection;
		  items: self query class comparators;
		  display: [ :prop | prop asString ];
		  whenSelectedItemChangedDo: [ :prop | 
			  self query comparator: prop.
			  self notifyQueryChanged ];
		  yourself
]

{ #category : #initialization }
MiPropertyQueryPresenter >> newPropertyDropList [

	| sortedProperties |
	sortedProperties := self query availableProperties sorted:
		                    #asString ascending.

	^ self newDropList
		  startWithoutSelection;
		  items: sortedProperties;
		  display: [ :prop | prop asString ];
		  whenSelectedItemChangedDo: [ :property | 
			  self updateProperty: property ];
		  yourself
]

{ #category : #initialization }
MiPropertyQueryPresenter >> newValueInputField [
	self subclassResponsibility 
]

{ #category : #actions }
MiPropertyQueryPresenter >> updateProperty: property [

	self query property: property.
	self notifyQueryChanged
]
