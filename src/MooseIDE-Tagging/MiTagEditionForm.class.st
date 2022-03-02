Class {
	#name : #MiTagEditionForm,
	#superclass : #MiTagCreationForm,
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagEditionForm >> checkFormInputs [

	nameField text ifEmpty: [ ^ false ].
	(tagModel getTagNamed: nameField text) ifNotNil: [ :tag | 
		tagModel currentTag = tag ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #initialization }
MiTagEditionForm >> connectPresenters [

	clearButton action: [ 
		self reset.
		self owner closeTagEditionForm ].
	addButton action: [ self submit ]
]

{ #category : #accessing }
MiTagEditionForm >> fillFormWithTag: aTag [

	aTag ifNil: [ ^ self ].
	aTag name ifNotNil: [ :name | nameField text: name ].
	aTag description ifNotNil: [ :desc | descriptionField text: desc ].
	aTag color ifNotNil: [ :color | colorPicker setColor: color ].
	aTag categories ifNotEmpty: [ 
		categorySelection selectItem: aTag categories first ]
]

{ #category : #accessing }
MiTagEditionForm >> fillWithCurrentTag [

	self fillFormWithTag: tagModel currentTag
]

{ #category : #initialization }
MiTagEditionForm >> initializeLayout [

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
				                 add: 'Edit Tag' asPresenter;
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
MiTagEditionForm >> initializePresenters [

	super initializePresenters.
	addButton label: 'Edit'
]

{ #category : #initialization }
MiTagEditionForm >> submit [

	self checkFormInputs ifFalse: [ ^ self ].
	
	self owner
		editCurrentTag: nameField text
		description: descriptionField text
		color: colorPicker color
		category: categorySelection selectedItem.
	self owner closeTagEditionForm
]
