Class {
	#name : #MiSettingsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'ownerTool',
		'settingItems',
		'btnCancel',
		'btnOk',
		'btnReset',
		'settingsChanged'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiSettingsPresenter >> addItem: anItem named: aName [

	anItem owner: self.
	settingItems at: aName put: anItem
]

{ #category : #'instance creation' }
MiSettingsPresenter >> buildPresenter [
	self layout
]

{ #category : #actions }
MiSettingsPresenter >> closeSettings [
	self window close.
	ownerTool settingsChanged: settingsChanged 
]

{ #category : #actions }
MiSettingsPresenter >> confirmItems [

	settingItems valuesDo: [ :item | item confirmValue ].
	settingsChanged := true
]

{ #category : #initialization }
MiSettingsPresenter >> connectPresenters [

	btnOk action: [ 
		self confirmItems.
		self closeSettings ].
	btnCancel action: [ 
		self resetItems.
		self closeSettings ].
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

	^ (self itemNamed: aString) getValue
]

{ #category : #'morphic ui' }
MiSettingsPresenter >> initialExtent [

	^ 200 @ (10 max: settingItems size) + 1 * self settingItemHeight
]

{ #category : #initialization }
MiSettingsPresenter >> initialize [

	super initialize.
	settingItems := OrderedDictionary new.
	settingsChanged := false
]

{ #category : #initialization }
MiSettingsPresenter >> initializePresenters [

	btnReset := self newButton label: 'Reset'.
	btnCancel := self newButton label: 'Cancel'.
	btnOk := self newButton label: 'Ok'
]

{ #category : #initialization }
MiSettingsPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: ownerTool toolName , ' settings'.
	aWindowPresenter initialExtent: self initialExtent
]

{ #category : #accessing }
MiSettingsPresenter >> itemNamed: aName [
	^settingItems at: aName ifAbsent: [ MiNoSuchSettingItem signal ]
]

{ #category : #'instance creation' }
MiSettingsPresenter >> open [

	self buildPresenter.
	settingsChanged := false.
	super open
]

{ #category : #accessing }
MiSettingsPresenter >> ownerTool [

	^ ownerTool
]

{ #category : #accessing }
MiSettingsPresenter >> ownerTool: anObject [

	ownerTool := anObject
]

{ #category : #actions }
MiSettingsPresenter >> resetItems [

	settingItems valuesDo: [ :item | item resetValue ]
]

{ #category : #accessing }
MiSettingsPresenter >> setItem: itemName value: aValue [ 
	
	(self itemNamed: itemName) setValue: aValue
]

{ #category : #accessing }
MiSettingsPresenter >> settingItemHeight [

	^ self class toolbarHeight + 10
]

{ #category : #'accessing - tests' }
MiSettingsPresenter >> settingItems [

	^ settingItems
]

{ #category : #accessing }
MiSettingsPresenter >> settingsChanged [
	^settingsChanged
]
