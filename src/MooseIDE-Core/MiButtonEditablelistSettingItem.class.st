"
A MiSettingItem which value is given by an editable list. It allows to chose an ordered list of elements from a set of elements (all possible values).
"
Class {
	#name : #MiButtonEditablelistSettingItem,
	#superclass : #MiButtonSettingItem,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiButtonEditablelistSettingItem >> display: aBlock [

	secondaryPresenter display: aBlock
]

{ #category : #accessing }
MiButtonEditablelistSettingItem >> displayBlock: aBlock [

	secondaryPresenter displayIcon: aBlock
]

{ #category : #accessing }
MiButtonEditablelistSettingItem >> displayIcon: aBlock [

	secondaryPresenter displayIcon: aBlock
]

{ #category : #accessing }
MiButtonEditablelistSettingItem >> getValue [
	
	^ secondaryPresenter items
]

{ #category : #initialization }
MiButtonEditablelistSettingItem >> initializeSecondaryPresenter [

	secondaryPresenter := MiEditableListSelector new.
	presenter help: (self listToString: secondaryPresenter items).

]

{ #category : #private }
MiButtonEditablelistSettingItem >> listToString: aCollection [
	^String cr join: (aCollection collect: #asString)

]

{ #category : #accessing }
MiButtonEditablelistSettingItem >> possibleValues [

	^ secondaryPresenter allItems
]

{ #category : #accessing }
MiButtonEditablelistSettingItem >> possibleValues: aCollection [

	secondaryPresenter allItems: aCollection
]

{ #category : #accessing }
MiButtonEditablelistSettingItem >> setValue: aCollection [

	secondaryPresenter items: aCollection
]
