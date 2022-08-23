"
I am a presenter to show all installed MooseModels and a code preview of how they can be used in the playground.
By clicking OK, user can add this code to the playground.
"
Class {
	#name : #MiPlaygroundModelsPresenter,
	#superclass : #StPresenter,
	#instVars : [
		'modelsList',
		'codePreview',
		'modelsPanel',
		'previewPanel'
	],
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #specs }
MiPlaygroundModelsPresenter class >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 30 percent;
		  add: #modelsPanel;
		  add: #previewPanel;
		  yourself
]

{ #category : #accessing }
MiPlaygroundModelsPresenter class >> defaultTitle [

	^ 'Add model to playground'
]

{ #category : #code }
MiPlaygroundModelsPresenter >> codeForModel: model [

	^ String streamContents: [ :s | 
		  s
			  << (model name asValidSelector copyWithout: $:);
			  << ' := MooseModel root at: ';
			  << (MooseModel root indexOf: model) asString;
			  << '.' ]
]

{ #category : #code }
MiPlaygroundModelsPresenter >> codeToAdd [

	^ codePreview text
]

{ #category : #initialization }
MiPlaygroundModelsPresenter >> initializePresenters [

	modelsPanel := (self instantiate: StHeaderPanel) label: 'Models'.
	modelsList := self newList
		              items: MooseModel root entities;
		              display: #name;
		              whenSelectedDo: [ :model | 
			              codePreview text: (self codeForModel: model) ].
	modelsPanel presenter: modelsList.

	previewPanel := (self instantiate: StHeaderPanel) label: 'Preview'.
	codePreview := self newCode beForScripting beNotEditable
		               withoutLineNumbers.
	previewPanel presenter: codePreview.

	self selectFirstModel
]

{ #category : #initialization }
MiPlaygroundModelsPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self class defaultTitle
]

{ #category : #initialization }
MiPlaygroundModelsPresenter >> selectFirstModel [

	MooseModel root entities ifNotEmpty: [ :models | 
		modelsList selectItem: models first ]
]
