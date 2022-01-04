"
I am a dynamic tag creation form.
"
Class {
	#name : #MiDynamicTagCreationForm,
	#superclass : #MiPresenter,
	#instVars : [
		'namePresenter',
		'colorPresenter',
		'queryCodePresenter',
		'submitButton',
		'cancelButton',
		'colorButton',
		'currentColor'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #initialization }
MiDynamicTagCreationForm >> checkFormInputs [

	namePresenter text ifEmpty: [ ^ false ].
	queryCodePresenter text ifEmpty: [ ^ false ].
	^ true
]

{ #category : #initialization }
MiDynamicTagCreationForm >> connectPresenters [

	cancelButton action: [ self owner closeTagCreationForm ].
	submitButton action: [ self submit ].
	colorPresenter whenTextChangedDo: [ :new :old | 
		new size = 6 ifTrue: [ 
			currentColor := Color fromHexString: new.
			colorButton image:
				((Form extent: 20 @ 30 depth: 32) fillColor: currentColor) ] ]
]

{ #category : #initialization }
MiDynamicTagCreationForm >> initializePresenters [

	namePresenter := self newTextInput placeholder: 'Enter a name'.
	colorPresenter := self newTextInput
		                  placeholder: 'Enter an hexa color (optional)';
		                  maxLength: 6.
	queryCodePresenter := self newCode
		                      withoutLineNumbers;
		                      placeholder: 'Enter a query'.
	submitButton := self newButton label: 'Add'.
	cancelButton := self newButton label: 'Cancel'.

	self layout: (SpBoxLayout newTopToBottom
			 spacing: 4;
			 add: (self newButton
					  label: 'Create dyanmic tag';
					  disable)
			 expand: false;
			 add: namePresenter expand: false;
			 add: (SpBoxLayout newLeftToRight
					  spacing: 3;
					  add: colorPresenter;
					  add: (colorButton := self newImage)
					  withConstraints: [ :constraints | 
						  constraints
							  expand: false;
							  width: 20;
							  height: 20 ];
					  yourself)
			 expand: false;
			 add: queryCodePresenter;
			 add: (SpBoxLayout newLeftToRight
					  spacing: 2;
					  add: cancelButton;
					  add: submitButton;
					  yourself)
			 expand: false;
			 yourself)
]

{ #category : #initialization }
MiDynamicTagCreationForm >> reset [

	namePresenter text: ''.
	colorPresenter text: ''. 
	queryCodePresenter text: ''.
	colorButton image: nil.
]

{ #category : #initialization }
MiDynamicTagCreationForm >> submit [

	| dt |
	self checkFormInputs ifFalse: [ ^ self ].
	dt := MiDynamicTag new
		      name: namePresenter text;
		      query: (Smalltalk compiler
				       source: queryCodePresenter text;
				       logged: false;
				       evaluate).
	dt color: (currentColor
			 ifNotNil: [ currentColor ]
			 ifNil: [ self owner model colorForDynamicTag: dt ]).
	self owner addDynamicTag: dt.
	self reset.
	self owner closeTagCreationForm
]
