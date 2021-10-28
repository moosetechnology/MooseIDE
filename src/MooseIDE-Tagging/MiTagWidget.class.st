Class {
	#name : #MiTagWidget,
	#superclass : #MiDraggableAbstractWidget,
	#instVars : [
		'tag',
		'name',
		'description',
		'save',
		'undo',
		'nameLabel',
		'descriptionLabel',
		'colorLabel',
		'colorWidget'
	],
	#category : #'MooseIDE-Tagging-Manager'
}

{ #category : #examples }
MiTagWidget class >> defaultSpec [

	^ super defaultSpec
		  add: #nameLabel height: 25;
		  add: #name height: 25;
		  add: #descriptionLabel height: 25;
		  add: #description height: 100;
		  add: #colorLabel height: 25;
		  add: #colorWidget height: 70;
		  add: (SpBoxLayout newLeftToRight
				   add: #save;
				   add: #undo)
		  height: 50;
		  yourself
]

{ #category : #examples }
MiTagWidget class >> open [

	<example>
	super open
]

{ #category : #specs }
MiTagWidget class >> title [
	^ 'Tag editor'
]

{ #category : #accessing }
MiTagWidget >> accept: anEntity [

	^ anEntity isKindOf: FamixTag
]

{ #category : #actions }
MiTagWidget >> bind [

	name text: tag name.
	description text:
		(tag description ifNil: [ 'Enter here a description' ]).
	colorWidget selectedColor: (tag color ifNil: [ Color white ])
]

{ #category : #actions }
MiTagWidget >> followAction [

	self tag: toSelect
]

{ #category : #actions }
MiTagWidget >> initializePresenters [

	super initializePresenters.
	name := self newTextInput.
	description := self newText.
	colorWidget := self instantiate: SpColorDropdownList.

	save := self newButton
		        icon: (self iconNamed: #smallOk);
		        action: [ self saveChanges ].
	undo := self newButton
		        icon: (self iconNamed: #smallUndo);
		        action: [ self undoChanges ].

	nameLabel := self newLabel
		             label: 'Name';
		             yourself.
	descriptionLabel := self newLabel
		                    label: 'Description';
		                    yourself.
	colorLabel := self newLabel
		              label: 'Color';
		              yourself
]

{ #category : #actions }
MiTagWidget >> saveChanges [

	tag name: name text.

	tag description: (description text = 'Enter here a description'
			 ifTrue: [ '' ]
			 ifFalse: [ description text ]).
	tag color: colorWidget selectedColor
]

{ #category : #actions }
MiTagWidget >> tag: aTag [

	tag := aTag.
	self bind
]

{ #category : #actions }
MiTagWidget >> undoChanges [

	self bind
]
