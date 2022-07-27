Class {
	#name : #MiTagGeneratorForm,
	#superclass : #MiPresenter,
	#instVars : [
		'submitButton',
		'cancelButton',
		'categorySelection',
		'multipleTagsButton',
		'tagModel',
		'currentStrategy',
		'gradualTagsButton',
		'uniqueTagButton',
		'itemChooser',
		'tagClass'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #actions }
MiTagGeneratorForm >> cancel [

	self reset.
	self owner closeTagGeneratorForm
]

{ #category : #initialization }
MiTagGeneratorForm >> connectPresenters [
	
	uniqueTagButton action: [ self setSingleTagForm ].
	multipleTagsButton action: [ self setMultipleTagsForm ].
	gradualTagsButton action: [ self setGradualTagsForm ].
	cancelButton action: [ self cancel ].
	submitButton action: [ self submit ]
]

{ #category : #accessing }
MiTagGeneratorForm >> currentStrategy [

	^ currentStrategy
]

{ #category : #initialization }
MiTagGeneratorForm >> formTitle [

	^ 'Generate tags'
]

{ #category : #initialization }
MiTagGeneratorForm >> initialize [

	super initialize.
	currentStrategy := OneTagGenerationStrategy
]

{ #category : #initialization }
MiTagGeneratorForm >> initializeLayout [

	| headerLayout mainLayout |
	self layout: (SpBoxLayout newTopToBottom spacing: 5).

	headerLayout := SpBoxLayout newLeftToRight
		                add: self formTitle asPresenter;
		                hAlignCenter;
		                yourself.

	mainLayout := SpBoxLayout newTopToBottom
		              spacing: 4;
		              add: (SpBoxLayout newLeftToRight
				               add: uniqueTagButton;
				               add: multipleTagsButton;
				               add: gradualTagsButton;
				               yourself)
		              expand: false;
		              add: (SpBoxLayout newTopToBottom
				               add: 'Category (optional)';
				               add: categorySelection;
				               yourself)
		              expand: false;
		              add: itemChooser expand: true fill: true;
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

	itemChooser := SpChooserPresenter
		               sourceItems: {  }
		               chosenItems: {  }
		               displayBlock: [ :each | each name ].
	submitButton := self newButton
		                label: 'Add';
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

	uniqueTagButton := self newToggleButton
		                   state: true;
		                   label: 'Unique tag';
		                   yourself.
	multipleTagsButton := self newToggleButton
		                      state: false;
		                      label: 'Multiple tags';
		                      yourself.
	gradualTagsButton := self newToggleButton
		                     state: false;
		                     label: 'Gradual tags';
		                     yourself.
	submitButton := self newButton
		                label: 'Generate';
		                yourself.
	cancelButton := self newButton
		                label: 'Cancel';
		                yourself.

	self initializeLayout
]

{ #category : #accessing }
MiTagGeneratorForm >> itemChooser [

	^ itemChooser
]

{ #category : #'as yet unclassified' }
MiTagGeneratorForm >> putAllButtonsStateToFalseExcept: aButton [
	| buttons |
	buttons := { uniqueTagButton. multipleTagsButton. gradualTagsButton } asOrderedCollection.
	buttons remove: aButton ifAbsent: [  ].
	buttons do: [ :button | button state: false ]
]

{ #category : #initialization }
MiTagGeneratorForm >> reset [

	categorySelection resetSelection.
	itemChooser sourceItems: {  }.
	itemChooser targetList items: {  }.
]

{ #category : #initialization }
MiTagGeneratorForm >> setGradualTagsForm [

	currentStrategy = GradualTagsGenerationStrategy ifTrue: [ 
		gradualTagsButton state: true.
		^ self ].
	currentStrategy := GradualTagsGenerationStrategy.
	self putAllButtonsStateToFalseExcept: gradualTagsButton.
	self update
]

{ #category : #initialization }
MiTagGeneratorForm >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : #initialization }
MiTagGeneratorForm >> setMultipleTagsForm [

	currentStrategy = MultipleTagsGenerationStrategy ifTrue: [ 
		multipleTagsButton state: true.
		^ self ].
	currentStrategy := MultipleTagsGenerationStrategy.
	self putAllButtonsStateToFalseExcept: multipleTagsButton.
	self update
]

{ #category : #initialization }
MiTagGeneratorForm >> setSingleTagForm [

	currentStrategy = OneTagGenerationStrategy ifTrue: [ 
		uniqueTagButton state: true.
		^ self ].
	currentStrategy := OneTagGenerationStrategy.
	self putAllButtonsStateToFalseExcept: uniqueTagButton.
	self update
]

{ #category : #initialization }
MiTagGeneratorForm >> setSourceItems: aCollection [
	itemChooser
		sourceItems: aCollection
		
]

{ #category : #initialization }
MiTagGeneratorForm >> setTagClass: aClass [
"set the class to give to the generating strategy"
	tagClass := aClass.
]

{ #category : #initialization }
MiTagGeneratorForm >> submit [

	| strategy tags |
	strategy := currentStrategy new
		            category: categorySelection selectedItem;
						tagClass: tagClass;
						entities: owner model entities.
		
	tags := strategy generateTags: itemChooser chosenItems.
	tags do: [ :tag | owner model addDynamicTag: tag ].
	self owner closeTagGeneratorForm
		
	
]

{ #category : #private }
MiTagGeneratorForm >> updateCategories [

	categorySelection items: { nil }, tagModel allCategories
]
