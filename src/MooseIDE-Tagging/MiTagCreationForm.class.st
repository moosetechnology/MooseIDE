"
A tag creation form.
"
Class {
	#name : #MiTagCreationForm,
	#superclass : #MiTagAbstractCreationForm,
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagCreationForm >> checkFormInputs [

	nameField text ifEmpty: [ ^ false ].
	^ true
]

{ #category : #initialization }
MiTagCreationForm >> connectPresenters [

	cancelButton action: [ 
		self reset.
		self owner closeTagCreationForm ].
	submitButton action: [ self submit ].
]

{ #category : #initialization }
MiTagCreationForm >> formLayout [

	^ SpBoxLayout newTopToBottom
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
				   add: 'Description (optional)' asPresenter expand: false;
				   add: descriptionField height: 150;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newLeftToRight
				   vAlignEnd;
				   spacing: 10;
				   add: cancelButton;
				   add: submitButton;
				   yourself);
		  yourself
]

{ #category : #initialization }
MiTagCreationForm >> reset [

	colorPicker setColor: Color random.
	nameField text: ''.
	descriptionField text: ''.
	categorySelection resetSelection
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
