Class {
	#name : 'MiAbstractRadioButtonSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'selectedButton',
		'itemWidth',
		'buttonRows'
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
MiAbstractRadioButtonSettingPresenter >> addButton: button toRow: aBoxLayout [

	aBoxLayout add: button expand: false fill: false
]

{ #category : 'building' }
MiAbstractRadioButtonSettingPresenter >> connectButtons [

	selectedButton
		associatedRadioButtons: (buttonRows flatCollect: #children);
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
	"puts radioButtons on rows of up to 4 buttons (to the limit of 12 buttons)
	 tries to put same number of radioButtons on each row"

	| nbRows rowLength currentRow |
	nbRows := ((self items size) / 4) roundUpTo: 1.
	rowLength := ((self items size) / nbRows) roundUpTo: 1.
	
	buttonRows := Array new: nbRows.
	1 to: nbRows do: [ :i | | row |
		row := self newBoxLayoutLeftToRight.
		self layout add: row expand: false fill: false.
		buttonRows at: i put: row
	].

	currentRow := 1.
	self items do: [ :item || button |
		button := self newRadioButtonFor: item.
		self addButton: button toRow: (buttonRows at: currentRow).
		(self rowSize: (buttonRows at: currentRow) isFull: rowLength) 
			ifTrue: [ currentRow := currentRow + 1 ].
	].

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
