Class {
	#name : #MiTagManagementPage,
	#superclass : #MiPresenter,
	#instVars : [
		'addButton',
		'removeButton',
		'tagModel',
		'nameField',
		'allTagsList'
	],
	#category : #'Midas-Tagging'
}

{ #category : #specs }
MiTagManagementPage class >> defaultSpec [

	^SpBoxLayout newVertical 
		add:
			(SpBoxLayout newHorizontal
				add: #allTagsList ;
				add: #removeButton ;
				yourself );
		add:
			(SpBoxLayout newHorizontal
				add: #nameField ;
				add: #addButton ;
				yourself );
		yourself
]

{ #category : #initialization }
MiTagManagementPage >> initializePresenters [
	super initializePresenters.
	nameField := self newTextInput.
	allTagsList := self newDropList 
		display: [ :tag | tag name ] ;
		whenSelectedItemChangedDo: [ :tag | self tagModel currentTag: tag  ] ;
		yourself.
	addButton := self newButton
		label: 'Add' ;
		action: [ |newTag |
			newTag := self tagModel addTag: nameField text.
			self refreshTagList.
			allTagsList selectItem: newTag ] ;
		yourself.
	removeButton := self newButton
		label: 'Remove' ;
		action: [ tagModel deleteCurrentTag ] ;
		yourself.
]

{ #category : #initialization }
MiTagManagementPage >> refreshTagList [
	allTagsList items: tagModel allTags
]

{ #category : #accessing }
MiTagManagementPage >> tagModel [
	^tagModel

]

{ #category : #accessing }
MiTagManagementPage >> tagModel: aModel [
	tagModel := aModel.
	self refreshTagList 

]
