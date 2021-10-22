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
		'newBusNameInput',
		'browser',
		'addBusButton'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #specs }
MiBusesPopup class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: #busesList withConstraints: [ :constraints | 
			  constraints
				  height: 100;
				  width: 250 ];
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: #newBusNameInput expand: true;
				   add: #addBusButton withConstraints: [ :constraints | 
					   constraints
						   height: self inputTextHeight;
						   width: self iconWidth ];
				   yourself);
		  yourself
]

{ #category : #initialization }
MiBusesPopup >> followNewBus [
	| newBus |
	newBusNameInput text ifEmpty: [ ^ self ].

	"Create new bus"
	newBus := self application busNamed: newBusNameInput text.

	"Follow new bus"
	browser isMiBrowser
		ifTrue: [ browser followBus: newBus ].

	"Update"
	newBusNameInput clearContent.
	busesList items: self application buses
]

{ #category : #initialization }
MiBusesPopup >> initializeBusesList [

	busesList := self newTable.
	busesList hideColumnHeaders.
	browser isMiBrowser ifTrue: [ 
		busesList addColumn: ((SpCheckBoxTableColumn evaluated: [ :bus | 
					  browser buses includes: bus ])
				 onActivation: [ :bus | browser followBus: bus ];
				 onDeactivation: [ :bus | browser unfollowBus: bus ];
				 width: 20) ].
	busesList
		addColumn: (SpStringTableColumn evaluated: #name);
		items: self application buses
]

{ #category : #initialization }
MiBusesPopup >> initializePresenters [

	super initializePresenters.
	self initializeBusesList.
	newBusNameInput := self newTextInput
		                   placeholder: 'New bus name';
		                   whenSubmitDo: [ self followNewBus ];
		                   bindKeyCombination: $s meta
		                   toAction: [ self followNewBus ];
		                   yourself.
	addBusButton := self newButton
		                iconName: #smallAdd;
		                action: [ self followNewBus ];
		                yourself
]

{ #category : #'accessing model' }
MiBusesPopup >> setModelBeforeInitialization: aBrowser [
	browser := aBrowser
]
