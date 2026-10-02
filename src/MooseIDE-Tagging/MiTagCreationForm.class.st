Class {
	#name : 'MiTagCreationForm',
	#superclass : 'MiTagAbstractForm',
	#instVars : [
		'intentButton',
		'extentButton',
		'queryListLabeled'
	],
	#category : 'MooseIDE-Tagging-Browser',
	#package : 'MooseIDE-Tagging',
	#tag : 'Browser'
}

{ #category : 'private' }
MiTagCreationForm >> connectPresenters [

	extentButton action: [ self setExtentForm ].
	intentButton action: [ self setIntentForm ].
]

{ #category : 'accessing' }
MiTagCreationForm >> extentButton [

	^ extentButton
]

{ #category : 'initialization' }
MiTagCreationForm >> initializeFormLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: (SpBoxLayout newLeftToRight
				   add: extentButton;
				   add: intentButton;
				   yourself)
		  expand: false;
		  add: self formLayout expand: true;
		  add: queryListLabeled expand: false;
		  yourself
]

{ #category : 'initialization' }
MiTagCreationForm >> initializePresenters [
	
	extentButton := self newToggleButton
		state: true;
		label: 'Static'.
	intentButton := self newToggleButton
		state: false;
		label: 'Dynamic'.
	super initializePresenters 
]

{ #category : 'initialization' }
MiTagCreationForm >> initializeTagDescriptionPresenters [

	super initializeTagDescriptionPresenters. 
	queryListLabeled := MiPresenter new
		layout: (SpBoxLayout newTopToBottom
			add: 'Query' asPresenter expand: false;
			add: queryList expand: false;
			yourself);
		 hide.

]

{ #category : 'accessing' }
MiTagCreationForm >> intentButton [

	^ intentButton
]

{ #category : 'testing' }
MiTagCreationForm >> isIntentSubmit [

	self specModel
		createDynamicTag: nameField text
		description: descriptionField text
		color: colorPicker color
		category: categorySelection selectedItem
		query: queryList selectedItem
]

{ #category : 'testing' }
MiTagCreationForm >> notIntentSubmit [

	self specModel
				createTag: nameField text
				description: descriptionField text
				color: colorPicker color
				category: categorySelection selectedItem
]

{ #category : 'accessing' }
MiTagCreationForm >> queryListLabeled [

	^ queryListLabeled
]

{ #category : 'private' }
MiTagCreationForm >> setExtentForm [

	isIntent ifFalse: [ 
		extentButton state: true.
		^ self ].

	intentButton state: false.
	queryListLabeled hide.
	super setExtentForm 
]

{ #category : 'private' }
MiTagCreationForm >> setIntentForm [

	isIntent ifTrue: [ 
		intentButton state: true.
		^ self ].

	extentButton state: false.
	queryListLabeled show.
	super setIntentForm 
]
