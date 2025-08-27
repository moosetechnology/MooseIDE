Class {
	#name : 'MiOldSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'ownerTool',
		'settingItems',
		'btnCancel',
		'btnOk',
		'btnReset',
		'settingsChanged'
	],
	#category : 'MooseIDE-Core-Settings-old',
	#package : 'MooseIDE-Core',
	#tag : 'Settings-old'
}

{ #category : 'instance creation' }
MiOldSettingsPresenter class >> owner: aMiSpecModel [

	^ self new
		  ownerTool: aMiSpecModel;
		  yourself
]

{ #category : 'accessing' }
MiOldSettingsPresenter >> addItem: anItem named: aName [

	anItem owner: self.
	settingItems at: aName put: anItem
]

{ #category : 'instance creation' }
MiOldSettingsPresenter >> buildPresenter [
	self layout
]

{ #category : 'accessing - tests' }
MiOldSettingsPresenter >> buttonCancel [

	^ btnCancel
]

{ #category : 'accessing - tests' }
MiOldSettingsPresenter >> buttonOk [

	^ btnOk
]

{ #category : 'accessing - tests' }
MiOldSettingsPresenter >> buttonReset [

	^ btnReset
]

{ #category : 'actions' }
MiOldSettingsPresenter >> closeSettings [
	self window close.
	ownerTool settingsChanged: settingsChanged 
]

{ #category : 'actions' }
MiOldSettingsPresenter >> confirmItems [

	settingItems valuesDo: [ :item | item confirmValue ].
	settingsChanged := true
]

{ #category : 'initialization' }
MiOldSettingsPresenter >> connectPresenters [

	btnOk action: [ 
		self confirmItems.
		self closeSettings ].
	btnCancel action: [ 
		self resetItems.
		self closeSettings ].
	btnReset action: [ self resetItems ]
]

{ #category : 'layout' }
MiOldSettingsPresenter >> defaultLayout [

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

{ #category : 'accessing' }
MiOldSettingsPresenter >> getItemValue: aString [

	^ (self itemNamed: aString) getValue
]

{ #category : 'morphic ui' }
MiOldSettingsPresenter >> initialExtent [

	^ 470 @ ((10 min: settingItems size) + 1 * self settingItemHeight
	   + (settingItems size - 1 * self itemSpacing))
]

{ #category : 'initialization' }
MiOldSettingsPresenter >> initialize [

	super initialize.
	settingItems := OrderedDictionary new.
	settingsChanged := false
]

{ #category : 'initialization' }
MiOldSettingsPresenter >> initializePresenters [

	btnReset := self newButton label: 'Reset'.
	btnCancel := self newButton label: 'Cancel'.
	btnOk := self newButton label: 'Ok'
]

{ #category : 'initialization' }
MiOldSettingsPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: ownerTool toolName , ' settings'
]

{ #category : 'accessing' }
MiOldSettingsPresenter >> itemNamed: aName [
	^settingItems at: aName ifAbsent: [ MiNoSuchSettingItem signal ]
]

{ #category : 'accessing' }
MiOldSettingsPresenter >> itemSpacing [

	^ 2
]

{ #category : 'instance creation' }
MiOldSettingsPresenter >> open [

	self buildPresenter.
	settingsChanged := false.
	super open
]

{ #category : 'accessing' }
MiOldSettingsPresenter >> ownerTool [

	^ ownerTool
]

{ #category : 'accessing' }
MiOldSettingsPresenter >> ownerTool: anObject [

	ownerTool := anObject
]

{ #category : 'actions' }
MiOldSettingsPresenter >> resetItems [

	settingItems valuesDo: [ :item | item resetValue ]
]

{ #category : 'accessing' }
MiOldSettingsPresenter >> setItem: itemName value: aValue [ 
	
	(self itemNamed: itemName) setValue: aValue
]

{ #category : 'accessing' }
MiOldSettingsPresenter >> settingItemHeight [

	^ self class toolbarHeight + 10
]

{ #category : 'accessing - tests' }
MiOldSettingsPresenter >> settingItems [

	^ settingItems
]

{ #category : 'accessing' }
MiOldSettingsPresenter >> settingsChanged [
	^settingsChanged
]
