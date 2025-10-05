Class {
	#name : 'MiTagEditionForm',
	#superclass : 'MiTagCreationForm',
	#category : 'MooseIDE-Tagging-Browser',
	#package : 'MooseIDE-Tagging',
	#tag : 'Browser'
}

{ #category : 'initialization' }
MiTagEditionForm >> checkFormInputs [

	nameField text ifEmpty: [ ^ false ].
	self specModel currentTag isIntent ifFalse: [
		(self specModel getTagNamed: nameField text) ifNotNil: [ :tag |
			self specModel currentTag = tag ifFalse: [
				| popup |
				(popup := self newPopover)
					addStyle: 'error';
					relativeTo: nameField;
					bePositionRight;
					presenter: (SpPresenter new
							 layout: (SpBoxLayout newTopToBottom
									  borderWidth: 2;
									  spacing: 0;
									  add: (self newLabel label: 'Name already exists');
									  yourself);
							 yourself);
					popup.
				^ false ] ] ].


	^ true
]

{ #category : 'initialization' }
MiTagEditionForm >> connectPresenters [

	"cancelButton action: [ 
		self reset.
		self owner closeTagEditionForm ].
	submitButton action: [ self submit ]"
]

{ #category : 'accessing' }
MiTagEditionForm >> fillFormWithTag: aTag [

	aTag ifNil: [ ^ self ].
	aTag isIntent
		ifTrue: [ self setDynamicTag: aTag ]
		ifFalse: [ self setTag: aTag ].
	
]

{ #category : 'accessing' }
MiTagEditionForm >> fillWithCurrentTag [

	self fillFormWithTag: self specModel currentTag
]

{ #category : 'initialization' }
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

{ #category : 'initialization' }
MiTagEditionForm >> formTitle [

	^ 'Edit tag'
]

{ #category : 'initialization' }
MiTagEditionForm >> initializePresenters [

	super initializePresenters.

	submitButton label: 'Save'.
	extentButton hide.
	intentButton hide.
]

{ #category : 'accessing' }
MiTagEditionForm >> setDynamicTag: aTag [

	self setIntentForm.
	aTag name ifNotNil: [ :name | nameField text: name ].
	aTag description ifNotNil: [ :desc | descriptionField text: desc ].
	aTag color ifNotNil: [ :color | colorPicker setColor: color ].
	aTag category ifNotNil: [
		categorySelection selectItem: aTag category ].
	aTag query ifNotNil: [
		(queryList items includes: aTag query) ifFalse: [
			queryList items: queryList items , { aTag query } ].
		queryList startWithSelection selectItem: aTag query ]
]

{ #category : 'accessing' }
MiTagEditionForm >> setTag: aTag [

	self setExtentForm.
	aTag name ifNotNil: [ :name | nameField text: name ].
	aTag description ifNotNil: [ :desc | descriptionField text: desc ].
	aTag color ifNotNil: [ :color | colorPicker setColor: color ].
	aTag categories ifNotEmpty: [ 
		categorySelection selectItem: aTag categories first ]
]

{ #category : 'initialization' }
MiTagEditionForm >> submit [

	self checkFormInputs ifFalse: [ ^ self ].

	self specModel currentTag isIntent
		ifTrue: [ 
			self specModel 
				editCurrentDynamicTag: nameField text
				description: descriptionField text
				color: colorPicker color
				category: categorySelection selectedItem
				query: queryList selectedItem ]
		ifFalse: [ 
			self specModel
				editCurrentTag: nameField text
				description: descriptionField text
				color: colorPicker color
				category: categorySelection selectedItem ].

	tagBrowser refreshTagList.
	self close
]

{ #category : 'accessing' }
MiTagEditionForm >> title [

	^ 'Edit tag'
]
