"
A settingItem which value is selected in a DropList
"
Class {
	#name : #MiDroplistSettingItem,
	#superclass : #MiAbstractSettingItem,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiDroplistSettingItem >> getValue [

	^presenter selectedItem
]

{ #category : #initialization }
MiDroplistSettingItem >> initialize [

	super initialize.
	presenter := SpDropListPresenter new
		help: help ;
		yourself.
]

{ #category : #accessing }
MiDroplistSettingItem >> possibleValues [
	^presenter items
]

{ #category : #accessing }
MiDroplistSettingItem >> possibleValues: aCollection [
	presenter items: aCollection.
	self setValue: aCollection anyOne
]

{ #category : #accessing }
MiDroplistSettingItem >> setValue: anObject [

	presenter selectItem: anObject 
]
