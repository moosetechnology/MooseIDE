Class {
	#name : #MiTagGeneratorForm,
	#superclass : #MiPresenter,
	#instVars : [
		'submitButton',
		'cancelButton',
		'nameField',
		'categorySelection',
		'descriptionField',
		'multipleTagsButton',
		'conditionList',
		'tagModel',
		'currentStrategy',
		'gradualTagsButton',
		'uniqueTagButton'
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

{ #category : #brokerage }
MiTagGeneratorForm >> consume: aCondition [
	
	self updateConditionsList

	
]

{ #category : #accessing }
MiTagGeneratorForm >> currentStrategy [

	^ currentStrategy
]

{ #category : #'as yet unclassified' }
MiTagGeneratorForm >> fetchConditions [

	^ (self owner application itemsFor: FamixCBCondition) asOrderedCollection
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
	| sep headerLayout formLayout mainLayout conditionListWidth |
	self layout: (SpBoxLayout newTopToBottom spacing: 5).
	conditionListWidth := 240.
	(sep := SpRoassalPresenter new) canvas color: (Color
			 r: 40
			 g: 40
			 b: 40
			 range: 255) translucent.
	
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

	mainLayout := SpBoxLayout newLeftToRight
							spacing: 10;
							add: conditionList width: conditionListWidth;
							add: sep width: 2;
							add: (SpBoxLayout newTopToBottom
				               spacing: 4;
				               add: (SpBoxLayout newLeftToRight
						                add: uniqueTagButton;
						                add: multipleTagsButton;
											add: gradualTagsButton; 
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
				               yourself);
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
	
	conditionList := self newList
		             display: [ :cond | cond name ] yourself.
	
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
		
	self initializeLayout.
	self updateConditionsList
]

{ #category : #'as yet unclassified' }
MiTagGeneratorForm >> putAllButtonsStateToFalseExcept: aButton [
	| buttons |
	buttons := { uniqueTagButton. multipleTagsButton. gradualTagsButton } asOrderedCollection.
	buttons remove: aButton ifAbsent: [  ].
	buttons do: [ :button | button state: false ]
]

{ #category : #brokerage }
MiTagGeneratorForm >> remove: aCondition [
	
	self updateConditionsList

	
]

{ #category : #initialization }
MiTagGeneratorForm >> reset [

	nameField text: ''.
	descriptionField text: ''.
	categorySelection resetSelection
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
MiTagGeneratorForm >> submit [

	| strategy tags |
	strategy := currentStrategy new
		            name: nameField text;
		            description: descriptionField text;
		            category: categorySelection selectedItem.
		
	tags := strategy generateTags: conditionList items.
	tags do: [ :tag | owner model addDynamicTag: tag ].
	self owner closeTagGeneratorForm
		
	
]

{ #category : #brokerage }
MiTagGeneratorForm >> update: aCondition [
	
	self updateConditionsList

	
]

{ #category : #private }
MiTagGeneratorForm >> updateCategories [

	categorySelection items: { nil }, tagModel allCategories
]

{ #category : #accessing }
MiTagGeneratorForm >> updateConditionsList [

	conditionList items: self fetchConditions
]
