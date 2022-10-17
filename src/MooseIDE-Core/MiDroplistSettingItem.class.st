"
A settingItem which value is selected in a DropList
"
Class {
	#name : #MiDroplistSettingItem,
	#superclass : #MiAbstractSettingItem,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiDroplistSettingItem >> displayBlock: aBlock [
	super displayBlock: aBlock.
	presenter display: aBlock 
]

{ #category : #accessing }
MiDroplistSettingItem >> getValue [

	^presenter selectedItem
]

{ #category : #initialization }
MiDroplistSettingItem >> initialize [

	super initialize.
	
	presenter := SpDropListPresenter new
		display: displayBlock ;
		help: help ;
		yourself.
	self displayBlock: [ :value :listItem | value asString].
]

{ #category : #accessing }
MiDroplistSettingItem >> possibleValues [
	^presenter items
]

{ #category : #accessing }
MiDroplistSettingItem >> possibleValues: aCollection [

	presenter items: aCollection.
	aCollection ifEmpty: [ ^ self ].
	self setValue: aCollection anyOne
]

{ #category : #accessing }
MiDroplistSettingItem >> setValue: anObject [

	presenter selectItem: anObject 
]
