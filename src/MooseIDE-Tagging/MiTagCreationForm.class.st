Class {
	#name : 'MiTagCreationForm',
	#superclass : 'MiTagAbstractForm',
	#instVars : [
		'intentButton',
		'extentButton'
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

{ #category : 'private' }
MiTagCreationForm >> setExtentForm [

	isIntent ifFalse: [ 
		extentButton state: true.
		^ self ].

	intentButton state: false.

	super setExtentForm 
]

{ #category : 'private' }
MiTagCreationForm >> setIntentForm [

	isIntent ifTrue: [ 
		intentButton state: true.
		^ self ].

	extentButton state: false.

	super setIntentForm 
]
