Class {
	#name : #MiTagBuilderForm,
	#superclass : #MiPresenter,
	#instVars : [
		'submitButton',
		'cancelButton',
		'formLayout',
		'categorySelection',
		'tagModel',
		'currentStrategy',
		'continuousButton',
		'discreetButton',
		'propertyInput',
		'boundsDroplist'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #actions }
MiTagBuilderForm >> cancel [

	self reset.
	self owner closeTagBuilderForm
]

{ #category : #initialization }
MiTagBuilderForm >> connectPresenters [
	
	continuousButton action: [ self setContinuousForm ].
	discreetButton action: [ self setDiscreetForm ].
	cancelButton action: [ self cancel ].
	submitButton action: [ self submit ]
]

{ #category : #'as yet unclassified' }
MiTagBuilderForm >> currentStategy [

	^ currentStrategy
]

{ #category : #initialization }
MiTagBuilderForm >> formTitle [ 
	
	^ 'Build tags'
]

{ #category : #initialization }
MiTagBuilderForm >> initialize [

	super initialize.
	currentStrategy := ContinuousQueryBuilder
]

{ #category : #initialization }
MiTagBuilderForm >> initializeLayout [

	| headerLayout mainLayout |
	self layout: (SpBoxLayout newTopToBottom spacing: 5).

	headerLayout := SpBoxLayout newLeftToRight
		                add: self formTitle asPresenter;
		                hAlignCenter;
		                yourself.

	formLayout := SpBoxLayout newTopToBottom
		              spacing: 5;
		              add: (SpBoxLayout newTopToBottom
				               add: 'Property' expand: false;
				               add: propertyInput expand: false;
				               yourself)
		              expand: false;
		              add: (SpBoxLayout newTopToBottom
				               add: 'Bounds';
				               add: boundsDroplist;
				               yourself)
		              expand: false;
		              add: (SpBoxLayout newTopToBottom
				               add: 'Category (optional)';
				               add: categorySelection;
				               yourself)
		              expand: false;
		              yourself.

	mainLayout := SpBoxLayout newTopToBottom
		              spacing: 10;
		              add: (SpBoxLayout newLeftToRight
				               add: continuousButton;
				               add: discreetButton;
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
		              yourself.
	self layout
		add: headerLayout expand: false;
		add: mainLayout
]

{ #category : #'as yet unclassified' }
MiTagBuilderForm >> initializePresenters [

	continuousButton := self newToggleButton
		                    state: true;
		                    label: 'Continuous mode';
		                    yourself.
	discreetButton := self newToggleButton
		                  state: false;
		                  label: 'Discreet mode';
		                  yourself.
	submitButton := self newButton
		                label: 'Build';
		                yourself.
	cancelButton := self newButton
		                label: 'Cancel';
		                yourself.
		
	categorySelection := self newDropList
		                     sortingBlock: [ :c1 :c2 | 
			                     c1 model ifNil: [ true ] ifNotNil: [ 
					                     c2 model
						                     ifNil: [ false ]
						                     ifNotNil: [ c1 model name < c2 model name ] ] ];
		                     display: [ :cat | 
			                     cat ifNil: [ '' ] ifNotNil: [ cat name ] ];
		                     yourself.
	boundsDroplist := self newDropList items: { { 1. 2. 3. 5. 10. 25. 50. 100. 500. } }.
	
	propertyInput := self newTextInput.

	self initializeLayout
]

{ #category : #initialization }
MiTagBuilderForm >> reset [

	categorySelection resetSelection
	
]

{ #category : #initialization }
MiTagBuilderForm >> setContinuousForm [

	currentStrategy = ContinuousQueryBuilder ifTrue: [ 
		continuousButton state: true.
		^ self ].
	currentStrategy := ContinuousQueryBuilder.
	discreetButton state: false.
	self update
]

{ #category : #initialization }
MiTagBuilderForm >> setDiscreetForm [

	discreetButton state: false.
	self update
]

{ #category : #initialization }
MiTagBuilderForm >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : #initialization }
MiTagBuilderForm >> submit [

	| strategy tags |
	strategy := currentStrategy new
		            property: propertyInput text;
		            comparator: #<=;
		            bounds: boundsDroplist selectedItem.
		
	tags := strategy buildTags.
	tagModel addTagsFromTagBuilder: tags.
	owner closeTagBuilderForm
]

{ #category : #private }
MiTagBuilderForm >> updateCategories [

	categorySelection items: { nil }, tagModel allCategories
]
