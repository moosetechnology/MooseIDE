Class {
	#name : #MiTagCategoryCreationForm,
	#superclass : #MiPresenter,
	#instVars : [
		'nameField',
		'cancelButton',
		'submitButton',
		'tagModel'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #accessing }
MiTagCategoryCreationForm >> cancelButton [

	^ cancelButton
]

{ #category : #initialization }
MiTagCategoryCreationForm >> connectPresenters [

	submitButton action: [ self submit ].
	cancelButton action: [ self owner closeCategoryCreationForm ]
]

{ #category : #initialization }
MiTagCategoryCreationForm >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 2;
			 add: (SpBoxLayout newLeftToRight
					  vAlignCenter;
					  add: nameField;
					  yourself);
			 add: submitButton width: submitButton icon width + 10;
			 add: cancelButton width: cancelButton icon width + 10;
			 yourself)
]

{ #category : #initialization }
MiTagCategoryCreationForm >> initializePresenters [

	nameField := self newTextInput placeholder: 'Enter name'.
	cancelButton := self newButton icon: (self iconNamed: #delete).
	submitButton := self newButton icon: (self iconNamed: #glamorousAccept).
	self initializeLayout
]

{ #category : #initialization }
MiTagCategoryCreationForm >> reset [

	nameField text: ''
]

{ #category : #initialization }
MiTagCategoryCreationForm >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : #initialization }
MiTagCategoryCreationForm >> submit [

	nameField text ifEmpty: [ ^ self ].
	tagModel addCategory: nameField text.
	self owner closeCategoryCreationForm.
	self owner refreshCategoryList
]
