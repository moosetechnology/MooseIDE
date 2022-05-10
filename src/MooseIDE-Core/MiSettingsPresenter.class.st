Class {
	#name : #MiSettingsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'settingItems',
		'btnCancel',
		'btnOk',
		'btnReset'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #initialization }
MiSettingsPresenter >> addItem: anItem named: aName [

	anItem owner: self.
	settingItems at: aName put: anItem
]

{ #category : #'instance creation' }
MiSettingsPresenter >> buildPresenter [
	self layout "ifNotNil: [ ^self ].

	self layout: SpBoxLayout newTopToBottom.
	settingItems valuesDo: [ :item | self layout add: item buildLayout ].
	self layout add: (SpBoxLayout newLeftToRight
			 add: btnCancel;
			 add: btnReset;
			 add: btnOk;
			 yourself)"
]

{ #category : #initialization }
MiSettingsPresenter >> confirmItems [

	settingItems valuesDo: [ :item | item confirmValue ]
]

{ #category : #initialization }
MiSettingsPresenter >> connectPresenters [

	btnOk action: [ 
		self confirmItems.
		self window close ].
	btnCancel action: [ 
		self resetItems.
		self window close ].
	btnReset action: [ self resetItems ]
]

{ #category : #layout }
MiSettingsPresenter >> defaultLayout [
	| tmpLayout |
	tmpLayout := SpBoxLayout newTopToBottom.
	settingItems valuesDo: [ :item | tmpLayout add: item buildLayout ].
	tmpLayout add: (SpBoxLayout newLeftToRight
			 add: btnCancel;
			 add: btnReset;
			 add: btnOk;
			 yourself).
	^tmpLayout
]

{ #category : #accessing }
MiSettingsPresenter >> getItemValue: aString [

	^ (settingItems at: aString) getValue
]

{ #category : #initialization }
MiSettingsPresenter >> initialize [

	super initialize.
	settingItems := OrderedDictionary new.
]

{ #category : #initialization }
MiSettingsPresenter >> initializePresenters [

	btnReset := self newButton label: 'Reset'.
	btnCancel := self newButton label: 'Cancel'.
	btnOk := self newButton label: 'Ok'
]

{ #category : #initialization }
MiSettingsPresenter >> initializeWindow: aMiWindowPresenter [

	super initializeWindow: aMiWindowPresenter.

	aMiWindowPresenter initialExtent:
		400 @ (settingItems size * self settingItemHeight)
]

{ #category : #'instance creation' }
MiSettingsPresenter >> open [

	self buildPresenter.
	super open
]

{ #category : #initialization }
MiSettingsPresenter >> resetItems [

	settingItems valuesDo: [ :item | item resetValue ]
]

{ #category : #accessing }
MiSettingsPresenter >> setItem: itemName value: aValue [ 
	
	(settingItems at: itemName) setValue: aValue
]

{ #category : #initialization }
MiSettingsPresenter >> settingItemHeight [

	^ self class toolbarHeight + 20
]

{ #category : #initialization }
MiSettingsPresenter >> settingItems [

	^ settingItems
]
