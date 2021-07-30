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
		  borderWidth: 5;
		  spacing: 5;
		  add: #busesList withConstraints: [ :constraints | 
			  constraints
				  height: MiApplication current buses size + 1 * self labelHeight;
				  width: 250 ];
		  add: (SpBoxLayout newLeftToRight
				   add: #newBusNameInput expand: true;
				   add: #addBusButton width: self iconWidth;
				   yourself)
		  height: self inputTextHeight;
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
