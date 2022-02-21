"
A tag creation form.
"
Class {
	#name : #MiTagCreationForm,
	#superclass : #MiPresenter,
	#instVars : [
		'nameField',
		'descriptionField',
		'addButton',
		'clearButton',
		'colorPicker',
		'tagModel',
		'categorySelection'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagCreationForm >> checkFormInputs [

	nameField text ifEmpty: [ ^ false ].
	^ true
]

{ #category : #initialization }
MiTagCreationForm >> connectPresenters [

	clearButton action: [ 
		self reset.
		self owner closeTagCreationForm ].
	addButton action: [ self submit ].
]

{ #category : #initialization }
MiTagCreationForm >> initializeLayout [

	| sep colorPickerWidth headerLayout inputFieldsLayout formLayout |
	colorPickerWidth := 240.
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
				                 add: 'Create Tag' asPresenter;
				                 hAlignCenter;
				                 yourself);
		                yourself.

	inputFieldsLayout := SpBoxLayout newTopToBottom
		                     spacing: 10;
		                     add: (SpBoxLayout newLeftToRight
				                      spacing: 5;
				                      add: (SpBoxLayout newTopToBottom
						                       add: 'Name' asPresenter expand: false;
						                       add: nameField expand: false;
						                       yourself);
				                      add: (SpBoxLayout newTopToBottom
						                       add: 'Category (optional)';
						                       add: categorySelection;
						                       yourself)
				                      width: 200;
				                      yourself)
		                     expand: false;
		                     add: (SpBoxLayout newTopToBottom
				                      add: 'Description (optional)' asPresenter
				                      expand: false;
				                      add: descriptionField height: 150;
				                      yourself)
		                     expand: false;
		                     add: (SpBoxLayout newLeftToRight
				                      vAlignEnd;
				                      spacing: 10;
				                      add: clearButton;
				                      add: addButton;
				                      yourself);
		                     yourself.

	formLayout := SpBoxLayout newLeftToRight
		              spacing: 10;
		              add: colorPicker width: colorPickerWidth;
		              add: sep width: 2;
		              add: inputFieldsLayout
		              expand: true
		              fill: true
		              padding: 10;
		              yourself.
	self layout: (SpBoxLayout newTopToBottom
			 spacing: 5;
			 add: headerLayout expand: false;
			 add: formLayout;
			 yourself)
]

{ #category : #initialization }
MiTagCreationForm >> initializePresenters [

	nameField := self newTextInput.
	descriptionField := self newText.
	addButton := self newButton
		             label: 'Add';
		             icon: (self iconNamed: #glamorousAccept);
		             yourself.
	clearButton := self newButton
		               label: 'Cancel';
		               icon: (self iconNamed: #delete);
		               yourself.
	(colorPicker := self instantiate: MiColorPicker) setColor:
		Color random.
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
MiTagCreationForm >> reset [

	colorPicker setColor: Color random.
	nameField text: ''.
	descriptionField text: ''.
	categorySelection resetSelection
]

{ #category : #initialization }
MiTagCreationForm >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : #initialization }
MiTagCreationForm >> submit [

	self checkFormInputs ifFalse: [ ^ self ].
	self owner
		createTag: nameField text
		description: descriptionField text
		color: colorPicker color
		category: categorySelection selectedItem.
	self owner closeTagCreationForm
]

{ #category : #private }
MiTagCreationForm >> updateCategories [

	categorySelection items: { nil }, tagModel allCategories
]
