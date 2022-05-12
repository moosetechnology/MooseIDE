Class {
	#name : #MiButtonEditablelistSettingItem,
	#superclass : #MiButtonSettingItem,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiButtonEditablelistSettingItem >> getValue [

	^secondaryPresenter items
]

{ #category : #initialization }
MiButtonEditablelistSettingItem >> initializeSecondaryPresenter [

	secondaryPresenter := SpEditableListPresenter new.
	presenter help: (self listToString: secondaryPresenter items).

]

{ #category : #private }
MiButtonEditablelistSettingItem >> listToString: aCollection [
	^String cr join: (aCollection collect: #asString)

]

{ #category : #accessing }
MiButtonEditablelistSettingItem >> setValue: aCollection [
	secondaryPresenter display: displayBlock.
	secondaryPresenter items: aCollection
]
