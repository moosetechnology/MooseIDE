Class {
	#name : #MiBusesPopup,
	#superclass : #MiPresenter,
	#instVars : [
		'busesList',
		'newBusNameInput',
		'browser',
		'addBusButton',
		'acceptButton'
	],
	#category : #'Midas-Core-Browser'
}

{ #category : #specs }
MiBusesPopup class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		borderWidth: 5;
		add:
			(SpBoxLayout newVertical
				spacing: 5;
				add: #busesList
					height: (MiApplication current buses size + 1) * self labelHeight;
				add:
					(SpBoxLayout newHorizontal
						add: #newBusNameInput;
						add: #addBusButton width: self iconWidth;
						yourself)
					height: self inputTextHeight;
				add: #acceptButton;
				yourself)
			width: 250;
		yourself
]

{ #category : #api }
MiBusesPopup >> dismiss [
	self owner dismiss
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
		yourself.
	addBusButton := self newButton
		iconName: #smallAdd;
		action: [ self followNewBus ];
		yourself.
	acceptButton := self newButton
		iconName: #smallOk;
		label: 'Accept';
		action: [ owner dismiss ];
		yourself
]

{ #category : #'accessing model' }
MiBusesPopup >> setModelBeforeInitialization: aBrowser [
	browser := aBrowser
]
