Class {
	#name : 'MiAbstractRadioButtonSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'selectedButton',
		'buttons'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'event handling' }
MiAbstractRadioButtonSettingPresenter >> activate: anItem [

	self subclassResponsibility
]

{ #category : 'adding' }
MiAbstractRadioButtonSettingPresenter >> addButton: aButton [

	self layout add: aButton
]

{ #category : 'adding' }
MiAbstractRadioButtonSettingPresenter >> addButton: button toRow: aBoxLayout [

	aBoxLayout add: button expand: false fill: false
]

{ #category : 'as yet unclassified' }
MiAbstractRadioButtonSettingPresenter >> beMultipleRows [
	"puts radioButtons on rows of up to 4 buttons (to the limit of 12 buttons)
	 tries to put same number of radioButtons on each row"

	| nbRows rowLength currentRow buttonRows|
	self layout: self newBoxLayoutTopToBottom.
	
	nbRows := ((self items size) / 4) roundUpTo: 1.
	rowLength := ((self items size) / nbRows) roundUpTo: 1.
	
	buttonRows := Array new: nbRows.
	1 to: nbRows do: [ :i | | row |
		row := self newBoxLayoutLeftToRight.
		self layout add: row expand: false fill: false.
		buttonRows at: i put: row
	].

	currentRow := 1.
	buttons do: [ :button |
		self addButton: button toRow: (buttonRows at: currentRow).
		(self rowSize: (buttonRows at: currentRow) isFull: rowLength) 
			ifTrue: [ currentRow := currentRow + 1 ].
	].
	
	
]

{ #category : 'building' }
MiAbstractRadioButtonSettingPresenter >> connectButtons [

	selectedButton
		associatedRadioButtons: buttons;
		state: true
]

{ #category : 'layout' }
MiAbstractRadioButtonSettingPresenter >> defaultLayout [

	^ self newBoxLayoutTopToBottom 
]

{ #category : 'building' }
MiAbstractRadioButtonSettingPresenter >> helpForItem: anItem [

	^ anItem printString
]

{ #category : 'initialization' }
MiAbstractRadioButtonSettingPresenter >> initializePresenters [

	buttons := self items collect: [ :item |
			           | button |
			           button := self newRadioButtonFor: item.
			           self addButton: button.
			           button ].

	self connectButtons
]

{ #category : 'testing' }
MiAbstractRadioButtonSettingPresenter >> isCurrentValue: anItem [

	self subclassResponsibility
]

{ #category : 'accessing' }
MiAbstractRadioButtonSettingPresenter >> items [

	^ self subclassResponsibility 
]

{ #category : 'building' }
MiAbstractRadioButtonSettingPresenter >> labelForItem: anItem [

	^ anItem printString
]

{ #category : 'instance creation' }
MiAbstractRadioButtonSettingPresenter >> newRadioButtonFor: anItem [

	| button |
	button := self newRadioButton.
	button
		label: (self labelForItem: anItem);
		help: (self helpForItem: anItem);
		whenActivatedDo: [ self activate: anItem ].

	(self isCurrentValue: anItem) ifTrue: [ selectedButton := button ].

	^ button
]

{ #category : 'initialization' }
MiAbstractRadioButtonSettingPresenter >> rowSize: aBoxLayout isFull: maxSize [

	^aBoxLayout children size >= maxSize 
]
