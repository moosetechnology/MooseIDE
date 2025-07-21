Class {
	#name : #MiCollectionSettingCommand,
	#superclass : #MiSettingCommand,
	#instVars : [
		'selectedButton'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #building }
MiCollectionSettingCommand >> buildPresenter [

	| presenter buttons |
	presenter := SpPresenter new.
	presenter layout: presenter newBoxLayoutLeftToRight.

	buttons := self items collect: [ :item |
			           | button |
			           button := self newRadioButtonFor: item.
			           presenter layout add: button.
			           button ].
	self connectButtons: buttons.

	^ presenter
]

{ #category : #building }
MiCollectionSettingCommand >> connectButtons: buttons [

	selectedButton associatedRadioButtons: buttons.
	selectedButton state: true
]

{ #category : #building }
MiCollectionSettingCommand >> helpForItem: anItem [

	^ anItem printString
]

{ #category : #testing }
MiCollectionSettingCommand >> isCurrentValue: anItem [

	^ anItem = self currentValue
]

{ #category : #accessing }
MiCollectionSettingCommand >> items [

	self shouldBeImplemented
]

{ #category : #building }
MiCollectionSettingCommand >> labelForItem: anItem [

	^ anItem printString
]

{ #category : #building }
MiCollectionSettingCommand >> newRadioButtonFor: anItem [

	| button |
	button := SpRadioButtonPresenter new.
	(self isCurrentValue: anItem) ifTrue: [ selectedButton := button ].
	button label: (self labelForItem: anItem).
	button help: (self helpForItem: anItem).

	button whenActivatedDo: [ self execute: anItem ].

	^ button
]
