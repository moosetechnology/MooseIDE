"
I am a presenter that compiles a query according to a code input
"
Class {
	#name : 'MiManualQueryPresenter',
	#superclass : 'MiQueryConfiguratorPresenter',
	#instVars : [
		'parentQuery',
		'queryCoder',
		'collectQueryButton',
		'selectQueryButton',
		'editScriptButton',
		'scriptLabel'
	],
	#category : 'MooseIDE-QueriesBrowser-Configuration presenters',
	#package : 'MooseIDE-QueriesBrowser',
	#tag : 'Configuration presenters'
}

{ #category : 'compiling' }
MiManualQueryPresenter >> compileQuery [

	query := queryCoder compiledQuery.
	query beChildOf: parentQuery.
	self notifyQueryChanged
]

{ #category : 'api - actions' }
MiManualQueryPresenter >> configureFor: aQuery [

	query := aQuery
]

{ #category : 'actions' }
MiManualQueryPresenter >> configureQuery: aQuery [

	query := aQuery
]

{ #category : 'initialization' }
MiManualQueryPresenter >> initializeButton [

	editScriptButton := self newButton.
	editScriptButton
		label: 'Edit script';
		icon: (self iconNamed: #edit);
		action: [
				owner owner selectItem: owner.
				self openQueryCoderPopup ]
]

{ #category : 'initialization' }
MiManualQueryPresenter >> initializePresenters [

	self initializeRadioButtons.
	self initializeScriptLabel.
	self initializeButton.
	self initializeQueryCoder.
	self initializeLayout
]

{ #category : 'initialization' }
MiManualQueryPresenter >> initializeQueryCoder [

	queryCoder := self instantiate: QueryCompilerPresenter on: self.
]

{ #category : 'as yet unclassified' }
MiManualQueryPresenter >> initializeRadioButtons [

	collectQueryButton := self newRadioButton
		                      addStyle: #smallRadioButton;
		                      label: 'Collect';
		                      whenActivatedDo: [
			                      self computeQueryAction: query beCollect ];
		                      yourself.
	selectQueryButton := self newRadioButton
		                     addStyle: #smallRadioButton;
		                     label: 'Select';
		                     whenActivatedDo: [
			                     self computeQueryAction: query beSelect ];
		                     yourself.
	^ collectQueryButton associatedRadioButtons: { selectQueryButton }
]

{ #category : 'as yet unclassified' }
MiManualQueryPresenter >> initializeScriptLabel [

	^ scriptLabel := self newLabel
		                     label: '[ :mooseEntity | "Your code here" ]';
		                     yourself
]

{ #category : 'layout' }
MiManualQueryPresenter >> newLayout [

	^ self newBoxLayoutLeftToRight
		  vAlignCenter;
		  spacing: 5;
		  add: collectQueryButton expand: false;
		  add: selectQueryButton expand: false;
		  add: scriptLabel;
		  add: editScriptButton expand: false;
		  yourself
]

{ #category : 'actions' }
MiManualQueryPresenter >> openQueryCoderPopup [

	self newPopover
		relativeTo: editScriptButton;
		bePositionBottom;
		presenter: queryCoder;
		popup;
		whenClosedDo: [ queryCoder updateConfigurationPresenter ].
	queryCoder selectBlockBehavior
]

{ #category : 'updating' }
MiManualQueryPresenter >> updateLabel: aString [

	scriptLabel label: aString
]
