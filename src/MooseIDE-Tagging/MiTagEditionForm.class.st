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

	cancelButton action: [ 
		self reset.
		self owner closeTagEditionForm ].
	submitButton action: [ self submit ]
]

{ #category : #accessing }
MiTagEditionForm >> fillFormWithTag: aTag [

	aTag ifNil: [ ^ self ].
	aTag isIntent
		ifTrue: [ self setDynamicTag: aTag ]
		ifFalse: [ self setTag: aTag ].
	
]

{ #category : #accessing }
MiTagEditionForm >> fillWithCurrentTag [

	self fillFormWithTag: tagModel currentTag
]

{ #category : #initialization }
MiTagEditionForm >> formLayout [

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
MiTagEditionForm >> initializePresenters [

	super initializePresenters.
	extentButton hide.
	intentButton hide. 
	submitButton label: 'Edit'.
]

{ #category : #accessing }
MiTagEditionForm >> setDynamicTag: aTag [

	self setIntentForm.
	aTag name ifNotNil: [ :name | nameField text: name ].
	aTag description ifNotNil: [ :desc | descriptionField text: desc ].
	aTag color ifNotNil: [ :color | colorPicker setColor: color ].
	aTag category ifNotNil: [ 
		categorySelection selectItem: aTag category ].
	aTag query ifNotNil: [ queryList selectItem: aTag query ]
]

{ #category : #accessing }
MiTagEditionForm >> setTag: aTag [

	self setExtentForm.
	aTag name ifNotNil: [ :name | nameField text: name ].
	aTag description ifNotNil: [ :desc | descriptionField text: desc ].
	aTag color ifNotNil: [ :color | colorPicker setColor: color ].
	aTag categories ifNotEmpty: [ 
		categorySelection selectItem: aTag categories first ]
]

{ #category : #initialization }
MiTagEditionForm >> submit [

	self checkFormInputs ifFalse: [ ^ self ].
	tagModel currentTag isIntent
		ifTrue: [ 
			self owner
				editCurrentDynamicTag: nameField text
				description: descriptionField text
				color: colorPicker color
				category: categorySelection selectedItem
				query: queryList selectedItem ]
		ifFalse: [ 
			self owner
				editCurrentTag: nameField text
				description: descriptionField text
				color: colorPicker color
				category: categorySelection selectedItem ].

	self owner closeTagEditionForm
]

{ #category : #accessing }
MiTagEditionForm >> title [

	^ 'Edit tag'
]
