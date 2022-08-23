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

{ #category : #'accessing - tests' }
MiSettingsPresenter >> buttonCancel [

	^ btnCancel
]

{ #category : #'accessing - tests' }
MiSettingsPresenter >> buttonOk [

	^ btnOk
]

{ #category : #'accessing - tests' }
MiSettingsPresenter >> buttonReset [

	^ btnReset
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

	| tmpLayout tmpLayout2 |
	tmpLayout := SpBoxLayout newTopToBottom
		             spacing: self itemSpacing;
		             vAlignCenter;
		             yourself.
	settingItems valuesDo: [ :item | 
		tmpLayout add: item buildLayout expand: false ].
	tmpLayout2 := SpBoxLayout newLeftToRight
		              add: btnCancel;
		              add: btnReset;
		              add: btnOk;
		              yourself.
	^ SpBoxLayout newTopToBottom
		  add: (SpScrollableLayout new child: tmpLayout);
		  add: tmpLayout2 expand: false;
		  yourself
]

{ #category : #accessing }
MiSettingsPresenter >> getItemValue: aString [

	^ (self itemNamed: aString) getValue
]

{ #category : #'morphic ui' }
MiSettingsPresenter >> initialExtent [

	^ 470 @ ((10 min: settingItems size) + 1 * self settingItemHeight
	   + (settingItems size - 1 * self itemSpacing))
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
	aWindowPresenter title: ownerTool toolName , ' settings'
]

{ #category : #accessing }
MiSettingsPresenter >> itemNamed: aName [
	^settingItems at: aName ifAbsent: [ MiNoSuchSettingItem signal ]
]

{ #category : #accessing }
MiSettingsPresenter >> itemSpacing [

	^ 2
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
