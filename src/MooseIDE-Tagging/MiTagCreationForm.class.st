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
		'colorPicker'
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
	addButton action: [ self submit ]
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
				                 add: 'Create Tag' asPresenter;
				                 hAlignCenter;
				                 yourself);
		                add: (SpBoxLayout newLeftToRight
				                 add: 'Tag Color' asPresenter;
				                 hAlignCenter;
				                 yourself)
		                width: colorPickerWidth;
		                yourself.

	inputFieldsLayout := SpBoxLayout newTopToBottom
		                     spacing: 7;
		                     add: nameField expand: false;
		                     add: descriptionField;
		                     add: (SpBoxLayout newLeftToRight
				                      spacing: 10;
				                      add: clearButton;
				                      add: addButton;
				                      yourself)
		                     expand: false;
		                     yourself.

	formLayout := SpBoxLayout newLeftToRight
		              spacing: 10;
		              add: inputFieldsLayout
		              expand: true
		              fill: true
		              padding: 3;
		              add: sep width: 2;
		              add: colorPicker width: colorPickerWidth;
		              yourself.
	self layout: (SpBoxLayout newTopToBottom
			 spacing: 5;
			 add: headerLayout expand: false;
			 add: formLayout;
			 yourself)
]

{ #category : #initialization }
MiTagCreationForm >> initializePresenters [

	nameField := self newTextInput
		             placeholder: 'Name';
		             yourself.
	descriptionField := self newText
		                    placeholder: 'Description';
		                    yourself.
	addButton := self newButton
		             label: 'Add';
		             yourself.
	clearButton := self newButton
		               label: 'Cancel';
		               yourself.
	(colorPicker := self instantiate: MiColorPicker) setColor:
		Color random.
	self initializeLayout
]

{ #category : #initialization }
MiTagCreationForm >> reset [

	colorPicker setColor: Color random.
	nameField text: ''.
	descriptionField text: ''.
]

{ #category : #initialization }
MiTagCreationForm >> submit [

	self checkFormInputs ifFalse: [ ^ self ].
	self owner
		createTag: nameField text
		description: descriptionField text
		color: colorPicker color.
	self owner closeTagCreationForm
]
