Class {
	#name : #MiTypeSelectionPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'list',
		'parentQuery'
	],
	#category : #'MooseIDE-QueriesBrowser-Widgets'
}

{ #category : #initialize }
MiTypeSelectionPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: list;
		  yourself
]

{ #category : #initialize }
MiTypeSelectionPresenter >> initializePresenters [

	list := self instantiate: SpFilteringSelectableListPresenter.

	list
		display: [ :item | parentQuery labelFor: item ];
		items: parentQuery query availableTypes
]

{ #category : #accessing }
MiTypeSelectionPresenter >> items [

	^ list items
]

{ #category : #accessing }
MiTypeSelectionPresenter >> items: types [

	list items: types
]

{ #category : #accessing }
MiTypeSelectionPresenter >> okButton [ 

	^self owner buttons detect: [ :button | button label = 'Ok' ]
]

{ #category : #accessing }
MiTypeSelectionPresenter >> selectItems: items [

	list selectItems: items
]

{ #category : #accessing }
MiTypeSelectionPresenter >> selectedItems [

	^ list selectedItems
]

{ #category : #initialize }
MiTypeSelectionPresenter >> setModelBeforeInitialization: aQueryTypePresenter [

	parentQuery := aQueryTypePresenter
]
