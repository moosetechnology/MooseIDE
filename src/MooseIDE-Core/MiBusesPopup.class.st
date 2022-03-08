"
I am a presenter showing the instantiated buses in the MiApplication.

In browsers, I am used to select which buses to follow --> I show checkboxes to allow selection.
In MooseIDE Overview, I show all the existing buses --> I only show the buses names, no need for checkboxes.

This difference is now implemented as a conditional, we should do it smarter.

The buses are shown in a SpTable. We don't have action on selection for now. An issue is filled on Spec to add this behavior (https://github.com/pharo-spec/Spec/issues/1122).
"
Class {
	#name : #MiBusesPopup,
	#superclass : #MiPresenter,
	#instVars : [
		'busesList',
		'browser'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #specs }
MiBusesPopup class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #busesList;
		  yourself
]

{ #category : #initialization }
MiBusesPopup >> followNewBusNamed: aName [

	| newBus |
	"Create new bus"
	newBus := self application busNamed: aName.

	"Follow new bus"
	browser isMiBrowser ifTrue: [ browser followBus: newBus ].

	"Update"
	busesList filterInputPresenter clearContent.
	busesList items: self application buses
]

{ #category : #initialization }
MiBusesPopup >> initializePresenters [

	busesList := self newSelectableListForPopoverExtent: 125 @ 150.
	busesList display: [ :bus | bus name ].
	busesList items: self application buses.
	busesList selectItems: browser buses.

	busesList
		onActivation: [ :bus | bus ifNotNil: [ browser followBus: bus ] ];
		onDeactivation: [ :bus | bus ifNotNil: [ browser unfollowBus: bus ] ].

	self useTextInputForBusCreation
]

{ #category : #'accessing - model' }
MiBusesPopup >> setModelBeforeInitialization: aBrowser [
	browser := aBrowser
]

{ #category : #initialization }
MiBusesPopup >> useTextInputForBusCreation [

	"Do not filter but use text input for bus creation"

	busesList filterInputPresenter placeholder: '+ New bus'.

	busesList itemFilter: [ :each :pattern | 
		true "We do not want to filter anything" ].

	busesList filterInputPresenter whenSubmitDo: [ 
		self followNewBusNamed: busesList filterInputPresenter text.
		busesList filterInputPresenter clearContent.
		busesList
			items: self application buses;
			selectItems: browser buses copy ]
]
