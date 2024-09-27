"
I am a presenter showing the instantiated buses in the MiApplication.

In browsers, I am used to select which buses to follow --> I show checkboxes to allow selection.
In MooseIDE Overview, I show all the existing buses --> I only show the buses names, no need for checkboxes.

This difference is now implemented as a conditional, we should do it smarter.

The buses are shown in a SpTable. We don't have action on selection for now. An issue is filled on Spec to add this behavior (https://github.com/pharo-spec/Spec/issues/1122).
"
Class {
	#name : #MiBusesPopup,
	#superclass : #SpFilteringSelectableListPresenter,
	#instVars : [
		'busesList',
		'browser'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #initialization }
MiBusesPopup >> createNewBusNamed: aName [

	| newBus |
	"Create new bus"
	newBus := self application busNamed: aName.

	"Follow new bus"
	browser followBus: newBus.

	"Update"
	self filterInputPresenter clearContent.
	self items: self application buses.
	self selectItem: newBus
]

{ #category : #initialization }
MiBusesPopup >> initialize [

	super initialize.
	self
		addStyle: 'busesList';
		display: #name;
		items: self application buses;
		selectItems: browser buses copy;
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

	self filterInputPresenter placeholder: '+ New bus'.

	self itemFilter: [ :each :pattern |
		true "We do not want to filter anything" ].

	self filterInputPresenter whenSubmitDo: [ :busName |
		self createNewBusNamed: busName.
		self filterInputPresenter clearContent.
		self items: self application buses ]
]
