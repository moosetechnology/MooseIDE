"
A settingItem which value is selected in a DropList
"
Class {
	#name : #MiDroplistSettingItem,
	#superclass : #MiAbstractSettingItem,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #tests }
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

{ #category : #tests }
MiDroplistSettingItem >> possibleValues: aCollection [
	presenter items: aCollection.
	self setValue: aCollection anyOne
]

{ #category : #tests }
MiDroplistSettingItem >> setValue: anObject [

	presenter selectItem: anObject 
]
