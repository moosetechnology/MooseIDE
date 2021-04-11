"
The page of the TagBrowser allowing to create, select, or remove tags
"
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

{ #category : #'as yet unclassified' }
MiTagManagementPage >> createTag [
	|newTag |
	newTag := self tagModel addTag: nameField text.
	nameField text: ''.
	self refreshTagList.
	allTagsList selectItem: newTag
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
		action: [ self createTag ] ;
		yourself.
	removeButton := self newButton
		label: 'Remove' ;
		action: [ self removeTag ] ;
		yourself.
]

{ #category : #initialization }
MiTagManagementPage >> refreshTagList [
	allTagsList resetSelection.
	allTagsList items: tagModel allTags
]

{ #category : #'as yet unclassified' }
MiTagManagementPage >> removeTag [
	tagModel deleteCurrentTag.
	self refreshTagList
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
