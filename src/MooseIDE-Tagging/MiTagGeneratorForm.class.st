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
		'itemChooser'
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
	
	uniqueTagButton action: [ self setCBSingleTagForm ].
	multipleTagsButton action: [ self setCBMultipleTagsForm ].
	gradualTagsButton action: [ self setCBGraduatedTagsForm ].
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
	currentStrategy := CBOneTagGenerationStrategy
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
MiTagGeneratorForm >> setCBGraduatedTagsForm [

	currentStrategy = CBGraduatedTagsGenerationStrategy ifTrue: [ 
		gradualTagsButton state: true.
		^ self ].
	currentStrategy := CBGraduatedTagsGenerationStrategy.
	self putAllButtonsStateToFalseExcept: gradualTagsButton.
	self update
]

{ #category : #initialization }
MiTagGeneratorForm >> setCBMultipleTagsForm [

	currentStrategy = CBMultipleTagsGenerationStrategy ifTrue: [ 
		multipleTagsButton state: true.
		^ self ].
	currentStrategy := CBMultipleTagsGenerationStrategy.
	self putAllButtonsStateToFalseExcept: multipleTagsButton.
	self update
]

{ #category : #initialization }
MiTagGeneratorForm >> setCBSingleTagForm [

	currentStrategy = CBOneTagGenerationStrategy ifTrue: [ 
		uniqueTagButton state: true.
		^ self ].
	currentStrategy := CBOneTagGenerationStrategy.
	self putAllButtonsStateToFalseExcept: uniqueTagButton.
	self update
]

{ #category : #initialization }
MiTagGeneratorForm >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : #initialization }
MiTagGeneratorForm >> setSourceItems: aCollection [
	itemChooser
		sourceItems: aCollection
		
]

{ #category : #initialization }
MiTagGeneratorForm >> submit [

	| strategy tags |
	strategy := currentStrategy new
		            category: categorySelection selectedItem.
		
	tags := strategy generateTags: itemChooser chosenItems.
	tags do: [ :tag | owner model addDynamicTag: tag ].
	self owner closeTagGeneratorForm
		
	
]

{ #category : #private }
MiTagGeneratorForm >> updateCategories [

	categorySelection items: { nil }, tagModel allCategories
]