"
I am a subclass of `StObjectContextPresenter`.

I force my initialization to be without the evaluator (the code presenter in the below part of the inspector). This is because in `MiInspectorBrowser` the evaluator is not wanted in any case.
"
Class {
	#name : #MiObjectContextPresenter,
	#superclass : #StObjectContextPresenter,
	#instVars : [
		'actionBar'
	],
	#category : #'MooseIDE-NewTools-Inspector'
}

{ #category : #initialization }
MiObjectContextPresenter >> initializePresenters [

	view := self model newInspectionView.
	self intializePresentersWithBetterEvaluator
]

{ #category : #initialization }
MiObjectContextPresenter >> intializePresentersWithBetterEvaluator [

	| mainLayout toogled |
	toogled := false.
	mainLayout := SpBoxLayout newTopToBottom.

	actionBar := self newActionBar add: (self newButton
			              label: 'Script';
			              icon: (self iconNamed: #arrowDoubleUp);
			              help: 'Open script area.';
			              action: [ 
				              toogled
					              ifTrue: [ 
						              toogled := false.
						              mainLayout remove: evaluator ]
					              ifFalse: [ 
						              toogled := true.
						              mainLayout add: evaluator ] ];
			              yourself).

	(evaluator := self newCode)
		beForObject: self model inspectedObject;
		text: self evaluatorInitialText;
		overridingContextMenu;
		contextMenu: [ (self menuActionsFor: evaluator) asMenuPresenter ];
		contextKeyBindings: (self menuActionsFor: evaluator) asKMCategory;
		whenTextChangedDo: [ :aString | self model codeSnippet: aString ].
	mainLayout
		add: view;
		add: actionBar
		expand: false
		fill: false
		padding: 0;
		yourself.
	self layout: mainLayout
]
