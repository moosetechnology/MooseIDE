Class {
	#name : #MiAbstractSettingItem,
	#superclass : #Object,
	#instVars : [
		'label',
		'help',
		'name',
		'presenter',
		'oldValue'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #'api - building' }
MiAbstractSettingItem >> buildLayout [

	oldValue := self getValue.
	^ SpBoxLayout newLeftToRight
		  add: (label asPresenter
				   help: help;
				   yourself);
		  add: self presenter;
		  yourself
]

{ #category : #action }
MiAbstractSettingItem >> confirmValue [

	oldValue := self getValue
]

{ #category : #tests }
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

{ #category : #accessing }
MiAbstractSettingItem >> label [

	^ label
]

{ #category : #accessing }
MiAbstractSettingItem >> label: anObject [

	label := anObject
]

{ #category : #accessing }
MiAbstractSettingItem >> name [

	^ name
]

{ #category : #accessing }
MiAbstractSettingItem >> name: anObject [

	name := anObject
]

{ #category : #accessing }
MiAbstractSettingItem >> owner: aPresenter [

	self presenter owner: aPresenter
]

{ #category : #tests }
MiAbstractSettingItem >> presenter [

	^ presenter
]

{ #category : #action }
MiAbstractSettingItem >> resetValue [

	self setValue: oldValue
]

{ #category : #tests }
MiAbstractSettingItem >> setValue: anObject [

	self subclassResponsibility
]
