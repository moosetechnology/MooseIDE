Class {
	#name : #MiTagAbstractCreationForm,
	#superclass : #MiPresenter,
	#instVars : [
		'colorPicker',
		'cancelButton',
		'submitButton',
		'nameField',
		'descriptionField',
		'categorySelection',
		'tagModel'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagAbstractCreationForm >> checkFormInputs [

	self subclassResponsibility
]

{ #category : #initialization }
MiTagAbstractCreationForm >> formLayout [

	self subclassResponsibility
]

{ #category : #initialization }
MiTagAbstractCreationForm >> initializeLayout [

	| sep colorPickerWidth headerLayout formLayout |
	self layout: (SpBoxLayout newTopToBottom spacing: 5).
	colorPickerWidth := 240.
	(sep := SpRoassalPresenter new) canvas color: (Color
			 r: 40
			 g: 40
			 b: 40
			 range: 255) translucent.
	(sep := SpRoassalPresenter new) canvas color: (Color
			 r: 40
			 g: 40
			 b: 40
			 range: 255) translucent.

	headerLayout := SpBoxLayout newLeftToRight
		                add: (SpBoxLayout newLeftToRight
				                 add: 'Tag Color' asPresenter;
				                 hAlignCenter;
				                 yourself)
		                width: colorPickerWidth;
		                add: (SpBoxLayout newLeftToRight
				                 add: self title asPresenter;
				                 hAlignCenter;
				                 yourself);
		                yourself.

	formLayout := SpBoxLayout newLeftToRight
		              spacing: 10;
		              add: colorPicker width: colorPickerWidth;
		              add: sep width: 2;
		              add: self formLayout
		              expand: true
		              fill: true
		              padding: 10;
		              yourself.
	self layout
		add: headerLayout expand: false;
		add: formLayout
]

{ #category : #initialization }
MiTagAbstractCreationForm >> initializePresenters [

	(colorPicker := self instantiate: MiColorPicker) setColor:
		Color random.

	submitButton := self newButton
		                label: 'Add';
		                yourself.
	cancelButton := self newButton
		                label: 'Cancel';
		                yourself.
	nameField := self newTextInput.
	descriptionField := self newText.
	categorySelection := self newDropList
		                     sortingBlock: [ :c1 :c2 | 
			                     c1 model ifNil: [ true ] ifNotNil: [ 
					                     c2 model
						                     ifNil: [ false ]
						                     ifNotNil: [ c1 model name < c2 model name ] ] ];
		                     display: [ :cat | 
			                     cat ifNil: [ '' ] ifNotNil: [ cat name ] ];
		                     yourself.
	self initializeLayout
]

{ #category : #initialization }
MiTagAbstractCreationForm >> reset [

	self subclassResponsibility
]

{ #category : #initialization }
MiTagAbstractCreationForm >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : #initialization }
MiTagAbstractCreationForm >> submit [

	self subclassResponsibility
]

{ #category : #accessing }
MiTagAbstractCreationForm >> title [

	^ 'Create tag'
]

{ #category : #private }
MiTagAbstractCreationForm >> updateCategories [

	categorySelection items: { nil }, tagModel allCategories
]
