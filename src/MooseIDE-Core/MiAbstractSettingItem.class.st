"
Represents a generic setting item. A setting item holds a value and necessary information to display the item on one line in a MiSettingsManager:

- label for the settingItem
- presenter for showing/changing the setting value
- help on the settingItem

Class side has some factory methods
"
Class {
	#name : #MiAbstractSettingItem,
	#superclass : #Object,
	#instVars : [
		'label',
		'help',
		'presenter',
		'oldValue',
		'displayBlock'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #'instance creation' }
MiAbstractSettingItem class >> buttonWithCodeSetting [
	^MiButtonCodeSettingItem new
]

{ #category : #'instance creation' }
MiAbstractSettingItem class >> buttonWithEditableListSetting [
	^MiButtonEditablelistSettingItem new
]

{ #category : #'instance creation' }
MiAbstractSettingItem class >> buttonWithSelectableListSetting [
	^MiButtonSelectableListSettingItem new
]

{ #category : #'instance creation' }
MiAbstractSettingItem class >> checkboxSetting [
	^MiCheckboxSettingItem new
]

{ #category : #'instance creation' }
MiAbstractSettingItem class >> colorSetting [

	^ MiColorSettingItem new
]

{ #category : #'instance creation' }
MiAbstractSettingItem class >> droplistSetting [
	^MiDroplistSettingItem new
]

{ #category : #'instance creation' }
MiAbstractSettingItem class >> integerSetting [
	^MiTextSettingItem new
		integerValue ;
		yourself
]

{ #category : #'api - building' }
MiAbstractSettingItem >> buildLayout [

	oldValue := self getValue.
	^ SpBoxLayout newLeftToRight
		  add: (label asPresenter
				   help: help;
				   yourself);
		  add: self presenter width: 250;
		  yourself
]

{ #category : #action }
MiAbstractSettingItem >> confirmValue [

	oldValue := self getValue
]

{ #category : #accessing }
MiAbstractSettingItem >> displayBlock: anObject [
	"a block with 1 argument (a value) used to display the Value in the Presenter"
	displayBlock := anObject
]

{ #category : #accessing }
MiAbstractSettingItem >> getValue [

	self subclassResponsibility
]

{ #category : #accessing }
MiAbstractSettingItem >> help [

	^ help
]

{ #category : #accessing }
MiAbstractSettingItem >> help: anObject [

	help := anObject
]

{ #category : #initialization }
MiAbstractSettingItem >> initialize [ 
	super initialize.

	displayBlock := #asString
]

{ #category : #accessing }
MiAbstractSettingItem >> label [

	^ label
]

{ #category : #accessing }
MiAbstractSettingItem >> label: anObject [

	label := anObject
]

{ #category : #accessing }
MiAbstractSettingItem >> owner: aPresenter [

	self presenter owner: aPresenter
]

{ #category : #accessing }
MiAbstractSettingItem >> presenter [

	^ presenter
]

{ #category : #action }
MiAbstractSettingItem >> resetValue [

	self setValue: oldValue
]

{ #category : #accessing }
MiAbstractSettingItem >> setValue: anObject [

	self subclassResponsibility
]
