"
A MiSettingItem which value is given by a code editor. The setting itself is a button that calls the display of a small editor window to change the code

"
Class {
	#name : #MiButtonCodeSettingItem,
	#superclass : #MiButtonSettingItem,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiButtonCodeSettingItem >> getValue [

	^secondaryPresenter text
]

{ #category : #initialization }
MiButtonCodeSettingItem >> initializeSecondaryPresenter [
	
	secondaryPresenter := SpCodePresenter new.
	presenter help: secondaryPresenter text.

]

{ #category : #accessing }
MiButtonCodeSettingItem >> setValue: aValue [

	secondaryPresenter text: (displayBlock value: aValue)
]
