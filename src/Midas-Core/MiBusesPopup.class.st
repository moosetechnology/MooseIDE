Class {
	#name : #MiBusesPopup,
	#superclass : #SpPresenter,
	#instVars : [
		'busesList',
		'newBusNameInput',
		'okButton',
		'browser'
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
						add: #okButton width: self iconWidth;
						yourself)
					height: self inputTextHeight;
				yourself)
			width: 250;
		yourself
]

{ #category : #initialization }
MiBusesPopup >> followNewBus [
	newBusNameInput text
		ifNotEmpty: [ :name | browser followBus: (browser application busNamed: name) ].
	self owner dismiss
]

{ #category : #initialization }
MiBusesPopup >> initializePresenters [
	super initializePresenters.
	busesList := self newList
		items: browser application buses asOrderedCollection;
		display: #name;
		whenSelectionChangedDo: [ :selection | 
			browser followBus: selection selectedItem.
			self owner dismiss ];
		yourself.
	newBusNameInput := self newTextInput
		placeholder: 'New bus name';
		whenSubmitDo: [ self followNewBus ];
		yourself.
	okButton := self newButton
		iconName: #smallOk;
		action: [ self followNewBus ];
		yourself
]

{ #category : #'accessing model' }
MiBusesPopup >> setModelBeforeInitialization: aBrowser [
	browser := aBrowser
]
