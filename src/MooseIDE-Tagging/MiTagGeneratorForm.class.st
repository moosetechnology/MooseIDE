Class {
	#name : #MiTagGeneratorForm,
	#superclass : #MiPresenter,
	#instVars : [
		'submitButton',
		'cancelButton',
		'nameField',
		'categorySelection',
		'descriptionField',
		'singleTagButton',
		'multipleTagsButton',
		'graduatedTagsButton',
		'tagModel'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagGeneratorForm >> formTitle [

	^ 'Generate tags'
]

{ #category : #initialization }
MiTagGeneratorForm >> initializeLayout [
	| headerLayout formLayout mainLayout |
	self layout: (SpBoxLayout newTopToBottom spacing: 5).

	headerLayout := (SpBoxLayout newLeftToRight
				                 add: self formTitle asPresenter;
				                 hAlignCenter;
				                 yourself).

	formLayout := SpBoxLayout newTopToBottom
		              spacing: 5;
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
				               add: descriptionField;
				               yourself)
		              expand: true;
		              yourself.

	mainLayout := SpBoxLayout newTopToBottom
				               spacing: 4;
				               add: (SpBoxLayout newLeftToRight
						                add: singleTagButton;
						                add: multipleTagsButton;
											add: graduatedTagsButton; 
						                yourself)
				               expand: false;
				               add: formLayout expand: true fill: true;
				               add: (SpBoxLayout newLeftToRight
						                vAlignEnd;
						                spacing: 10;
						                add: cancelButton;
						                add: submitButton;
						                yourself)
				               expand: false;
				               yourself;
		              yourself.
	self layout
		add: headerLayout expand: false;
		add: mainLayout
]

{ #category : #'as yet unclassified' }
MiTagGeneratorForm >> initializePresenters [

	submitButton := self newButton
		                label: 'Add';
		                yourself.
	cancelButton := self newButton
		                label: 'Cancel';
		                yourself.
	nameField := self newTextInput.
	categorySelection := self newDropList
		                     sortingBlock: [ :c1 :c2 | 
			                     c1 model ifNil: [ true ] ifNotNil: [ 
					                     c2 model
						                     ifNil: [ false ]
						                     ifNotNil: [ c1 model name < c2 model name ] ] ];
		                     display: [ :cat | 
			                     cat ifNil: [ '' ] ifNotNil: [ cat name ] ];
		                     yourself.
	descriptionField := self newText.
	
	singleTagButton := self newToggleButton
		                state: true;
		                label: 'Single tag';
		                yourself.
	multipleTagsButton := self newToggleButton
		                state: false;
		                label: 'Multiple tags';
		                yourself.
	graduatedTagsButton := self newToggleButton
		                state: false;
		                label: 'Graduated tags';
		                yourself.
	submitButton := self newButton
		                label: 'Generate';
		                yourself.
	cancelButton := self newButton
		                label: 'Cancel';
		                yourself.
		
	self initializeLayout
]

{ #category : #initialization }
MiTagGeneratorForm >> reset [

	nameField text: ''.
	descriptionField text: ''.
	categorySelection resetSelection
]

{ #category : #initialization }
MiTagGeneratorForm >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : #private }
MiTagGeneratorForm >> updateCategories [

	categorySelection items: { nil }, tagModel allCategories
]
